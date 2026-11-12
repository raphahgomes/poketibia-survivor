local damageMultiplier = damageMultiplierMoves.singletarget
local damageEffect = 767
local teleportEffect = 331
local areaDamage = createCombatArea(AREA_CIRCLE1X1)
local areaEffect = createCombatArea(NO_AREA)
local combat = COMBAT_FIGHTINGDAMAGE
local defenseType = COMBAT_PHYSICALDAMAGE

function onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target then return true end

	local damage = damageMultiplier * creature:getTotalMeleeAttack()
	local creaturePos = creature:getPosition()
	local targetPosition = target:getPosition()
	local effectPosition = target:getPosition()
	effectPosition:getNextPosition(1)
	effectPosition:getNextPosition(2)

	-- No modo PokeView (Player), nao teleporta o jogador para cima da horda!
	if creature:isPlayer() then
		doSendDistanceShoot(creaturePos, targetPosition, CONST_ANI_WHIRLWINDSWORD)
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

	doAreaCombatHealth(creature.uid, combat, effectPosition, areaEffect, 0, 0, damageEffect, defenseType)
	doAreaCombatHealth(creature.uid, combat, targetPosition, areaDamage, -damage, -damage, 0, defenseType)
	return true
end
