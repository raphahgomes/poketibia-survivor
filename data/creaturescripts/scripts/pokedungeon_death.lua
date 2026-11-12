function onPrepareDeath(creature, killer)
    if creature:isPlayer() and creature:getStorageValue(PokeDungeon.STORAGE_ACTIVE) == 1 then
        PokeDungeon.onPlayerDeath(creature)
        return false -- Cancela a morte: sem perda de EXP, itens ou skills
    end
    return true
end

