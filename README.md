# ⚡ Poketestes by Raph · Dungeons de Sobrevivência & Mundo Aberto

[![Engine](https://img.shields.io/badge/Server-TFS%201.2%20(Win64)-blue.svg?style=for-the-badge)](https://github.com/otland/forgottenserver)
[![Database](https://img.shields.io/badge/Database-MariaDB%20(poketestes)-orange.svg?style=for-the-badge)](https://mariadb.org/)
[![Client](https://img.shields.io/badge/Client-OTClient%2010.98-green.svg?style=for-the-badge)](https://github.com/edubart/otclient)
[![Project](https://img.shields.io/badge/Project-Poketestes%20by%20Raph-red.svg?style=for-the-badge)](#)

> **Poketestes by Raph** é um servidor completo com **Mundo Aberto** e um modo exclusivo de **Dungeons de Sobrevivência em Tempo Real (Modo PokeView)**.
>
> No Mundo Aberto, o jogador explora o continente como Treinador com **Pokébar, Golpes `m1`–`m12`, Order (Fly, Ride, Surf, Teleport, Blink), Sistema de Boost (`+50`) e Shinies**. Ao entrar na **Estação do Portal no Centro Pokémon de Saffron**, o jogador acessa o **Lobby da Dungeon**, escolhe entre **25 Linhagens de Pokémon** e assume diretamente o controle do Pokémon na Arena (**Modo PokeView**), evoluindo em tempo real durante a partida (**Estágio 1 ➔ Estágio 2 ➔ Estágio 3**)!

---

## 🚀 Como Iniciar e Testar (1-Click)

1. **Iniciar o Servidor e Banco de Dados (`poketestes`):** Execute `iniciar_servidor.bat` (sobe automaticamente o banco MariaDB local, cria/migra a base `poketestes` e inicia o servidor).
2. **Abrir o Cliente:** Execute `abrir_jogo.bat` (suporta múltiplas janelas abertas simultaneamente para testar GM + Jogador ao mesmo tempo).
3. **Contas Pré-Configuradas Automaticamente no Startup:**

| Perfil | Account | Senha | Personagem | Grupo / Permissões |
| :--- | :--- | :--- | :--- | :--- |
| 🛡️ **GM / Admin (Invulnerável)** | `su` | `123456` | **`SU`** | `GOD (group_id = 3)` — Invulnerabilidade ativa no Mundo Aberto e na Arena + Acesso total aos comandos GM (`/cb`, `/m`, `/i`, `/goto`, `/up`, `/down`, `/ghost`, `!dungeon gm`) |
| 🎮 **Jogador Normal** | `survivor` | `123456` | **`Survivor`** | `Player (group_id = 1)` — Experiência real de jogo, progressão normal de dano, uso de Contratos Pré-Run (Cash-Sink) e Kit Mestre de Mundo Aberto |

---

## 🏥 Estação do Portal no Centro Pokémon & Kit Mestre de Mundo Aberto

### 1. Portal Dimensional no Centro Pokémon de Saffron
* Ao entrar no jogo (ou ao sair da Dungeon), o jogador aparece no salão principal do **Centro Pokémon de Saffron (`1054, 1050, 7`)**, de frente para a Nurse Joy.
* Logo ao lado (`2 SQMs a Oeste`, em **`1052, 1050, 7`**), encontra-se o **Portal Dimensional da Dungeon** (com pulso luminoso `"DUNGEON"`), que teleporta o jogador diretamente para o **Lobby (`1805, 2255, 7`)**.
* No Lobby:
  * **Portal Norte (`1805, 2252, 7`):** Abre a seleção das **25 Linhagens de Pokémon**, a **Loja Kecleon (Meta-Upgrades & Contratos Pré-Run)** e o **Painel Sandbox GM**.
  * **Portal Sul (`1805, 2258, 7`):** Retorna com segurança ao **Centro Pokémon de Saffron**.

### 2. Kit Mestre de Mundo Aberto (`!kit` ou Automático no 1º Login)
Para garantir uma experiência completa também fora da Dungeon, todo personagem recebe automaticamente no primeiro login (ou a qualquer momento digitando **`!kit`**) uma **Equipe Completa (Level 100, Boost +50, Love 100)** já sincronizada na **Pokébar**:
* 🔥 **Shiny Charizard [Lv. 100 | Boost +50]** — Habilidade **Fly** (`Order` + `!up`/`!down`) e ataques de Fogo em área (`m1`–`m12`).
* 👻 **Shiny Gengar [Lv. 100 | Boost +50]** — Habilidades **Blink / Teleport** e alto DPS Fantasma/Sombrio.
* 🔮 **Shiny Gardevoir [Lv. 100 | Boost +50]** — Habilidade **Teleport**, cura e controle Psíquico.
* 🥊 **Shiny Lucario [Lv. 100 | Boost +50]** — Lutador/Aço de alta velocidade e dano explosivo.
* 🌊 **Shiny Gyarados [Lv. 100 | Boost +50]** — Habilidade **Surf** e ataques Água/Dragão em área.
* 🛡️ **Shiny Snorlax [Lv. 100 | Boost +50]** — Alta vitalidade e controle de grupo.
* **Ferramentas & Suprimentos:** *Pokédex, Order, Fishing Rod, Rope, Bike, Badge Case, 100 Ultra Balls, 100 Revives, 100 Ultra Potions e 100 Crystal Coins*.

---

## 🌟 Mecânicas da Dungeon (`data/lib/pokedungeon.lua`)

### 1. 25 Linhagens Jogáveis com Evolução In-Run (`Estágio 1 ➔ Estágio 2 ➔ Estágio 3`)
* **Iniciais Gen 1 a 4:**
  * *Charmander ➔ Charmeleon ➔ Charizard* | *Squirtle ➔ Wartortle ➔ Blastoise* | *Bulbasaur ➔ Ivysaur ➔ Venusaur* | *Pikachu ➔ Raichu*
  * *Cyndaquil ➔ Quilava ➔ Typhlosion* | *Totodile ➔ Croconaw ➔ Feraligatr* | *Chikorita ➔ Bayleef ➔ Meganium*
  * *Treecko ➔ Grovyle ➔ Sceptile* | *Torchic ➔ Combusken ➔ Blaziken* | *Mudkip ➔ Marshtomp ➔ Swampert*
  * *Turtwig ➔ Grotle ➔ Torterra* | *Chimchar ➔ Monferno ➔ Infernape* | *Piplup ➔ Prinplup ➔ Empoleon*
* **Clássicos & Pseudo-Lendários:**
  * *Gastly ➔ Haunter ➔ Gengar* | *Abra ➔ Kadabra ➔ Alakazam* | *Machop ➔ Machoke ➔ Machamp* | *Riolu ➔ Lucario* | *Ralts ➔ Kirlia ➔ Gardevoir*
  * *Beldum ➔ Metang ➔ Metagross* | *Gible ➔ Gabite ➔ Garchomp* | *Dratini ➔ Dragonair ➔ Dragonite*
  * *Psyduck ➔ Golduck* | *Slowpoke ➔ Slowbro* | *Lapras* | *Eevee ➔ Espeon ➔ Umbreon*
* **Evolução Automática na Partida:** O jogador inicia no **Estágio 1**, evolui para o **Estágio 2 no Nível 5 da Run** e atinge o **Estágio 3 no Nível 10 da Run** (transformando o sprite automaticamente — inclusive com suporte a **Skins Shiny** em cada estágio —, ganhando `+25% Vida Máx`, `+20 Velocidade` e desbloqueando o 2º golpe assinatura na forma final).

### 2. 17 Tipos Elementais, 90+ Golpes, 10 Arquétipos e Evolução Dourada (`Golpe+`)
* **10 Arquétipos de Combate Automático em 360° (`executeMoveArchetype`):**
  * 🪐 **Orbit (`Fire Spin`, `Magical Leaf`, `Spark`, `Cosmic Power`, `Rollout`, `Twister`, `Gyro Ball`, `Swift`):** Anel orbital de 8 pontos girando ao redor do Pokémon.
  * ⚡ **Chain (`Thunder Shock`, `Psyshock`, `Ancient Power`, `Air Slash`, `Shadow Punch`, `Quick Attack`):** Ricocheteia entre 3 a 5 inimigos próximos (`"CHAIN!"`).
  * 🪃 **Boomerang (`Razor Leaf`, `Bonemerang`, `Fury Cutter`, `Air Cutter`, `Night Slash`):** Atinge na ida e retorna até a posição atual do jogador após `320ms` (`"RETURN!"`).
  * 💥 **Nova (`Fire Blast`, `Surf`, `Leaf Storm`, `Shock Wave`, `Psychic`, `Earthquake`, `Dark Pulse`):** Explosão radial em 8 direções + onda de choque AoE.
  * 🔥 **Trail (`Flame Wheel`, `Muddy Water`, `Acid`):** Deixa zonas elementais temporárias no chão que causam dano contínuo (`"TRAIL!"`).
  * ☄️ **Meteor (`Magma Storm`, `Thunder`, `Future Sight`, `Sludge Bomb`, `Rock Slide`, `Blizzard`, `Draco Meteor`, `Doom Desire`):** Marca zonas de impacto no chão e derruba meteoros do céu após `300ms`.
  * 🌀 **Aura / Cone / Beam / Projectile:** Pulso circular, leque frontal, feixe linear perfurante e projéteis múltiplos.
* **Evolução Dourada (`Golpe Nv. 5` ➔ `Golpe+`):** Ao elevar qualquer golpe ao Nv. 5, o próximo Level Up oferece a carta dourada **`🌟 EVOLUÇÃO DOURADA: GOLPE+`** (`×1.85` de poder + explosão sinérgica secundária `"PLUS+!"`).

### 3. 6 Biomas Gráficos Procedurais, Objetos Destrutíveis, Terrenos e Bosses
1. **Andar 1 — Bosque Umbrio (Floresta Viva):** Clareiras orgânicas, árvores e **arbustos cortáveis (`2767`)** que dropam **Oran/Sitrus Berries** e **Gemas de EXP**. Bosses: *Pidgeotto* & *Fearow*.
2. **Andar 2 — Cueva Cristal (Mina Subterrânea):** Formações rochosas, **cristais luminosos quebráveis (`8637`, `3610`)** e inimigos explosivos (*Voltorb, Koffing, Geodude*). Bosses: *Onix* & *Rhydon*.
3. **Andar 3 — Cementerio Sombrio (Pântano & Cripta):** Árvores mortas, candelabros de caveira, névoa sombria e curandeiros (*Chansey, Golbat*). Bosses: *Haunter* & *Gengar*.
4. **Andar 4 — Glaciar Eterno (Tundra de Gelo):** Pistas de **Gelo Escorregadio (`8570`)** que concedem *Speed Boost*, pinheiros nevados e nevasca. Bosses: *Lapras* & *Articuno*.
5. **Andar 5 — Volcan Ceniza (Caldeira de Magma):** **Fendas de Magma (`3264`)** e pseudo-lendários. Bosses: *Tyranitar* & *Moltres*.
6. **Andar 6 — Ruinas del Juicio (Santuário de Arceus):** Colunas imperiais de mármore branco, estátuas sagradas, hordas de Lendários e o Boss Final **Arceus** invocando o Julgamento Divino (*Judgment*) em múltiplas zonas simultâneas.

---

## 💰 Economia, Cash-Sink (Gold In-Game) & Modelo de Monetização Justa (Zero P2W)

### 1. Cash-Sink In-Game: Contratos de Expedição Pré-Run (`!dungeon shop`)
Para evitar inflação de Gold/Crystal Coins no servidor, a **Loja Kecleon** conta com **3 Contratos Consumíveis (duram exatamente 1 Partida / 1 Run)** comprados com dinheiro do jogo (**Crystal Coins**):
* 🎫 **Contrato de Vanguarda (3 Crystal Coins — 1 Run):** Começa a partida com **+1 Golpe Extra na largada** e **Escudo Protetor de 30s (-50% Dano)**. Acelera o início da partida sem alterar o teto de poder final.
* 🧲 **Contrato do Colecionador (3 Crystal Coins — 1 Run):** Começa a partida com **Ímã Magnético Nv. 2 (+4 SQMs)** e **+25% de EXP** durante aquela Run.
* 🍀 **Contrato do Caçador (5 Crystal Coins — 1 Run):** Dobra a chance de **Shinies Selvagens (de 6% para 12%)**, gera **2 Baús de Relíquia Extras** na largada e concede **+2 Rerolls de Traits**.

### 2. Arquitetura de Monetização Sustentável (Doações / VIP sem Pay-to-Win)
O modo de jogo permite uma monetização altamente atrativa focada em **Cosméticos, Conveniência (QoL) e Variedade Horizontal**:
1. **Skins Shiny, Mega & Efeitos Visuais de Golpes (Cosméticos Puros):**
   - Desbloqueio de **Skins Shiny / Mega / Chroma** para usar no modo PokeView e auras cosméticas de rastro ao caminhar na Arena.
2. **Passe de Temporada (Season Pass — Trilha Gratuita & Trilha Premium):**
   - Missões diárias/semanais dentro da Dungeon (*"Derrote 500 Pokémon no Vulcão"*, *"Evolua 3 Golpes para a Forma Dourada+"*) que recompensam **Outfits de Treinador exclusivos**, **Decorações de House (Troféus de Bosses)** e **Títulos no Ranking**.
3. **Expansão Horizontal de Roster (Desbloqueio Antecipado de Linhagens):**
   - Todas as 25 linhagens têm o mesmo orçamento de balanceamento (*budget* de HP/Speed), podendo ser desbloqueadas jogando (com Crystal Coins/Tokens) ou instantaneamente via Loja de Doação.
4. **Conveniência & Contratos (Nunca Atributos Exclusivos):**
   - **Auto-Loot / Auto-Bank no Mundo Aberto**, **+1 Slot de Reroll ou Banimento de Trait** (permite banir 1 trait indesejada da pool da Run) e **Tickets de Desafio Semanal (Challenge Mode com Ranking próprio)**.

---

## ⌨️ Comandos Rápidos no Chat

* `!dungeon` — Abre o menu de seleção das 25 Linhagens de Pokémon
* `!dungeon shop` — Abre a **Loja Kecleon** (Meta-Upgrades Permanentes + Contratos Pré-Run Cash-Sink + Skin Shiny)
* `!kit` — Entrega/atualiza o **Kit Mestre de Mundo Aberto (6 Pokémon Lv.100 Boost +50 + Suprimentos)**
* `!dungeon gm` — Abre o **Painel de Controle GM / Sandbox** para testar qualquer mecânica instantaneamente
* `!dungeon shiny` — Alterna a Skin Shiny do seu Pokémon na Dungeon
* `!dungeon evolve` — Evolui imediatamente o Pokémon na partida (`Estágio 1 ➔ 2 ➔ 3`)
* `!dungeon boss` — Invoca o Boss do andar atual
* `!dungeon god` — Alterna a invulnerabilidade na Arena
* `!dungeon floor <1..6>` — Inicia diretamente no andar escolhido (`1` a `6`)
* `!dungeon rank` — Exibe o Top 10 Leaderboard persistente (MariaDB `poketestes`)
* `!dungeon leave` — Sai da Dungeon e retorna ao Centro Pokémon de Saffron
