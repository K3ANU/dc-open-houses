QBCore = exports['qb-core']:GetCoreObject()

function GetClosestHouse(source)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(source))
    local ClosestHouseIndex
    for i = 1, #Config.OpenHouses do
        if #(PlayerCoords - Config.OpenHouses[i].center) <= 30 then
            if ClosestHouseIndex then
                if #(PlayerCoords - Config.OpenHouses[i].center) < #(PlayerCoords - Config.OpenHouses[ClosestHouseIndex].center) then
                    ClosestHouseIndex = i
                end
            else
                ClosestHouseIndex = i
            end
        end
    end
    return ClosestHouseIndex
end

CreateThread(function()
    local Lenght = GetResourceKvpInt("Housescount") or 0
    for i = 1, Lenght do
        local House = json.decode(GetResourceKvpString('Openhouse_'..tostring(i)))
        Config.OpenHouses[i] = {
            house = House.house,
            owner = House.owner,
            doors = House.doors,
            keyholders = House.keyholders,
            center = vector3(House.center.x, House.center.y, House.center.z),
            stash = vector3(House.stash.x, House.stash.y, House.stash.z),
            outfit = vector3(House.outfit.x, House.outfit.y, House.outfit.z),
            logout = vector3(House.logout.x, House.logout.y, House.logout.z),
            garage = vector3(House.garage.x, House.garage.y, House.garage.z)
        }
    end
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)

AddEventHandler('playerJoining', function(source)
    TriggerClientEvent('dc-open-houses:client:sync', source, Config.OpenHouses)
end)
