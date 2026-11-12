-- ====================================================================
-- Poketestes by Raph - Sistema de Dungeons & Arenas de Sobrevivência
-- Inclui: 25 Linhagens com Evolução In-Run (Estágio 1 -> 2 -> 3),
-- 17 Tipos e 10 Arquétipos de Combate, Golpes Evoluídos (Golpe+),
-- Bosses com Ataques Telegrafados, Altares, Fontes, Baús, Held Items,
-- Shinies, Clima Dinâmico, Meta-Upgrades, Cash-Sink (Contratos Pré-Run)
-- e Painel Sandbox GM (!dungeon gm).
-- ====================================================================

PokeDungeon = {
    -- Storages Principais
    STORAGE_ACTIVE      = 95000, -- 1 se estiver na dungeon (lobby ou arena)
    STORAGE_POKEVIEW    = 95001, -- 1 se modo PokeView ativo (na arena)
    STORAGE_POKENAME    = 95002, -- Nome do pokemon PokeView escolhido
    STORAGE_FLOOR       = 95003, -- Andar atual (1..6)
    STORAGE_KILLS       = 95004, -- Monstros mortos no andar atual
    STORAGE_TARGET      = 95005, -- Meta de monstros do andar
    STORAGE_MAX_FLOOR   = 95006, -- Maior andar desbloqueado
    STORAGE_TOTAL_KILLS = 95007, -- Total geral de kills

    -- Storages de Buffs Temporários (30 segundos)
    STORAGE_BUFF_HP  = 95010,
    STORAGE_BUFF_DEF = 95011,
    STORAGE_BUFF_ATK = 95012,
    STORAGE_BUFF_SPD = 95013,
    STORAGE_BUFF_CD  = 95014,

    -- Storages da Partida (Run Level, In-Run EXP e Traits)
    STORAGE_RUN_EXP       = 95020, -- Run EXP acumulada
    STORAGE_RUN_LEVEL     = 95021, -- Run Level (começa em 1)
    STORAGE_TRAIT_VIGOR   = 95030, -- Níveis de Vigor (+25% Max HP e cura)
    STORAGE_TRAIT_ATK     = 95031, -- Níveis de Potência (+20% Dano geral)
    STORAGE_TRAIT_DEF     = 95032, -- Níveis de Carapaça (+15% Redução de dano)
    STORAGE_TRAIT_SPEED   = 95033, -- Níveis de Agilidade (+35 Velocidade)
    STORAGE_TRAIT_REGEN   = 95034, -- Níveis de Regeneração (+12 HP/s)
    STORAGE_TRAIT_CD      = 95035, -- Níveis de Aceleração (-15% Cooldown)
    STORAGE_TRAIT_MAGNET  = 95036, -- Níveis de Ímã Magnético (+2 SQMs raio de coleta)
    STORAGE_TRAIT_CRIT    = 95037, -- Níveis de Foco Crítico (+8% Chance Crítica)

    -- Storages de Meta-Progressão Permanente (Lobby / Kecleon Upgrades)
    STORAGE_META_HP       = 95040, -- Vitalidade Eterna (+12% HP inicial por nv, máx 5)
    STORAGE_META_ATK      = 95041, -- Força Bruta (+10% Dano inicial por nv, máx 5)
    STORAGE_META_SPEED    = 95042, -- Passos Leves (+15 Speed inicial por nv, máx 5)
    STORAGE_META_EXP      = 95043, -- Sabedoria Ancestral (+15% EXP por nv, máx 5)
    STORAGE_META_REROLL   = 95044, -- Dados do Destino (+1 Reroll por run por nv, máx 5)
    STORAGE_META_MOVES    = 95045, -- Repertório Inicial (Nv 1 = Começa com 2 golpes)
    STORAGE_SHINY_SKIN    = 95046, -- 1 = Usa Skin Shiny no Pokémon Inicial
    STORAGE_GOD_MODE      = 95047, -- 1 = Modo Invulnerável (GM / Sandbox)

    -- Storages de Cash-Sink: Contratos de Expedição Consumíveis (Valem por 1 Partida / 1 Run)
    STORAGE_BOOST_VANGUARD  = 95048, -- 1 = Contrato de Vanguarda (+1 Golpe Extra na largada + Escudo 30s)
    STORAGE_BOOST_COLLECTOR = 95049, -- 1 = Contrato do Colecionador (Ímã Nv.2 na largada + 25% EXP na Run)
    STORAGE_BOOST_SHINY     = 95050, -- 1 = Contrato do Caçador (2x Chance Shiny + 2 Baús Extras + 2 Rerolls)
    STORAGE_PXG_KIT_GIVEN   = 95051, -- 1 = Já recebeu o Kit Mestre de Mundo Aberto fora da dungeon

    -- IDs de Modal Windows
    MODAL_CHOOSE_POKE = 9540, -- Janela de Seleção do Pokémon Inicial
    MODAL_UPGRADES    = 9545, -- Janela de Melhorias Permanentes, Contratos (Cash-Sink) & Skin Shiny
    MODAL_LEVELUP     = 9550, -- Janela de Escolha de Trait por Nível
    MODAL_DEMO        = 9560, -- Painel de Controle GM / Sandbox (!dungeon gm)

    -- Catálogo Completo de Golpes por Elemento (17 Tipos Elementais)
    TYPE_MOVES = {
        ["fire"] = {
            "ember", "flamethrower", "fireball", "fire blast", "fire spin", "flame wheel", "magma storm"
        },
        ["water"] = {
            "water gun", "water pulse", "bubble", "hydro pump", "surf", "muddy water"
        },
        ["grass"] = {
            "vine whip", "razor leaf", "magical leaf", "solar beam", "leaf storm", "petal dance"
        },
        ["electric"] = {
            "thunder shock", "spark", "thunder bolt", "thunder", "shock wave"
        },
        ["psychic"] = {
            "confusion", "psybeam", "psychic", "psyshock", "cosmic power", "future sight"
        },
        ["poison"] = {
            "poison sting", "acid", "sludge", "sludge bomb", "poison gas", "sludge wave"
        },
        ["ground"] = {
            "mud shot", "bonemerang", "bulldoze", "earthquake", "earth power"
        },
        ["rock"] = {
            "rock throw", "rollout", "rock slide", "ancient power", "stone edge"
        },
        ["bug"] = {
            "bug bite", "pin missile", "fury cutter", "silver wind", "bug buzz", "signal beam"
        },
        ["flying"] = {
            "gust", "wing attack", "air cutter", "air slash", "hurricane"
        },
        ["ice"] = {
            "powder snow", "ice shard", "icy wind", "ice beam", "blizzard"
        },
        ["fighting"] = {
            "mach punch", "double kick", "cross chop", "brick break", "dynamic punch"
        },
        ["ghost"] = {
            "lick", "shadow punch", "shadow ball", "night shade", "confuse ray"
        },
        ["dragon"] = {
            "twister", "dragon breath", "dragon claw", "dragon rage", "draco meteor"
        },
        ["steel"] = {
            "metal claw", "iron tail", "gyro ball", "iron head", "doom desire"
        },
        ["dark"] = {
            "bite", "feint attack", "night slash", "crunch", "dark pulse"
        },
        ["normal"] = {
            "tackle", "quick attack", "swift", "slash", "body slam", "hyper beam"
        }
    },

    -- Metadados de Arquétipos de Combate e Evolução Dourada (Golpe Nv. 5 -> Golpe+)
    -- kinds: projectile, cone, beam, orbit, chain, boomerang, nova, trail, meteor, aura
    MOVE_EVOLUTIONS = {
        -- FIRE
        ["ember"]          = { evoName = "Inferno Ember+",      kind = "projectile", combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_FIREAREA,       missile = CONST_ANI_FIRE,           desc = "[Projetil] Dano x1.85 + Rajada Tripla Incendiaria!" },
        ["flamethrower"]   = { evoName = "Blue Flamethrower+",  kind = "cone",       combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_HITBYFIRE,      missile = CONST_ANI_FIRE,           desc = "[Cone] Dano x1.85 + Cone de Fogo Purificador!" },
        ["fireball"]       = { evoName = "Meteor Fireball+",    kind = "projectile", combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_EXPLOSIONAREA,  missile = CONST_ANI_FIRE,           desc = "[Explosao] Dano x1.85 + Explosao Dupla de Magma!" },
        ["fire blast"]     = { evoName = "Daiji Fire Blast+",   kind = "nova",       combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_FIREAREA,       missile = CONST_ANI_FIRE,           desc = "[Nova] Dano x1.85 + Cruz de Fogo em 8 Direcoes!" },
        ["fire spin"]      = { evoName = "Vortex Fire Spin+",   kind = "orbit",      combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_FIREAREA,       missile = CONST_ANI_FIRE,           desc = "[Orbital] Dano x1.85 + Anel de Fogo Giratorio!" },
        ["flame wheel"]    = { evoName = "Blazing Trail+",      kind = "trail",      combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_FIREAREA,       missile = CONST_ANI_FIRE,           desc = "[Rastro] Dano x1.85 + Trilha Flamejante no Chao!" },
        ["magma storm"]    = { evoName = "Cataclysm Magma+",    kind = "meteor",     combat = COMBAT_FIREDAMAGE,     effect = CONST_ME_EXPLOSIONAREA,  missile = CONST_ANI_FIRE,           desc = "[Meteoro] Dano x1.85 + Chuva de Rochas Vulcanicas!" },

        -- WATER
        ["water gun"]      = { evoName = "Hydro Cannon+",       kind = "beam",       combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_LOSEENERGY,     missile = CONST_ANI_ICE,            desc = "[Feixe] Dano x1.85 + Jato Pressurizado Perfurante!" },
        ["water pulse"]    = { evoName = "Tsunami Pulse+",      kind = "aura",       combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_WATERSPLASH,    missile = CONST_ANI_ICE,            desc = "[Aura] Dano x1.85 + Ondas de Choque Aquaticas 360!" },
        ["bubble"]         = { evoName = "Bubble Barrage+",     kind = "projectile", combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_LOSEENERGY,     missile = CONST_ANI_ICE,            desc = "[Leque] Dano x1.85 + Chuva de Bolhas Explosivas!" },
        ["hydro pump"]     = { evoName = "Maelstrom Pump+",     kind = "beam",       combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_WATERSPLASH,    missile = CONST_ANI_ICE,            desc = "[Feixe] Dano x1.85 + Diluvio Abissal em Linha!" },
        ["surf"]           = { evoName = "Tidal Wave Surf+",    kind = "nova",       combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_WATERSPLASH,    missile = CONST_ANI_ICE,            desc = "[Nova] Dano x1.85 + Maremoto Radial em 8 Direcoes!" },
        ["muddy water"]    = { evoName = "Abyssal Mire+",       kind = "trail",      combat = COMBAT_WATERDAMAGE,    effect = CONST_ME_WATERSPLASH,    missile = CONST_ANI_SMALLEARTH,     desc = "[Rastro] Dano x1.85 + Pocas de Lama Corrosiva!" },

        -- GRASS
        ["vine whip"]      = { evoName = "Frenzy Plant+",       kind = "cone",       combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_EARTH,          desc = "[Chicote] Dano x1.85 + Raizes Espinhosas em Cone!" },
        ["razor leaf"]     = { evoName = "Boomerang Leaf+",     kind = "boomerang",  combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_SMALLEARTH,     desc = "[Bumerangue] Dano x1.85 + Folhas que Vao e Voltam!" },
        ["magical leaf"]   = { evoName = "Sylvan Orbit+",       kind = "orbit",      combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_EARTH,          desc = "[Orbital] Dano x1.85 + Escudo Giratorio de Folhas!" },
        ["solar beam"]     = { evoName = "Solar Oblivion+",     kind = "beam",       combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_HOLYAREA,       missile = CONST_ANI_HOLY,           desc = "[Feixe] Dano x1.85 + Raio Solar Perfurante!" },
        ["leaf storm"]     = { evoName = "Gaia Hurricane+",     kind = "nova",       combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_EARTH,          desc = "[Nova] Dano x1.85 + Furacao Botanico em 8 Direcoes!" },
        ["petal dance"]    = { evoName = "Blossom Aura+",       kind = "aura",       combat = COMBAT_GRASSDAMAGE,    effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_SMALLEARTH,     desc = "[Aura] Dano x1.85 + Redemoinho de Petalas Curativas!" },

        -- ELECTRIC
        ["thunder shock"]  = { evoName = "Volt Chain+",         kind = "chain",      combat = COMBAT_ELECTRICDAMAGE, effect = CONST_ME_ENERGYHIT,      missile = CONST_ANI_ENERGY,         desc = "[Cadeia] Dano x1.85 + Raio que Ricocheteia em 5 Alvos!" },
        ["spark"]          = { evoName = "Plasma Orbit+",       kind = "orbit",      combat = COMBAT_ELECTRICDAMAGE, effect = CONST_ME_ENERGYAREA,     missile = CONST_ANI_ENERGYBALL,     desc = "[Orbital] Dano x1.85 + Esferas Eletricas Orbitais!" },
        ["thunder bolt"]   = { evoName = "Overdrive Bolt+",     kind = "projectile", combat = COMBAT_ELECTRICDAMAGE, effect = CONST_ME_ENERGYHIT,      missile = CONST_ANI_ENERGY,         desc = "[Projetil] Dano x1.85 + Raios Duplos Perfurantes!" },
        ["thunder"]        = { evoName = "Judgment Thunder+",   kind = "meteor",     combat = COMBAT_ELECTRICDAMAGE, effect = CONST_ME_BIGCLOUDS,      missile = CONST_ANI_ENERGY,         desc = "[Tempestade] Dano x1.85 + Trovoes Celestiais em Area!" },
        ["shock wave"]     = { evoName = "Tesla Nova+",         kind = "nova",       combat = COMBAT_ELECTRICDAMAGE, effect = CONST_ME_ENERGYAREA,     missile = CONST_ANI_ENERGY,         desc = "[Nova] Dano x1.85 + Pulso Eletromagnetico 360!" },

        -- PSYCHIC
        ["confusion"]      = { evoName = "Mind Break+",         kind = "aura",       combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_MAGIC_BLUE,     missile = CONST_ANI_ENERGYBALL,     desc = "[Aura] Dano x1.85 + Onda Telecinetica Expansiva!" },
        ["psybeam"]        = { evoName = "Prismatic Laser+",    kind = "beam",       combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_MAGIC_RED,      missile = CONST_ANI_ENERGY,         desc = "[Feixe] Dano x1.85 + Laser Psiquico Perfurante!" },
        ["psychic"]        = { evoName = "Psystrike Nova+",     kind = "nova",       combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_MAGIC_BLUE,     missile = CONST_ANI_ENERGYBALL,     desc = "[Nova] Dano x1.85 + Colapso Gravitacional 360!" },
        ["psyshock"]       = { evoName = "Synapse Chain+",      kind = "chain",      combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_MAGIC_RED,      missile = CONST_ANI_ENERGYBALL,     desc = "[Cadeia] Dano x1.85 + Choque Mental Ricocheteante!" },
        ["cosmic power"]   = { evoName = "Astral Ring+",        kind = "orbit",      combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_MAGIC_BLUE,     missile = CONST_ANI_ENERGYBALL,     desc = "[Orbital] Dano x1.85 + Orbes Astrais Giratorios!" },
        ["future sight"]   = { evoName = "Oracle Doom+",        kind = "meteor",     combat = COMBAT_PSYCHICDAMAGE,  effect = CONST_ME_HOLYAREA,       missile = CONST_ANI_HOLY,           desc = "[Meteoro] Dano x1.85 + Impactos Profeticos do Ceu!" },

        -- POISON
        ["poison sting"]   = { evoName = "Venom Volley+",       kind = "projectile", combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_GREEN_RINGS,    missile = CONST_ANI_POISON,         desc = "[Projetil] Dano x1.85 + Dardos Venenosos Multiplos!" },
        ["acid"]           = { evoName = "Corrosive Trail+",    kind = "trail",      combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_HITBYPOISON,    missile = CONST_ANI_POISON,         desc = "[Rastro] Dano x1.85 + Trilha de Acido Derretedor!" },
        ["sludge"]         = { evoName = "Biohazard Sludge+",   kind = "projectile", combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_HITBYPOISON,    missile = CONST_ANI_POISON,         desc = "[Projetil] Dano x1.85 + Lodo Toxico Explosivo!" },
        ["sludge bomb"]    = { evoName = "Plague Mortar+",      kind = "meteor",     combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_GREEN_RINGS,    missile = CONST_ANI_POISON,         desc = "[Morteiro] Dano x1.85 + Bombas Toxicas em Area!" },
        ["poison gas"]     = { evoName = "Miasma Cloud+",       kind = "aura",       combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_GREEN_RINGS,    missile = CONST_ANI_POISON,         desc = "[Aura] Dano x1.85 + Nuvem Venenosa Persistente!" },
        ["sludge wave"]    = { evoName = "Toxic Tsunami+",      kind = "nova",       combat = COMBAT_POISONDAMAGE,   effect = CONST_ME_HITBYPOISON,    missile = CONST_ANI_POISON,         desc = "[Nova] Dano x1.85 + Onda Venenosa em 8 Direcoes!" },

        -- GROUND
        ["mud shot"]       = { evoName = "Quicksand Barrage+",  kind = "projectile", combat = COMBAT_GROUNDDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_SMALLEARTH,     desc = "[Projetil] Dano x1.85 + Disparo Triplo de Argila!" },
        ["bonemerang"]     = { evoName = "Marowak Boomerang+",  kind = "boomerang",  combat = COMBAT_GROUNDDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_THROWINGKNIFE,  desc = "[Bumerangue] Dano x1.85 + Osso que Vai e Volta 2x!" },
        ["bulldoze"]       = { evoName = "Tectonic Crush+",     kind = "aura",       combat = COMBAT_GROUNDDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_LARGEROCK,      desc = "[Aura] Dano x1.85 + Tremor Sismico ao Redor!" },
        ["earthquake"]     = { evoName = "Cataclysm Quake+",    kind = "nova",       combat = COMBAT_GROUNDDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_LARGEROCK,      desc = "[Nova] Dano x1.85 + Terremoto Devastador 360!" },
        ["earth power"]    = { evoName = "Groudon Eruption+",   kind = "meteor",     combat = COMBAT_GROUNDDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_LARGEROCK,      desc = "[Erupcao] Dano x1.85 + Pilares Teluricos nos Alvos!" },

        -- ROCK
        ["rock throw"]     = { evoName = "Boulder Hurl+",       kind = "projectile", combat = COMBAT_ROCKDAMAGE,     effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_SMALLSTONE,     desc = "[Projetil] Dano x1.85 + Arremesso de Pedregulhos!" },
        ["rollout"]        = { evoName = "Asteroid Orbit+",     kind = "orbit",      combat = COMBAT_ROCKDAMAGE,     effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_LARGEROCK,      desc = "[Orbital] Dano x1.85 + Rochas Giratorias ao Redor!" },
        ["rock slide"]     = { evoName = "Avalanche Slide+",    kind = "meteor",     combat = COMBAT_ROCKDAMAGE,     effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_LARGEROCK,      desc = "[Meteoro] Dano x1.85 + Deslizamento de Rochas!" },
        ["ancient power"]  = { evoName = "Fossil Ricochet+",    kind = "chain",      combat = COMBAT_ROCKDAMAGE,     effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_SMALLSTONE,     desc = "[Cadeia] Dano x1.85 + Rochas Ancestrais em Cadeia!" },
        ["stone edge"]     = { evoName = "Diamond Storm+",      kind = "nova",       combat = COMBAT_ROCKDAMAGE,     effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_SMALLSTONE,     desc = "[Nova] Dano x1.85 + Estilhacos de Rocha em 8 Direcoes!" },

        -- BUG
        ["bug bite"]       = { evoName = "Predator Mandible+",  kind = "projectile", combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_SMALLPLANTS,    missile = CONST_ANI_POISON,         desc = "[Projetil] Dano x1.85 + Mordida Voraz Drenante!" },
        ["pin missile"]    = { evoName = "Stinger Barrage+",    kind = "projectile", combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_HITAREA,        missile = CONST_ANI_SPEAR,          desc = "[Rajada] Dano x1.85 + Chuva de Espinhos Perfurantes!" },
        ["fury cutter"]    = { evoName = "Scyther Boomerang+",  kind = "boomerang",  combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_HITAREA,        missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Bumerangue] Dano x1.85 + Foices que Vao e Voltam!" },
        ["silver wind"]    = { evoName = "Monarch Gale+",       kind = "orbit",      combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_SOUND_WHITE,    missile = CONST_ANI_ENERGY,         desc = "[Orbital] Dano x1.85 + Vento Prateado Giratorio!" },
        ["bug buzz"]       = { evoName = "Ultrasonic Buzz+",    kind = "aura",       combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_SOUND_GREEN,    missile = CONST_ANI_ENERGY,         desc = "[Aura] Dano x1.85 + Ressonancia Sonica em Area!" },
        ["signal beam"]    = { evoName = "Spectrum Laser+",     kind = "beam",       combat = COMBAT_BUGDAMAGE,      effect = CONST_ME_MAGIC_GREEN,    missile = CONST_ANI_GREENSTAR,      desc = "[Feixe] Dano x1.85 + Raio Luminoso Multicolorido!" },

        -- FLYING
        ["gust"]           = { evoName = "Tornado Gust+",       kind = "projectile", combat = COMBAT_FLYINGDAMAGE,   effect = CONST_ME_POFF,           missile = CONST_ANI_THROWINGKNIFE,  desc = "[Projetil] Dano x1.85 + Tornados Cortantes!" },
        ["wing attack"]    = { evoName = "Brave Bird Gale+",    kind = "cone",       combat = COMBAT_FLYINGDAMAGE,   effect = CONST_ME_POFF,           missile = CONST_ANI_THROWINGKNIFE,  desc = "[Cone] Dano x1.85 + Vendaval Cortante Frontal!" },
        ["air cutter"]     = { evoName = "Zephyr Boomerang+",   kind = "boomerang",  combat = COMBAT_FLYINGDAMAGE,   effect = CONST_ME_SOUND_WHITE,    missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Bumerangue] Dano x1.85 + Laminas de Vento Duplas!" },
        ["air slash"]      = { evoName = "Sky Ricochet+",       kind = "chain",      combat = COMBAT_FLYINGDAMAGE,   effect = CONST_ME_HITAREA,        missile = CONST_ANI_THROWINGKNIFE,  desc = "[Cadeia] Dano x1.85 + Cortes Aereos em Cadeia!" },
        ["hurricane"]      = { evoName = "Lugia Tempest+",      kind = "orbit",      combat = COMBAT_FLYINGDAMAGE,   effect = CONST_ME_SOUND_WHITE,    missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Orbital] Dano x1.85 + Ciclone Protetor Giratorio!" },

        -- ICE
        ["powder snow"]    = { evoName = "Frostbite Mist+",     kind = "cone",       combat = COMBAT_ICEDAMAGE,      effect = CONST_ME_ICEAREA,        missile = CONST_ANI_ICE,            desc = "[Cone] Dano x1.85 + Sopro Glacial Congelante!" },
        ["ice shard"]      = { evoName = "Icicle Spear+",       kind = "projectile", combat = COMBAT_ICEDAMAGE,      effect = CONST_ME_ICEATTACK,      missile = CONST_ANI_ICE,            desc = "[Projetil] Dano x1.85 + Estalactites Perfurantes!" },
        ["icy wind"]       = { evoName = "Zero Aura+",          kind = "aura",       combat = COMBAT_ICEDAMAGE,      effect = CONST_ME_ICEAREA,        missile = CONST_ANI_ICE,            desc = "[Aura] Dano x1.85 + Vento Polar Congelante 360!" },
        ["ice beam"]       = { evoName = "Sheer Cold Beam+",    kind = "beam",       combat = COMBAT_ICEDAMAGE,      effect = CONST_ME_ICEAREA,        missile = CONST_ANI_ICE,            desc = "[Feixe] Dano x1.85 + Raio Zero Absoluto!" },
        ["blizzard"]       = { evoName = "Articuno Blizzard+",  kind = "meteor",     combat = COMBAT_ICEDAMAGE,      effect = CONST_ME_ICEATTACK,      missile = CONST_ANI_ICE,            desc = "[Tempestade] Dano x1.85 + Nevasca Cataclismica!" },

        -- FIGHTING
        ["mach punch"]     = { evoName = "Bullet Aura Punch+",  kind = "projectile", combat = COMBAT_FIGHTINGDAMAGE, effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Projetil] Dano x1.85 + Punhos Sonicos Multi-Impacto!" },
        ["double kick"]    = { evoName = "Triple Axel Kick+",   kind = "chain",      combat = COMBAT_FIGHTINGDAMAGE, effect = CONST_ME_HITAREA,        missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Cadeia] Dano x1.85 + Chutes Marciais em Cadeia!" },
        ["cross chop"]     = { evoName = "Close Combat+",       kind = "cone",       combat = COMBAT_FIGHTINGDAMAGE, effect = CONST_ME_HITAREA,        missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Cone] Dano x1.85 + Golpe Cruzado Demolidor!" },
        ["brick break"]    = { evoName = "Shatter Impact+",     kind = "aura",       combat = COMBAT_FIGHTINGDAMAGE, effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_SMALLSTONE,     desc = "[Aura] Dano x1.85 + Quebra-Barreiras em Area!" },
        ["dynamic punch"]  = { evoName = "Aura Sphere Nova+",   kind = "nova",       combat = COMBAT_FIGHTINGDAMAGE, effect = CONST_ME_EXPLOSIONHIT,   missile = CONST_ANI_ENERGYBALL,     desc = "[Nova] Dano x1.85 + Esferas de Aura em 8 Direcoes!" },

        -- GHOST
        ["lick"]           = { evoName = "Phantom Lick+",       kind = "aura",       combat = COMBAT_GHOSTDAMAGE,    effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Aura] Dano x1.85 + Toque Espectral Drenante!" },
        ["shadow punch"]   = { evoName = "Spectral Chain+",     kind = "chain",      combat = COMBAT_GHOSTDAMAGE,    effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Cadeia] Dano x1.85 + Punhos das Sombras em Cadeia!" },
        ["shadow ball"]    = { evoName = "Dark Void Ball+",     kind = "projectile", combat = COMBAT_GHOSTDAMAGE,    effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Projetil] Dano x1.85 + Esferas Sombrias Triplas!" },
        ["night shade"]    = { evoName = "Nightmare Nova+",     kind = "nova",       combat = COMBAT_GHOSTDAMAGE,    effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Nova] Dano x1.85 + Explosao Abissal Noturna 360!" },
        ["confuse ray"]    = { evoName = "Wisp Orbit+",         kind = "orbit",      combat = COMBAT_GHOSTDAMAGE,    effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Orbital] Dano x1.85 + Fogos-Fatuos Espirituais!" },

        -- DRAGON
        ["twister"]        = { evoName = "Dragon Hurricane+",   kind = "orbit",      combat = COMBAT_DRAGONDAMAGE,   effect = CONST_ME_DRAGONBREATH,   missile = CONST_ANI_ENERGY,         desc = "[Orbital] Dano x1.85 + Tornados Draconicos Orbitais!" },
        ["dragon breath"]  = { evoName = "Soul Roar Breath+",   kind = "cone",       combat = COMBAT_DRAGONDAMAGE,   effect = CONST_ME_DRAGONBREATH,   missile = CONST_ANI_FIRE,           desc = "[Cone] Dano x1.85 + Baforada Imperial em Area!" },
        ["dragon claw"]    = { evoName = "Outrage Claw+",       kind = "cone",       combat = COMBAT_DRAGONDAMAGE,   effect = CONST_ME_DRAGONBREATH,   missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Cone] Dano x1.85 + Garras Draconicas Freneticas!" },
        ["dragon rage"]    = { evoName = "Dragon Pulse+",       kind = "projectile", combat = COMBAT_DRAGONDAMAGE,   effect = CONST_ME_DRAGONBREATH,   missile = CONST_ANI_ENERGYBALL,     desc = "[Projetil] Dano x1.85 + Esfera de Furia Ancestral!" },
        ["draco meteor"]   = { evoName = "Apocalypse Meteor+",  kind = "meteor",     combat = COMBAT_DRAGONDAMAGE,   effect = CONST_ME_EXPLOSIONAREA,  missile = CONST_ANI_FIRE,           desc = "[Meteoro] Dano x1.85 + Chuva Cataclismica de Meteoros!" },

        -- STEEL
        ["metal claw"]     = { evoName = "Adamant Slash+",      kind = "cone",       combat = COMBAT_STEELDAMAGE,    effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Cone] Dano x1.85 + Garras de Titânio Cortantes!" },
        ["iron tail"]      = { evoName = "Meteor Mash Sweep+",  kind = "aura",       combat = COMBAT_STEELDAMAGE,    effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Aura] Dano x1.85 + Giro Metalico Demolidor!" },
        ["gyro ball"]      = { evoName = "Aegis Gyro Orbit+",   kind = "orbit",      combat = COMBAT_STEELDAMAGE,    effect = CONST_ME_BLOCKHIT,       missile = CONST_ANI_WHIRLWINDCLUB,  desc = "[Orbital] Dano x1.85 + Esferas de Aco Orbitais!" },
        ["iron head"]      = { evoName = "Flash Cannon+",       kind = "projectile", combat = COMBAT_STEELDAMAGE,    effect = CONST_ME_ENERGYHIT,      missile = CONST_ANI_THROWINGKNIFE,  desc = "[Projetil] Dano x1.85 + Impacto Blindado Perfurante!" },
        ["doom desire"]    = { evoName = "Jirachi Judgment+",   kind = "meteor",     combat = COMBAT_STEELDAMAGE,    effect = CONST_ME_HOLYAREA,       missile = CONST_ANI_HOLY,           desc = "[Meteoro] Dano x1.85 + Feixes Celestiais de Aco!" },

        -- DARK
        ["bite"]           = { evoName = "Savage Fang+",        kind = "aura",       combat = COMBAT_DARKDAMAGE,     effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Aura] Dano x1.85 + Presas Sombrias Vorazes!" },
        ["feint attack"]   = { evoName = "Shadow Ambush+",      kind = "chain",      combat = COMBAT_DARKDAMAGE,     effect = CONST_ME_MORTAREA,       missile = CONST_ANI_THROWINGKNIFE,  desc = "[Cadeia] Dano x1.85 + Ataque Furtivo em Cadeia!" },
        ["night slash"]    = { evoName = "Crescent Boomerang+", kind = "boomerang",  combat = COMBAT_DARKDAMAGE,     effect = CONST_ME_MORTAREA,       missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Bumerangue] Dano x1.85 + Laminas Noturnas de Ida e Volta!" },
        ["crunch"]         = { evoName = "Abyssal Crunch+",     kind = "cone",       combat = COMBAT_DARKDAMAGE,     effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Cone] Dano x1.85 + Trituracao Sombria em Area!" },
        ["dark pulse"]     = { evoName = "Darkrai Eclipse+",    kind = "nova",       combat = COMBAT_DARKDAMAGE,     effect = CONST_ME_MORTAREA,       missile = CONST_ANI_SUDDENDEATH,    desc = "[Nova] Dano x1.85 + Onda de Eclipse em 8 Direcoes!" },

        -- NORMAL
        ["tackle"]         = { evoName = "Giga Impact+",        kind = "projectile", combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_HITAREA,        missile = CONST_ANI_SMALLSTONE,     desc = "[Projetil] Dano x1.85 + Investida Colossal!" },
        ["quick attack"]   = { evoName = "Extreme Speed+",      kind = "chain",      combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_HITAREA,        missile = CONST_ANI_THROWINGKNIFE,  desc = "[Cadeia] Dano x1.85 + Velocidade Extrema em Cadeia!" },
        ["swift"]          = { evoName = "Starlight Orbit+",    kind = "orbit",      combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_FIREWORK_YELLOW,missile = CONST_ANI_REDSTAR,        desc = "[Orbital] Dano x1.85 + Estrelas Cadentes Orbitais!" },
        ["slash"]          = { evoName = "Guillotine Slash+",   kind = "cone",       combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_HITAREA,        missile = CONST_ANI_WHIRLWINDSWORD, desc = "[Cone] Dano x1.85 + Corte Critico Frontal!" },
        ["body slam"]      = { evoName = "Snorlax Slam+",       kind = "aura",       combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_GROUNDSHAKER,   missile = CONST_ANI_LARGEROCK,      desc = "[Aura] Dano x1.85 + Impacto Corporal Sismico!" },
        ["hyper beam"]     = { evoName = "Eternabeam+",         kind = "beam",       combat = COMBAT_NORMALDAMAGE,   effect = CONST_ME_ENERGYAREA,     missile = CONST_ANI_HOLY,           desc = "[Feixe] Dano x1.85 + Feixe Supremo Aniquilador!" }
    },

    -- Arquétipos Comportamentais de Inimigos Selvagens
    ENEMY_BEHAVIORS = {
        -- Bombers: Explodem em área (3x3) ao morrer, causando dano colateral na horda!
        bombers = {
            ["Voltorb"] = true, ["Electrode"] = true, ["Koffing"] = true, ["Weezing"] = true,
            ["Geodude"] = true, ["Graveler"] = true, ["Golem"] = true, ["Pineco"] = true, ["Forretress"] = true
        },
        -- Healers: Curam periodicamente os monstros selvagens próximos!
        healers = {
            ["Chansey"] = true, ["Blissey"] = true, ["Clefairy"] = true, ["Clefable"] = true,
            ["Jigglypuff"] = true, ["Wigglytuff"] = true, ["Oddish"] = true, ["Gloom"] = true, ["Bellossom"] = true
        }
    },

    -- Catálogo de Held Items Passivos da Run
    HELD_ITEMS = {
        ["leftovers"] = {
            id = "leftovers",
            title = "🍎 Held Item: Leftovers (Sobras)",
            shortName = "Leftovers",
            desc = "Regenera 4% do HP Maximo por segundo continuamente."
        },
        ["life_orb"] = {
            id = "life_orb",
            title = "🔮 Held Item: Life Orb (Orbe da Vida)",
            shortName = "Life Orb",
            desc = "Multiplica todo o dano dos seus golpes em +35%."
        },
        ["focus_sash"] = {
            id = "focus_sash",
            title = "🎗️ Held Item: Focus Sash (Faixa de Foco)",
            shortName = "Focus Sash",
            desc = "Impede a morte 1x por andar, curando 50% HP e explodindo inimigos."
        },
        ["rocky_helmet"] = {
            id = "rocky_helmet",
            title = "🪖 Held Item: Rocky Helmet (Capacete Rochoso)",
            shortName = "Rocky Helmet",
            desc = "Reflete dano em area (3x3) sempre que voce sofre um ataque."
        },
        ["shell_bell"] = {
            id = "shell_bell",
            title = "🔔 Held Item: Shell Bell (Sino Concha)",
            shortName = "Shell Bell",
            desc = "Converte 8% do dano causado em cura imediata (Lifesteal)."
        },
        ["lucky_egg"] = {
            id = "lucky_egg",
            title = "🥚 Held Item: Lucky Egg (Ovo da Sorte)",
            shortName = "Lucky Egg",
            desc = "Aumenta toda a EXP obtida de gemas e baus em +40%."
        }
    },

    -- Climas Dinâmicos da Arena
    WEATHERS = {
        ["clear"] = {
            name = "Ceu Limpo",
            boostTypes = {},
            effect = CONST_ME_NONE,
            desc = "Condicoes normais de batalha."
        },
        ["sun"] = {
            name = "Sol Abrasador",
            boostTypes = {"fire", "grass", "ground"},
            effect = CONST_ME_HITBYFIRE,
            desc = "Golpes de Fogo, Planta e Terra causam +25% de dano!"
        },
        ["rain"] = {
            name = "Chuva Torrencial",
            boostTypes = {"water", "electric", "bug"},
            effect = CONST_ME_LOSEENERGY,
            desc = "Golpes de Agua, Eletrico e Inseto causam +25% de dano!"
        },
        ["sandstorm"] = {
            name = "Tempestade de Areia",
            boostTypes = {"rock", "ground", "fighting", "steel"},
            effect = CONST_ME_POFF,
            desc = "Golpes Lutador, Terra, Pedra e Aco causam +25% de dano!"
        },
        ["hail"] = {
            name = "Nevasca Congelante",
            boostTypes = {"ice", "water", "flying"},
            effect = CONST_ME_ICEATTACK,
            desc = "Golpes de Gelo, Agua e Voador causam +25% de dano!"
        },
        ["fog"] = {
            name = "Nevoa Sombria",
            boostTypes = {"ghost", "psychic", "dragon", "dark", "poison"},
            effect = CONST_ME_MORTAREA,
            desc = "Golpes Fantasma, Sombrio, Veneno, Psiquico e Dragao causam +25% de dano!"
        }
    },

    -- Configurações de Coordenadas, Andares e Biomas Gráficos
    config = {
        lobbyPos = Position(1805, 2255, 7),
        arenaPos = Position(1840, 2270, 7),
        arenaArea = {
            from = Position(1820, 2250, 7),
            to   = Position(1860, 2290, 7)
        },
        templePos = Position(1054, 1050, 7),
        cpPortalPos = Position(1052, 1050, 7), -- Estação do Portal dentro do Centro Pokémon de Saffron (2 SQMs a Oeste do Spawn)

        buffDuration = 30,
        buffDropChance = 25,

        -- Posições dos Objetos Interativos na Arena
        altars = {
            { pos = Position(1827, 2257, 7), buff = "ataque",     label = "Altar da Furia (+60% Dano)" },
            { pos = Position(1853, 2257, 7), buff = "cooldown",   label = "Altar do Tempo (-50% Cooldown)" },
            { pos = Position(1827, 2283, 7), buff = "velocidade", label = "Altar do Vento (Super Speed)" },
            { pos = Position(1853, 2283, 7), buff = "defesa",     label = "Altar da Rocha (-50% Dano)" }
        },
        springs = {
            { pos = Position(1833, 2270, 7), label = "Manancial da Vida" },
            { pos = Position(1847, 2270, 7), label = "Manancial da Vida" }
        },

        -- 6 Andares com Biomas Procedurais Gráficos
        floors = {
            [1] = {
                targetKills = 25,
                level = 1,
                monsters = {"Rattata", "Caterpie", "Pidgey", "Weedle", "Oddish", "Zubat", "Clefairy"},
                midBoss = "Pidgeotto",
                floorBoss = "Fearow",
                weather = "clear",
                monsterHp = 70,
                spawnInterval = 1800,
                spawnAmount = 2,
                maxMonsters = 12,
                name = "Andar 1: Bosque Umbrio (Floresta Viva)",
                biome = "grassland",
                floorId = 4526,
                wallId = 1049,
                desc = "Clareira florestal com arbustos cortaveis (dropam Berries) e enxames iniciais."
            },
            [2] = {
                targetKills = 50,
                level = 15,
                monsters = {"Geodude", "Zubat", "Ekans", "Mankey", "Sandshrew", "Machop", "Voltorb", "Koffing"},
                midBoss = "Onix",
                floorBoss = "Rhydon",
                weather = "sandstorm",
                monsterHp = 150,
                spawnInterval = 1700,
                spawnAmount = 3,
                maxMonsters = 16,
                name = "Andar 2: Cueva Cristal (Mina Subterranea)",
                biome = "cave",
                floorId = 4554,
                wallId = 1049,
                desc = "Caverna de cristais brilhantes, rochas destrutiveis e inimigos explosivos."
            },
            [3] = {
                targetKills = 90,
                level = 35,
                monsters = {"Gastly", "Haunter", "Kadabra", "Golbat", "Weezing", "Graveler", "Arbok", "Chansey"},
                midBoss = "Haunter",
                floorBoss = "Gengar",
                weather = "fog",
                monsterHp = 290,
                spawnInterval = 1500,
                spawnAmount = 4,
                maxMonsters = 24,
                name = "Andar 3: Cementerio Sombrio (Pantano & Cripta)",
                biome = "ghost",
                floorId = 407,
                wallId = 1049,
                desc = "Cemiterio nebuloso com arvores mortas, gas venenoso, healers e espectros."
            },
            [4] = {
                targetKills = 150,
                level = 60,
                monsters = {"Seel", "Dewgong", "Shellder", "Cloyster", "Jynx", "Sneasel", "Piloswine", "Electrode"},
                midBoss = "Lapras",
                floorBoss = "Articuno",
                weather = "hail",
                monsterHp = 650,
                spawnInterval = 1200,
                spawnAmount = 5,
                maxMonsters = 32,
                name = "Andar 4: Glaciar Eterno (Tundra de Gelo)",
                biome = "ice",
                floorId = 4737,
                wallId = 1049,
                desc = "Campos de neve e patinacao no gelo (Speed Boost!) guardados por Articuno."
            },
            [5] = {
                targetKills = 250,
                level = 85,
                monsters = {"Magmar", "Arcanine", "Houndoom", "Camerupt", "Tyranitar", "Garchomp", "Dragonite", "Golem"},
                midBoss = "Tyranitar",
                floorBoss = "Moltres",
                weather = "sun",
                monsterHp = 1500,
                spawnInterval = 1000,
                spawnAmount = 6,
                maxMonsters = 42,
                name = "Andar 5: Volcan Ceniza (Caldeira de Magma)",
                biome = "volcano",
                floorId = 407,
                wallId = 1049,
                desc = "Cratera vulcanica com pocas de lava borbulhante e pseudo-lendarios brutais."
            },
            [6] = {
                targetKills = 400,
                level = 110,
                monsters = {"Articuno", "Zapdos", "Moltres", "Raikou", "Entei", "Suicune", "Metagross", "Mewtwo"},
                midBoss = "Mewtwo",
                floorBoss = "Arceus",
                weather = "fog",
                monsterHp = 3500,
                spawnInterval = 900,
                spawnAmount = 7,
                maxMonsters = 50,
                name = "Andar 6: Ruinas del Juicio (Santuario de Arceus)",
                biome = "divine",
                floorId = 424,
                wallId = 1049,
                desc = "O templo celestial supremo de marmore branco guardado por Mewtwo e ARCEUS!"
            }
        },

        -- Ordem de Exibição no Menu de Seleção (25 Linhagens Selecionáveis)
        starterOrder = {
            "Charizard", "Blastoise", "Venusaur", "Pikachu",
            "Typhlosion", "Feraligatr", "Meganium",
            "Sceptile", "Blaziken", "Swampert",
            "Torterra", "Infernape", "Empoleon",
            "Gengar", "Alakazam", "Machamp", "Lucario",
            "Gardevoir", "Metagross", "Garchomp", "Dragonite",
            "Golduck", "Slowbro", "Lapras", "Eevee"
        },

        -- Roster Completo de 25 Linhagens Selecionáveis com Evolução In-Run (Nv. 1 -> Nv. 5 -> Nv. 10)
        characters = {
            -- GEN 1 STARTERS
            ["Charizard"] = {
                lookType = 909, hp = 4500, speed = 275,
                types = {"fire", "flying"},
                evolutionChain = {"Charmander", "Charmeleon", "Charizard"},
                startMove = "ember",
                secondMove = "flamethrower",
                desc = "Gen 1 [Charmander -> Charmeleon -> Charizard] · Fogo/Voador · Ember & Flamethrower"
            },
            ["Blastoise"] = {
                lookType = 912, hp = 5200, speed = 245,
                types = {"water"},
                evolutionChain = {"Squirtle", "Wartortle", "Blastoise"},
                startMove = "water gun",
                secondMove = "hydro pump",
                desc = "Gen 1 [Squirtle -> Wartortle -> Blastoise] · Agua · Water Gun & Hydro Pump"
            },
            ["Venusaur"] = {
                lookType = 906, hp = 5100, speed = 240,
                types = {"grass", "poison"},
                evolutionChain = {"Bulbasaur", "Ivysaur", "Venusaur"},
                startMove = "razor leaf",
                secondMove = "sludge bomb",
                desc = "Gen 1 [Bulbasaur -> Ivysaur -> Venusaur] · Planta/Veneno · Razor Leaf & Sludge Bomb"
            },
            ["Pikachu"] = {
                lookType = 928, hp = 3900, speed = 325,
                types = {"electric"},
                evolutionChain = {"Pikachu", "Raichu"},
                startMove = "thunder shock",
                secondMove = "spark",
                desc = "Gen 1 [Pikachu -> Raichu] · Eletrico · Thunder Shock (Chain) & Spark (Orbit)"
            },

            -- GEN 2 STARTERS
            ["Typhlosion"] = {
                lookType = 1060, hp = 4600, speed = 285,
                types = {"fire"},
                evolutionChain = {"Cyndaquil", "Quilava", "Typhlosion"},
                startMove = "flame wheel",
                secondMove = "fire blast",
                desc = "Gen 2 [Cyndaquil -> Quilava -> Typhlosion] · Fogo · Flame Wheel (Trail) & Fire Blast"
            },
            ["Feraligatr"] = {
                lookType = 1063, hp = 5100, speed = 260,
                types = {"water", "dark"},
                evolutionChain = {"Totodile", "Croconaw", "Feraligatr"},
                startMove = "water pulse",
                secondMove = "crunch",
                desc = "Gen 2 [Totodile -> Croconaw -> Feraligatr] · Agua/Sombrio · Water Pulse & Crunch"
            },
            ["Meganium"] = {
                lookType = 1057, hp = 5400, speed = 245,
                types = {"grass"},
                evolutionChain = {"Chikorita", "Bayleef", "Meganium"},
                startMove = "magical leaf",
                secondMove = "petal dance",
                desc = "Gen 2 [Chikorita -> Bayleef -> Meganium] · Planta · Magical Leaf (Orbit) & Petal Dance"
            },

            -- GEN 3 STARTERS
            ["Sceptile"] = {
                lookType = 1157, hp = 4300, speed = 320,
                types = {"grass", "dragon"},
                evolutionChain = {"Treecko", "Grovyle", "Sceptile"},
                startMove = "razor leaf",
                secondMove = "leaf storm",
                desc = "Gen 3 [Treecko -> Grovyle -> Sceptile] · Planta · Razor Leaf (Boomerang) & Leaf Storm"
            },
            ["Blaziken"] = {
                lookType = 1160, hp = 4600, speed = 290,
                types = {"fire", "fighting"},
                evolutionChain = {"Torchic", "Combusken", "Blaziken"},
                startMove = "double kick",
                secondMove = "fire spin",
                desc = "Gen 3 [Torchic -> Combusken -> Blaziken] · Fogo/Lutador · Double Kick & Fire Spin"
            },
            ["Swampert"] = {
                lookType = 1163, hp = 5400, speed = 250,
                types = {"water", "ground"},
                evolutionChain = {"Mudkip", "Marshtomp", "Swampert"},
                startMove = "mud shot",
                secondMove = "earthquake",
                desc = "Gen 3 [Mudkip -> Marshtomp -> Swampert] · Agua/Terra · Mud Shot & Earthquake"
            },

            -- GEN 4 STARTERS
            ["Torterra"] = {
                lookType = 1292, hp = 5600, speed = 235,
                types = {"grass", "ground"},
                evolutionChain = {"Turtwig", "Grotle", "Torterra"},
                startMove = "bulldoze",
                secondMove = "earthquake",
                desc = "Gen 4 [Turtwig -> Grotle -> Torterra] · Planta/Terra · Bulldoze & Earthquake"
            },
            ["Infernape"] = {
                lookType = 1295, hp = 4400, speed = 315,
                types = {"fire", "fighting"},
                evolutionChain = {"Chimchar", "Monferno", "Infernape"},
                startMove = "mach punch",
                secondMove = "flame wheel",
                desc = "Gen 4 [Chimchar -> Monferno -> Infernape] · Fogo/Lutador · Mach Punch & Flame Wheel"
            },
            ["Empoleon"] = {
                lookType = 1298, hp = 5000, speed = 260,
                types = {"water", "steel"},
                evolutionChain = {"Piplup", "Prinplup", "Empoleon"},
                startMove = "metal claw",
                secondMove = "surf",
                desc = "Gen 4 [Piplup -> Prinplup -> Empoleon] · Agua/Aco · Metal Claw & Surf"
            },

            -- CLASSICS & PSEUDO-LEGENDARIES
            ["Gengar"] = {
                lookType = 997, hp = 4100, speed = 295,
                types = {"ghost", "poison"},
                evolutionChain = {"Gastly", "Haunter", "Gengar"},
                startMove = "shadow ball",
                secondMove = "sludge wave",
                desc = "Classico [Gastly -> Haunter -> Gengar] · Fantasma/Veneno · Shadow Ball & Sludge Wave"
            },
            ["Alakazam"] = {
                lookType = 968, hp = 3800, speed = 305,
                types = {"psychic"},
                evolutionChain = {"Abra", "Kadabra", "Alakazam"},
                startMove = "psybeam",
                secondMove = "psychic",
                desc = "Classico [Abra -> Kadabra -> Alakazam] · Psiquico · Psybeam & Psychic Nova"
            },
            ["Machamp"] = {
                lookType = 971, hp = 5000, speed = 265,
                types = {"fighting", "rock"},
                evolutionChain = {"Machop", "Machoke", "Machamp"},
                startMove = "cross chop",
                secondMove = "dynamic punch",
                desc = "Classico [Machop -> Machoke -> Machamp] · Lutador · Cross Chop & Dynamic Punch"
            },
            ["Lucario"] = {
                lookType = 3056, hp = 4600, speed = 300,
                types = {"fighting", "steel"},
                evolutionChain = {"Riolu", "Lucario"},
                startMove = "mach punch",
                secondMove = "gyro ball",
                desc = "Classico [Riolu -> Lucario] · Lutador/Aco · Mach Punch & Gyro Ball (Orbit)"
            },
            ["Gardevoir"] = {
                lookType = 1185, hp = 4200, speed = 285,
                types = {"psychic"},
                evolutionChain = {"Ralts", "Kirlia", "Gardevoir"},
                startMove = "cosmic power",
                secondMove = "future sight",
                desc = "Classico [Ralts -> Kirlia -> Gardevoir] · Psiquico · Cosmic Power (Orbit) & Future Sight"
            },
            ["Metagross"] = {
                lookType = 1279, hp = 5500, speed = 260,
                types = {"steel", "psychic"},
                evolutionChain = {"Beldum", "Metang", "Metagross"},
                startMove = "iron head",
                secondMove = "doom desire",
                desc = "Pseudo-Lendario [Beldum -> Metang -> Metagross] · Aco/Psiquico · Iron Head & Doom Desire"
            },
            ["Garchomp"] = {
                lookType = 1348, hp = 5100, speed = 305,
                types = {"dragon", "ground"},
                evolutionChain = {"Gible", "Gabite", "Garchomp"},
                startMove = "dragon claw",
                secondMove = "earth power",
                desc = "Pseudo-Lendario [Gible -> Gabite -> Garchomp] · Dragao/Terra · Dragon Claw & Earth Power"
            },
            ["Dragonite"] = {
                lookType = 1052, hp = 5200, speed = 285,
                types = {"dragon", "flying"},
                evolutionChain = {"Dratini", "Dragonair", "Dragonite"},
                startMove = "twister",
                secondMove = "draco meteor",
                desc = "Pseudo-Lendario [Dratini -> Dragonair -> Dragonite] · Dragao/Voador · Twister & Draco Meteor"
            },
            ["Golduck"] = {
                lookType = 958, hp = 4500, speed = 275,
                types = {"water", "psychic"},
                evolutionChain = {"Psyduck", "Golduck"},
                startMove = "confusion",
                secondMove = "surf",
                desc = "Especialista [Psyduck -> Golduck] · Agua/Psiquico · Confusion (Aura) & Surf (Nova)"
            },
            ["Slowbro"] = {
                lookType = 983, hp = 5500, speed = 230,
                types = {"water", "psychic"},
                evolutionChain = {"Slowpoke", "Slowbro"},
                startMove = "water pulse",
                secondMove = "future sight",
                desc = "Guardiao [Slowpoke -> Slowbro] · Agua/Psiquico · Alta Vida, Water Pulse & Future Sight"
            },
            ["Lapras"] = {
                lookType = 1034, hp = 5300, speed = 255,
                types = {"water", "ice"},
                evolutionChain = {"Lapras"},
                startMove = "ice beam",
                secondMove = "blizzard",
                desc = "Classico [Lapras] · Agua/Gelo · Ice Beam & Blizzard"
            },
            ["Eevee"] = {
                lookType = 1036, hp = 4400, speed = 300,
                types = {"normal", "fire", "water", "electric", "psychic", "dark"},
                evolutionChain = {"Eevee", "Espeon", "Umbreon"},
                startMove = "swift",
                secondMove = "dark pulse",
                desc = "Versatil [Eevee -> Espeon -> Umbreon] · Domina Multiplos Elementos · Swift (Orbit)"
            }
        }
    },

    -- Memória de Estado Volátil
    playerState = {},
    spawnerEvents = {},
    autoAttackEvents = {},
    bossEvents = {},
    mapInitialized = false
}

