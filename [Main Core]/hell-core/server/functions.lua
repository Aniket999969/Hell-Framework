GRPCore.Trace = function(str)
	if Config.EnableDebug then
		print('GRPCore> ' .. str)
	end
end

GRPCore.SetTimeout = function(msec, cb)
	local id = GRPCore.TimeoutCount + 1

	SetTimeout(msec, function()
		if GRPCore.CancelledTimeouts[id] then
			GRPCore.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	GRPCore.TimeoutCount = id

	return id
end

GRPCore.ClearTimeout = function(id)
	GRPCore.CancelledTimeouts[id] = true
end

GRPCore.RegisterServerCallback = function(name, cb)
	GRPCore.ServerCallbacks[name] = cb
end

GRPCore.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if GRPCore.ServerCallbacks[name] ~= nil then
		GRPCore.ServerCallbacks[name](source, cb, ...)
	else
		print('grp-core: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

GRPCore.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- User accounts
	for i=1, #xPlayer.accounts, 1 do
		if GRPCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] ~= xPlayer.accounts[i].money then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_accounts SET money = @money WHERE identifier = @identifier AND name = @name', {
					['@money']      = xPlayer.accounts[i].money,
					['@identifier'] = xPlayer.identifier,
					['@name']       = xPlayer.accounts[i].name
				}, function(rowsChanged)
					cb()
				end)
			end)

			GRPCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] = xPlayer.accounts[i].money
		end
	end
	
	-- Job, loadout and position
	table.insert(asyncTasks, function(cb)
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade, loadout = @loadout, position = @position WHERE identifier = @identifier', {
			['@job']        = xPlayer.job.name,
			['@job_grade']  = xPlayer.job.grade,
			['@loadout']    = json.encode(xPlayer.getLoadout()),
			['@position']   = json.encode(xPlayer.getLastPosition()),
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			cb()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		RconPrint('\27[32m[grp-core] [Saving Player]\27[0m ' .. xPlayer.name .. "^7\n")

		if cb ~= nil then
			cb()
		end
	end)
end

GRPCore.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = GRPCore.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = GRPCore.GetPlayerFromId(xPlayers[i])
			GRPCore.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('\27[32m[grp-core] [Saving All Players]\27[0m' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

GRPCore.StartDBSync = function()
	function saveData()
		GRPCore.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

GRPCore.GetPlayers = function()
	local sources = {}

	for k,v in pairs(GRPCore.Players) do
		table.insert(sources, k)
	end

	return sources
end


GRPCore.GetPlayerFromId = function(source)
	return GRPCore.Players[tonumber(source)]
end

GRPCore.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(GRPCore.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

GRPCore.RegisterUsableItem = function(item, cb)
	GRPCore.UsableItemsCallbacks[item] = cb
end

GRPCore.UseItem = function(source, item)
	GRPCore.UsableItemsCallbacks[item](source)
end

GRPCore.GetItemLabel = function(item)
	if GRPCore.Items[item] ~= nil then
		return GRPCore.Items[item].label
	end
end

GRPCore.CreatePickup = function(type, name, count, label, player)
	local pickupId = (GRPCore.PickupId == 65635 and 0 or GRPCore.PickupId + 1)

	GRPCore.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count
	}

	TriggerClientEvent('grp:pickup', -1, pickupId, label, player)
	GRPCore.PickupId = pickupId
end

GRPCore.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if GRPCore.Jobs[job] and GRPCore.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end