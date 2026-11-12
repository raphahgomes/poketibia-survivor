function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then return false end

    -- Action ID 9500: Portal de Entrada no Centro Pokémon -> Entra na Praça Pokémon (Lobby)
    if item.actionid == 9500 then
        PokeDungeon.enterLobby(creature)
        return true
    end

    -- Action ID 9501: Portão da Masmorra ou Bancada do Prof. Carvalho -> Seleção do Pokémon Inicial
    if item.actionid == 9501 then
        PokeDungeon.openPokemonSelectModal(creature)
        return true
    end

    -- Action ID 9502: Portal de Saída (Arena -> Praça Pokémon ou Praça Pokémon -> Centro Pokémon)
    if item.actionid == 9502 then
        local inArena = (creature:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1)
        PokeDungeon.cleanArena()
        PokeDungeon.revertToTrainer(creature)

        if inArena then
            creature:teleportTo(PokeDungeon.config.lobbyPos)
            creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Poketestes by Raph] Voce retornou a Praca Pokemon (Lobby) como Treinador.")
        else
            creature:teleportTo(PokeDungeon.config.templePos)
            PokeDungeon.healAtPokemonCenter(creature)
            creature:sendTextMessage(MESSAGE_INFO_DESCR, "[Poketestes by Raph] Voce retornou ao Centro Pokemon de Saffron com a equipe 100% curada!")
        end
        return true
    end

    -- Action ID 9503: Tapete da Tenda Kecleon (Praça Pokémon) -> Abre Loja Kecleon & Contratos Pré-Run
    if item.actionid == 9503 then
        position:sendMagicEffect(CONST_ME_GIFT_WRAPS)
        PokeDungeon.openUpgradesModal(creature)
        return true
    end

    -- Action ID 9504: Tapete do Monumento da Liga Índigo -> Abre Hall da Fama / Leaderboard
    if item.actionid == 9504 then
        position:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        PokeDungeon.showLeaderboard(creature)
        return true
    end

    -- Action ID 9505: Tapete do Console Battle Frontier / Sandbox -> Abre Painel GM / Sandbox
    if item.actionid == 9505 then
        position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        PokeDungeon.openDemoModal(creature)
        return true
    end

    -- Action ID 9506: Estação de Cura Clássica da Enfermeira Joy no Centro Pokémon
    if item.actionid == 9506 then
        PokeDungeon.healAtPokemonCenter(creature)
        return true
    end

    return true
end
