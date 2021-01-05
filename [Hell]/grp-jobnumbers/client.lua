local JobCount = {}


Citizen.CreateThread(function()
    while GRPCore == nil do
		TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
		Citizen.Wait(0)
	end
	while GRPCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = GRPCore.GetPlayerData()
end)

RegisterNetEvent('grp:setJob')
AddEventHandler('grp:setJob', function(job)
	PlayerData.job = job
	TriggerServerEvent('grp-jobnumbers:setjobs', job)
end)

RegisterNetEvent('grp:playerLoaded')
AddEventHandler('grp:playerLoaded', function(xPlayer)
    TriggerServerEvent('grp-jobnumbers:setjobs', xPlayer.job)
end)


RegisterNetEvent('grp-jobnumbers:setjobs')
AddEventHandler('grp-jobnumbers:setjobs', function(jobslist)
   JobCount = jobslist
end)

function jobonline(joblist)
    for i,v in pairs(Config.MultiNameJobs) do
        for u,c in pairs(v) do
            if c == joblist then
                joblist = i
            end
        end
    end

    local amount = 0
    local job = joblist
    if JobCount[job] ~= nil then
        amount = JobCount[job]
    end

    return amount
end


