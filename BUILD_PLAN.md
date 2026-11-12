# Poketestes by Raph — Arquitetura & Build

> Servidor TFS 1.2 (Protocolo 10.98) com suporte a MariaDB (`poketestes`) e SQLite (`poketestes.sqlite`), Mundo Aberto e Dungeons de Sobrevivência.

---

## Estrutura de Banco de Dados
- **MariaDB (Windows):** `mysqlDatabase = "poketestes"` inicializado automaticamente via `iniciar_servidor.bat` a partir de `schema.sql`.
- **SQLite (Alternativo):** `sqliteDatabase = "poketestes.sqlite"` inicializado a partir de `schema_sqlite.sql`.
- **Contas Padrão Provisionadas no Startup (`startup.lua`):**
  - `su` / `123456` -> Personagem **`SU`** (`GOD group_id = 3`)
  - `survivor` / `123456` -> Personagem **`Survivor`** (`Player group_id = 1`)
