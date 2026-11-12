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
            local corpsePos = creature:getPosition()
            local skull = creature:getSkull()
            local cName = creature:getName()

            -- Remove o corpo morto da arena para manter o chão limpo e destacar as Gemas de EXP
            if corpse and type(corpse) == "userdata" and corpse.remove then
                pcall(function() corpse:remove() end)
            end

            local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
            local gemId = 2146 -- Safira Azul (18 EXP)
            if floorNum >= 5 then
                gemId = 2147 -- Rubi Vermelho (85 EXP)
            elseif floorNum >= 3 then
                gemId = 2149 -- Esmeralda Verde (40 EXP)
            end

            -- Recompensas Especiais: Boss, Shiny ou Meowth do Tesouro
            if skull == SKULL_RED or skull == SKULL_WHITE then
                PokeDungeon.spawnArenaChest(corpsePos)
                for _ = 1, 3 do
                    Game.createItem(2147, 1, corpsePos)
                end
                player:addItem(2160, 5)
                corpsePos:sendMagicEffect(CONST_ME_FIREWORK_RED)
                Game.sendAnimatedText(corpsePos, "BOSS DOWN!", TEXTCOLOR_RED)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🏆 [BOSS DERROTADO] " .. cName .. " deixou um Bau de Tesouro e +5 Crystal Coins!")

            elseif skull == SKULL_YELLOW or cName:find("Shiny ") then
                for _ = 1, 4 do
                    Game.createItem(2147, 1, corpsePos)
                end
                player:addItem(2160, 3)
                corpsePos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                Game.sendAnimatedText(corpsePos, "SHINY +3 CC!", TEXTCOLOR_YELLOW)

            elseif skull == SKULL_GREEN then
                for _ = 1, 5 do
                    Game.createItem(2147, 1, corpsePos)
                end
                player:addItem(2160, 5)
                corpsePos:sendMagicEffect(CONST_ME_GIFT_WRAPS)
                Game.sendAnimatedText(corpsePos, "JACKPOT!", TEXTCOLOR_YELLOW)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "💰 [JACKPOT] Voce derrotou o Meowth do Tesouro e ganhou +5 Crystal Coins e Rubis de EXP!")

            else
                local gem = Game.createItem(gemId, 1, corpsePos)
                if gem then
                    corpsePos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                end
            end

            PokeDungeon.onMonsterKill(player, creature)
        end
    end
    return true
end
