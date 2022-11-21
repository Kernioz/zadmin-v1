local callbackDebug = true -- Display prints or not
ServerCallbacks = {}

function RegisterServerCallback(name, cb)
    ServerCallbacks[name] = cb
	print("^2[Callback Module] ^3Callback ^2 '" .. string.upper(name) .. "' ^3registered")
end

function TriggerServerCallback(name, requestId, source, cb, ...)
    if ServerCallbacks[name] then
        if callbackDebug then
     --      print("^4[kFw] ^0Trigger ^4"..name.." ^0CALLED^1 b4 "..source)
        end
		ServerCallbacks[name](source, cb, ...)
	else
	--	print(('^1ERROR:^7 Server callback "%s" does not exist.'):format(name))
	end
end



RegisterServerEvent('triggerServerCallback')
AddEventHandler('triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('serverCallback', playerId, requestId, ...)
	end, ...)
end)