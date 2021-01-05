GRPCore = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end

	while GRPCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = GRPCore.GetPlayerData()
end)

RegisterNetEvent('grp-fines:Anim')
AddEventHandler('grp-fines:Anim', function()
	RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
end)