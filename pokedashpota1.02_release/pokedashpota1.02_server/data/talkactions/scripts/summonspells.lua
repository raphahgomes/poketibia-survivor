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

	-- Modo PokeView (Poketestes by Raph): m1..m12 conjuram diretamente os golpes desbloqueados na Pokébar!
	if isPokeView then
		local pokeName = PokeDungeon.getPlayerPoke(player)
		local unlocked = PokeDungeon.getUnlockedMoves(player)
		for i = 1, #moveWords do
			if words == moveWords[i] then
				local mInfo = unlocked[i]
				if mInfo then
					local aimTarget = player:getTarget()
					if not aimTarget or aimTarget:getHealth() <= 0 then
						aimTarget = PokeDungeon.findAimTarget(player, 7)
					end
					PokeDungeon.executeSurvivorMove(player, pokeName, i, mInfo, aimTarget)
				else
					player:sendCancelMessage("Slot de golpe ainda nao desbloqueado.")
				end
				break
			end
		end
		return false
	end

	local caster = summon
	local pokeName = summon:getName()
	local target = summon:getTarget()

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
				if getCreatureCondition(summon, CONDITION_SLEEP) then
					player:sendCancelMessage("Sorry, not possible. Your pokemon is sleeping.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					break
				end

				local cooldown = (move[i].speed / 1000)
				local exhausted = player:checkMoveExhaustion(i, cooldown)
				if not exhausted then
					local moveName = move[i].name
					doCreatureCastSpell(caster, moveName)
					player:say(pokeName .. ", use " .. moveName .. "!", TALKTYPE_MONSTER_SAY)
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
