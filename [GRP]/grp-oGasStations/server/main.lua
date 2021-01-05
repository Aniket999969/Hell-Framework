GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('carfill:checkmoney')
AddEventHandler('carfill:checkmoney', function(cash)
    local source = source
    local xPlayer = GRPCore.GetPlayerFromId(source)
    if cash > 0 then
        xPlayer.removeMoney(cash)
    end
end)