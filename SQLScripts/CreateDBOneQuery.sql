--SQL Script to Create Full DB with one query:

CREATE TABLE account (
    id_account       SERIAL PRIMARY KEY  NOT NULL,
    user_login       VARCHAR(20)         NOT NULL,
    user_pass        VARCHAR(20)         NOT NULL,
    email            VARCHAR(40)         NOT NULL DEFAULT '',
    active           BOOLEAN             NOT NULL DEFAULT TRUE,

    UNIQUE(user_login, email)
);

CREATE TABLE characters (
    id_char                   SERIAL PRIMARY KEY               NOT NULL,
    owner_account_id          INT                              NOT NULL,
    char_name                 VARCHAR(20)                      NOT NULL,
    char_lvl                  SMALLINT                         NOT NULL DEFAULT 1,
    exp                       BIGINT                           NOT NULL DEFAULT 0,
    skill_points               SMALLINT                         NOT NULL DEFAULT 1,
    vit                       SMALLINT                         NOT NULL DEFAULT 0,                              
    str                       SMALLINT                         NOT NULL DEFAULT 0,
    gold                      INT                              NOT NULL DEFAULT 0,
    max_hp                    INT                              NOT NULL DEFAULT 100,
    hp                        INT                              NOT NULL DEFAULT 100,
    is_online                 BOOLEAN                          NOT NULL DEFAULT FALSE,
    last_online               TIMESTAMP                            NULL,
    inventory_slots           SMALLINT                         NOT NULL DEFAULT 100,
    char_party_id             INT                              NOT NULL DEFAULT 0,
    char_guild_id             INT                              NOT NULL DEFAULT 0,

    UNIQUE(char_name),
    FOREIGN KEY (owner_account_id) REFERENCES account(id_account)
);
CREATE INDEX player_online_index ON characters (is_online);

CREATE TYPE ITEMTYPE AS ENUM('helmet','armour','bottom','boots','gloves','weapon','offhand','potion');

CREATE TABLE items (
    id_item                           SERIAL PRIMARY KEY              NOT NULL,
    item_name                         VARCHAR(40)                     NOT NULL,
    min_equip_lvl                     SMALLINT                            NULL DEFAULT 1,
    item_type                         ITEMTYPE                        NOT NULL,
    sell_price                        INT                                 NULL DEFAULT 10,
    attack                            INT                                 NULL,
    defense                           INT                                 NULL,
    other_value                       INT                                 NULL,
    stack_amount                      SMALLINT                            NULL,

    UNIQUE(item_name)
);
CREATE INDEX id_item_index ON items (id_item);

CREATE TABLE equipment (
    id_equipment             SERIAL PRIMARY KEY               NOT NULL,
    eq_owner_char_id         INT                              NOT NULL,
    eq_item_id               INT                              NOT NULL,
    eq_amount                INT                              NOT NULL, 
    is_equiped               BOOLEAN                          NOT NULL DEFAULT FALSE,
    FOREIGN KEY (eq_owner_char_id) REFERENCES characters(id_char),
    FOREIGN KEY (eq_item_id) REFERENCES items(id_item) 
);

CREATE TABLE storage (
    id_storage            SERIAL PRIMARY KEY               NOT NULL,
    storage_owner_id      INT                              NOT NULL,
    storage_item_id       INT                              NOT NULL,
    storage_item_amount   INT                              NOT NULL,

    FOREIGN KEY (storage_owner_id) REFERENCES account(id_account),
    FOREIGN KEY (storage_item_id) REFERENCES items(id_item)
);

CREATE TABLE party (
  id_party             SERIAL PRIMARY KEY            NOT NULL,
  party_name           VARCHAR(20)                   NOT NULL,
  leader_id            INT                           NOT NULL,

  FOREIGN KEY (leader_id) REFERENCES characters(id_char)
);

CREATE TABLE guild (
  id_guild            SERIAL PRIMARY KEY              NOT NULL,
  guild_name          VARCHAR(20)                     NOT NULL,
  gm_char_id          INT                             NOT NULL,
  max_members         SMALLINT                        NOT NULL DEFAULT 32,

  UNIQUE(guild_name),
  FOREIGN KEY (gm_char_id) REFERENCES characters(id_char)
);

