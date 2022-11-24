RMenu.Add('kernioz', 'main_menu_staff', RageUI.CreateMenu("Admin", "Menu options", 1, 100))
RMenu:Get('kernioz', 'main_menu_staff').Closed = function()
    Player.InMenu = false
end

RMenu.Add('kernioz', 'main_menu_staff_servers', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))


RMenu.Add('kernioz', 'main_menu_staff_ranks', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_servers'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_ranks_interact', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_ranks'), "Admin", "Menu options"))

RMenu.Add('kernioz', 'main_menu_staff_myped', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))

RMenu.Add('kernioz', 'main_menu_staff_players', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_players_interact', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_players'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_players_interact_warnslist', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_players_interact'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_players_interact_history', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_players_interact'), "Admin", "Menu options"))

RMenu.Add('kernioz', 'main_menu_staff_world', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_others', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_vehicles', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_list', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff_players'), "Admin", "Menu options"))
RMenu.Add('kernioz', 'main_menu_staff_banlist', RageUI.CreateSubMenu(RMenu:Get('kernioz', 'main_menu_staff'), "Admin", "Menu options"))

kUtils.RegisterControlKey("handlerStaff", "Menu staff", "F10", function()
    Admin:OpenMenu()
end)

local wantConfirm = false
function Admin:OpenMenu()
    if Player.InMenu then 
        Player.InMenu = false
        RageUI.CloseAll()
        return
    else
        Player.InMenu = true
        RageUI.Visible(RMenu:Get('kernioz', 'main_menu_staff'), true)
      
        Citizen.CreateThread(function()
            while Player.InMenu do
                Citizen.Wait(1.0)

                RageUI.IsVisible(RMenu:Get('kernioz', 'main_menu_staff'), true, false, true, function()
                   -- RageUI.Separator("~g~" .. #Admin.Players .. "~s~ joueurs en ligne")
                    RageUI.ButtonWithStyle(" Players list", nil, {RightLabel = "→"}, true, function(_, _, s)
                        if s then
                            TriggerServerCallback("players:getPlayers", function(cb)
                                Admin.Players = cb
                            end)
                        end
                    end, RMenu:Get('kernioz', 'main_menu_staff_players'))

                    RageUI.ButtonWithStyle(" My player", nil, {RightLabel = "→"}, true, function(f, g, s) end, RMenu:Get('kernioz', 'main_menu_staff_myped'))
                    RageUI.ButtonWithStyle(" Vehicles", nil, {RightLabel = "→"}, true, function(f, g, s) end, RMenu:Get('kernioz', 'main_menu_staff_vehicles'))
                end)

                RageUI.IsVisible(RMenu:Get('kernioz', 'main_menu_staff_myped'), true, false, true, function() 
                    RageUI.Checkbox(" GodMode", nil, Player.IsInvincible, {}, function(Hovered, Selected, Active, Checked)
                        if (Active) then
                   
                        end
                    end, function()
                        Player.IsInvincible = true
                        NetworkSetLocalPlayerInvincibleTime(9999)
                        SetEntityInvincible(Player.Ped, true)
                    end, function()
                        Player.IsInvincible = false
                       NetworkSetLocalPlayerInvincibleTime(0)
                       SetEntityInvincible(Player.Ped, false)
                   end)
                    RageUI.Checkbox(" Visible", nil, Player.IsInvisible, {}, function(Hovered, Selected, Active, Checked)
                        if (Active) then
                    
                        end
                    end, function()
                  
                        Player.IsInvisible = not Player.IsInvisible
                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), Player.IsInvisible)
                        SetEntityVisible(PlayerPedId(), not Player.IsInvisible, false)

                        kUtils.ShowNotification("~g~Vous avez activé le mode invisible")

                        Admin:Invisible()
                    end, function()
                        Player.IsInvisible = not Player.IsInvisible
                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), Player.IsInvisible)
                        SetEntityVisible(PlayerPedId(), not Player.IsInvisible, false)
             
                        kUtils.ShowNotification("~r~Vous avez désactivé le mode invisible")
                    end)
                    RageUI.Checkbox(" Noclip", nil, Admin.InSpec, {}, function(Hovered, Selected, Active, Checked)
                        if (Active) then

                        end
                    end, function()
                        Admin:Spectate()
                        kUtils.ShowNotification("~g~Vous avez activé le mode spectateur")
             
                    end, function()
                        Admin:Spectate()
                        kUtils.ShowNotification("~r~Vous avez désactivé le mode spectateur")
             
                    end)
                end)

                
                RageUI.IsVisible(RMenu:Get('kernioz', 'main_menu_staff_players'), true, false, true, function() 
                    RageUI.ButtonWithStyle(" Filtrer", haveFiltre(cfg_staff.filterHandler.filtrerName), { RightLabel = "🔎" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            cfg_staff.filterHandler.filtrer = nil
                            a = kUtils.KeyboardInput("KERNIOZ_TEST", "~o~Search ?", "", 200)
                            a = tostring(a)
                            if a ~= "nil" then
                                if type(a) == 'string' then
                                    cfg_staff.filterHandler.filtrer = a
                                    cfg_staff.filterHandler.filtrerName = a
                                    cfg_staff.filterHandler.filtrer = cfg_staff.filterHandler.filtrer:sub(1, -2)
                                    cfg_staff.filterHandler.filtrer = string.lower(cfg_staff.filterHandler.filtrer)
                                end
                            else
                                cfg_staff.filterHandler.filtrer = nil
                                kUtils.ShowNotification("~r~Recherche invalide/annulée")
                           
                            end
                        end
                    end)
                    
                    if cfg_staff.filterHandler.filtrer ~= nil then 
                        RageUI.ButtonWithStyle(" Delete filter", nil, { RightLabel = "❌" }, true, function(_, _, s)
                            if s then 
                                cfg_staff.filterHandler.filtrer = nil
                            end 
                        end)
                    end
               
                    for k, v in pairs(Admin.Players) do
                        if cfg_staff.filterHandler.filtrer ~= nil then 
                            noLabel = v.playerName
                            v.playerName = string.lower(v.playerName)
                            if string.sub(v.playerName, 1, string.len(cfg_staff.filterHandler.filtrer)) == cfg_staff.filterHandler.filtrer then
                                RageUI.ButtonWithStyle(" " ..noLabel .. " (" .. v.userId .. ") ", nil, {RightLabel = "→"}, true, function(_, _, s) 
                                    if s then
                                        Admin.targetId = {
                                            playerName = noLabel,
                                            player = v,
                                            serverId = v.playerId,
                                            userId = v.userId
                                        }
                                    end 
                                end, RMenu:Get('kernioz', 'main_menu_staff_players_interact'))
                            end
                        else
                            if v.playerName == nil then Admin.Players[k] = nil end 
                            RageUI.ButtonWithStyle(" " ..v.playerName .. " (" .. v.userId .. ")", nil, {RightLabel = "→"}, true, function(_, _, s) 
                                if s then 
                                    Admin.targetId = {
                                        playerName = v.playerName,
                                        player = v,
                                        serverId = v.playerId,
                                        userId = v.userId,
                                    }
                                end 
                            end, RMenu:Get('kernioz', 'main_menu_staff_players_interact'))
                        end 
                    end 
                end)

                RageUI.IsVisible(RMenu:Get('kernioz', 'main_menu_staff_players_interact'), true, false, true, function() 
                    RageUI.ButtonWithStyle("~r~ (" .. Admin.targetId.userId .. ") - " .. Admin.targetId.playerName, nil, {RightLabel = ""}, true, function(_, _, s) end)

                    RageUI.ButtonWithStyle(" Envoyer un messagé privé", nil, {RightLabel = ""}, true, function(_, _, s)
                        if s then 
                            kUtils.AskEntry(function(msg)
                                if msg == nil then
                                    kUtils.ShowNotification("~r~Veuillez insérer un message !")
                                    return
                                end

                                ExecuteCommand("mp " .. Admin.targetId.userId .. " " .. msg)
                            end, "~q~Message au joueur")
                        end 
                    end)
                    RageUI.ButtonWithStyle(" Spectate ", nil, {RightLabel = ""}, true, function(_, _, s)
                        if s then
                            if not Admin.InSpec then
                                kUtils.ShowNotification("~r~Vous devez être en mode spectateur !")
                                return
                            end
                            if not DoesEntityExist(GetPlayerPed(GetPlayerFromServerId(Admin.targetId.serverId))) then
                                kUtils.ShowNotification("~r~Le joueur est trop loin !")
                                return
                            end

                            if Admin.CamTarget and Admin.CamTarget.id then
                                Admin:ExitSpectate()
                            end
                            Admin:StartSpectate(Admin.targetId)
                        end
                    end)
                    RageUI.ButtonWithStyle(" Goto", nil, {RightLabel = ""}, true, function(_, _, s) 
                        if s then 
                            ExecuteCommand("goto " .. Admin.targetId.serverId)
                        end
                    end)
                    RageUI.ButtonWithStyle(" Bring", nil, {RightLabel = ""}, true, function(_, _, s) 
                        if s then 
                            ExecuteCommand("bring " .. Admin.targetId.serverId)
                        end
                    end)
                    
                    RageUI.List(" Information", {"UUID", "Discord", "License", "Tout"}, cfg_staff.indexHandler.infoPer, nil, {}, true, {
                        onListChange = function(Index, Item)
                            cfg_staff.indexHandler.infoPer = Index
                        end,

                        onSelected = function(Index, Item)
                            if Index == 1 then
                                ExecuteCommand("getinfo " .. Admin.targetId.serverId .. " uuid")
                            elseif Index == 2 then
                                ExecuteCommand("getinfo " .. Admin.targetId.serverId .. " discord")
                            elseif Index == 3 then
                                ExecuteCommand("getinfo " .. Admin.targetId.serverId .. " license")
                            elseif Index == 4 then
                                ExecuteCommand("getinfo " .. Admin.targetId.serverId .. " all")
                            end
                        end,
                    })
                   
                    RageUI.ButtonWithStyle(" Freeze le joueur", nil, {RightLabel = ""}, true, function(_, _, s) 
                        if s then 
                            ExecuteCommand("freeze " .. Admin.targetId.serverId)
                        end 
                    end)
                    RageUI.ButtonWithStyle(" Screenshot", nil, {RightLabel = ""}, true, function(_, _, s) 
                        if s then 
                            ExecuteCommand("screen " .. Admin.targetId.userId)
                        end 
                    end)
                end)


                RageUI.IsVisible(RMenu:Get('kernioz', 'main_menu_staff_vehicles'), true, false, true, function() 
                    RageUI.ButtonWithStyle(" Supprimer les véhicules à proximité (50m)", nil, {RightLabel = ""}, true, function(_, _, s) 
                        if s then 
                            ExecuteCommand("dv 50")
                        end 
                    end)
                end)
            end 
        end)
    end
end

