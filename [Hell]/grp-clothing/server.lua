GRPCore = nil

TriggerEvent("grp:getSharedObject", function(library) 
	GRPCore = library 
end)

RegisterServerEvent('grp-skin:save')
AddEventHandler('grp-skin:save', function()
    local src = source
    TriggerClientEvent('grp-clothing:guardarSkin',src)
end)

GRPCore.RegisterServerCallback('grp-skin:getPlayerSkin', function(source, cb)
  local xPlayer = GRPCore.GetPlayerFromId(source)
  local jobSkin = {
  skin_male   = xPlayer.job.skin_male,
  skin_female = xPlayer.job.skin_female}
  cb(nil, jobSkin)
end)


GRPCore.RegisterServerCallback('grp-clothing:getSex', function(source, cb)
    local xPlayer = GRPCore.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["identifier"] = xPlayer.identifier}, function(result)
        cb(result[1].sex)
    end)
  end)

local function checkExistenceClothes(identifier, cb)
    local xPlayer = GRPCore.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT identifier FROM users WHERE identifier = @identifier", {["identifier"] = xPlayer.identifier}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

local function checkExistenceFace(identifier, cb)
    local xPlayer = GRPCore.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT identifier FROM users WHERE identifier = @identifier", {["identifier"] = xPlayer.identifier}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

RegisterServerEvent("grp-clothing:insert_character_current")
AddEventHandler("grp-clothing:insert_character_current",function(data)
    if not data then return end
    local src = source
    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier
    if not characterId then return end
    checkExistenceClothes(characterId, function(exists)
        local values = {
            ["identifier"] = characterId,
            ["model"] = json.encode(data.model),
            ["drawables"] = json.encode(data.drawables),
            ["props"] = json.encode(data.props),
            ["drawtextures"] = json.encode(data.drawtextures),
            ["proptextures"] = json.encode(data.proptextures),
        }

        if not exists then
            local cols = "identifier, model, drawables, props, drawtextures, proptextures"
            local vals = "@identifier, @model, @drawables, @props, @drawtextures, @proptextures"

            MySQL.Async.execute("INSERT INTO users ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
        MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values)
    end)
end)

RegisterServerEvent("grp-clothing:insert_character_face")
AddEventHandler("grp-clothing:insert_character_face",function(data)
    if not data then return end
    local src = source

    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    checkExistenceFace(characterId, function(exists)
        if data.headBlend == "null" or data.headBlend == nil then
            data.headBlend = '[]'
        else
            data.headBlend = json.encode(data.headBlend)
        end
        local values = {
            ["identifier"] = characterId,
            ["hairColor"] = json.encode(data.hairColor),
            ["headBlend"] = data.headBlend,
            ["headOverlay"] = json.encode(data.headOverlay),
            ["headStructure"] = json.encode(data.headStructure),
        }

        if not exists then
            local cols = "identifier, hairColor, headBlend, headOverlay, headStructure"
            local vals = "@identifier, @hairColor, @headBlend, @headOverlay, @headStructure"

            MySQL.Async.execute("INSERT INTO users ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "hairColor = @hairColor,headBlend = @headBlend, headOverlay = @headOverlay,headStructure = @headStructure"
        MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values )
    end)
end)

RegisterServerEvent("grp-clothing:get_character_face")
AddEventHandler("grp-clothing:get_character_face",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT cc.model, cf.hairColor, cf.headBlend, cf.headOverlay, cf.headStructure FROM users cf INNER JOIN users cc on cc.identifier = cf.identifier WHERE cf.identifier = @identifier", {['identifier'] = characterId}, function(result)
        if (result ~= nil and result[1] ~= nil) then
            local temp_data = {
                hairColor = json.decode(result[1].hairColor),
                headBlend = json.decode(result[1].headBlend),
                headOverlay = json.decode(result[1].headOverlay),
                headStructure = json.decode(result[1].headStructure),
            }
            local model = tonumber(result[1].model)
            if model == 1885233650 or model == -1667301416 then
                TriggerClientEvent("grp-clothing:setpedfeatures", src, temp_data)
            end
        else
            TriggerClientEvent("grp-clothing:setpedfeatures", src, false)
        end
	end)
end)

RegisterServerEvent("grp-clothing:get_character_current")
AddEventHandler("grp-clothing:get_character_current",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['identifier'] = characterId}, function(result)
        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }
        TriggerClientEvent("grp-clothing:setclothes", src, temp_data,0)
	end)
end)

RegisterServerEvent("grp-clothing:retrieve_tats")
AddEventHandler("grp-clothing:retrieve_tats", function(pSrc)
    local src = (not pSrc and source or pSrc)
	local user = GRPCore.GetPlayerFromId(src)
	MySQL.Async.fetchAll("SELECT * FROM playerstattoos WHERE identifier = @identifier", {['identifier'] = user.identifier}, function(result)
        if(#result == 1) then
			TriggerClientEvent("grp-clothing:settattoos", src, json.decode(result[1].tattoos))
		else
			local tattooValue = "{}"
			MySQL.Async.execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['identifier'] = user.identifier, ['tattoo'] = tattooValue})
			TriggerClientEvent("grp-clothing:settattoos", src, {})
		end
	end)
end)

