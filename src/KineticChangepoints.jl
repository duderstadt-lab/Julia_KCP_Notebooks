using Roots

function pfunc(p, T, confidenceLevel)
    ((p * p)/2.) * exp(-(p * p)/2.) * (T - (2. * T)/(p * p) + 4./(p * p)) + confidenceLevel - 1.0
end

function confidenceThreshold(xlength, confidenceLevel)
    num1 = log(xlength)
    num2 = num1^1.5
    h = num2/xlength
    T = log((1.0-h * h)/(h * h))
    curriedp(p) = pfunc(p, T, confidenceLevel)
    root = fzero(curriedp, 2, 7)
    return root
end

function olsfit(xdata, ydata, xoffset, xlength)
    xsumsquares = 0.0
    xsum = 0.0
    ysum = 0.0
    xysum = 0.0
    for i in xoffset:(xoffset + xlength - 1)
        xsumsquares += xdata[i]*xdata[i]
        xsum += xdata[i]
        ysum += ydata[i]
        xysum += xdata[i]*ydata[i]
    end
    delta = xlength * xsumsquares-xsum*xsum
    A = (xsumsquares*ysum-xsum*xysum)/delta
    B = (xlength*xysum-xsum*ysum)/delta
    return [A, B]
end

function olsfit_ll(xdata, ydata, xoffset, xlength, sigma)
    xsumsquares = 0.0::Float64
    xsum = 0.0::Float64
    ysum = 0.0::Float64
    xysum = 0.0::Float64
    for i in xoffset:(xoffset + xlength - 1)
        xsumsquares += xdata[i]*xdata[i]
        xsum += xdata[i]
        ysum += ydata[i]
        xysum += xdata[i]*ydata[i]
    end
    delta = xlength * xsumsquares-xsum*xsum
    A = (xsumsquares*ysum-xsum*xysum)/delta
    B = (xlength*xysum-xsum*ysum)/delta
    linesum = 0.0::Float64
    for i in xoffset:(xoffset + xlength - 1)
        linesum += (ydata[i] - B*xdata[i] - A) * (ydata[i] - B*xdata[i] - A)
    end
    return xlength * log(1.0/sigma * sqrt(2*pi)) - linesum/(2*sigma*sigma)
end

function changepoint(inputarray, xoffset, xlength, sigma, confidenceLevel)
    xdata = view(inputarray, : , 1)
    ydata = view(inputarray, : , 2)
    llnull = olsfit_ll(xdata, ydata, xoffset, xlength, sigma)
    llr_max = 0.0::Float64
    llr_max_position = -1
    for w in 2:(xlength - 3)
        segA_ll = olsfit_ll(xdata, ydata, xoffset, w, sigma)
        segB_ll = olsfit_ll(xdata, ydata, xoffset + w, xlength - w, sigma) 
        ll_ratio = segA_ll + segB_ll -  llnull
        if (ll_ratio > llr_max)
            llr_max = ll_ratio
            llr_max_position = xoffset + w
        end
    end	
    if sqrt(2*llr_max) > confidenceThreshold(xlength, confidenceLevel)
        return llr_max_position
    else
        return -1
    end
end

function binary_search(inputarray, xoffset, xlength, sigma, confidenceLevel)
    cp_positions = [xoffset, xoffset + xlength - 1]
    q = 1
    while q < length(cp_positions)
        cp = changepoint(inputarray, cp_positions[q], cp_positions[q + 1] - cp_positions[q], sigma, confidenceLevel)
        if (cp != -1)
            insert!(cp_positions, q + 1, cp)
        else
            q += 1
        end
    end

    q = 1
    if length(cp_positions) > 3
        while q < (length(cp_positions) - 1)
            cp = changepoint(inputarray, cp_positions[q], cp_positions[q + 2] - cp_positions[q], sigma, confidenceLevel)
            deleteat!(cp_positions, q + 1)
            if (cp != -1)
                insert!(cp_positions, q + 1, cp)
                q += 1
            end
        end
    end	
    return cp_positions
end

function startendtable(resultsarray)
    current_traj = resultsarray[1,3]
    trajlist = [resultsarray[1,3]]
    startlist = [1]
    for i in 1:length(resultsarray[:,3])
        if resultsarray[i,3] != current_traj
            current_traj = resultsarray[i,3]
            append!(trajlist, current_traj)
            append!(startlist, i)
        end
    end
    lengthlist = []
    for i in 1:(length(startlist) - 1)
        append!(lengthlist, startlist[i + 1] - startlist[i])
    end
    append!(lengthlist, length(resultsarray[:,3]) - startlist[end] + 1)
    return [trajlist startlist lengthlist]
end


function batch_table(inputarray, sigma, confidenceLevel)
    resultsarray = view(inputarray, :, :)
    offsetslengths = startendtable(resultsarray)
    cp_table = []
    for i in 1:length(offsetslengths[:,1])
        append!(cp_table, binary_search(resultsarray, offsetslengths[i,2], offsetslengths[i,3], sigma, confidenceLevel))
    end
    i1_table = []
    i2_table = []
    x1_table = []
    x2_table = []
    y1_table = []
    y2_table = []
    t_table = []
    A_table = []
    B_table = []
    for i in 1:length(cp_table) - 1
        if (cp_table[i + 1] - cp_table[i]) > 2
            Atemp, Btemp = olsfit(view(resultsarray, :, 1), view(resultsarray, :, 2), cp_table[i], cp_table[i + 1] - cp_table[i])
            append!(i1_table, Int(cp_table[i]))
            append!(i2_table, Int(cp_table[i + 1]))
            append!(x1_table, resultsarray[cp_table[i],1])
            append!(x2_table, resultsarray[cp_table[i + 1],1])
            append!(t_table, Int(resultsarray[cp_table[i + 1],3]))
            append!(y1_table, Atemp + resultsarray[cp_table[i],1]*Btemp)
            append!(y2_table, Atemp + resultsarray[cp_table[i + 1],1]*Btemp)
            append!(A_table, Atemp)
            append!(B_table, Btemp)
        end
    end
    duration = x2_table .- x1_table
    lengthtable = y2_table .- y1_table
    segtable = [t_table i1_table i2_table x1_table y1_table x2_table y2_table A_table B_table duration lengthtable]
	colnames = ["trajectory" "X_index1" "x_index2" "x1" "y1" "x2" "y2" "A" "B" "duration" "length"]
	return vcat(colnames, segtable)
end


function convert_array(dataframe, timenucleotidestrajectory = [1, 2, 3])
    if eltype(dataframe[1]) == Char
        dataframe = dataframe[2:end,:]
    end
    timecolumn = dataframe[:,timenucleotidestrajectory[1]]*1.0
    ntcolumn = dataframe[:,timenucleotidestrajectory[2]]*1.0
    trajectorycolumn = dataframe[:,timenucleotidestrajectory[3]]*1.0
return [timecolumn ntcolumn trajectorycolumn]
end


function getchangepoints(inputfile, outputfilename, sigma, confidenceLevel, sep = ',', columnorder = [1,2,3])
    inputarray = readdlm(inputfile, sep)
    testarray = convert_array(inputarray, columnorder)
    outputarray = batch_table(testarray, sigma, confidenceLevel)
    writecsv(outputfilename, outputarray)
    return outputarray
end