-- ====================================================================
-- MÉTODOS DE SUPORTE A DANO E COMBATE PARA PLAYER (POKEVIEW)
-- ====================================================================

function Player.isPokemon(self)
    return self:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1
end

function PokeDungeon.getCastMoveMultiplier(player)
    local guid = player:getGuid()
    local st = PokeDungeon.playerState[guid]
    if not st or not st.lastCastMove then return 1.0 end

    local mInfo = st.lastCastMove
    local lvl = math.max(1, mInfo.level or 1)
    local mult = 1.0 + ((lvl - 1) * 0.25)
    if mInfo.evolved then
        mult = mult * 1.85
    end
    return mult
end

function PokeDungeon.hasHeldItem(player, itemId)
    local guid = player:getGuid()
    local st = PokeDungeon.playerState[guid]
    if not st or not st.heldItems then return false end
    return st.heldItems[itemId] == true
end

function PokeDungeon.addHeldItem(player, itemId)
    local itemData = PokeDungeon.HELD_ITEMS[itemId]
    if not itemData then return false end
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    local st = PokeDungeon.playerState[guid]
    if not st.heldItems then st.heldItems = {} end
    st.heldItems[itemId] = true
    if itemId == "focus_sash" then
        st.focusSashReady = true
    end
    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
    Game.sendAnimatedText(player:getPosition(), itemData.shortName:upper() .. "!", TEXTCOLOR_LIGHTBLUE)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[HELD ITEM] Voce equipou " .. itemData.title .. "! (" .. itemData.desc .. ")")
    return true
