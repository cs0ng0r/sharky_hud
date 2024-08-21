ESX.RegisterServerCallback('sharky_hud:fetchData', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    data = {
        name = player.getName(),
        money = player.getMoney(),
        job = player.getJob().label,
        time = os.date('%H:%M', os.time())
    }

    cb(data)
end)

