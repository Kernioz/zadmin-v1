Admin = Admin or {}

Admin.Banlist = {}
Admin.targetId = {}

Admin.Crews = {}
Admin.Ranks = {}
Admin.RanksPermissions = {}
Admin.Blips = {}
Admin.Players = {}

Admin.SpeedNoclip = 0.1
Admin.Cam = nil
Admin.InSpec = false
Admin.CamCalculate = nil
Admin.Timer = 0
Admin.Timer2 = 0
Admin.CamTarget = {}
Admin.GetGamerTag = {}
Admin.Menu = {}
Admin.Scalform = nil
Admin.BanHistory = {}

Admin.BlipsActive = false


Admin.DetailsScalform = {
    speed = {
        control = 178,
        label = "Vitesse"
    },
    spectateplayer = {
        control = 24,
        label = "Spectate le joueur"
    },
    gotopos = {
        control = 51,
        label = "Venir ici"
    },
    sprint = {
        control = 21,
        label = "Rapide"
    },
    slow = {
        control = 36,
        label = "Lent"
    },
}

Admin.DetailsInSpec = {
    exit = {
        control = 45,
        label = "Quitter"
    },

    openmenu = {
        control = 51,
        label = "Ouvrir le menu"
    },
}

kUtils.RegisterControlKey("handlerSpectacte", "Mode spectateur (staff)", "O", function()
    Admin:Spectate()
end)

function Admin:TeleportCoords(vector, peds)
    if not vector or not peds then return end
    local x, y, z = vector.x, vector.y, vector.z + 0.98
    peds = peds or PlayerPedId()

    RequestCollisionAtCoord(x, y, z)
    NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

    local TimerToGetGround = GetGameTimer()
    while not IsNewLoadSceneLoaded() do
        if GetGameTimer() - TimerToGetGround > 3500 then
            break
        end
        Citizen.Wait(0)
    end

    SetEntityCoordsNoOffset(peds, x, y, z)

    TimerToGetGround = GetGameTimer()
    while not HasCollisionLoadedAroundEntity(peds) do
        if GetGameTimer() - TimerToGetGround > 3500 then
            break
        end
        Citizen.Wait(0)
    end

    local retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
    TimerToGetGround = GetGameTimer()
    while not retval do
        z = z + 5.0
        retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
        Wait(0)

        if GetGameTimer() - TimerToGetGround > 3500 then
            break
        end
    end

    SetEntityCoordsNoOffset(peds, x, y, retval and GroundPosZ or z)
    NewLoadSceneStop()
    return true
end

-- Scalforms


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

function CreateScaleform(name, data) -- Créer un scalform
    if not name or string.len(name) <= 0 then return end
    local scaleform = RequestScaleformMovie(name)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    SetScaleformParams(scaleform, data)
    return scaleform
end

-- Teleport to point

function Admin:TeleporteToPoint(ped)
    local pPed = ped or PlayerPedId()
    local bInfo = GetFirstBlipInfoId(8)
    if not bInfo or bInfo == 0 then
        return
    end
    local entity = IsPedInAnyVehicle(pPed, false) and GetVehiclePedIsIn(pPed, false) or pPed
    local bCoords = GetBlipInfoIdCoord(bInfo)
    Admin:TeleportCoords(bCoords, entity)
end

-- Active Scalform

function Admin:ActiveScalform(bool)
    local dataSlots = {
        {
            name = "CLEAR_ALL",
            param = {}
        },
        {
            name = "TOGGLE_MOUSE_BUTTONS",
            param = { 0 }
        },
        {
            name = "CREATE_CONTAINER",
            param = {}
        }
    }
    local dataId = 0
    for k, v in pairs(bool and Admin.DetailsInSpec or Admin.DetailsScalform) do
        dataSlots[#dataSlots + 1] = {
            name = "SET_DATA_SLOT",
            param = {dataId, GetControlInstructionalButton(2, v.control, 0), v.label}
        }
        dataId = dataId + 1
    end
    dataSlots[#dataSlots + 1] = {
        name = "DRAW_INSTRUCTIONAL_BUTTONS",
        param = { -1 }
    }
    return dataSlots
end

-- Controls cam

