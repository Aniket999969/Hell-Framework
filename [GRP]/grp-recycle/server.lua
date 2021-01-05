GRPCore                = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(money)
    local source = source
    local xPlayer  = GRPCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
        TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 5 Loose Buds of Weed.', 1)
    end
end)

RegisterServerEvent('missionSystem:caughtMoney')
AddEventHandler('missionSystem:caughtMoney', function(money)
    local source = source
    local xPlayer  = GRPCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)