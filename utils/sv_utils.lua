zFw["Utils"] = {}

zFw["Utils"].GetValueInTable = function(table, want, cb)
    for k, v in pairs(table) do 
        if want == v then 
           cb(v)
        end 
        cb(false)
    end 
end

zFw["Utils"].ConvertToBool = function(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end


zFw["Utils"].Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

zFw["Utils"].ConvertToBool = function(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end

zFw["Utils"].RequestLicense = function(identifer, license)
    for k, v in ipairs(GetPlayerIdentifiers(identifer)) do 
        if string.match(v, license..':') then
          return v
        end 
    end
end

zFw["Utils"].GenerateRandomNumber = function()
    return math.random(1111111, 9999999) .. "-" .. math.random(1111111, 9999999)  .. "-" .. math.random(1111111, 9999999) .. "-" .. math.random(1111111, 9999999) 
end