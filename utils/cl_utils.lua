_TriggerServerEvent = TriggerServerEvent
local scenarios = {
    'WORLD_VEHICLE_ATTRACTOR',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_BICYCLE_BMX',
    'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
    'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
    'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
    'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
    'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
    'WORLD_VEHICLE_BICYCLE_ROAD',
    'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
    'WORLD_VEHICLE_BIKER',
    'WORLD_VEHICLE_BOAT_IDLE',
    'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BROKEN_DOWN',
    'WORLD_VEHICLE_BUSINESSMEN',
    'WORLD_VEHICLE_HELI_LIFEGUARD',
    'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
    'WORLD_VEHICLE_CONSTRUCTION_SOLO',
    'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
    'WORLD_VEHICLE_DRIVE_SOLO',
    'WORLD_VEHICLE_FIRE_TRUCK',
    'WORLD_VEHICLE_EMPTY',
    'WORLD_VEHICLE_MARIACHI',
    'WORLD_VEHICLE_MECHANIC',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_PARK_PARALLEL',
    'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
    'WORLD_VEHICLE_PASSENGER_EXIT',
    'WORLD_VEHICLE_POLICE_BIKE',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_POLICE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_QUARRY',
    'WORLD_VEHICLE_SALTON',
    'WORLD_VEHICLE_SALTON_DIRT_BIKE',
    'WORLD_VEHICLE_SECURITY_CAR',
    'WORLD_VEHICLE_STREETRACE',
    'WORLD_VEHICLE_TOURBUS',
    'WORLD_VEHICLE_TOURIST',
    'WORLD_VEHICLE_TANDL',
    'WORLD_VEHICLE_TRACTOR',
    'WORLD_VEHICLE_TRACTOR_BEACH',
    'WORLD_VEHICLE_TRUCK_LOGS',
    'WORLD_VEHICLE_TRUCKS_TRAILERS',
    'WORLD_VEHICLE_DISTANT_EMPTY_Ground'
  }
  
for i, v in ipairs(scenarios) do
    SetScenarioTypeEnabled(v, false)
end


function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end


function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

kUtils = {}


local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end

