Commands = {}

Commands.Register = {}
Commands.Register.__index = Commands.Register

setmetatable(Commands.Register, {
    __call = function(_, commandName, handler, restricted)
        local self = setmetatable({}, Commands.Register)
        zFw:Logger("Commands", commandName .. " has been registered")
        RegisterCommand(commandName, function(source, args, rawCommand)     
            if restricted then 
                local plySource = source
                if plySource == 0 then 
                    handler(source, args, rawCommand)
                else
                    local plyDb = Admin.ESX.GetPlayerFromId(source)
                    if Commands:haveAccess(plyDb.group, tbl) then 
                        handler(source, args, rawCommand)
                    end 
                end 
            else
                handler(source, args, rawCommand)
            end 
        end, false)
        

        return self
    end
})


function Commands:haveAccess(group, tbl)
    for k, v in pairs(tbl) do 
        if group == v then 
            return true
        end 
    end 
    return false  
end
