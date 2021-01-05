GRPCore = nil

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

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) grp = obj end)
		Citizen.Wait(0)
	end
end)


local hudStatus = true
local health = 0
local armor = 0
local myStamina = 0
local usingSeatbelt = false
local isTalking = false
local myOxygen = 10.0

local hour = 0
local minute = 0

local opacityBars = 0 

local Addition = 0.0

local HudStage = 1

--oxygenTank = 100.0

opacity = 0

local thirsty = 0

local hunger = 0

Citizen.CreateThread(function()
	
	while true do
		Citizen.Wait(5000)
		
		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			thirsty = status.val/1000000*100

		end)

		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			hunger = status.val/1000000*100

		end)
		
	end

end)


oxygenTank = 25.0

RegisterNetEvent("RemoveOxyTank")
AddEventHandler("RemoveOxyTank",function()
	if oxygenTank > 25.0 then
		oxygenTank = 25.0
	end
end)

RegisterNetEvent("UseOxygenTank")
AddEventHandler("UseOxygenTank",function()
	oxygenTank = 100.0
end)




function drawRct(x,y,width,height,r,g,b,a)

	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function NdrawTxt(x, y, width, height, scale, text, r, g, b, a, center)
  SetTextFont(6)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 1, 1, 1, 1)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextCentre(center)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width / 2, y - height / 2 + 0.005)
end


local voipTypes = {
	
	{type = "Whisper", event = "pv:voip1"},
	{type = "Normal", event = "pv:voip2"},
	{type = "Yell", event = "pv:voip3"}
}

local voip = {}
voip['default'] = {name = 'default', setting = 18.0}
voip['local'] = {name = 'local', setting = 18.0}
voip['whisper'] = {name = 'whisper', setting = 4.0}
voip['yell'] = {name = 'yell', setting = 35.0}

