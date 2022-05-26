QBCore = exports['qb-core']:GetCoreObject()

function GetClosestHouse(source)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(source))
    local ClosestHouse
    for i = 1, #Config.OpenHouses do
        if #(PlayerCoords - Config.OpenHouses[i].center) <= 30 then
            if ClosestHouse then
                if #(PlayerCoords - Config.OpenHouses[i].center) < #(PlayerCoords - ClosestHouse.center) then
                    ClosestHouse = Config.OpenHouses[i]
                end
            else
                ClosestHouse = Config.OpenHouses[i]
            end
        end
    end
    return ClosestHouse
end

CreateThread(function()
    local Lenght = GetResourceKvpInt("Housescount") or 0
    for i = 1, Lenght do
        House = json.decode(GetResourceKvpString('Openhouse_'..tostring(i)))
        Config.OpenHouses[i] = {
            house = House.house,
            owner = House.owner,
            doors = House.doors,
            keyholders = House.keyholders,
            center = vector3(House.center.x, House.center.y, House.center.z),
            stash = House.stash,
            outfit = House.outfit,
            logout = House.logout,
            garage = House.garage
        }
        print(Config.OpenHouses[i].center)
    end
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)
