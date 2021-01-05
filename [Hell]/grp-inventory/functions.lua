GRPCore = nil
local Licenses = {}
Citizen.CreateThread(function()
	while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
        Citizen.Wait(0)
        TriggerServerEvent("playerSpawned")
	end

	while GRPCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	GRPCore.PlayerData = GRPCore.GetPlayerData()
end)


Citizen.CreateThread(function()
    while GRPCore == nil or GRPCore.PlayerData == nil or GRPCore.PlayerData.job == nil do
        Citizen.Wait(1)
    end
end)


RegisterNetEvent('grp:setJob')
AddEventHandler('grp:setJob', function(job)
	GRPCore.PlayerData.job = job
end)



local fixingvehicle = false
local justUsed = false
local retardCounter = 0
local lastCounter = 0 
local HeadBone = 0x796e;



local validWaterItem = {
    ["oxygentank"] = true,
    ["water"] = true,
    ["vodka"] = true,
    ["beer"] = true,
    ["whiskey"] = true,
    ["coffee"] = true,
    ["fishtaco"] = true,
    ["taco"] = true,
    ["burrito"] = true,
    ["churro"] = true,
    ["hotdog"] = true,
    ["greencow"] = true,
    ["donut"] = true,
    ["eggsbacon"] = true,
    ["icecream"] = true,
    ["mshake"] = true,
    ["sandwich"] = true,
    ["hamburger"] = true,
    ["cola"] = true,
    ["jailfood"] = true,
    ["bleederburger"] = true,
    ["heartstopper"] = true,
    ["torpedo"] = true,
    ["meatfree"] = true,
    ["moneyshot"] = true,
    ["fries"] = true,
    ["slushy"] = true,

}



Citizen.CreateThread(function()
    TriggerServerEvent("inv:playerSpawned");
end)


Citizen.CreateThread(function()
    while true do 
     Citizen.Wait(0)
    
     if IsControlJustPressed(0, 311) then 
         TriggerEvent("OpenInv")
      end
    end
 end)


RegisterNetEvent("evLockers:openCaseFile")
AddEventHandler("evLockers:openCaseFile", function(id)
    local type = "evLocker"
    local evLockerName = "CASE ID: "..id
    Citizen.Wait(200)
    TriggerEvent("server-inventory-open", "1", "CASE ID: "..id)
	TriggerScreenblurFadeIn(0)
end)

