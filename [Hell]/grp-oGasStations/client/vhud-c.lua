-- VARIABLES
local waittime = 500
local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,15,16,17,18,19,20};
local toghud = true
--seatbelt locals
local seatbeltEjectSpeed = 65
local seatbeltEjectAccel = 80
local seatbeltIsOn = false
local inVehicle = false
local currSpeed = 0.0
--location
local zones = { ['AIRP'] = "Airport LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
-- time
local curTime = ''
--nitro
local nitro = 0
local watchon = false
local stopWatchDisplay = false
local uiopen = false
-- START

RegisterNetEvent('amp-hud:nitro')
AddEventHandler('amp-hud:nitro', function(percent)
  nitro = percent
end)

RegisterNetEvent('veh:seatbelt')
AddEventHandler('veh:seatbelt', function(status)
	seatbeltIsOn = status
end)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)
    if show then
        toghud = true
    else
        toghud = false
    end
end)

RegisterNetEvent('hud:toggleWatch')
AddEventHandler('hud:toggleWatch', function()
	watchon = not watchon
	if watchon then
		SendNUIMessage({action = "toggleWatch", show = true})
	else
		SendNUIMessage({action = "toggleWatch", show = false})
	end
end)

-- HUD
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed, false) then
			--waittime = 150
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			if not inVehicle then
				inVehicle = true
				SendNUIMessage({action = "toggleCar", show = true})
				DisplayRadar(true)
			end

			SendNUIMessage({action = "updateGas", key = "gas", value = Fuel})

			if Fuel < 15 then
				if not IsThisModelABike(GetEntityModel(veh)) then
					TriggerEvent("CarFuelAlarm")
				end
			end

			if nitro ~= 0 then
				SendNUIMessage({action = "updateNitro", key = "nitro", value = nitro, show = true})
			else
				SendNUIMessage({action = "updateNitro", show = false})
			end
			
		else
			if seatbeltIsOn or IsRadarEnabled() or not toghud then 
				--waittime = 0
				TriggerEvent("veh:seatbelt", false)
				SendNUIMessage({action = "seatbelt", status = seatbeltIsOn})
				if inVehicle then
					inVehicle = false
					SendNUIMessage({action = "toggleCar", show = false})
				end
				DisplayRadar(false)
			end
			if watchon then
				SendNUIMessage({action = "toggleWatch", show = true})
			end
		end
	end
end)

-- HEADLIGHTS
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local player = PlayerPedId()

		if IsPedInAnyVehicle(player, false) then
			local vehicle = GetVehiclePedIsIn(player, false)
			local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
			local vehicleIsLightsOn

			if vehicleLights == 1 and vehicleHighlights == 0 then
				vehicleIsLightsOn = 'normal'
			elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
				vehicleIsLightsOn = 'high'
			else
				vehicleIsLightsOn = 'off'
			end
			SendNUIMessage({action = "lights", status = vehicleIsLightsOn})
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local player = GetPlayerPed(-1)

		-- SEATBELT
		if IsPedInAnyVehicle(player, false) then
			local vehicle = GetVehiclePedIsIn(player, false)
			local vehicleClass = GetVehicleClass(vehicle)

			if seatbeltIsOn then 
				local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
				if vehIsMovingFwd then
					DisableControlAction(27, 75, true)
					DisableControlAction(0, 75, true)
				end
			end

			if IsControlJustReleased(0, 29) and (has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8) then
				if not seatbeltIsOn then
					TriggerEvent('DoLongHudText', 'Seatbelt On', 1)
					TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",0.3)
					TriggerEvent("veh:seatbelt", true)
					SendNUIMessage({action = "seatbelt", status = seatbeltIsOn})
				else
					TriggerEvent('DoLongHudText', 'Seatbelt Off', 2)
					TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.7)
					TriggerEvent("veh:seatbelt", false)
					SendNUIMessage({action = "seatbelt", status = seatbeltIsOn})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    local area = GetLabelText(zone)
    playerStreetsLocation = area

    if not zone then
        zone = "UNKNOWN"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
    else
        playerStreetsLocation = "[" .. area .. "]"
	end
	
	while true do
		Citizen.Wait(1000)

		local Ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(Ped, false)
		local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        local time = CalculateTimeToDisplay()
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        local area = GetLabelText(zone)
		playerStreetsLocation = area

		PedCar = GetVehiclePedIsIn(Ped, false)
		if not PedCar or PedCar == 0 then
			PedCar = GetVehiclePedIsIn(Ped, true)
		end
		carSpeed = math.ceil(GetEntitySpeed(PedCar) * 1.23)
		
		if not zone then
            zone = "UNKNOWN"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
        else
            playerStreetsLocation = "[".. area .. "]"
        end

        street = playerStreetsLocation

		if watchon or IsPedInAnyVehicle(Ped, false) then

			local pos = GetEntityCoords(Ped)
			local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
			local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

            local atl = false
            if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(veh) * 3.28084)
            end
            local engine = false
            if GetVehicleEngineHealth(veh) < 400.0 then
                engine = true
            end
            local GasTank = false
            if GetVehiclePetrolTankHealth(veh) < 3002.0 then
                GasTank = true
            end

			SendNUIMessage({
				showhud = toghud,
				speed = carSpeed,
				showlocation = true,
				location = street,
				clock = true,
				showclock = time.hour .. ':' .. time.minute,
			})
		end
	end
end)

Citizen.CreateThread(function()
    Citizen.Wait(50)
    while true do
        SendNUIMessage({
            action = 'updateStatusHud',
            show = toghud,
		})
		
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local time = CalculateTimeToDisplay()
		if watchon and not stopWatchDisplay then
			SendNUIMessage({
				action = "updateWatchInfo",
				time = time.hour .. ':' .. time.minute,
				direction = math.floor(calcHeading(-GetEntityHeading(PlayerPedId()) % 360)),
			})
		end
	end
end)



-- COMPASS
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		local Ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(Ped, false)
		local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)

		if IsPedInAnyVehicle(Ped, false) and vehicleIsOn then
			SendNUIMessage({
				showcompass = true,
				direction = math.floor(calcHeading(-GetEntityHeading(PlayerPedId()) % 360)),
			})
		end
	end
end)

RegisterNetEvent("amp:useItem:watch")
AddEventHandler("amp:useItem:watch", function()
	TriggerEvent('hud:toggleWatch')
end)

-- TIME / CLOCK
function CalculateTimeToDisplay()
    hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

    if hour <= 12 then
        obj.ampm = 'AM'
    elseif hour >= 13 then
        obj.ampm = 'PM'
        hour = hour - 12
    end

    if minute <= 9 then
        minute = "0" .. minute
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

alarmset = false
RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
		TriggerEvent('DoLongHudText', 'Low Fuel.', 2)
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

---------------------------------
-- Compass
---------------------------------
 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end
