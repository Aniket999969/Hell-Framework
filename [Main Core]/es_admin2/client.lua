GRPCore = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end

	while GRPCore.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	GRPCore.PlayerData = GRPCore.GetPlayerData()
end)

local group = "user"
local states = {}
states.frozen = false
states.frozenPos = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustPressed(1, 213) then
			GRPCore.TriggerServerCallback('es_admin2:openMenu', function(canOpen, plys)
				if canOpen then
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'open', players = plys, playersCount = #plys})
				else
					TriggerEvent('DoLongHudText', "You can't open this menu, Because You Are Not An Admin", 2)
				end
			end)
		end
	end
end)


RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quitspectate', function(data, cb)
	SetNuiFocus(false)
	exports["esx_spectate"]:quit()
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "spectate" then
		SendNUIMessage({ type = 'close' })
	end

	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" then
		TriggerServerEvent('admin:all', data.type)
	else
		TriggerServerEvent('admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('admin:set', data.type, data.user, data.param)
end)

local noclip = false
RegisterNetEvent('admin:quick')
AddEventHandler('admin:quick', function(t, target)
	if t == "slay" then SetEntityHealth(PlayerPedId(), 0) end
	if t == "goto" then SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) end
	if t == "bring" then 
		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
	end
	if t == "crash" then 
		Citizen.Trace("You're being crashed, so you know. This server sucks.\n")
		Citizen.CreateThread(function()
			while true do end
		end) 
	end
	if t == "slap" then ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
	if t == "noclip" then
		local msg = "disabled"
		if(noclip == false)then
			noclip_pos = GetEntityCoords(PlayerPedId(), false)
		end

		noclip = not noclip

		if(noclip)then
			msg = "enabled"
			SetAllCollition(false)
		else
			SetAllCollition(true)
		end

	end
	if t == "freeze" then
		local player = PlayerId()

		local ped = PlayerPedId()

		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)

		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
	end
	if t == "spectate" then

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		else
			Citizen.Wait(200)
		end
	end
end)

local heading = 0
local gtimer = GetGameTimer()
local speed = 10
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(noclip)then
			--[[SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

			if(IsControlPressed(1, 34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
			end

			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			end

			if(IsControlPressed(1, 173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
			end
		else
			Citizen.Wait(200)]]
			
			
			local multiplier = GetGameTimer() - gtimer
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local camRot = GetGameplayCamRot(0)
			local camHeading = map(camRot.z, -180.0, 180.0, 0.0, 360.0)
			local ax, ay = math.sin(math.rad(camHeading)), -math.cos(math.rad(camHeading))
			local newX, newY, newZ = pos.x, pos.y, pos.z
			if IsControlJustPressed(2, 174) then speed = speed - 2 end -- Left
			if IsControlJustPressed(2, 175) then speed = speed + 2 end -- Right
			
			if speed < 1 then speed = 1 end 
			if IsControlPressed(2, 87) then newX, newY = newX + ax*(multiplier*(speed/100)), newY + ay*(multiplier*(speed/100)) end -- W 
			if IsControlPressed(2, 88) then newX, newY = newX - ax*(multiplier*(speed/100)), newY - ay*(multiplier*(speed/100)) end -- S
			if IsControlPressed(2, 172) then newZ = newZ + multiplier*(speed/100) end -- Up
			if IsControlPressed(2, 173) then newZ = newZ - multiplier*(speed/100) end -- Down
			
			
			if IsControlPressed(2, 89) then -- A
				local newcamHeading = (camHeading + 90) % 360
				ax, ay = math.sin(math.rad(newcamHeading)), -math.cos(math.rad(newcamHeading))
				newX, newY = newX + ax*(multiplier*(speed/100)), newY + ay*(multiplier*(speed/100))
			end
			if IsControlPressed(2, 90) then -- D
				local newcamHeading = (camHeading - 90) % 360
				ax, ay = math.sin(math.rad(newcamHeading)), -math.cos(math.rad(newcamHeading))
				newX, newY = newX + ax*(multiplier*(speed/100)), newY + ay*(multiplier*(speed/100))
			end
			SetAllCollition(false)
			SetAllCoordsNoOffset(newX, newY, newZ, ax, ay, 0.0)
			gtimer = GetGameTimer()
			
			
		end
	end
end)

function map(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function GetControllerEntity(ped)
	if IsPedInAnyVehicle(ped, false) then
		return GetVehiclePedIsUsing(ped)
	else
		return ped
	end
end

function SetAllCollition(mode)
	local ped = PlayerPedId()
	SetEntityCollision(ped, mode, true)
	if IsPedInAnyVehicle(ped, false) then
		local veh = GetVehiclePedIsUsing(ped)
		SetEntityCollision(veh, mode, true)
	end
end

function SetAllCoordsNoOffset(x, y, z, zx, zy, zz)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		local veh = GetVehiclePedIsUsing(ped)
		SetEntityCoordsNoOffset(veh, x, y, z, zx, zy, zz)
	else
		SetEntityCoordsNoOffset(ped, x, y, z, zx, zy, zz)
	end
end

RegisterNetEvent('admin:freezePlayer')
AddEventHandler("admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('admin:teleportUser')
AddEventHandler('admin:teleportUser', function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('admin:slap')
AddEventHandler('admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('admin:kill')
AddEventHandler('admin:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('admin:heal')
AddEventHandler('admin:heal', function()
	SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('admin:crash')
AddEventHandler('admin:crash', function()
	while true do
	end
end)

RegisterNetEvent("admin:noclip")
AddEventHandler("admin:noclip", function(t)
	local msg = "Disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "Enabled"
		SetAllCollition(false)
	else
		SetAllCollition(true)
	end

	TriggerClientEvent('chat:addMessage', source, {
		template = '<div class="chat-message server"><b>NOCLIP</b> {0}</div>',
		args = { msg }
	})

end)

