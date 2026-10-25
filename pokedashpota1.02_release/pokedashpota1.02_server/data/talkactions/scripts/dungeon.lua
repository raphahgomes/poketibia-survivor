function onSay(player, words, param)
    local split = param:split(" ")
    local action = split[1] and split[1]:lower() or ""

    if action == "" or action == "menu" then
        PokeDungeon.openMenu(player)
        return false
    end

    if action == "enter" or action == "lobby" then
        PokeDungeon.enterLobby(player)
        return false
    end

    if action == "leave" or action == "exit" or action == "sair" then
        PokeDungeon.leaveDungeon(player)
        return false
    end

    if action == "rank" or action == "ranking" or action == "leaderboard" or action == "top" then
        PokeDungeon.showLeaderboard(player)
        return false
    end

    if action == "poke" or action == "pokemon" then
        local pokeName = split[2]
        if not pokeName then
            local available = {}
            for k, _ in pairs(PokeDungeon.config.characters) do
                table.insert(available, k)
            end
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[PokeView] Pokemons disponiveis: " .. table.concat(available, ", "))
            return false
        end

        -- Formata primeira letra maiuscula
        pokeName = pokeName:sub(1,1):upper() .. pokeName:sub(2):lower()

        if PokeDungeon.setPlayerPoke(player, pokeName) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[PokeView] Sucesso! Seu personagem agora luta como " .. pokeName .. ".")
        else
            player:sendCancelMessage("[PokeView] Pokemon nao encontrado! Escolha: Charizard, Blastoise, Venusaur, Gengar, Pikachu, Lucario ou Alakazam.")
        end
        return false
    end

    if action == "floor" or action == "andar" or action == "start" or action == "iniciar" then
        local floorNum = tonumber(split[2]) or 1
        if floorNum < 1 or floorNum > #PokeDungeon.config.floors then
            player:sendCancelMessage("Andar invalido! Os andares vao de 1 a 6.")
            return false
        end

        local maxFloor = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_MAX_FLOOR))
        if floorNum > maxFloor then
            player:sendCancelMessage("Voce ainda nao desbloqueou o Andar " .. floorNum .. "! Complete os andares anteriores primeiro.")
            return false
        end

        PokeDungeon.startFloor(player, floorNum)
        return false
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Uso: !dungeon [enter | poke <nome> | floor <1..6> | rank | leave]")
    return false
end
