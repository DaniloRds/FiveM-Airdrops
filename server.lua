-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
GFclient = Tunnel.getInterface("unity_airdrops")

local pickup_positions = {}
local total_drops_requested = 0
local condneve = 0

------------------------------------------------------------------------------------
-- Ativar presente automatico
------------------------------------------------------------------------------------
local activateAutoGift = true

local minTimeToSpawn = 40   --Minimo de tempo pra spawnar
local maxTimeToSpawn = 60   --Maximop de tempo pra spawnar
local quantidadeMin = 4      --Minimo de quantidade para spawnar
local quantidadeMax = 8     --Maximo de quantidade para spawnar
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

------------------------------------------------------------------------------------
-- COMANDO CASO QUEIRA FAZER OS DROPS CAIREM MANUALMENTE /airdrop QUANTIDADE
------------------------------------------------------------------------------------
RegisterCommand('airdrop', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") and args[1] ~= nil then
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

-- CONFIGURE DAQUI PARA BAIXO OS ITENS QUE VÃO VIR NO DROP

local ItemUm = "polvora"
local ItemDois = "chumbo"
local ItemTres = "capsula"
local ItemQuatro = "dinheiro-sujo"
local ItemCindo = "tecido"
local ItemSeis = "algemas"
local ItemSete = "lockpick"
local ItemOito = "energetico"

-- AQUI SÃO AS QUANTIDADES POSSÍVEIS PARA VIR CADA ITEM

local Quant = 1 -- AQUI SÓ VEM 1
local Quantidade = math.random(1, 3) -- AQUIPODE VIR ALEATÓRIO 1 a 3
local QuantidadeUm = math.random(5, 10) -- AQUI PODE VIR ALEATÓRIO DE 5 a 10
local QuantidadeDois = math.random(10, 15) -- 
local QuantidadeTres = math.random(15, 30) --
local QuantidadeQuatro = math.random(0, 15000) -- USADO PRA DINHEIRO 0 -> 15000
local AmmoQuantidade = math.random(20, 50) -- QUANTIDADE PARA MUNIÇÕES
----------------------------------------------------

-- ARMAS QUE VOCÊS PODEM COLOCAR PARA DROPAR
local whiteWeapons = {
	"WEAPON_BAT",
	"WEAPON_KNUCKLE",
	"WEAPON_KNIFE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_CROWBAR",
	"WEAPON_HATCHET",
	"WEAPON_DAGGER",
	"WEAPON_MACHETE",
	"WEAPON_BOTTLE",
}

local commonLethalWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN"
}
local rareLethalWeapons = {
	"WEAPON_SMG",
	"WEAPON_ASSAULTSMG",
	"WEAPON_PUMPSHOTGUN"
}
local epicLethalWeapons = {
	"WEAPON_CARBINERIFLE",
	"WEAPON_ASSAULTRIFLE",
}
local ammoWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_SMG",
	"WEAPON_ASSAULTSMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_CARBINERIFLE",
	"WEAPON_ASSAULTRIFLE"
}


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


				if lucky <= 5000 then -- MONEY
					vRP.giveMoney(user_id, QuantidadeQuatro)
					vRPclient.notify(player,"Você ganhou R$" ..QuantidadeQuatro)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou R$ "..QuantidadeQuatro.."")

				elseif lucky > 3000 and lucky <= 5000 then
					vRP.giveInventoryItem(user_id, ItemUm, QuantidadeUm,true)
					vRP.giveInventoryItem(user_id, ItemDois, QuantidadeUm,true)
					vRP.giveInventoryItem(user_id, ItemTres, QuantidadeUm,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..QuantidadeUm.."x " ..ItemUm..", " ..QuantidadeUm.."x " ..ItemDois.. "e " ..QuantidadeUm.."x " ..ItemTres.."", 10000)

				elseif lucky > 5001 and lucky <= 7000 then
					vRP.giveInventoryItem(user_id, ItemCindo, QuantidadeUm,true)
					vRP.giveInventoryItem(user_id, ItemSeis, Quantidade,true)
					vRP.giveInventoryItem(user_id, ItemSete, Quantidade,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..QuantidadeUm.."x "..ItemCindo..", "..Quantidade.."x" ..ItemSeis.. "e "..Quantidade.."x " ..ItemSete.."", 10000)

				elseif lucky > 7001 and lucky <= 8999 then
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					vRP.giveInventoryItem(user_id, ItemOito, Quantidade,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..QuantidadeQuatro.."x "..ItemQuatro..", "..Quantidade.."x" ..ItemOito.."", 10000)

				elseif lucky > 9000 and lucky <= 9300 then
					itemanameRandom = whiteWeapons[math.random(1, #whiteWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeQuatro.."x " ..ItemQuatro, 10000)
				
				elseif lucky > 9301 and lucky <= 9500 then
					itemanameRandom = commonLethalWeapons[math.random(1, #commonLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeQuatro.."x " ..ItemQuatro, 10000)

				elseif lucky > 9500 and lucky <= 9700 then
					itemanameRandom = ammoWeapons[math.random(1, #ammoWeapons)]
					vRP.giveInventoryItem(user_id, "wammo|"..itemanameRandom, AmmoQuantidade,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou "..AmmoQuantidade.."x munições de "..itemanameRandom.." e "..QuantidadeQuatro.."x " ..ItemQuatro, 10000)

				elseif lucky > 9701 and lucky <= 9800 then
					itemanameRandom = rareLethalWeapons[math.random(1, #rareLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeQuatro.."x " ..ItemQuatro, 10000)

				elseif lucky > 9801 and lucky <= 9999 then
					itemanameRandom = epicLethalWeapons[math.random(1, #epicLethalWeapons)]
					vRP.giveInventoryItem(user_id, "wbody|"..itemanameRandom, 1,true)
					vRP.giveInventoryItem(user_id, ItemQuatro, QuantidadeQuatro,true)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou 1x "..itemanameRandom.." e "..QuantidadeQuatro.."x "..ItemQuatro, 10000)

				else
					TriggerClientEvent("Notify",source,"aviso","Você deu azar e não coletou nada...", 5000)
				end
			end
		end
	end
end)