function Admin:ControlInCam()
    local p10, p11 = IsControlPressed(1, 10), IsControlPressed(1, 11)
    local pSprint, pSlow = IsControlPressed(1, Admin.DetailsScalform.sprint.control), IsControlPressed(1, Admin.DetailsScalform.slow.control)
    if p10 or p11 then
        Admin.SpeedNoclip = math.max(0, math.min(100, kUtils.Round(Admin.SpeedNoclip + (p10 and 0.01 or -0.01), 2)))
    end
    if Admin.CamCalculate == nil then
        if pSprint then
            Admin.CamCalculate = Admin.SpeedNoclip * 2.0
        elseif pSlow then
            Admin.CamCalculate = Admin.SpeedNoclip * 0.1
        end
    elseif not pSprint and not pSlow then
        if Admin.CamCalculate ~= nil then
            Admin.CamCalculate = nil
        end
    end
    if IsControlJustPressed(0, Admin.DetailsScalform.speed.control) then
        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", Admin.SpeedNoclip, "", "", "", 5)
        while UpdateOnscreenKeyboard() == 0 do
            Citizen.Wait(10)
            if UpdateOnscreenKeyboard() == 1 and GetOnscreenKeyboardResult() and string.len(GetOnscreenKeyboardResult()) >= 1 then
                Admin.SpeedNoclip = tonumber(GetOnscreenKeyboardResult()) or 1.0
                break
            end
        end
    end
end

-- Manage pos cam

function Admin:ManageCam()
    local p32, p33, p35, p34 = IsControlPressed(1, 32), IsControlPressed(1, 33), IsControlPressed(1, 35), IsControlPressed(1, 34)
    local g220, g221 = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    if g220 ~= 0.0 or g221 ~= 0.0 then
        local cRot = GetCamRot(Admin.Cam, 2)
        new_z = cRot.z + g220 * -1.0 * 10.0;
        new_x = cRot.x + g221 * -1.0 * 10.0
        SetCamRot(Admin.Cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(), new_z)
    end
    if p32 or p33 or p35 or p34 then
        local rightVector, forwardVector, upVector = GetCamMatrix(Admin.Cam)
        local cPos = (GetCamCoord(Admin.Cam)) + ((p32 and forwardVector or p33 and -forwardVector or vector3(0.0, 0.0, 0.0)) + (p35 and rightVector or p34 and -rightVector or vector3(0.0, 0.0, 0.0))) * (Admin.CamCalculate ~= nil and Admin.CamCalculate or Admin.SpeedNoclip)
        SetCamCoord(Admin.Cam, cPos)
        SetFocusPosAndVel(cPos)
    end
end

-- Start spectate

function Admin:StartSpectate(player)
    Admin.CamTarget = player
    Admin.CamTarget.PedHandle = GetPlayerPed(player.id)

    NetworkSetInSpectatorMode(1, Admin.CamTarget.PedHandle)
    SetCamActive(Admin.Cam, false)
    RenderScriptCams(false, false, 0, false, false)
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(true))
    ClearFocus()
end

-- Stop spectate

function Admin:ExitSpectate()
    local pPed = PlayerPedId()
    if DoesEntityExist(Admin.CamTarget.PedHandle) then
        SetCamCoord(Admin.Cam, GetEntityCoords(Admin.CamTarget.PedHandle))
    end
    NetworkSetInSpectatorMode(0, pPed)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.CamTarget = {}
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(true))
end

function Admin:ScalformSpectate()
    if IsControlJustPressed(0, Admin.DetailsInSpec.exit.control) then
        Admin:ExitSpectate()
    end
    if IsControlJustPressed(0, Admin.DetailsInSpec.openmenu.control) then
        Admin.tId = GetPlayerServerId(Admin.CamTarget.id)
        print(Admin.tId)
        Admin:OpenPlayer(GetPlayerServerId(Admin.CamTarget.id))
    end
    if GetGameTimer() > Admin.Timer then
        Admin.Timer = GetGameTimer() + 1000
        SetFocusPosAndVel(GetEntityCoords(GetPlayerPed(Admin.CamTarget.id)))
    end
end

function Admin:SpecAndPos()
    if not Admin.CamTarget.id and IsControlJustPressed(0, Admin.DetailsScalform.spectateplayer.control) then
        local qTable = {}
        local CamCoords = GetCamCoord(Admin.Cam)
        local pId = PlayerId()
        for k, v in pairs(GetActivePlayers()) do
            local vPed = GetPlayerPed(v)
            local vPos = GetEntityCoords(vPed)
            local vDist = GetDistanceBetweenCoords(vPos, CamCoords)
            if v ~= pId and vPed and vDist <= 20 and (not qTable.pos or GetDistanceBetweenCoords(qTable.pos, CamCoords) > vDist) then
                qTable = {
                    id = v,
                    pos = vPos
                }
            end
        end
        if qTable and qTable.id then
            Admin:StartSpectate(qTable)
        end
    end
    local camActive = GetCamCoord(Admin.Cam)
    SetEntityCoords(GetPlayerPed(-1), camActive)
    if IsControlJustPressed(1, Admin.DetailsScalform.gotopos.control) then
        local camActive = GetCamCoord(Admin.Cam)
        Admin:Spectate(camActive)
    end
