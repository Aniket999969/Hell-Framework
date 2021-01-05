GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

AddEventHandler('grp:playerLoaded', function(source)
	TriggerEvent('grp-license:getLicenses', source, function(licenses)
		TriggerClientEvent('grp-dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('grp-dmvschool:addLicense')
AddEventHandler('grp-dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('grp-license:addLicense', _source, type, function()
		TriggerEvent('grp-license:getLicenses', _source, function(licenses)
			TriggerClientEvent('grp-dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('grp-dmvschool:pay')
AddEventHandler('grp-dmvschool:pay', function(price)
	local _source = source
	local xPlayer = GRPCore.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('DoLongHudText', _source, 'You paid $'.. GRPCore.Math.GroupDigits(price) .. ' to the DMV school', 1)
end)
