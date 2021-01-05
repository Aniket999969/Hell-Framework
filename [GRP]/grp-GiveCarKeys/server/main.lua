
--- SERVER

GRPCore               = nil
local cars 		  = {}

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

GRPCore.RegisterServerCallback('grp-givecarkeys:requestPlayerCars', function(source, cb, plate)

	local xPlayer = GRPCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if trim(vehicleProps.plate) == trim(plate) then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

RegisterServerEvent('grp-givecarkeys:frommenu')
AddEventHandler('grp-givecarkeys:frommenu', function ()
	TriggerClientEvent('grp-givecarkeys:keys', source)
end)


RegisterServerEvent('grp-givecarkeys:setVehicleOwnedPlayerId')
AddEventHandler('grp-givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = GRPCore.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},

	function (rowsChanged)
		TriggerClientEvent('grp:showNotification', playerId, 'You have got a new car with plate ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)

	end)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end



RegisterCommand('transferveh', function(source, args, user)
	TriggerClientEvent('grp-givecarkeys:keys', source)
end)