end

function Player.getTotalMagicAttack(self)
    local pokeName = PokeDungeon.getPlayerPoke(self) or "Charizard"
    local mType = MonsterType(pokeName)
    local base = 100
    if mType and mType.getMoveMagicAttackBase then
        base = mType:getMoveMagicAttackBase() or 100
    end

    local runLevel = math.max(1, self:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
    local atkTrait = math.max(0, self:getStorageValue(PokeDungeon.STORAGE_TRAIT_ATK))
    local metaAtk = math.max(0, self:getStorageValue(PokeDungeon.STORAGE_META_ATK))
    local traitMult = 1.0 + (atkTrait * 0.20) + (metaAtk * 0.10)

    if PokeDungeon.hasBuff(self, "ataque") then
        traitMult = traitMult * 1.6
    end
    if PokeDungeon.hasHeldItem(self, "life_orb") then
        traitMult = traitMult * 1.35
    end

    local moveMult = PokeDungeon.getCastMoveMultiplier(self)
    return math.floor(base * (1 + (runLevel - 1) * 0.15) * traitMult * moveMult)
end

function Player.getTotalMeleeAttack(self)
    local pokeName = PokeDungeon.getPlayerPoke(self) or "Charizard"
    local mType = MonsterType(pokeName)
    local base = 100
    if mType then
        local minMelee = 0
        local maxMelee = 0
        local attacks = mType:getAttackList()
        if attacks and #attacks > 0 then
            for i = 1, #attacks do
                if attacks[i].isMelee == 1 then
                    minMelee = minMelee - attacks[i].minCombatValue
                    maxMelee = maxMelee - attacks[i].maxCombatValue
                end
            end
            if (minMelee + maxMelee) > 0 then
                base = (minMelee + maxMelee) / 2
            end
        end
    end

    local runLevel = math.max(1, self:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
    local atkTrait = math.max(0, self:getStorageValue(PokeDungeon.STORAGE_TRAIT_ATK))
    local metaAtk = math.max(0, self:getStorageValue(PokeDungeon.STORAGE_META_ATK))
    local traitMult = 1.0 + (atkTrait * 0.20) + (metaAtk * 0.10)

    if PokeDungeon.hasBuff(self, "ataque") then
        traitMult = traitMult * 1.6
    end
    if PokeDungeon.hasHeldItem(self, "life_orb") then
        traitMult = traitMult * 1.35
    end

    local moveMult = PokeDungeon.getCastMoveMultiplier(self)
    return math.floor(base * (1 + (runLevel - 1) * 0.15) * traitMult * moveMult)
end

function Player.getMaster(self)
    return self
end

function Player.getUsedVitaminsNumber(self, name)
    return 0
end

function Player.getBoost(self)
    return 0
end

function Player.getLove(self)
    return 100
end

-- ====================================================================
-- GERAÇÃO PROCEDURAL DO MAPA E BIOMAS (LOBBY + ARENA + PROPS)
-- ====================================================================

local function setTileFloorAndClear(pos, groundId)
    local tile = Tile(pos)
    if not tile then
        Game.createTile(pos)
        tile = Tile(pos)
    end
    if tile then
        local items = tile:getItems()
        if items then
            for i = #items, 1, -1 do
                local it = items[i]
                if it and it:getId() ~= 1387 then
                    it:remove()
                end
            end
        end
        local ground = tile:getGround()
        if not ground then
            Game.createItem(groundId, 1, pos)
        else
            ground:transform(groundId)
        end
    end
    return tile
end

local function placeWall(pos)
    setTileFloorAndClear(pos, 4526)
    Game.createItem(1049, 1, pos)
end

local function placePortal(pos, actionId)
    setTileFloorAndClear(pos, 416)
    local tile = Tile(pos)
    local existingPortal = nil
    if tile and tile:getItems() then
        for _, it in ipairs(tile:getItems()) do
            if it:getId() == 1387 then
                existingPortal = it
                break
            end
        end
    end
    if not existingPortal then
        local p = Game.createItem(1387, 1, pos)
        if p then p:setActionId(actionId) end
    else
        existingPortal:setActionId(actionId)
    end
end

-- Cria um Baú de Tesouro Interativo na Arena
function PokeDungeon.spawnArenaChest(pos)
    local tile = Tile(pos)
    if not tile then return nil end
    local chest = Game.createItem(1740, 1, pos)
    if chest then
        chest:setActionId(9510)
        pos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        Game.sendAnimatedText(pos, "BAU!", TEXTCOLOR_YELLOW)
    end
    return chest
end

-- Verifica se uma coordenada está próxima de pontos críticos (Spawn, Portal, Altares, Fontes)
local function isProtectedArenaPos(x, y)
    if math.abs(x - 1840) <= 2 and math.abs(y - 2270) <= 2 then return true end -- Spawn central
    if math.abs(x - 1840) <= 2 and math.abs(y - 2252) <= 2 then return true end -- Portal de saída
    if math.abs(x - 1840) <= 1 and math.abs(y - 2263) <= 1 then return true end -- Baú inicial
    for _, altar in ipairs(PokeDungeon.config.altars) do
        if math.abs(x - altar.pos.x) <= 2 and math.abs(y - altar.pos.y) <= 2 then return true end
    end
    for _, spring in ipairs(PokeDungeon.config.springs) do
        if math.abs(x - spring.pos.x) <= 2 and math.abs(y - spring.pos.y) <= 2 then return true end
    end
    return false
end

-- Gera proceduralmente o Bioma Gráfico do Andar + Props Destrutíveis + Altares + Fontes
function PokeDungeon.buildFloorBiome(floorNum)
    local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]
    local biome = floorData.biome or "grassland"
    local baseGround = floorData.floorId or 4526

    for x = 1820, 1860 do
        for y = 2250, 2290 do
            local pos = Position(x, y, 7)
            if x == 1820 or x == 1860 or y == 2250 or y == 2290 then
                placeWall(pos)
            else
                -- Hash espacial determinístico mas variado por andar
                local h = (x * 37 + y * 73 + floorNum * 19) % 100
                local patch = ((math.floor(x / 3) * 17 + math.floor(y / 3) * 31) % 10)
                local fId = baseGround

                -- 1. Texturas Orgânicas de Piso por Bioma
                if biome == "grassland" then
                    if patch == 0 or patch == 1 then fId = 4667        -- Manchas de Terra (Dirt)
                    elseif patch == 2 then fId = 4580                  -- Grama Musgosa (Swamp patch)
                    else fId = 4526 + ((x + y) % 3)                    -- Variações naturais de Grama
                    end
                elseif biome == "cave" then
                    if (x == 1840 or y == 2270) then fId = 416         -- Passarela central de pedra
                    elseif patch <= 2 then fId = 4405                  -- Solo rochoso escuro
                    else fId = 4554                                    -- Cascalho de caverna
                    end
                elseif biome == "ghost" then
                    if patch <= 2 then fId = 4580                      -- Pântano sombrio
                    elseif (x + y) % 5 == 0 then fId = 3166            -- Laje entalhada de cripta
                    else fId = 407                                     -- Mármore negro
                    end
                elseif biome == "ice" then
                    if patch <= 3 then fId = 8570                      -- Pista de Gelo Escorregadio (Speed Boost!)
                    else fId = 4737                                    -- Neve profunda
                    end
                elseif biome == "volcano" then
                    if patch <= 2 then fId = 3264                      -- Terra vulcânica ardente (Magma)
                    elseif patch == 3 then fId = 4667                  -- Cinzas vulcânicas
                    else fId = 407                                     -- Basalto escuro
                    end
                elseif biome == "divine" then
                    if (x == 1840 or y == 2270) then fId = 3166        -- Caminho real dourado/entalhado
                    elseif (x + y) % 2 == 0 then fId = 3173            -- Piso ornamentado de santuário
                    else fId = 424                                     -- Mármore branco sagrado
                    end
                end

                setTileFloorAndClear(pos, fId)

                -- 2. Decorações de Borda Interna (1 SQM das paredes) e Props Destrutíveis na Arena
                local isInnerBorder = (x == 1821 or x == 1859 or y == 2251 or y == 2289)
                if not isProtectedArenaPos(x, y) then
                    if isInnerBorder and h < 45 then
                        -- Árvores, Cristais Gigantes, Pilares e Fontes de Lava no perímetro
                        if biome == "grassland" then
                            Game.createItem((h % 2 == 0) and 2700 or 2701, 1, pos)
                        elseif biome == "cave" then
                            Game.createItem(8633 + (h % 4), 1, pos)
                        elseif biome == "ghost" then
                            Game.createItem((h % 2 == 0) and 2709 or 3744, 1, pos)
                        elseif biome == "ice" then
                            Game.createItem((h % 2 == 0) and 2698 or 8571, 1, pos)
                        elseif biome == "volcano" then
                            Game.createItem((h % 2 == 0) and 5074 or 2601, 1, pos)
                        elseif biome == "divine" then
                            Game.createItem((h % 2 == 0) and 5308 or 3697, 1, pos)
                        end
                    elseif not isInnerBorder then
                        -- Props Destrutíveis (Arbustos Cortáveis 2767 e Rochas/Cristais Quebráveis 3610/3615/8637)
                        -- e Detalhes Rasteiros Caminháveis (Flores, Cogumelos, Gás)
                        if biome == "grassland" then
                            if h < 4 then
                                Game.createItem(2767, 1, pos) -- Arbusto Cortável (Dropa Berry/EXP!)
                            elseif h == 5 then
                                Game.createItem(3610, 1, pos) -- Pedra Quebrável
                            elseif h >= 92 then
                                Game.createItem(2744 + (h % 3), 1, pos) -- Flores silvestres
                            end
                        elseif biome == "cave" then
                            if h < 4 then
                                Game.createItem(8637, 1, pos) -- Cristal Quebrável (Dropa Gemas/Coins!)
                            elseif h == 5 or h == 6 then
                                Game.createItem(3610, 1, pos) -- Rocha de Caverna Quebrável
                            end
                        elseif biome == "ghost" then
                            if h < 3 then
                                Game.createItem(2767, 1, pos) -- Arbusto Sombrio Cortável
                            elseif h == 4 then
                                Game.createItem(3610, 1, pos) -- Lápide/Pedra Quebrável
                            elseif fId == 4580 and h >= 95 then
                                Game.createItem(1496, 1, pos) -- Névoa de Gás Venenoso
                            end
                        elseif biome == "ice" then
                            if h < 4 then
                                Game.createItem(8637, 1, pos) -- Cristal de Gelo Quebrável
                            elseif h == 5 then
                                Game.createItem(3615, 1, pos) -- Rocha Congelada Quebrável
                            end
                        elseif biome == "volcano" then
                            if h < 4 then
                                Game.createItem(3610, 1, pos) -- Rocha de Magma Quebrável
                            elseif h == 5 then
                                Game.createItem(8637, 1, pos) -- Cristal Ígneo Quebrável
                            end
                        elseif biome == "divine" then
                            if h < 4 then
                                Game.createItem(8637, 1, pos) -- Cristal Celestial Quebrável
                            elseif h == 5 then
                                Game.createItem(3610, 1, pos) -- Relíquia de Pedra Quebrável
                            end
                        end
                    end
                end
            end
        end
    end

    -- Portal de Saída da Arena de volta ao Lobby (1840, 2252, 7)
    placePortal(Position(1840, 2252, 7), 9502)

    -- 4 Altares de Poder nos Cantos Internos da Arena
    for _, altar in ipairs(PokeDungeon.config.altars) do
        setTileFloorAndClear(altar.pos, 424)
        Game.createItem(1484, 1, altar.pos)
    end

    -- 2 Fontes Curativas (Mananciais de Vida)
    for _, spring in ipairs(PokeDungeon.config.springs) do
        setTileFloorAndClear(spring.pos, 416)
        Game.createItem(2146, 1, spring.pos)
    end

    -- Pilares Temáticos em posições estratégicas da Arena
    local pillars = {
        Position(1840, 2256, 7), Position(1840, 2284, 7),
        Position(1826, 2270, 7), Position(1854, 2270, 7)
    }
    local pillarItem = 1484
    if biome == "cave" then pillarItem = 8635
    elseif biome == "ghost" then pillarItem = 3744
    elseif biome == "ice" then pillarItem = 8571
    elseif biome == "volcano" then pillarItem = 2601
    elseif biome == "divine" then pillarItem = 5308
    end
    for _, pilPos in ipairs(pillars) do
        setTileFloorAndClear(pilPos, 424)
        Game.createItem(pillarItem, 1, pilPos)
    end
end

function PokeDungeon.buildMap()
    -- 1. CONSTRUÇÃO DO LOBBY (1801 a 1809, 2251 a 2259, z = 7)
    for x = 1801, 1809 do
        for y = 2251, 2259 do
            local pos = Position(x, y, 7)
            if x == 1801 or x == 1809 or y == 2251 or y == 2259 then
                placeWall(pos)
            else
                local floorId = ((x + y) % 2 == 0) and 416 or 417
                setTileFloorAndClear(pos, floorId)
            end
        end
    end

    -- Portais do Lobby:
    -- Norte (1805, 2252, 7): Abre Seleção de Pokémon / Inicia Run (ActionId 9501)
    placePortal(Position(1805, 2252, 7), 9501)
    -- Sul (1805, 2258, 7): Sai da Dungeon / Volta ao Templo (ActionId 9502)
    placePortal(Position(1805, 2258, 7), 9502)

    -- Tochas nos cantos do Lobby
    Game.createItem(1484, 1, Position(1802, 2252, 7))
    Game.createItem(1484, 1, Position(1808, 2252, 7))
    Game.createItem(1484, 1, Position(1802, 2258, 7))
    Game.createItem(1484, 1, Position(1808, 2258, 7))

    -- 2. Constrói o Bioma inicial da Arena (Andar 1)
    PokeDungeon.buildFloorBiome(1)

    -- 3. ESTAÇÃO DE TELEPORTE DENTRO DO CENTRO POKÉMON DE SAFFRON (1052, 1050, 7)
    -- Garante que o tile de chegada (1054, 1050, 7) fique livre e cria o Portal de Evento 2 SQMs ao lado!
    setTileFloorAndClear(PokeDungeon.config.templePos, 416)
    local cpPos = PokeDungeon.config.cpPortalPos
    setTileFloorAndClear(cpPos, 417)
    placePortal(cpPos, 9500)

    -- Inicia o pulso visual periódico nos portais do Centro Pokémon e do Lobby
    if not PokeDungeon.portalBeaconStarted then
        PokeDungeon.portalBeaconStarted = true
        PokeDungeon.runPortalBeaconLoop()
    end

    PokeDungeon.mapInitialized = true
    print(">> [Poketestes by Raph] Mapa, Estacao do Centro Pokemon, Lobby, Arena e 6 Biomas Graficos construidos com sucesso!")
end

function PokeDungeon.runPortalBeaconLoop()
    local cpPos = PokeDungeon.config.cpPortalPos
    if cpPos then
        cpPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        Game.sendAnimatedText(cpPos, "DUNGEON", TEXTCOLOR_LIGHTBLUE)
    end
    local lobbyNorth = Position(1805, 2252, 7)
    lobbyNorth:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    Game.sendAnimatedText(lobbyNorth, "JOGAR!", TEXTCOLOR_LIGHTGREEN)

    local lobbySouth = Position(1805, 2258, 7)
    lobbySouth:sendMagicEffect(CONST_ME_TELEPORT)
    Game.sendAnimatedText(lobbySouth, "CP SAFFRON", TEXTCOLOR_WHITE)

    addEvent(PokeDungeon.runPortalBeaconLoop, 3500)
end

-- ====================================================================
-- POKÉBAR HUD (EXTENDED OPCODE 52 - OTCLIENT)
-- ====================================================================

function PokeDungeon.getEffectiveMoveCooldown(player, mInfo)
    local baseCd = mInfo.cooldown or 2200
    local cdLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_CD))
    local cdMult = math.max(0.35, 1.0 - (cdLvl * 0.15))
    if PokeDungeon.hasBuff(player, "cooldown") then
        cdMult = cdMult * 0.5
    end
    if mInfo.evolved then
        cdMult = cdMult * 0.85
    end
    return math.max(500, math.floor(baseCd * cdMult))
