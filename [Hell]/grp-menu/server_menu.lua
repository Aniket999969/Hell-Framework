GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj)
    GRPCore = obj
end)

RegisterServerEvent('grp-interactions:putInVehicle')
AddEventHandler('grp-interactions:putInVehicle', function(target)
    TriggerClientEvent('grp-interactions:putInVehicle', target)
end)

RegisterServerEvent('grp-interactions:outOfVehicle')
AddEventHandler('grp-interactions:outOfVehicle', function(target)
    TriggerClientEvent('grp-interactions:outOfVehicle', target)
end)
