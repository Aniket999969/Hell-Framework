local GRPCore, selectedspawnposition = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) 
			GRPCore = obj 
		end)

		Citizen.Wait(0)
	end
end)

local myspawnpoints = {}
local spawning = false

currentselection = 1

RegisterNetEvent('hotel:createRoom')
AddEventHandler('hotel:createRoom', function(numMultiplier,roomType,mykeys,illness,isImprisoned,isClothesSpawn)
	local imprisoned = false
	imprisoned = isImprisoned
	spawning = false
	TriggerEvent("spawning",true)
	FreezeEntityPosition(PlayerPedId(),true)
	SetEntityCoords(PlayerPedId(), 152.09986877441 , -1004.7946166992, -98.999984741211)
	SetEntityInvincible(PlayerPedId(),true)
	selectedspawnposition = GRPCore.GetPlayerData()["lastPosition"]

	myspawnpoints  = {
		[1] =  { ['x'] = -204.93,['y'] = -1010.13,['z'] = 29.55,['h'] = 180.99, ['info'] = ' Altee Street Train Station', ["typeSpawn"] = 1 },
		[2] =  { ['x'] = 272.16,['y'] = 185.44,['z'] = 104.67,['h'] = 320.57, ['info'] = ' Vinewood Blvd Taxi Stand', ["typeSpawn"] = 1 },
		[3] =  { ['x'] = -1833.96,['y'] = -1223.5,['z'] = 13.02,['h'] = 310.63, ['info'] = ' The Boardwalk', ["typeSpawn"] = 1 },
		[4] =  { ['x'] = 145.62,['y'] = 6563.19,['z'] = 32.0,['h'] = 42.83, ['info'] = ' Paleto Gas Station', ["typeSpawn"] = 1 },
		[5] =  { ['x'] = -214.24,['y'] = 6178.87,['z'] = 31.17,['h'] = 40.11, ['info'] = ' Paleto Bus Stop', ["typeSpawn"] = 1 },
		[6] =  { ['x'] = 1122.11,['y'] = 2667.24,['z'] = 38.04,['h'] = 180.39, ['info'] = ' Harmony Motel', ["typeSpawn"] = 1 },
		[7] =  { ['x'] = 453.29,['y'] = -662.23,['z'] = 28.01,['h'] = 5.73, ['info'] = ' LS Bus Station', ["typeSpawn"] = 1 },
		[8] =  { ['x'] = -1266.53,['y'] = 273.86,['z'] = 64.66,['h'] = 28.52, ['info'] = ' The Richman Hotel', ["typeSpawn"] = 1 },
		[9] =  { ['x'] = 259.114,['y'] = -654.0481,['z'] = 42.01986,['h'] = 10.73, ['info'] = ' Integrity Way', ["typeSpawn"] = 1 },
		[10] =  { ['x'] = 292.7334,['y'] = -1089.514,['z'] = 29.40647,['h'] = 296.7173, ['info'] = ' Fantastic Plaza', ["typeSpawn"] = 1 },
		[11] =  { ['x'] = -679.6422,['y'] = -1109.527,['z'] = 14.52532,['h'] = 348.7846, ['info'] = ' South Rockford Drive', ["typeSpawn"] = 1 },
		[12] =  { ['x'] = -1283.36,['y'] = -418.2161,['z'] = 34.72104,['h'] = 242.3938, ['info'] = ' Morningwood Blvd', ["typeSpawn"] = 1 },
		[13] =  { ['x'] = -608.6765,['y'] = 27.18178,['z'] = 42.40987,['h'] = 176.3476, ['info'] = ' Tinsel Towers', ["typeSpawn"] = 1 },
	}


	if illness == "dead" or illness == "icu" then
		return
	end

	local rooster = exports["isPed"]:GroupRank("rooster_academy")
	if rooster >= 2 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = -172.83,['y'] = 331.17,['z'] = 93.76,['h'] = 266.08, ['info'] = ' Rooster Cab', ["typeSpawn"] = 1 }
	end

	if isClothesSpawn then
		local apartmentName = ' Apartments 1'
		if roomType == 1 then
			apartmentName = ' Apartments 1'
		elseif roomType == 2 then
			apartmentName = ' Apartments 2'
		else
			apartmentName = ' Apartments 3'
		end

		for k,v in pairs(myspawnpoints) do
			if v.info == apartmentName then
				currentselection = k
			end
		end

		confirmSpawning(true)
	else
		if not imprisoned then
			SendNUIMessage({
				openSection = "main",
			})

			SetNuiFocus(true,true)
			doSpawn(myspawnpoints)
			DoScreenFadeIn(2500)
			doCamera()
		elseif imprisoned then
			DoScreenFadeIn(2500)
			doCamera(true)
		end
	end