AddEventHandler('np-base:playerSessionStarted', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('pv:voip')
AddEventHandler('pv:voip', function(voipDistance)

	NotificationMessage("Your VOIP is now ~b~" .. voipsetting ..".")
	NetworkSetTalkerProximity(distanceSetting)
		
end)


distanceSetting = 18.0
NetworkSetTalkerProximity(18.0)

voipsetting = "Normal"
RegisterNetEvent('pv:voip1')
AddEventHandler('pv:voip1', function(voipDistance)
	distanceSetting = 4.0
	NetworkSetTalkerProximity(distanceSetting)
	voipsetting = "Whisper"
end)

RegisterNetEvent('pv:voip2')
AddEventHandler('pv:voip2', function(voipDistance)
	distanceSetting = 18.0
	NetworkSetTalkerProximity(distanceSetting)	
	voipsetting = "Normal"
end)


RegisterNetEvent('pv:voip3')
AddEventHandler('pv:voip3', function(voipDistance)
	distanceSetting = 35.0
	NetworkSetTalkerProximity(distanceSetting)	
	voipsetting = "Yell"
end)


Citizen.CreateThread(function()

	while true do
		if sleeping then
			if IsControlJustPressed(0,38) then
				sleeping = false
				DetachEntity(GetPlayerPed(-1), 1, true)
			end
		end


		if IsControlJustPressed(0,178) then
			if HudStage == 1 then
				HudStage = 2				
			elseif HudStage == 2 then
				HudStage = 3
				Addition = 0.001
			elseif HudStage == 3 then
				HudStage = 4
				Addition = 0.001
			else
				HudStage = 1			
				Addition = 0.001
			end
			--TriggerEvent("disableHUD",HudStage)
		end

		if HudStage == 4 then
			if opacityBars < 255 then
				opacityBars = opacityBars + 1
			else
				opacityBars = 255
			end
			if Addition < 0.2 then
				Addition = Addition + 0.001
			end

			DrawRect(0,-0.2 + Addition, 2.0, 0.2, 1, 1, 1, opacityBars)
			DrawRect(0,1.20 - Addition, 2.0, 0.2, 1, 1, 1, opacityBars)
		end

		if HudStage ~= 4 then
			if opacityBars > 0 then
				opacityBars = opacityBars - 1
				Addition = Addition + 0.001
				DrawRect(0,0 - Addition, 2.0, 0.2, 1, 1, 1, opacityBars)
				DrawRect(0,0.98 + Addition, 2.0, 0.2, 1, 1, 1, opacityBars)				
			end
		end

		last_health = GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1),false))
		Citizen.Wait(1)

	    if IsHudComponentActive(1) then 
	        HideHudComponentThisFrame(1)
	    end

	    if IsHudComponentActive(6) then 
	        HideHudComponentThisFrame(6)
	    end

	    if IsHudComponentActive(7) then 
	        HideHudComponentThisFrame(7)
	    end

	    if IsHudComponentActive(9) then 
	        HideHudComponentThisFrame(9)
	    end

	    if IsHudComponentActive(0) and not IsPedInAnyVehicle(GetPlayerPed( -1 ), true) then 
	        HideHudComponentThisFrame(0)
	    end
		
	    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

		SetPedMinGroundTimeForStungun(GetPlayerPed(-1), 16000)

		if HudStage < 3 then

			local get_ped = GetPlayerPed(-1) -- current ped
			local get_ped_veh = GetVehiclePedIsIn(get_ped,false) -- Current Vehicle ped is in
			local plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
			local veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
			local veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage 
			local veh_body_health = GetVehicleBodyHealth(get_ped_veh)
			local veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout
			local thespeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			local siren_on = IsVehicleSirenOn(get_ped_veh)
			local varVoipSet = 0
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())


			if oxygenTank > 0 and IsPedSwimmingUnderWater(GetPlayerPed(-1)) then
				SetPedDiesInWater(GetPlayerPed(-1), false)
				if oxygenTank > 25.0 then
					oxygenTank = oxygenTank - 0.001
				else
					oxygenTank = oxygenTank - 0.01
				end
			else
				SetPedDiesInWater(GetPlayerPed(-1), true)
			end

			if IsControlJustPressed(1, 349) then
				for k,v in ipairs(voipTypes) do
					if v.type == voipsetting then
						if k >= #voipTypes then TriggerEvent(voipTypes[1].event) break else TriggerEvent(voipTypes[k + 1].event) break end
					end
				end
			end

			if distanceSetting == 35.0 then
				varVoipSet = 0.027 * 0.1
			elseif distanceSetting == 18.0 then
				varVoipSet = 0.027 * 0.5
			elseif distanceSetting == 4.0 then
				varVoipSet = 0.027
			end


			if not IsPedSwimmingUnderWater( GetPlayerPed(-1) ) and oxygenTank < 25.0 then
				oxygenTank = oxygenTank + 0.01
				if oxygenTank > 25.0 then
					oxygenTank = 25.0
				end
			end

			if oxygenTank > 25.0 and not oxyOn then
				oxyOn = true

			elseif oxyOn and oxygenTank <= 25.0 then
				oxyOn = false
			end

		    if opacity > 0 and not fadein then
		    	opacity = opacity - 10
		    end

		    if opacity < 250 and fadein then
		    	opacity = opacity + 10
		    end

			if IsControlPressed(1, 249) or IsDisabledControlPressed(1, 249)  then
				talking = true
			else
				talking = false
			end

			drawRct(0.015, 0.9677, 0.1418,0.028,80,80,80,177)
			if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then
				SetEntityMaxHealth(GetPlayerPed(-1), 200)
				SetEntityHealth(GetPlayerPed(-1), 200)
			end					
			local health = GetEntityHealth(GetPlayerPed(-1)) - 100
			
			if health < 1 then health = 100 end

			local varSet = 0.06938 * (health / 100)
			
			drawRct(0.016, 0.97, 0.06938,0.01,190,190,190,80)
			drawRct(0.016, 0.97, varSet,0.01,55,190,55,177)



			armor = GetPedArmour(GetPlayerPed(-1))
			if armor > 100.0 then armor = 100.0 end

			local varSet = 0.06938 * (armor / 100)

			drawRct(0.0865, 0.97, 0.06938,0.01,190,190,190,80)
			drawRct(0.0865, 0.97, varSet,0.01,120,120,255,177)

			if hunger < 0 then
				hunger = 0
			end
			if thirsty < 0 then
				thirsty = 0
			end


			if thirsty > 100 then thirsty = 100 end
			varSet = 0.027 * (thirsty / 100)

			drawRct(0.016, 0.983, 0.0268,0.01,190,190,190,80)
			drawRct(0.016, 0.983, varSet,0.01,55,190,55,177)


			if hunger > 100 then hunger = 100 end
			varSet = 0.0268 * (hunger / 100)

			drawRct(0.044, 0.983, 0.027,0.01,190,190,190,80)
			drawRct(0.044, 0.983, varSet,0.01,80,80,255,177)


			varSet = 0.027 * (oxygenTank / 100)
			drawRct(0.072, 0.983, 0.027,0.01,190,190,190,80)
			drawRct(0.072, 0.983, varSet,0.01,255,255,55,177)

			if distanceSetting == 4.0 then
				varSet = 0.027 * 0.1
			elseif distanceSetting == 18.0 then
				varSet = 0.027 * 0.5
			elseif distanceSetting == 35.0 then
				varSet = 0.027
			end
			
			if talking  then
				drawRct(0.1, 0.983, varVoipSet,0.01,255, 55, 155,155)
				drawRct(0.1, 0.983, 0.027,0.01,255, 55, 155,170)
			else
				drawRct(0.1, 0.983, varVoipSet,0.01,205,205,205,155)
				drawRct(0.1, 0.983, 0.027,0.01,188,188,188,80)
			end

			varSet = 0.0278 * (stamina / 100)
			drawRct(0.128, 0.983, 0.0278,0.01,190,190,190,80)
			drawRct(0.128, 0.983, varSet,0.01,200, 0, 0,177)


			if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
				fadein = true
			else
				fadein = false
				veh_body_health = 0
			end	
		end
	end
