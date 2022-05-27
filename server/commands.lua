QBCore.Commands.Add('createopenhouse', Lang:t('command.create_house'), {{name = 'House Name', help = Lang:t('command.name_of_house')}, {name = 'Owner CID | ID', help = Lang:t('command.owner_cid')}}, true, function(source, args)
    local src = source
    local HouseName = tostring(args[1])
    local OwnerCID = QBCore.Functions.GetPlayer(tonumber(args[2])).PlayerData.citizenid or tostring(args[2])
    local Owner = QBCore.Functions.GetPlayerByCitizenId(OwnerCID)
    if not Owner then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.owner_not_found'), 'error') return end
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local AmountOfHouses = (GetResourceKvpInt("Housescount") or 0) + 1
    Config.OpenHouses[AmountOfHouses] = {
        house = HouseName,
        owner = OwnerCID,
        doors = {},
        keyholders = {},
        center = PlayerCoords,
        stash = vector3(0, 0, -150),
        outfit = vector3(0, 0, -150),
        logout = vector3(0, 0, -150),
        garage = vector3(0, 0, -150)
    }
    SetResourceKvp('Openhouse_'..tostring(AmountOfHouses), json.encode(Config.OpenHouses[AmountOfHouses]))
    SetResourceKvpInt('Housescount', AmountOfHouses)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.create_house', {house = HouseName, owner = Owner.PlayerData.charinfo.firstname}), 'success')
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end, 'admin')

QBCore.Commands.Add('deleteallhouses', Lang:t('command.delete_all'), {}, false, function(source)
    local Lenght = GetResourceKvpInt("Housescount") or 0
    for i = 1, Lenght do
        DeleteResourceKvpNoSync('Openhouse_'..tostring(i))
    end
    TriggerClientEvent('QBCore:Notify', source, Lang:t('info.deleted_houses', {amount = Lenght}))
    SetResourceKvpIntNoSync('Housescount', 0)
    FlushResourceKvp()
    Config.OpenHouses = {}
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end, 'god')

QBCore.Commands.Add('addstash', Lang:t('command.create_stash'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ClosestHouseIndex = GetClosestHouse(src)
    local ClosestHouse = Config.OpenHouses[ClosestHouseIndex]

    if not ClosestHouse then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_nearby_house'), 'error') return end
    if Player.PlayerData.citizenid ~= ClosestHouse.owner and not QBCore.Functions.HasPermission(src, 'admin') then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_perms'), 'error') return end

    local House = json.decode(GetResourceKvpString('Openhouse_'..tostring(ClosestHouseIndex)))
    Config.OpenHouses[ClosestHouseIndex] = {
        house = House.house,
        owner = House.owner,
        doors = House.doors,
        keyholders = House.keyholders,
        center = vector3(House.center.x, House.center.y, House.center.z),
        stash = GetEntityCoords(GetPlayerPed(src)),
        outfit = vector3(House.outfit.x, House.outfit.y, House.outfit.z),
        logout = vector3(House.logout.x, House.logout.y, House.logout.z),
        garage = vector3(House.garage.x, House.garage.y, House.garage.z)
    }
    SetResourceKvp('Openhouse_'..tostring(ClosestHouseIndex), json.encode(Config.OpenHouses[ClosestHouseIndex]))
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.create_stash', {house = Config.OpenHouses[ClosestHouseIndex].house}), 'success')
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)

QBCore.Commands.Add('addoutfit', Lang:t('command.create_outfit'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ClosestHouseIndex = GetClosestHouse(src)
    local ClosestHouse = Config.OpenHouses[ClosestHouseIndex]

    if not ClosestHouse then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_nearby_house'), 'error') return end
    if Player.PlayerData.citizenid ~= ClosestHouse.owner and not QBCore.Functions.HasPermission(src, 'admin') then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_perms'), 'error') return end

    local House = json.decode(GetResourceKvpString('Openhouse_'..tostring(ClosestHouseIndex)))
    Config.OpenHouses[ClosestHouseIndex] = {
        house = House.house,
        owner = House.owner,
        doors = House.doors,
        keyholders = House.keyholders,
        center = vector3(House.center.x, House.center.y, House.center.z),
        stash = vector3(House.stash.x, House.stash.y, House.stash.z),
        outfit = GetEntityCoords(GetPlayerPed(src)),
        logout = vector3(House.logout.x, House.logout.y, House.logout.z),
        garage = vector3(House.garage.x, House.garage.y, House.garage.z)
    }
    SetResourceKvp('Openhouse_'..tostring(ClosestHouseIndex), json.encode(Config.OpenHouses[ClosestHouseIndex]))
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.create_outfit', {house = Config.OpenHouses[ClosestHouseIndex].house}), 'success')
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)

QBCore.Commands.Add('addlogout', Lang:t('command.create_logout'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ClosestHouseIndex = GetClosestHouse(src)
    local ClosestHouse = Config.OpenHouses[ClosestHouseIndex]

    if not ClosestHouse then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_nearby_house'), 'error') return end
    if Player.PlayerData.citizenid ~= ClosestHouse.owner and not QBCore.Functions.HasPermission(src, 'admin') then TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_perms'), 'error') return end

    local House = json.decode(GetResourceKvpString('Openhouse_'..tostring(ClosestHouseIndex)))
    Config.OpenHouses[ClosestHouseIndex] = {
        house = House.house,
        owner = House.owner,
        doors = House.doors,
        keyholders = House.keyholders,
        center = vector3(House.center.x, House.center.y, House.center.z),
        stash = vector3(House.stash.x, House.stash.y, House.stash.z),
        outfit = vector3(House.outfit.x, House.outfit.y, House.outfit.z),
        logout = GetEntityCoords(GetPlayerPed(src)),
        garage = vector3(House.garage.x, House.garage.y, House.garage.z)
    }
    SetResourceKvp('Openhouse_'..tostring(ClosestHouseIndex), json.encode(Config.OpenHouses[ClosestHouseIndex]))
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.create_logout', {house = Config.OpenHouses[ClosestHouseIndex].house}), 'success')
    Wait(50)
    TriggerClientEvent('dc-open-houses:client:sync', -1, Config.OpenHouses)
end)
