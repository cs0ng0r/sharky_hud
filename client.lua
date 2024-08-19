RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer)
  ESX.PlayerData = xPlayer
end)


CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = GetPlayerPed(-1)
        local health = GetEntityHealth(playerPed) - 100
        local armor = GetPedArmour(playerPed)
        local cash = 0
        local accounts = ESX.PlayerData.accounts

        for _, accounts in pairs(accounts) do
            if accounts.name == 'money' then
                cash = accounts.money
            end
        end


        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                hunger = hunger.getPercent()
                thirst = thirst.getPercent()

                -- Calculate percentages
                local healthPercentage = math.max(0, math.min(100, (health / 100) * 100))
                local armorPercentage = math.max(0, math.min(100, (armor / 100) * 100))
                local hungerPercentage = math.max(0, math.min(100, (hunger / 100) * 100))
                local thirstPercentage = math.max(0, math.min(100, (thirst / 100) * 100))

                -- Send the updated data to the NUI (HUD)
                SendNUIMessage({
                    type = "hudUpdate",
                    username = ESX.PlayerData.name,
                    id = GetPlayerServerId(PlayerId()),
                    job = ESX.PlayerData.job.label,
                    health = healthPercentage,
                    money = cash,
                    armor = armorPercentage,
                    hunger = hungerPercentage,
                    thirst = thirstPercentage
                })
            end)
        end)
    end
end)

