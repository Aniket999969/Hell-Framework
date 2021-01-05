local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('grp-hospital:server:SyncInjuries')
AddEventHandler('grp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)