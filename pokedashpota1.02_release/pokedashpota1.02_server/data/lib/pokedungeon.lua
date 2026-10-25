-- ====================================================================
-- PokéDungeon Survivor - Modo Torre por Andares com PokeView
-- Baseado no conceito PokéSurvivor adaptado para PokeTibia (Baiak)
-- ====================================================================

PokeDungeon = {
    -- Storages
    STORAGE_ACTIVE = 95000,         -- 1 se estiver na dungeon
    STORAGE_POKEVIEW = 95001,       -- 1 se modo PokeView ativo
    STORAGE_POKENAME = 95002,       -- Nome do pokemon PokeView (string via setSpecialStorage/global table)
    STORAGE_FLOOR = 95003,          -- Andar atual (1..6)
    STORAGE_KILLS = 95004,          -- Monstros mortos no andar atual
    STORAGE_TARGET = 95005,         -- Meta de monstros do andar
    STORAGE_MAX_FLOOR = 95006,      -- Maior andar desbloqueado
    STORAGE_TOTAL_KILLS = 95007,    -- Total geral de kills

    -- Buff Storages (armazenam timestamp de termino os.time() + 30)
    STORAGE_BUFF_HP = 95010,
    STORAGE_BUFF_DEF = 95011,
    STORAGE_BUFF_ATK = 95012,
    STORAGE_BUFF_SPD = 95013,
    STORAGE_BUFF_CD  = 95014,

    -- Configuração de Coordenadas
    config = {
        lobbyPos = Position(1805, 2255, 7),     -- Sala de espera segura (Lobby)
        arenaPos = Position(1830, 2268, 7),     -- Ponto central da Arena
        arenaArea = {
            from = Position(1814, 2258, 7),
            to = Position(1849, 2278, 7)
        },
        templePos = Position(1054, 1050, 7),    -- Templo principal (Saffron)

        buffDuration = 30,  -- 30 segundos
        buffDropChance = 25, -- 25% de chance ao matar monstro de dropar/ativar buff

        -- Configuração dos Andares
        floors = {
            [1] = {
                targetKills = 10,
                level = 15,
                monsters = {"Rattata", "Caterpie", "Pidgey", "Weedle", "Bellsprout", "Oddish"},
                spawnInterval = 2000,
                spawnAmount = 3,
                maxMonsters = 15,
                name = "Andar 1: Planicie Inicial (10 Kills)",
                desc = "Inimigos fracos (Lv 10-15). Bom para aquecer os golpes."
            },
            [2] = {
                targetKills = 50,
                level = 35,
                monsters = {"Geodude", "Zubat", "Ekans", "Mankey", "Sandshrew", "Machop"},
                spawnInterval = 1800,
                spawnAmount = 4,
                maxMonsters = 25,
                name = "Andar 2: Caverna Rochosa (50 Kills)",
                desc = "Monstros venenosos e rochosos (Lv 30-40)."
            },
            [3] = {
                targetKills = 100,
                level = 65,
                monsters = {"Kadabra", "Haunter", "Machoke", "Magneton", "Golbat", "Graveler"},
                spawnInterval = 1500,
                spawnAmount = 5,
                maxMonsters = 35,
                name = "Andar 3: Torre Fantasma (100 Kills)",
                desc = "Evolucoes intermediarias rapidas e perigosas (Lv 60-70)."
            },
            [4] = {
                targetKills = 1000,
                level = 95,
                monsters = {"Gengar", "Alakazam", "Gyarados", "Arcanine", "Rhydon", "Scizor", "Poliwrath"},
                spawnInterval = 1200,
                spawnAmount = 7,
                maxMonsters = 50,
                name = "Andar 4: Horda da Furia (1.000 Kills)",
                desc = "Hordas massivas de Pokemons totalmente evoluidos (Lv 90-100)."
            },
            [5] = {
                targetKills = 2500,
                level = 135,
                monsters = {"Dragonite", "Tyranitar", "Salamence", "Metagross", "Ancient Dragonite", "Ancient Lapras"},
                spawnInterval = 1000,
                spawnAmount = 8,
                maxMonsters = 65,
                name = "Andar 5: Enxame Titanico (2.500 Kills)",
                desc = "Pseudo-lendarios brutais com alta resistencia e dano (Lv 130-150)."
            },
            [6] = {
                targetKills = 5000,
                level = 190,
                monsters = {"Mewtwo", "Rayquaza", "Zapdos", "Moltres", "Articuno", "Ancient Gengar", "Lugia"},
                spawnInterval = 800,
                spawnAmount = 10,
                maxMonsters = 80,
                name = "Andar 6: Apocalipse Lendario (5.000 Kills)",
                desc = "Chefes e Lendarios implacaveis. O desafio supremo!"
            }
        },

        -- Pokemons do Modo PokeView
        characters = {
            ["Charizard"] = {
                lookType = 909,
                hp = 4500,
                speed = 260,
                type = "fire",
                moves = {"scratch", "ember", "flamethrower", "slash", "fireball", "fire blast", "wing attack"}
            },
            ["Blastoise"] = {
                lookType = 912,
                hp = 5200,
                speed = 230,
                type = "water",
                moves = {"bite", "water gun", "water pulse", "bubble beam", "hydro pump", "skull bash"}
            },
            ["Venusaur"] = {
                lookType = 906,
                hp = 5000,
                speed = 220,
                type = "grass",
                moves = {"tackle", "vine whip", "razor leaf", "poison powder", "solar beam", "leech seed"}
            },
            ["Gengar"] = {
                lookType = 997,
                hp = 3800,
                speed = 280,
                type = "ghost",
                moves = {"lick", "shadow ball", "night shade", "hypnosis", "dream eater", "dark pulse"}
            },
            ["Pikachu"] = {
                lookType = 928,
                hp = 3400,
                speed = 310,
                type = "electric",
                moves = {"quick attack", "thunder shock", "thunder wave", "spark", "thunderbolt", "thunder"}
            },
            ["Alakazam"] = {
                lookType = 968,
                hp = 3300,
                speed = 290,
                type = "psychic",
                moves = {"confusion", "psybeam", "psychic", "recover", "calm mind", "psywave"}
            },
            ["Lucario"] = {
                lookType = 3056,
                hp = 4400,
                speed = 290,
                type = "fighting",
                moves = {"quick attack", "force palm", "bone rush", "aura sphere", "close combat", "dragon pulse"}
            }
        }
    },

    -- Memoria volatil de estado por jogador
    playerState = {},
    spawnerEvents = {}
}