end)




local zoneNames = {
 AIRP = "Los Santos International Airport",
 ALAMO = "Alamo Sea",
 ALTA = "Alta",
 ARMYB = "Fort Zancudo",
 BANHAMC = "Banham Canyon Dr",
 BANNING = "Banning",
 BAYTRE = "Baytree Canyon",
 BEACH = "Vespucci Beach",
 BHAMCA = "Banham Canyon",
 BRADP = "Braddock Pass",
 BRADT = "Braddock Tunnel",
 BURTON = "Burton",
 CALAFB = "Calafia Bridge",
 CANNY = "Raton Canyon",
 CCREAK = "Cassidy Creek",
 CHAMH = "Chamberlain Hills",
 CHIL = "Vinewood Hills",
 CHU = "Chumash",
 CMSW = "Chiliad Mountain State Wilderness",
 CYPRE = "Cypress Flats",
 DAVIS = "Davis",
 DELBE = "Del Perro Beach",
 DELPE = "Del Perro",
 DELSOL = "La Puerta",
 DESRT = "Grand Senora Desert",
 DOWNT = "Downtown",
 DTVINE = "Downtown Vinewood",
 EAST_V = "East Vinewood",
 EBURO = "El Burro Heights",
 ELGORL = "El Gordo Lighthouse",
 ELYSIAN = "Elysian Island",
 GALFISH = "Galilee",
 GALLI = "Galileo Park",
 golf = "GWC and Golfing Society",
 GRAPES = "Grapeseed",
 GREATC = "Great Chaparral",
 HARMO = "Harmony",
 HAWICK = "Hawick",
 HORS = "Vinewood Racetrack",
 HUMLAB = "Humane Labs and Research",
 JAIL = "Bolingbroke Penitentiary",
 KOREAT = "Little Seoul",
 LACT = "Land Act Reservoir",
 LAGO = "Lago Zancudo",
 LDAM = "Land Act Dam",
 LEGSQU = "Legion Square",
 LMESA = "La Mesa",
 LOSPUER = "La Puerta",
 MIRR = "Mirror Park",
 MORN = "Morningwood",
 MOVIE = "Richards Majestic",
 MTCHIL = "Mount Chiliad",
 MTGORDO = "Mount Gordo",
 MTJOSE = "Mount Josiah",
 MURRI = "Murrieta Heights",
 NCHU = "North Chumash",
 NOOSE = "N.O.O.S.E",
 OCEANA = "Pacific Ocean",
 PALCOV = "Paleto Cove",
 PALETO = "Paleto Bay",
 PALFOR = "Paleto Forest",
 PALHIGH = "Palomino Highlands",
 PALMPOW = "Palmer-Taylor Power Station",
 PBLUFF = "Pacific Bluffs",
 PBOX = "Pillbox Hill",
 PROCOB = "Procopio Beach",
 RANCHO = "Rancho",
 RGLEN = "Richman Glen",
 RICHM = "Richman",
 ROCKF = "Rockford Hills",
 RTRAK = "Redwood Lights Track",
 SanAnd = "San Andreas",
 SANCHIA = "San Chianski Mountain Range",
 SANDY = "Sandy Shores",
 SKID = "Mission Row",
 SLAB = "Stab City",
 STAD = "Maze Bank Arena",
 STRAW = "Strawberry",
 TATAMO = "Tataviam Mountains",
 TERMINA = "Terminal",
 TEXTI = "Textile City",
 TONGVAH = "Tongva Hills",
 TONGVAV = "Tongva Valley",
 VCANA = "Vespucci Canals",
 VESP = "Vespucci",
 VINE = "Vinewood",
 WINDF = "Ron Alternates Wind Farm",
 WVINE = "West Vinewood",
 ZANCUDO = "Zancudo River",
 ZP_ORT = "Port of South Los Santos",
 ZQ_UAR = "Davis Quartz"
}

