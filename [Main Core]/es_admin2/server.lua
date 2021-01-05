GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {
	slay = "mod",
	noclip = "admin",
	crash = "superadmin",
	freeze = "admin",
	bring = "mod",
	["goto"] = "mod",
	slap = "admin",
	slay = "mod",
	kick = "admin",
	ban = "admin"
}

local time = os.date("%Y/%m/%d %X")
local url = 'https://discordapp.com/api/webhooks/732287286976184381/TDkBXkCM-WvfDQNDqzi9lHiPZKnq1s_uiVMWXXfEz0ZYJnZeGYKq5CEL4P50AdZbx-WZ'

local banned = ""
local bannedTable = {}

RegisterServerEvent('admin:logs')
AddEventHandler('admin:logs', function(data)
	PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "] " .. data .. "\n```"}), {['Content-Type'] = 'application/json'})
end)

function loadBans()
	banned = LoadResourceFile(GetCurrentResourceName(), "bans.json") or ""
	if banned ~= "" then
		bannedTable = json.decode(banned)
	else
		bannedTable = {}
	end
end

RegisterCommand("refresh_bans", function()
	loadBans()
end, true)

function loadExistingPlayers()
	TriggerEvent("es:getPlayers", function(curPlayers)
		for k,v in pairs(curPlayers)do
			TriggerClientEvent("admin:setGroup", v.get('source'), v.get('group'))
		end
	end)
end

loadExistingPlayers()

function removeBan(id)
	bannedTable[id] = nil
	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

function isBanned(id)
	if bannedTable[id] ~= nil then
		if bannedTable[id].expire < os.time() then
			removeBan(id)
			return false
		else
			return bannedTable[id]
		end
	else
		return false
	end
end

