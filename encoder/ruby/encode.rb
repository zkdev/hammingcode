#!/usr/bin/env ruby

$logging = false

def log(level, message)
    if $logging
        puts "[#{level}]: #{message}"
    end
end

def init()
    if ARGV.length == 1
        $logging = true
        return ARGV[0].chomp.chars
    else
        return "0110001".chars
    end
end

def _get_no_of_parity_bits(length)
    num = 0
    while 2**num < length + num + 1 do
        num+=1
    end
    log("INFO", "#{num} parity bits will be added.")
    return num
end

def _get_parity_bit_indices(bitstring)
    indices = []
    for i in (1 ... _get_no_of_parity_bits(bitstring.length) + bitstring.length)
        if ((i & (i - 1)) == 0)
            indices.push(i - 1)
            # need to manipulate bitstring here to avoid redundant loops later
            bitstring.insert(i - 1, 0)
        end
    end
    log("INFO", "Parity bits will be added at #{indices.join(", ")}.")
    return indices
end

def valid(bitstring)
    if bitstring.length < 1
        log("ERROR", "The bitstring is empty.")
        return false
    end
    for bit in bitstring
        if bit != '0' && bit != '1'
            log("ERROR", "The bitstring can only consist of 0s and 1s.")
            return false
        end
    end
    log("INFO", "Valid input.")
    return true
end

def _get_parity_value(pos, bitstring, exclude)
    sum = 0
    # indexing assumes to start from so that the bitshift rule can be applied
    for index in (exclude + 2 .. bitstring.length)
        if ((index >> pos) & 1) == 1
            # indexing fixed here for actual use
            sum += bitstring[index - 1].to_i
        end
    end
    log("INFO", "Parity bit at index #{exclude} has the value #{sum % 2}.")
    return (sum % 2).to_s
end

def encode(bitstring)
    result = bitstring[0..-1]
    parity_indices = _get_parity_bit_indices(result)
    pos = 0
    for index in parity_indices
        result[index] = _get_parity_value(pos, result, index)
        pos+=1
    end
    return result
end

if __FILE__ == $0
    bitstring = init()
    if valid(bitstring)
        result = encode(bitstring)
        log("SUCCESS", "The bitstring #{bitstring.join} was successfully encoded to #{result.join}.")
        puts "Result: #{result.join}"
    end
end
