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
        Config.OpenHouses[i] = json.decode(GetResourceKvpString('Openhouse_'..tostring(i)))
    end
end)