kUtils.ShowNotificationWithButton = function(button, message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("jamyfafi")
	return EndTextCommandThefeedPostReplayInput(1, button, message)
end

local oldNotification 
kUtils.ShowNotification = function(message, back)
	if oldNotification then RemoveNotification(oldNotification) end
	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("jamyfafi")
	AddLongString(message)
	oldNotification = EndTextCommandThefeedPostTicker(0, 1)
	return EndTextCommandThefeedPostTicker(0, 1)
end

kUtils.ShowNotificationNoReplace = function(message, back)

	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("jamyfafi")
	AddLongString(message)
	oldNotification = EndTextCommandThefeedPostTicker(0, 1)
	return EndTextCommandThefeedPostTicker(0, 1)
end

kUtils.ShowHelp = function(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end

kUtils.ShowFloatingHelp = function(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    kUtils.ShowHelp(text, 2)
end


local playersCount = nil
kUtils.getPlayersWithJob = function(obj)
	TriggerServerCallback("jobs:getPlayers", function(count)
		playersCount = count
	end, obj)
	while playersCount == nil do Wait(1) end
	return playersCount
end

kUtils.resetPlayersWithJob = function()
	playersCount = nil 
end


RegisterNetEvent("kFw:getJobCounter")
AddEventHandler("kFw:getJobCounter", function(del)
	playersCount = del
end)

RegisterNetEvent("kFw:showAdvancedNotification")
AddEventHandler("kFw:showAdvancedNotification", function(sender, subject, msg, textureDict, iconType) 
	kUtils.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType)
end)


RegisterNetEvent("kFw:showColoredNotification")
AddEventHandler("kFw:showColoredNotification", function(del, michel)
	kUtils.ShowColoredNotification(del, michel)
end)

RegisterNetEvent("kFw:showNotification")
AddEventHandler("kFw:showNotification", function(del, michel)
	kUtils.ShowNotification(del)
end)
RegisterNetEvent("kFw:showNotification2")
AddEventHandler("kFw:showNotification2", function(del, michel)
	kUtils.ShowNotificationNoReplace(del)
end)

kUtils.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType)
	AddTextEntry('AdvancedNotification', msg)
	BeginTextCommandThefeedPost('AdvancedNotification')
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(false, false)
end

kUtils.ShowHelpNotification = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

kUtils.ShowColoredNotification = function(msg, color)
    SetNotificationBackgroundColor(color)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

kUtils.ShowAdvancedColoredNotification = function(title, subject, msg, icon, iconType, color)
	SetNotificationBackgroundColor(color)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end


kUtils.GetVehicleBasicVisualDamages = function(vehicle)
	if not vehicle or not DoesEntityExist(vehicle) then return end
	local tbl = { doors = {}, tyres = {}, windows = {}}

	for i=0, GetNumberOfVehicleDoors(vehicle) - 1 do
		if IsVehicleDoorDamaged(vehicle, i) then
			tbl.doors[i] = 0
		end
	end

	for i=0, GetVehicleNumberOfWheels(vehicle) - 1 do
		if IsVehicleTyreBurst(vehicle, i, true) then
			tbl.tyres[i] = 0
		elseif IsVehicleTyreBurst(vehicle, i, false) then
			tbl.tyres[i] = 1
		end
	end

	-- max is 13 but 7 seems to be enough to get all important windows
	for i=0, 7 do
		if not IsVehicleWindowIntact(vehicle, i) then
			tbl.windows[#tbl.windows + 1] = i
		end
	end

	return tbl
end

kUtils.SetVehicleBasicVisualDamages = function(vehicle, damages)
	for k,v in pairs(damages.tyres) do
		SetVehicleTyreBurst(vehicle, k, true, v == 0 and 1000.0 or 0.0)
	end

	for _,v in pairs(damages.windows) do
		SmashVehicleWindow(vehicle, v)
	end
end

kUtils.SelectRandomSpawn = function(zone)
    local count = 0
    for k,v in pairs(zone) do
        count = count + 1
        local r = zone[math.random(1, #zone)]
        if kUtils.IsSpawnPointClear(r.pos, 2.0) then
            return r.pos, r.heading
        end

        if count >= #zone then
            break
        end
    end
    return false
end

kUtils.KeyboardAmount = function(b)
    local amount = nil
    
	if b ~= nil then AddTextEntry("CUSTOM_AMOUNT", b) else AddTextEntry("CUSTOM_AMOUNT", "Entrer une valeur") end 
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 15)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
	
    if UpdateOnscreenKeyboard() ~= 2 then
        amount = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
	
    return tonumber(amount)
end

kUtils.Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

kUtils.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())..right
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

kUtils.GetPlayers = function()
	local maxPlayers = 1024
	local players    = {}

	for i=0, maxPlayers, 1 do

		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end

kUtils.Teleport = function(entity, coords, cb)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	
	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end

  	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	if cb ~= nil then 
		cb()	
	end 
end

-- Téléportations
kUtils.TeleportTopCoords = function(pos, ent, trustPos) -- TP Un joueur (Sans bug de collision)
	if not pos or not pos.x or not pos.y or not pos.z or (ent and not DoesEntityExist(ent)) then return true end
	local x, y, z = pos.x, pos.y, pos.z + 1.0
	ent = ent or GetPlayerPed(-1)

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local tempTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(ent, x, y, z)

	tempTimer = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(ent) do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ
	if not trustPos then
		foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
		tempTimer = GetGameTimer()
		while not foundNewZ do
			z = z + 10.0
			foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
			Wait(0)

			if GetGameTimer() - tempTimer > 2000 then
				break
			end
		end
	end

	LastCoords = vector3(x, y, foundNewZ and newZ or z)
	SetEntityCoordsNoOffset(ent, x, y, foundNewZ and newZ or z)
	NewLoadSceneStop()

	if type(pos) ~= "vector3" and pos.a then SetEntityHeading(ent, pos.a) end
	return true
end

local done

kUtils.GoPlayerToPos = function(pos, ent) -- TP Un joueur (Sans bug de collision) avec Cinématique
	LastCoords = pos
	done = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	done = kUtils.TeleportTopCoords(pos, ent)
	while not done do
		Citizen.Wait(0)
	end
	DoScreenFadeIn(100)
end


kUtils.GetPlayersInArea = function(coords, area)
	local players       = kUtils.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

kUtils.RequestModel = function(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do Wait(500) end
end

kUtils.GetEntityOwner = function(entity)
    local owner = NetworkGetEntityOwner(entity)
    return GetPlayerServerId(owner)
end

kUtils.SpawnProp = function(model, coords, cb)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do Wait(1) end

	local entity = CreateObject(GetHashKey(model), coords, 0, 0, 0)
	FreezeEntityPosition(entity, true)
	PlaceObjectOnGroundProperly(entity)
	if cb then
		cb()
	end
	return entity
end

kUtils.RequestControl = function(entity) --Request Control d'une entité
	local start = GetGameTimer()
	local entityId = tonumber(entity)
	if not DoesEntityExist(entityId) then return end
	if not NetworkHasControlOfEntity(entityId) then		
		NetworkRequestControlOfEntity(entityId)
		while not NetworkHasControlOfEntity(entityId) do
			Citizen.Wait(10)
			if GetGameTimer() - start > 5000 then return end
		end
	end
	return entityId
end

--[[
	enum spinnerType  F
	{  
		LOADING_PROMPT_LEFT, 	(1) 
		LOADING_PROMPT_LEFT_2,  (2)
		LOADING_PROMPT_LEFT_3,  (3)
		SAVE_PROMPT_LEFT,  		(4)
		LOADING_PROMPT_RIGHT,  	(5)
	}; 
--]]


kUtils.LoadingPrompt = function(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

kUtils.DrawAdvancedText = function(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end


kUtils.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

kUtils.GetVehiclesInArea = function(coords, area)
	local vehicles       = kUtils.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

kUtils.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds = {}

	for ped in EnumeratePeds() do
		local found = false

		for j = 1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

kUtils.GetClosestPed = function(coords, ignoreList)
	ignoreList = ignoreList or {}
	local peds = kUtils.GetPeds(ignoreList)
	local closestDistance, closestPed = -1, -1

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i], false)
		local distance = #(pedCoords - coords)

		if closestDistance == -1 or closestDistance > distance then
			closestPed = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

kUtils.GetClosestPed2 = function(vector, radius, modelHash, testFunction) -- Get un ped par radius
	if not vector or not radius then return end
	local handle, myped, veh = FindFirstPed(), GetPlayerPed(-1)
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z)
		if firstDist < radius and veh ~= myped and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh))) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextPed(handle)
	until not success
		EndFindPed(handle)
	return theVeh
end

kUtils.GetNearbyPlayers = function(distance) -- Get des joueurs dans la zone
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(kUtils.GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

local cWait = false;
local xWait = false
kUtils.GetNearbyPlayer = function(distance) -- Sélectionner un joueur si plusieurs sont collé à vous
    if cWait then
        xWait = true
        while cWait do
            Citizen.Wait(5)
        end
    end
    xWait = false
    local cTimer = GetGameTimer() + 10000;
    local oPlayer = kUtils.GetNearbyPlayers(distance)
    if #oPlayer == 0 then
		kUtils.ShowNotification("~r~Rapprochez-vous d'un joueur!")
        return false
    end
    if #oPlayer == 1 then
        return oPlayer[1]
    end

	kUtils.ShowNotification("Appuyez sur ~b~E~s~ pour valider.\nAppuyer sur ~b~A~s~ pour changer de cible.\nAppuyer sur ~r~X~s~ pour annuler")
    Citizen.Wait(100)
    local cBase = 1
    cWait = true
    while GetGameTimer() <= cTimer and not xWait do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            cWait = false
            return oPlayer[cBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            kUtils.ShowNotification("~r~Vous avez annulé le choix du joueur !")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            cBase = (cBase == #oPlayer) and 1 or (cBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[cBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    cWait = false
    return false
end

kUtils.GetClosestPlayer = function()
	local pPed = GetPlayerPed(-1)
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k,v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

kUtils.GetClosestVehicle = function(coords)
	local vehicles        = kUtils.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

kUtils.GetClosestVehicle2 = function(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, veh = FindFirstVehicle()
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z, true)
		if firstDist < radius and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh), true)) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextVehicle(handle)
	until not success
		EndFindVehicle(handle)

	return theVeh
end