-- Armazenamento em memoria do PokeView do jogador
function PokeDungeon.getPlayerPoke(player)
    local guid = player:getGuid()
    if PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].pokeName then
        return PokeDungeon.playerState[guid].pokeName
    end
    return "Charizard"
end

function PokeDungeon.setPlayerPoke(player, pokeName)
    local charData = PokeDungeon.config.characters[pokeName]
    if not charData then return false end

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    PokeDungeon.playerState[guid].pokeName = pokeName

    -- Aplica outfit do Pokemon
    player:setOutfit({lookType = charData.lookType})
    player:setStorageValue(PokeDungeon.STORAGE_POKEVIEW, 1)

    -- Ajusta velocidade inicial
    player:changeSpeed(-player:getSpeed() + charData.speed)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "[PokeView] Voce se transformou em " .. pokeName .. "! Use m1, m2, m3... para disparar seus golpes.")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
    return true
end

-- ====================================================================
-- SISTEMA DE BUFFS TEMPORARIOS (30 Segundos)
-- ====================================================================

PokeDungeon.BUFF_TYPES = {
    ["vida"] = {
        name = "Vigor (Vida)",
        storage = PokeDungeon.STORAGE_BUFF_HP,
        effect = CONST_ME_MAGIC_GREEN,
        apply = function(player)
            player:addHealth(player:getMaxHealth() - player:getHealth())
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BUFF] Vigor Ativo! Vida 100% restaurada durante 30s!")
        end
    },
    ["defesa"] = {
        name = "Coraza (Defesa)",
        storage = PokeDungeon.STORAGE_BUFF_DEF,
        effect = CONST_ME_MAGIC_BLUE,
        apply = function(player)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BUFF] Coraza Ativa! -50% de dano recebido durante 30s!")
        end
    },
    ["ataque"] = {
        name = "Potencia (Ataque)",
        storage = PokeDungeon.STORAGE_BUFF_ATK,
        effect = CONST_ME_HITBYFIRE,
        apply = function(player)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BUFF] Potencia Ativa! +60% de dano em todos os golpes durante 30s!")
        end
    },
    ["velocidade"] = {
        name = "Agilidade (Speed)",
        storage = PokeDungeon.STORAGE_BUFF_SPD,
        effect = CONST_ME_ENERGYAREA,
        apply = function(player)
            player:changeSpeed(180)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BUFF] Agilidade Ativa! +180 de velocidade de movimento durante 30s!")
        end
    },
    ["cooldown"] = {
        name = "Reflejos (Recarga Rapida)",
        storage = PokeDungeon.STORAGE_BUFF_CD,
        effect = CONST_ME_MAGIC_RED,
        apply = function(player)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[BUFF] Reflejos Ativo! -50% de cooldown nos golpes durante 30s!")
        end
    }
}

