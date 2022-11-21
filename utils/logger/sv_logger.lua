function zFw:Logger(type, message)
    if type then print("^4[Kernioz] ^0[" .. zFw["Utils"].Round(os.clock(), 0) .. "ms] [" .. type .. "] " .. message) return end 
    print("^4[Kernioz] ^0[" .. zFw["Utils"].Round(os.clock(), 0) .. "ms] " .. message)
end