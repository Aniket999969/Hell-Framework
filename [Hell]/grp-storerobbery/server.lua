GRPCore = nil
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

local deadPeds = {}

RegisterServerEvent('grp-storerobbery:pedDead')
AddEventHandler('grp-storerobbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('grp-storerobbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('grp-storerobbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('grp-storerobbery:handsUp')
AddEventHandler('grp-storerobbery:handsUp', function(store)
    TriggerClientEvent('grp-storerobbery:handsUp', -1, store)
end)

RegisterServerEvent('grp-storerobbery:pickUp')
AddEventHandler('grp-storerobbery:pickUp', function(store)
    local xPlayer = GRPCore.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('DoLongHudText', source, 'You got: $' .. randomAmount, 2) 
    TriggerClientEvent('grp-storerobbery:removePickup', -1, store) 
end)

GRPCore.RegisterServerCallback('grp-storerobbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = GRPCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = GRPCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= Config.Shops[store].cops then
        if not Config.Shops[store].robbed and not deadPeds[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('grp-storerobbery:notif')
AddEventHandler('grp-storerobbery:notif', function(store)
    local src = source
    local xPlayers = GRPCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = GRPCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('grp-storerobbery:msgPolice', src, store)
            return
        end
    end
end)

RegisterServerEvent('grp-storerobbery:rob')
AddEventHandler('grp-storerobbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    TriggerClientEvent('grp-storerobbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('grp-storerobbery:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('grp-storerobbery:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('grp-storerobbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)
