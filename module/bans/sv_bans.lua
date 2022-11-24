Bans = {}

function Bans:Delete(licenseid, cb)
    MySQL.Async.execute("DELETE FROM banlist WHERE licenseid = @licenseid", {
        ["@licenseid"] = licenseid
    }, function()
        if cb then
            cb()
        end
    end)
end

function Bans:DeleteWithId(licenseid, cb)
    MySQL.Async.execute("DELETE FROM banlist WHERE id = @licenseid", {
        ["@licenseid"] = licenseid
    }, function()
        if cb then
            cb()
        end
    end)
end

function Bans:IsBanned(license, cb)
    MySQL.Async.fetchAll("SELECT * FROM banlist WHERE tokens = @licenseid", {
        ["@licenseid"] = json.encode(license)
    }, function(result)
        if #result > 0 then
            cb(true, result[1])
        else
            cb(false, result[1])
        end
    end)
end

function TimeRemaining(seconds)
    local days = seconds / 86400
    local hours = (days - math.floor(days)) * 24
    local minutes = (hours - math.floor(hours)) * 60
    seconds = (minutes - math.floor(minutes)) * 60
    return ('%s jours %s heures %s minutes %s secondes'):format(math.floor(days), math.floor(hours), math.floor(minutes), math.floor(seconds))
end

function Bans:Add(source, licenseid, playerip, targetName, sourceName, time, reason, permanent, tokens)
    time = time * 3600
    local timeat = os.time()
    local expiration = time + timeat
    local tokens = json.encode(tokens)

    MySQL.Async.execute('INSERT INTO banlist (licenseid, playerip, targetName, sourceName, reason, timeat, expiration, permanent, tokens) VALUES (@licenseid, @playerip, @targetName, @sourceName, @reason, @timeat, @expiration, @permanent, @tokens)', {
        ['@licenseid'] = licenseid,
        ['@playerip'] = playerip,
        ['@targetName'] = targetName,
        ['@sourceName'] = sourceName,
        ['@reason'] = reason,
        ['@timeat'] = timeat,
        ['@expiration'] = expiration,
        ['@permanent'] = permanent,
        ['@tokens'] = tokens
    }, function()
        MySQL.Async.execute('INSERT INTO banlisthistory (licenseid, playerip, targetName, sourceName, reason, timeat, expiration, permanent) VALUES (@licenseid, @playerip, @targetName, @sourceName, @reason, @timeat, @expiration, @permanent)', {
            ['@licenseid'] = licenseid,
            ['@playerip'] = playerip,
            ['@targetName'] = targetName,
            ['@sourceName'] = sourceName,
            ['@reason'] = reason,
            ['@timeat'] = timeat,
            ['@expiration'] = expiration,
            ['@permanent'] = permanent
        })

        if permanent == 0 then
            TriggerClientEvent("kFw:showNotification", source, "Vous avez banni ~b~" .. targetName .. "~s~ pendant ~b~" .. TimeRemaining(time) .. "~s~ pour la raison : ~b~" .. reason)
        else
            TriggerClientEvent("kFw:showNotification", source, "Vous avez banni ~b~" .. targetName .. "~s~ pour la raison : ~b~" .. reason)
        end
    end)
end