RegisterServerEvent("grp-clothing:set_tats")
AddEventHandler("grp-clothing:set_tats", function(tattoosList)
	local src = source
	local user = GRPCore.GetPlayerFromId(src)
	MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['tattoos'] = json.encode(tattoosList), ['identifier'] = user.identifier})
end)


RegisterServerEvent("grp-clothing:get_outfit")
AddEventHandler("grp-clothing:get_outfit",function(slot)
    if not slot then return end
    local src = source

    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT * FROM character_outfits WHERE steamid = @steamid and slot = @slot", {
        ['steamid'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            if result[1].model == nil then
                TriggerClientEvent('DoLongHudText', src, "Can not use.", 2)
                return
            end

            local data = {
                model = result[1].model,
                drawables = json.decode(result[1].drawables),
                props = json.decode(result[1].props),
                drawtextures = json.decode(result[1].drawtextures),
                proptextures = json.decode(result[1].proptextures),
                hairColor = json.decode(result[1].hairColor)
            }

            TriggerClientEvent("grp-clothing:setclothes", src, data,0)

            local values = {
                ["identifier"] = characterId,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
            }

            local set = "model = @model, drawables = @drawables, props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier",values)
        else
            TriggerClientEvent('DoLongHudText', src, "No outfit on slot " .. slot, 1)
            return
        end
	end)
end)

RegisterServerEvent("grp-clothing:set_outfit")
AddEventHandler("grp-clothing:set_outfit",function(slot, name, data)
    if not slot then return end
    local src = source

    local user = GRPCore.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT slot FROM character_outfits WHERE steamid = @steamid and slot = @slot", {
        ['steamid'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            local values = {
                ["steamid"] = characterId,
                ["slot"] = slot,
                ["name"] = name,
                ["model"] = json.encode(data.model),
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor),
            }

            local set = "model = @model,name = @name,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures,hairColor = @hairColor"
            MySQL.Async.execute("UPDATE character_outfits SET "..set.." WHERE steamid = @steamid and slot = @slot",values)
        else
            local cols = "steamid, model, name, slot, drawables, props, drawtextures, proptextures, hairColor"
            local vals = "@steamid, @model, @name, @slot, @drawables, @props, @drawtextures, @proptextures, @hairColor"

            local values = {
                ["steamid"] = characterId,
                ["name"] = name,
                ["slot"] = slot,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor)
            }

            MySQL.Async.execute("INSERT INTO character_outfits ("..cols..") VALUES ("..vals..")", values, function()
                TriggerClientEvent('DoLongHudText', src,  name .. " stored in slot " .. slot, 1)
            end)
        end
	end)
end)


RegisterServerEvent("grp-clothing:remove_outfit")
AddEventHandler("grp-clothing:remove_outfit",function(slot)

    local src = source
    local user = GRPCore.GetPlayerFromId(src)
    local steamid = user.identifier
    local slot = slot

    if not steamid then return end

    MySQL.Async.execute( "DELETE FROM character_outfits WHERE steamid = @steamid AND slot = @slot", { ['steamid'] = steamid,  ["slot"] = slot } )
    TriggerClientEvent('DoLongHudText', src, "Removed slot " .. slot .. ".", 1)
end)

RegisterServerEvent("grp-clothing:list_outfits")
AddEventHandler("grp-clothing:list_outfits",function()
    local src = source
    local user = GRPCore.GetPlayerFromId(src)
    local steamid = user.identifier
    local slot = slot
    local name = name

    if not steamid then return end

    MySQL.Async.fetchAll("SELECT slot, name FROM character_outfits WHERE steamid = @steamid", {['steamid'] = steamid}, function(skincheck)
    	TriggerClientEvent("grp-clothing:listOutfits",src, skincheck)
	end)
end)


RegisterServerEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function()
    local src = source
    local user = GRPCore.GetPlayerFromId(src)
    local steamid = user.identifier

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier LIMIT 1", {
        ['identifier'] = steamid
    }, function(result)
        local isService = false;
        if user.job.name == "police" or user.job.name == "ambulance" then isService = true end

        if result[1] == nil then
            MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["identifier"] = steamid}, function(result)
                if result[1].skin then
                    TriggerClientEvent('grp-clothing:setclothes',src,{},json.decode(result[1].skin))
                else
                    TriggerClientEvent('grp-clothing:setclothes',src,{},nil)
                end
                return
            end)
        else
            TriggerEvent("grp-clothing:get_character_current", src)
        end
        TriggerClientEvent("grp-clothing:inService",src,isService)
    end)
end)

RegisterServerEvent("clothing:checkMoney")
AddEventHandler("clothing:checkMoney", function(menu,askingPrice)
    local src = source
    local target = GRPCore.GetPlayerFromId(src)

    if not askingPrice
    then
        askingPrice = 0
    end

    if (tonumber(target.getMoney()) >= askingPrice) then
        target.removeMoney(askingPrice)
        TriggerClientEvent('DoLongHudText', src, "You Paid $"..askingPrice, 1)
        TriggerClientEvent("grp-clothing:hasEnough",src,menu)
    else
        TriggerClientEvent('DoLongHudText', src, "You need $"..askingPrice.." + Tax.", 2)
    end
end)