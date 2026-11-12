local criticalProbability = 1
local blockedProbability = 1
local racesStrength = 
	{
		["none"] = {strong = {}, weak = {}},
		["blood"] = {strong = {}, weak = {}},
		["physical"] = {strong = {}, weak = {}},
		["healing"] = {strong = {}, weak = {}},
		["fire"] = {strong = {"grass", "ice", "bug", "steel"}, weak = {"water", "ground", "rock"}},
		["grass"] = {strong = {"water", "ground", "rock"}, weak = {"fire", "ice", "poison", "flying", "bug"}},
		["normal"] = {strong = {}, weak = {"fighting"}},
		["water"] = {strong = {"fire", "ground", "rock"}, weak = {"electric", "grass"}},
		["flying"] = {strong = {"grass", "fighting", "bug"}, weak = {"electric", "ice", "rock"}},
		["poison"] = {strong = {"grass", "fairy"}, weak = {"ground", "psychic"}},
		["earth"] = {strong = {"grass", "fairy"}, weak = {"ground", "psychic"}}, --correct CONDITION_POISON = COMBAT_EARTHDAMAGE
		["electric"] = {strong = {"water", "flying"}, weak = {"ground"}},
		["ground"] = {strong = {"fire", "electric", "poison", "rock", "steel"}, weak = {"water", "grass", "ice"}},
		["psychic"] = {strong = {"fighting", "poison"}, weak = {"bug", "ghost", "dark"}},
		["rock"] = {strong = {"fire", "ice", "flying", "bug"}, weak = {"water", "grass", "fighting", "ground", "steel"}},
		["ice"] = {strong = {"grass", "ground", "flying", "dragon"}, weak = {"fire", "fighting", "rock", "steel"}},
		["bug"] = {strong = {"grass", "psychic", "dark"}, weak = {"fire", "flying", "rock"}},
		["dragon"] = {strong = {"dragon"}, weak = {"ice", "dragon", "fairy"}},
		["ghost"] = {strong = {"psychic", "ghost"}, weak = {"ghost", "dark"}},
		["dark"] = {strong = {"psychic", "ghost"}, weak = {"fighting", "bug", "fairy"}},
		["steel"] = {strong = {"ice", "rock", "fairy"}, weak = {"fire", "fighting", "ground"}},
		["fairy"] = {strong = {"fighting", "dragon", "dark"}, weak = {"poison", "steel"}},
		["fighting"] = {strong = {"normal", "ice", "rock", "dark", "steel"}, weak = {"flying", "psychic", "fairy"}}
	}

local function isStrongAgainst(attackerRace, defenderRace, defenderRace2)
	if not racesStrength[attackerRace] then return false end
	if isInArray(racesStrength[attackerRace].strong, defenderRace) or isInArray(racesStrength[attackerRace].strong, defenderRace2) then
		return true
	end

	return false
end

