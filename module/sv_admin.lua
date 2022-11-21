Admin = Admin or {}

Admin.ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("admin:tooLongReplyStaff")
AddEventHandler("admin:tooLongReplyStaff", function(toPlayer) 
    local source = source
    TriggerClientEvent("kFw:showNotification", toPlayer, "~r~Le joueur " .. GetPlayerName(source) .. " n'a pas répondu à votre message (30s)")
end)

RegisterNetEvent("admin:replyToStaff")
AddEventHandler("admin:replyToStaff", function(toPlayer, a) 
    local source = source 
    TriggerClientEvent("kFw:showNotification", toPlayer, "~r~Réponse joueur\n~s~"..a)
end)

AddEventHandler("playerConnecting", function(pName, setKickReason, pDeferals)
    local plySource = source
    local pDiscord, pLicense, pTokens = string.sub(zFw["Utils"].RequestLicense(plySource, "discord"), 9, -1), zFw["Utils"].RequestLicense(plySource, "license"), {}

    pDeferals.update("Identification en cours...")
    Citizen.Wait(5000)
    if (not pDiscord or pDiscord == nil or pDiscord == "") then
        deferrals.done("🚫 Veuillez ouvrir Discord pour vous connecter sur MZ PVP.")
        CancelEvent()
        return
    end


    if GetNumPlayerTokens(plySource) == 0 or GetNumPlayerTokens(plySource) == nil or GetNumPlayerTokens(plySource) < 0 or GetNumPlayerTokens(plySource) == "**Invalid**" or GetNumPlayerTokens(plySource) == "null" or not GetNumPlayerTokens(plySource) then 
        pDeferals.done("🚫 Veuillez redémarrer FiveM (jusqu'à que celui si génére vos jetons)")
        CancelEvent()
        return
    end 


    for i = 0, GetNumPlayerTokens(plySource) do
        table.insert(pTokens, GetPlayerToken(plySource, i))
    end

    Citizen.Wait(5000)
    GM.Bans:IsBanned(pTokens, function(isBanned, banData)
        if isBanned then
            if tonumber(banData.permanent) == 1 then
                pDeferals.done(("\n\n🚫 Vous êtes banni permanent de MZ PVP. \nDétails de votre bannissement\n\n Raison : %s\n Auteur: %s\nID-Ban: %s"):format(banData.reason, banData.sourceName, banData.id))
            else
                if tonumber(banData.expiration) > os.time() then
                    local timeRemaining = tonumber(banData.expiration) - os.time()
                    pDeferals.done(("\n\n🚫 Vous êtes banni de MZ PVP. \nDétails de votre bannissement\n\n Raison : %s\n Temps restant: %s\n Auteur: %s\nID-Ban: %s"):format(banData.reason, TimeRemaining(timeRemaining), banData.sourceName, banData.id))
                else
                    GM.Bans:Delete(pLicense)
                    pDeferals.done()
                end
            end
        else
            pDeferals.done()
        end
    end)
end)