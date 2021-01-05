vehsales = {}

vehsales.Version = '1.0.10'

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj; end)
Citizen.CreateThread(function(...)
  while not GRPCore do
    TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj; end)
    Citizen.Wait(0)
  end
end)