local function isWeakAgainst(attackerRace, defenderRace, defenderRace2)
	if not racesStrength[attackerRace] then return false end
	if isInArray(racesStrength[attackerRace].weak, defenderRace) or isInArray(racesStrength[attackerRace].weak, defenderRace2) then
		return true
	end

	return false
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)

	if not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- 1. Suporte PokeView na Dungeon: Dano do Jogador -> Monstro (Vantagem Elemental Suavizada, Clima, Critico e Lifesteal)
	if attacker and attacker:isPlayer() and creature:isMonster() and attacker:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
		local atkMult = 2.2
		local primaryTypeName = getCombatName(primaryType)
		local defenderMonsterType = MonsterType(creature:getName())

		if defenderMonsterType then
			local defenderRace = defenderMonsterType:getRaceName()
			local defenderRace2 = defenderMonsterType:getRace2Name()
			if isStrongAgainst(primaryTypeName, defenderRace, defenderRace2) then
				atkMult = atkMult * 1.6
				Game.sendAnimatedText(creature:getPosition(), "SUPER!", TEXTCOLOR_ORANGE)
			elseif isWeakAgainst(primaryTypeName, defenderRace, defenderRace2) then
				atkMult = atkMult * 0.65
			end
		end

		-- Bônus de Clima Dinâmico (+25%)
		local guid = attacker:getGuid()
		local st = PokeDungeon.playerState[guid]
		if st and st.weather and PokeDungeon.WEATHERS[st.weather] then
			local boostTypes = PokeDungeon.WEATHERS[st.weather].boostTypes
			if boostTypes and isInArray(boostTypes, primaryTypeName) then
				atkMult = atkMult * 1.25
			end
		end

		-- Chance de Dano Crítico (10% base + 8% por nível de Foco Crítico)
		local critLvl = math.max(0, attacker:getStorageValue(PokeDungeon.STORAGE_TRAIT_CRIT))
		local critChance = 10 + (critLvl * 8)
		if math.random(1, 100) <= critChance then
			atkMult = atkMult * 1.5
			Game.sendAnimatedText(creature:getPosition(), "CRITICO!", TEXTCOLOR_RED)
		end

		if primaryDamage then primaryDamage = math.floor(primaryDamage * atkMult) end
		if secondaryDamage then secondaryDamage = math.floor(secondaryDamage * atkMult) end

		-- Held Item: Shell Bell (8% Lifesteal)
		if PokeDungeon.hasHeldItem(attacker, "shell_bell") then
			local totalDmg = math.abs(primaryDamage or 0) + math.abs(secondaryDamage or 0)
			local leech = math.max(2, math.floor(totalDmg * 0.08))
			if attacker:getHealth() < attacker:getMaxHealth() then
				attacker:addHealth(leech)
			end
		end

		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- 2. Suporte PokeView na Dungeon: Dano do Monstro -> Jogador (Defesa, Rocky Helmet, Focus Sash e God-Mode)
	if creature:isPlayer() and creature:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
		-- Modo Imortal GM (God-Mode)
		if creature:getStorageValue(PokeDungeon.STORAGE_GOD_MODE) == 1 then
			return 0, primaryType, 0, secondaryType
		end

		local floorNum = math.max(1, creature:getStorageValue(PokeDungeon.STORAGE_FLOOR))
		local baseDmg = 4 + (floorNum - 1) * 7 + math.random(1, 4)

		local defTrait = math.max(0, creature:getStorageValue(PokeDungeon.STORAGE_TRAIT_DEF))
		local defMult = math.max(0.25, 1.0 - (defTrait * 0.15))
		if PokeDungeon.hasBuff(creature, "defesa") then
			defMult = defMult * 0.5
		end

		local finalDamage = math.max(1, math.floor(baseDmg * defMult))

		-- Held Item: Rocky Helmet (Reflete dano no atacante)
		if attacker and attacker:isMonster() and PokeDungeon.hasHeldItem(creature, "rocky_helmet") then
			local thorns = 25 + (floorNum * 25)
			attacker:addHealth(-math.min(attacker:getHealth() - 1, thorns))
			attacker:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		end

		-- Held Item: Focus Sash (Impede morte 1x por andar)
		local guid = creature:getGuid()
		local st = PokeDungeon.playerState[guid]
		if finalDamage >= creature:getHealth() and st and st.focusSashReady then
			st.focusSashReady = false
			local restoreHp = math.floor(creature:getMaxHealth() * 0.50)
			creature:addHealth(restoreHp)
			creature:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			creature:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			Game.sendAnimatedText(creature:getPosition(), "FOCUS SASH!", TEXTCOLOR_YELLOW)
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🎗️ [FOCUS SASH] Sua Faixa de Foco impediu sua derrota e restaurou 50% de HP!")
			return 0, primaryType, 0, secondaryType
		end

		return finalDamage, primaryType, 0, secondaryType
	end

	if creature:isPlayer() or attacker:isPlayer() then
		if primaryDamage then primaryDamage = math.floor(primaryDamage * 0.08) end
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local primaryTypeName = getCombatName(primaryType)
	local secondaryTypeName = getCombatName(secondaryType)

	local localDamageMultiplier = 1.0

	local masterLevel
	local summonLevel
	local summonBoost
	local summonLove

	if attacker:getMaster() and attacker:getMaster():isNpc() then
		masterLevel = 100
		summonLevel = attacker:getLevel()
		summonBoost = 0
		summonLove = 0
	else
		masterLevel = attacker:getMasterLevel()
		summonLevel = attacker:getLevel()
		summonBoost = attacker:getBoost()
		summonLove = attacker:getLove()
	end

	local formulaDamage = damageFormula(masterLevel, summonLevel, summonBoost, summonLove)
	localDamageMultiplier = localDamageMultiplier * formulaDamage

	if secondaryTypeName == "physical" then
		local defenseDamping = (1-creature:getTotalDefense()/600)
		if defenseDamping <= 0.5 then 
			defenseDamping = 0.5
		elseif defenseDamping >= 1 then
			defenseDamping = 1
		end
		localDamageMultiplier = localDamageMultiplier * defenseDamping
	else
		if primaryTypeName ~= "physical" and creature:getTotalMagicDefense() > 0 then	
			local defenseDamping = (1-creature:getTotalMagicDefense()/600)
			if defenseDamping <= 0.5 then 
				defenseDamping = 0.5
			elseif defenseDamping >= 1 then
				defenseDamping = 1
			end
			localDamageMultiplier = localDamageMultiplier * defenseDamping
		end
	end

	local defenderMonsterType = MonsterType(creature:getName())
	local defenderRace = defenderMonsterType:getRaceName()
	local defenderRace2 = defenderMonsterType:getRace2Name()

	if isStrongAgainst(primaryTypeName, defenderRace, defenderRace2) then
		localDamageMultiplier = localDamageMultiplier * 1.5
	end

	if isWeakAgainst(primaryTypeName, defenderRace, defenderRace2) then
		localDamageMultiplier = localDamageMultiplier / 1.5
	end

	if math.random(1, 100) <= criticalProbability then
		localDamageMultiplier = localDamageMultiplier * 1.5
		Game.sendAnimatedText(creature:getPosition(), "CRITICAL", TEXTCOLOR_RED)
	else
		if math.random(1, 100) <= blockedProbability then
			localDamageMultiplier = 0.0
			Game.sendAnimatedText(creature:getPosition(), "BLOCKED", TEXTCOLOR_LIGHTGREY)
		end
	end

	if attacker:isPokemon() and creature:isPokemon() then --duel between players
		localDamageMultiplier = localDamageMultiplier / 7.0
	end

	if not attacker:isPokemon() and creature:isPokemon() then --wild pokemon damage
		localDamageMultiplier = localDamageMultiplier / 3.0
	end

	localDamageMultiplier = localDamageMultiplier * (0.3 + math.random(1, 20) * 0.01)

	if primaryDamage then primaryDamage = math.floor(primaryDamage * localDamageMultiplier) end
	if secundaryDamage then secondaryDamage = math.floor(secondaryDamage * localDamageMultiplier) end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