function PokeDungeon.hasBuff(player, buffKey)
    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return false end
    local expires = player:getStorageValue(buffInfo.storage)
    return expires and expires > os.time()
end

function PokeDungeon.applyBuff(player, buffKey)
    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return false end

    local now = os.time()
    player:setStorageValue(buffInfo.storage, now + PokeDungeon.config.buffDuration)
    player:getPosition():sendMagicEffect(buffInfo.effect)

    if buffInfo.apply then
        buffInfo.apply(player)
    end

    -- Loop de animacao do buff
    PokeDungeon.tickBuffAnimation(player:getId(), buffKey, 0)
    return true
end

function PokeDungeon.tickBuffAnimation(playerId, buffKey, secondsElapsed)
    local player = Player(playerId)
    if not player then return end

    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return end

    local timeLeft = player:getStorageValue(buffInfo.storage) - os.time()
    if timeLeft > 0 then
        -- Efeito visual a cada 3 segundos
        if secondsElapsed % 3 == 0 then
            player:getPosition():sendMagicEffect(buffInfo.effect)
        end
        addEvent(PokeDungeon.tickBuffAnimation, 1000, playerId, buffKey, secondsElapsed + 1)
    else
        -- Buff expirou
        if buffKey == "velocidade" then
            player:changeSpeed(-180)
        end
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Dungeon] O buff " .. buffInfo.name .. " expirou.")
    end
end

-- ====================================================================
-- ENTRADA, ANDARES E SPAWNER
-- ====================================================================

function PokeDungeon.enterLobby(player)
    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, 1)

    -- Configura PokeView se ainda nao tiver
    local currentPoke = PokeDungeon.getPlayerPoke(player)
    PokeDungeon.setPlayerPoke(player, currentPoke)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "=== BEM-VINDO AO LOBBY DA POKEDUNGEON ===")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Digite '!dungeon' para abrir o menu, escolher seu Pokemon ou iniciar um Andar!")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Derrote a meta de Pokemons para subir de andar. Colete buffs de 30s pelo caminho!")
    return true
end

function PokeDungeon.leaveDungeon(player)
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, -1)
    player:setStorageValue(PokeDungeon.STORAGE_POKEVIEW, -1)

    -- Reseta outfit padrao
    player:setOutfit(player:getOutfit())
    player:teleportTo(PokeDungeon.config.templePos)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "[Dungeon] Voce retornou a cidade principal.")
    return true
end

function PokeDungeon.cleanArena()
    local fromPos = PokeDungeon.config.arenaArea.from
    local toPos = PokeDungeon.config.arenaArea.to

    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tile = Tile(x, y, fromPos.z)
            if tile and tile:getCreatureCount() > 0 then
                for i = 1, tile:getCreatureCount() do
                    local creature = tile:getCreatures()[i]
                    if creature and creature:isMonster() and not creature:isPokemon() then
                        creature:remove()
                    end
                end
            end
        end
    end
end

function PokeDungeon.startFloor(player, floorNum)
    local floorData = PokeDungeon.config.floors[floorNum]
    if not floorData then
        player:sendCancelMessage("Andar invalido!")
        return false
    end

    -- Registra dados do jogador
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, 1)
    player:setStorageValue(PokeDungeon.STORAGE_FLOOR, floorNum)
    player:setStorageValue(PokeDungeon.STORAGE_KILLS, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TARGET, floorData.targetKills)

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    PokeDungeon.playerState[guid].floorStartTime = os.time()

    -- Garante modo PokeView
    local pokeName = PokeDungeon.getPlayerPoke(player)
    PokeDungeon.setPlayerPoke(player, pokeName)

    -- Limpa a arena e teleporta
    PokeDungeon.cleanArena()
    player:teleportTo(PokeDungeon.config.arenaPos)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

    broadcastMessage("[Dungeon] O jogador " .. player:getName() .. " iniciou o " .. floorData.name .. "!", MESSAGE_STATUS_WARNING)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "--- " .. floorData.name .. " INICIADO! ---")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Objetivo: Derrotar " .. floorData.targetKills .. " Pokemons selvagens para avancar!")

    -- Inicia o Spawner do Andar
    PokeDungeon.runSpawner(player:getId(), floorNum)
    return true
end

