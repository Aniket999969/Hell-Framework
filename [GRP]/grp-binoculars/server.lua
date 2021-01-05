GRPCore               = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

GRPCore.RegisterUsableItem('binoculars', function(source)
    local xPlayer = GRPCore.GetPlayerFromId(source)
    local drill = xPlayer.getInventoryItem('binoculars')

    TriggerClientEvent('binoculars:Activate', source)
end)