GRPCore = nil
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('grp-bennysmech:attemptPurchase')
AddEventHandler('grp-bennysmech:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = GRPCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('grp-bennysmech:purchaseSuccessful', source)
        else
            TriggerClientEvent('grp-bennysmech:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('grp-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('grp-bennysmech:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('grp-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('grp-bennysmech:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('grp-bennysmech:updateRepairCost')
AddEventHandler('grp-bennysmech:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('grp-bennysmech:updateVehicle')
AddEventHandler('grp-bennysmech:updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)