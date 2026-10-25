function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then return false end

    -- Action ID 9500: Portal de Entrada no Templo
    if item.actionid == 9500 then
        PokeDungeon.enterLobby(creature)
        return true
    end

    -- Action ID 9501: Portal do Lobby para o Andar
    if item.actionid == 9501 then
        local floorNum = creature:getStorageValue(PokeDungeon.STORAGE_FLOOR)
        if not floorNum or floorNum <= 0 then floorNum = 1 end
        PokeDungeon.startFloor(creature, floorNum)
        return true
    end

    -- Action ID 9502: Portal de Saida do Lobby (Volta pro Templo)
    if item.actionid == 9502 then
        PokeDungeon.leaveDungeon(creature)
        return true
    end

    return true
end
