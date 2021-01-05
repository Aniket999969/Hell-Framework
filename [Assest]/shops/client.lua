GRPCore          = nil

Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end
end)

local vendingMachines = {
	[1] = 690372739,
	[2] = 1114264700,
	[3] = 690372739, 
	[4] = -2015792788,
	[5] = -1318035530,
	[6] = 73774428, 
	[7] = -1317235795, 
	[8] = -654402915,
}

local methlocation = { ['x'] = 1763.75,['y'] = 2499.44,['z'] = 50.43,['h'] = 213.58, ['info'] = ' cell1' }
------------------------------
--FONCTIONS
-------------------------------
local cellcoords = { 
	[1] =  { ['x'] = 1763.75,['y'] = 2499.44,['z'] = 50.43,['h'] = 213.58, ['info'] = ' cell1' },
	[2] =  { ['x'] = 1761.18,['y'] = 2497.56,['z'] = 50.43,['h'] = 208.44, ['info'] = ' cell2' },
	[3] =  { ['x'] = 1758.35,['y'] = 2495.69,['z'] = 50.43,['h'] = 201.86, ['info'] = ' cell3' },
	[4] =  { ['x'] = 1755.23,['y'] = 2494.2,['z'] = 50.43,['h'] = 202.71, ['info'] = ' cell4' },
	[5] =  { ['x'] = 1752.35,['y'] = 2492.39,['z'] = 50.43,['h'] = 201.77, ['info'] = ' cell5' },
	[6] =  { ['x'] = 1749.21,['y'] = 2490.48,['z'] = 50.43,['h'] = 212.78, ['info'] = ' cell6' },
	[7] =  { ['x'] = 1745.86,['y'] = 2488.94,['z'] = 50.43,['h'] = 213.06, ['info'] = ' cell7' },
	[8] =  { ['x'] = 1743.28,['y'] = 2486.98,['z'] = 50.43,['h'] = 212.35, ['info'] = ' cell8' },
	[9] =  { ['x'] = 1743.2,['y'] = 2486.85,['z'] = 45.82,['h'] = 212.24, ['info'] = ' cell9' },
	[10] =  { ['x'] = 1745.87,['y'] = 2489.08,['z'] = 45.82,['h'] = 208.68, ['info'] = ' cell10' },
	[11] =  { ['x'] = 1748.99,['y'] = 2490.77,['z'] = 45.82,['h'] = 202.26, ['info'] = ' cell11' },
	[12] =  { ['x'] = 1752.14,['y'] = 2492.47,['z'] = 45.82,['h'] = 208.49, ['info'] = ' cell12' },
	[13] =  { ['x'] = 1755.08,['y'] = 2494.0,['z'] = 45.82,['h'] = 212.58, ['info'] = ' cell13' },
	[14] =  { ['x'] = 1761.12,['y'] = 2497.27,['z'] = 45.83,['h'] = 215.37, ['info'] = ' cell14' },
	[15] =  { ['x'] = 1763.93,['y'] = 2499.34,['z'] = 45.83,['h'] = 217.65, ['info'] = ' cell15' },
	[16] =  { ['x'] = 1772.74,['y'] = 2482.72,['z'] = 50.43,['h'] = 24.74, ['info'] = ' cell16' },
	[17] =  { ['x'] = 1769.67,['y'] = 2480.9,['z'] = 50.43,['h'] = 29.66, ['info'] = ' cell17' },
	[18] =  { ['x'] = 1766.94,['y'] = 2479.04,['z'] = 50.43,['h'] = 32.87, ['info'] = ' cell18' },
	[19] =  { ['x'] = 1763.79,['y'] = 2477.64,['z'] = 50.42,['h'] = 22.54, ['info'] = ' cell19' },
	[20] =  { ['x'] = 1760.55,['y'] = 2476.16,['z'] = 50.42,['h'] = 38.85, ['info'] = ' cell20' },
	[21] =  { ['x'] = 1757.82,['y'] = 2473.99,['z'] = 50.42,['h'] = 32.59, ['info'] = ' cell21' },
	[22] =  { ['x'] = 1754.61,['y'] = 2472.72,['z'] = 50.42,['h'] = 38.6, ['info'] = ' cell22' },
	[23] =  { ['x'] = 1751.35,['y'] = 2470.67,['z'] = 50.42,['h'] = 31.17, ['info'] = ' cell23' },
	[24] =  { ['x'] = 1772.55,['y'] = 2483.08,['z'] = 45.82,['h'] = 33.01, ['info'] = ' cell24' },
	[26] =  { ['x'] = 1769.41,['y'] = 2481.15,['z'] = 45.82,['h'] = 32.61, ['info'] = ' cell25' },
	[27] =  { ['x'] = 1766.78,['y'] = 2478.99,['z'] = 45.82,['h'] = 27.96, ['info'] = ' cell26' },
	[28] =  { ['x'] = 1763.71,['y'] = 2477.66,['z'] = 45.82,['h'] = 33.65, ['info'] = ' cell27' },
	[29] =  { ['x'] = 1760.7,['y'] = 2475.73,['z'] = 45.82,['h'] = 30.13, ['info'] = ' cell28' },
	[30] =  { ['x'] = 1757.74,['y'] = 2473.94,['z'] = 45.82,['h'] = 29.95, ['info'] = ' cell29' },
	[31] =  { ['x'] = 1754.95,['y'] = 2471.86,['z'] = 45.82,['h'] = 40.79, ['info'] = ' cell30' },
	[32] =  { ['x'] = 1751.72,['y'] = 2470.46,['z'] = 45.82,['h'] = 13.22, ['info'] = ' cell31' },

}

