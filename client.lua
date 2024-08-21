-- Event handler for when ESX player data is loaded
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

-- Thread to periodically update player HUD data
CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local health = GetEntityHealth(playerPed) - 100
        local armor = GetPedArmour(playerPed)
        local cash = 0
        local accounts = ESX.PlayerData.accounts

        -- Retrieve player's cash amount from account data
        for _, account in pairs(accounts) do
            if account.name == 'money' then
                cash = account.money
            end
        end

        -- Retrieve hunger and thirst statuses
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                hunger = hunger.getPercent()
                thirst = thirst.getPercent()

                -- Calculate percentages for HUD display
                local healthPercentage = math.max(0, math.min(100, (health / 100) * 100))
                local armorPercentage = math.max(0, math.min(100, (armor / 100) * 100))
                local hungerPercentage = math.max(0, math.min(100, (hunger / 100) * 100))
                local thirstPercentage = math.max(0, math.min(100, (thirst / 100) * 100))
                local id = GetPlayerServerId(PlayerId())

                -- Fetch additional player data from server
                ESX.TriggerServerCallback('sharky_hud:fetchData', function(data)
                    -- Send updated HUD data to NUI
                    SendNUIMessage({
                        type = "hudUpdate",
                        username = data.name,
                        id = id,
                        job = data.job,
                        health = healthPercentage,
                        money = cash,
                        armor = armorPercentage,
                        hunger = hungerPercentage,
                        thirst = thirstPercentage,
                        time = data.time
                    })
                end)
            end)
        end)
    end
end)

-- Thread to manage vehicle speed and seatbelt status
CreateThread(function()
    local lastVehicleState = false
    local lastSpeed = 0

    while true do
        Citizen.Wait(100)

        local playerPed = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(playerPed, false)

        if isInVehicle then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert m/s to km/h

            -- Update speedometer only if vehicle state or speed has changed significantly
            if not lastVehicleState or math.abs(speed - lastSpeed) > 1 then
                SendNUIMessage({
                    type = "speedUpdate",
                    speed = speed,
                    isInVehicle = true,
                })
                lastSpeed = speed
            end
        else
            -- Hide speedometer when the player exits the vehicle
            if lastVehicleState then
                SendNUIMessage({
                    type = "speedUpdate",
                    isInVehicle = false
                })
            end
        end

        lastVehicleState = isInVehicle
    end
end)

