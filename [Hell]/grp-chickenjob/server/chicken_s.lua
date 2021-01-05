GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj)
	GRPCore = obj
end)

RegisterServerEvent('chickenpayment:pay')
AddEventHandler('chickenpayment:pay', function()
local _source = source
local xPlayer = GRPCore.GetPlayerFromId(source)
	xPlayer.addMoney(math.random(100,155))
end)