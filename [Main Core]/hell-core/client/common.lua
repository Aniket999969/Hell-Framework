AddEventHandler('grp:getSharedObject', function(cb)
	cb(GRPCore)
end)

function getSharedObject()
	return GRPCore
end