end

function PokeDungeon.sendPokebar(player)
    local unlocked = PokeDungeon.getUnlockedMoves(player)
    local movesList = {}
    local speedsList = {}
    local remainingList = {}

    for _, mInfo in ipairs(unlocked) do
        local mName = mInfo.name
        local speed = PokeDungeon.getEffectiveMoveCooldown(player, mInfo)

        table.insert(movesList, mName)
        table.insert(speedsList, speed)
        table.insert(remainingList, 0)
    end

    local parts = {}
    for _, m in ipairs(movesList) do table.insert(parts, m) end
    for _, s in ipairs(speedsList) do table.insert(parts, tostring(s)) end
    for _, r in ipairs(remainingList) do table.insert(parts, tostring(r)) end

    local buffer = table.concat(parts, ",") .. ","
    player:sendExtendedOpcode(52, buffer)
end

-- ====================================================================
-- SELEÇÃO DE POKÉMON, EVOLUÇÃO IN-RUN (ESTÁGIO 1 -> 2 -> 3) E OUTFITS
-- ====================================================================

-- Retorna o nome da espécie atual do jogador considerando o Estágio de Evolução In-Run (1, 2 ou 3)
function PokeDungeon.getCurrentSpeciesName(player, baseLineageName)
    baseLineageName = baseLineageName or PokeDungeon.getPlayerPoke(player)
    local charData = PokeDungeon.config.characters[baseLineageName] or PokeDungeon.config.characters["Charizard"]
    local chain = charData.evolutionChain or {baseLineageName}
    local guid = player:getGuid()
    local st = PokeDungeon.playerState[guid]
    local stage = (st and st.evoStage) or 1
    if stage > #chain then stage = #chain end
    if stage < 1 then stage = 1 end
    return chain[stage] or baseLineageName
end

function PokeDungeon.getOutfitForPokemon(player, pokeName)
    local speciesName = PokeDungeon.getCurrentSpeciesName(player, pokeName)
    local charData = PokeDungeon.config.characters[pokeName] or PokeDungeon.config.characters["Charizard"]
    local look = charData.lookType

    -- Busca o lookType exato do estágio atual (ex: Charmander, Charmeleon ou Charizard) em MonsterType
    local normalType = MonsterType(speciesName)
    if normalType and normalType:getOutfit() and normalType:getOutfit().lookType > 0 then
        look = normalType:getOutfit().lookType
    end

    if player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1 then
        local shinyType = MonsterType("Shiny " .. speciesName)
        if shinyType and shinyType:getOutfit() and shinyType:getOutfit().lookType > 0 then
            look = shinyType:getOutfit().lookType
        end
    end
    return look
end

-- Evolui o Pokémon do jogador durante a partida (Nv. 5 -> Estágio 2, Nv. 10 -> Estágio 3, ou via Painel Demo)
function PokeDungeon.evolvePlayerPokemon(player, forceNext)
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then return false end
    local st = PokeDungeon.playerState[guid]
    local baseLineage = st.pokeName or "Charizard"
    local charData = PokeDungeon.config.characters[baseLineage] or PokeDungeon.config.characters["Charizard"]
    local chain = charData.evolutionChain or {baseLineage}

    local curStage = st.evoStage or 1
    if curStage >= #chain then
        if forceNext then
            -- Se já está no estágio final e forçou no Demo, cicla de volta ao Estágio 1 ou avisa!
            st.evoStage = 1
            local resetSpecies = PokeDungeon.getCurrentSpeciesName(player, baseLineage)
            player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, baseLineage)})
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🧬 [DEMO EVOLUCAO] Retornou ao Estagio 1 (" .. resetSpecies .. ") para demonstrar a linha evolutiva novamente!")
            return true
        end
        return false
    end

    local oldSpecies = chain[curStage]
    st.evoStage = curStage + 1
    local newSpecies = chain[st.evoStage]

    -- Atualiza visual para o novo estágio (Normal ou Shiny!)
    player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, baseLineage)})

    -- Bônus de Atributos da Evolução (+25% Max HP, Cura Total e +20 Speed)
    local newMaxHp = math.floor(player:getMaxHealth() * 1.25)
    player:setMaxHealth(newMaxHp)
    player:addHealth(newMaxHp)
    player:changeSpeed(20)

    -- Se atingiu a forma final e ainda não tem o 2º golpe assinatura, desbloqueia gratuitamente!
    if st.evoStage == #chain and charData.secondMove then
        local unlocked = PokeDungeon.getUnlockedMoves(player)
        local hasSecond = false
        for _, u in ipairs(unlocked) do
            if u.name:lower() == charData.secondMove:lower() then
                hasSecond = true
                break
            end
        end
        if not hasSecond and #unlocked < 6 then
            table.insert(unlocked, { name = charData.secondMove, level = 1, cooldown = 1850, evolved = false })
            PokeDungeon.sendPokebar(player)
        end
    end

    local pPos = player:getPosition()
    pPos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    pPos:sendMagicEffect(CONST_ME_FIREWORK_RED)
    pPos:sendMagicEffect(CONST_ME_HOLYAREA)
    Game.sendAnimatedText(pPos, "EVOLUIU!", TEXTCOLOR_YELLOW)
    player:say("O que?! " .. oldSpecies .. " evoluiu para " .. newSpecies:upper() .. "!", TALKTYPE_MONSTER_YELL)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("🧬 [EVOLUCAO POKEMON] Parabens! Seu %s evoluiu para %s (+25%% Vida Maxima, +20 Speed e Poder Ampliado)!", oldSpecies, newSpecies:upper()))
    return true
end

function PokeDungeon.openPokemonSelectModal(player)
    local shinyTag = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1) and " [SKIN SHINY ✨]" or ""
    local maxFloor = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_MAX_FLOOR))
    local curFloor = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
    if curFloor > maxFloor then curFloor = maxFloor end

    local activeContracts = {}
    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_VANGUARD) == 1 then table.insert(activeContracts, "Vanguarda") end
    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_COLLECTOR) == 1 then table.insert(activeContracts, "Colecionador") end
    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_SHINY) == 1 then table.insert(activeContracts, "Cacador") end
    local contractStr = (#activeContracts > 0) and (" | Contratos: " .. table.concat(activeContracts, "+")) or ""

    local prompt = string.format("Andar: %d/%d%s%s\n25 Linhagens (Gen 1-4 + Classicos) com Evolucao na Partida (Nv.5 e Nv.10):", curFloor, maxFloor, shinyTag, contractStr)
    local window = ModalWindow(PokeDungeon.MODAL_CHOOSE_POKE, "⭐ Poketestes by Raph: Escolha sua Linhagem ⭐", prompt)
    window:addButton(1, "Iniciar")
    window:addButton(2, "Loja / Boosts")
    window:addButton(3, "Painel GM")
    window:addButton(4, "Cancelar")
    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(4)

    local pokes = PokeDungeon.config.starterOrder
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    PokeDungeon.playerState[guid].offeredPokes = pokes

    for i, pName in ipairs(pokes) do
        local data = PokeDungeon.config.characters[pName]
        local desc = data and data.desc or pName
        local firstStage = (data and data.evolutionChain and data.evolutionChain[1]) or pName
        local displayPrefix = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1) and ("✨ Shiny " .. firstStage .. " (" .. pName .. ")") or (firstStage .. " -> " .. pName)
        window:addChoice(i, displayPrefix .. " — " .. desc)
    end

    window:sendToPlayer(player)
end

-- Loja Kecleon: Meta-Upgrades Permanentes, Contratos Pré-Run (Cash-Sink) & Kit Mestre Mundo Aberto
function PokeDungeon.openUpgradesModal(player)
    local coins = player:getItemCount(2160) -- Crystal Coins
    local shinyOn = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1)
    local prompt = string.format("Saldo: %d Crystal Coins | Skin Shiny: %s\nMelhore atributos permanentes ou contrate Boosts Pre-Run (Cash-Sink de 1 Partida):", coins, shinyOn and "ATIVADA ✨" or "Normal")

    local window = ModalWindow(PokeDungeon.MODAL_UPGRADES, "🛒 Loja Kecleon: Upgrades & Contratos Pre-Run", prompt)
    window:addButton(1, "Comprar / Ativar")
    window:addButton(2, "Voltar")
    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(2)

    local hpLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_HP))
    local atkLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_ATK))
    local spdLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_SPEED))
    local expLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_EXP))
    local rerollLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_REROLL))
    local movesLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_MOVES))

    local cVanguard = (player:getStorageValue(PokeDungeon.STORAGE_BOOST_VANGUARD) == 1)
    local cCollector = (player:getStorageValue(PokeDungeon.STORAGE_BOOST_COLLECTOR) == 1)
    local cShiny = (player:getStorageValue(PokeDungeon.STORAGE_BOOST_SHINY) == 1)

    -- 1 a 6: Meta-Upgrades Permanentes
    window:addChoice(1, string.format("❤️ Vitalidade Eterna [Nv. %d/5] — +12%% Vida Inicial (Custo: 5 Crystal Coins)", hpLvl))
    window:addChoice(2, string.format("⚔️ Forca Bruta [Nv. %d/5] — +10%% Dano Base (Custo: 5 Crystal Coins)", atkLvl))
    window:addChoice(3, string.format("👟 Passos Leves [Nv. %d/5] — +15 Velocidade Inicial (Custo: 5 Crystal Coins)", spdLvl))
    window:addChoice(4, string.format("📘 Sabedoria Ancestral [Nv. %d/5] — +15%% EXP Ganha (Custo: 5 Crystal Coins)", expLvl))
    window:addChoice(5, string.format("🎲 Dados do Destino [Nv. %d/5] — +1 Reroll de Traits na Run (Custo: 5 Crystal Coins)", rerollLvl))
    window:addChoice(6, string.format("🔥 Repertorio Inicial [Nv. %d/1] — Comeca a Run com 2 Golpes! (Custo: 10 Crystal Coins)", movesLvl))

    -- 7 a 9: Contratos de Expedição Consumíveis (Cash-Sink de Dinheiro do Jogo — Valem por 1 Run)
    window:addChoice(7, string.format("🎫 [BOOST 1 RUN] Contrato de Vanguarda [%s] — +1 Golpe Extra na Largada + Escudo 30s (3 CC)", cVanguard and "ATIVO" or "Contratar"))
    window:addChoice(8, string.format("🧲 [BOOST 1 RUN] Contrato do Colecionador [%s] — Ima Nv.2 na Largada + 25%% EXP na Run (3 CC)", cCollector and "ATIVO" or "Contratar"))
    window:addChoice(9, string.format("🍀 [BOOST 1 RUN] Contrato do Cacador [%s] — 2x Chance Shiny + 2 Baus Extras + 2 Rerolls (5 CC)", cShiny and "ATIVO" or "Contratar"))

    -- 10 a 12: Cosméticos, Kit Mestre Mundo Aberto e Auxílio de Testes
    window:addChoice(10, string.format("✨ Cosmético: Alternar Skin SHINY nos Starters [Atual: %s]", shinyOn and "SHINY ✨" or "NORMAL"))
    window:addChoice(11, "🎒 Kit Mestre Mundo Aberto: Receber 6 Pokemons Lv.100 [Boost +50] + Suprimentos")
    window:addChoice(12, "💰 [Teste / Sandbox] Receber +50 Crystal Coins")

    window:sendToPlayer(player)
end