local tool_shops = {
	{ ['x'] = 44.838947296143, ['y'] = -1748.5364990234, ['z'] = 29.549386978149 },
	{ ['x'] = 2749.2309570313, ['y'] = 3472.3308105469, ['z'] = 55.679393768311 },
}

local twentyfourseven_shops = {
	{ ['x'] = 1961.1140136719, ['y'] = 3741.4494628906, ['z'] = 32.34375 },
	{ ['x'] = 1392.4129638672, ['y'] = 3604.47265625, ['z'] = 34.980926513672 },
	{ ['x'] = 546.98962402344, ['y'] = 2670.3176269531, ['z'] = 42.156539916992 },
	{ ['x'] = 2556.2534179688, ['y'] = 382.876953125, ['z'] = 108.62294769287 },
	{ ['x'] = -1821.9542236328, ['y'] = 792.40191650391, ['z'] = 138.13920593262 },
	{ ['x'] = -1223.6690673828, ['y'] = -906.67517089844, ['z'] = 12.326356887817 },
	{ ['x'] = -708.19256591797, ['y'] = -914.65264892578, ['z'] = 19.215591430664 },
	{ ['x'] = 26.419162750244, ['y'] = -1347.5804443359, ['z'] = 29.497024536133 },
	{ ['x'] = 436.144, ['y'] = -985.824, ['z'] = 30.6896 },
	{ ['x'] = -45.4649, ['y'] = -1754.41, ['z'] = 29.421 },
	{ ['x'] = 24.5889, ['y'] = -1342.32, ['z'] = 29.497 },
	{ ['x'] = -707.394, ['y'] = -910.114, ['z'] = 19.2156 },
	{ ['x'] = 1162.87, ['y'] = -319.218, ['z'] = 69.2051 },
	{ ['x'] = 373.872, ['y'] = 331.028, ['z'] = 103.566 },
	{ ['x'] = 2552.47, ['y'] = 381.031, ['z'] = 108.623 },
	{ ['x'] = -1823.67, ['y'] = 796.291, ['z'] = 138.126 },
	{ ['x'] = 2673.91, ['y'] = 3281.77, ['z'] = 55.2411 },
	{ ['x'] = 1957.64, ['y'] = 3744.29, ['z'] = 32.3438 },
	{ ['x'] = 1701.97, ['y'] = 4921.81, ['z'] = 42.0637 },
	{ ['x'] = 1730.06, ['y'] = 6419.63, ['z'] = 35.0372 },
	{ ['x'] = 1842.973,['y'] = 2570.243,['z'] = 46.02 },
	{ ['x'] = -436.94,['y'] = 6007.02,['z'] = 31.72 }, -- paletopd
}

