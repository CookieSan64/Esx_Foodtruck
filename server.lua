ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_RufiFoodTruck:GiveItem')
AddEventHandler('esx_RufiFoodTruck:GiveItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent('esx_RufiFoodTruck:OpenBillMenu')
AddEventHandler('esx_RufiFoodTruck:OpenBillMenu', function(player, amount)
	local xPlayer = ESX.GetPlayerFromId(player)
	local xSeller = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Esx_RufiFoodtruck:PayBill', xPlayer.source, amount, xSeller.source)
end)

RegisterServerEvent('esx_RufiFoodTruck:NPCPay')
AddEventHandler('esx_RufiFoodTruck:NPCPay', function(amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local Ramount =  tonumber(amount)
	local method = math.random(1,2)
	if method == 1 then		
		xPlayer.addMoney(Ramount)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu ~g~' .. Ramount .. '$~w~ en ~y~LIQUIDE~w~ de la part de :~b~ PNJ client.')
	else
		xPlayer.addAccountMoney('bank', Ramount)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez reçu ~g~' .. Ramount .. '$~w~ sur votre ~o~COMPTE EN BANQUE~w~ de la part de :~b~ PNJ client.')
	end 
end)

RegisterServerEvent('esx_RufiFoodTruck:Pay')
AddEventHandler('esx_RufiFoodTruck:Pay', function(method, amount, seller)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xSeller = ESX.GetPlayerFromId(seller)
	local Ramount =  tonumber(amount)
	if method == 'cash' then
		if xPlayer.getMoney() < Ramount then
			TriggerClientEvent('esx:showNotification', src, '~r~Vous n\'avez pas assez d\'argent liquide.')
		else
			xPlayer.removeMoney(Ramount)
			TriggerClientEvent('esx:showNotification', src, '~g~Paiement accepté.')
			xSeller.addMoney(Ramount)
			TriggerClientEvent('esx:showNotification', xSeller.source, 'Vous avez reçu ~g~' .. Ramount .. '$~w~ en ~y~LIQUIDE~w~ de la part de :~b~ ' .. xPlayer.source .. ' ')
		end
	else
		if xPlayer.getAccount('bank').money < Ramount then
			TriggerClientEvent('esx:showNotification', src, '~r~Vous n\'avez pas assez d\'argent sur votre compte en banque.')
		else
			xPlayer.removeAccountMoney('bank', Ramount)
			TriggerClientEvent('esx:showNotification', src, '~g~Paiement accepté.')
			xSeller.addAccountMoney('bank', Ramount)
			TriggerClientEvent('esx:showNotification', xSeller.source, 'Vous avez reçu ~g~' .. Ramount .. '$~w~ sur votre ~o~COMPTE EN BANQUE~w~ de la part de :~b~ ' .. xPlayer.source .. ' ')
		end
	end 
end)

RegisterServerEvent('esx_RufiFoodTruck:RegisterOwner')
AddEventHandler('esx_RufiFoodTruck:RegisterOwner', function(plate, amount, cash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local matricula = plate
	if cash then
		if xPlayer.getMoney() >= amount then
			MySQL.Async.fetchAll('SELECT * FROM `foodtruck_owners` WHERE identifier = @identifier',
				{
					['@identifier']  = xPlayer.identifier
				}, function(tiene)
				if not tiene[1] then
					MySQL.Async.execute('INSERT INTO foodtruck_owners (identifier, plate) VALUES (@identifier, @plate)',
						{   
							['@identifier']  = xPlayer.identifier,
							['@plate']      = matricula
						}, function(rowsChanged)
							xPlayer.removeMoney(amount)
							TriggerClientEvent('esx:showNotification', xPlayer.source, ('Vous avez acheté un ~g~FoodTruck !' ))
						end)
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, ('~r~Pas assez d\'argent liquide !' ))
		end
	else
		if xPlayer.getAccount('bank').money >= amount then
			MySQL.Async.fetchAll('SELECT * FROM `foodtruck_owners` WHERE identifier = @identifier',
				{
					['@identifier']  = xPlayer.identifier
				}, function(tiene)
				if not tiene[1] then
					MySQL.Async.execute('INSERT INTO foodtruck_owners (identifier, plate) VALUES (@identifier, @plate)',
						{   
							['@identifier']  = xPlayer.identifier,
							['@plate']      = matricula
						}, function(rowsChanged)
							xPlayer.removeAccountMoney('bank', amount)
							TriggerClientEvent('esx:showNotification', xPlayer.source, ('Vous avez acheté un ~g~FoodTruck !' ))
						end)
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, ('~r~Pas assez d\'argent sur votre compte en banque !' ))
		end
	end				
end)

ESX.RegisterServerCallback('esx_RufiFoodTruck:CheckOwner', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM `foodtruck_owners` WHERE identifier = @identifier',
		{
			['@identifier']  = xPlayer.identifier
		}, function(result)
			if result[1] then
				local rslt = {}
				for i=1, #result, 1 do
					local plate = result[i].plate
					chk = true
					table.insert(rslt,{chk = chk, plate = plate})
					cb(rslt)
				end
			else
				local rslt = {}
				table.insert(rslt,{chk = false, plate = nil})
				cb(rslt)
			end
		end)
end)

ESX.RegisterUsableItem('taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('taco', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_taco_02')
end)

ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('burger', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_cs_burger_01')
end)

ESX.RegisterUsableItem('hotdog', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hotdog', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_cs_hotdog_01')
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chocolate', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_choc_ego')
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_sandwich_01')
end)

ESX.RegisterUsableItem('hamburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hamburger', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'prop_cs_burger_01')
end)

ESX.RegisterUsableItem('cupcake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cupcake', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'ng_proc_food_ornge1a')
end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('Esx_RufiFoodtruck:onEat', source, 'v_ret_ml_chips4')
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cola', 1)
	TriggerClientEvent('esx_status:add', source, 'rthirst', 200000)
	TriggerClientEvent('Esx_RufiFoodtruck:onDrink', source, 'prop_ecola_can')
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('icetea', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 80000)
	TriggerClientEvent('Esx_RufiFoodtruck:onDrink', source, 'prop_ld_can_01')
end)

ESX.RegisterUsableItem('coffee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coffee', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('Esx_RufiFoodtruck:onDrink', source, 'prop_fib_coffee')
end)

ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('beer', 1)
	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
	TriggerClientEvent('Esx_RufiFoodtruck:onDrink', source, 'prop_amb_beer_bottle')
end)