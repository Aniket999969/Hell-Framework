RegisterServerEvent("grp-alerts:teenA")
AddEventHandler("grp-alerts:teenA",function(targetCoords)
    TriggerClientEvent('grp-alerts:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:teenB")
AddEventHandler("grp-alerts:teenB",function(targetCoords)
    TriggerClientEvent('grp-alerts:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:teenpanic")
AddEventHandler("grp-alerts:teenpanic",function(targetCoords)
    TriggerClientEvent('grp-alerts:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:fourA")
AddEventHandler("grp-alerts:fourA",function(targetCoords)
    TriggerClientEvent('grp-alerts:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:fourB")
AddEventHandler("grp-alerts:fourB",function(targetCoords)
    TriggerClientEvent('grp-alerts:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:downperson")
AddEventHandler("grp-alerts:downperson",function(targetCoords)
    TriggerClientEvent('grp-alerts:downalert', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:sveh")
AddEventHandler("grp-alerts:sveh",function(targetCoords)
    TriggerClientEvent('grp-alerts:vehiclesteal', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:shoot")
AddEventHandler("grp-alerts:shoot",function(targetCoords)
    TriggerClientEvent('grp-outlawalert:gunshotInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:figher")
AddEventHandler("grp-alerts:figher",function(targetCoords)
    TriggerClientEvent('grp-outlawalert:combatInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:storerob")
AddEventHandler("grp-alerts:storerob",function(targetCoords)
    TriggerClientEvent('grp-alerts:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:houserob")
AddEventHandler("grp-alerts:houserob",function(targetCoords)
    TriggerClientEvent('grp-alerts:houserobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:tbank")
AddEventHandler("grp-alerts:tbank",function(targetCoords)
    TriggerClientEvent('grp-alerts:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("grp-alerts:robjew")
AddEventHandler("grp-alerts:robjew",function()
    TriggerClientEvent('grp-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("grp-alerts:bjail")
AddEventHandler("grp-alerts:bjail",function()
    TriggerClientEvent('grp-alerts:jewelrobbey', -1)
	return
end)