local showCompass = true
local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

Citizen.CreateThread(function()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    playerStreetsLocation = zoneNames[tostring(zone)]

    if not zone then
        zone = "UNKNOWN"
        zoneNames['UNKNOWN'] = zone
    elseif not zoneNames[tostring(zone)] then
        local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
        zoneNames[tostring(zone)] = "Undefined Zone"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | " .. zoneNames[tostring(zone)]
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. zoneNames[tostring(zone)]
    else
        playerStreetsLocation = zoneNames[tostring(zone)]
    end

    while true do
        Citizen.Wait(2000)

		        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
		        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
		        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
		        zone = tostring(GetNameOfZone(x, y, z))
		        playerStreetsLocation = zoneNames[tostring(zone)]

		        if not zone then
		            zone = "UNKNOWN"
		            zoneNames['UNKNOWN'] = zone
		        elseif not zoneNames[tostring(zone)] then
		            local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
		            zoneNames[tostring(zone)] = "Undefined Zone"
		        end

		        if intersectStreetName ~= nil and intersectStreetName ~= "" then
		            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | " .. zoneNames[tostring(zone)]
		        elseif currentStreetName ~= nil and currentStreetName ~= "" then
		            playerStreetsLocation = currentStreetName .. " | " .. zoneNames[tostring(zone)]
		        else
		            playerStreetsLocation = zoneNames[tostring(zone)]
		        end

	end
end)


Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
        DisplayRadar(true)
        if IsPedInAnyVehicle(PlayerPedId(), false) then

		  		local Mph = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
				local fuel = GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
				local time = CalculateTimeToDisplay()


				drawTxt(0.667, 1.424, 1.0,1.0,0.55 , "~w~" .. math.ceil(Mph), 255, 255, 255, 255)  
				drawTxt(0.685, 1.429, 1.0,1.0,0.4, "~w~ km/h", 255, 255, 255, 255)
				drawTxt(0.714, 1.424, 1.0,1.0,0.55 , "~w~" .. math.ceil(fuel), 255, 255, 255, 255)
				drawTxt(0.732, 1.429, 1.0,1.0,0.4, "~w~ fuel", 255, 255, 255, 255)

				if usingSeatbelt then
          DisableControlAction(0, 75)
					drawTxt(0.757, 1.428, 1.0,1.0,0.46 , "~g~ BELT", 255, 255, 255, 255) 
				else
					drawTxt(0.757, 1.428, 1.0,1.0,0.46, "~r~ BELT", 255, 255, 255, 255)
				end

          drawTxt(0.668, 1.395, 1.0,1.0,0.43 ,"" .. hour .. ":" .. minute, 255, 255, 255, 255)

	        SetTextFont(4)
	        SetTextProportional(1)
	        SetTextScale(0.0, 0.43)
	        SetTextColour(255, 255, 255, 255)
	        SetTextDropshadow(0, 0, 0, 0, 255)
	        SetTextEdge(1, 0, 0, 0, 255)
	        SetTextDropShadow()
	        SetTextOutline()
	        SetTextEntry("STRING")

	        if showCompass then
	        	compass = getCardinalDirectionFromHeading(math.floor(GetEntityHeading(GetPlayerPed(-1)) + 0.5))
	        	lastStreetName = compass .. " | " .. playerStreetsLocation
	        end

	        AddTextComponentString(lastStreetName)
	        DrawText(0.168, 0.964)
      else
       DisplayRadar(true)
       Citizen.Wait(2000)
	    end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end



