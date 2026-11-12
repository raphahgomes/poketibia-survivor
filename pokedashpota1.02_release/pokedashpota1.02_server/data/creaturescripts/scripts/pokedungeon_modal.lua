function onModalWindow(player, modalWindowId, buttonId, choiceId)
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    local st = PokeDungeon.playerState[guid]

    -- 1. Janela de Escolha do Pokémon Inicial (Lobby / Portal Norte)
    if modalWindowId == PokeDungeon.MODAL_CHOOSE_POKE then
        if buttonId == 1 then -- "Iniciar"
            local offered = st.offeredPokes
            if offered and offered[choiceId] then
                local chosen = offered[choiceId]
                local floorNum = player:getStorageValue(PokeDungeon.STORAGE_FLOOR)
                if not floorNum or floorNum <= 0 then floorNum = 1 end
                PokeDungeon.startRun(player, chosen, floorNum)
            end
        elseif buttonId == 2 then -- "Melhorias" (Loja Kecleon)
            PokeDungeon.openUpgradesModal(player)
        elseif buttonId == 3 then -- "Modo Demo" (Painel Diretor)
            if st.offeredPokes and st.offeredPokes[choiceId] then
                st.pokeName = st.offeredPokes[choiceId]
            end
            PokeDungeon.openDemoModal(player)
        else
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Poketestes by Raph] Selecao cancelada. Voce continua no Lobby.")
        end
        return true
    end

    -- 2. Loja de Meta-Upgrades Permanentes & Skin Shiny
    if modalWindowId == PokeDungeon.MODAL_UPGRADES then
        if buttonId == 1 then
            PokeDungeon.handleUpgradeChoice(player, choiceId)
        else
            PokeDungeon.openPokemonSelectModal(player)
        end
        return true
    end

    -- 3. Janela de Level Up (3 Traits + Opção de Reroll)
    if modalWindowId == PokeDungeon.MODAL_LEVELUP then
        if buttonId == 1 then -- "Escolher"
            local offered = st.offeredTraits
            if offered and offered[choiceId] then
                local trait = offered[choiceId]
                PokeDungeon.applyTrait(player, trait)
            end
        elseif buttonId == 3 then -- "Reroll"
            if (st.rerollsLeft or 0) > 0 then
                st.rerollsLeft = st.rerollsLeft - 1
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
                local curLvl = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
                PokeDungeon.openLevelUpModal(player, curLvl)
            end
        else
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Poketestes by Raph] Escolha pulada.")
        end
        return true
    end

    -- 4. Painel Diretor / Showcase (!dungeon demo)
    if modalWindowId == PokeDungeon.MODAL_DEMO then
        if buttonId == 1 then
            PokeDungeon.handleDemoChoice(player, choiceId)
        end
        return true
    end

    return true
end
