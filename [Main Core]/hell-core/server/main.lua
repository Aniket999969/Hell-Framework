Citizen.CreateThread(function()
	Citizen.Wait(500)
	print('\27[32m[grp-core]\27[0m Loaded All Data Successfully')
end)

AddEventHandler('es:playerLoaded', function(source, _player)
	local _source = source
	local tasks   = {}

	local userData = {
		accounts     = {},
		job          = {},
		loadout      = {},
		playerName   = GetPlayerName(_source),
		lastPosition = nil
	}

	TriggerEvent('es:getPlayerFromId', _source, function(player)
		-- Update user name in DB
		table.insert(tasks, function(cb)
			MySQL.Async.execute('UPDATE users SET name = @name WHERE identifier = @identifier', {
				['@identifier'] = player.getIdentifier(),
				['@name'] = userData.playerName
			}, function(rowsChanged)
				cb()
			end)
		end)

		-- Get accounts
		table.insert(tasks, function(cb)
			MySQL.Async.fetchAll('SELECT * FROM user_accounts WHERE identifier = @identifier', {
				['@identifier'] = player.getIdentifier()
			}, function(accounts)
				for i=1, #Config.Accounts, 1 do
					for j=1, #accounts, 1 do
						if accounts[j].name == Config.Accounts[i] then
							table.insert(userData.accounts, {
								name  = accounts[j].name,
								money = accounts[j].money,
								label = Config.AccountLabels[accounts[j].name]
							})
							break
						end
					end
				end

				cb()
			end)
		end)

		-- Get job and loadout
		table.insert(tasks, function(cb)

			local tasks2 = {}

			-- Get job name, grade and last position
			table.insert(tasks2, function(cb2)

				MySQL.Async.fetchAll('SELECT job, job_grade, loadout, position FROM users WHERE identifier = @identifier', {
					['@identifier'] = player.getIdentifier()
				}, function(result)
					local job, grade = result[1].job, tostring(result[1].job_grade)

					if GRPCore.DoesJobExist(job, grade) then
						local jobObject, gradeObject = GRPCore.Jobs[job], GRPCore.Jobs[job].grades[grade]

						userData.job = {}

						userData.job.id    = jobObject.id
						userData.job.name  = jobObject.name
						userData.job.label = jobObject.label

						userData.job.grade        = tonumber(grade)
						userData.job.grade_name   = gradeObject.name
						userData.job.grade_label  = gradeObject.label
						userData.job.grade_salary = gradeObject.salary

						userData.job.skin_male    = {}
						userData.job.skin_female  = {}

						if gradeObject.skin_male ~= nil then
							userData.job.skin_male = json.decode(gradeObject.skin_male)
						end
			
						if gradeObject.skin_female ~= nil then
							userData.job.skin_female = json.decode(gradeObject.skin_female)
						end
					else
						print(('grp-core: %s had an unknown job [job: %s, grade: %s], setting as unemployed!'):format(player.getIdentifier(), job, grade))

						local job, grade = 'unemployed', '0'
						local jobObject, gradeObject = GRPCore.Jobs[job], GRPCore.Jobs[job].grades[grade]

						userData.job = {}

						userData.job.id    = jobObject.id
						userData.job.name  = jobObject.name
						userData.job.label = jobObject.label
			
						userData.job.grade        = tonumber(grade)
						userData.job.grade_name   = gradeObject.name
						userData.job.grade_label  = gradeObject.label
						userData.job.grade_salary = gradeObject.salary
			
						userData.job.skin_male    = {}
						userData.job.skin_female  = {}
					end

					if result[1].loadout ~= nil then
						userData.loadout = json.decode(result[1].loadout)

						-- Compatibility with old loadouts prior to components update
						for k,v in ipairs(userData.loadout) do
							if v.components == nil then
								v.components = {}
							end
						end
					end

					if result[1].position ~= nil then
						userData.lastPosition = json.decode(result[1].position)
					end

					cb2()
				end)

			end)

			Async.series(tasks2, cb)

		end)

		-- Run Tasks
		Async.parallel(tasks, function(results)
			local xPlayer = CreateExtendedPlayer(player, userData.accounts, userData.job, userData.loadout, userData.playerName, userData.lastPosition)

			xPlayer.getMissingAccounts(function(missingAccounts)
				if #missingAccounts > 0 then

					for i=1, #missingAccounts, 1 do
						table.insert(xPlayer.accounts, {
							name  = missingAccounts[i],
							money = 0,
							label = Config.AccountLabels[missingAccounts[i]]
						})
					end

					xPlayer.createAccounts(missingAccounts)
				end

				GRPCore.Players[_source] = xPlayer

				TriggerEvent('grp:playerLoaded', _source, xPlayer)

				TriggerClientEvent('grp:playerLoaded', _source, {
					identifier   = xPlayer.identifier,
					accounts     = xPlayer.getAccounts(),
					job          = xPlayer.getJob(),
					loadout      = xPlayer.getLoadout(),
					lastPosition = xPlayer.getLastPosition(),
					money        = xPlayer.getMoney()
				})

				xPlayer.displayMoney(xPlayer.getMoney())
			end)
		end)

	end)
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = GRPCore.GetPlayerFromId(_source)

	if xPlayer then
		TriggerEvent('grp:playerDropped', _source, reason)
		TriggerEvent('grp:PlayerDropped', xPlayer, source)

		GRPCore.SavePlayer(xPlayer, function()
			GRPCore.Players[_source] = nil
			GRPCore.LastPlayerData[_source] = nil
		end)
	end
end)

RegisterServerEvent('grp:updateLoadout')
AddEventHandler('grp:updateLoadout', function(loadout)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.loadout = loadout
end)

RegisterServerEvent('grp:updateLastPosition')
AddEventHandler('grp:updateLastPosition', function(position)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.setLastPosition(position)
end)

GRPCore.RegisterServerCallback('grp:getPlayerData', function(source, cb)
	local xPlayer = GRPCore.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		job          = xPlayer.getJob(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

GRPCore.RegisterServerCallback('grp:getOtherPlayerData', function(source, cb, target)
	local xPlayer = GRPCore.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		job          = xPlayer.getJob(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

TriggerEvent("es:addGroup", "jobmaster", "user", function(group) end)

GRPCore.StartDBSync()
GRPCore.StartPayCheck()
