GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)


RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function(money)
    local source = source
    local xPlayer = GRPCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        TriggerClientEvent('oxydelivery:startDealing', source)
        TriggerClientEvent('oxydelivery:client', source)
    else
        TriggerClientEvent('DoLongHudText', source, 'You do not have enough money to start', 2)
    end
end)