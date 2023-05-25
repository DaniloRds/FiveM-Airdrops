-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local Config = module(GetCurrentResourceName(),"config")

local pickup_positions = {}
local total_drops_requested = 0
local condneve = 0

------------------------------------------------------------------------------------
-- NÃO MEXA EM NADA SE NÃO SOUBER O QUE ESTÁ FAZENDO!
------------------------------------------------------------------------------------

local activateAutoGift = Config.AutoGift

local minTimeToSpawn = Config.minTimeToSpawn   
local maxTimeToSpawn = Config.maxTimeToSpawn   
local quantidadeMin = Config.quantidadeMin   
local quantidadeMax = Config.quantidadeMax   
------------------------------------------------------------------------------------
Citizen.CreateThread(function() 
	while activateAutoGift do
		local timespawn = math.random(minTimeToSpawn, maxTimeToSpawn)
		local randomPlayer = false
		Citizen.Wait(timespawn * 60000)
		local qtd = math.random(quantidadeMin, quantidadeMax)
		if qtd < 1 then
			qtd = 1 
		end
		if qtd > 100 then 
			qtd = 100 
		end
		local users = vRP.getUsers()
		for k,v in pairs(users) do
			local target_source = vRP.getUserSource(k)
			if target_source ~= nil and not randomPlayer then
				randomPlayer = target_source
			end
		end
		if randomPlayer then
			total_drops_requested = total_drops_requested + qtd
			if total_drops_requested > 0 then
				for i=1,total_drops_requested do
					local newPickup = {id = math.random(1, 9999), position = {}, spawned = false, collecting = false }
					table.insert(pickup_positions, newPickup)
					TriggerClientEvent("unity:gift:host_request_new_dropper", randomPlayer, newPickup.id)
					total_drops_requested = total_drops_requested - 1
				end
				users = vRP.getUsers()
				for k,v in pairs(users) do
					local target_source = vRP.getUserSource(k)
					if target_source ~= nil then
						TriggerClientEvent("unity:gift:midsizedMessage", target_source, 2, "ALERTA", "Airdrops cairam pelo mapa, vá até a localização deles.", 6)
					end
				end
			end
		end
	end
end)

RegisterCommand(Config.CommandAir, function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,Config.Permission) and args[1] ~= nil then
			local qtd = tonumber(args[1])
			if qtd < 1 then 
				qtd = 1 
			end
			if qtd > 100 then 
				qtd = 100 
			end
			total_drops_requested = total_drops_requested + qtd
			if total_drops_requested > 0 then
				
				for i=1,total_drops_requested do
					local newPickup = {id = math.random(1, 9999), position = {}, spawned = false, collecting = false }
					table.insert(pickup_positions, newPickup)
					TriggerClientEvent("unity:gift:host_request_new_dropper", player, newPickup.id)
					total_drops_requested = total_drops_requested - 1
				end
				local users = vRP.getUsers()
				for k,v in pairs(users) do
					local target_source = vRP.getUserSource(k)
					if target_source ~= nil then
						TriggerClientEvent("unity:gift:midsizedMessage", target_source, 2, "ALERTA", "Airdrops cairam pelo mapa, vá até a localização deles.", 6)
					end
				end
			end
		end
	end
end)

RegisterServerEvent("b2k:gift:host_request_new_dropper_callback")
AddEventHandler("b2k:gift:host_request_new_dropper_callback", function(loc_id,loc_position)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		for k,v in pairs(pickup_positions) do
			if v.id == loc_id and not v.spawned then
				v.position = loc_position
				v.spawned = true
				TriggerClientEvent("unity:gift:new_dropper", -1, v.id, v.position)
				SetTimeout(30*60*1000, function()
					TriggerClientEvent("unity:gift:remove_dropper", -1, v.id)
				end)
			end
		end
	end
end)

--[[ Items ]]--

-- CONFIGURAÇÃO DOS ITENS QUE PODEM VIR, CASO QUEIRA ALTERAR VÁ ATÉ config.lua

local ItemUm = Config.ItemUm
local ItemDois = Config.ItemDois
local ItemTres = Config.ItemTres
local ItemQuatro = Config.ItemQuatro
local ItemCinco = Config.ItemCinco
local ItemSeis = Config.ItemSeis
local ItemSete = Config.ItemSete
local ItemOito = Config.ItemOito
----------------------------------------------------