function PokeDungeon.givePxgStarterTeam(player, force)
    if not force and player:getStorageValue(PokeDungeon.STORAGE_PXG_KIT_GIVEN) == 1 then
        return false
    end
    player:setStorageValue(PokeDungeon.STORAGE_PXG_KIT_GIVEN, 1)

    if type(player.addSlotItems) == "function" then
        player:addSlotItems()
    end

    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack then
        backpack = player:addItem(1988, 1, false, 1, CONST_SLOT_BACKPACK)
    end
    if not backpack then return false end

    local pxgTeam = {
        { name = "Shiny Charizard", level = 100, boost = 50, love = 100, ballId = 26666 },
        { name = "Shiny Gengar",    level = 100, boost = 50, love = 100, ballId = 26670 },
        { name = "Shiny Gardevoir", level = 100, boost = 50, love = 100, ballId = 26666 },
        { name = "Shiny Lucario",   level = 100, boost = 50, love = 100, ballId = 26670 },
        { name = "Shiny Gyarados",  level = 100, boost = 50, love = 100, ballId = 26670 },
        { name = "Shiny Snorlax",   level = 100, boost = 50, love = 100, ballId = 26666 }
    }

    for _, pk in ipairs(pxgTeam) do
        local mType = MonsterType(pk.name)
        if not mType then
            pk.name = pk.name:gsub("Shiny ", "")
            mType = MonsterType(pk.name)
        end
        if mType then
            local ball = backpack:addItem(pk.ballId, 1)
            if ball then
                local baseHealth = mType:getMaxHealth()
                local mult = (type(statusGainFormula) == "function") and statusGainFormula(player:getLevel(), pk.level, pk.boost, pk.love) or 5.0
                local maxHealth = math.max(1000, math.floor(baseHealth * mult))
                local expNeeded = (type(getNeededExp) == "function") and getNeededExp(pk.level) or 100000
                ball:setSpecialAttribute("pokeName", pk.name)
                ball:setSpecialAttribute("pokeLevel", pk.level)
                ball:setSpecialAttribute("pokeBoost", pk.boost)
                ball:setSpecialAttribute("pokeLove", pk.love)
                ball:setSpecialAttribute("pokeExperience", expNeeded)
                ball:setSpecialAttribute("pokeMaxHealth", maxHealth)
                ball:setSpecialAttribute("pokeHealth", maxHealth)
                ball:setSpecialAttribute("isBeingUsed", 0)
            end
        end
    end

    player:addItem(26688, 100) -- 100 Ultra Balls
    player:addItem(27645, 100) -- 100 Revives
    player:addItem(27646, 100) -- 100 Ultra Potions
    player:addItem(2160, 100)  -- 100 Crystal Coins

    if type(player.refreshPokemonBar) == "function" then
        player:refreshPokemonBar({}, {})
    end

    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🎒 [KIT MESTRE MUNDO ABERTO] Voce recebeu 6 Pokemons Lv.100 [Boost +50] na Pokebar (Fly, Teleport, Blink, Surf), Revives, Potions e 100 Crystal Coins!")
    return true
end

function PokeDungeon.handleUpgradeChoice(player, choiceId)
    -- Contratos Pré-Run (Cash-Sink de 1 Partida)
    local contracts = {
        [7] = { storage = PokeDungeon.STORAGE_BOOST_VANGUARD,  cost = 3, name = "Contrato de Vanguarda (+1 Golpe + Escudo Inicial)" },
        [8] = { storage = PokeDungeon.STORAGE_BOOST_COLLECTOR, cost = 3, name = "Contrato do Colecionador (Ima Nv.2 + 25% EXP)" },
        [9] = { storage = PokeDungeon.STORAGE_BOOST_SHINY,     cost = 5, name = "Contrato do Cacador (2x Shiny + 2 Baus + 2 Rerolls)" }
    }
    if contracts[choiceId] then
        local c = contracts[choiceId]
        if player:getStorageValue(c.storage) == 1 then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Loja Kecleon] Este Contrato Pre-Run ja esta ativo para sua proxima partida!")
            PokeDungeon.openUpgradesModal(player)
            return true
        end
        if player:getItemCount(2160) < c.cost then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Loja Kecleon] Crystal Coins insuficientes! Custo: " .. c.cost .. " Crystal Coins.")
            PokeDungeon.openUpgradesModal(player)
            return true
        end
        player:removeItem(2160, c.cost)
        player:setStorageValue(c.storage, 1)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🎫 [CASH-SINK / BOOST PRE-RUN] " .. c.name .. " ativado para sua proxima Run!")
        PokeDungeon.openUpgradesModal(player)
        return true
    end

    if choiceId == 10 then
        local cur = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1) and 0 or 1
        player:setStorageValue(PokeDungeon.STORAGE_SHINY_SKIN, cur)
        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        if player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
            local pName = PokeDungeon.getPlayerPoke(player)
            player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, pName)})
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Poketestes by Raph] Modo Skin SHINY: " .. (cur == 1 and "ATIVADO ✨!" or "DESATIVADO."))
        PokeDungeon.openUpgradesModal(player)
        return true
    elseif choiceId == 11 then
        PokeDungeon.givePxgStarterTeam(player, true)
        PokeDungeon.openUpgradesModal(player)
        return true
    elseif choiceId == 12 then
        player:addItem(2160, 50)
        player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Loja Kecleon] Voce recebeu +50 Crystal Coins para testes!")
        PokeDungeon.openUpgradesModal(player)
        return true
    end

    local map = {
        [1] = { storage = PokeDungeon.STORAGE_META_HP,     max = 5, cost = 5,  name = "Vitalidade Eterna" },
        [2] = { storage = PokeDungeon.STORAGE_META_ATK,    max = 5, cost = 5,  name = "Forca Bruta" },
        [3] = { storage = PokeDungeon.STORAGE_META_SPEED,  max = 5, cost = 5,  name = "Passos Leves" },
        [4] = { storage = PokeDungeon.STORAGE_META_EXP,    max = 5, cost = 5,  name = "Sabedoria Ancestral" },
        [5] = { storage = PokeDungeon.STORAGE_META_REROLL, max = 5, cost = 5,  name = "Dados do Destino" },
        [6] = { storage = PokeDungeon.STORAGE_META_MOVES,  max = 1, cost = 10, name = "Repertorio Inicial" }
    }
    local up = map[choiceId]
    if not up then return false end

    local curLvl = math.max(0, player:getStorageValue(up.storage))
    if curLvl >= up.max then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Loja Kecleon] Este upgrade ja esta no nivel maximo!")
        PokeDungeon.openUpgradesModal(player)
        return true
    end

    if player:getItemCount(2160) < up.cost then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Loja Kecleon] Crystal Coins insuficientes!")
        PokeDungeon.openUpgradesModal(player)
        return true
    end

    player:removeItem(2160, up.cost)
    player:setStorageValue(up.storage, curLvl + 1)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Loja Kecleon] %s aprimorado para Nv. %d/%d!", up.name, curLvl + 1, up.max))
    PokeDungeon.openUpgradesModal(player)
    return true
end

function PokeDungeon.revertToTrainer(player)
    player:setStorageValue(PokeDungeon.STORAGE_POKEVIEW, -1)
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, -1)

    local guid = player:getGuid()
    if PokeDungeon.autoAttackEvents[guid] then
        stopEvent(PokeDungeon.autoAttackEvents[guid])
        PokeDungeon.autoAttackEvents[guid] = nil
    end
    if PokeDungeon.spawnerEvents[guid] then
        stopEvent(PokeDungeon.spawnerEvents[guid])
        PokeDungeon.spawnerEvents[guid] = nil
    end
    if PokeDungeon.bossEvents[guid] then
        stopEvent(PokeDungeon.bossEvents[guid])
        PokeDungeon.bossEvents[guid] = nil
    end

    local tLook = (player:getSex() == 0 and 1971 or 1974)
    player:setOutfit({lookType = tLook})

    player:setMaxHealth(1000)
    player:addHealth(1000)
    player:changeSpeed(-player:getSpeed() + 250)

    player:say("thanks", TALKTYPE_MONSTER_SAY)
end

function PokeDungeon.getPlayerPoke(player)
    local guid = player:getGuid()
    if PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].pokeName then
        return PokeDungeon.playerState[guid].pokeName
    end
    return "Charizard"
end

function PokeDungeon.getUnlockedMoves(player)
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    if not PokeDungeon.playerState[guid].unlockedMoves then
        local pokeName = PokeDungeon.getPlayerPoke(player)
        local charData = PokeDungeon.config.characters[pokeName] or PokeDungeon.config.characters["Charizard"]
        local sMove = charData.startMove or "ember"
        PokeDungeon.playerState[guid].unlockedMoves = {
            { name = sMove, level = 1, cooldown = 1400, evolved = false }
        }
        if math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_MOVES)) >= 1 and charData.secondMove then
            table.insert(PokeDungeon.playerState[guid].unlockedMoves, {
                name = charData.secondMove, level = 1, cooldown = 2000, evolved = false
            })
        end
    end
    return PokeDungeon.playerState[guid].unlockedMoves
end

-- ====================================================================
-- AUTO-AIM, PROPS DESTRUTÍVEIS, EFEITOS DE TERRENO & ENGINE DE ARQUÉTIPOS
-- ====================================================================

function PokeDungeon.findAimTarget(player, maxDist)
    local pPos = player:getPosition()
    local dir = player:getDirection()
    local bestTarget = nil
    local bestDist = maxDist + 1

    for x = pPos.x - maxDist, pPos.x + maxDist do
        for y = pPos.y - maxDist, pPos.y + maxDist do
            local dx = x - pPos.x
            local dy = y - pPos.y
            local dist = math.max(math.abs(dx), math.abs(dy))
            if dist <= maxDist and dist > 0 then
                local inFacingCone = false
                if dir == 0 and dy < 0 and math.abs(dx) <= math.abs(dy) + 1 then inFacingCone = true
                elseif dir == 1 and dx > 0 and math.abs(dy) <= math.abs(dx) + 1 then inFacingCone = true
                elseif dir == 2 and dy > 0 and math.abs(dx) <= math.abs(dy) + 1 then inFacingCone = true
                elseif dir == 3 and dx < 0 and math.abs(dy) <= math.abs(dx) + 1 then inFacingCone = true
                end

                if inFacingCone and dist < bestDist then
                    local tile = Tile(x, y, pPos.z)
                    if tile and tile:getCreatureCount() > 0 then
                        for i = 1, tile:getCreatureCount() do
                            local c = tile:getCreatures()[i]
                            if c and c:isMonster() and not c:isPokemon() and c:getHealth() > 0 then
                                bestTarget = c
                                bestDist = dist
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    if not bestTarget then
        bestDist = maxDist + 1
        for x = pPos.x - maxDist, pPos.x + maxDist do
            for y = pPos.y - maxDist, pPos.y + maxDist do
                local dist = math.max(math.abs(x - pPos.x), math.abs(y - pPos.y))
                if dist <= maxDist and dist > 0 and dist < bestDist then
                    local tile = Tile(x, y, pPos.z)
                    if tile and tile:getCreatureCount() > 0 then
                        for i = 1, tile:getCreatureCount() do
                            local c = tile:getCreatures()[i]
                            if c and c:isMonster() and not c:isPokemon() and c:getHealth() > 0 then
                                bestTarget = c
                                bestDist = dist
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

-- Quebra Arbustos (2767) e Rochas/Cristais (3610, 3615, 8637) próximos aos ataques
function PokeDungeon.checkDestructibleProps(player, centerPos, radius)
    if not centerPos then return end
    for x = centerPos.x - radius, centerPos.x + radius do
        for y = centerPos.y - radius, centerPos.y + radius do
            local tile = Tile(x, y, centerPos.z)
            if tile and tile:getItems() then
                for i = #tile:getItems(), 1, -1 do
                    local it = tile:getItems()[i]
                    if it then
                        local id = it:getId()
                        local tPos = Position(x, y, centerPos.z)
                        if id == 2767 then
                            -- Arbusto Cortável -> Dropa Berry Curativa (2677/2680) ou Safira de EXP (2146)
                            it:remove()
                            tPos:sendMagicEffect(CONST_ME_SMALLPLANTS)
                            Game.sendAnimatedText(tPos, "CORTOU!", TEXTCOLOR_LIGHTGREEN)
                            local roll = math.random(1, 100)
                            if roll <= 45 then
                                Game.createItem(2677, 1, tPos) -- Oran Berry (Blueberry)
                            elseif roll <= 70 then
                                Game.createItem(2680, 1, tPos) -- Sitrus Berry (Strawberry)
                            else
                                Game.createItem(2146, 1, tPos) -- Safira de EXP
                            end
                        elseif id == 3610 or id == 3615 or id == 8637 then
                            -- Rocha / Cristal Quebrável -> Dropa Esmeralda/Rubi de EXP ou Crystal Coin!
                            it:remove()
                            tPos:sendMagicEffect(CONST_ME_GROUNDSHAKER)
                            Game.sendAnimatedText(tPos, "QUEBROU!", TEXTCOLOR_ORANGE)
                            local roll = math.random(1, 100)
                            if roll <= 55 then
                                Game.createItem(2149, 1, tPos) -- Esmeralda de EXP (40 EXP)
                            elseif roll <= 85 then
                                Game.createItem(2677, 1, tPos) -- Berry Curativa
                            else
                                Game.createItem(2147, 1, tPos) -- Rubi de EXP (85 EXP)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Checa Efeitos Físicos dos Pisos dos Biomas (Gelo Escorregadio, Magma Vulcânico, Pântano) e Healers Selvagens
function PokeDungeon.checkTerrainAndEnemyBehaviors(player)
    local pPos = player:getPosition()
    local tile = Tile(pPos)
    if tile and tile:getGround() then
        local gId = tile:getGround():getId()
        -- Piso de Gelo (8570): Patinação rápida com faíscas de gelo!
        if gId == 8570 and math.random(1, 100) <= 35 then
            pPos:sendMagicEffect(CONST_ME_ICEAREA)
            Game.sendAnimatedText(pPos, "SLIDE!", TEXTCOLOR_LIGHTBLUE)
        -- Piso de Magma Ardente (3264): Cura Pokémon de Fogo ou aquece a arena!
        elseif gId == 3264 and math.random(1, 100) <= 25 then
            local charData = PokeDungeon.config.characters[PokeDungeon.getPlayerPoke(player)]
            local isFire = charData and isInArray(charData.types or {}, "fire")
            if isFire and player:getHealth() < player:getMaxHealth() then
                local heal = math.floor(player:getMaxHealth() * 0.03)
                player:addHealth(heal)
                pPos:sendMagicEffect(CONST_ME_FIREAREA)
                Game.sendAnimatedText(pPos, "+" .. heal, TEXTCOLOR_ORANGE)
            end
        end
    end

    -- Comportamento de Inimigos Healers (Chansey, Clefairy, Wigglytuff, Oddish): Curam aliados próximos
    local guid = player:getGuid()
    local st = PokeDungeon.playerState[guid]
    local nowSec = os.time()
    if st and (not st.lastEnemyHealTick or (nowSec - st.lastEnemyHealTick >= 4)) then
        st.lastEnemyHealTick = nowSec
        for x = pPos.x - 7, pPos.x + 7 do
            for y = pPos.y - 7, pPos.y + 7 do
                local t = Tile(x, y, pPos.z)
                if t and t:getCreatureCount() > 0 then
                    for i = 1, t:getCreatureCount() do
                        local c = t:getCreatures()[i]
                        if c and c:isMonster() and PokeDungeon.ENEMY_BEHAVIORS.healers[c:getName()] then
                            local cPos = c:getPosition()
                            cPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
                            Game.sendAnimatedText(cPos, "HEAL!", TEXTCOLOR_LIGHTGREEN)
                            for hx = cPos.x - 2, cPos.x + 2 do
                                for hy = cPos.y - 2, cPos.y + 2 do
                                    local ht = Tile(hx, hy, cPos.z)
                                    if ht and ht:getCreatureCount() > 0 then
                                        for j = 1, ht:getCreatureCount() do
                                            local ally = ht:getCreatures()[j]
                                            if ally and ally:isMonster() and ally:getHealth() < ally:getMaxHealth() then
                                                ally:addHealth(math.floor(ally:getMaxHealth() * 0.15))
                                                ally:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
                                            end
                                        end
                                    end
                                end
                            end
                            return
                        end
                    end
                end
            end
        end
    end
end

-- Checa proximidade com Altares de Poder, Fontes Curativas e Baús
function PokeDungeon.checkArenaInteractables(player)
    local guid = player:getGuid()
    local st = PokeDungeon.playerState[guid]
    if not st then return end
    if not st.altarCooldowns then st.altarCooldowns = {} end
    if not st.springCooldowns then st.springCooldowns = {} end

    local pPos = player:getPosition()
    local nowSec = os.time()

    -- 1. Altares de Poder
    for idx, altar in ipairs(PokeDungeon.config.altars) do
        local dist = math.max(math.abs(pPos.x - altar.pos.x), math.abs(pPos.y - altar.pos.y))
        local readyAt = st.altarCooldowns[idx] or 0
        if dist <= 1 and nowSec >= readyAt then
            st.altarCooldowns[idx] = nowSec + 45
            PokeDungeon.applyBuff(player, altar.buff)
            altar.pos:sendMagicEffect(CONST_ME_FIREWORK_RED)
            Game.sendAnimatedText(altar.pos, "ALTAR!", TEXTCOLOR_YELLOW)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[ALTAR DE PODER] " .. altar.label .. " ativado por 30s!")
        end
    end

    -- 2. Fontes Curativas (Mananciais)
    for idx, spring in ipairs(PokeDungeon.config.springs) do
        local dist = math.max(math.abs(pPos.x - spring.pos.x), math.abs(pPos.y - spring.pos.y))
        local lastTick = st.springCooldowns[idx] or 0
        if dist <= 1 and (nowSec - lastTick) >= 2 then
            if player:getHealth() < player:getMaxHealth() then
                st.springCooldowns[idx] = nowSec
                local healAmt = math.floor(player:getMaxHealth() * 0.12)
                player:addHealth(healAmt)
                pPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                Game.sendAnimatedText(pPos, "+" .. healAmt, TEXTCOLOR_LIGHTGREEN)
            end
        end
    end

    -- 3. Baús de Tesouro na Arena (Raio 1 SQM)
    for x = pPos.x - 1, pPos.x + 1 do
        for y = pPos.y - 1, pPos.y + 1 do
            local tile = Tile(x, y, pPos.z)
            if tile and tile:getItems() then
                for i = #tile:getItems(), 1, -1 do
                    local it = tile:getItems()[i]
                    if it and it:getId() == 1740 then
                        local cPos = it:getPosition()
                        it:remove()
                        cPos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                        cPos:sendMagicEffect(CONST_ME_GIFT_WRAPS)
                        Game.sendAnimatedText(cPos, "TESOURO!", TEXTCOLOR_YELLOW)
                        player:addItem(2160, 3)

                        -- Equipa um Held Item inédito ou dá Level Up imediato
                        local unownedHeld = {}
                        for hKey, _ in pairs(PokeDungeon.HELD_ITEMS) do
                            if not PokeDungeon.hasHeldItem(player, hKey) then
                                table.insert(unownedHeld, hKey)
                            end
                        end
                        if #unownedHeld > 0 then
                            local chosenHeld = unownedHeld[math.random(1, #unownedHeld)]
                            PokeDungeon.addHeldItem(player, chosenHeld)
                        else
                            local curLvl = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
                            PokeDungeon.addRunExp(player, PokeDungeon.getExpForLevel(curLvl))
                        end
                    end
                end
            end
        end
    end
end

function PokeDungeon.startAutoAttackLoop(playerId)
    local player = Player(playerId)
    if not player then return end
    if player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) ~= 1 or player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then
        return
    end

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    local st = PokeDungeon.playerState[guid]
    if not st.moveCooldowns then
        st.moveCooldowns = {}
    end

    -- 1. Coleta automática magnética de Gemas de EXP, Berries Curativas e Moedas
    PokeDungeon.checkMagnetPickup(player)

    -- 2. Interação automática com Altares, Fontes, Baús e Pisos de Bioma
    PokeDungeon.checkArenaInteractables(player)
    PokeDungeon.checkTerrainAndEnemyBehaviors(player)

    -- 3. Regeneração contínua de Vida (Trait Regeneração + Held Item Leftovers + Clima)
    local nowSec = os.time()
    if not st.lastRegenTick or (nowSec - st.lastRegenTick >= 1) then
        st.lastRegenTick = nowSec
        local regenLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_REGEN))
        local totalHeal = regenLvl * 15
        if PokeDungeon.hasHeldItem(player, "leftovers") then
            totalHeal = totalHeal + math.floor(player:getMaxHealth() * 0.04)
        end
        if totalHeal > 0 and player:getHealth() < player:getMaxHealth() then
            player:addHealth(totalHeal)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end

        -- Efeito visual sutil de Clima Dinâmico a cada 4 segundos
        if st.weather and st.weather ~= "clear" and (nowSec % 4 == 0) then
            local wData = PokeDungeon.WEATHERS[st.weather]
            if wData and wData.effect ~= CONST_ME_NONE then
                local pPos = player:getPosition()
                Position(pPos.x + math.random(-4, 4), pPos.y + math.random(-4, 4), pPos.z):sendMagicEffect(wData.effect)
            end
        end
    end

    -- 4. Auto-Ataque Direcionado com Precisão em Milissegundos (os.mtime)
    local nowMs = (os.mtime and os.mtime()) or (os.time() * 1000)
    local unlocked = PokeDungeon.getUnlockedMoves(player)
    local speciesName = PokeDungeon.getCurrentSpeciesName(player)
    local aimTarget = PokeDungeon.findAimTarget(player, 7)

    for i, mInfo in ipairs(unlocked) do
        local mName = mInfo.name
        local lastCast = st.moveCooldowns[mName] or 0
        local effectiveCd = PokeDungeon.getEffectiveMoveCooldown(player, mInfo)

        if (nowMs - lastCast) >= effectiveCd then
            local casted = PokeDungeon.executeSurvivorMove(player, speciesName, i, mInfo, aimTarget)
            if casted then
                st.moveCooldowns[mName] = nowMs
            end
        end
    end

    PokeDungeon.autoAttackEvents[guid] = addEvent(PokeDungeon.startAutoAttackLoop, 250, playerId)
