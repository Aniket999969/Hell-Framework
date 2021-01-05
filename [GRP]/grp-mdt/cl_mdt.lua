local isVisible = false
local tabletObject = nil

TriggerServerEvent("grp-mdt:getOffensesAndOfficer")

RegisterNetEvent("grp-mdt:sendNUIMessage")
AddEventHandler("grp-mdt:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("grp-mdt:toggleVisibilty")
AddEventHandler("grp-mdt:toggleVisibilty", function(reports, warrants, officer)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        officer = officer
    })
    ToggleGUI()
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("grp-mdt:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("grp-mdt:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("evFile", function(data, cb)
    TriggerServerEvent("grpLockers:sendCaseFileID", data.id)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("grp-mdt:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("grp-mdt:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("grp-mdt:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("grp-mdt:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("grp-mdt:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("grp-mdt:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("grp-mdt:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("grp-mdt:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("grp-mdt:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("grp-mdt:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("grp-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("grp-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("grp-mdt:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    local players = {}
    for i = 0, 256 do
        if GetPlayerServerId(i) ~= 0 then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    TriggerServerEvent("grp-mdt:sentencePlayer", data.jailtime, data.charges, data.char_id, data.fine, players)
    cb('ok')
end)

RegisterNetEvent("grp-mdt:returnOffenderSearchResults")
AddEventHandler("grp-mdt:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("grp-mdt:returnOffenderDetails")
AddEventHandler("grp-mdt:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("grp-mdt:returnOffensesAndOfficer")
AddEventHandler("grp-mdt:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("grp-mdt:returnReportSearchResults")
AddEventHandler("grp-mdt:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("grp-mdt:returnVehicleSearchInFront")
AddEventHandler("grp-mdt:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("grp-mdt:returnVehicleSearchResults")
AddEventHandler("grp-mdt:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("grp-mdt:returnVehicleDetails")
AddEventHandler("grp-mdt:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("grp-mdt:returnWarrants")
AddEventHandler("grp-mdt:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("grp-mdt:completedWarrantAction")
AddEventHandler("grp-mdt:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("grp-mdt:returnReportDetails")
AddEventHandler("grp-mdt:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

RegisterNetEvent("grp-mdt:billPlayer")
AddEventHandler("grp-mdt:billPlayer", function(src, sharedAccountName, label, amount)
    TriggerServerEvent("grp-billing:sendBill", src, sharedAccountName, label, amount)
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end