function permBanUser(bannedBy, id)
	bannedTable[id] = {
		banner = bannedBy,
		reason = "Permanently banned from this server",
		expire = 0
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

function banUser(expireSeconds, bannedBy, id, re)
	bannedTable[id] = {
		banner = bannedBy,
		reason = re,
		expire = (os.time() + expireSeconds)
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		local banData = isBanned(v)
		if banData ~= false then
			set("Banned for: " .. banData.reason .. "\nExpires: " .. (os.date("%c", banData.expire)))
			CancelEvent()
			break
		end
	end
end)

AddEventHandler('es:incorrectAmountOfArguments', function(source, wantedArguments, passedArguments, user, command)
	if(source == 0)then
		print("Argument count mismatch (passed " .. passedArguments .. ", wanted " .. wantedArguments .. ")")
	else
		TriggerClientEvent('chat:addMessage', source, {
			args = {"^1SYSTEM", "Incorrect amount of arguments! (" .. passedArguments .. " passed, " .. requiredArguments .. " wanted)"}
		})
	end
end)

RegisterServerEvent('admin:all')
AddEventHandler('admin:all', function(type)
	local Source = source
	local user = GRPCore.GetPlayerFromId(Source)
	local playersteam = GetPlayerIdentifier(Source)
	if user.getGroup() == "superadmin" then
		if type == "slay_all" then 
			TriggerClientEvent('admin:quick', -1, 'slay') 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. GetPlayerName(Source) .. " (" .. Source .. ") | Action: Slay Everyone \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "bring_all" then 
			TriggerClientEvent('admin:quick', -1, 'bring', Source) 
		elseif type == "slap_all" then 
			TriggerClientEvent('admin:quick', -1, 'slap') 
		end
	else
		TriggerClientEvent('chat:addMessage', Source, {
			args = {"^1SYSTEM", "You do not have permission to do this"}
		})
	end
end)

RegisterServerEvent('admin:quick')
AddEventHandler('admin:quick', function(id, type)
	local Source = source
	local user = GRPCore.GetPlayerFromId(source)
	local target = GRPCore.GetPlayerFromId(id)
	local group = user.getGroup()
	if group == 'admin' or group == 'superadmin' then
		local pname = GetPlayerName(Source)
		local playerip = GetPlayerEndpoint(Source)
		local playersteam = GetPlayerIdentifier(Source)
		local playerping = GetPlayerPing(Source)
		local targetName = GetPlayerName(id)

		if type == "revive" then 
			TriggerClientEvent('grp-ambulancejob:revive', id) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Revived! ! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "heal" then 
			TriggerClientEvent('esx_basicneeds:healPlayer', id) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Revived! ! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "noclip" then 
			TriggerClientEvent('admin:quick', id, type) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") No Clip ! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "freeze" then 
			TriggerClientEvent('admin:quick', id, type) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Freezed! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "crash" then
			TriggerClientEvent('admin:quick', id, type)
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Crashed! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "bring" then 
			TriggerClientEvent('admin:quick', id, type, Source) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: Bring " .. targetName .. " (" .. id .. ")! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "goto" then 
			TriggerClientEvent('admin:quick', Source, type, id)
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: Goto " .. targetName .. " (" .. id .. ")! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "slap" then 
			TriggerClientEvent('admin:quick', id, type) 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Slapped! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "slay" then 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: " .. targetName .. " (" .. id .. ") Killed! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
			TriggerClientEvent('admin:quick', id, type) 
		elseif type == "spectate" then 
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: Spectate " .. targetName .. " (" .. id .. ")! \nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
			TriggerClientEvent('esx_spectate:play', source, id) 
		elseif type == "kick" then
			DropPlayer(id, 'Kicked by Admin ')
			PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " (" .. source .. ") | Action: Kicked " .. targetName .. "\nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
		elseif type == "ban" then
			local id
			local ip
			for k,v in ipairs(GetPlayerIdentifiers(source))do
				if string.sub(v, 1, string.len("steam:")) == "steam:" then
					permBanUser(user.identifier, v)
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					permBanUser(user.identifier, v)
				end
			end
			DropPlayer(id, "You were banned from this server")
		end
	end
end)

AddEventHandler('es:playerLoaded', function(Source, user)
	TriggerClientEvent('admin:setGroup', Source, user.getGroup())
end)

RegisterServerEvent('admin:set')
AddEventHandler('admin:set', function(t, USER, val)
	local Source = source
	local user = GRPCore.GetPlayerFromId(source)
	if user.getGroup() == 'superadmin' then
		if t == "group" then
			if GetPlayerName(USER) == nil then
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Player not found"} })
			else
				TriggerEvent("es:getAllGroups", function(groups)
					if groups[val] then
						TriggerEvent("es:setPlayerData", USER, "group", val, function(response, success)
							TriggerClientEvent('admin:setGroup', USER, val)
							TriggerClientEvent('chat:addMessage', -1, { args = {"^1CONSOLE", "Group of ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 has been set to ^2^*" .. val}})
							PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. GetPlayerName(Source) .. " | Action: Set Group: " .. val .. " To " .. GetPlayerName(USER) .. "\n```"}), { ['Content-Type'] = 'application/json' })
						end)
					else
						TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Group not found"} })
					end
				end)
			end
		elseif t == "level" then
			if GetPlayerName(USER) == nil then
				TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Player not found"}})
			else
				local level = tonumber(val)
				if level ~= nil and level > -1 then
					TriggerEvent("es:setPlayerData", USER, "permission_level", level, function(response, success) end)

					TriggerClientEvent('chat:addMessage', -1, { args = {"^1CONSOLE", "Permission level of ^2" .. GetPlayerName(tonumber(USER)) .. "^0 has been set to ^2 " .. tostring(level)}})
					PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. GetPlayerName(Source) .. " | Action: Set Level: " .. val .. " To " .. GetPlayerName(USER) .. "\n```"}), { ['Content-Type'] = 'application/json' })

				else
					TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Invalid integer entered"}})
				end
			end
		elseif t == "money" then
			if GetPlayerName(USER) == nil then
				TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Player not found"}})
			else
				local money = tonumber(val)
				if money ~= nil and money > -1 then
					local target = GRPCore.GetPlayerFromId(USER)
					local name = GetPlayerName(target.source)
					target.setMoney(money)
					PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. GetPlayerName(source) .. " | Action: Set Money: " .. money .. " To " .. name .. "\n```"}), { ['Content-Type'] = 'application/json' })
				else
					TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Invalid integer entered"}})
				end
			end
		elseif t == "bank" then
			if(GetPlayerName(USER) == nil)then
				TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Player not found"}})
			else
				local bank = tonumber(val)
				if bank ~= nil and bank > -1 then
					local target = GRPCore.GetPlayerFromId(USER)
					local name = GetPlayerName(target.source)
					target.setBankBalance(bank)
					PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. GetPlayerName(source) .. " | Action: Set Bank: " .. bank .. " To " .. name .. "\n```"}), { ['Content-Type'] = 'application/json' })
				else
					TriggerClientEvent('chat:addMessage', Source, { args = {"^1SYSTEM", "Invalid integer entered"}})
				end
			end
		end
	end
end)

RegisterCommand('setadmin', function(source, args, raw)
	local player = tonumber(args[1])
	local level = tonumber(args[2])
	if args[1] then
		if (player and GetPlayerName(player)) then
			if level then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
					RconPrint(response)
		
					TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
					TriggerClientEvent('chat:addMessage', -1, {
						args = {"^1CONSOLE", "Permission level of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2 " .. args[2]}
					})
				end)
			else
				RconPrint("Invalid integer\n")
			end
		else
			RconPrint("Player not ingame\n")
		end
	else
		RconPrint("Usage: setadmin [user-id] [permission-level]\n")
	end
end, true)

