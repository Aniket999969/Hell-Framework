GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('grp-uberkdshfksksdhfskdjjob:pay')
AddEventHandler('grp-uberkdshfksksdhfskdjjob:pay', function(amount)
	local _source = source
	local xPlayer = GRPCore.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
	TriggerClientEvent('chatMessagess', _source, '', 4, 'You got payed $' .. amount)
end)
