GRPCore = nil
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
---------- Pawn Shop --------------

RegisterServerEvent('grp-pawnshop:selljewels')
AddEventHandler('grp-pawnshop:selljewels', function()
local _source = source
local xPlayer = GRPCore.GetPlayerFromId(_source)
	xPlayer.addMoney(50)
end)