RegisterCommand('setgroup', function(source, args, raw)
	local player = tonumber(args[1])
	local group = args[2]
	if args[1] then
		if (player and GetPlayerName(player)) then
			TriggerEvent("es:getAllGroups", function(groups)

				if(groups[args[2]])then
					TriggerEvent("es:getPlayerFromId", player, function(user)
						ExecuteCommand('remove_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())

						TriggerEvent("es:setPlayerData", player, "group", args[2], function(response, success)
							TriggerClientEvent('es:setPlayerDecorator', player, 'group', tonumber(group), true)
							TriggerClientEvent('chat:addMessage', -1, {
								args = {"^1CONSOLE", "Group of ^2^*" .. GetPlayerName(player) .. "^r^0 has been set to ^2^*" .. group}
							})
							pname = GetPlayerName(Source)
							PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " | Action: Set Group: " .. group .. " To " .. GetPlayerName(player) .. "\n```"}), { ['Content-Type'] = 'application/json' })

							ExecuteCommand('add_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())
						end)
					end)
				else
					RconPrint("This group does not exist.\n")
				end
			end)
		else
			RconPrint("Player not ingame\n")
		end
	else
		RconPrint("Usage: setgroup [user-id] [group]\n")
	end
end, true)


RegisterCommand('setmoney', function(source, args, raw)
	local player = tonumber(args[1])
	local money = tonumber(args[2])

	playersteam = GetPlayerIdentifier(source)
	pname = GetPlayerName(source)

	if args[1] then
		if (player and GetPlayerName(player)) then
			if money then
				TriggerEvent("es:getPlayerFromId", player, function(user)
					if(user)then
						user.setMoney(money)

						RconPrint("Money set")
						TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "Your money has been set to: ^2^*$" .. money}})
						PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = "Administrator logs", content = "```css\n[" .. time .. "]> From: " .. pname .. " | Action: Give Money: " .. money .. "$ To " .. GetPlayerName(player) .. "\nSteam Hex: " .. playersteam .. "\n```"}), { ['Content-Type'] = 'application/json' })
					end
				end)
			else
				RconPrint("Invalid integer\n")
			end
		else
			RconPrint("Player not ingame\n")
		end
	else
		RconPrint("Usage: setmoney [user-id] [money]\n")
	end
end, true)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1SYSTEM", "Level: ^*^2 " .. tostring(user.get('permission_level'))}
	})
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1SYSTEM", "Group: ^*^2 " .. user.getGroup()}
	})
end, {help = "Shows what admin level you are and what group you're in"})

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "admin", function(source, args, user)
	TriggerClientEvent("admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Enable or disable noclip"})

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "admin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				local reason = args
				table.remove(reason, 1)
				if(#reason == 0)then
					reason = "Kicked: You have been kicked from the server"
				else
					reason = "Kicked: " .. table.concat(reason, " ")
				end

				TriggerClientEvent('chat:addMessage', source, {
					args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been kicked(^2" .. reason .. "^0)"}
				})
				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Kick a user with the specified reason or no reason", params = {{name = "userid", help = "The ID of the player"}, {name = "reason", help = "The reason as to why you kick this player"}}})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('admin:freezePlayer', player, frozen[player])

				local state = "Unfrozen"
				if(frozen[player])then
					state = "Frozen"
				end

				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", GetPlayerName(player) .. ' ' .. state .. '.'} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Freeze or unfreeze a user", params = {{name = "userid", help = "The ID of the player"}}})

-- Bring
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('admin:teleportUser', target.get('source'), user.getCoords().x, user.getCoords().y, user.getCoords().z)

				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", GetPlayerName(player) .. " Brought."} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Teleport a user to you", params = {{name = "userid", help = "The ID of the player"}}})

-- Slap
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('admin:slap', player)

				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", GetPlayerName(player) .. " Slapped."} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Slap a user", params = {{name = "userid", help = "The ID of the player"}}})

-- Goto
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then

					TriggerClientEvent('admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)

					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Teleported to " .. GetPlayerName(player) .. "."} })
				end
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Teleport to a user", params = {{name = "userid", help = "The ID of the player"}}})

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('admin:kill', source)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "You killed yourself"} })
end, {help = "Suicide"})

-- Slay a player
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('admin:kill', player)

				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", GetPlayerName(player) .. "^0 Killed."} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Slay a user", params = {{name = "userid", help = "The ID of the player"}}})


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

loadBans()

GRPCore.RegisterServerCallback('es_admin2:openMenu', function(source, cb)
	local xPlayer = GRPCore.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group ~= "user", getPlayers())
end)

function getPlayers()
	local esxPlayers = GRPCore.GetPlayers()
    local players = {}
	for _, player in ipairs(esxPlayers) do
		table.insert(players, {id = player, name = GetPlayerName(player)})
    end
    return players
end

function GetDiscord(source,cb)
	local source = source
	local num = 0
	local num2 = GetNumPlayerIdentifiers(source)
	local discord = nil
	while num < num2 and not discord do
	local a = GetPlayerIdentifier(source, num)
	if string.find(a, "discord") then discord = string.sub(a, 9) end
		num = num+1
	end


	if not discord then
		cb(GetPlayerName(source))
	else
    	PerformHttpRequest("https://discordapp.com/api/users/"..discord, function(err, text, headers)
			if err == 200 then
				cb(json.decode(text).username .. '#' .. json.decode(text).discriminator)
			else
				cb(GetPlayerName(source))
			end

		end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot NzEyNjIzMjQ5MDQwNjA1Mjg1.XxoK-w.yXUPYOiMg1fBda1Adh8qO65cVz4"})
	end
end
