function onSay(player, words, param)
	local summon = player:getSummon()
	local isPokeView = (player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1)

	if not summon and not isPokeView then
		player:sendCancelMessage("Sorry, not possible. You need a summon to conjure spells.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local tile = Tile(player:getPosition())
	if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage("Sorry, not possible in protection zone.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local caster = summon
	local pokeName = ""
	local target = nil

	if isPokeView then
		caster = player
		pokeName = PokeDungeon.getPlayerPoke(player)
		target = player:getTarget()
	else
		pokeName = summon:getName()
		target = summon:getTarget()
	end

	local monsterType = MonsterType(pokeName)
	if not monsterType then return false end
	local move = monsterType:getMoveList()

	for i = 1, #moveWords do
		if words == moveWords[i] then			
			if move[i] then
				if move[i].isTarget == 1 and not target then
					player:sendCancelMessage("Sorry, not possible. You need a target.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end
				if target and move[i].isTarget == 1 and move[i].range ~= 0 and caster:getPosition():getDistance(target:getPosition()) > move[i].range then
					player:sendCancelMessage("Sorry, not possible. You are too far.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end
				if not isPokeView and getCreatureCondition(summon, CONDITION_SLEEP) then
					player:sendCancelMessage("Sorry, not possible. Your pokemon is sleeping.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end

				-- Cooldown dos Golpes (Com suporte a Buff de Cooldown de 30s)
				local cooldown = (move[i].speed / 1000)
				if isPokeView and PokeDungeon.hasBuff(player, "cooldown") then
					cooldown = cooldown * 0.5
				end

				local exhausted = player:checkMoveExhaustion(i, cooldown)
				if not exhausted then
					local moveName = move[i].name
					doCreatureCastSpell(caster, moveName)
					if isPokeView then
						player:say(moveName:upper() .. "!", TALKTYPE_MONSTER_SAY)
					else
						player:say(pokeName .. ", use " .. moveName .. "!", TALKTYPE_MONSTER_SAY)
					end
				end
			else
				player:sendCancelMessage("Sorry, not possible.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				break
			end
		end
	end
	return false
end
