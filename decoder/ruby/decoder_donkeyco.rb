def run()
   bitarr = get_bitstring().split("").map{ |s| s.to_i }
   pararr = calc_par(bitarr)
   checkarr = check_par(bitarr, pararr)
   correct_bit(bitarr, checkarr)
   decoded = reduce_arr(bitarr, checkarr.length)
   print_arr(decoded)
end

def get_bitstring()
    bitstring = ARGV[0]
    unless ARGV[0]
        bitstring = "00011110000"
        puts "No bitstring provided. Defaulting to decoding 00011110000..."
    end
    return bitstring
end

def get_parcount(bitarr)
    max = 1
    while 2**(max) < bitarr.length
        max = max + 1  
    end
    return max
end

def init_arr(max)
    pararr = Array.new(max)
    c = 0
    while c < pararr.length
        pararr[c] = Array.new()
        c = c + 1 
    end
    return pararr
end

def calc_par(bitarr)
    parcount = get_parcount(bitarr)
    pararr = init_arr(parcount)
    counter = 0
    while counter <= bitarr.length
        bcounter = 0
        while bcounter < parcount
            bitpos = counter >> bcounter
            if (bitpos.to_i % 2) == 1
                pararr[bcounter].push(counter)
            end
            bcounter = bcounter + 1
        end
        counter = counter + 1
    end
    return pararr
end

def check_par(bitarr, pararr)
    arr = Array.new(pararr.length, 0)
    c = 0
    while c < (pararr.length - 1)
        for i in pararr[c]
            arr[c] = (arr[c] + bitarr[i-1]) % 2
        end
        c = c + 1
    end
    return arr
end

def correct_bit(bitarr, checkarr)
    if (checkarr.inject(0, :+) % 2) == 1
        count = 0
        pos = 0
        while count <= checkarr.length
            pos = pos + count * checkarr[count]
            count = count + 1
        end
        checkarr[pos] = (checkarr[pos] - 1).abs
    end
end

def reduce_arr(bitarr, ccount)
    count = 0
    arr = Array.new(ccount, 0)
    while count < ccount
        arr[count] = 2**count - 1
        count = count + 1
    end

    count = 0
    decoded = Array.new()
    while count < bitarr.length
        if !(arr.include? count)
            decoded.push(bitarr[count])
        end
        count = count + 1
    end
    return decoded
end

def print_arr(bitarr)
    print "Decoded Bits: "
    for bit in bitarr
        print bit
    end
end

run() 