function CalculateTimeToDisplay()
  hour = GetClockHours()
  minute = GetClockMinutes()
  local type = 'AM'

 if hour == 1 or hour == 2 or hour == 3 or hour == 4 or hour == 5 or hour == 6 or hour == 7 or hour == 8 or hour == 9 or hour == 10 or hour == 11 or hour == 12 then
  type = 'AM'
 else
  type = 'PM'
 end
 if hour >= 13 then
	hour = hour-12
 end
 if hour <= 9 then
  hour = "0" .. hour
 end
 
 if minute <= 9 then
  minute = "0" .. minute
 end
 minute = minute..' '..type
end

--SEATBELT--

local speedBuffer  = {}
local velBuffer    = {}
local wasInCar     = false
local carspeed = 0
local speed = 0

Citizen.CreateThread(function()
 Citizen.Wait(500)
  while true do
   local ped = GetPlayerPed(-1)
   local car = GetVehiclePedIsIn(ped)
   if car ~= 0 and (wasInCar or IsCar(car)) then
    wasInCar = true
    speedBuffer[2] = speedBuffer[1]
    speedBuffer[1] = GetEntitySpeed(car)
    if speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[2] > 18.00 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[2] * 0.465) and usingSeatbelt == false then
    local co = GetEntityCoords(ped, true)
    local fw = Fwv(ped)
    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
    SetEntityVelocity(ped, velBuffer[2].x-10/2, velBuffer[2].y-10/2, velBuffer[2].z-10/4)
    Citizen.Wait(1)
    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
   end
    velBuffer[2] = velBuffer[1]
    velBuffer[1] = GetEntityVelocity(car)

    if IsControlJustPressed(0, 29) then
      if usingSeatbelt == false then
       usingSeatbelt = true
       TriggerEvent('notification', 'Seat Belt Enabled', 1)
       TriggerEvent('InteractSound_CL:PlayOnOne', 'buckle', 0.8)
       --esx.ShowNotification('~g~Cintura allacciata')
	   exports['mythic_notify']:DoHudText('inform', 'Belt On')
      else
       usingSeatbelt = false
       TriggerEvent('notification', 'Seat Belt Disabled', 1)
       TriggerEvent('InteractSound_CL:PlayOnOne', 'unbuckle', 0.8)
       --esx.ShowNotification('~r~Cintura tolta')
	   exports['mythic_notify']:DoHudText('inform', 'Belt Off')
      end
    end


   elseif wasInCar then
    wasInCar = false
    usingSeatbelt = false
    speedBuffer[1], speedBuffer[2] = 0.0, 0.0
   end
   Citizen.Wait(5)
   speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936)
  end
end)

function IsCar(veh)
 local vc = GetVehicleClass(veh)
 return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
 local hr = GetEntityHeading(entity) + 90.0
 if hr < 0.0 then hr = 360.0 + hr end
 hr = hr * 0.0174533
 return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end