RegisterNetEvent('RunUseItem')
AddEventHandler('RunUseItem', function(itemid, slot, inventoryName, isWeapon)

    if itemid == nil then
        return
    end
    local ItemInfo = GetItemInfo(slot)
    if tonumber(ItemInfo.quality) < 1 then
        TriggerEvent("DoLongHudText","Item is too worn.",2) 
        if isWeapon then
            TriggerEvent("brokenWeapon")
        end
        return
    end

    if justUsed then
        retardCounter = retardCounter + 1
        if retardCounter > 10 and retardCounter > lastCounter+5 then
            lastCounter = retardCounter
            TriggerServerEvent("exploiter", "Tried using " .. retardCounter .. " items in < 500ms ")
        end
        return
    end

    justUsed = true

    if (not hasEnoughOfItem(itemid,1,false)) then
        TriggerEvent("DoLongHudText","You dont appear to have this item on you?",2) 
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    if itemid == "-72657034" then
        TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
        TriggerEvent("inventory:removeItem",itemid, 1)
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    if not isValidUseCase(itemid,isWeapon) then
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    if (itemid == nil) then
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    
    if (isWeapon) then
        if tonumber(ItemInfo.quality) > 0 then
            TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
        end
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end



    TriggerEvent("hud-display-item",itemid,"Used")

    Wait(800)

    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)

    if (not IsPedInAnyVehicle(player)) then
        if (itemid == "Suitcase") then
            TriggerEvent('attach:suitcase')
        end

        if (itemid == "Boombox") then
                TriggerEvent('attach:boombox')
        end
        if (itemid == "Box") then
                TriggerEvent('attach:box')
        end
        if (itemid == "DuffelBag") then
                TriggerEvent('attach:blackDuffelBag')
        end
        if (itemid == "MedicalBag") then
                TriggerEvent('attach:medicalBag')
        end
        if (itemid == "SecurityCase") then
                TriggerEvent('attach:securityCase')
        end
        if (itemid == "Toolbox") then
                TriggerEvent('attach:toolbox')
        end
    end

    local remove = false
    local itemreturn = false
    local drugitem = false
    local fooditem = false
    local drinkitem = false
    local healitem = false

    if (itemid == "joint" or itemid == "weed5oz" or itemid == "weedq" or itemid == "beer" or itemid == "vodka" or itemid == "whiskey" or itemid == "lsdtab") then
        drugitem = true
    end

    if (itemid == "fakeplate") then
      TriggerEvent("fakeplate:change")
    end

    if (itemid == "tuner") then

      local finished = exports["grp-taskbar"]:taskBar(2000,"Connecting Tuner Laptop",false,false,playerVeh)
      if (finished == 100) then
        TriggerEvent("tuner:open")
      end
    end

    if (itemid == "electronickit" or itemid == "lockpick") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
      
    end

    -- Weed Plant Shit
    if (itemid == "purifiedwater" ) then
        if hasEnoughOfItem("purifiedwater",1,false) then
        TriggerServerEvent("grp-weedplants:purifiedwater",itemid)
        end
    end

    if (itemid == "highgradefert" ) then
        if hasEnoughOfItem("highgradefert",1,false) then
        TriggerServerEvent("grp-weedplants:highgradefert",itemid)
        end
    end

    if (itemid == "highgrademaleseed" ) then
        if (hasEnoughOfItem("highgrademaleseed",1,false) and hasEnoughOfItem('plantpot',1,false)) then
        TriggerServerEvent("grp-weedplants:highgrademaleseed",itemid)
        end
    end

    if (itemid == "highgradefemaleseed" ) then
        if (hasEnoughOfItem("highgradefemaleseed",1,false) and hasEnoughOfItem('plantpot',1,false)) then
        TriggerServerEvent("grp-weedplants:highgradefemaleseed",itemid)
        end
    end
    --
    if (itemid == "locksystem") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if (itemid == "thermite") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if(itemid == "evidencebag") then
        TriggerEvent("evidence:startCollect", itemid, slot)
        local itemInfo = GetItemInfo(slot)
        local data = itemInfo.information
        if data == '{}' then
            TriggerEvent("DoLongHudText","Start collecting evidence!",1) 
            TriggerEvent("inventory:updateItem", itemid, slot, '{"used": "true"}')
            --
        else
            local dataDecoded = json.decode(data)
            if(dataDecoded.used) then
                print('YOURE ALREADY COLLECTING EVIDENCE YOU STUPID FUCK')
            end
        end
    end

    if (itemid == "lsdtab" or itemid == "badlsdtab") then
        TriggerEvent("animation:PlayAnimation","pill")
        local finished = exports["grp-taskbar"]:taskBar(3000,"Placing LSD Strip on 👅",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",24,1200)
            TriggerEvent("fx:run", "lsd", 180, nil, (itemid == "badlsdtab" and true or false))
            remove = true
        end
    end

    if (itemid == "decryptersess" or itemid == "decrypterfv2" or itemid == "decrypterenzo") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
          local finished = exports["grp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if (finished == 100) then
            TriggerEvent("pixerium:check",3,"robbery:decrypt",true)
          end
      end

      if #(GetEntityCoords(player) - vector3( 2328.94, 2571.4, 46.71)) < 3.0 then
          local finished = exports["grp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if finished == 100 then
            TriggerEvent("pixerium:check",3,"robbery:decrypt2",true)
          end
      end

      if #(GetEntityCoords(player) - vector3( 1208.73,-3115.29, 5.55)) < 3.0 then
          local finished = exports["grp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if finished == 100 then
            TriggerEvent("pixerium:check",3,"robbery:decrypt3",true)
          end
      end
      
    end

    if (itemid == "pix1") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
          local finished = exports["grp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if (finished == 100) then
            TriggerEvent("Crypto:GivePixerium",math.random(1,2))
            remove = true
          end
      end
    end  

    if (itemid == "pix2") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
          local finished = exports["grp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if (finished == 100) then
            TriggerEvent("Crypto:GivePixerium",math.random(5,12))
            remove = true
          end
      end
    end


    if (itemid == "radio") then
        TriggerEvent('radioGui')
    end


    if (itemid == "femaleseed") then
       TriggerEvent("Evidence:StateSet",4,1600)
       TriggerEvent("weed:startcropInsideCheck","female")
       
    end

    if (itemid == "maleseed") then
        TriggerEvent("Evidence:StateSet",4,1600)
        TriggerEvent("weed:startcropInsideCheck","male")
    end

    if (itemid == "cr") then
        TriggerEvent("grp-doorlock:UseRedKeycard", itemid)
    end

    if (itemid == "weedoz") then
 
      local finished = exports["grp-taskbar"]:taskBar(5000,"Packing Q Bags",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("weedq", 40, true)
        end
        
    end

    if ( itemid == "smallbud" and hasEnoughOfItem("qualityscales",1,false) ) then
        local finished = exports["grp-taskbar"]:taskBar(1000,"Packing Joint",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("joint2", 80, true)    
        end
    end

    if (itemid == "weedq") then
        local finished = exports["grp-taskbar"]:taskBar(1000,"Rolling Joints",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("joint", 80, true)    
        end
    end

    if (itemid == "lighter") then
        TriggerEvent("animation:PlayAnimation","lighter")
          local finished = exports["grp-taskbar"]:taskBar(2000,"Starting Fire",false,false,playerVeh)
        if (finished == 100) then
            
        end
    end

    if (itemid == "joint" or itemid == "joint2") then
        local finished = exports["grp-taskbar"]:taskBar(2000,"Smoking Joint",false,false,playerVeh)
        if (finished == 100) then
            Wait(200)
            TriggerEvent("animation:PlayAnimation","weed")
            TriggerEvent("Evidence:StateSet",3,600)
            TriggerEvent("Evidence:StateSet",4,600)        
            TriggerEvent("stress:timed",1000,"WORLD_HUMAN_SMOKING_POT")
            remove = true
        end
    end

    if (itemid == "vodka" or itemid == "beer" or itemid == "whiskey") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
        TriggerEvent("Evidence:StateSet", 8, 600)
        local alcoholStrength = 0.5
        if itemid == "vodka" or itemid == "whiskey" then alcoholStrength = 1.0 end
        TriggerEvent("fx:run", "alcohol", 180, alcoholStrength)
    end

    if (itemid == "coffee") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","coffee:drink",true,itemid,playerVeh)
    end

    if (itemid == "fishtaco") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:FishTaco",true,itemid,playerVeh)
    end

    if (itemid == "taco" or itemid == "burrito") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Taco",true,itemid,playerVeh)
    end

    if (itemid == "churro" or itemid == "hotdog") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "greencow") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "donut" or itemid == "eggsbacon") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "icecream" or itemid == "mshake") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:IceCream",true,itemid,playerVeh)
    end



    if (itemid == "advlockpick") then
    if hasEnoughOfItem('advlockpick', 1, false) then
        TriggerEvent('houseRobberies:attempt')
        end   
    end


    if (itemid == "Gruppe6Card") then
        TriggerServerEvent('grp-securityheists:banktstart')
    end


    if (itemid == "usbdevice") then
        local finished = exports["grp-taskbar"]:taskBar(15000,"Scanning For Networks",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("hacking:attemptHack")
        end
        
    end

    if (itemid == "weed12oz") then
        TriggerServerEvent("exploiter", "Someone ate a box with 12oz of weed for no reason / removing item in unintended way")
        TriggerEvent("inv:weedPacking") -- cannot find the end of this call anywhere
        remove = true
    end

    if (itemid == "heavyammo") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1788949567,50,true)
            remove = true
        end
    end

    if (itemid == "pistolammo") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1950175060,50,true)
            remove = true
        end
    end

    if (itemid == "rifleammo") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",218444191,50,true)
            remove = true
        end
    end

    if (itemid == "shotgunammo") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",-1878508229,50,true)
            remove = true
        end
    end

    if (itemid == "subammo") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1820140472,50,true)
            remove = true
        end
    end


    if (itemid == "armor") then
        local finished = exports["grp-taskbar"]:taskBar(10000,"Armor",true,false,playerVeh)
        if (finished == 100) then
            SetPlayerMaxArmour(PlayerId(), 60 )
            SetPedArmour( player, 60 )
            TriggerEvent("UseBodyArmor")
            remove = true
        end
    end

    if (itemid == "bodybag") then
        local finished = exports["grp-taskbar"]:taskBar(10000,"Opening bag",true,false,playerVeh)
        if (finished == 100) then
            remove = true
            TriggerEvent( "player:receiveItem", "humanhead", 1 )
            TriggerEvent( "player:receiveItem", "humantorso", 1 )
            TriggerEvent( "player:receiveItem", "humanarm", 2 )
            TriggerEvent( "player:receiveItem", "humanleg", 2 )
        end
    end

    if (itemid == "bodygarbagebag") then
            local finished = exports["grp-taskbar"]:taskBar(10000,"Opening trash bag",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerServerEvent('loot:useItem', itemid)
            end
    end

    if (itemid == "foodsupplycrate") then
        TriggerEvent("DoLongHudText","Make sure you have a ton of space in your inventory! 100 or more.",2)
        local finished = exports["grp-taskbar"]:taskBar(20000,"Opening the crate (ESC to Cancel)",false,false,playerVeh)
        if (finished == 100) then
            remove = true
            TriggerEvent( "player:receiveItem", "heartstopper", 10 )
            TriggerEvent( "player:receiveItem", "moneyshot", 10 )
            TriggerEvent( "player:receiveItem", "bleederburger", 10 )
            TriggerEvent( "player:receiveItem", "fries", 10 )
            TriggerEvent( "player:receiveItem", "cola", 10 )
        end
end

    if (itemid == "organcooler") then
        local finished = exports["grp-taskbar"]:taskBar(5000,"Opening cooler",true,false,playerVeh)
        if (finished == 100) then
            remove = true
            TriggerEvent( "player:receiveItem", "humanheart", 1 )
            TriggerEvent( "player:receiveItem", "organcooleropen", 1 )
        end
    end

    if itemid == "humanhead" then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid,playerVeh,true,"humanskull")
    end

    if (itemid == "humantorso" or itemid == "humanarm" or itemid == "humanhand" or itemid == "humanleg" or itemid == "humanfinger") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid,playerVeh,true,"humanbone")
    end

    if (itemid == "humanear" or itemid == "humanintestines" or itemid == "humanheart" or itemid == "humaneye" or itemid == "humanbrain" or itemid == "humankidney" or itemid == "humanliver" or itemid == "humanlungs" or itemid == "humantongue" or itemid == "humanpancreas") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid)
    end

    if (itemid == "Bankbox") then
        if (hasEnoughOfItem("locksystem",1,false)) then
            local finished = exports["grp-taskbar"]:taskBar(10000,"Opening bank box.",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerEvent("inventory:removeItem","locksystem", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the box with",2)
        end
    end

    if (itemid == "Securebriefcase") then
        if (hasEnoughOfItem("Bankboxkey",1,false)) then
            local finished = exports["grp-taskbar"]:taskBar(5000,"Opening briefcase.",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerEvent("inventory:removeItem","Bankboxkey", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the briefcase with",2)
        end
    end

    if (itemid == "Largesupplycrate") then
        if (hasEnoughOfItem("2227010557",1,false)) then
            local finished = exports["grp-taskbar"]:taskBar(15000,"Opening supply crate.",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerEvent("inventory:removeItem","2227010557", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the crate with",2)
        end
    end

    if (itemid == "Smallsupplycrate") then
        if (hasEnoughOfItem("2227010557",1,false)) then
            local finished = exports["grp-taskbar"]:taskBar(15000,"Opening supply crate.",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerEvent("inventory:removeItem","2227010557", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the crate with",2)
        end
    end

    if (itemid == "Mediumsupplycrate") then
        if (hasEnoughOfItem("2227010557",1,false)) then
            local finished = exports["grp-taskbar"]:taskBar(15000,"Opening supply crate.",false,false,playerVeh)
            if (finished == 100) then
                remove = true
                TriggerEvent("inventory:removeItem","2227010557", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the crate with",2)
        end
    end


    if (itemid == "binoculars") then 
        TriggerEvent("binoculars:Activate")
        
    end

    if (itemid == "camera") then
        TriggerEvent("camera:Activate")
    end

    if (itemid == "nitrous") then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        
        if not IsToggleModOn(currentVehicle,18) then
            TriggerEvent("DoLongHudText","You need a Turbo to use NOS!",2)
        else
            local finished = 0
            local cancelNos = false
            Citizen.CreateThread(function()
                while finished ~= 100 and not cancelNos do
                    Citizen.Wait(100)
                    if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                        exports["grp-taskbar"]:closeGuiFail()
                        cancelNos = true
                    end
                end
            end)
            finished = exports["grp-taskbar"]:taskBar(20000,"Nitrous")
            if (finished == 100 and not cancelNos) then
                TriggerEvent("NosStatus")
                TriggerEvent("amp-hud:nitro", 100, false)
                remove = true
            else
                TriggerEvent("DoLongHudText","You can't drive and hook up nos at the same time.",2)
            end
        end
    end

    if (itemid == "lockpick") then
        local myJob = exports["isPed"]:isPed("myJob")
        if myJob ~= "news" then
            TriggerEvent("inv:lockPick",false,inventoryName,slot)

        else
            TriggerEvent("DoLongHudText","Nice news reporting, you shit lord idiot.")
        end
    end

    if (itemid == "umbrella") then
        TriggerEvent("animation:PlayAnimation","umbrella")
        
    end

    if (itemid == "repairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end

    if (itemid =="advrepairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end
    if (itemid == "securityblue" or itemid == "securityblack" or itemid == "securitygreen" or itemid == "securitygold" or itemid == "securityred")  then
        TriggerEvent("robbery:scanLock",false,itemid)       
    end

    if (itemid == "Gruppe6Card2")  then
        TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if (itemid == "Gruppe6Card222")  then
        TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end    

    if (itemid == "ciggy") then
        local finished = exports["grp-taskbar"]:taskBar(1000,"Lighting Up",false,false,playerVeh)
        if (finished == 100) then
            Wait(300)
            TriggerEvent("animation:PlayAnimation","smoke")
        end
    end

    if (itemid == "cigar") then
        local finished = exports["grp-taskbar"]:taskBar(1000,"Lighting Up",false,false,playerVeh)
        if (finished == 100) then
            Wait(300)
            TriggerEvent("animation:PlayAnimation","cigar")
        end
    end

    if (itemid == "oxygentank") then
        local finished = exports["grp-taskbar"]:taskBar(30000,"Oxygen Tank",true,false,playerVeh)
        if (finished == 100) then        
            TriggerEvent("UseOxygenTank")
            remove = true
        end
    end

    if (itemid == "bandage") then
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49,10000,"Healing","grp-hospital:items:bandage",true,itemid,playerVeh)
    end

    if (itemid == "coke50g") then
        CreateCraftOption("coke5g", 80, true)
        
    end

    if (itemid == "bakingsoda") then 
        CreateCraftOption("1gcrack", 80, true)
    end

    if (itemid == "glucose") then 
        CreateCraftOption("1gcocaine", 80, true)
        
    end

    if (itemid == "idcard") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerEvent("idcard:show",ItemInfo.information)
    end

    if (itemid == "drivingtest") then 
        local ItemInfo = GetItemInfo(slot)
        if (ItemInfo.information ~= "No information stored") then
            local data = json.decode(ItemInfo.information)
            TriggerServerEvent("driving:getResults", data.ID)
        end
    end

    if (itemid == "1gcocaine") then
        TriggerEvent("attachItemObjectnoanim","drugpackage01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 49, 5000, "Coke Gaming", "hadcocaine", true,itemid,playerVeh)
    end

    if (itemid == "1gcrack") then 
        TriggerEvent("attachItemObjectnoanim","crackpipe01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 5000, "Smoking Quack", "hadcrack", true,itemid,playerVeh)
    end

    if (itemid == "treat") then
        local model = GetEntityModel(player)
        if model == GetHashKey("a_c_chop") then
            TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 1200, "Treat Num's", "hadtreat", true,itemid,playerVeh)
        end
    end

    if (itemid == "IFAK") then
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49,2000,"Applying IFAK","healed:useOxy2",true,itemid,playerVeh)
    end


    if (itemid == "oxy") then
        TriggerEvent("animation:PlayAnimation","pill")
        TriggerEvent("useOxy")
        TriggerEvent("healed:useOxy")
        remove = true
    end

    if (itemid == "sandwich" or itemid == "hamburger") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "cola" or itemid == "water") then
        --attachPropsToAnimation(itemid, 6000)
        --TaskItem("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
    end


    if (itemid == "jailfood" or itemid == "bleederburger" or itemid == "heartstopper" or itemid == "torpedo" or itemid == "meatfree" or itemid == "moneyshot" or itemid == "fries") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","inv:wellfed",true,itemid,playerVeh)
        --attachPropsToAnimation(itemid, 6000)
        --TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 6000, "Eating", "inv:wellfed", true,itemid)
    end

    if (itemid == "methbag") then
        local finished = exports["grp-taskbarskill"]:taskBar(2500,10)
        if (finished == 100) then  
            TriggerEvent("attachItemObjectnoanim","crackpipe01")
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",6,1200)
            TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 1500, "💩 Smoking Ass Meth 💩", "hadcocaine", true, itemid,playerVeh)
        end
    end
    if itemid == "slushy" then
        --attachPropsToAnimation(itemid, 6000)
        TriggerEvent("healed:useOxy")
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49, 6000,"Eating", "inv:wellfed",true,itemid,playerVeh)
    end

    if (itemid == "shitlockpick") then
        lockpicking = true
        TriggerEvent("animation:lockpickinvtestoutside") 
        local finished = exports["grp-taskbarskill"]:taskBar(2500,math.random(5,20))
        if (finished == 100) then    
            TriggerEvent("police:uncuffMenu")
        end
        lockpicking = false
        remove = true
    end

    if (itemid == "watch") then
        TriggerEvent("amp:useItem:watch")
    end

    if (itemid == "harness") then
        local veh = GetVehiclePedIsIn(player, false)
        local driver = GetPedInVehicleSeat(veh, -1)
        if (PlayerPedId() == driver) then
            TriggerEvent("vehicleMod:useHarnessItem")
            remove = true
        end
    end

    if (itemid == "fishingrod") then
        TriggerEvent("grp-fish:lego")
    end

    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end

    Wait(500)
    retardCounter = 0
    justUsed = false


end)

function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid,vehicle)
    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" then
        TriggerEvent("attachItem", "sandwich")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "water" or itemid == "cola" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" then
        --TriggerEvent("attachItem", itemid)
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" then
        TriggerEvent("attachItem", "cup")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)




local clientInventory = {};
RegisterNetEvent('current-items')
AddEventHandler('current-items', function(inv)
    clientInventory = inv
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait (5000)
     
        TriggerEvent('nui-myinventory')
    end
end)

RegisterNetEvent('SniffRequestCID')
AddEventHandler('SniffRequestCID', function(src)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("SniffCID",cid,src)
end)



function GetItemInfo(checkslot)
    
     for i,v in pairs(clientInventory) do
        
         if (tonumber(v.slot) == tonumber(checkslot)) then
             local info = {["information"] = v.information, ["id"] = v.id, ["quality"] = v.quality }
             return info
         end
     end
     return "No information stored";
 end

-- item id, amount allowed, crafting.
function CreateCraftOption(id, add, craft)
    TriggerEvent("CreateCraftOption", id, add, craft)
end

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    local timer = tonumber(timer)
    if timer > 0 then
        local finished = exports["grp-taskbar"]:taskBar(timer,message,true,false,playerVeh)
        if finished == 100 or timer == 0 then
            TriggerEvent(func)
            ClearPedTasks(PlayerPedId())
            TriggerEvent("destroyProp")
        end
    else
        TriggerEvent(func)
    end

    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end
end



function GetCurrentWeapons()
    local returnTable = {}
    for i,v in pairs(clientInventory) do
        if (tonumber(v.item_id)) then
            local t = { ["hash"] = v.item_id, ["id"] = v.id, ["information"] = v.information, ["name"] = v.item_id, ["slot"] = v.slot }
            returnTable[#returnTable+1]=t
        end
    end   
    if returnTable == nil then 
        return {}
    end
    return returnTable
end

function getQuantity(itemid)
    local amount = 0
    for i,v in pairs(clientInventory) do
        if (v.item_id == itemid) then
            amount = amount + v.amount
        end
    end
    return amount
end

function hasEnoughOfItem(itemid,amount,shouldReturnText)

    if shouldReturnText == nil then shouldReturnText = true end
    if itemid == nil or itemid == 0 or amount == nil or amount == 0 then if shouldReturnText then TriggerEvent("DoLongHudText","I dont seem to have " .. itemid .. " in my pockets.",2) end return false end
    amount = tonumber(amount)
    local slot = 0
    local found = false

    if getQuantity(itemid) >= amount then
        return true
    end
    if (shouldReturnText) then
        --TriggerEvent("DoLongHudText","I dont have enough of that item...",2) 
    end    
    return false
end


function isValidUseCase(itemID,isWeapon)
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    if playerVeh ~= 0 then
        local model = GetEntityModel(playerVeh)
        if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
            if IsEntityInAir(playerVeh) then
                Wait(1000)
                if IsEntityInAir(playerVeh) then
                    TriggerEvent("DoLongHudText","You appear to be flying through the air",2) 
                    return false
                end
            end
        end
    end

    if not validWaterItem[itemID] and not isWeapon then
        if IsPedSwimming(player) then
            local targetCoords = GetEntityCoords(player, 0)
            Wait(700)
            local plyCoords = GetEntityCoords(player, 0)
            if #(targetCoords - plyCoords) > 1.3 then
                TriggerEvent("DoLongHudText","Cannot be moving while swimming to use this.",2) 
                return false
            end
        end

        if IsPedSwimmingUnderWater(player) then
            TriggerEvent("DoLongHudText","Cannot be underwater to use this.",2) 
            return false
        end
    end

    return true
end



RegisterNetEvent('evidence:addDnaSwab')
AddEventHandler('evidence:addDnaSwab', function(dna)
    TriggerEvent("DoLongHudText", "DNA Result: " .. dna,1)    
end)

RegisterNetEvent('idcard:show')
AddEventHandler('idcard:show', function(data)
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:showID", GetPlayerServerId(t), data)
    else
        TriggerEvent("DoLongHudText", "No player nearby!",2)
    end
end)

RegisterNetEvent('CheckDNA')
AddEventHandler('CheckDNA', function()
    TriggerServerEvent("Evidence:checkDna")
end)

RegisterNetEvent('evidence:dnaSwab')
AddEventHandler('evidence:dnaSwab', function()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:dnaAsk", GetPlayerServerId(t))
    end
end)

RegisterNetEvent('evidence:swabNotify')
AddEventHandler('evidence:swabNotify', function()
    TriggerEvent("DoLongHudText", "DNA swab taken.",1)
end)


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end



function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end

local burgies = 0
RegisterNetEvent('inv:wellfed')
AddEventHandler('inv:wellfed', function()
    TriggerEvent("changehunger")
    TriggerEvent("changehunger")
    TriggerEvent("client:newStress",false,10)
    TriggerEvent("changehunger")
    TriggerEvent("changethirst")
    burgies = 0
end)


RegisterNetEvent('animation:lockpickinvtestoutside')
AddEventHandler('animation:lockpickinvtestoutside', function()
    local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    
    while lockpicking do        
        TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
        Citizen.Wait(2500)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('animation:lockpickinvtest')
AddEventHandler('animation:lockpickinvtest', function(disable)
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    if disable ~= nil then
        if not disable then
            lockpicking = false
            return
        else
            lockpicking = true
        end
    end
    while lockpicking do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)



RegisterNetEvent('inv:lockPick')
AddEventHandler('inv:lockPick', function(isForced,inventoryName,slot)
    TriggerEvent("robbery:scanLock",true)
    if lockpicking then return end

    lockpicking = true
    playerped = PlayerPedId()
    targetVehicle = GetVehiclePedIsUsing(playerped)
    local itemid = 21

    if targetVehicle == 0 then
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
        local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
        if targetVehicle == 0 then
            lockpicking = false
            TriggerEvent("robbery:lockpickhouse",isForced)
            return
        end

        if driverPed ~= 0 then
            lockpicking = false
            return
        end
            local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
            local leftfront = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)

            local count = 5000
            local dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
            while dist > 2.0 and count > 0 do
                dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
                Citizen.Wait(1)
                count = count - 1
                DrawText3Ds(leftfront["x"],leftfront["y"],leftfront["z"],"Move here to lockpick.")
            end

            if dist > 2.0 then
                lockpicking = false
                return
            end


            TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
            Citizen.Wait(1000)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end


            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
           
            TriggerEvent("animation:lockpickinvtestoutside")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)



 
            local finished = exports["grp-taskbarskill"]:taskBar(25000,3)

            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["grp-taskbarskill"]:taskBar(2200,10)

            if finished ~= 100 then
                 lockpicking = false
                return
            end


            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then

                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerEvent("DoLongHudText", "Vehicle Unlocked.",1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 0.1)

                end
            end
        lockpicking = false
    else
        if targetVehicle ~= 0 and not isForced then

            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end

            SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
           
            TriggerEvent("animation:lockpickinvtest")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)

           
            local carTimer = GetVehicleHandlingFloat(targetVehicle, 'CHandlingData', 'nMonetaryValue')
            if carTimer == nil then
                carTimer = math.random(25000,180000)
            end
            if carTimer < 25000 then
                carTimer = 25000
            end

            if carTimer > 180000 then
                carTimer = 180000
            end
            
            carTimer = math.ceil(carTimer / 3)


            local myJob = exports["isPed"]:isPed("myJob")
            if myjob == "towtruck" then
                carTimer = 4000
            end

            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)

            local finished = exports["grp-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["grp-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end


            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
            local finished = exports["grp-taskbarskill"]:taskBar(1500,math.random(5,15))
            if finished ~= 100 then
                TriggerEvent("DoLongHudText", "The lockpick bent out of shape.",2)
                TriggerEvent("inventory:removeItem","lockpick", 1)                
                 lockpicking = false
                return
            end     


            Citizen.Wait(500)
            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then
                    local plate = GetVehicleNumberPlateText(targetVehicle)
                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerServerEvent("garage:addKeys", plate)
                    TriggerEvent("keys:startvehicle")
                    TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
                    TriggerEvent("DoLongHudText", "Ignition Working.",1)
                    SetEntityAsMissionEntity(targetVehicle,false,true)
                    SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
                end
                lockpicking = false
            end
        end
    end
    lockpicking = false
end)

local reapiring = false
RegisterNetEvent('veh:repairing')
AddEventHandler('veh:repairing', function(inventoryName,slot,itemid)
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    local advanced = false
    if itemid == "advrepairkits" then
        advanced = true
    end

    if targetVehicle ~= 0 then

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d2["y"]+0.5,0.2)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000
        local fueltankhealth = GetVehiclePetrolTankHealth(targetVehicle)

        while dist > 1.5 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
        end

        if reapiring then return end
        reapiring = true
        
        local timeout = 20

        NetworkRequestControlOfEntity(targetVehicle)

        while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
            NetworkRequestControlOfEntity(targetVehicle)
            Citizen.Wait(100)
            timeout = timeout -1
        end


        if dist < 1.5 then
            TriggerEvent("animation:repair",targetVehicle)
            fixingvehicle = true

            local repairlength = 1000

            if advanced then
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1200
                        else
                           timeAdded = timeAdded + 800
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 5) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            else
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1600
                        else
                           timeAdded = timeAdded + 1200
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 3) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            end



            local finished = exports["grp-taskbarskill"]:taskBar(15000,math.random(10,20))
            if finished ~= 100 then
                fixingvehicle = false
                reapiring = false
                ClearPedTasks(playerped)
                return
            end

            if finished == 100 then
                
                local myJob = exports["isPed"]:isPed("myJob")
                if myJob == "towtruck" then

                    SetVehicleEngineHealth(targetVehicle, 1000.0)
                    SetVehicleBodyHealth(targetVehicle, 1000.0)
                    SetVehiclePetrolTankHealth(targetVehicle, 4000.0)

                    if math.random(100) > 95 then
                        TriggerEvent("inventory:removeItem","repairtoolkit",1)
                    end

                else

                    TriggerEvent('veh.randomDegredation',30,targetVehicle,3)

                    if advanced then
                        TriggerEvent("inventory:removeItem","advrepairkit", 1)
                        TriggerEvent('veh.randomDegredation',30,targetVehicle,3)
                        if GetVehicleEngineHealth(targetVehicle) < 900.0 then
                            SetVehicleEngineHealth(targetVehicle, 900.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 3800.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 3800.0)
                        end

                    else

                        local timer = math.ceil(GetVehicleEngineHealth(targetVehicle) * 5)
                        if timer < 2000 then
                            timer = 2000
                        end
                        local finished = exports["grp-taskbarskill"]:taskBar(timer,math.random(5,15))
                        if finished ~= 100 then
                            fixingvehicle = false
                            reapiring = false
                            ClearPedTasks(playerped)
                            return
                        end

                        if math.random(100) > 95 then
                            TriggerEvent("inventory:removeItem","repairtoolkit",1)
                        end

                        if GetVehicleEngineHealth(targetVehicle) < 200.0 then
                            SetVehicleEngineHealth(targetVehicle, 200.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 2900.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 2900.0)
                        end                        

                        if GetEntityModel(targetVehicle) == `BLAZER` then
                            SetVehicleEngineHealth(targetVehicle, 600.0)
                            SetVehicleBodyHealth(targetVehicle, 800.0)
                        end
                    end                    
                end

                for i = 0, 5 do
                    SetVehicleTyreFixed(targetVehicle, i) 
                end
            end
            ClearPedTasks(playerped)
        end
        fixingvehicle = false
    end
    reapiring = false
end)

-- Animations
RegisterNetEvent('animation:load')
AddEventHandler('animation:load', function(dict)
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end)

RegisterNetEvent('animation:repair')
AddEventHandler('animation:repair', function(veh)
    SetVehicleDoorOpen(veh, 4, 0, 0)
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end

    TaskTurnPedToFaceEntity(PlayerPedId(), veh, 1.0)
    Citizen.Wait(1000)

    while fixingvehicle do
        local anim3 = IsEntityPlayingAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 3)
        if not anim3 then
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    SetVehicleDoorShut(veh, 4, 1, 1)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        BlockWeaponWheelThisFrame()
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 199, true) 
    end
end)


RegisterNetEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(bool, isFrisk)
        local _bool = bool

        if _bool == nil or _bool == false then 
            _bool = false 
        else 
            _bool = true
        end
		if isFrisk == nil then isFrisk = false end
		t, distance, closestPed = GetClosestPlayer()
		if(distance ~= -1 and distance < 5) then
			TriggerServerEvent("server-inventory-openPlayer", GetPlayerServerId(t), isFrisk, _bool)
		else
			TriggerEvent("DoLongHudText", "No player near you!",2)
		end
end)

RegisterCommand("search", function(source, args)
    local player = GRPCore.GetPlayerData()
    local closestPlayer, closestDistance = GRPCore.Game.GetClosestPlayer()
    if GRPCore.GetPlayerData().job.name == 'police' then
        if closestPlayer ~= -1 and closestDistance <= 2.0 then
            local searchPlayerPed = GetPlayerPed(closestPlayer)
            TriggerServerEvent("people-search", GetPlayerServerId(closestPlayer)) --COPY THIS
        end
    end
end)

RegisterCommand("seizecash", function(source, args)
    local player = GRPCore.GetPlayerData()
    local closestPlayer, closestDistance = GRPCore.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 and GRPCore.PlayerData.job.name == 'police' then
        local searchPlayerPed = GetPlayerPed(closestPlayer)
        TriggerServerEvent("police:SeizeCash",  GetPlayerServerId(closestPlayer))
    else
        TriggerEvent("DoLongHudText", "Job Required: Police")
    end
end)