kUtils.KeyboardInput = function(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

kUtils.IsSpawnPointClear = function(coords, radius)
	local vehicles = kUtils.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end


kUtils.RequestAnimationDict = function(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb then
		cb()
	end
end

kUtils.RequestAnimationSet = function(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet) do
			Citizen.Wait(1)
		end
	end

	if cb then
		cb()
	end
end



kUtils.SpawnVehicle = function(model, coords, heading, cb)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
			
		end

		local vehicle = CreateVehicle(model, coords, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)


		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

kUtils.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	Citizen.CreateThread(function()
		RequestModel(modelName)

		while not HasModelLoaded(modelName) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(modelName, coords, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

kUtils.DeleteVehicle = function(vehicle) -- Supprimé un véhicules
	kUtils.RequestControl(vehicle)
	if not DoesEntityExist(vehicle) then return end
	SetEntityAsMissionEntity(vehicle, true, true)
	SetEntityAsNoLongerNeeded(vehicle)
	-- TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
	DeleteEntity(vehicle)
end



kUtils.DrawSub = function(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

kUtils.ClearSub = function()
	ClearPrints()
end

kUtils.DrawText3D = function(x, y, z, string, sizes, v3) -- Draw Text 3D
    local size = sizes or 7
    local camx, camy, camz = table.unpack(GetGameplayCamCoords())
    sizes = GetDistanceBetweenCoords(camx, camy, camz, x, y, z, 1)
    local distance = GetDistanceBetweenCoords(Player.Pos, x, y, z, 1) - 1.65
    local scale, dst = ((1 / sizes) * (size * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if distance < size then
        dst = math.floor(255 * ((size - distance) / size))
    elseif distance >= size then
        dst = 0
    end
    dst = v3 or dst
    SetTextFont(0)
    SetTextScale(.0 * scale, .1 * scale)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, dst)))
    SetTextCentre(1)
    SetDrawOrigin(x, y, z, 0)
    SetTextEntry("STRING")
    AddTextComponentString(string)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


kUtils.DrawTextObject = function(v, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(v.x,v.y,v.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, v.x,v.y,v.z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function DrawTextAdvanced(x, y, text)
    SetTextFont(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(230, 230, 230, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x,y)
end

local announcerHandler = false
kUtils.DrawAnnouncerMessage = function(msg, time)
	announcerHandler = true
	Citizen.CreateThread(function() 
		while announcerHandler do 
			Wait(1)
			DrawTextAdvanced(0.5, 0.77, msg)
		end 
	end)

	Citizen.CreateThread(function() 
		Wait(time)
		announcerHandler = false
	end)
end 

RegisterNetEvent("kz:showSub")
AddEventHandler("kz:showSub", function(msg, timeMs)
	kUtils.DrawAnnouncerMessage(msg, timeMs)
end)

kUtils.PlayAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
	if blendin == nil then blendin = 1.0 end
	if blendout == nil then blendout = 1.0 end
	if playbackRate == nil then playbackRate = 1.0 end
	if duration == nil then duration = -1 end
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
	RemoveAnimDict(dict)
end	

kUtils.GetClosestObject = function(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, veh = FindFirstObject()
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z, true)
		if firstDist < radius and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh), true)) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextObject(handle)
	until not success
		EndFindObject(handle)
	return theVeh
end

kUtils.checkItemInventory = function(inv, name)
	if inv ~= nil then 
		for k,v in pairs(inv) do
			if v.item == name then
				return true, v.args, v.itemId, v.count
			end
		end
	end
    return false
end



kUtils.haveItem = function(inv, name)
	if inv ~= nil then 
		for k,v in pairs(inv) do
			if v.item == name then
				return v
			end
		end
	end
    return false
end


kUtils.getItemCount = function(name)
	for k,v in pairs(Player.Inventory) do
		if v.item == name then
			return v.count
		end
	end
    return 0
end

kUtils.getItemWithSpecCount = function(name, count)
	for k,v in pairs(Player.Inventory) do
		if v.item == name then
			if v.count >= count then 
				return true
			end 
			return false
		end
	end
    return false
end

kUtils.StartInteractAnimation = function(time)
	if time ~= nil then
		Player.IsAnimating = true
		RequestAnimDict("pickup_object")
		while (not HasAnimDictLoaded("pickup_object")) do Citizen.Wait(0) end
		TaskPlayAnim(GetPlayerPed(-1), "pickup_object","pickup_low", 1.0, -1.0, -1, 0, 1, true, true, true)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		Citizen.Wait(time)
		Player.IsAnimating = false
	else
		RequestAnimDict("pickup_object")
		while (not HasAnimDictLoaded("pickup_object")) do Citizen.Wait(0) end
		TaskPlayAnim(GetPlayerPed(-1), "pickup_object","pickup_low", 1.0, -1.0, -1, 0, 1, true, true, true)
		FreezeEntityPosition(GetPlayerPed(-1), false)
	end
end

kUtils.StartInteractionDrugsAnimation = function(position, heading, time)
	SetEntityCoords(PlayerPedId(), position)
	SetEntityHeading(PlayerPedId(), heading)
	RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
	while (not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@")) do Citizen.Wait(0) end
	TaskPlayAnim(GetPlayerPed(-1), "anim@amb@business@weed@weed_inspecting_lo_med_hi@","weed_crouch_checkingleaves_idle_01_inspector", 1.0, -1.0, -1, 0, 1, true, true, true)
	FreezeEntityPosition(GetPlayerPed(-1), false)
end


kUtils.StartHackingAnimation = function()
	RequestAnimDict("anim@heists@ornate_bank@hack")
	while (not HasAnimDictLoaded("anim@heists@ornate_bank@hack")) do Citizen.Wait(0) end
	TaskPlayAnim(GetPlayerPed(-1), "anim@heists@ornate_bank@hack","hack_loop", 3.0, 1.0, -1, 30, 1.0, 0, 0)
	FreezeEntityPosition(GetPlayerPed(-1), false)
end

kUtils.startAnim = function(lib, anim)
	kUtils.RequestAnimationDict(lib, function()
		TaskPlayAnim(GetPlayerPed(-1), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

kUtils.startScenario = function(anim)
	TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, false)
end

kUtils.SetVehicleProperties = function(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

kUtils.DrawText = function(v, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(v.x,v.y,v.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, v.x,v.y,v.z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

replaceText = function(py)
    local one  = GetPlayerName(py)
    local two = ""
    for i = 1, string.len(one), 1 do
        two = two.."•"
    end

    return two
end

kUtils.showIDPlayer = function(coordsx, coordsy, coordsz, text, size)
	local onScreen, x, y = World3dToScreen2d(coordsx, coordsy, coordsz)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coordsx, coordsy, coordsz, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(4)
		SetTextOutline()
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextCentre(1)
		SetTextEntry('STRING')

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

kUtils.VehicleInFront = function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

kUtils.GetTargetedVehicle = function(pCoords, ply)
    for i = 1, 200 do
        coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, (6.281)/i, 0.0)
        targetedVehicle = kUtils.GetVehicleInDirection(pCoords, coordB)
        if(targetedVehicle ~= nil and targetedVehicle ~= 0)then
            return targetedVehicle
        end
    end
    return
end

kUtils.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

kUtils.CTS = function(eventName, ...)
	return _TriggerServerEvent("stc", eventName, ...)
end 


kUtils.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = kUtils.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = kUtils.Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = kUtils.Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = kUtils.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = kUtils.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleMod(vehicle, 48),
		}
	else
		return
	end
end



function Instructions(instructions, cam) -- Mettre une instruction (scalform)
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(1) end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

	local counter = 0
    for _, instruction in pairs(instructions) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(counter)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, instruction.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(instruction.message)
        EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		counter = counter + 1
	end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

function DisplayMessage(msg)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)

    AddTextEntry("respawn", msg)
    BeginTextCommandScaleformString("respawn")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 170, 0)
end

function showFireworkEffect(_asset, _name, _coords, _size)
	if not HasNamedPtfxAssetLoaded(_asset) then
		RequestNamedPtfxAsset(_asset)
		while not HasNamedPtfxAssetLoaded(_asset) do
			Wait(10)
		end
	end

	UseParticleFxAssetNextCall(_asset)
	local part = StartParticleFxNonLoopedAtCoord(_name, _coords.x, _coords.y, _coords.z, 0.0, 0.0, 0.0, _size + 0.0, false, false, false, false)
end

-- Progres bars
local HaveProgress
function ProgressBarExists() -- Si une barre de progression existe
    return HaveProgress 
end

function DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext) -- Créer un text 2D a l'écran
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text,Text+.1)
    end;
    AddTextComponentString(Text2)
    DrawText(Text,Text3)
end

local petitpoint = {".","..","...",""}
function ProgressBar(Text, r, g, b, a, Timing, NoTiming) -- Créer une progress bar
    if not Timing then 
        return 
    end
    RemoveProgressBar()
    HaveProgress = true

    Citizen.CreateThread(function()
        local Timing1, Timing2 = .0, GetGameTimer() + Timing
        local E, Timing3 = ""
        while HaveProgress and (not NoTiming and Timing1 < 1) do
            Citizen.Wait(0)
            if not NoTiming or Timing1 < 1 then 
                Timing1 = 1-((Timing2 - GetGameTimer())/Timing)
            end
            if not Timing3 or GetGameTimer() >= Timing3 then
                Timing3 = GetGameTimer()+500;
                E = petitpoint[string.len(E)+1] or ""
            end;
            DrawRect(.5,.875,.15,.03,0,0,0,100)
            local y, endroit=.15-.0025,.03-.005;
            local chance = math.max(0,math.min(y,y*Timing1))
            DrawRect((.5-y/2)+chance/2,.875,chance,endroit,0,141,223,a) -- 0,155,255,125
            DrawTextScreen(.5,.875-.0125,.3,(Text or"Action en cours")..E,0,0,false)
        end;
        RemoveProgressBar()
    end)
end

function RemoveProgressBar() -- Delete les progress bar
    HaveProgress = nil 
end



local Scenes = {}
Scenes.Synchronised = {}

function SynchronisedScene()
    return Scenes.Synchronised 
end

function ReleaseModel(model)
    local hash = (type(model) == "number" and model or GetHashKey(model))
    if HasModelLoaded(hash) then
        SetModelAsNoLongerNeeded(hash)
    end
end

function ReleaseAnimDict(dict)
    if HasAnimDictLoaded(dict) then
        SetAnimDictAsNoLongerNeeded(dict)
    end
end

if not Citizen then
    NetworkCreateSynchronisedScene      = function(...)   return ...            end
    NetworkAddPedToSynchronisedScene    = function(...)   return ...            end
    NetworkAddEntityToSynchronisedScene = function(...)   return ...            end
    NetworkStartSynchronisedScene       = function(...)   return ...            end
    NetworkStopSynchronisedScene        = function(...)   return ...            end
    vector3                             = function(x,y,z) return {x=x,y=y,z=z}  end
end

Scenes.Synchronised = {
    Defaults = {
        SceneConfig = {
          position      = vector3(0.0,0.0,0.0),
          rotation      = vector3(0.0,0.0,0.0),
          rotOrder      = 2,
          useOcclusion  = false,
          loop          = false,
          unk1          = 1.0,
          animTime      = 0,
          animSpeed     = 1.0, 
        },
  
        PedConfig = {
            blendIn       = 1.0,
            blendOut      = 1.0,
            duration      = 0,
            flag          = 0,
            speed         = 1.0,
            unk1          = 0,
        },
  
        EntityConfig = {
            blendIn       = 1.0,
            blendOut      = 1.0,
            flags         = 1,
        }
    },


    Create = function(sceneConfig)    
        return NetworkCreateSynchronisedScene(sceneConfig.position,sceneConfig.rotation,sceneConfig.rotOrder,sceneConfig.useOcclusion,sceneConfig.loop,sceneConfig.unk1,sceneConfig.animTime,sceneConfig.animSpeed)
    end,
    
    SceneConfig = function(pos,rot,rotOrder,useOcclusion,loop,unk1,animTime,animSpeed)
    
        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["SceneConfig"][v2]; end; end
    
        local conObj = {}
        conObj.position     = _D(pos,"position")
        conObj.rotation     = _D(rot,"rotation")
        conObj.rotOrder     = _D(rotOrder,"rotOrder")
        conObj.useOcclusion = _D(useOcclusion,"useOcclusion")
        conObj.loop         = _D(loop,"loop")
        conObj.unk1         = _D(p9,"unk1")
        conObj.animTime     = _D(animTime,"animTime")
        conObj.animSpeed    = _D(animSpeed,"animSpeed")
        return conObj
    end,
    
    AddPed = function(pedConfig)
        return NetworkAddPedToSynchronisedScene(pedConfig.ped,pedConfig.scene,pedConfig.animDict,pedConfig.animName,pedConfig.blendIn,pedConfig.blendOut,pedConfig.duration,pedConfig.flag,pedConfig.speed,pedConfig.unk1)
    end,
    
    PedConfig = function(ped,scene,animDict,animName,blendIn,blendOut,duration,flag,speed,unk1)

        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["PedConfig"][v2]; end; end

        local conObj = {}
        conObj.ped          = ped
        conObj.scene        = scene
        conObj.animDict     = animDict
        conObj.animName     = animName
        conObj.blendIn      = _D(blendIn,"blendIn")
        conObj.blendOut     = _D(blendOut,"blendOut")
        conObj.duration     = _D(duration,"duration")
        conObj.flag         = _D(flag,"flag")
        conObj.speed        = _D(speed,"speed")
        conObj.unk1         = _D(unk1,"unk1")
        return conObj
    end,
    
    AddEntity = function(entityConfig)
        return NetworkAddEntityToSynchronisedScene(entityConfig.entity,entityConfig.scene,entityConfig.animDict,entityConfig.animName,entityConfig.blendIn,entityConfig.blendOut,entityConfig.flags)
    end,
    
    EntityConfig = function(entity,scene,animDict,animName,blendIn,blendOut,flags)

        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["EntityConfig"][v2]; end; end

        local conObj = {}
        conObj.entity       = entity
        conObj.scene        = scene
        conObj.animDict     = animDict
        conObj.animName     = animName
        conObj.blendIn      = _D(blendIn,"blendIn")
        conObj.blendOut     = _D(blendOut,"blendOut")
        conObj.flags        = _D(flags,"flags")
        return conObj
    end,

    Start = function(scene)
        NetworkStartSynchronisedScene(scene)
    end,

    Stop = function(scene)
        NetworkStopSynchronisedScene(scene)
    end,
}

local sceneObjects  = {}
local Scenes = SynchronisedScene()
local startTime
function SceneHandler(action, pos)
    local plyPed = PlayerPedId()
    local pPos = GetEntityCoords(plyPed)
    action.location = pos
    local sceneType = action.act
    local doScene = action.scene
    local actPos = action.location - action.offset
    local actRot = action.rotation
    local animDict = SceneDicts[sceneType][doScene]
    local actItems = SceneItems[sceneType][doScene]
    local actAnims = SceneAnims[sceneType][doScene]
    local plyAnim = PlayerAnims[sceneType][doScene]
    while not HasAnimDictLoaded(animDict) do 
        RequestAnimDict(animDict)
        Wait(0)
    end
    local count = 1
    local objectCount = 0
    for k,v in pairs(actItems) do
        local hash = GetHashKey(v)
        while not HasModelLoaded(hash) do RequestModel(hash)
            Wait(0) 
        end
        sceneObjects[k] = CreateObject(hash,actPos,true)
        SetModelAsNoLongerNeeded(hash)
        objectCount = objectCount + 1
        while not DoesEntityExist(sceneObjects[k]) do 
            Wait(0)
        end
        SetEntityCollision(sceneObjects[k],false,false)
    end
    local scenes = {}
    local sceneConfig = Scenes.SceneConfig(actPos,actRot,2,false,false,1.0,0,1.0)
    for i=1,math.max(1,math.ceil(objectCount/3)),1 do
      scenes[i] = Scenes.Create(sceneConfig)
    end
    local pedConfig = Scenes.PedConfig(plyPed,scenes[1],animDict,plyAnim)
    Scenes.AddPed(pedConfig)
    for k,animation in pairs(actAnims) do      
      local targetScene = scenes[math.ceil(count/3)]
      local entConfig = Scenes.EntityConfig(sceneObjects[k],targetScene,animDict,animation)
      Scenes.AddEntity(entConfig)
      count = count + 1
    end
    local extras = {}
    if action.extraProps then
      for k,v in pairs(action.extraProps) do
        kUtils.RequestModel(v.model)
        local obj = CreateObject(GetHashKey(v.model), actPos + v.pos, true,true,true)
        while not DoesEntityExist(obj) do Wait(0); end
        SetEntityRotation(obj,v.rot)
        FreezeEntityPosition(obj,true)
        extras[#extras+1] = obj
      end
    end
    startTime = GetGameTimer()
    for i=1,#scenes,1 do
      Scenes.Start(scenes[i])
    end
    Wait(action.time)
    for i=1,#scenes,1 do
      Scenes.Stop(scenes[i])
    end
    for k,v in pairs(extras) do
      DeleteObject(v)
    end
    RemoveAnimDict(animDict)
    for k,v in pairs(sceneObjects) do 
        NetworkFadeOutEntity(v, false, false)
    end
end

function SimpleRayCastFromPed(offset, flag, ignore)
    local playerId = PlayerId()
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId),true)
    local inDirection  = GetOffsetFromEntityInWorldCoords(GetPlayerPed(playerId), offset.x, offset.y, offset.z)
    local rayHandle    = CastRayPointToPoint(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, flag, ignore, 0)
    local _, _, offset, _, entityRayCasted = GetShapeTestResult(rayHandle)
    return entityRayCasted, offset
end

function ConvertToBool(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end

function ConvertToNum(bool)
    if bool then return 1 else return 0 end
end

-- Gestion blips
-- Blips
function CreateBlips(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale, intDisplay, intAlpha, Title, Image, InfoType, InfoName, InfoText) -- Créer un blips
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
    if Title then
        exports.zNotifs:SetBlipInfoTitle(blip, Title, false)
    end
    if Image then
        RequestStreamedTextureDict(Image[1], 1)
        while not HasStreamedTextureDictLoaded(Image[1]) do
            Wait(0)
        end
    
        exports.zNotifs:SetBlipInfoImage(blip, Image[1], Image[2])
    end
	
	if InfoType then 
		exports.zNotifs:AddBlipInfoText(blip, InfoType[1], InfoType[2])
	end 

    if InfoName then
        exports.zNotifs:AddBlipInfoName(blip, InfoName[1], InfoName[2])
    end
    if InfoText then
		exports.zNotifs:AddBlipInfoHeader(blip, "") 
        exports.zNotifs:AddBlipInfoText(blip, InfoText)
    end
	return blip
end

function GetAllBlipsWithSprite(spriteId) -- Get Des blips
	local blip = GetFirstBlipInfoId(spriteId)
	if blip == 0 then return {} end

	local allBlips = {}
	local nextBlip = blip

	while nextBlip ~= 0 do
		allBlips[#allBlips + 1] = nextBlip
		nextBlip = GetNextBlipInfoId(spriteId)
	end

	return allBlips
end
-- Fin gestion Blips

-- Scaleforms
kUtils.CreateVehicleStats = function(cars)
    local VehicleModel = GetEntityModel(cars)
    local VehicleSpeed = GetVehicleEstimatedMaxSpeed(cars) * 1.25
    local VehicleAcceleration = GetVehicleAcceleration(cars) * 200
    local VehicleBraking = GetVehicleMaxBraking(cars) * 100
    local VehicleTraction = GetVehicleMaxTraction(cars) * 25
    local VehicleHealth = kUtils.GetVehicleHealth(cars)
    return CreateScaleform("mp_car_stats_01", {{
        name = "SET_VEHICLE_INFOR_AND_STATS",
        param = {GetLabelText(GetDisplayNameFromVehicleModel(VehicleModel)), "État du véhicule: "..VehicleHealth.."%", "MPCarHUD","Annis", "Vitesse max", "Accélération", "Frein", "Suspension", VehicleSpeed, VehicleAcceleration, VehicleBraking, VehicleTraction}
    }})
end

function CreateScaleform(name, data) -- Créer un scalform
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

function SetScaleformParams(scaleform, data) -- Set des éléments dans un scalform
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end

local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }
activeBars = {}

function DrawText2(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp) -- Draw text 2D
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end
	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(stirngText)
	DrawText(intPosX, intPosY)
end

function AddTimerBar(title, itemData) -- Add un timber bar
    if not itemData then return end
    RequestStreamedTextureDict("timerbars", true)

    local barIndex = #activeBars + 1
    activeBars[barIndex] = {
        title = title,
        text = itemData.text,
        textColor = itemData.color or { 255, 255, 255, 255 },
        percentage = itemData.percentage,
        endTime = itemData.endTime,
        pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
        pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
    }

    return barIndex
end

function RemoveTimerBar() -- Remove une timer bar
    activeBars = {}
    SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function UpdateTimerBar(barIndex, itemData) -- Update une timer bar
    if not activeBars[barIndex] or not itemData then return end
    for k,v in pairs(itemData) do
        activeBars[barIndex][k] = v
    end
end

local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

function SecondsToClock(seconds) -- Get les secondes
    seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00"
    else
        mins = string.format("%02.f", math.floor(seconds / 60))
        secs = string.format("%02.f", math.floor(seconds - mins * 60))
        return string.format("%s:%s", mins, secs)
    end
end

Citizen.CreateThread(function()
    while true do
        local attente = 2500

        local safeZone = GetSafeZoneSize()
        local safeZoneX = (1.0 - safeZone) * 0.5
        local safeZoneY = (1.0 - safeZone) * 0.5

        if #activeBars > 0 then
            attente = 1
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)

            for i,v in pairs(activeBars) do
                local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
                DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
                DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

                if v.percentage then
                    local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
                    local pbarY = drawY + ScreenCoords.pbarOffsetY;
                    local width = Sizes.pbarWidth * v.percentage;

                    DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

                    DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
                elseif v.text then
                    DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
                elseif v.endTime then
                    local remainingTime = math.floor(v.endTime - GetGameTimer())
                    DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
                end
            end
        end
        Wait(attente)
    end
end)

kUtils.AskEntry = function(callback, name, lim, default)
	AddTextEntry('FMMC_KEY_TIP8', name or "Montant")
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", default, "", "", "", lim or 60)

	while UpdateOnscreenKeyboard() == 0 do
		Citizen.Wait(10)
		if UpdateOnscreenKeyboard() >= 1 then
			callback(GetOnscreenKeyboardResult())
			break
		end
	end
end

-- Animations
kUtils.TaskAnim = function(animName, time, flag, ped, customPos) -- Faire jouer une anim a un ped (joueur)
	if type(animName) ~= "table" then animName = {animName} end
	ped, flag = ped or GetPlayerPed(-1), flag and tonumber(flag) or false

	if not animName or not animName[1] or string.len(animName[1]) < 1 then return end
    if IsEntityPlayingAnim(ped, animName[1], animName[2], 3) or IsPedActiveInScenario(ped) then ClearPedTasks(ped) 
        return end

	Citizen.CreateThread(function()
		kUtils.TaskAnimForce(animName, flag, { ped = ped, time = time, pos = customPos })
	end)
end

kUtils.TaskSynchronizedTasks = function(ped, animData, clearTasks)
	for _,v in pairs(animData) do
		if not HasAnimDictLoaded(v.anim[1]) then
			RequestAnimDict(v.anim[1])
			while not HasAnimDictLoaded(v.anim[1]) do Citizen.Wait(0) end
		end
	end

	local _, sequence = OpenSequenceTask(0)
	for _,v in pairs(animData) do
		TaskPlayAnim(0, v.anim[1], v.anim[2], 2.0, -2.0, math.floor(v.time or -1), v.flag or 48, 0, 0, 0, 0)
	end

	CloseSequenceTask(sequence)
	if clearTasks then ClearPedTasks(ped) end
	TaskPerformSequence(ped, sequence)
	ClearSequenceTask(sequence)

	for _,v in pairs(animData) do
		RemoveAnimDict(v.anim[1])
	end

	return sequence
end

local AnimBlacklist = {"WORLD_HUMAN_MUSICIAN", "WORLD_HUMAN_CLIPBOARD"}
local AnimFemale = {
	["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
	["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
	["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
	["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
	["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
	["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"},
}

kUtils.TaskAnimForce = function(animName, flag, args) -- Faire forcer une anim a un ped (joueur)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and AnimFemale[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = AnimFemale[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not kUtils.TableGetValue(AnimBlacklist, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end

kUtils.RegisterControlKey = function(strKeyName, strDescription, strKey, cbPress, elease) -- Bind une touche pour une action
    RegisterKeyMapping("" .. strKeyName, strDescription, "keyboard", strKey)
	RegisterCommand("" .. strKeyName, function()
		if PLAYER.IsDead then return end
            cbPress()
    end, false)
end

-- Objects player
kUtils.AttachObjectToHandsPeds = function(ped, hash, timer, rot, bone, dynamic) -- Attach un props sur la main d'un ped
    if props and DoesEntityExist(props)then 
        DeleteEntity(props)
    end
    props = CreateObject(GetHashKey(hash), GetEntityCoords(ped), not dynamic)
    AttachEntityToEntity(props, ped, GetPedBoneIndex(ped, bone and 60309 or 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, not rot)
    if timer then 
        Citizen.Wait(timer)
        if props and DoesEntityExist(props)then 
            DeleteEntity(props)
        end
    	ClearPedTasks(ped)
    end
    return props
end

-- Zones player
local Zones =  {
	["LS"] = {
		"TONGVAH",
		"GREATC",
		"DESRT",
		"PALMPOW",
		"ZANCUDO",
		"ALAMO",
		"ARMYB",
		"BRADP",
		"BRADT",
		"CALAFB",
		"CANNY",
		"CCREAK",
		"CMSW",
		"ELGORL",
		"GALFISH",
		"GRAPES",
		"HARMO",
		"HUMLAB",
		"JAIL",
		"LAGO",
		"MTCHIL",
		"MTGORDO",
		"MTJOSE",
		"NCHU",
		"PALCOV",
		"PALETO",
		"PALFOR",
		"PROCOB",
		"RTRAK",
		"SANAND",
		"SANDY",
		"SANCHIA",
		"SLAB",
		"TONGVAV",
		"WINDF",
		"ISHEIST",
		"SanAnd",
		"OCEANA",
		"ZQ_UAR"
	},
	["BC"] = {
		"CHU",
		"BANHAMC",
		"BHAMCA",
		"RGLEN",
		"VINE",
		"TATAMO",
		"PALHIGH",
		"AIRP",
		"ALTA",
		"BANHAMC",
		"BANNING",
		"BEACH",
		"BHAMCA",
		"BURTON",
		"CHAMH",
		"CHIL",
		"CYPRE",
		"DAVIS",
		"DELBE",
		"DELPE",
		"DELSOL",
		"DOWNT",
		"DTVINE",
		"EAST_V",
		"EBURO",
		"ELYSIAN",
		"GOLF",
		"HAWICK",
		"HORS",
		"KOREAT",
		"LACT",
		"LDAM",
		"LEGSQU",
		"LMESA",
		"LOSPUER",
		"MIRR",
		"MORN",
		"MOVIE",
		"MURRI",
		"NOOSE",
		"PALHIGH",
		"PBLUFF",
		"PBOX",
		"RANCHO",
		"RGLEN",
		"RICHM",
		"ROCKF",
		"SKID",
		"STAD",
		"STRAW",
		"TATAMO",
		"TERMINA",
		"TEXTI",
		"VCANA",
		"VESP",
		"WVINE",
		"ZP_ORT"
	}
}
local ZonesHash = {
	["BC"] = -289320599, 
	["LS"] = 2072609373
}

kUtils.IsZoneOutside = function(player, name, zName) -- Get la zone précise d'un joueur
    local zLS, zName, zHash = Zones[name] or Zones["LS"], zName or player.ZoneName, ZonesHash[name] or ZonesHash["LS"]
    return zLS and kUtils.TableGetValue(zLS ,zName) or (zName == "OCEANA" and (GetHashOfMapAreaAtCoords(Player.Pos) == zHash))
end

kUtils.GetZonesFromPlayer = function(player) -- Get la zone d'un joueur
	player = player or Player
    return kUtils.IsZoneOutside(player, "LS", player.ZoneName) and "BC" or "LS"
end

-- Table
kUtils.TableGetValue = function(tbl, value, k) -- Si une table a une value précise
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

local KeepFocus = false
local Thread = false
local ControlDisable = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 68, 69, 70, 91, 92, 142, 182, 199, 200, 245, 257}
function SetKeepInputMode(bool) -- Pouvoir marcher dans un focus
	if SetNuiFocusKeepInput then
		SetNuiFocusKeepInput(bool)
	end

	KeepFocus = bool

	if not Thread and bool then
		Thread = true

		Citizen.CreateThread(function()
			while KeepFocus do
				Wait(0)

				for _,v in pairs(ControlDisable) do
					DisableControlAction(0, v, true)
				end
			end

			Thread = false
		end)
	end
end

kUtils.CreateEffect = function(style, default, time) -- Créer un effet
    Citizen.CreateThread(function()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetTimecycleModifier(style or "spectator3")
        if default then 
            SetCamEffect(2)
        end
        DoScreenFadeIn(1000)
        Citizen.Wait(time or 20000)
        local pPed = GetPlayerPed(-1)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        SetPedIsDrunk(pPed,false)
		SetCamEffect(0)
    end)
end

kUtils.DrawTextScreen = function(Text,Text3,Taille,Text2,Font,Justi,havetext) -- Créer un text 2D a l'écran
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text,Text+.1)
    end;
    AddTextComponentString(Text2)
    DrawText(Text,Text3)
end

function GetCursorScreenPosition()
    if (not IsControlEnabled(0, 239)) then
        EnableControlAction(0, 239, true)
    end
    if (not IsControlEnabled(0, 240)) then
        EnableControlAction(0, 240, true)
    end

    return vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
end

function ScreenToWorld(screenPosition, maxDistance)
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(0)
    local fov = GetGameplayCamFov()
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, 0, 2)
    local camRight, camForward, camUp, camPos = GetCamMatrix(cam)
    DestroyCam(cam, true)

    screenPosition = vector2(screenPosition.x - 0.5, screenPosition.y - 0.5) * 2.0
    
    local fovRadians = DegreesToRadians(fov)
    local to = camPos + camForward + (camRight * screenPosition.x * fovRadians * GetAspectRatio(false) * 0.534375) - (camUp * screenPosition.y * fovRadians * 0.534375)

    local direction = (to - camPos) * maxDistance
    local endPoint = camPos + direction
    
    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endPoint.x, endPoint.y, endPoint.z, -1, nil, 0)
    local _, hit, worldPosition, normalDirection, entity = GetShapeTestResult(rayHandle)
    
	if entity >= 1 then
        entityType = GetEntityType(entity)
    end
	
    if (hit == 1) then
        return true, worldPosition, normalDirection, entity, entityType
    else
        return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
    end
end

function DegreesToRadians(degrees)
    return (degrees * 3.14) / 180.0
end

kUtils.GetVehicleHealth = function(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleEngineHealth(entityVeh) / 10 ) ) )
end


local function GetEntityName(entityType)
	if entityType and type(entityType) == "string" then entityType = entityType == "VEHICLE" and 2 or entityType == "PED" and 8 end
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, entityType and entityType or 10, ped, 0)
	local _,_,_,_, ent = GetShapeTestResult(rayHandle)
	return ent
end

function kUtils.GetVehicleFace()
	local ent = GetEntityName(2)
	if ent == 0 then return end
	return ent
end

function kUtils.GetObjectFace()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, 16, ped, 0)
	local _,_,_,_, ent = GetShapeTestResult(rayHandle)

	if not IsEntityAnObject(ent) then return end
	return ent
end

function kUtils.GetPedFace()
	local ent = GetEntityName(8)
	if ent == 0 then return end
	return ent
end

function kUtils.GetPlayerFace()
	local ent = GetEntityName(8)
	if ent == 0 or not IsPedAPlayer(ent) then return end
	return ent
end

kUtils.CamManager = {
    cams = {},

    create = function(name)
        local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        cam.cams[name] = c 
    end,

    delete = function(name)
        if cam.cams[name] ~= nil then
            RenderScriptCams(0, 0, 0, 0, 1)
            SetCamActive(cam.cams[name], false)
            DestroyCam(cam.cams[name], false)
            ClearFocus()
            cam.cams[name] = nil
        end
    end,    

    setActive = function(name, bool)
        if cam.cams[name] ~= nil then
            SetCamActive(cam.cams[name], bool)
        end
    end,

    setPos = function(name, pos)
        if cam.cams[name] ~= nil then
            SetFocusPosAndVel(pos.xyz, 0.0, 0.0, 0.0)
            SetCamCoord(cam.cams[name], pos.xyz)
        end
    end,    

    setFov = function(name, fov)
        if cam.cams[name] ~= nil then
            SetCamFov(cam.cams[name], fov)
        end
    end,

    lookAtCoords = function(name, pos)
        if cam.cams[name] ~= nil then
            PointCamAtCoord(cam.cams[name], pos.xyz)

        end
    end,

    attachToEntity = function(name, entity, xOffset, yOffset, zOffset, isRelative)
        if cam.cams[name] ~= nil then
            AttachCamToEntity(cam.cams[name], entity, xOffset, yOffset, zOffset, isRelative)
		end
    end,

    attachToVehicleBone = function(name, vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)
        if cam.cams[name] ~= nil then
            AttachCamToVehicleBone(cam.cams[name], vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)    
        end
    end,

    render = function(name, render, animation, time)
        if cam.cams[name] ~= nil then
            SetCamActive(cam.cams[name], true)
            RenderScriptCams(render, animation, time, 1, 1)
        end
    end,

    switchToCam = function(name, newName, time)
        if cam.cams[name] ~= nil then
            if cam.cams[newName] ~= nil then
                SetCamActiveWithInterp(cam.cams[name], cam.cams[newName], time, 1, 1)
            end
        end
    end,

    rotation = function(name, rotX, rotY, rotZ)
        if cam.cams[name] ~= nil then
            SetCamRot(cam.cams[name], rotX, rotY, rotZ, 2)
        end
    end,
    
}


kUtils.CreateDrawMarkerDefault = function(coords)
    DrawMarker(23, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 8, 190, 246, 100, false, true, 2, false, false, false, false)
end


RegisterCommand("disablenui", function() 
    SetCursorLocation(0.5, 0.5)
    SetNuiFocus(false, false)
    SetKeepInputMode(false)
end, false)

RegisterNUICallback("disablenui", function() 
    EnableFocusNUI(false)
end, false)


function EnableFocusNUI(boolean)
    Player.InMenu = boolean
    SetNuiFocus(boolean, boolean)
    SetKeepInputMode(boolean)
    
    if boolean then 
        Citizen.CreateThread(function()
            while Player.InMenu do
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 21, true)

                DisableControlAction(0, 245, true) 
                DisableControlAction(0, 309, true) 
                DisableControlAction(0, 1, true) 
                DisableControlAction(0, 2, true) 
                DisableControlAction(0, 24, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 25, true) 
                DisableControlAction(0, 263, true) 
                DisableControlAction(0, 32, true) 
                DisableControlAction(0, 34, true) 
                DisableControlAction(0, 31, true) 
                DisableControlAction(0, 30, true) 
    
                DisableControlAction(0, 45, true) 
                DisableControlAction(0, 22, true) 
                DisableControlAction(0, 44, true) 
                DisableControlAction(0, 37, true) 
                DisableControlAction(0, 23, true) 
    
                DisableControlAction(0, 288,  true) 
                DisableControlAction(0, 289, true) 
                DisableControlAction(0, 170, true)
                DisableControlAction(0, 167, true) 
    
                DisableControlAction(0, 0, true)
                DisableControlAction(0, 26, true)
                DisableControlAction(0, 73, true) 
                DisableControlAction(2, 199, true) 
    
                DisableControlAction(0, 59, true) 
                DisableControlAction(0, 71, true) 
                DisableControlAction(0, 72, true)
    
                DisableControlAction(2, 36, true) 
    
                DisableControlAction(0, 47, true) 
                DisableControlAction(0, 264, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 140, true) 
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true) 
                DisableControlAction(0, 143, true) 
                DisableControlAction(0, 75, true)  
                DisableControlAction(27, 75, true) 

                SetPedMoveRateOverride(GetPlayerPed(-1), 0.0)
                HideHudAndRadarThisFrame()
                Wait(1.0)
            end
        end)
    end 
end

local loaded = false
RegisterNetEvent("kFw:spawnLastPosition")
AddEventHandler("kFw:spawnLastPosition", function(data, PosX, PosY, PosZ)
    if not loaded then
        if data == 0 then
            SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 0.0, 0.0, 0.0, 0)
            FreezeEntityPosition(GetPlayerPed(-1), false)
            Citizen.Wait(10)
            loaded = true
            while not NetworkIsSessionStarted() do Wait(1000) end
        else
            SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 0.0, 0.0, 0.0, 0)
            FreezeEntityPosition(GetPlayerPed(-1), false)
            loaded = true
        end
    end

    Wait(2500)

    DoScreenFadeOut(500)

    local sCoords = GetEntityCoords(GetPlayerPed(-1))
    local tCoords = vector3(PosX, PosY, PosZ)
    local bDist   = #(sCoords - tCoords)

    local tpN = 0
    while tpN < 2 do
        tpN = tpN + 1

        SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 0.0, 0.0, 0.0, 0)
        Wait(500)
    end

    DoScreenFadeIn(500)
    SetEntityVisible(GetPlayerPed(-1), true)
end)
