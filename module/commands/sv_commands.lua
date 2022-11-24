RegisterCommand("inserttebex", function(s,a,r)
    if s == 0 then 
        local tebexId = a[1]
        local tebexInfo = a[2]
        local tebexInfo = a[3]
        
        MySQL.Async.execute("INSERT INTO payements_tebex(tebexId, tebexInfo, tebexAmount, claimed) VALUES(@tebexId, @tebexInfo, @claimed)", {
            ["@tebexId"] = tebexId,
            ["@tebexInfo"] = tebexInfo,
            ["@tebexAmount"] = tebexAmount,
            ["@claimed"] = 0,
        })
    end
end, false)

Commands.Register("mp", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = Admin.ESX.GetPlayerFromUUID(args[1])
    local reason = table.concat(args, " ", 2)

    TriggerClientEvent("admin:asyncChat", plyTarget.source, plySource, reason)
end, {"mod", "admin", "superadmin"})

Commands.Register("freezed", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        local plyDb = Admin.ESX.GetPlayerFromUUID(plyTarget)

        TriggerClientEvent('chatMessage', source, "^1MZPVP | ^7Vous avez freeze le joueur ^8^*" .. GetPlayerName(tPlayer.source))
        TriggerClientEvent('chatMessage', plyDb.source, "^1MZPVP | ^7Vous avez été freeze par ^8^*" .. GetPlayerName(source))
        TriggerClientEvent("kFw:freezeEntityPlayer", plyDb.source)
    end 
end, {"admin", "mod", "superadmin"})

Commands.Register("dv", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        TriggerClientEvent("admin:deleteEntities", plySource, tonumber(plyTarget))
    else
        TriggerClientEvent("admin:deleteEntities", plySource, tonumber(1))
    end
end, {"mod", "admin", "superadmin"})

Commands.Register("unban", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        Bans:DeleteWithId(plyTarget)
    end
end, {"superadmin", "admin"})


Commands.Register("kickuuid", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = Admin.ESX.GetPlayerFromUUID(args[1])
    local reason = table.concat(args, " ", 2)

    TriggerClientEvent('chatMessage', plyDb.source, "MZ PVP: "..GetPlayerName(plyTarget.source).." was kicked from the server for: "..reason)
    DropPlayer(plyTarget.source, reason)
end, {"mod", "admin", "superadmin"})

local function TimeRemaining(seconds)
    local days = seconds / 86400
    local hours = (days - math.floor(days)) * 24
    local minutes = (hours - math.floor(hours)) * 60
    seconds = (minutes - math.floor(minutes)) * 60
    return ('%s jours %s heures %s minutes %s secondes'):format(math.floor(days), math.floor(hours), math.floor(minutes), math.floor(seconds))
end

Commands.Register("banuuid", function(source, args, rawCommand)
    local licenseid, playerip, tokens = 'N/A', 'N/A', {}
    local target = tonumber(args[1])
    local expiration = tonumber(args[2])
    local reason = table.concat(args, ' ', 3)

    if target and target > 0 then
        local targetDb = Admin.ESX.GetPlayerFromUUID(target)
        local sourceName = GetPlayerName(source)
        local targetName = GetPlayerName(targetDb.source)
        if targetName then
            if expiration and expiration <= 336 then
                licenseid = zFw["Utils"].RequestLicense(targetDb.source, "license")

                for e = 0, GetNumPlayerTokens(targetDb.source) do
                    table.insert(tokens, GetPlayerToken(targetDb.source, e))
                end

                if not licenseid then
                    licenseid = 'N/A'
                end

                if reason == '' then
                    reason = "Aucune raison"
                end

                if expiration > 0 then
                    Bans:Add(source, licenseid, playerip, targetName, sourceName, expiration, reason, 0, tokens)
                    TriggerClientEvent('chatMessage', -1, "MZ PVP: "..targetName.." was kicked from the server for: "..reason)
                    DropPlayer(targetDb.source, ('Vous êtes banni de MZPVP\nRaison : %s\nTemps Restant : %s\nAuteur : %s'):format(reason, TimeRemaining(expiration * 3600), sourceName))
                else
                    Bans:Add(source, licenseid, playerip, targetName, sourceName, expiration, reason, 1, tokens)
                    TriggerClientEvent('chatMessage', -1, "MZ PVP: "..targetName.." was kicked from the server for: "..reason)
                    DropPlayer(targetDb.source, ('Vous êtes banni de MZPVP\nRaison : %s\nTemps Restant : Permanent\nAuteur : %s'):format(reason, sourceName))
                end
            end
        end
    end
end, {"mod", "superadmin", "admin"})

Commands.Register("getinfo", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = Admin.ESX.GetPlayerFromUUID(tonumber(args[1]))
 
    print(plyTarget, args[1])
    if args[2] == "discord" then
        local member = string.sub(zFw["Utils"].RequestLicense(plyTarget.playerId, "discord"), 9, -1)
        PerformHttpRequest("https://discord.com/api/v10/guilds/666775709553000449/members/" .. member, function(err, text, headers)
            if err == 200 then
                local text = json.decode(text)
                TriggerClientEvent("kFw:showNotification", source, "Informations\nID Discord: ~b~"..member.."~s~\nDiscord: ~b~".. text["user"]["username"] .. "#" .. text["user"]["discriminator"] .. "~s~", 2500)
            end
        end, 'GET', '', { ["authorization"] = 'Bot MTAzNzMxODYzMjY2NzA4Njg0OA.GczvHa.vDYjPdTtl_QVlJLNkNHhq1Yk-Y_PgJfZbgaUEU'})  
    elseif args[2] == "license" then
        local rockstar = zFw["Utils"].RequestLicense(plyTarget.playerId, "rockstar")

        TriggerClientEvent("kFw:showNotification", source, "Informations\nLicense: ~b~"..rockstar.."~s~", 2500)
    elseif args[2] == "uuid" then 
        local idPerma = args[1]
  
        TriggerClientEvent("kFw:showNotification", source, "Informations\nUUID: ~b~"..idPerma.."~s~", 2500)
    elseif args[2] == "all" then 
        local member = string.sub(zFw["Utils"].RequestLicense(plyTarget.playerId, "discord"), 9, -1)
        local rockstar = zFw["Utils"].RequestLicense(plyTarget.playerId, "rockstar")

        local idPerma = args[1]
  
        PerformHttpRequest("https://discord.com/api/v9/guilds/666775709553000449/members/" .. member, function(err, text, headers)
            if err == 200 then
                local text = json.decode(text)
                TriggerClientEvent("kFw:showNotification", source, "Informations (~b~".. text["user"]["username"] .. "#" .. text["user"]["discriminator"] .."~s~)\nID Discord: ~b~"..member.."~s~\nLicense: ~b~"..rockstar.."~s~\nUUID: ~b~"..idPerma.."~s~", 2500)
            end
        end, 'GET', '', { ["authorization"] = 'Bot MTAzNzMxODYzMjY2NzA4Njg0OA.GczvHa.vDYjPdTtl_QVlJLNkNHhq1Yk-Y_PgJfZbgaUEU'})
    end

end, {"mod", "superadmin", "admin"})
