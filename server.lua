local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("createopenhouse", Lang:t("info.create_house"), {{name = "House Name", help = Lang:t("info.name_of_house")}, {name = "Owner CID", help = Lang:t("info.owner_cid")}}, true, function(source, args)
    local src = source
    local HouseName = tostring(args[1])
    local OwnerCID = tostring(args[2])
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    Config.OpenHouses[HouseName] = {
        owner = OwnerCID,
        doors = {},
        keyholders = {},
        center = PlayerCoords,
        stash = nil,
        outfit = nil,
        logout = nil,
        garage = nil
    }
end, 'admin')
