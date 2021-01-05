GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('grp-fish:payShit')
AddEventHandler('grp-fish:payShit', function(money)
    local source = source
    local xPlayer  = GRPCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)

RegisterServerEvent('fish:checkAndTakeDepo')
AddEventHandler('fish:checkAndTakeDepo', function()
local source = source
local xPlayer  = GRPCore.GetPlayerFromId(source)
    xPlayer.removeMoney(500)
end)

RegisterServerEvent('fish:returnDepo')
AddEventHandler('fish:returnDepo', function()
local source = source
local xPlayer  = GRPCore.GetPlayerFromId(source)
    xPlayer.addMoney(500)
end)

RegisterServerEvent('grp-fish:getFish')
AddEventHandler('grp-fish:getFish', function()
local source = source
    TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,2))
end)