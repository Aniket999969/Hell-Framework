
GRPCore = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('grp:playerLoaded', function (source)
	TriggerEvent("playerSpawned")
end)


RegisterServerEvent('CheckMyLicense')
AddEventHandler('CheckMyLicense', function()
  local _src = source
  local player = GRPCore.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
      ['@owner'] = player.identifier
    }, function (result)
      if result[1] ~= nil then
        if result[1].type == 'weapon'then
        TriggerClientEvent('wtflols',_src, player.getMoney(), 1)
        end
      end
    end)
end)

