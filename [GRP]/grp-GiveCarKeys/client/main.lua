-- Client

GRPCore               = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("grp-givecarkeys:keys")
AddEventHandler("grp-givecarkeys:keys", function()

giveCarKeys()

end)

function giveCarKeys()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = GRPCore.Game.GetVehicleProperties(vehicle)


	GRPCore.TriggerServerCallback('grp-givecarkeys:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then

		local closestPlayer, closestDistance = GRPCore.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then
	TriggerEvent('DoLongHudText', 'No players nearby!', 2)
else
	TriggerEvent('DoLongHudText', 'You are giving your car keys for vehicle with plate '..vehicleProps.plate..'!', 1)
	TriggerServerEvent('grp-givecarkeys:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
end

		end
	end, GetVehicleNumberPlateText(vehicle))
end
