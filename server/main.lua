QBCore = exports['qb-core']:GetCoreObject()

function GetClosestHouseIndex(source)
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

function IsKeyholder(CitizenID, House)
    for i = 1, #House.keyholders do
        if House.keyholders[i] == CitizenID then
            return true
        end
    end
    return false
end

RegisterNetEvent('dc-open-houses:server:DoorInteract', function(HouseIndex, DoorIndex, LockState)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local House = Config.OpenHouses[HouseIndex]

    if #(PlayerCoords - House.doors[DoorIndex].coords) > 5 then return end
    if not IsKeyholder(Player.PlayerData.citizenid, House) and Player.PlayerData.citizenid ~= House.owner then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_keyholder'), 'error') return end

    House.doors[DoorIndex].locked = LockState
    SetResourceKvp('Openhouse_'..tostring(HouseIndex), json.encode(House))
    TriggerEvent('qb-doorlock:server:updateState', House.doors[DoorIndex].name, LockState, false, false, true, true, true, src)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)

CreateThread(function()
    local Lenght = GetResourceKvpInt("Housescount") or 0
    local Doors = {}
    for i = 1, Lenght do
        local House = json.decode(GetResourceKvpString('Openhouse_'..tostring(i)))
        for b = 1, #House.doors do
            Doors[b] = {
                name = House.doors[b].name,
                coords = vector3(House.doors[b].coords.x, House.doors[b].coords.y, House.doors[b].coords.z),
                locked = true
            }
        end
        Config.OpenHouses[i] = {
            house = House.house,
            owner = House.owner,
            doors = Doors,
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
