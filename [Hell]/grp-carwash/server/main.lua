GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

GRPCore.RegisterServerCallback('grp-carwash:canAfford', function(source, cb)
	local xPlayer = GRPCore.GetPlayerFromId(source)

	if Config.EnablePrice then
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeMoney(Config.Price)
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end)