end

-- Render Cam

function Admin:RenderCam()
    if not NetworkIsInSpectatorMode() then
        Admin:ControlInCam()
        Admin:ManageCam()
        Admin:SpecAndPos()
    else
        Admin:ScalformSpectate()
    end
    if Admin.Scalform then
        DrawScaleformMovieFullscreen(Admin.Scalform, 255, 255, 255, 255, 0)
    end
    if GetGameTimer() > Admin.Timer2 then
        Admin.Timer2 = GetGameTimer() + 15000
    end
end

-- Create Cam

function Admin:CreateCam()
    Admin.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.Scalform = CreateScaleform("INSTRUCTIONAL_BUTTONS", Admin:ActiveScalform())
end

-- Destroy Cam

function Admin:DestroyCam()
    DestroyCam(Admin.Cam)
    RenderScriptCams(false, false, 0, false, false)
    ClearFocus()
    SetScaleformMovieAsNoLongerNeeded(Admin.Scalform)
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, Admin.CamTarget.id and GetPlayerPed(Admin.CamTarget.id) or 0)
    end
    Admin.Scalform = nil
    Admin.Cam = nil
    lockEntity = nil
    Admin.CamTarget = {}
end


-- Spectate

function Admin:Spectate(pPos)
    local player = PlayerPedId()
    local pPed = player
    Admin.InSpec = not Admin.InSpec
    Wait(0)
    if not Admin.InSpec then
        Admin:DestroyCam()
        SetEntityVisible(pPed, true, true)
        SetEntityInvincible(pPed, false)
        SetEntityCollision(pPed, true, true)
        FreezeEntityPosition(pPed, false)
        if pPos then
            SetEntityCoords(pPed, pPos)
        end
    else
        Admin:CreateCam()

        SetEntityVisible(pPed, false, false)
        SetEntityInvincible(pPed, true)
        SetEntityCollision(pPed, false, false)
        FreezeEntityPosition(pPed, true)
        SetCamCoord(Admin.Cam, GetEntityCoords(player))
        CreateThread(function()
            while Admin.InSpec do
                Wait(0)
                Admin:RenderCam()
            end
        end)
    end
end

Admin.HasGamerTag = false;
Admin.AllTags = { GAMER_NAME = 0, CREW_TAG = 1, healthArmour = 2, BIG_TEXT = 3, AUDIO_ICON = 4, MP_USING_MENU = 5, MP_PASSIVE_MODE = 6, WANTED_STARS = 7, MP_DRIVER = 8, MP_CO_DRIVER = 9, MP_TAGGED = 10, GAMER_NAME_NEARBY = 11, ARROW = 12, MP_PACKAGES = 13, INV_IF_PED_FOLLOWING = 14, RANK_TEXT = 15, MP_TYPING = 16 }
local gamerTags = {}

local staffColor = {
    [0] = {color = "0", tag = ""},
    [1] = {color = "50", tag = ""},
    [2] = {color = "51", tag = "💄"},
    [3] = {color = "208", tag = "👑"},
    [4] = {color = "170", tag = ""},
    [5] = {color = "51", tag = "💅"},
}

ShowNames = function(status)
    if status ~= nil then
        Admin.HasGamerTag = false
        for _, v in pairs(gamerTags) do
            RemoveMpGamerTag(v)
        end
        gamerTags = {}
        kUtils.ShowNotification("~r~Vous avez désactivé les noms !")
        return
    end
    Admin.HasGamerTag = true

    kUtils.ShowNotification("~g~Vous avez activé les noms !")
    whileShowName()
end

function GetPlyId(id) 
    for k, v in pairs(Admin.Players) do 
        if id == v.playerId then 
            return v
        end 
    end
end