function PokeDungeon.countAliveMonsters()
    local count = 0
    local fromPos = PokeDungeon.config.arenaArea.from
    local toPos = PokeDungeon.config.arenaArea.to

    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tile = Tile(x, y, fromPos.z)
            if tile and tile:getCreatureCount() > 0 then
                for i = 1, tile:getCreatureCount() do
                    local creature = tile:getCreatures()[i]
                    if creature and creature:isMonster() and not creature:isPokemon() then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

function PokeDungeon.runSpawner(playerId, floorNum)
    local player = Player(playerId)
    if not player then return end

    if player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) ~= 1 or player:getStorageValue(PokeDungeon.STORAGE_FLOOR) ~= floorNum then
        return
    end

    local floorData = PokeDungeon.config.floors[floorNum]
    if not floorData then return end

    local currentKills = player:getStorageValue(PokeDungeon.STORAGE_KILLS)
    if currentKills >= floorData.targetKills then
        return -- Ja concluiu o andar
    end

    local alive = PokeDungeon.countAliveMonsters()
    if alive < floorData.maxMonsters then
        local pPos = player:getPosition()
        local spawned = 0

        for i = 1, floorData.spawnAmount do
            if alive + spawned >= floorData.maxMonsters then break end

            local randomMonster = floorData.monsters[math.random(1, #floorData.monsters)]
            local angle = math.random() * 2 * math.pi
            local dist = math.random(5, 10)
            local sx = math.floor(pPos.x + math.cos(angle) * dist)
            local sy = math.floor(pPos.y + math.sin(angle) * dist)

            -- Delimita na area da arena
            sx = math.max(PokeDungeon.config.arenaArea.from.x + 1, math.min(PokeDungeon.config.arenaArea.to.x - 1, sx))
            sy = math.max(PokeDungeon.config.arenaArea.from.y + 1, math.min(PokeDungeon.config.arenaArea.to.y - 1, sy))

            local spawnPos = Position(sx, sy, pPos.z)
            local monster = Game.createMonster(randomMonster, spawnPos, false, false, floorData.level, 0)
            if monster then
                spawnPos:sendMagicEffect(CONST_ME_POFF)
                monster:setTarget(player)
                spawned = spawned + 1
            end
        end
    end

    -- Proxima onda
    addEvent(PokeDungeon.runSpawner, floorData.spawnInterval, playerId, floorNum)
end

-- ====================================================================
-- ABATES E PROGRESSAO
-- ====================================================================

function PokeDungeon.onMonsterKill(player, monster)
    if not player or player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) ~= 1 then
        return
    end

    local floorNum = player:getStorageValue(PokeDungeon.STORAGE_FLOOR)
    local floorData = PokeDungeon.config.floors[floorNum]
    if not floorData then return end

    local currentKills = player:getStorageValue(PokeDungeon.STORAGE_KILLS) + 1
    player:setStorageValue(PokeDungeon.STORAGE_KILLS, currentKills)

    local totalKills = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS)) + 1
    player:setStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS, totalKills)

    -- Chance de Dropar/Ativar Buff de 30 segundos
    if math.random(1, 100) <= PokeDungeon.config.buffDropChance then
        local buffList = {"vida", "defesa", "ataque", "velocidade", "cooldown"}
        local selectedBuff = buffList[math.random(1, #buffList)]
        PokeDungeon.applyBuff(player, selectedBuff)
    end

    -- Notificacao de progresso
    if currentKills % 5 == 0 or currentKills == floorData.targetKills or currentKills % 50 == 0 then
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "[Dungeon] Progresso: " .. currentKills .. " / " .. floorData.targetKills .. " Kills.")
    end

    -- Venceu o Andar!
    if currentKills >= floorData.targetKills then
        PokeDungeon.completeFloor(player, floorNum)
    end
end

function PokeDungeon.completeFloor(player, floorNum)
    local floorData = PokeDungeon.config.floors[floorNum]
    PokeDungeon.cleanArena()

    local guid = player:getGuid()
    local startTime = (PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].floorStartTime) or os.time()
    local duration = os.time() - startTime

    -- Atualiza maior andar desbloqueado
    local maxFloor = math.max(player:getStorageValue(PokeDungeon.STORAGE_MAX_FLOOR), floorNum)
    player:setStorageValue(PokeDungeon.STORAGE_MAX_FLOOR, maxFloor + 1)

    -- Atualiza no Banco de Dados
    PokeDungeon.updateLeaderboard(player, floorNum, player:getStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS), duration)

    broadcastMessage("[Dungeon] PARABENS! " .. player:getName() .. " concluiu o " .. floorData.name .. " em " .. duration .. " segundos!", MESSAGE_STATUS_WARNING)

    -- Recompensas do Andar
    player:addItem("crystal coin", floorNum * 5)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[VITORIA] Voce completou o " .. floorData.name .. "!")
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa: " .. (floorNum * 5) .. " Crystal Coins adicionados a sua mochila!")

    if PokeDungeon.config.floors[floorNum + 1] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "O proximo andar (" .. (floorNum + 1) .. ") foi desbloqueado! Fale com o portal ou use '!dungeon'.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "INCRIVEL! Voce zerou todos os andares da PokeDungeon! O topo da torre e seu!")
    end

    -- Retorna ao lobby em seguranca
    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
