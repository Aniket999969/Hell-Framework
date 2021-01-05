GRPCore = nil

TriggerEvent("grp:getSharedObject", function(obj) GRPCore = obj end)

RegisterServerEvent("grp-policefrisk:closestPlayer")
AddEventHandler("grp-policefrisk:closestPlayer", function(closestPlayer)
    _source = source
    target = closestPlayer

    TriggerClientEvent("grp-policefrisk:friskPlayer", target)
end)

RegisterServerEvent("grp-policefrisk:notifyMessage")
AddEventHandler("grp-policefrisk:notifyMessage", function(frisk)
    if frisk == true then
        TriggerClientEvent('chatMessagess', _source, 'Information: ', 4, "I could feel something that reminds of a firearm")
        return
    elseif frisk == false then
        TriggerClientEvent('chatMessagess', _source, 'Information: ', 4, "I could not feel anything")
        return
    end
end)