GRPCore             = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('mythic_hospital:server:HealSomeShit')
AddEventHandler('mythic_hospital:server:HealSomeShit', function()
    local src = source

	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	local xPlayer = GRPCore.GetPlayerFromId(src)
	xPlayer.removeBank(1000)
        TriggerClientEvent('grp:showNotification', src, '~w~You Were Billed For ~r~$1,000 ~w~For Medical Services & Expenses')
end)