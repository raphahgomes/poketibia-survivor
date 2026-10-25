# PokéTibia Survivor · Modo Torre / PokeDungeon (Baiak)

Derivado de ação rápida estilo **Baiak / Survivor** para PokeTibia (protocolo 10.98), baseado no conceito do **PokéSurvivor**.

Neste modo alternativo, você entra na **Torre PokéDungeon** transformado em um Pokémon através do **Modo PokeView**, usando ativamente os golpes e cooldowns (`m1` a `m8`), coletando **buffs temporários de 30 segundos** e enfrentando andares com metas de abates cada vez maiores até o confronto com os Lendários!

---

## 🎮 Mecânicas do Modo de Jogo

### 1. 🐾 Modo PokeView (Você é o Pokémon)
- Ao invés de invocar um summon que te segue, **você se transforma diretamente no Pokémon**!
- Seus atalhos `m1`, `m2`, `m3`, `m4`, `m5`, `m6`, `m7`, `m8` disparam os golpes do Pokémon transformado a partir do seu próprio personagem, com sistema de cooldowns e alcance.
- **Pokémons disponíveis no PokeView:**
  - 🔥 **Charizard**: Scratch, Ember, Flamethrower, Slash, Fireball, Fire Blast, Wing Attack.
  - 💧 **Blastoise**: Bite, Water Gun, Water Pulse, Bubble Beam, Hydro Pump, Skull Bash.
  - 🍃 **Venusaur**: Tackle, Vine Whip, Razor Leaf, Poison Powder, Solar Beam, Leech Seed.
  - 👻 **Gengar**: Lick, Shadow Ball, Night Shade, Hypnosis, Dream Eater, Dark Pulse.
  - ⚡ **Pikachu**: Quick Attack, Thunder Shock, Thunder Wave, Spark, Thunderbolt, Thunder.
  - 🔮 **Alakazam**: Confusion, Psybeam, Psychic, Recover, Calm Mind, Psywave.
  - 🥊 **Lucario**: Quick Attack, Force Palm, Bone Rush, Aura Sphere, Close Combat, Dragon Pulse.

---

### 2. 🏛️ Andares da Torre com Kills Limitadas
Cada andar possui uma meta exata de abates e inimigos com níveis e dificuldades crescentes:

| Andar | Meta de Kills | Nível Inimigo | Tema / Pokémons Selvagens |
|---|---|---|---|
| **Andar 1** | **10** | Lv 15 | Planície Inicial (Rattata, Pidgey, Caterpie, Weedle, Bellsprout) |
| **Andar 2** | **50** | Lv 35 | Caverna Rochosa (Geodude, Zubat, Ekans, Mankey, Sandshrew) |
| **Andar 3** | **100** | Lv 65 | Torre Espectral (Kadabra, Haunter, Machoke, Magneton, Golbat) |
| **Andar 4** | **1.000** | Lv 95 | Horda da Fúria (Gengar, Alakazam, Gyarados, Arcanine, Scizor) |
| **Andar 5** | **2.500** | Lv 135 | Enxame Titânico (Dragonite, Tyranitar, Salamence, Metagross) |
| **Andar 6** | **5.000** | Lv 190 | Apocalipse Lendário (Mewtwo, Rayquaza, Zapdos, Moltres, Lugia) |

Ao atingir a meta do andar:
- A arena é limpa automaticamente.
- Você recebe recompensas (Crystal Coins e EXP).
- O próximo andar é desbloqueado e seu tempo é registrado no Leaderboard!

---

### 3. ⚡ Buffs Temporários de 30 Segundos
Durante as batalhas nos andares, cada monstro abatido tem chance de ativar um **Buff Temporário de 30s**:

- 💚 **Vigor (Vida)**: Restaura 100% da vida imediatamente.
- 🛡️ **Coraza (Defesa)**: -50% de redução de dano recebido durante 30s.
- ⚔️ **Potência (Ataque)**: +60% de dano com todos os movimentos durante 30s.
- 👟 **Agilidade (Velocidade)**: +180 de velocidade de movimento durante 30s.
- ⏱️ **Reflejos (Cooldown)**: -50% no tempo de recarga de todos os golpes (`m1..m8`) durante 30s!

---

### 4. 🔄 Morte Sem Sair do Portal (Respawn no Lobby)
Se a sua vida chegar a zero dentro de qualquer andar da Dungeon:
- Você **NÃO** morre de verdade: não perde nível, skills nem itens!
- É teleportado imediatamente de volta para o **Lobby da Torre** com 100% de vida.
- Você continua dentro da área da Dungeon, podendo mudar de Pokémon ou reiniciar o andar imediatamente.

---

### 5. 🏆 Leaderboard (Placar de Líderes)
O sistema possui persistência no banco de dados (`dungeon_leaderboard`) gravando:
- Maior andar alcançado
- Total acumulado de abates
- Menor tempo de conclusão por andar
- Use `!leaderboard` ou `!dungeon rank` para ver os 10 melhores jogadores!

---

## 🚀 Como Iniciar e Testar (1 Clique)

### Passo 1: Iniciar o Servidor
Dê um duplo clique no arquivo:
```
iniciar_servidor.bat
```
*(Ele verifica o MariaDB local e abre o `pokedashpota_win64.exe` com tudo carregado!)*

### Passo 2: Abrir o Jogo (Cliente)
Dê um duplo clique no arquivo:
```
abrir_jogo.bat
```
*(Abre o cliente OTClient com suporte aos sprites de Pokémon).*

### Contas Prontas para Login:
- **Conta Jogador**:
  - Usuário: `survivor`
  - Senha: `123456`
  - Personagem: `Trainer Survivor`

- **Conta Administrador / GOD**:
  - Usuário: `gm`
  - Senha: `123456`
  - Personagens: `GOD Pota` / `Pota`

---

## 💬 Comandos no Jogo

| Comando | Descrição |
|---|---|
| `!dungeon` | Abre a janela com opções da PokeDungeon |
| `!dungeon enter` | Teleporta diretamente para o Lobby da Dungeon |
| `!dungeon poke <nome>` | Muda sua transformação PokeView (ex: `!dungeon poke Gengar`) |
| `!dungeon floor <1..6>` | Inicia o andar correspondente (ex: `!dungeon floor 1`) |
| `!leaderboard` ou `!dungeon rank` | Exibe o Top 10 jogadores e seus recordes |
| `!dungeon leave` | Retorna ao Templo de Saffron |
| `m1` até `m8` | Dispara os golpes do Pokémon do PokeView |

---

## 📂 Estrutura de Arquivos

```
poketibia-survivor/
├── iniciar_servidor.bat          # Inicia banco + servidor em 1 clique
├── abrir_jogo.bat                # Inicia o cliente de jogo em 1 clique
├── db_data/                      # Banco de dados local MariaDB inicializado
├── pokedashpota1.02_release/
│   ├── pokedashpota1.02_server/  # Servidor C++ Win64 + scripts Lua
│   │   ├── data/lib/pokedungeon.lua               # Core da PokeDungeon & Buffs 30s
│   │   ├── data/talkactions/scripts/dungeon.lua   # Talkaction !dungeon e !leaderboard
│   │   ├── data/talkactions/scripts/summonspells.lua # PokeView cooldowns
│   │   ├── data/creaturescripts/scripts/pokedungeon_death.lua # Respawn no Lobby
│   │   ├── data/creaturescripts/scripts/pokedungeon_kill.lua  # Abates e drops de buffs
│   │   └── pokedashpota_win64.exe                 # Executável do servidor
│   └── pokedashpota1.02_client/  # Cliente de jogo completo com sprites
```
