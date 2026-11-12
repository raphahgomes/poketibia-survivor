function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then return false end

    -- Action ID 9500: Portal de Entrada no Templo -> Entra no Lobby como Treinador
    if item.actionid == 9500 then
        PokeDungeon.enterLobby(creature)
        return true
    end

    -- Action ID 9501: Portal do Lobby para o Andar -> Abre Janela de Escolha do Pokémon!
    if item.actionid == 9501 then
        PokeDungeon.openPokemonSelectModal(creature)
        return true
    end

    -- Action ID 9502: Portal de Saída (Arena -> Lobby ou Lobby -> Templo)
    if item.actionid == 9502 then
        local inArena = (creature:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1)
        PokeDungeon.cleanArena()
        PokeDungeon.revertToTrainer(creature)

        if inArena then
            creature:teleportTo(PokeDungeon.config.lobbyPos)
            creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Poketestes by Raph] Voce retornou ao Lobby como Treinador.")
        else
            creature:teleportTo(PokeDungeon.config.templePos)
            creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Poketestes by Raph] Voce retornou a cidade como Treinador.")
        end
        return true
    end

    return true
end