whileShowName = function()
    Citizen.CreateThread(function()
        while Admin.HasGamerTag do
    
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed, false)
            for _, v in pairs(GetActivePlayers()) do
                local otherPed = GetPlayerPed(v)
                local staff = GetPlyId(GetPlayerServerId(v))
            
                
                if not gamerTags[v] then 
                    if staff == nil then gamerTags[v] = nil end 
                    gamerTags[v] = CreateFakeMpGamerTag(otherPed, " ["..staff.userId.."] "..GetPlayerName(v), false, false, "", 0)
               
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.AUDIO_ICON, NetworkIsPlayerTalking(v))
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.AUDIO_ICON, 255)
                    SetMpGamerTagName(gamerTags[v], "[" .. staff.userId .. "] - " .. GetPlayerName(v))
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.INV_IF_PED_FOLLOWING, not IsPedInAnyVehicle(otherPed, false))
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.INV_IF_PED_FOLLOWING, 255)
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.MP_DRIVER, GetPedInVehicleSeat(GetVehiclePedIsIn(otherPed, false), -1) == otherPed)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.MP_DRIVER, 255)
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.MP_CO_DRIVER, GetPedInVehicleSeat(GetVehiclePedIsIn(otherPed, false), 0) == otherPed)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.MP_CO_DRIVER, 255)

                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.GAMER_NAME, true)
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.healthArmour, true)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.healthArmour, 255)
                else
                    if staff == nil then gamerTags[v] = nil end    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.AUDIO_ICON, NetworkIsPlayerTalking(v))
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.AUDIO_ICON, 255)
                    SetMpGamerTagName(gamerTags[v], "[" .. staff.userId .. "] - " .. GetPlayerName(v))
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.INV_IF_PED_FOLLOWING, not IsPedInAnyVehicle(otherPed, false))
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.INV_IF_PED_FOLLOWING, 255)
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.MP_DRIVER, GetPedInVehicleSeat(GetVehiclePedIsIn(otherPed, false), -1) == otherPed)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.MP_DRIVER, 255)
    
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.MP_CO_DRIVER, GetPedInVehicleSeat(GetVehiclePedIsIn(otherPed, false), 0) == otherPed)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.MP_CO_DRIVER, 255)

                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.GAMER_NAME, true)
                    SetMpGamerTagVisibility(gamerTags[v], Admin.AllTags.healthArmour, true)
                    SetMpGamerTagAlpha(gamerTags[v], Admin.AllTags.healthArmour, 255)
                end 

              
            end
            Wait(1.0)
        end
    end)
end

function Admin:SetInvisible()
    Citizen.CreateThread(function()
        while Player.IsInvisible do 
            Citizen.Wait(1.0)
            SetLocalPlayerInvisibleLocally(true)
        end
    end)
end

RegisterNetEvent("admin:deleteEntities")
AddEventHandler("admin:deleteEntities", function(number)
    local pPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(pPed)
    local pCallback = {}
    local vehicles = kUtils.GetVehiclesInArea(pCoords, number)

    for k, v in pairs(vehicles) do
        table.insert(pCallback, VehToNet(v))
    end

    TriggerServerEvent("admin:plyManager", 2, 2, pCallback)
    kUtils.ShowNotification("Vous avez effacé tout les véhicules aux alentours de ~b~" .. number .. "m")
end)

RegisterNetEvent("admin:asyncChat")
AddEventHandler("admin:asyncChat", function(staff, msg)
    kUtils.ShowNotification("~b~Message staff\n~s~"..msg)
    cooldownActive = true
    isReply = false
    answerToStaff(staff)
end)

function answerToStaff(staff)
    Citizen.CreateThread(function()
        while cooldownActive do
            Citizen.Wait(30*1000)

            if cooldownActive then
                TriggerServerEvent("kFw:tooLongReplyStaff", staff)
                kUtils.ShowNotification("~r~Vous n'avez pas répondu au staff !")
            end

            cooldownActive = false
            isReply = nil
            if not cooldownActive then
                break
            end
        end
    end)

    Citizen.CreateThread(function()
        while isReply ~= nil do
            Citizen.Wait(1.0)

            if IsControlJustPressed(1, 51) then
                a = kUtils.KeyboardInput("KERNIOZ_TEST", "~o~Message", "", 200)
                a = tostring(a)
                if a ~= "nil" then
                    if type(a) == 'string' then
                        isReply = nil
                        cooldownActive = false
                        TriggerServerEvent("kFw:replyToStaff", staff, a)
                    end
                else
                    kUtils.ShowNotification("~r~Recherche invalide/annulée")
                end
            end
        end
    end)
end


playerFreeze = false
RegisterNetEvent("kFw:freezeEntityPlayer")
AddEventHandler("kFw:freezeEntityPlayer", function() 
    playerFreeze = not playerFreeze
    freezePlayerWhile()
end)

freezePlayerWhile = function() 
    local pPed = GetPlayerPed(-1)
    if not playerFreeze then FreezeEntityPosition(pPed, 0)  end
    
    Citizen.CreateThread(function() 
        while playerFreeze do 
            Citizen.Wait(1.0)
            local pPed = GetPlayerPed(-1)
            FreezeEntityPosition(pPed, 1)

            if not playerFreeze then 
                FreezeEntityPosition(pPed, 0)
                break
            end 
        end 
    end)
end