end

-- Auxiliar para aplicar dano em todos os monstros selvagens dentro de um tile ou raio
local function damageMonstersInRadius(player, centerPos, radius, combatType, minDmg, maxDmg, effect)
    local hitCount = 0
    for x = centerPos.x - radius, centerPos.x + radius do
        for y = centerPos.y - radius, centerPos.y + radius do
            local tile = Tile(x, y, centerPos.z)
            if tile and tile:getCreatureCount() > 0 then
                for i = 1, tile:getCreatureCount() do
                    local c = tile:getCreatures()[i]
                    if c and c:isMonster() and not c:isPokemon() and c:getHealth() > 0 then
                        doTargetCombatHealth(player.uid, c.uid, combatType, -math.floor(minDmg), -math.floor(maxDmg), effect)
                        hitCount = hitCount + 1
                    end
                end
            end
        end
    end
    return hitCount
end

-- Engine Completa de Arquétipos de Combate do Poketestes by Raph
-- Executa orbit, chain, boomerang, nova, trail, meteor, aura, cone, beam, projectile + Golpe+!
function PokeDungeon.executeMoveArchetype(player, mInfo, aimTarget)
    local mName = mInfo.name:lower()
    local evoMeta = PokeDungeon.MOVE_EVOLUTIONS[mName] or {
        kind = "projectile",
        combat = COMBAT_ENERGYDAMAGE,
        effect = CONST_ME_ENERGYHIT,
        missile = CONST_ANI_ENERGY
    }

    local kind = evoMeta.kind or "projectile"
    local pPos = player:getPosition()
    local basePower = player:getTotalMagicAttack()
    local minDmg = math.floor(basePower * 0.85)
    local maxDmg = math.floor(basePower * 1.25)

    -- Quebra arbustos e rochas próximas ao jogador e ao alvo!
    PokeDungeon.checkDestructibleProps(player, pPos, 2)
    if aimTarget then
        PokeDungeon.checkDestructibleProps(player, aimTarget:getPosition(), 2)
    end

    -- 1. ARQUÉTIPO ORBIT (Anel Giratório ao redor do Pokémon: Fire Spin, Spark, Magical Leaf, Twister, Gyro Ball, Swift)
    if kind == "orbit" then
        local ringOffsets = {
            {x = 0, y = -2}, {x = 2, y = -2}, {x = 2, y = 0}, {x = 2, y = 2},
            {x = 0, y = 2},  {x = -2, y = 2}, {x = -2, y = 0}, {x = -2, y = -2}
        }
        for i = 1, #ringOffsets do
            local curOff = ringOffsets[i]
            local nextOff = ringOffsets[(i % #ringOffsets) + 1]
            local posA = Position(pPos.x + curOff.x, pPos.y + curOff.y, pPos.z)
            local posB = Position(pPos.x + nextOff.x, pPos.y + nextOff.y, pPos.z)
            doSendDistanceShoot(posA, posB, evoMeta.missile)
            posA:sendMagicEffect(evoMeta.effect)
        end
        damageMonstersInRadius(player, pPos, mInfo.evolved and 3 or 2, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)

    -- 2. ARQUÉTIPO CHAIN (Ricochete em Cadeia entre Monstros: Thunder Shock, Psyshock, Ancient Power, Quick Attack, Feint Attack)
    elseif kind == "chain" and aimTarget then
        local maxJumps = mInfo.evolved and 5 or 3
        local hitIds = {}
        local currTarget = aimTarget
        local prevPos = pPos

        for jump = 1, maxJumps do
            if not currTarget or not currTarget:isMonster() or currTarget:getHealth() <= 0 then break end
            local tPos = currTarget:getPosition()
            hitIds[currTarget:getId()] = true
            doSendDistanceShoot(prevPos, tPos, evoMeta.missile)
            doTargetCombatHealth(player.uid, currTarget.uid, evoMeta.combat, -minDmg, -maxDmg, evoMeta.effect)
            if jump > 1 then
                Game.sendAnimatedText(tPos, "CHAIN!", TEXTCOLOR_LIGHTBLUE)
            end
            prevPos = tPos

            -- Procura próximo monstro não atingido em até 4 SQMs
            local nextTarget = nil
            for x = tPos.x - 4, tPos.x + 4 do
                for y = tPos.y - 4, tPos.y + 4 do
                    local tile = Tile(x, y, tPos.z)
                    if tile and tile:getCreatureCount() > 0 then
                        for i = 1, tile:getCreatureCount() do
                            local c = tile:getCreatures()[i]
                            if c and c:isMonster() and not c:isPokemon() and c:getHealth() > 0 and not hitIds[c:getId()] then
                                nextTarget = c
                                break
                            end
                        end
                    end
                    if nextTarget then break end
                end
                if nextTarget then break end
            end
            currTarget = nextTarget
        end

    -- 3. ARQUÉTIPO BOOMERANG (Projétil de Ida e Volta que acerta 2x: Razor Leaf, Bonemerang, Fury Cutter, Air Cutter, Night Slash)
    elseif kind == "boomerang" and aimTarget then
        local tPos = aimTarget:getPosition()
        doSendDistanceShoot(pPos, tPos, evoMeta.missile)
        damageMonstersInRadius(player, tPos, 1, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)

        local playerId = player:getId()
        addEvent(function()
            local pNow = Player(playerId)
            if not pNow or pNow:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then return end
            local returnPos = pNow:getPosition()
            doSendDistanceShoot(tPos, returnPos, evoMeta.missile)
            Game.sendAnimatedText(tPos, "RETURN!", TEXTCOLOR_LIGHTGREEN)
            damageMonstersInRadius(pNow, tPos, mInfo.evolved and 2 or 1, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)
        end, 320)

    -- 4. ARQUÉTIPO NOVA (Explosão Radial em 8 Direções: Surf, Leaf Storm, Earthquake, Psychic, Dark Pulse, Dynamic Punch)
    elseif kind == "nova" then
        local dirs = {
            {x = 0, y = -3}, {x = 3, y = -3}, {x = 3, y = 0}, {x = 3, y = 3},
            {x = 0, y = 3},  {x = -3, y = 3}, {x = -3, y = 0}, {x = -3, y = -3}
        }
        for _, d in ipairs(dirs) do
            local outPos = Position(pPos.x + d.x, pPos.y + d.y, pPos.z)
            doSendDistanceShoot(pPos, outPos, evoMeta.missile)
            outPos:sendMagicEffect(evoMeta.effect)
        end
        damageMonstersInRadius(player, pPos, mInfo.evolved and 4 or 3, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)

    -- 5. ARQUÉTIPO TRAIL (Rastro Elemental Persistente no Chão: Flame Wheel, Acid, Muddy Water)
    elseif kind == "trail" then
        local trailPositions = { pPos }
        if aimTarget then
            local tPos = aimTarget:getPosition()
            local midPos = Position(math.floor((pPos.x + tPos.x) / 2), math.floor((pPos.y + tPos.y) / 2), pPos.z)
            table.insert(trailPositions, midPos)
            table.insert(trailPositions, tPos)
        end
        local playerId = player:getId()
        for tick = 0, 2 do
            addEvent(function()
                local pNow = Player(playerId)
                if not pNow or pNow:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then return end
                for _, trPos in ipairs(trailPositions) do
                    trPos:sendMagicEffect(evoMeta.effect)
                    damageMonstersInRadius(pNow, trPos, 1, evoMeta.combat, math.floor(minDmg * 0.65), math.floor(maxDmg * 0.65), evoMeta.effect)
                end
            end, tick * 550)
        end

    -- 6. ARQUÉTIPO METEOR (Chuva de Meteoros/Trovões do Céu: Draco Meteor, Thunder, Blizzard, Rock Slide, Earth Power, Doom Desire)
    elseif kind == "meteor" then
        local impactTargets = {}
        if aimTarget then
            table.insert(impactTargets, aimTarget:getPosition())
        end
        local extraMeteors = mInfo.evolved and 4 or 2
        for i = 1, extraMeteors do
            local mx = math.max(1822, math.min(1858, pPos.x + math.random(-4, 4)))
            local my = math.max(2252, math.min(2288, pPos.y + math.random(-4, 4)))
            table.insert(impactTargets, Position(mx, my, pPos.z))
        end

        for _, impPos in ipairs(impactTargets) do
            impPos:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
        end

        local playerId = player:getId()
        addEvent(function()
            local pNow = Player(playerId)
            if not pNow or pNow:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then return end
            for _, impPos in ipairs(impactTargets) do
                local skyPos = Position(impPos.x - 2, impPos.y - 2, impPos.z)
                doSendDistanceShoot(skyPos, impPos, evoMeta.missile)
                impPos:sendMagicEffect(evoMeta.effect)
                PokeDungeon.checkDestructibleProps(pNow, impPos, 1)
                damageMonstersInRadius(pNow, impPos, 1, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)
            end
        end, 300)

    -- 7. ARQUÉTIPO AURA (Pulso Circular ao Redor do Jogador: Water Pulse, Confusion, Poison Gas, Bulldoze, Bug Buzz, Iron Tail)
    elseif kind == "aura" then
        local radius = mInfo.evolved and 3 or 2
        for dx = -radius, radius do
            for dy = -radius, radius do
                if math.max(math.abs(dx), math.abs(dy)) == radius then
                    Position(pPos.x + dx, pPos.y + dy, pPos.z):sendMagicEffect(evoMeta.effect)
                end
            end
        end
        damageMonstersInRadius(player, pPos, radius, evoMeta.combat, minDmg, maxDmg, evoMeta.effect)

    -- 8. ARQUÉTIPOS BEAM, CONE E PROJECTILE (Garante Acerto Diagonal e Rajada)
    elseif aimTarget then
        local tPos = aimTarget:getPosition()
        doSendDistanceShoot(pPos, tPos, evoMeta.missile)
        doTargetCombatHealth(player.uid, aimTarget.uid, evoMeta.combat, -minDmg, -maxDmg, evoMeta.effect)
        if kind == "cone" or kind == "beam" then
            damageMonstersInRadius(player, tPos, 1, evoMeta.combat, math.floor(minDmg * 0.75), math.floor(maxDmg * 0.85), evoMeta.effect)
        end
    end

    -- 9. BÔNUS DE EVOLUÇÃO DOURADA (Golpe+): Explosão Secundária Multi-Alvo "PLUS+!"
    if mInfo.evolved and aimTarget and aimTarget:isMonster() and aimTarget:getHealth() > 0 then
        local tPos = aimTarget:getPosition()
        doSendDistanceShoot(pPos, tPos, evoMeta.missile)
        tPos:sendMagicEffect(evoMeta.effect)
        Game.sendAnimatedText(tPos, "PLUS+!", TEXTCOLOR_YELLOW)
        damageMonstersInRadius(player, tPos, 2, evoMeta.combat, math.floor(minDmg * 0.8), math.floor(maxDmg * 0.95), evoMeta.effect)
    end
end

function PokeDungeon.executeSurvivorMove(player, speciesName, moveIdx, moveInfo, aimTarget)
    local mName = moveInfo.name
    local evoMeta = PokeDungeon.MOVE_EVOLUTIONS[mName:lower()]
    local kind = evoMeta and evoMeta.kind or "projectile"
    local canCastWithoutTarget = (kind == "orbit" or kind == "nova" or kind == "aura" or kind == "trail" or kind == "meteor" or kind == "cone" or kind == "beam")

    if not canCastWithoutTarget and not aimTarget then
        return false
    end

    local guid = player:getGuid()
    if PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid].lastCastMove = moveInfo
    end

    if aimTarget then
        player:setTarget(aimTarget)
        local pPos = player:getPosition()
        local tPos = aimTarget:getPosition()
        local dx = tPos.x - pPos.x
        local dy = tPos.y - pPos.y
        local faceDir = DIRECTION_SOUTH
        if math.abs(dx) > math.abs(dy) then
            faceDir = (dx > 0) and DIRECTION_EAST or DIRECTION_WEST
        else
            faceDir = (dy > 0) and DIRECTION_SOUTH or DIRECTION_NORTH
        end
        player:setDirection(faceDir)
    end

    -- Executa a spell nativa do OT + a Engine de Arquétipos do Poketestes by Raph!
    doCreatureCastSpell(player, mName)
    PokeDungeon.executeMoveArchetype(player, moveInfo, aimTarget)

    local displayMove = moveInfo.evolved and (evoMeta and evoMeta.evoName or (mName .. "+")) or mName
    player:say(speciesName .. ", use " .. displayMove .. "!", TALKTYPE_MONSTER_SAY)
    return true
end

-- ====================================================================
-- BOSSES DE ANDAR & ATAQUES TELEGRAFADOS NO CHÃO (TELEGRAPHED AOE)
-- ====================================================================

function PokeDungeon.spawnBoss(player, bossName, isFloorBoss)
    local pPos = player:getPosition()
    local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
    local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]

    local sx = math.max(PokeDungeon.config.arenaArea.from.x + 3, math.min(PokeDungeon.config.arenaArea.to.x - 3, pPos.x + math.random(-5, 5)))
    local sy = math.max(PokeDungeon.config.arenaArea.from.y + 3, math.min(PokeDungeon.config.arenaArea.to.y - 3, pPos.y + math.random(-5, 5)))
    if sx == pPos.x and sy == pPos.y then sx = sx + 3 end

    local spawnPos = Position(sx, sy, pPos.z)
    local boss = Game.createMonster(bossName, spawnPos, false, true, 1, 0)
    if not boss then
        boss = Game.createMonster("Charizard", spawnPos, false, true, 1, 0)
    end
    if not boss then return nil end

    boss:registerEvent("PokeDungeonKill")
    boss:registerEvent("MonsterHealthChange")

    local hpMult = isFloorBoss and 12 or 6
    local bossHp = (floorData.monsterHp or 100) * hpMult
    boss:setMaxHealth(bossHp)
    boss:setHealth(bossHp)
    boss:setSkull(isFloorBoss and SKULL_RED or SKULL_WHITE)
    boss:setTarget(player)

    spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
    spawnPos:sendMagicEffect(CONST_ME_FIREWORK_RED)
    local tag = isFloorBoss and "BOSS DO ANDAR" or "MINI-BOSS"
    Game.sendAnimatedText(spawnPos, tag .. "!", TEXTCOLOR_RED)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("⚠️ [%s] %s apareceu na Arena! Cuidado com os ataques telegrafados no chao!", tag, bossName:upper()))

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    PokeDungeon.playerState[guid].activeBossId = boss:getId()

    if PokeDungeon.bossEvents[guid] then
        stopEvent(PokeDungeon.bossEvents[guid])
    end
    PokeDungeon.bossEvents[guid] = addEvent(PokeDungeon.runBossTelegraphLoop, 3000, player:getId(), boss:getId())
    return boss
end

function PokeDungeon.runBossTelegraphLoop(playerId, bossId)
    local player = Player(playerId)
    local boss = Monster(bossId)
    if not player or not boss or boss:getHealth() <= 0 then
        return
    end
    if player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then
        return
    end

    local pPos = player:getPosition()
    local bPos = boss:getPosition()
    local isArceus = (boss:getName():lower() == "arceus")

    if isArceus then
        boss:say("ARCEUS INVOCA O JULGAMENTO DIVINO (JUDGMENT)!", TALKTYPE_MONSTER_YELL)
        bPos:sendMagicEffect(CONST_ME_HOLYAREA)
    else
        boss:say(boss:getName():upper() .. " PREPARA ATAQUE DEVASTADOR!", TALKTYPE_MONSTER_YELL)
        bPos:sendMagicEffect(CONST_ME_MAGIC_RED)
    end

    -- Define os tiles da zona de impacto (3x3 na posição atual do jogador + meteoros extras se for Arceus!)
    local dangerTiles = {}
    for dx = -1, 1 do
        for dy = -1, 1 do
            local tx = math.max(1821, math.min(1859, pPos.x + dx))
            local ty = math.max(2251, math.min(2289, pPos.y + dy))
            table.insert(dangerTiles, Position(tx, ty, pPos.z))
        end
    end

    if isArceus then
        for i = 1, 3 do
            local rx = math.max(1822, math.min(1858, pPos.x + math.random(-5, 5)))
            local ry = math.max(2252, math.min(2288, pPos.y + math.random(-5, 5)))
            table.insert(dangerTiles, Position(rx, ry, pPos.z))
        end
    end

    -- Pisca os alertas vermelhos no chão em 0ms, 400ms e 800ms
    for _, tPos in ipairs(dangerTiles) do
        tPos:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
    end
    Game.sendAnimatedText(pPos, isArceus and "JUDGMENT!" or "PERIGO!", TEXTCOLOR_RED)

    addEvent(function()
        for _, tPos in ipairs(dangerTiles) do
            tPos:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
        end
    end, 450)

    addEvent(function()
        for _, tPos in ipairs(dangerTiles) do
            tPos:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
        end
    end, 900)

    -- Explode após 1.3s!
    addEvent(function()
        local pNow = Player(playerId)
        if not pNow or pNow:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 then return end
        local curPos = pNow:getPosition()
        local hitPlayer = false

        for _, tPos in ipairs(dangerTiles) do
            tPos:sendMagicEffect(isArceus and CONST_ME_HOLYAREA or CONST_ME_EXPLOSIONHIT)
            tPos:sendMagicEffect(CONST_ME_FIREAREA)
            if curPos.x == tPos.x and curPos.y == tPos.y and curPos.z == tPos.z then
                hitPlayer = true
            end
        end

        if hitPlayer then
            if pNow:getStorageValue(PokeDungeon.STORAGE_GOD_MODE) == 1 then
                Game.sendAnimatedText(curPos, "IMORTAL!", TEXTCOLOR_YELLOW)
            else
                local floorNum = math.max(1, pNow:getStorageValue(PokeDungeon.STORAGE_FLOOR))
                local dmg = math.floor(pNow:getMaxHealth() * (0.12 + floorNum * 0.02))
                pNow:addHealth(-math.min(pNow:getHealth() - 1, dmg))
                Game.sendAnimatedText(curPos, "-" .. dmg, TEXTCOLOR_RED)
            end
        else
            Game.sendAnimatedText(curPos, "ESQUIVOU!", TEXTCOLOR_LIGHTGREEN)
        end
    end, 1300)

    local guid = player:getGuid()
    PokeDungeon.bossEvents[guid] = addEvent(PokeDungeon.runBossTelegraphLoop, isArceus and 3800 or 4500, playerId, bossId)
end

-- ====================================================================
-- SHINIES SELVAGENS, MEOWTH DO TESOURO E CLIMAS DINÂMICOS
-- ====================================================================

function PokeDungeon.spawnWildShiny(player, baseMonsterName)
    local pPos = player:getPosition()
    local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
    local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]
    baseMonsterName = baseMonsterName or floorData.monsters[math.random(1, #floorData.monsters)]

    local shinyName = "Shiny " .. baseMonsterName
    if not MonsterType(shinyName) then
        shinyName = "Shiny Charizard"
    end

    local sx = math.max(1822, math.min(1858, pPos.x + math.random(-6, 6)))
    local sy = math.max(2252, math.min(2288, pPos.y + math.random(-6, 6)))
    local spawnPos = Position(sx, sy, pPos.z)

    local shiny = Game.createMonster(shinyName, spawnPos, false, true, 1, 0)
    if shiny then
        shiny:registerEvent("PokeDungeonKill")
        shiny:registerEvent("MonsterHealthChange")
        local hp = (floorData.monsterHp or 100) * 2
        shiny:setMaxHealth(hp)
        shiny:setHealth(hp)
        shiny:setSkull(SKULL_YELLOW)
        shiny:setTarget(player)
        spawnPos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        Game.sendAnimatedText(spawnPos, "SHINY!", TEXTCOLOR_YELLOW)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "✨ [SHINY SELVAGEM] Um " .. shinyName .. " brilhante apareceu! Derrote-o para 5x EXP e Crystal Coins!")
    end
    return shiny
end

function PokeDungeon.spawnTreasureMeowth(player)
    local pPos = player:getPosition()
    local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
    local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]

    local sx = math.max(1822, math.min(1858, pPos.x + math.random(-6, 6)))
    local sy = math.max(2252, math.min(2288, pPos.y + math.random(-6, 6)))
    local spawnPos = Position(sx, sy, pPos.z)

    local meowth = Game.createMonster("Meowth", spawnPos, false, true, 1, 0)
    if meowth then
        meowth:registerEvent("PokeDungeonKill")
        meowth:registerEvent("MonsterHealthChange")
        local hp = (floorData.monsterHp or 100) * 3
        meowth:setMaxHealth(hp)
        meowth:setHealth(hp)
        meowth:setSkull(SKULL_GREEN)
        spawnPos:sendMagicEffect(CONST_ME_SOUND_YELLOW)
        Game.sendAnimatedText(spawnPos, "TESOURO!", TEXTCOLOR_YELLOW)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "💰 [EVENTO] Um Meowth do Tesouro apareceu carregando gemas e Crystal Coins!")
    end
    return meowth
