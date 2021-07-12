ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('esx-bennys:attemptPurchase')
AddEventHandler('esx-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('esx-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('esx-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('esx-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('esx-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('esx-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('esx-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('esx-bennys:updateRepairCost')
AddEventHandler('esx-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)