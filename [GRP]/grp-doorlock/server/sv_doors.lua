local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local GRPCore = nil
-- GRPCore
TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

RegisterServerEvent('grp-doors:alterlockstate2')
AddEventHandler('grp-doors:alterlockstate2', function()
    --GRP.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('grp-doors:alterlockstateclient', source, GRP.DoorCoords)

end)

RegisterServerEvent('grp-doors:alterlockstate')
AddEventHandler('grp-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    GRP.alterState(alterNum)
end)

RegisterServerEvent('grp-doors:ForceLockState')
AddEventHandler('grp-doors:ForceLockState', function(alterNum, state)
    GRP.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('GRP:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('grp-doors:requestlatest')
AddEventHandler('grp-doors:requestlatest', function()
    local src = source 
    local steamcheck = GRPCore.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('grp-doors:alterlockstateclient', source,GRP.DoorCoords)
end)

function isDoorLocked(door)
    if GRP.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end