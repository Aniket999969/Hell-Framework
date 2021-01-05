GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('grp-driftschool:takemoney')
AddEventHandler('grp-driftschool:takemoney', function(money)
    local source = source
    local xPlayer = GRPCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        TriggerClientEvent('grp-driftschool:tookmoney', source, true)
    else
        TriggerClientEvent('DoLongHudText', source, 'Not enough money', 2)
    end
end)