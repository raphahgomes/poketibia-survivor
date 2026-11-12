local damageMultiplier = damageMultiplierMoves.singletarget
local damageEffect = 10
local teleportEffect = 331
local combat = COMBAT_NORMALDAMAGE
local defenseType = COMBAT_PHYSICALDAMAGE

function onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target then return true end

	local damage = damageMultiplier * creature:getTotalMeleeAttack()
	local creaturePos = creature:getPosition()
	local targetPosition = target:getPosition()

	-- No modo PokeView (Player), nao teleporta o jogador para cima da horda!
	if creature:isPlayer() then
		doSendDistanceShoot(creaturePos, targetPosition, CONST_ANI_THROWINGSTAR)
		targetPosition:sendMagicEffect(teleportEffect)
	else
		creaturePos:sendMagicEffect(teleportEffect)
		local random = math.random(0, 3)
		local stepPos = target:getPosition()
		stepPos:getNextPosition(random)
		local newPos = creature:getClosestFreePosition(stepPos, 0, true)
		newPos:sendMagicEffect(teleportEffect)
		creature:teleportTo(newPos)
	end

	doTargetCombatHealth(creature.uid, target, combat, -damage, -damage, damageEffect, defenseType)
	return true
end
