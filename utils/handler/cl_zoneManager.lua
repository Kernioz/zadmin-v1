Zone = Zone or {}
Zone.List = {}

function Zone:Register(tbl)
    return table.insert(Zone.List, tbl)
end

Citizen.CreateThread(function()
    kUtils.Logger("Zone Manager", "Zone Loop has been loaded")
    while PLAYER.INIT == nil do Citizen.Wait(1.0) end 
    while true do 
        local pPosition, isNear = PLAYER.Pos, false
        
        for k, v in pairs(Zone.List) do
            local sizePoint = v.size or 2.5
            local drawMarker = v.drawMarker or false
            local drawText = v.drawText or false
            local message = v.pointName or nil

            local distanceBetween = GetDistanceBetweenCoords(pPosition, v.position, false)

            if distanceBetween <= sizePoint then 
                isNear = true
                if drawText then 
                    kUtils.DrawText3D(v.position.x, v.position.y, v.position.z + 1.10, message)
                else
                    kUtils.ShowHelpNotification(message)
                end 
                
                if drawMarker then
                    DrawMarker(6, v.position, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 190, 246, 100, false, true, 2, false, false, false, false)
                end 
              
                if IsControlJustReleased(1, 51) then
                    v.action() 
                end 
            end 
        end 
        
        if isNear then Citizen.Wait(1.0) else Citizen.Wait(500.0) end 
    end 
end)


function Zone:Remove(id)
    for k, v in pairs(Zone.List) do 
        if v.id == id then 
            Zone[k] = nil
        end 
    end 
end