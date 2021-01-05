GRPCore                = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('towtruck:giveCash')
AddEventHandler('towtruck:giveCash', function(cash)
  local source = source
  local xPlayer  = GRPCore.GetPlayerFromId(source)
  xPlayer.addMoney(cash)
end)

RegisterServerEvent('grp-imp:mechCar')
AddEventHandler('grp-imp:mechCar', function(plate)
	local user = GRPCore.GetPlayerFromId(source)
    local characterId = user.identifier
	garage = 'Impound Lot'
	state = 'Normal Impound'
	MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage, state = @state WHERE plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
end)