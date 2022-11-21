Discord = Discord or {}
Discord.API = {}

function Discord.API:Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function Discord.API:Logger(type, message)
    if type then print("^4[Kernioz] ^0[" .. Discord.API:Round(os.clock(), 0) .. "ms] [" .. type .. "] " .. message) return end 
    print("^4[Kernioz] ^0[" .. Discord.API:Round(os.clock(), 0) .. "ms] " .. message)
end

function Discord.API:CheckInTable(tbl, item)
    for key, value in pairs(tbl) do 
        if value == item then return value end 
    end 
    return false
end 

function Discord.API:CheckInTableRole(tbl, item)
    for key, value in pairs(tbl) do 
        if value.id == item then return value end 
    end 
    return false
end 

function Discord.API:CallMethod(method, cb)
    local token = zFw["Config"].Discord.Token
    PerformHttpRequest("https://discord.com/api/v10/" .. method, function(err, text, headers)
        if err ~= 200 then self:Logger("Discord API", "Error when API was called") return end 
        cb(err, json.decode(text))
    end,  'GET', '', { ["authorization"] = 'Bot ' .. token})
end 

function Discord.API:requestSpecificRoleFromMember(member, role, cb)
    local guild = zFw["Config"].Discord.Guild
    if member == nil then self:Logger("Discord API", "Arg that calls the member couldn't be found") return end 
    if role == nil then self:Logger("Discord API", "Arg that calls member roles couldn't be found") return end 
    Discord.API:CallMethod("guilds/" .. guild .."/members/" .. member, function(err, result)
        if err == 404 then self:Logger(nil, "User '" .. member .. "' isn't on Discord") return end 
        local roleHasBeenFound = Discord.API:CheckInTable(result["roles"], role)
        if cb and roleHasBeenFound then 
            local usernameInformation = result["user"]["username"] .. "#" .. result["user"]["discriminator"] .. "(" .. member .. ")"
            self:Logger(nil, "User '" .. usernameInformation .. "' has been found as  " .. ("Unknown") .. " on Discord")
            cb(true, result)
        elseif roleHasBeenFound then
            local usernameInformation = result["user"]["username"] .. "#" .. result["user"]["discriminator"] .. "(" .. member .. ")"
            self:Logger(nil, "User '" .. usernameInformation .. "' has been found as  " .. ("Unknown") .. " on Discord")
            return true, result
        end
    end)
end

function Discord.API:requestAnyRoleFromMember(member, cb)
    local guild = zFw["Config"].Discord.Guild
    
    if member == nil then self:Logger("Discord API", "Arg that calls the member couldn't be found") return end
    Discord.API:CallMethod("guilds/" .. guild .. "/members/" .. member, function(err, result)
        if err == 404 then self:Logger("Discord API", "User '" .. member .. "' isn't on Discord") return end 
        if cb then 
            cb(result["roles"])
        else
            return result["roles"]
        end 
    end)
end

function Discord.API:requestAnyInformationFromMember(member, cb)
    local guild = zFw["Config"].Discord.Guild
    if member == nil then self:Logger("Discord API", "Arg that calls the member couldn't be found") return end
    Discord.API:CallMethod("guilds/" .. guild .. "/members/" .. member, function(err, result)
        if err == 404 then self:Logger("Discord API", "User '" .. member .. "' isn't on Discord") return end 
        if cb then 
            cb(result)
        else
            return result
        end 
    end)
end

function Discord.API:RequestUserIsPresent(member, cb)
    local guild = zFw["Config"].Discord.Guild
    if guild == nil then self:Logger("Discord API", "Arg that calls the guild couldn't be found") os.exit() end 
    Discord.API:CallMethod("guilds/"..guild.."/members/"..member, function(err, result)
        if cb then 
            cb(result)
        else
            return result
        end 
    end)
end

function Discord.API:requestAnyRolesFromGuild()
    local guild = zFw["Config"].Discord.Guild
    if guild == nil then self:Logger("Discord API", "Arg that calls the guild couldn't be found") os.exit() end 
    Discord.API:CallMethod("guilds/" .. guild .. "/roles", function(err, result)
        return result
    end)
end

function Discord.API:Load()
    local token = zFw["Config"].Discord.Token
    local guild = zFw["Config"].Discord.Guild

    if token == "" or not guild then 
        self:Logger("Discord API", "Arg that calls the token or guild couldn't be found") os.exit()
    else
        self:Logger("Discord API", "Discord has been loaded!")
    end 
end