-- AQUI SÃO AS QUANTIDADES POSSÍVEIS PARA VIR CADA ITEM

local Quantidade = Config.Quantidade -- AQUIPODE VIR ALEATÓRIO 1 a 3
local QuantidadeMoney = Config.QuantidadeMoney -- USADO PRA DINHEIRO 0 -> 15000
local AmmoQuantidade = Config.AmmoQuantidade-- QUANTIDADE PARA MUNIÇÕES
----------------------------------------------------

-- AQUI SÃO AS ARMAS

local whiteWeapons = Config.whiteWeapons
local commonLethalWeapons = Config.commonLethalWeapons
local rareLethalWeapons = Config.rareLethalWeapons
local epicLethalWeapons = Config.epicLethalWeapons
local ammoWeapons = Config.ammoWeapons

RegisterServerEvent("unity:pickup_dropper")
AddEventHandler("unity:pickup_dropper", function(loc_id)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,10)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		for k,v in pairs(pickup_positions) do
			if v.id == loc_id and v.spawned and not v.collecting then
				v.collecting = true
				TriggerClientEvent("unity:gift:remove_dropper", -1, loc_id)
			
				local itemanameRandom = ""
				local lucky = math.random(1, 10000)

				if lucky < 2500 then -- MONEY
					vRP.giveMoney(user_id, QuantidadeMoney)
					vRPclient.notify(player,"Você ganhou R$" ..QuantidadeMoney)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou R$ "..QuantidadeMoney.."")

				elseif lucky > 4000 and lucky <= 5000 then
					vRP.giveInventoryItem(user_id, item, Quantidade,true)
					vRP.giveInventoryItem(user_id, item, Quantidade,true)
					vRP.giveInventoryItem(user_id, item, Quantidade,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..Quantidade.."x " ..item..", " ..Quantidade.."x " ..item.. "e " ..Quantidade.."x " ..item.."", 10000)

				elseif lucky > 5000 and lucky <= 6000 then
					vRP.giveInventoryItem(user_id, ItemCindo, Quantidade,true)
					vRP.giveInventoryItem(user_id, ItemSeis, Quantidade,true)
					vRP.giveInventoryItem(user_id, ItemSete, Quantidade,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..Quantidade.."x "..ItemCindo..", "..Quantidade.."x" ..ItemSeis.. "e "..Quantidade.."x " ..ItemSete.."", 10000)

				elseif lucky > 6000 and lucky <= 8000 then
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					vRP.giveInventoryItem(user_id, ItemOito, Quantidade,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..QuantidadeMoney.."x "..ItemQuatro..", "..Quantidade.."x" ..ItemOito.."", 10000)

				elseif lucky > 8000 and lucky <= 8800 then
					itemanameRandom = whiteWeapons[math.random(1, #whiteWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeMoney.."x " ..ItemQuatro, 10000)
				
				elseif lucky > 8800 and lucky <= 9300 then
					itemanameRandom = commonLethalWeapons[math.random(1, #commonLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeMoney.."x " ..ItemQuatro, 10000)

				elseif lucky > 9300 and lucky <= 9600 then
					itemanameRandom = ammoWeapons[math.random(1, #ammoWeapons)]
					vRP.giveInventoryItem(user_id, "wammo|"..itemanameRandom, AmmoQuantidade,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..AmmoQuantidade.."x munições de "..itemanameRandom.." e "..QuantidadeMoney.."x " ..ItemQuatro, 10000)

				elseif lucky > 9600 and lucky <= 9800 then
					itemanameRandom = rareLethalWeapons[math.random(1, #rareLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeMoney.."x " ..ItemQuatro, 10000)

				elseif lucky > 9800 and lucky <= 10000 then
					itemanameRandom = epicLethalWeapons[math.random(1, #epicLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeMoney,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeMoney.."x "..ItemQuatro, 10000)

				else
					TriggerClientEvent("Notify",source,"aviso","Você deu azar e não coletou nada...", 5000)
				end
			end
		end
	end
end)
