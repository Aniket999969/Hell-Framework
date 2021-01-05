GRPCore                      = {}
GRPCore.Players              = {}
GRPCore.UsableItemsCallbacks = {}
GRPCore.Items                = {}
GRPCore.ServerCallbacks      = {}
GRPCore.TimeoutCount         = -1
GRPCore.CancelledTimeouts    = {}
GRPCore.LastPlayerData       = {}
GRPCore.Pickups              = {}
GRPCore.PickupId             = 0
GRPCore.Jobs                 = {}

AddEventHandler('grp:getSharedObject', function(cb)
	cb(GRPCore)
end)

function getSharedObject()
	return GRPCore
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			GRPCore.Items[result[i].name] = {
				label     = result[i].label,
				limit     = result[i].limit,
				rare      = (result[i].rare       == 1 and true or false),
				canRemove = (result[i].can_remove == 1 and true or false),
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		GRPCore.Jobs[result[i].name] = result[i]
		GRPCore.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if GRPCore.Jobs[result2[i].job_name] then
			GRPCore.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('grp-core: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(GRPCore.Jobs) do
		if next(v.grades) == nil then
			GRPCore.Jobs[v.name] = nil
			print(('grp-core: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)

AddEventHandler('grp:playerLoaded', function(source)
	local xPlayer         = GRPCore.GetPlayerFromId(source)
	local accounts        = {}
	local items           = {}
	local xPlayerAccounts = xPlayer.getAccounts()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	GRPCore.LastPlayerData[source] = {
		accounts = accounts,
		items    = items
	}
end)

RegisterServerEvent('grp:clientLog')
AddEventHandler('grp:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterServerEvent('grp:triggerServerCallback')
AddEventHandler('grp:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	GRPCore.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('grp:serverCallback', _source, requestId, ...)
	end, ...)
end)
