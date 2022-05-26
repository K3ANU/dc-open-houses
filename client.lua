local QBCore = exports['qb-core']:GetCoreObject()
local ClosestHouse

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

--- Check if the player is nearby an open house. To prevent all the other threads to keep running all the time.
--- If you have really big houses increase the range down below at line 11.
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
                    end
                else
                    ClosestHouse = Config.OpenHouses[i]
                end
            end
        end
        if not Nearby then ClosestHouse = nil end
        Wait(2500)
    end
end)

CreateThread(function()
    while true do
        local WaitTime
        if ClosestHouse then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            WaitTime = 700
            if #(PlayerCoords - ClosestHouse.stash) <= 1.8 then
                WaitTime = 0
                DrawText3D(ClosestHouse.stash.x, ClosestHouse.stash.y, ClosestHouse.stash.z + 0.5, '~o~E~w~ - '..Lang:t('text.open_stash'))
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Notify('TextHere', 'error', 7500)
                end
            elseif #(PlayerCoords - ClosestHouse.outfit) <= 1.8 then
                WaitTime = 0
                DrawText3D(ClosestHouse.outfit.x, ClosestHouse.outfit.y, ClosestHouse.outfit.z + 0.5, '~o~E~w~ - '..Lang:t('text.change_outfit'))
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Notify('TextHere', 'error', 7500)
                end
            elseif #(PlayerCoords - ClosestHouse.logout) <= 1.8 then
                WaitTime = 0
                DrawText3D(ClosestHouse.logout.x, ClosestHouse.logout.y, ClosestHouse.logout.z + 0.5, '~o~E~w~ - '..Lang:t('text.change_char'))
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Notify('TextHere', 'error', 7500)
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
end)
