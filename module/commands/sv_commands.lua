Commands = {}

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
    local plyTarget = Admin.ESX.GetPlayerFromUUID(plyTarget)
    local reason = table.concat(args, " ", 2)

    TriggerClientEvent("admin:asyncChat", plyTarget.source, plySource, reason)
end, {"Moderator", "Owner", "Supervisor"})

Commands.Register("freeze", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        local plyDb = Admin.ESX.GetPlayerFromUUID(plyTarget)

        TriggerClientEvent('chatMessage', source, "^1MZPVP | ^7Vous avez freeze le joueur ^8^*" .. GetPlayerName(tPlayer.source))
        TriggerClientEvent('chatMessage', plyDb.source, "^1MZPVP | ^7Vous avez été freeze par ^8^*" .. GetPlayerName(source))
        TriggerClientEvent("kFw:freezeEntityPlayer", plyDb.source)
    end 
end, {"Moderator", "Owner", "Supervisor"})

Commands.Register("dv", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        TriggerClientEvent("admin:deleteEntities", plySource, tonumber(plyTarget))
    else
        TriggerClientEvent("admin:deleteEntities", plySource, tonumber(1))
    end
end, {"Moderator", "Owner", "Supervisor"})

Commands.Register("unban", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = args[1]

    if plyTarget then 
        Bans:DeleteWithId(plyTarget)
    end
end, {"Owner", "Supervisor"})


Commands.Register("kick", function(source, args, rawCommand)
    local plySource = source
    local plyTarget = Admin.ESX.GetPlayerFromUUID(args[1])
    local reason = table.concat(args, " ", 2)

    TriggerClientEvent('chatMessage', plyDb.source, "MZ PVP: "..GetPlayerName(plyTarget.source).." was kicked from the server for: "..reason)
    DropPlayer(plyTarget.source, reason)
end, {"Moderator", "Owner", "Supervisor"})

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
end, {"Moderator", "Owner", "Supervisor"})