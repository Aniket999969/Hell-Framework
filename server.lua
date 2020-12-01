RegisterServerEvent ('HellFW:SpawnPlayer')
AddEventHandler('HellFW:SpawnPlayer' , function()
    local source = source
    exports.ghmattisql:execute('SELECT * FROM users WHERE identifer + @identifer')