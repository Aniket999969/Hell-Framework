local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

GRPCore = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for i=1, #Config.Locations, 1 do
		carWashLocation = Config.Locations[i]

		local blip = AddBlipForCoord(carWashLocation)
		SetBlipSprite(blip, 100)
		SetBlipScale  (blip, 0.7)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('blip_carwash'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		if CanWashVehicle() then

			for i=1, #Config.Locations, 1 do
				local carWashLocation = Config.Locations[i]
				local distance = GetDistanceBetweenCoords(coords, carWashLocation, true)

				if distance < 5 then
					canSleep = false

					if Config.EnablePrice then
						GRPCore.ShowHelpNotification(_U('prompt_wash_paid', GRPCore.Math.GroupDigits(Config.Price)))
					else
						GRPCore.ShowHelpNotification(_U('prompt_wash'))
					end

					if IsControlJustReleased(0, Keys['E']) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

						if GetVehicleDirtLevel(vehicle) > 2 then
							WashVehicle()
						else
							TriggerEvent('DoLongHudText', 'Your vehicle does not need a car wash', 2)
						end
					end
				end
			end

			if canSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

function CanWashVehicle()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

function WashVehicle()
	GRPCore.TriggerServerCallback('grp-carwash:canAfford', function(canAfford)
		if canAfford then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleDirtLevel(vehicle, 0.1)

			if Config.EnablePrice then
				GRPCore.ShowNotification(_U('wash_successful_paid', GRPCore.Math.GroupDigits(Config.Price)))
			else
				TriggerEvent('DoLongHudText', 'Your vehicle has been washed', 1)
			end
			Citizen.Wait(5000)
		else
			TriggerEvent('DoLongHudText', 'Your vehicle does not need a wash', 2)
			Citizen.Wait(5000)
		end
	end)
end