CREATE TABLE guild_storage (
    id_guild_storage            SERIAL PRIMARY KEY               NOT NULL,
    storage_guild_id            INT                              NOT NULL,
    guild_storage_item_id       INT                              NOT NULL,
    guild_item_amount           INT                              NOT NULL,

    FOREIGN KEY (storage_guild_id) REFERENCES guild(id_guild),
    FOREIGN KEY (guild_storage_item_id) REFERENCES items(id_item)
);

CREATE TYPE STORAGEACTION AS ENUM('deposit','withdraw');

CREATE TABLE guild_storage_log (
    id_guild_storage            SERIAL PRIMARY KEY               NOT NULL,
    storage_guild_id            INT                              NOT NULL,
    guild_storage_item_id       INT                              NOT NULL,
    guild_item_amount           INT                              NOT NULL,
    storage_action              STORAGEACTION                    NOT NULL,
    action_time                 TIMESTAMP                        NOT NULL,
    action_char_id              INT                              NOT NULL,
    FOREIGN KEY (storage_guild_id) REFERENCES guild(id_guild),
    FOREIGN KEY (guild_storage_item_id) REFERENCES items(id_item),
    FOREIGN KEY (action_char_id) REFERENCES characters(id_char)
);

CREATE TABLE guild_expulsion (
  id_ex                 SERIAL PRIMARY KEY            NOT NULL,
  ex_guild_id           INT                           NOT NULL,
  ex_char_id            INT                           NOT NULL,
  ex_message            VARCHAR(150),
  FOREIGN KEY (ex_guild_id) REFERENCES guild(id_guild),
  FOREIGN KEY (ex_char_id) REFERENCES characters(id_char)
);

CREATE TABLE friends (
  id_friend            SERIAl PRIMARY KEY            NOT NULL,
  char_id_1              INT                           NOT NULL,
  char_id_2              INT                           NOT NULL,
  FOREIGN KEY (char_id_1) REFERENCES characters(id_char),
  FOREIGN KEY (char_id_2) REFERENCES characters(id_char)
);

CREATE TABLE store (
  id_store           SERIAL PRIMARY KEY                NOT NULL,
  store_item_id      INT                               NOT NULL,
  buy_price          INT                               NOT NULL,

  FOREIGN KEY (store_item_id) REFERENCES items(id_item)
);

CREATE TABLE mobs (
  id_mob                    SERIAL PRIMARY KEY                NOT NULL,
  mob_name                  VARCHAR(20)                       NOT NULL,
  mob_lvl                   SMALLINT                          NOT NULL,
  mob_hp                    INT                               NOT NULL,
  mob_attack                INT                               NOT NULL DEFAULT 10,
  mob_defense               INT                               NOT NULL DEFAULT 0,
  mob_vit                   SMALLINT                          NOT NULL DEFAULT 0,
  mob_str                   SMALLINT                          NOT NULL DEFAULT 0,
  UNIQUE(mob_name)
);

CREATE TABLE mobs_drop (
  id_mobs_drop                SERIAL PRIMARY KEY                NOT NULL,
  drop_mob_id                      INT                               NOT NULL,
  drop_item_id                INT                                   NULL,
  drop_rate                   SMALLINT                              NULL DEFAULT 1,
  drop_option                 VARCHAR(20)                           NULL,

  FOREIGN KEY (drop_mob_id) REFERENCES mobs(id_mob),
  FOREIGN KEY (drop_item_id) REFERENCES items(id_item)
);

CREATE TYPE CHATTYPE AS ENUM('Open','Whisper','Party','Guild');

CREATE TABLE chat_log (
  id_msg            BIGSERIAL PRIMARY KEY                NOT NULL,
  msg_time          TIMESTAMP                            NOT NULL,
  chat_type         CHATTYPE                             NOT NULL DEFAULT 'Open',
  src_char_id       INT                                  NOT NULL,
  dst_char_id       INT                                      NULL,
  msg_text          VARCHAR(150)                         NOT NULL DEFAULT '',

  FOREIGN KEY (src_char_id) REFERENCES characters(id_char),
  FOREIGN KEY (dst_char_id) REFERENCES characters(id_char)
);

ALTER TABLE characters ADD CONSTRAINT fk_characters_party
FOREIGN KEY (char_party_id) REFERENCES party(id_party);

ALTER TABLE characters ADD CONSTRAINT fk_characters_guild
FOREIGN KEY (char_guild_id) REFERENCES guild(id_guild);