end

-- ====================================================================
-- MORTE: RETORNA AO LOBBY SEM SAIR DO PORTAL
-- ====================================================================

function PokeDungeon.onPlayerDeath(player)
    if player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) ~= 1 then
        return false -- Comportamento de morte normal
    end

    -- Cancela morte: cura e manda para o Lobby
    player:addHealth(player:getMaxHealth())
    PokeDungeon.cleanArena()

    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:getPosition():sendMagicEffect(CONST_ME_POFF)

    -- Mensagens
    player:sendTextMessage(MESSAGE_STATUS_WARNING, "[Dungeon] Voce caiu em combate no Andar " .. player:getStorageValue(PokeDungeon.STORAGE_FLOOR) .. "!")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Voce retornou a salvo ao Lobby da Dungeon. Recupere o folego e tente novamente!")

    -- Reseta progresso do andar atual
    player:setStorageValue(PokeDungeon.STORAGE_KILLS, 0)
    return true
end

-- ====================================================================
-- LEADERBOARD (BANCO DE DADOS)
-- ====================================================================

function PokeDungeon.updateLeaderboard(player, floorNum, totalKills, timeElapsed)
    local pId = player:getGuid()
    local pName = db.escapeString(player:getName())

    local query = string.format([[
        INSERT INTO `dungeon_leaderboard` (`player_id`, `player_name`, `highest_floor`, `total_kills`, `best_time`)
        VALUES (%d, %s, %d, %d, %d)
        ON DUPLICATE KEY UPDATE
            `highest_floor` = GREATEST(`highest_floor`, %d),
            `total_kills` = GREATEST(`total_kills`, %d),
            `best_time` = CASE WHEN `best_time` = 0 THEN %d ELSE LEAST(`best_time`, %d) END
    ]], pId, pName, floorNum, totalKills, timeElapsed, floorNum, totalKills, timeElapsed, timeElapsed)

    db.query(query)
end

function PokeDungeon.showLeaderboard(player)
    local resultId = db.storeQuery("SELECT `player_name`, `highest_floor`, `total_kills`, `best_time` FROM `dungeon_leaderboard` ORDER BY `highest_floor` DESC, `total_kills` DESC, `best_time` ASC LIMIT 10")

    local text = "=== RANKING POKEDUNGEON SURVIVOR ===\n\n"
    if resultId ~= false then
        local rank = 1
        repeat
            local name = result.getDataString(resultId, "player_name")
            local floor = result.getDataInt(resultId, "highest_floor")
            local kills = result.getDataInt(resultId, "total_kills")
            local time = result.getDataInt(resultId, "best_time")

            text = text .. string.format("#%d - %s | Andar: %d | Kills: %d | Tempo: %ds\n", rank, name, floor, kills, time)
            rank = rank + 1
        until not result.next(resultId)
        result.free(resultId)
    else
        text = text .. "Nenhum registro no ranking ainda! Seja o primeiro a conquistar os andares!\n"
    end

    text = text .. "\nDesafie os andares usando '!dungeon'!"
    player:showTextDialog(1950, text)
end

-- ====================================================================
-- MENU MODAL / TALKACTION INTERATIVA
-- ====================================================================

function PokeDungeon.openMenu(player)
    local maxFloor = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_MAX_FLOOR))
    local currentPoke = PokeDungeon.getPlayerPoke(player)

    local msg = "Escolha uma opcao:\n" ..
                "• Pokemon PokeView Atual: " .. currentPoke .. "\n" ..
                "• Maior Andar Desbloqueado: " .. maxFloor .. "\n\n" ..
                "Comandos Rapidos no Chat:\n" ..
                "!dungeon enter        -> Ir para o Lobby\n" ..
                "!dungeon poke <nome>  -> Mudar Pokemon (ex: Charizard, Blastoise, Gengar...)\n" ..
                "!dungeon floor <1..6> -> Entrar no Andar\n" ..
                "!dungeon rank         -> Ver Placar de Lideres\n" ..
                "!dungeon leave        -> Voltar ao Templo"

    player:showTextDialog(2548, msg)
end
