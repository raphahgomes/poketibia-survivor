function onSay(player, words, param)
    if words == "!pxg" or words == "!kit" then
        PokeDungeon.givePxgStarterTeam(player, true)
        return false
    end

    local split = param:split(" ")
    local action = split[1] and split[1]:lower() or ""

    if action == "" or action == "menu" then
        PokeDungeon.openMenu(player)
        return false
    end

    if action == "gm" or action == "sandbox" or action == "demo" or action == "painel" then
        PokeDungeon.openDemoModal(player)
        return false
    end

    if action == "pxg" or action == "kit" then
        PokeDungeon.givePxgStarterTeam(player, true)
        return false
    end

    if action == "upgrade" or action == "upgrades" or action == "shop" or action == "loja" or action == "kecleon" or action == "boost" then
        PokeDungeon.openUpgradesModal(player)
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

    if action == "shiny" then
        PokeDungeon.handleUpgradeChoice(player, 10)
        return false
    end

    if action == "god" or action == "imortal" then
        PokeDungeon.handleDemoChoice(player, 10)
        return false
    end

    if action == "boss" then
        PokeDungeon.handleDemoChoice(player, 3)
        return false
    end

    if action == "evolve" or action == "evoluir" then
        PokeDungeon.evolvePlayerPokemon(player, true)
        return false
    end

    if action == "poke" or action == "pokemon" then
        local pokeName = split[2]
        if not pokeName then
            local available = PokeDungeon.config.starterOrder or {}
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[PokeView] 25 Linhagens disponiveis: " .. table.concat(available, ", "))
            return false
        end

        pokeName = pokeName:sub(1,1):upper() .. pokeName:sub(2):lower()

        if PokeDungeon.setPlayerPoke(player, pokeName) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[PokeView] Sucesso! Sua linhagem agora e " .. pokeName .. ".")
        else
            player:sendCancelMessage("[PokeView] Pokemon nao encontrado! Use !dungeon para abrir a lista completa com as 25 linhagens.")
        end
        return false
    end

    if action == "floor" or action == "andar" or action == "start" or action == "iniciar" then
        local floorNum = tonumber(split[2]) or 1
        if floorNum < 1 or floorNum > #PokeDungeon.config.floors then
            player:sendCancelMessage("Andar invalido! Os andares vao de 1 a 6.")
            return false
        end

        PokeDungeon.startFloor(player, floorNum)
        return false
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Uso: !dungeon [gm | shop | kit | enter | poke <nome> | floor <1..6> | shiny | evolve | boss | god | rank | leave]")
    return false
end

