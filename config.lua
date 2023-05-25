Config = {}

Config.AutoGift = true -- Define se os drops cairão de forma automatica ou não (true/false)
Config.minTimeToSpawn = 40  -- Minimo de tempo pra spawnar (Em minutos)
Config.maxTimeToSpawn = 60 -- Maximo de tempo pra spawnar (Em minutos)
Config.quantidadeMin = 4 -- Minimo de quantidade para spawnar
Config.quantidadeMax = 8 -- Maximo de quantidade para spawnar

Config.cooldown = 20 -- Tempo que o player vai ter que esperar pra pegar outro drop (Em segundos)

Config.Permission = "admin.permissao" -- Permissão para usar o comando /aidrop (quantidade)
Config.CommandAir = 'airdrop' -- Comando caso queira fazer os drops cairem manualemnte --> /airdrop QUANTIDADE

-- CONFIGURE DAQUI PARA BAIXO OS ITENS QUE VÃO VIR NO DROP

Config.ItemUm = "agua"
Config.ItemDois = "lockpick"
Config.ItemTres = "agua"
Config.ItemQuatro = "dinheiro-sujo" -- CASO ALTERE AQUI PARA UM ITEM DIFERENTE DE DINHEIRO SUJO MUDE NO SERVER.LUA TAMBÉM POIS AQUI ESTÁ CONFIGURADO PARA VIR EM MAIS QUANTIDADE
Config.ItemCinco = "lockpick"
Config.ItemSeis = "agua"
Config.ItemSete = "lockpick"
Config.ItemOito = "energetico"

-- AQUI SÃO AS QUANTIDADES POSSÍVEIS PARA PEGAR OS ITENS

Config.Quantidade = math.random(1, 3) -- AQUI PODE VIR ALEATÓRIO 1 a 3
Config.QuantidadeMoney = math.random(0, 15000) -- USADO PRA DINHEIRO 0 -> 15000
Config.AmmoQuantidade = math.random(20, 50) -- QUANTIDADE PARA MUNIÇÕES

-- ARMAS QUE VOCÊS PODEM COLOCAR PARA DROPAR

Config.whiteWeapons = { -- ARMAS BRANCAS
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

Config.commonLethalWeapons = { -- ARMAS COMUNS DE VIR
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN"
}
Config.rareLethalWeapons = { -- ARMAS RARAS DE VIR
	"WEAPON_SMG",
	"WEAPON_ASSAULTSMG",
	"WEAPON_PUMPSHOTGUN"
}
Config.epicLethalWeapons = { -- ARMAS ÉPICAS
	"WEAPON_CARBINERIFLE",
	"WEAPON_ASSAULTRIFLE",
}

Config.ammoWeapons = { -- MUNIÇÕES
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_SMG",
	"WEAPON_ASSAULTSMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_CARBINERIFLE",
	"WEAPON_ASSAULTRIFLE"
}

return Config