end

function PokeDungeon.setWeather(player, weatherKey)
    local wData = PokeDungeon.WEATHERS[weatherKey]
    if not wData then return false end
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    PokeDungeon.playerState[guid].weather = weatherKey

    player:getPosition():sendMagicEffect(wData.effect ~= CONST_ME_NONE and wData.effect or CONST_ME_MAGIC_BLUE)
    Game.sendAnimatedText(player:getPosition(), wData.name:upper(), TEXTCOLOR_LIGHTBLUE)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🌦️ [CLIMA DINAMICO] " .. wData.name .. ": " .. wData.desc)
    return true
end

-- ====================================================================
-- SISTEMA DE EXP, ORBS MAGNÉTICAS, BERRIES E LEVEL UP COM EVOLUÇÃO
-- ====================================================================

function PokeDungeon.getExpForLevel(level)
    return math.floor(25 * (level ^ 1.35))
end

function PokeDungeon.checkMagnetPickup(player)
    local pPos = player:getPosition()
    local magnetLvl = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_MAGNET))
    local radius = math.min(8, 2 + magnetLvl)

    for x = pPos.x - radius, pPos.x + radius do
        for y = pPos.y - radius, pPos.y + radius do
            local tile = Tile(x, y, pPos.z)
            if tile then
                local items = tile:getItems()
                if items then
                    for i = #items, 1, -1 do
                        local it = items[i]
                        if it then
                            local id = it:getId()
                            local expVal = 0
                            local berryHealPct = 0
                            if id == 2146 then expVal = 18           -- Safira Azul (18 EXP)
                            elseif id == 2149 then expVal = 40       -- Esmeralda Verde (40 EXP)
                            elseif id == 2147 then expVal = 85       -- Rubi Vermelho (85 EXP)
                            elseif id == 2677 then berryHealPct = 0.15 -- Oran Berry (15% Cura)
                            elseif id == 2680 then berryHealPct = 0.25 -- Sitrus Berry (25% Cura)
                            end

                            -- Não remove a safira decorativa fixa das Fontes Curativas
                            local isSpringTile = false
                            for _, sp in ipairs(PokeDungeon.config.springs) do
                                if x == sp.pos.x and y == sp.pos.y then
                                    isSpringTile = true
                                    break
                                end
                            end

                            if expVal > 0 and not isSpringTile then
                                doSendDistanceShoot(it:getPosition(), pPos, CONST_ANI_ENERGY)
                                it:remove()
                                PokeDungeon.addRunExp(player, expVal)
                                pPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                            elseif berryHealPct > 0 then
                                doSendDistanceShoot(it:getPosition(), pPos, CONST_ANI_GREENSTAR)
                                it:remove()
                                local healAmt = math.max(50, math.floor(player:getMaxHealth() * berryHealPct))
                                player:addHealth(healAmt)
                                pPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
                                Game.sendAnimatedText(pPos, "BERRY +" .. healAmt, TEXTCOLOR_LIGHTGREEN)
                            end
                        end
                    end
                end
            end
        end
    end
end

function PokeDungeon.addRunExp(player, amount)
    local metaExp = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_EXP))
    local expMult = 1.0 + (metaExp * 0.15)
    if PokeDungeon.hasHeldItem(player, "lucky_egg") then
        expMult = expMult * 1.40
    end
    local guid = player:getGuid()
    if PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].collectorBoostActive then
        expMult = expMult * 1.25
    end
    if PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].goldenHourUntil and PokeDungeon.playerState[guid].goldenHourUntil > os.time() then
        expMult = expMult * 2.0
    end

    amount = math.floor(amount * expMult)
    local curExp = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_RUN_EXP)) + amount
    local curLvl = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
    local nextExp = PokeDungeon.getExpForLevel(curLvl)

    player:sendTextMessage(MESSAGE_EXPERIENCE, "[EXP] +" .. amount .. " EXP (" .. curExp .. "/" .. nextExp .. ")")

    if curExp >= nextExp then
        curExp = curExp - nextExp
        curLvl = curLvl + 1
        player:setStorageValue(PokeDungeon.STORAGE_RUN_LEVEL, curLvl)
        player:setStorageValue(PokeDungeon.STORAGE_RUN_EXP, curExp)

        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
        player:say("LEVEL UP! Nv. " .. curLvl, TALKTYPE_MONSTER_SAY)

        -- Checa Evolução Automática do Pokémon no Nível 5 (Estágio 2) e Nível 10 (Estágio 3)!
        if curLvl == 5 or curLvl == 10 then
            PokeDungeon.evolvePlayerPokemon(player, false)
        end

        player:addHealth(player:getMaxHealth())
        PokeDungeon.openLevelUpModal(player, curLvl)
    else
        player:setStorageValue(PokeDungeon.STORAGE_RUN_EXP, curExp)
    end
end

-- ====================================================================
-- MODAL WINDOW: ESCOLHA DE 1 ENTRE 3 TRAITS, EVOLUÇÃO DOURADA E HELD ITEMS
-- ====================================================================

function PokeDungeon.generateTraitChoices(player)
    local pokeName = PokeDungeon.getPlayerPoke(player)
    local charData = PokeDungeon.config.characters[pokeName] or PokeDungeon.config.characters["Charizard"]
    local unlocked = PokeDungeon.getUnlockedMoves(player)

    local priorityEvolutions = {}
    local candidatePool = {}

    -- 0. EVOLUÇÕES DOURADAS (Golpes no Nv. 5 prontos para evoluir para Golpe+!)
    for _, u in ipairs(unlocked) do
        if u.level >= 5 and not u.evolved then
            local evoMeta = PokeDungeon.MOVE_EVOLUTIONS[u.name:lower()]
            local evoTitle = evoMeta and evoMeta.evoName or (u.name:upper() .. "+")
            local evoDesc = evoMeta and evoMeta.desc or "Dano x1.85 + Explosao Secundaria Multi-Alvo!"
            table.insert(priorityEvolutions, {
                type = "move_evolve",
                name = u.name,
                title = "🌟 EVOLUCAO DOURADA: " .. evoTitle,
                desc = evoDesc
            })
        end
    end

    -- 1. Upgrades para golpes que o jogador já possui (Nv. 1 a 4 -> até 5)
    for _, u in ipairs(unlocked) do
        if u.level < 5 then
            table.insert(candidatePool, {
                type = "move_upgrade",
                name = u.name,
                level = u.level + 1,
                title = "⚡ Upgrade: " .. u.name:upper() .. " (Nv. " .. (u.level + 1) .. "/5)",
                desc = "+25% de Dano e -15% de Tempo de Recarga."
            })
        end
    end

    -- 2. Desbloquear novos golpes elementais correspondentes ao tipo do Pokémon
    if #unlocked < 6 then
        local elementPool = {}
        for _, elem in ipairs(charData.types or {"normal"}) do
            if PokeDungeon.TYPE_MOVES[elem] then
                for _, m in ipairs(PokeDungeon.TYPE_MOVES[elem]) do
                    table.insert(elementPool, m)
                end
            end
        end
        for _, nm in ipairs(PokeDungeon.TYPE_MOVES["normal"]) do
            table.insert(elementPool, nm)
        end

        for _, mName in ipairs(elementPool) do
            local alreadyHas = false
            for _, u in ipairs(unlocked) do
                if u.name:lower() == mName:lower() then
                    alreadyHas = true
                    break
                end
            end
            if not alreadyHas then
                table.insert(candidatePool, {
                    type = "move_unlock",
                    name = mName,
                    level = 1,
                    title = "🔥 Novo Golpe: " .. mName:upper(),
                    desc = "Adiciona este golpe a sua rotacao automatica."
                })
            end
        end
    end

    -- 3. Held Items Passivos Raros (caso ainda não possua)
    for hKey, hData in pairs(PokeDungeon.HELD_ITEMS) do
        if not PokeDungeon.hasHeldItem(player, hKey) then
            table.insert(candidatePool, {
                type = "held_item",
                key = hKey,
                title = hData.title,
                desc = hData.desc
            })
        end
    end

    -- 4. Atributos Passivos de Sobrevivência
    local statPool = {
        { type = "stat", key = "vigor",  title = "❤️ Vigor (+25% Vida Max)",      desc = "Aumenta a vida maxima em +25% e cura totalmente." },
        { type = "stat", key = "atk",    title = "⚔️ Potencia (+20% Dano)",       desc = "Aumenta o dano de todos os golpes em +20%." },
        { type = "stat", key = "def",    title = "🛡️ Carapaca (+15% Defesa)",     desc = "Reduz todo o dano recebido em +15%." },
        { type = "stat", key = "speed",  title = "👟 Agilidade (+35 Velocidade)", desc = "Aumenta a velocidade de movimento para esquivar." },
        { type = "stat", key = "regen",  title = "💖 Regeneracao (+15 HP/s)",     desc = "Recupera 15 de vida a cada segundo continuamente." },
        { type = "stat", key = "cd",     title = "⏳ Aceleracao (-15% Cooldown)", desc = "Reduz o tempo de recarga de todos os golpes em -15%." },
        { type = "stat", key = "magnet", title = "🧲 Ima Magnetico (+2 SQMs)",    desc = "Aumenta o alcance de atracao das gemas de EXP." },
        { type = "stat", key = "crit",   title = "🎯 Foco Critico (+8% Critico)", desc = "Aumenta a chance de causar Dano Critico (x1.5)." }
    }

    for _, s in ipairs(statPool) do
        table.insert(candidatePool, s)
    end

    local choices = {}
    -- Garante que Evoluções Douradas disponíveis sempre apareçam no topo!
    for _, evo in ipairs(priorityEvolutions) do
        if #choices < 3 then
            table.insert(choices, evo)
        end
    end

    local usedIndices = {}
    local tries = 0
    while #choices < 3 and #choices < (#candidatePool + #priorityEvolutions) and tries < 60 do
        tries = tries + 1
        local idx = math.random(1, #candidatePool)
        if not usedIndices[idx] then
            usedIndices[idx] = true
            table.insert(choices, candidatePool[idx])
        end
    end

    return choices
end

function PokeDungeon.openLevelUpModal(player, newLevel)
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    local st = PokeDungeon.playerState[guid]

    local choices = PokeDungeon.generateTraitChoices(player)
    st.offeredTraits = choices

    local rerollsLeft = st.rerollsLeft or 0
    local prompt = string.format("Escolha 1 Trait para aprimorar sua build (Rerolls disponiveis: %d):", rerollsLeft)
    local window = ModalWindow(PokeDungeon.MODAL_LEVELUP, "⚡ Poketestes by Raph: Subiu para Nivel " .. newLevel .. "! ⚡", prompt)
    window:addButton(1, "Escolher")
    if rerollsLeft > 0 then
        window:addButton(3, "Reroll (" .. rerollsLeft .. ")")
    end
    window:addButton(2, "Pular")
    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(2)

    for i, choice in ipairs(choices) do
        window:addChoice(i, choice.title .. " - " .. choice.desc)
    end

    window:sendToPlayer(player)
end

function PokeDungeon.applyTrait(player, trait)
    if not trait then return end

    if trait.type == "move_unlock" then
        local unlocked = PokeDungeon.getUnlockedMoves(player)
        table.insert(unlocked, { name = trait.name, level = 1, cooldown = 2200, evolved = false })
        PokeDungeon.sendPokebar(player)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[TRAIT] Novo golpe desbloqueado: " .. trait.name:upper() .. "!")

    elseif trait.type == "move_upgrade" then
        local unlocked = PokeDungeon.getUnlockedMoves(player)
        for _, u in ipairs(unlocked) do
            if u.name:lower() == trait.name:lower() then
                u.level = trait.level
                u.cooldown = math.max(600, math.floor(u.cooldown * 0.85))
                break
            end
        end
        PokeDungeon.sendPokebar(player)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[TRAIT] Upgrade aplicado em " .. trait.name:upper() .. " (Nv. " .. trait.level .. "/5)!")

    elseif trait.type == "move_evolve" then
        local unlocked = PokeDungeon.getUnlockedMoves(player)
        for _, u in ipairs(unlocked) do
            if u.name:lower() == trait.name:lower() then
                u.level = 6
                u.evolved = true
                u.cooldown = math.max(550, math.floor(u.cooldown * 0.80))
                break
            end
        end
        PokeDungeon.sendPokebar(player)
        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
        Game.sendAnimatedText(player:getPosition(), "EVOLVED+!", TEXTCOLOR_YELLOW)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🌟 [EVOLUCAO DOURADA] Seu golpe " .. trait.name:upper() .. " evoluiu para a forma suprema!")

    elseif trait.type == "held_item" then
        PokeDungeon.addHeldItem(player, trait.key)

    elseif trait.type == "stat" then
        if trait.key == "vigor" then
            local curVigor = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_VIGOR)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_VIGOR, curVigor)
            local newMax = math.floor(player:getMaxHealth() * 1.25)
            player:setMaxHealth(newMax)
            player:addHealth(newMax)

        elseif trait.key == "atk" then
            local curAtk = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_ATK)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_ATK, curAtk)

        elseif trait.key == "def" then
            local curDef = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_DEF)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_DEF, curDef)

        elseif trait.key == "speed" then
            local curSpd = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_SPEED)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_SPEED, curSpd)
            player:changeSpeed(35)

        elseif trait.key == "regen" then
            local curReg = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_REGEN)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_REGEN, curReg)

        elseif trait.key == "cd" then
            local curCd = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_CD)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_CD, curCd)
            PokeDungeon.sendPokebar(player)

        elseif trait.key == "magnet" then
            local curMag = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_MAGNET)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_MAGNET, curMag)

        elseif trait.key == "crit" then
            local curCrit = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TRAIT_CRIT)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_TRAIT_CRIT, curCrit)
        end

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[TRAIT] Atributo aprimorado: " .. trait.title .. "!")
    end

    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
end

-- ====================================================================
-- PAINEL DE CONTROLE GM / SANDBOX (!dungeon gm / !dungeon demo)
-- ====================================================================

function PokeDungeon.openDemoModal(player)
    local godOn = (player:getStorageValue(PokeDungeon.STORAGE_GOD_MODE) == 1)
    local shinyOn = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1)
    local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))

    local prompt = string.format("Painel de Controle GM / Sandbox (Andar %d | Invulneravel: %s | Skin Shiny: %s)\nAcione qualquer evento ou mecanica em tempo real para testes:",
        floorNum, godOn and "ATIVO" or "Desligado", shinyOn and "SHINY ✨" or "Normal")

    local window = ModalWindow(PokeDungeon.MODAL_DEMO, "🛠️ Poketestes by Raph: Painel GM / Sandbox", prompt)
    window:addButton(1, "Executar")
    window:addButton(2, "Fechar")
    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(2)

    window:addChoice(1, "⚡ Subir de Nivel Agora (Abrir Janela de 3 Traits)")
    window:addChoice(2, "🌟 Evolucao Dourada Instantanea (Coloca Golpe no Nv.5 e Abre Golpe+)")
    window:addChoice(3, "👹 Invocar BOSS do Andar (Com Ataque Telegrafado no Chao)")
    window:addChoice(4, "✨ Invocar Pokemon SHINY Selvagem + Meowth do Tesouro")
    window:addChoice(5, "🎒 Equipar Todos os Held Items (Leftovers, Life Orb, Focus Sash, Rocky Helmet, Shell Bell)")
    window:addChoice(6, "🌦️ Alternar Clima Dinamico + Ativar Hora Dourada (2x EXP)")
    window:addChoice(7, "🏛️ Spawnar Bau de Tesouro ao Lado e Ativar Todos os Buffs")
    window:addChoice(8, "🗺️ Avancar / Trocar Bioma Grafico da Arena (Andar 1 -> 2 -> 3 -> 4 -> 5 -> 6)")
    window:addChoice(9, "✨ Alternar Skin do Jogador (Normal <-> SHINY)")
    window:addChoice(10, "🛡️ Alternar Invulnerabilidade GM (God-Mode: " .. (godOn and "ATIVO" or "DESLIGADO") .. ")")
    window:addChoice(11, "🧬 Evoluir Meu Pokemon Agora (Estagio 1 -> Estagio 2 -> Estagio 3)")

    window:sendToPlayer(player)
end

function PokeDungeon.handleDemoChoice(player, choiceId)
    -- Se o jogador ainda não estiver na Arena, inicia a Run automaticamente para facilitar a demonstração!
    if player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) ~= 1 and choiceId ~= 9 and choiceId ~= 10 then
        PokeDungeon.startRun(player, PokeDungeon.getPlayerPoke(player), 1)
    end

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    local st = PokeDungeon.playerState[guid]

    if choiceId == 1 then
        local curLvl = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL))
        PokeDungeon.addRunExp(player, PokeDungeon.getExpForLevel(curLvl))

    elseif choiceId == 2 then
        local unlocked = PokeDungeon.getUnlockedMoves(player)
        local targetMove = unlocked[1]
        for _, u in ipairs(unlocked) do
            if not u.evolved then
                targetMove = u
                break
            end
        end
        if targetMove then
            targetMove.level = 5
            targetMove.evolved = false
            local curLvl = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_RUN_LEVEL)) + 1
            player:setStorageValue(PokeDungeon.STORAGE_RUN_LEVEL, curLvl)
            PokeDungeon.openLevelUpModal(player, curLvl)
        end

    elseif choiceId == 3 then
        local floorNum = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
        local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]
        PokeDungeon.spawnBoss(player, floorData.floorBoss or "Mewtwo", true)

    elseif choiceId == 4 then
        PokeDungeon.spawnWildShiny(player)
        PokeDungeon.spawnTreasureMeowth(player)

    elseif choiceId == 5 then
        for hKey, _ in pairs(PokeDungeon.HELD_ITEMS) do
            PokeDungeon.addHeldItem(player, hKey)
        end

    elseif choiceId == 6 then
        local order = {"sun", "rain", "sandstorm", "hail", "fog", "clear"}
        local curW = st.weather or "clear"
        local nextW = "sun"
        for i, w in ipairs(order) do
            if w == curW then
                nextW = order[(i % #order) + 1]
                break
            end
        end
        PokeDungeon.setWeather(player, nextW)
        st.goldenHourUntil = os.time() + 30
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🌟 [HORA DOURADA] 2x EXP e Moedas ativada por 30 segundos!")

    elseif choiceId == 7 then
        local pPos = player:getPosition()
        PokeDungeon.spawnArenaChest(Position(pPos.x + 1, pPos.y, pPos.z))
        for _, bKey in ipairs({"vida", "defesa", "ataque", "velocidade", "cooldown"}) do
            PokeDungeon.applyBuff(player, bKey)
        end

    elseif choiceId == 8 then
        local curFloor = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_FLOOR))
        local nextFloor = (curFloor % #PokeDungeon.config.floors) + 1
        player:setStorageValue(PokeDungeon.STORAGE_MAX_FLOOR, 6)
        PokeDungeon.startRun(player, PokeDungeon.getPlayerPoke(player), nextFloor)

    elseif choiceId == 9 then
        local cur = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1) and 0 or 1
        player:setStorageValue(PokeDungeon.STORAGE_SHINY_SKIN, cur)
        if player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
            local pName = PokeDungeon.getPlayerPoke(player)
            player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, pName)})
            player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "✨ [DEMO] Skin Shiny: " .. (cur == 1 and "ATIVADA!" or "Normal"))

    elseif choiceId == 10 then
        local cur = (player:getStorageValue(PokeDungeon.STORAGE_GOD_MODE) == 1) and 0 or 1
        player:setStorageValue(PokeDungeon.STORAGE_GOD_MODE, cur)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🛡️ [DEMO] Modo Imortal GM (God-Mode): " .. (cur == 1 and "ATIVADO!" or "DESATIVADO"))

    elseif choiceId == 11 then
        PokeDungeon.evolvePlayerPokemon(player, true)
    end
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
            local heal = math.floor(player:getMaxHealth() * 0.5)
            player:addHealth(heal)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "[BUFF] Vigor ativado! +50% de HP recuperado!")
        end
    },
    ["defesa"] = {
        name = "Escudo (Defesa)",
        storage = PokeDungeon.STORAGE_BUFF_DEF,
        effect = CONST_ME_MAGIC_BLUE,
        apply = function(player)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "[BUFF] Escudo ativado! -50% de dano sofrido por 30 segundos!")
        end
    },
    ["ataque"] = {
        name = "Furia (Ataque)",
        storage = PokeDungeon.STORAGE_BUFF_ATK,
        effect = CONST_ME_HITBYFIRE,
        apply = function(player)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "[BUFF] Furia ativada! +60% de dano causado por 30 segundos!")
        end
    },
    ["velocidade"] = {
        name = "Agilidade (Velocidade)",
        storage = PokeDungeon.STORAGE_BUFF_SPD,
        effect = CONST_ME_MAGIC_RED,
        apply = function(player)
            player:changeSpeed(180)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "[BUFF] Agilidade ativada! Super velocidade por 30 segundos!")
        end
    },
    ["cooldown"] = {
        name = "Aceleracao (Cooldown)",
        storage = PokeDungeon.STORAGE_BUFF_CD,
        effect = CONST_ME_FIREWORK_YELLOW,
        apply = function(player)
            PokeDungeon.sendPokebar(player)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "[BUFF] Aceleracao ativada! Cooldowns reduzidos pela metade por 30 segundos!")
        end
    }
}

