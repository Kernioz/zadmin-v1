cfg_staff = {}

cfg_staff.indexHandler = {
    infoPer = 1
}
cfg_staff.filterHandler = {
    filter = nil,
    filterPlayer = nil,
    filterName = ""
}

cfg_staff.Settings = {
    ZoneOnly = false
}

function haveFiltre(filtre)
    if cfg_staff.filterHandler.filter ~= nil then 
        local resultat = "Filter : " .. cfg_staff.filterHandler.filter
        return resultat
    else
        return "No filter"
    end 
end

