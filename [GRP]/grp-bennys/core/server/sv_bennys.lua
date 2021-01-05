GRPCore = nil
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('grp-bennys:attemptPurchase')
AddEventHandler('grp-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = GRPCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('grp-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('grp-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('grp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('grp-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('grp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('grp-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('grp-bennys:updateRepairCost')
AddEventHandler('grp-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)