function PokeDungeon.hasBuff(player, buffKey)
    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return false end
    local expTime = player:getStorageValue(buffInfo.storage)
    return expTime and expTime > os.time()
end

function PokeDungeon.applyBuff(player, buffKey)
    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return false end

    local now = os.time()
    local alreadyActive = PokeDungeon.hasBuff(player, buffKey)
    player:setStorageValue(buffInfo.storage, now + PokeDungeon.config.buffDuration)
    player:getPosition():sendMagicEffect(buffInfo.effect)

    if buffInfo.apply and (not alreadyActive or buffKey ~= "velocidade") then
        buffInfo.apply(player)
    end

    if not alreadyActive then
        PokeDungeon.tickBuffAnimation(player:getId(), buffKey, 0)
    end
    return true
end

function PokeDungeon.tickBuffAnimation(playerId, buffKey, secondsElapsed)
    local player = Player(playerId)
    if not player then return end

    local buffInfo = PokeDungeon.BUFF_TYPES[buffKey]
    if not buffInfo then return end

    local timeLeft = player:getStorageValue(buffInfo.storage) - os.time()
    if timeLeft > 0 then
        if secondsElapsed % 3 == 0 then
            player:getPosition():sendMagicEffect(buffInfo.effect)
        end
        addEvent(PokeDungeon.tickBuffAnimation, 1000, playerId, buffKey, secondsElapsed + 1)
    else
        if buffKey == "velocidade" and player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
            player:changeSpeed(-180)
        elseif buffKey == "cooldown" and player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
            PokeDungeon.sendPokebar(player)
        end
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "[Dungeon] O buff " .. buffInfo.name .. " expirou.")
    end
end

-- ====================================================================
-- ENTRADA, ANDARES E SPAWNER
-- ====================================================================

function PokeDungeon.enterLobby(player)
    if not PokeDungeon.mapInitialized then
        PokeDungeon.buildMap()
    end

    PokeDungeon.revertToTrainer(player)

    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, 1)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "=== BEM-VINDO AO LOBBY DO POKETESTES BY RAPH ===")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Entre no portal Norte para escolher seu Pokemon, contratar Boosts Pre-Run na Loja Kecleon (!dungeon shop) ou voltar ao Centro Pokemon no portal Sul!")
    return true
end

function PokeDungeon.leaveDungeon(player)
    PokeDungeon.revertToTrainer(player)
    player:teleportTo(PokeDungeon.config.templePos)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "[Poketestes by Raph] Voce retornou a cidade com seguranca.")
    return true
end

function PokeDungeon.cleanArena()
    local fromPos = PokeDungeon.config.arenaArea.from
    local toPos = PokeDungeon.config.arenaArea.to

    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tile = Tile(x, y, fromPos.z)
            if tile and tile:getCreatureCount() > 0 then
                for i = tile:getCreatureCount(), 1, -1 do
                    local creature = tile:getCreatures()[i]
                    if creature and creature:isMonster() and not creature:isPokemon() then
                        creature:remove()
                    end
                end
            end
        end
    end
end

-- Inicia a Run com o Pokémon escolhido e gera o Bioma do Andar!
function PokeDungeon.startRun(player, pokeName, floorNum)
    local charData = PokeDungeon.config.characters[pokeName] or PokeDungeon.config.characters["Charizard"]
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then
        PokeDungeon.playerState[guid] = {}
    end
    local st = PokeDungeon.playerState[guid]

    -- Cancela timers anteriores caso esteja trocando de andar
    if PokeDungeon.autoAttackEvents[guid] then stopEvent(PokeDungeon.autoAttackEvents[guid]) end
    if PokeDungeon.spawnerEvents[guid] then stopEvent(PokeDungeon.spawnerEvents[guid]) end
    if PokeDungeon.bossEvents[guid] then stopEvent(PokeDungeon.bossEvents[guid]) end

    -- 1. Ativa Modo PokeView e Estágio Inicial da Linha Evolutiva (Estágio 1 -> 2 -> 3)
    player:setStorageValue(PokeDungeon.STORAGE_POKEVIEW, 1)
    player:setStorageValue(PokeDungeon.STORAGE_ACTIVE, 1)
    if st.pokeName ~= pokeName or not st.evoStage then
        st.evoStage = 1
    end
    st.pokeName = pokeName

    -- 2. Transforma visualmente no Pokémon do Estágio Atual (Normal ou Shiny!)
    player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, pokeName)})

    -- 3. Aplica HP robusto do Pokémon + Meta-Upgrade de Vitalidade!
    local metaHp = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_HP))
    local startHp = math.floor(charData.hp * (1.0 + metaHp * 0.12))
    player:setMaxHealth(startHp)
    player:addHealth(startHp)

    -- 4. Ajusta velocidade + Meta-Upgrade de Passos Leves!
    local metaSpd = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_SPEED))
    local startSpd = charData.speed + (metaSpd * 15)
    player:changeSpeed(-player:getSpeed() + startSpd)

    -- 5. Inicializa dados da Run
    floorNum = floorNum or 1
    player:setStorageValue(PokeDungeon.STORAGE_FLOOR, floorNum)
    local floorData = PokeDungeon.config.floors[floorNum] or PokeDungeon.config.floors[1]
    player:setStorageValue(PokeDungeon.STORAGE_KILLS, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TARGET, floorData.targetKills)
    player:setStorageValue(PokeDungeon.STORAGE_RUN_EXP, 0)
    player:setStorageValue(PokeDungeon.STORAGE_RUN_LEVEL, 1)

    -- Reseta traits da run
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_VIGOR, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_ATK, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_DEF, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_SPEED, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_REGEN, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_CD, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_MAGNET, 0)
    player:setStorageValue(PokeDungeon.STORAGE_TRAIT_CRIT, 0)

    -- Inicia com golpe inicial do Pokémon (+ 2º golpe se tiver Meta-Upgrade Repertório)
    local sMove = charData.startMove or "ember"
    st.unlockedMoves = {
        { name = sMove, level = 1, cooldown = 1350, evolved = false }
    }
    if math.max(0, player:getStorageValue(PokeDungeon.STORAGE_META_MOVES)) >= 1 and charData.secondMove then
        table.insert(st.unlockedMoves, {
            name = charData.secondMove, level = 1, cooldown = 1900, evolved = false
        })
    end

    st.moveCooldowns = {}
    st.heldItems = st.heldItems or {}
    st.focusSashReady = PokeDungeon.hasHeldItem(player, "focus_sash")
    st.rerollsLeft = math.max(1, player:getStorageValue(PokeDungeon.STORAGE_META_REROLL))
    st.midBossSpawned = false
    st.floorBossSpawned = false
    st.activeBossId = nil
    st.altarCooldowns = {}
    st.springCooldowns = {}
    st.floorStartTime = os.time()
    st.collectorBoostActive = false
    st.shinyHunterActive = false

    -- 5.5. Consome e Aplica os Contratos de Expedição Pré-Run (Cash-Sink de 1 Partida)
    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_VANGUARD) == 1 then
        player:setStorageValue(PokeDungeon.STORAGE_BOOST_VANGUARD, 0)
        local extraMove = charData.secondMove or "quick attack"
        local hasExtra = false
        for _, u in ipairs(st.unlockedMoves) do
            if u.name:lower() == extraMove:lower() then hasExtra = true break end
        end
        if not hasExtra then
            table.insert(st.unlockedMoves, { name = extraMove, level = 1, cooldown = 1800, evolved = false })
        else
            table.insert(st.unlockedMoves, { name = "swift", level = 1, cooldown = 1800, evolved = false })
        end
        PokeDungeon.applyBuff(player, "defesa")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🎫 [CONTRATO DE VANGUARDA] Voce iniciou a Run com +1 Golpe Extra e Escudo Protetor de 30s!")
    end

    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_COLLECTOR) == 1 then
        player:setStorageValue(PokeDungeon.STORAGE_BOOST_COLLECTOR, 0)
        player:setStorageValue(PokeDungeon.STORAGE_TRAIT_MAGNET, 2)
        st.collectorBoostActive = true
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🧲 [CONTRATO DO COLECIONADOR] Voce iniciou a Run com Ima Magnetico Nv.2 (+4 SQMs) e +25% EXP!")
    end

    -- 6. Envia Opcode 52 -> Abre Pokébar no client com os golpes!
    PokeDungeon.sendPokebar(player)

    -- 7. Limpa a arena, gera o Bioma procedural + Altares + Fontes e posiciona o jogador
    PokeDungeon.cleanArena()
    PokeDungeon.buildFloorBiome(floorNum)
    player:teleportTo(PokeDungeon.config.arenaPos)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

    -- Aplica o Clima Dinâmico do Andar
    PokeDungeon.setWeather(player, floorData.weather or "clear")

    -- Spawna um Baú de Tesouro inicial na Arena para incentivar exploração
    PokeDungeon.spawnArenaChest(Position(1840, 2263, 7))

    if player:getStorageValue(PokeDungeon.STORAGE_BOOST_SHINY) == 1 then
        player:setStorageValue(PokeDungeon.STORAGE_BOOST_SHINY, 0)
        st.shinyHunterActive = true
        st.rerollsLeft = st.rerollsLeft + 2
        PokeDungeon.spawnArenaChest(Position(1835, 2265, 7))
        PokeDungeon.spawnArenaChest(Position(1845, 2265, 7))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "🍀 [CONTRATO DO CACADOR] 2x Chance Shiny, +2 Rerolls e 2 Baus de Reliquia Extras gerados na Arena!")
    end

    local displayPoke = (player:getStorageValue(PokeDungeon.STORAGE_SHINY_SKIN) == 1) and ("Shiny " .. pokeName) or pokeName
    broadcastMessage("[Poketestes by Raph] " .. player:getName() .. " entrou na Arena como " .. displayPoke .. " (" .. floorData.name .. ")!", MESSAGE_STATUS_WARNING)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "=== " .. floorData.name:upper() .. " INICIADO! ===")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Objetivo: Derrotar " .. floorData.targetKills .. " Pokemons selvagens! Use os 4 Altares nos cantos e as 2 Fontes de Vida!")

    -- 8. Dispara Spawner e Loop de Auto-Ataque Direcionado
    PokeDungeon.runSpawner(player:getId(), floorNum)
    PokeDungeon.startAutoAttackLoop(player:getId())
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
        return
    end

    local alive = PokeDungeon.countAliveMonsters()
    if alive < floorData.maxMonsters then
        local pPos = player:getPosition()
        local spawned = 0

        for i = 1, floorData.spawnAmount do
            if alive + spawned >= floorData.maxMonsters then break end

            -- 6% de chance de spawnar um Pokémon SHINY selvagem (12% com Contrato do Caçador!)
            local guid = player:getGuid()
            local shinyChancePct = (PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].shinyHunterActive) and 12 or 6
            local randomMonster = floorData.monsters[math.random(1, #floorData.monsters)]
            if math.random(1, 100) <= shinyChancePct then
                PokeDungeon.spawnWildShiny(player, randomMonster)
                spawned = spawned + 1
            else
                local angle = math.random() * 2 * math.pi
                local dist = math.random(6, 11)
                local sx = math.floor(pPos.x + math.cos(angle) * dist)
                local sy = math.floor(pPos.y + math.sin(angle) * dist)

                sx = math.max(PokeDungeon.config.arenaArea.from.x + 2, math.min(PokeDungeon.config.arenaArea.to.x - 2, sx))
                sy = math.max(PokeDungeon.config.arenaArea.from.y + 2, math.min(PokeDungeon.config.arenaArea.to.y - 2, sy))

                local spawnPos = Position(sx, sy, pPos.z)
                local monster = Game.createMonster(randomMonster, spawnPos, false, false, 1, 0)
                if monster then
                    monster:registerEvent("PokeDungeonKill")
                    monster:registerEvent("MonsterHealthChange")
                    local targetHp = floorData.monsterHp or 70
                    monster:setMaxHealth(targetHp)
                    monster:setHealth(targetHp)

                    spawnPos:sendMagicEffect(CONST_ME_POFF)
                    monster:setTarget(player)
                    spawned = spawned + 1
                end
            end
        end
    end

    local guid = player:getGuid()
    PokeDungeon.spawnerEvents[guid] = addEvent(PokeDungeon.runSpawner, floorData.spawnInterval, playerId, floorNum)
end

function PokeDungeon.onMonsterKill(player, monster)
    local floorNum = player:getStorageValue(PokeDungeon.STORAGE_FLOOR)
    local floorData = PokeDungeon.config.floors[floorNum]
    if not floorData then return end

    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    local st = PokeDungeon.playerState[guid]

    -- Comportamento Bomber (Voltorb, Electrode, Koffing, Weezing, Geodude, Graveler, Golem): Explode em 3x3 ao morrer!
    if monster and PokeDungeon.ENEMY_BEHAVIORS.bombers[monster:getName()] then
        local mPos = monster:getPosition()
        mPos:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        Game.sendAnimatedText(mPos, "BOOM!", TEXTCOLOR_ORANGE)
        local bombDmg = math.max(40, math.floor((floorData.monsterHp or 100) * 0.65))
        for bx = mPos.x - 1, mPos.x + 1 do
            for by = mPos.y - 1, mPos.y + 1 do
                local bt = Tile(bx, by, mPos.z)
                if bt and bt:getCreatureCount() > 0 then
                    for i = 1, bt:getCreatureCount() do
                        local c = bt:getCreatures()[i]
                        if c and c:isMonster() and c:getId() ~= monster:getId() and c:getHealth() > 1 then
                            c:addHealth(-math.min(c:getHealth() - 1, bombDmg))
                            c:getPosition():sendMagicEffect(CONST_ME_HITBYFIRE)
                        end
                    end
                end
            end
        end
    end

    local currentKills = player:getStorageValue(PokeDungeon.STORAGE_KILLS) + 1
    player:setStorageValue(PokeDungeon.STORAGE_KILLS, currentKills)

    local totalKills = math.max(0, player:getStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS)) + 1
    player:setStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS, totalKills)

    -- Eventos de Mid-Boss (40% da meta) e Boss de Andar (80% da meta)
    local midThreshold = math.max(5, math.floor(floorData.targetKills * 0.40))
    local bossThreshold = math.max(12, math.floor(floorData.targetKills * 0.80))

    if not st.midBossSpawned and currentKills >= midThreshold then
        st.midBossSpawned = true
        PokeDungeon.spawnBoss(player, floorData.midBoss or "Onix", false)
        PokeDungeon.spawnTreasureMeowth(player)
    elseif not st.floorBossSpawned and currentKills >= bossThreshold then
        st.floorBossSpawned = true
        PokeDungeon.spawnBoss(player, floorData.floorBoss or "Gengar", true)
    end

    if math.random(1, 100) <= PokeDungeon.config.buffDropChance then
        local buffList = {"vida", "defesa", "ataque", "velocidade", "cooldown"}
        local selectedBuff = buffList[math.random(1, #buffList)]
        PokeDungeon.applyBuff(player, selectedBuff)
    end

    if currentKills % 5 == 0 or currentKills == floorData.targetKills or currentKills % 50 == 0 then
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "[Poketestes by Raph] Kills: " .. currentKills .. " / " .. floorData.targetKills)
    end

    if currentKills >= floorData.targetKills then
        PokeDungeon.completeFloor(player, floorNum)
    end
end

function PokeDungeon.completeFloor(player, floorNum)
    local floorData = PokeDungeon.config.floors[floorNum]
    PokeDungeon.cleanArena()

    local guid = player:getGuid()
    local startTime = (PokeDungeon.playerState[guid] and PokeDungeon.playerState[guid].floorStartTime) or os.time()
    local duration = math.max(1, os.time() - startTime)

    local maxFloor = math.max(player:getStorageValue(PokeDungeon.STORAGE_MAX_FLOOR), floorNum + 1)
    player:setStorageValue(PokeDungeon.STORAGE_MAX_FLOOR, math.min(6, maxFloor))
    if PokeDungeon.config.floors[floorNum + 1] then
        player:setStorageValue(PokeDungeon.STORAGE_FLOOR, floorNum + 1)
    end

    PokeDungeon.updateLeaderboard(player, floorNum, player:getStorageValue(PokeDungeon.STORAGE_TOTAL_KILLS), duration)

    broadcastMessage("[Poketestes by Raph] PARABENS! " .. player:getName() .. " concluiu o " .. floorData.name .. " em " .. duration .. "s!", MESSAGE_STATUS_WARNING)

    player:addItem(2160, floorNum * 5)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[VITORIA] Voce completou o " .. floorData.name .. "!")
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa: " .. (floorNum * 5) .. " Crystal Coins adicionadas para usar na Loja Kecleon!")

    if PokeDungeon.config.floors[floorNum + 1] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "O proximo andar (" .. (floorNum + 1) .. ") foi desbloqueado! Entre no portal Norte para continuar.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "INCRIVEL! Voce zerou todos os andares da Dungeon!")
    end

    PokeDungeon.revertToTrainer(player)
    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
end

-- ====================================================================
-- MORTE: RETORNA AO LOBBY COMO TREINADOR (ZERO PENALIDADES)
-- ====================================================================

function PokeDungeon.onPlayerDeath(player)
    if player:getStorageValue(PokeDungeon.STORAGE_ACTIVE) ~= 1 then
        return false
    end

    PokeDungeon.cleanArena()
    PokeDungeon.revertToTrainer(player)

    player:teleportTo(PokeDungeon.config.lobbyPos)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "=== VOCE FOI DERROTADO! ===")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Voce retornou ao Lobby sem nenhuma perda. Use suas Crystal Coins na Loja Kecleon e tente novamente!")
    return true
end

-- ====================================================================
-- BANCO DE DADOS E LEADERBOARD
-- ====================================================================

function PokeDungeon.updateLeaderboard(player, floorNum, kills, duration)
    local guid = player:getGuid()
    local playerName = db.escapeString(player:getName())

    local query = string.format([[
        INSERT INTO `dungeon_leaderboard` (`player_id`, `player_name`, `highest_floor`, `total_kills`, `best_time`, `updated_at`)
        VALUES (%d, %s, %d, %d, %d, NOW())
        ON DUPLICATE KEY UPDATE
            `highest_floor` = GREATEST(`highest_floor`, %d),
            `total_kills` = GREATEST(`total_kills`, %d),
            `best_time` = LEAST(IF(`best_time` = 0, 999999, `best_time`), %d);
    ]], guid, playerName, floorNum, kills, duration, floorNum, kills, duration)

    db.asyncQuery(query)
end

function PokeDungeon.showLeaderboard(player)
    local resultId = db.storeQuery([[
        SELECT `player_name`, `highest_floor`, `total_kills`, `best_time`
        FROM `dungeon_leaderboard`
        ORDER BY `highest_floor` DESC, `total_kills` DESC, `best_time` ASC
        LIMIT 10;
    ]])

    local msg = "=== RANKING POKETESTES BY RAPH ===\n\n"
    if resultId ~= false then
        local rank = 1
        repeat
            local name = result.getDataString(resultId, "player_name")
            local floor = result.getDataInt(resultId, "highest_floor")
            local kills = result.getDataInt(resultId, "total_kills")
            local time = result.getDataInt(resultId, "best_time")

            msg = msg .. string.format("#%d %s - Andar: %d | Kills: %d | Tempo: %ds\n", rank, name, floor, kills, time)
            rank = rank + 1
        until not result.next(resultId)
        result.free(resultId)
    else
        msg = msg .. "Nenhum recorde registrado ainda. Seja o primeiro a vencer um andar!"
    end

    player:popupFYI(msg)
    return true
end

-- Metodos de Compatibilidade com Talkactions (!dungeon)
PokeDungeon.openMenu = PokeDungeon.openPokemonSelectModal

function PokeDungeon.setPlayerPoke(player, pokeName)
    if not PokeDungeon.config.characters[pokeName] then return false end
    local guid = player:getGuid()
    if not PokeDungeon.playerState[guid] then PokeDungeon.playerState[guid] = {} end
    PokeDungeon.playerState[guid].pokeName = pokeName
    if player:getStorageValue(PokeDungeon.STORAGE_POKEVIEW) == 1 then
        player:setOutfit({lookType = PokeDungeon.getOutfitForPokemon(player, pokeName)})
    end
    return true
end

function PokeDungeon.startFloor(player, floorNum)
    return PokeDungeon.startRun(player, PokeDungeon.getPlayerPoke(player), floorNum)
end
