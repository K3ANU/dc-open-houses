local QBCore = exports['qb-core']:GetCoreObject()
local ClosestHouse
local ClosestHouseIndex
local Blips = {}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function CreateHouseBlip(coords, name)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 40)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local CitizenID = QBCore.Functions.GetPlayerData().citizenid
    for i = 1, #Config.OpenHouses do
        if Config.OpenHouses[i].owner == CitizenID then
            local House = Config.OpenHouses[i]
            Blips[#Blips+1] = CreateHouseBlip(House.center, House.house)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    for i = 1, #Blips do
        RemoveBlip(Blips[i])
    end
end)

RegisterNetEvent('dc-open-houses:client:CreateBlip', function(HouseCoords, HouseName)
    Blips[#Blips+1] = CreateHouseBlip(HouseCoords, HouseName)
end)

RegisterNetEvent('dc-open-houses:client:DeleteBlip', function(HouseCoords)
    for i = 1, #Blips do
        if GetBlipCoords(Blips[i]) == HouseCoords then
            RemoveBlip(Blips[i])
            table.remove(Blips, i)
            break
        end
    end
end)

--- Check if the player is nearby an open house. To prevent all the other threads to keep running all the time.
--- If you have really big houses increase the range down below.
CreateThread(function()
    while true do
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local Nearby = false
        for i = 1, #Config.OpenHouses do
            if #(PlayerCoords - Config.OpenHouses[i].center) <= 30 then
                Nearby = true
                if ClosestHouse then
                    if #(PlayerCoords - Config.OpenHouses[i].center) < #(PlayerCoords - ClosestHouse.center) then
                        ClosestHouse = Config.OpenHouses[i]
                        ClosestHouseIndex = i
                    end
                else
                    ClosestHouse = Config.OpenHouses[i]
                    ClosestHouseIndex = i
                end
            end
        end
        if not Nearby then ClosestHouse = nil end
        Wait(1500)
    end
end)

CreateThread(function()
    while true do
        local WaitTime
        if ClosestHouse then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            WaitTime = 700
            if #(PlayerCoords - ClosestHouse.stash) <= 1.6 then
                WaitTime = 0
                DrawText3D(ClosestHouse.stash.x, ClosestHouse.stash.y, ClosestHouse.stash.z, '~o~E~w~ - '..Lang:t('text.open_stash'))
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", ClosestHouse.house)
                    TriggerEvent("inventory:client:SetCurrentStash", ClosestHouse.house)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
                end
            elseif #(PlayerCoords - ClosestHouse.outfit) <= 1.6 then
                WaitTime = 0
                DrawText3D(ClosestHouse.outfit.x, ClosestHouse.outfit.y, ClosestHouse.outfit.z, '~o~E~w~ - '..Lang:t('text.change_outfit'))
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
                    TriggerEvent('qb-clothing:client:openOutfitMenu')
                end
            elseif #(PlayerCoords - ClosestHouse.logout) <= 1.6 then
                WaitTime = 0
                DrawText3D(ClosestHouse.logout.x, ClosestHouse.logout.y, ClosestHouse.logout.z, '~o~E~w~ - '..Lang:t('text.change_char'))
                if IsControlJustPressed(0, 38) then
                    DoScreenFadeOut(250)
                    while not IsScreenFadedOut() do Wait(0) end
                    TriggerServerEvent('qb-houses:server:LogoutLocation')
                end
            end
        else
            WaitTime = 2000
        end
        Wait(WaitTime)
    end
end)

CreateThread(function()
    while true do
        local WaitTime
        if ClosestHouse then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            WaitTime = 700
            for i = 1, #ClosestHouse.doors do
                if #(PlayerCoords - ClosestHouse.doors[i].coords) <= 1.6 then
                    WaitTime = 0
                    if ClosestHouse.doors[i].locked then
                        DrawText3D(ClosestHouse.doors[i].coords.x, ClosestHouse.doors[i].coords.y, ClosestHouse.doors[i].coords.z, '~o~E~w~ - '..Lang:t('text.open_door'))
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('dc-open-houses:server:DoorInteract', ClosestHouseIndex, i, false)
                        end
                    else
                        DrawText3D(ClosestHouse.doors[i].coords.x, ClosestHouse.doors[i].coords.y, ClosestHouse.doors[i].coords.z, '~o~E~w~ - '..Lang:t('text.close_door'))
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('dc-open-houses:server:DoorInteract', ClosestHouseIndex, i, true)
                        end
                    end
                end
            end
        else
            WaitTime = 2000
        end
        Wait(WaitTime)
    end
end)

RegisterNetEvent('dc-open-houses:client:sync', function(ServerConfig)
    Config.OpenHouses = ServerConfig
    if Config.OpenHouses[ClosestHouseIndex] ~= ClosestHouse then ClosestHouse = Config.OpenHouses[ClosestHouseIndex] end
end)
