GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('grp-billing:sendBill')
AddEventHandler('grp-billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = GRPCore.GetPlayerFromId(_source)
	local xTarget = GRPCore.GetPlayerFromId(playerId)

	TriggerEvent('grp-addonaccount:getSharedAccount', sharedAccountName, function(account)

		if amount < 0 then
		elseif account == nil then

			if xTarget ~= nil then
				MySQL.Async.execute(
					'INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
					{
						['@identifier']  = xTarget.identifier,
						['@sender']      = xPlayer.identifier,
						['@target_type'] = 'player',
						['@target']      = xPlayer.identifier,
						['@label']       = label,
						['@amount']      = amount
					},
					function(rowsChanged)
						TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_invoice'), 1)
					end
				)
			end

		else

			if xTarget ~= nil then
				MySQL.Async.execute(
					'INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
					{
						['@identifier']  = xTarget.identifier,
						['@sender']      = xPlayer.identifier,
						['@target_type'] = 'society',
						['@target']      = sharedAccountName,
						['@label']       = label,
						['@amount']      = amount
					},
					function(rowsChanged)
						TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_invoice'), 1)
					end
				)
			end

		end
	end)

end)

GRPCore.RegisterServerCallback('grp-billing:getBills', function(source, cb)
	local xPlayer = GRPCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM billing WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local bills = {}

			for i=1, #result, 1 do
				table.insert(bills, {
					id         = result[i].id,
					identifier = result[i].identifier,
					sender     = result[i].sender,
					targetType = result[i].target_type,
					target     = result[i].target,
					label      = result[i].label,
					amount     = result[i].amount
				})
			end

			cb(bills)

		end
	)

end)

GRPCore.RegisterServerCallback('grp-billing:getTargetBills', function(source, cb, target)
	local xPlayer = GRPCore.GetPlayerFromId(target)

	MySQL.Async.fetchAll(
		'SELECT * FROM billing WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local bills = {}

			for i=1, #result, 1 do
				table.insert(bills, {
					id         = result[i].id,
					identifier = result[i].identifier,
					sender     = result[i].sender,
					targetType = result[i].target_type,
					target     = result[i].target,
					label      = result[i].label,
					amount     = result[i].amount
				})
			end

			cb(bills)

		end
	)

end)


GRPCore.RegisterServerCallback('grp-billing:payBill', function(source, cb, id)
	local xPlayer = GRPCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM billing WHERE id = @id',
		{
			['@id'] = id
		}, function(result)

			local sender     = result[1].sender
			local targetType = result[1].target_type
			local target     = result[1].target
			local amount     = result[1].amount

			local xTarget = GRPCore.GetPlayerFromIdentifier(sender)

			if targetType == 'player' then

				if xTarget ~= nil then

					if xPlayer.getMoney() >= amount then

						MySQL.Async.execute('DELETE from billing WHERE id = @id',
						{
							['@id'] = id
						}, function(rowsChanged)
							xPlayer.removeMoney(amount)
							xTarget.addMoney(amount)

							TriggerClientEvent('DoLongHudText', xPlayer.source, _U('paid_invoice', amount), 1)
							TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_payment', amount), 1)

							cb()
						end)

					elseif xPlayer.getBank() >= amount then

						MySQL.Async.execute('DELETE from billing WHERE id = @id',
						{
							['@id'] = id
						}, function(rowsChanged)
							xPlayer.removeAccountMoney('bank', amount)
							xTarget.addAccountMoney('bank', amount)

							TriggerClientEvent('DoLongHudText', xPlayer.source, _U('paid_invoice', amount), 1)
							TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_payment', amount), 1)

							cb()
						end)

					else
						TriggerClientEvent('DoLongHudText', xTarget.source, _U('target_no_money'), 2)
						TriggerClientEvent('DoLongHudText', xPlayer.source, _U('no_money'), 2)

						cb()
					end

				else
					TriggerClientEvent('DoLongHudText', xPlayer.source, _U('player_not_online'), 2)
					cb()
				end
			else
				TriggerEvent('grp-addonaccount:getSharedAccount', target, function(account)

					if xPlayer.getMoney() >= amount then

						MySQL.Async.execute('DELETE from billing WHERE id = @id',
						{
							['@id'] = id
						}, function(rowsChanged)
							xPlayer.removeMoney(amount)
							account.addMoney(amount)

							TriggerClientEvent('DoLongHudText', xPlayer.source, _U('paid_invoice', amount), 1)
							if xTarget ~= nil then
								TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_payment', amount), 1)
							end

							cb()
						end)

					elseif xPlayer.getBank() >= amount then

						MySQL.Async.execute('DELETE from billing WHERE id = @id',
						{
							['@id'] = id
						}, function(rowsChanged)
							xPlayer.removeAccountMoney('bank', amount)
							account.addMoney(amount)

							TriggerClientEvent('DoLongHudText', xPlayer.source, _U('paid_invoice', amount), 1)
							if xTarget ~= nil then
								TriggerClientEvent('DoLongHudText', xTarget.source, _U('received_payment', amount), 1)
							end

							cb()
						end)
					else
						TriggerClientEvent('DoLongHudText', xPlayer.source, _U('no_money'), 2)

						if xTarget ~= nil then
							TriggerClientEvent('DoLongHudText', xTarget.source, _U('target_no_money'), 2)
						end
						cb()
					end
				end)
			end
		end
	)
end)