local weashop_locations = {
	{entering = {811.973572,-2155.33862,28.8189938}, inside = {811.973572,-2155.33862,28.8189938}, outside = {811.973572,-2155.33862,28.8189938},delay = 900},
	{entering = { 1692.54, 3758.13, 34.71}, inside = { 1692.54, 3758.13, 34.71}, outside = { 1692.54, 3758.13, 34.71},delay = 600},
	{entering = {252.915,-48.186,69.941}, inside = {252.915,-48.186,69.941}, outside = {252.915,-48.186,69.941},delay = 600},
	{entering = {844.352,-1033.517,28.094}, inside = {844.352,-1033.517,28.194}, outside = {844.352,-1033.517,28.194},delay = 780},
	{entering = {-331.487,6082.348,31.354}, inside = {-331.487,6082.348,31.454}, outside = {-331.487,6082.348,31.454},delay = 600},
	{entering = {-664.268,-935.479,21.729}, inside = {-664.268,-935.479,21.829}, outside = {-664.268,-935.479,21.829},delay = 600},
	{entering = {-1305.427,-392.428,36.595}, inside = {-1305.427,-392.428,36.695}, outside = {-1305.427,-392.428,36.695},delay = 600},
	{entering = {-1119.1, 2696.92, 18.56}, inside = {-1119.1, 2696.92, 18.56}, outside = {-1119.1, 2696.92, 18.56},delay = 600},
	{entering = {2569.978,294.472,108.634}, inside = {2569.978,294.472,108.734}, outside = {2569.978,294.472,108.734},delay = 800},
	{entering = {-3172.584,1085.858,20.738}, inside = {-3172.584,1085.858,20.838}, outside = {-3172.584,1085.858,20.838},delay = 600},
	{entering = {20.0430,-1106.469,29.697}, inside = {20.0430,-1106.469,29.797}, outside = {20.0430,-1106.469,29.797},delay = 600},
}


local weashop_blips = {}

