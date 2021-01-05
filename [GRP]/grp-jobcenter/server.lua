
GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(job)
	local xPlayer = GRPCore.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setJob(job, 0)
    end
    
end)