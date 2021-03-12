-----------------------------------------
-- Crée par Hamza#8601 pour AfterLife & Animus
-- Contact devafterlife@gmail.com or contact@afterlife.fr
-----------------------------------------
ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local cbd, limonade = 1, 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'cbdplant', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'cbdplant', _U('cbdprod_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'cbdplant', 'Cbdprod', 'society_cbdplant', 'society_cbdplant', 'society_cbdplant', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "CbdbrutFarm" then
			local itemQuantity = xPlayer.getInventoryItem('cbdbrut').count
			if itemQuantity >= 100 then
				xPlayer.showNotification(_U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('cbdbrut', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_hamzacdbjob:startHarvest')
AddEventHandler('esx_hamzacdbjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		print('creator Hamza#8602')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('cbdbrut_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_hamzacdbjob:stopHarvest')
AddEventHandler('esx_hamzacdbjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		print('creator Hamza#8602')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementCbd" then
			local itemQuantity = xPlayer.getInventoryItem('cbdbrut').count

			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_cbdbrut'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('cbdbrut', 1)
						xPlayer.addInventoryItem('cbd_plus', 1)
						xPlayer.showNotification(_U('cbd_plus'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('cbdbrut', 1)
						xPlayer.addInventoryItem('cbd', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementLimonade" then
			local itemQuantity = xPlayer.getInventoryItem('cbdbrut').count
			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_cbdbrut'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('cbdbrut', 1)
					xPlayer.addInventoryItem('limonade_cbdbrut', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_hamzacdbjob:startTransform')
AddEventHandler('esx_hamzacdbjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_hamzacdbjob:stopTransform')
AddEventHandler('esx_hamzacdbjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre cbdbrut')
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'VenteCbd' then
			if xPlayer.getInventoryItem('cbd').count <= 0 then
				cbd = 0
			else
				cbd = 1
			end
			
			if xPlayer.getInventoryItem('limonade_cbdbrut').count <= 0 then
				limonade = 0
			else
				limonade = 1
			end
		
			if cbd == 0 and limonade == 0 then
				xPlayer.showNotification(_U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('cbd').count <= 0 and limonade == 0 then
				xPlayer.showNotification(_U('no_cbds_sale'))
				cbd = 0
				return
			elseif xPlayer.getInventoryItem('limonade_cbdbrut').count <= 0 and cbd == 0then
				xPlayer.showNotification(_U('no_limonade_sale'))
				limonade = 0
				return
			else
				if (limonade == 1) then
					SetTimeout(1100, function()
						local money = math.random(5,7)
						xPlayer.removeInventoryItem('limonade_cbdbrut', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cbdplant', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (cbd == 1) then
					SetTimeout(1100, function()
						local money = math.random(7,12)
						xPlayer.removeInventoryItem('cbd', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cbdplant', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_hamzacdbjob:startSell')
AddEventHandler('esx_hamzacdbjob:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_hamzacdbjob:stopSell')
AddEventHandler('esx_hamzacdbjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_hamzacdbjob:getStockItem')
AddEventHandler('esx_hamzacdbjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbdplant', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification(_U('have_withdrawn') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_hamzacdbjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbdplant', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_hamzacdbjob:putStockItems')
AddEventHandler('esx_hamzacdbjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cbdplant', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification(_U('added') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_hamzacdbjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

ESX.RegisterUsableItem('limonade_cbdbrut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('limonade_cbdbrut', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_limonade'))
end)

ESX.RegisterUsableItem('cbd_plus', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cbd_plus', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_cbd_plus'))
end)
