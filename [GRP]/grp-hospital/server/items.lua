GRPCore               = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

----
GRPCore.RegisterUsableItem('gauze', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gauze', 1)

	TriggerClientEvent('grp-hospital:items:gauze', source)
end)

GRPCore.RegisterUsableItem('bandaids', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandaids', 1)

	TriggerClientEvent('grp-hospital:items:bandage', source)
end)

GRPCore.RegisterUsableItem('firstaid', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firstaid', 1)

	TriggerClientEvent('grp-hospital:items:firstaid', source)
end)

GRPCore.RegisterUsableItem('vicodin', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vicodin', 1)

	TriggerClientEvent('grp-hospital:items:vicodin', source)
end)

GRPCore.RegisterUsableItem('ifak', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ifak', 1)

	TriggerClientEvent('grp-hospital:items:ifak', source)
end)

GRPCore.RegisterUsableItem('hydrocodone', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hydrocodone', 1)

	TriggerClientEvent('grp-hospital:items:hydrocodone', source)
end)

GRPCore.RegisterUsableItem('morphine', function(source)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)

	TriggerClientEvent('grp-hospital:items:morphine', source)
end)