RegisterCommand("steal", function(source, args)
    local closestPlayer, closestDistance = GRPCore.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 1.0 then
        local playerPed = PlayerPedId()
        local searchPlayerPed = GetPlayerPed(closestPlayer)

        if IsEntityPlayingAnim(searchPlayerPed, 'missfbi5ig_22', 'hands_up_anxious_scientist', 3) or (IsEntityPlayingAnim(searchPlayerPed, "dead", "dead_a", 3)) then
            RequestAnimDict("random@shop_robbery")

            while not HasAnimDictLoaded("random@shop_robbery") do

                Citizen.Wait(0)

            end
        
            TaskPlayAnim(PlayerPedId(), "random@shop_robbery" , "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
            local finished = exports["grp-taskbar"]:taskBar(3500, "Robbing")
            TriggerServerEvent("people-search", GetPlayerServerId(closestPlayer)) --COPY THIS
            TriggerServerEvent("Stealtheybread", GetPlayerServerId(closestPlayer))
        else
            TriggerEvent('DoLongHudText', 'They need to do /e handsup2 or be dead!', 2)
        end
    end
end)

RegisterNetEvent('searching-person')
AddEventHandler('searching-person', function(target)
    TriggerEvent("server-inventory-open", "1", target)
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(pos.x,pos.y,pos.z,15.72802066803,-1598.2983398438,29.377981185913,false)
        if distance <= 1.2 then
            DrawText3D(15.72802066803,-1598.2983398438,29.377981185913, "Open pockets to cook here")
        end
        Citizen.Wait(5)
    end
end)


function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterCommand("coords", function(src, args, rawCommand)
    print(GetEntityCoords(PlayerPedId(-1)))
end)

RegisterNetEvent('grp-inventory:goldtrade')
AddEventHandler('grp-inventory:goldtrade', function()
	if exports["grp-inventory"]:hasEnoughOfItem("goldbar",70,true) then
		TriggerEvent("inventory:removeItem", "goldbar", 70)
		TriggerServerEvent('mission:finished', 35000)
	end
end)


Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(1)
	    local GoldBars = #(GetEntityCoords(PlayerPedId()) - vector3(-114.1761, 6471.347, 31.6267))
		if GoldBars < 1.5 then
			if isTime() then
				DrawText3Ds(-114.1761, 6471.347, 31.6267, "[E] to Exchange 70 Gold Bars for $35000 (5p)") 			
				if IsControlJustReleased(0,38) then
					if exports["grp-inventory"]:hasEnoughOfItem("goldbar",70,true) then
						local finished = exports["grp-taskbar"]:taskBar(6000,"Trading Bars")
						if finished == 100 then
                            TriggerEvent('grp-inventory:goldtrade')
						end
					end
					Citizen.Wait(1000)
				end
			else
				DrawText3Ds(-114.1761, 6471.347, 31.6267, "We are currently not open") 
			end
		end
    end
end)

function isTime()
    local hour = GetClockHours()
    if hour < 18 or hour > 9 then
      return true
    end
  end