end)


RegisterNUICallback('selectedspawn', function(data, cb)

	if spawning then
		return
	end
    currentselection = data.tableidentifier
    -- altercam
    doCamera()
end)
RegisterNUICallback('confirmspawn', function(data, cb)
	spawning = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	SendNUIMessage({
		openSection = "close",
	})	
	startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(false, true, 500, true, true)
	SetCamActiveWithInterp(cam, cam2, 3700, true, true)
	SetEntityVisible(PlayerPedId(), true, 0)
	FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvisibleLocally(PlayerPedId(), false)
    SetPlayerInvincible(PlayerPedId(), false)

    DestroyCam(startcam, false)
    DestroyCam(cam, false)
    DestroyCam(cam2, false)
    Citizen.Wait(0)
    FreezeEntityPosition(GetPlayerPed(-1), false)
	confirmSpawning(false)
end)

function confirmSpawning(isClothesSpawn)

	local x = myspawnpoints[currentselection]["x"]
	local y = myspawnpoints[currentselection]["y"]
	local z = myspawnpoints[currentselection]["z"]
	local h = myspawnpoints[currentselection]["h"]

	ClearFocus()

	SetNuiFocus(false,false)
	-- spawn them here.
    
    
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	DestroyCam(cam, false)

	
	if myspawnpoints[currentselection]["typeSpawn"] == 1 then
		SetEntityCoords(PlayerPedId(),x,y,z)
		SetEntityHeading(PlayerPedId(),h)		
	elseif myspawnpoints[currentselection]["typeSpawn"] == 2 then
		defaultSpawn()
	elseif myspawnpoints[currentselection]["typeSpawn"] == 3 then
		local house_id = myspawnpoints[currentselection]["house_id"]
		local house_model = myspawnpoints[currentselection]["house_model"]
		TriggerEvent("EnterMotelRoom")
	else
		print("error spawning?")
	end
	
	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)

	Citizen.Wait(2000)
	DoScreenFadeIn(5000)
	TriggerEvent("spawning",false)

	if isClothesSpawn then
	end


	if(DoesCamExist(cam)) then
		DestroyCam(cam, false)
	end


	local xPlayer = GRPCore.GetPlayerData()
	TriggerEvent("DoLongHudText", "You're now " .. xPlayer.job.label,3)
	TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
	TriggerEvent('police:setAnimEmotes')
	Wait(100)
end

--	mykeys[i] = { ["house_name"] = results[i].house_name, ["house_poi"] = pois,  ["table_id"] = results[i].id, ["owner"] = true, ["house_id"] = results[i].house_id, ["house_model"] = results[i].house_model, ["house_name"] = results[i].house_name }

-- "typeSpawn" 1 = no building, 2 = default housing, 3 = house/offices with address
function doSpawn(array)

	for i = 1, #array do

		SendNUIMessage({
			openSection = "enterspawn",
			textmessage = array[i]["info"],
			tableid = i,
		})
	end
	-- /halt script fill html and allow selection.
end

cam = 0
local camactive = false
local killcam = true
function doCamera(prison)
	killcam = true
	if spawning then
		return
	end
	Citizen.Wait(1)
	killcam = false
	local camselection = currentselection
	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	local x,y,z,h

	if prison then
		 x = 1802.51
		 y = 2607.19
		 z = 46.01
		 h = 93.0
	else
		 x = myspawnpoints[currentselection]["x"]
		 y = myspawnpoints[currentselection]["y"]
		 z = myspawnpoints[currentselection]["z"]
		 h = myspawnpoints[currentselection]["h"]
	end
	
	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 and camselection == currentselection and not spawning and not killcam do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(1)
	end

end