RegisterNetEvent("shop:createMeth")
AddEventHandler("shop:createMeth", function()
	methlocation = cellcoords[math.random(#cellcoords)]
end)


RegisterNetEvent("shop:isNearPed")
AddEventHandler("shop:isNearPed", function()
	local pedpos = GetEntityCoords(PlayerPedId())
	local found = false
	for k,v in ipairs(twentyfourseven_shops)do
		local dist = #(vector3(v.x, v.y, v.z) - vector3(pedpos.x,pedpos.y,pedpos.z))
		if(dist < 10 and not found)then
			found = true
			TriggerServerEvent("exploiter", "User sold to a shop keeper at store.")
		end
	end
end)

function setShopBlip()

	for station,pos in pairs(weashop_locations) do
		local loc = pos
		pos = pos.entering
		local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
		-- 60 58 137
		SetBlipSprite(blip,110)
		SetBlipScale(blip, 0.85)
		SetBlipColour(blip, 17)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Ammunation')
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip,true)
		SetBlipAsMissionCreatorBlip(blip,true)
		weashop_blips[#weashop_blips+1]= {blip = blip, pos = loc}
	end

	for k,v in ipairs(twentyfourseven_shops)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Shop")
		EndTextCommandSetBlipName(blip)
	end

	for k,v in ipairs(tool_shops)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tool Shop")
		EndTextCommandSetBlipName(blip)
	end	

end
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


Citizen.CreateThread(function()
	
	setShopBlip()

	while true do

		local found = false
		Citizen.Wait(1)
		local dstscan = 3.0
		local pos = GetEntityCoords(PlayerPedId(), false)

		for i,b in ipairs(weashop_blips) do
			local scanned = #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - pos)
			if scanned < dstscan then
				dstscan = scanned
			end
			if dstscan < 2.5 then
				DrawMarker(27,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,1.001,1.0001,0.5001,0,155,255,50,0,0,0,0)
				if IsPedInAnyVehicle(PlayerPedId(), true) == false and dstscan < 0.25 then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
					if IsControlJustPressed(1, 38) then	
						GRPCore.TriggerServerCallback('grp-license:checkLicense', function(hasWeaponLicense)
							if hasWeaponLicense then
								TriggerEvent("server-inventory-open", "5", "Shop");	
							else
								TriggerEvent('DoLongHudText', "You do not have a Weapon's License. Contact the Police.", 2)
								end
							end, GetPlayerServerId(PlayerId()), 'weapon')
						Wait(1000)
				    end
				end
			end
		end


		-- if(Vdist( 1000.94, -115.18, 74.19, pos.x, pos.y, pos.z) < 20.0)then
		-- 	found = true
		-- 	-- TODO: At a later date move location
		-- 	-- DrawMarker(27,  977.81, -101.04, 74.85 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
		-- 	if(Vdist( 1000.94, -115.18, 74.19, pos.x, pos.y, pos.z) < 2.0)then
		-- 		-- DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~craft bench.")
		-- 		if IsControlJustPressed(1, 38) and exports["isPed"]:GroupRank("parts_shop") > 3 then	
		-- 			TriggerEvent("server-inventory-open", "16", "Craft");
		-- 			Wait(1000)	
		-- 			--TriggerEvent("openSubMenu","shop")
		-- 	    end
		-- 	end
		-- end

		-- if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 20.0)then
		-- 	found = true
		-- 	DrawMarker(27,  1108.45, -2007.2, 30.95 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
		-- 	if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 2.0)then
		-- 		DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~smelter.")
		-- 		if IsControlJustPressed(1, 38) then	
		-- 			local finished = exports["grp-taskbar"]:taskBar(60000,"Readying Smelter")
      	-- 			if (finished == 100) then
      	-- 				pos = GetEntityCoords(PlayerPedId(), false)
      	-- 				if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 2.0)then
		-- 					TriggerEvent("server-inventory-open", "17", "Craft");	
		-- 					Wait(1000)
		-- 				end
		-- 			end
		-- 			--TriggerEvent("openSubMenu","shop")
		-- 	    end
		-- 	end
		-- end





		if(Vdist( 306.49, -601.31, 43.29, pos.x, pos.y, pos.z) < 20.0)then
			found = true
			DrawMarker(27,  306.49, -601.31, 43.29 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist( 306.49, -601.31, 43.29, pos.x, pos.y, pos.z) < 2.0)then
				local job = GRPCore.GetPlayerData().job.name
				DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
				if IsControlJustPressed(1, 38) then	
					if (job == "ambulance") then
						TriggerEvent("server-inventory-open", "15", "Shop");	
					else
						TriggerEvent("server-inventory-open", "29", "Shop");	
					end
					
					--TriggerEvent("openSubMenu","shop")
			    end
			end
		end






		-- if(Vdist(467.69613647461,-992.7451171875,24.920822143555, pos.x, pos.y, pos.z) < 20.0)then
		-- 	found = true
		-- 	DrawMarker(27, 467.69613647461,-992.7451171875,24.920822143555 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
		-- 	if(Vdist(467.69613647461,-992.7451171875,24.920822143555, pos.x, pos.y, pos.z) < 2.0)then
		-- 		local job = exports["isPed"]:isPed("myjob")
		-- 		DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
		-- 		if IsControlJustPressed(1, 38) and job == "police" then	
		-- 			TriggerEvent("server-inventory-open", "10", "Shop");	
		-- 			Wait(1000)
		-- 			--TriggerEvent("openSubMenu","shop")
		-- 	    end
		-- 	end
		-- end

		if(Vdist(452.4139, -980.1369, 30.68969, pos.x, pos.y, pos.z) < 20.0)then
			found = true
			local job = GRPCore.GetPlayerData().job.name
			if job == "police" then
			DrawMarker(27, 452.4139, -980.1369, 30.68969 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(452.4139, -980.1369, 30.68969, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
				if IsControlJustPressed(1, 38) then	
					TriggerEvent("server-inventory-open", "10", "Shop");	
					Wait(1000)
					end
			    end
			end
		end


		-- if(Vdist(461.72647094727,-982.73687744141,30.689556121826, pos.x, pos.y, pos.z) < 20.0)then
		-- 	found = true
		-- 	DrawMarker(461.72647094727,-982.73687744141,30.689556121826 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
		-- 	if(Vdist(461.72647094727,-982.73687744141,30.689556121826, pos.x, pos.y, pos.z) < 2.0)then
		-- 		local job = exports["isPed"]:isPed("myjob")
		-- 		DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
		-- 		if IsControlJustPressed(1, 38)  then	
		-- 			TriggerEvent("server-inventory-open", "29", "Shop");	
		-- 			Wait(1000)
		-- 			--TriggerEvent("openSubMenu","shop")
		-- 	    end
		-- 	end
		-- end


		if(Vdist(256.18,-368.91,-44.13, pos.x, pos.y, pos.z) < 20.0)then
			found = true
			DrawMarker(27, 256.18,-368.91,-44.13 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(256.18,-368.91,-44.13, pos.x, pos.y, pos.z) < 3.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
				if IsControlJustPressed(1, 38) then	
					TriggerEvent("server-inventory-open", "14", "Shop");	
					Wait(1000)
					--TriggerEvent("openSubMenu","shop")
			    end
			end
		end


		if(Vdist(105.2,3600.14, 40.73, pos.x, pos.y, pos.z) < 20.0)then
			found = true
			DrawMarker(27, 105.2,3600.14, 40.73 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(105.2,3600.14, 40.73, pos.x, pos.y, pos.z) < 3.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~g~ Craft.")
				if IsControlJustPressed(1, 38) and exports["isPed"]:GroupRank("lost_mc") >= 3 then	
  					pos = GetEntityCoords(PlayerPedId(), false)
  					if(Vdist(105.2,3600.14, 40.73, pos.x, pos.y, pos.z) < 3.0)then
						TriggerEvent("server-inventory-open", "9", "Craft");
						Wait(1000)	
					end
			    end
			end
		end


		-- if(Vdist(885.61,-3199.84,-98.19, pos.x, pos.y, pos.z) < 20.0)then
		-- 	found = true
		-- 	DrawMarker(27, 885.61,-3199.84,-98.19 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
		-- 	if(Vdist(885.61,-3199.84,-98.19, pos.x, pos.y, pos.z) < 3.0)then
		-- 		DisplayHelpText("Press ~INPUT_CONTEXT~ to ~g~ CRAFT.")
		-- 		if IsControlJustPressed(1, 38) then	

  		-- 			pos = GetEntityCoords(PlayerPedId(), false)
  		-- 			if(Vdist(885.61,-3199.84,-98.19, pos.x, pos.y, pos.z) < 3.0)then
		-- 				TriggerEvent("server-inventory-open", "6", "Craft");
		-- 				Wait(1000)	
		-- 			end

		-- 	    end
		-- 	end
		-- end
		 
		--[1] =  { ['x'] = 105.2,['y'] = 3600.14,['z'] = 40.73,['h'] = 102.26, ['info'] = ' craft new bikeirsy' },
-- [2] =  { ['x'] = 206.21,['y'] = -1852.54,['z'] = 27.48,['h'] = 10.05, ['info'] = ' wqek' },

--[2] =  { ['x'] = 885.61,['y'] = -3199.84,['z'] = -98.19,['h'] = 56.8, ['info'] = ' crafting' },
--[3] =  { ['x'] = 902.21,['y'] = -3182.47,['z'] = -97.05,['h'] = 272.78, ['info'] = ' Storage' },
		if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 20.0)then
			found = true
			DrawMarker(27,  1108.45, -2007.2, 30.95 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~smelter.")
				if IsControlJustPressed(1, 38) then	
					local finished = exports["grp-taskbar"]:taskBar(60000,"Readying Smelter")
      				if (finished == 100) then
      					pos = GetEntityCoords(PlayerPedId(), false)
      					if(Vdist( 1108.45, -2007.2, 30.95, pos.x, pos.y, pos.z) < 2.0)then
							TriggerEvent("server-inventory-open", "17", "Craft");	
							Wait(1000)
						end
					end
					--TriggerEvent("openSubMenu","shop")
			    end
			end
		end




		for k,v in ipairs(twentyfourseven_shops) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
				found = true
				DrawMarker(27, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 3.0)then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~shop.")
					if IsControlJustPressed(1, 38) then	
						TriggerEvent("server-inventory-open", "2", "Shop");	
						Wait(1000)
						--TriggerEvent("openSubMenu","shop")
				    end
                end
            end
		end

		if(Vdist(1783.16, 2557.02, 45.68, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			DrawMarker(27, 1783.16, 2557.02, 45.68 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(1783.16, 2557.02, 45.68, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to look at food")
				if IsControlJustPressed(1, 38) then
					TriggerEvent("server-inventory-open", "22", "Shop");
					Wait(1000)
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
		end
		
		if(Vdist(1775.8272705078,2587.4946289063,45.712657928467, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			DrawMarker(27, 1775.8272705078,2587.4946289063,45.712657928467 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(1775.8272705078,2587.4946289063,45.712657928467, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to look at food")
				if IsControlJustPressed(1, 38) then
					TriggerEvent("server-inventory-open", "22", "Shop");
					Wait(1000)
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
        end

    	if(Vdist(methlocation["x"],methlocation["y"],methlocation["z"], pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(methlocation["x"],methlocation["y"],methlocation["z"], pos.x, pos.y, pos.z) < 5.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) then
					local finished = exports["grp-taskbar"]:taskBar(60000,"Searching...")
      				if (finished == 100) and Vdist(methlocation["x"],methlocation["y"],methlocation["z"], pos.x, pos.y, pos.z) < 2.0 then
						TriggerEvent("server-inventory-open", "25", "Shop");
						Wait(1000)
					end
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
        end   
    	if(Vdist(1663.36, 2512.99, 46.87, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1663.36, 2512.99, 46.87, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1663.36, 2512.99, 46.87, pos.x, pos.y, pos.z) < 2.0) then
					local finished = exports["grp-taskbar"]:taskBar(60000,"Searching...")
      				if (finished == 100) then
						TriggerEvent("server-inventory-open", "26", "Shop");
						Wait(1000)
					end
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
        end   

    	if(Vdist(1775.6893310547,2593.6455078125,45.723571777344, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1775.6893310547,2593.6455078125,45.723571777344, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1775.6893310547,2593.6455078125,45.723571777344, pos.x, pos.y, pos.z) < 2.0) then
					local finished = exports["grp-taskbar"]:taskBar(60000,"Making a god slushy...")
      				if (finished == 100) then
						TriggerEvent("server-inventory-open", "27", "Shop");
						Wait(1000)
					end
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
		end   
		
		if(Vdist(3094.623,-4715.215,27.27864, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(3094.623,-4715.215,27.27864, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(3094.623,-4715.215,27.27864, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "104", "Craft");
						Wait(1000)
			    	end
            	end
			end   
			
		if(Vdist(1713.245,-1555.175,113.9422, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1713.245,-1555.175,113.9422, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) and (Vdist(1713.245,-1555.175,113.9422, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "105", "Craft");
						Wait(1000)
			    	end
            	end
			end
			
		if(Vdist(-343.6864, -140.0516, 39.00968, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			local job = GRPCore.GetPlayerData().job.name
			if job == "mechanic" then
			DrawMarker(27, -343.6864, -140.0516, 39.2 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(-343.6864, -140.0516, 39.00968, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ Open Mechanic Crafting")
				if IsControlJustPressed(1, 38) and (Vdist(-343.6864, -140.0516, 39.00968, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "55", "Craft");  
						Wait(1000)
			    	end
            	end
        	end   
		end

		if(Vdist(-345.0014, -109.2862, 39.2, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			local job = GRPCore.GetPlayerData().job.name
			if job == "mechanic" then
			DrawMarker(27, -345.0014, -109.2862, 39.2 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(-345.0014, -109.2862, 39.2, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ Open Mechanic Stash")
				if IsControlJustPressed(1, 38) and (Vdist(-345.0014, -109.2862, 39.2, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "1", "LSC Stash") 
						Wait(1000)
			    	end
            	end
        	end   
		end

		if(Vdist(467.63592529297,-993.21063232422,24.920820236206, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			local job = GRPCore.GetPlayerData().job.name
			if job == "police" then
			DrawMarker(27, 467.63592529297,-993.21063232422,24.920820236206 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(467.63592529297,-993.21063232422,24.920820236206, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ Open Junk Locker")
				if IsControlJustPressed(1, 38) and (Vdist(467.63592529297,-993.21063232422,24.920820236206, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "1", "Junk Locker")
						Wait(1000)
			    	end
            	end
        	end   
		end


		if(Vdist(1777.58, 2565.15, 45.68, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			if(Vdist(1777.58, 2565.15, 45.68, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ what dis?")
				if IsControlJustPressed(1, 38) then
					local finished = exports["grp-taskbar"]:taskBar(60000,"Searching...")
      				if (finished == 100) and (Vdist(1777.58, 2565.15, 45.68, pos.x, pos.y, pos.z) < 2.0) then
						TriggerEvent("server-inventory-open", "23", "Craft");
						Wait(1000)
					end
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
        end


		if(Vdist(-632.64, 235.25, 81.89, pos.x, pos.y, pos.z) < 10.0)then
			found = true
			DrawMarker(27, -632.64, 235.25, 81.89 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
			if(Vdist(-632.64, 235.25, 81.89, pos.x, pos.y, pos.z) < 5.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to purchase Hipster")
				if IsControlJustPressed(1, 38) then
					TriggerEvent("server-inventory-open", "12", "Shop");
					Wait(1000)
					--TriggerEvent("openSubMenu","burgershot")
			    end
            end
        end 

		for k,v in ipairs(tool_shops) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
				found = true
				DrawMarker(27, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 3.0)then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to open the ~g~tool shop.")
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open", "4", "Shop");
						Wait(1000)
						--TriggerEvent("openSubMenu","tool")
				    end
                end
            end
		end

		if not found and dstscan > 2.5 then
			Wait(1200)
		end

	end

end)
