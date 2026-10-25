function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if creature:isMonster() and not creature:isPokemon() then
        local player = killer
        if player and not player:isPlayer() and player:getMaster() then
            player = player:getMaster()
        end

        if not player or not player:isPlayer() then
            if mostDamageKiller and mostDamageKiller:isPlayer() then
                player = mostDamageKiller
            elseif mostDamageKiller and mostDamageKiller:getMaster() and mostDamageKiller:getMaster():isPlayer() then
                player = mostDamageKiller:getMaster()
            end
        end

        if player and player:isPlayer() and player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) == 1 then
            PokeDungeon.onMonsterKill(player, creature)
        end
    end
    return true
end
