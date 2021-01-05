GRPCore = nil
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent("grp-fleeca:startcheck")
AddEventHandler("grp-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = GRPCore.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = GRPCore.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 0
        end
    end
    local xPlayer = GRPCore.GetPlayerFromId(_source)

    if copcount >= fleeca.mincops then
        if not fleeca.Banks[bank].onaction == true then
            if (os.time() - fleeca.cooldown) > fleeca.Banks[bank].lastrobbed then
                fleeca.Banks[bank].onaction = true
                TriggerClientEvent('inventory:removeItem', _source, 'thermite', 1)
                TriggerClientEvent("grp-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("grp-fleeca:policenotify", -1, bank)
                TriggerClientEvent('grp-dispatch:bankrobbery', -1)
                    return
                else
                    TriggerClientEvent("grp-fleeca:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)), 60))
                end
            else
            TriggerClientEvent("grp-fleeca:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("grp-fleeca:outcome", _source, false, "There is not enough police in the city.")
    end
end)

RegisterServerEvent("grp-fleeca:lootup")
AddEventHandler("grp-fleeca:lootup", function(var, var2)
    TriggerClientEvent("grp-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("grp-fleeca:openDoor")
AddEventHandler("grp-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("grp-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("grp-fleeca:startLoot")
AddEventHandler("grp-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("grp-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("grp-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("grp-fleeca:stopHeist")
AddEventHandler("grp-fleeca:stopHeist", function(name)
    TriggerClientEvent("grp-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("grp-fleeca:rewardCash")
AddEventHandler("grp-fleeca:rewardCash", function()
    local xPlayer = GRPCore.GetPlayerFromId(source)
    local reward = math.random(1, 2)
    local mathfunc = math.random(200)
    local payout = math.random(2,4)
    if mathfunc == 15 then
      TriggerClientEvent('player:receiveItem', source, 'goldbar', payout)
    end
    TriggerClientEvent("player:receiveItem", source, "band", reward)
end)

RegisterServerEvent("grp-fleeca:setCooldown")
AddEventHandler("grp-fleeca:setCooldown", function(name)
    fleeca.Banks[name].lastrobbed = os.time()
    fleeca.Banks[name].onaction = false
    TriggerClientEvent("grp-fleeca:resetDoorState", -1, name)
end)

GRPCore.RegisterServerCallback("grp-fleeca:getBanks", function(source, cb)
    cb(fleeca.Banks)
end)