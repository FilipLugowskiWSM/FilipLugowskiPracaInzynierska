CREATE TABLE account (
    id_account       SERIAL PRIMARY KEY  NOT NULL,
    user_login       VARCHAR(20)         NOT NULL,
    user_pass        VARCHAR(20)         NOT NULL, --jak będzie czas to by zmieniało na MD5
    email            VARCHAR(40)         NOT NULL DEFAULT '',
    active           BOOLEAN             NOT NULL DEFAULT TRUE,

    UNIQUE(user_login, email) --Unikalny login by nie bylo takiego samego loginu do dwóch różnych kont.
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
    --luc                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --spd                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --agi                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --int                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    gold                      INT                              NOT NULL DEFAULT 0,
    --Helmet                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Armour                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --BottomArmour              INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Boots                     INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Gloves                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --WeaponSlot1               INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --WeaponSlot2               INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Back                      INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    max_hp                    INT                              NOT NULL DEFAULT 100,
    hp                        INT                              NOT NULL DEFAULT 100,
    is_online                 BOOLEAN                          NOT NULL DEFAULT FALSE,
    last_online               TIMESTAMP                            NULL,
    --TitleId                   SMALLINT                         NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    inventory_slots           SMALLINT                         NOT NULL DEFAULT 100,
    char_party_id             INT                              NOT NULL DEFAULT 0, -- 0 oznacza brak party
    char_guild_id             INT                              NOT NULL DEFAULT 0, -- 0 oznacza brak gildii
    
    UNIQUE(char_name), --Unikalny CharName by nie bylo takiej samej osoby w tablicach wynikow.
    FOREIGN KEY (owner_account_id) REFERENCES account(id_account),
    FOREIGN KEY (char_party_id) REFERENCES party(id_party),
    FOREIGN KEY (char_guild_id) REFERENCES guild(id_guild)
);
CREATE INDEX player_online_index ON characters (is_online);


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

CREATE TABLE party (
  id_party             SERIAL PRIMARY KEY            NOT NULL,
  party_name           VARCHAR(20)                   NOT NULL,
  leader_id            INT                           NOT NULL,

  FOREIGN KEY (leader_id) REFERENCES characters(id_char)
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

CREATE TABLE guild (
  id_guild            SERIAL PRIMARY KEY              NOT NULL,
  guild_name          VARCHAR(20)                     NOT NULL,
  gm_char_id          INT                             NOT NULL,
  max_members         SMALLINT                        NOT NULL DEFAULT 32,

  UNIQUE(guild_name),
  FOREIGN KEY (gm_char_id) REFERENCES characters(id_char)
);

CREATE TABLE guild_expulsion (
  id_ex                 SERIAL PRIMARY KEY            NOT NULL,
  ex_guild_id           INT                           NOT NULL,
  ex_char_id            INT                           NOT NULL,
  ex_message            VARCHAR(150),
  FOREIGN KEY (ex_guild_id) REFERENCES guild(id_guild),
  FOREIGN KEY (ex_char_id) REFERENCES characters(id_char)
);

/*
CREATE TABLE guild_members (
  id_guild_member         SERIAL PRIMARY KEY            NOT NULL,
  member_char_id          INT                           NOT NULL,
  guild_id                INT                           NOT NULL,
  position                SMALLINT                      NOT NULL DEFAULT '0',
  
  FOREIGN KEY (guild_id) REFERENCES guild(id_guild),
  FOREIGN KEY (member_id) REFERENCES characters(id_char)
);
*/

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
  --Luc                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Spd                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Agi                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Int                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Element                   VARCHAR(20)                          NULL,           --wymaga wprowdzanie dodatkowej mechaniki w grze                              
  --ElementPower              SMALLINT                             NULL,                               

  UNIQUE(mob_name)
);

CREATE TABLE mobs_drop (
  id_mobs_drop                SERIAL PRIMARY KEY                NOT NULL,
  id_of_mob                   INT                               NOT NULL,
  drop_item_id                INT                                   NULL,
  drop_rate                   SMALLINT                              NULL DEFAULT 1,
  drop_option                 VARCHAR(20)                           NULL, --DropOption jest opcjonalne i może się przydać

  FOREIGN KEY (drop_item_id) REFERENCES items(id_item)
);

CREATE TYPE CHATTYPE AS ENUM('Open','Whisper','Party','Guild');

CREATE TABLE chat_log (
  id_msg            BIGSERIAL PRIMARY KEY                NOT NULL,
  msg_time          TIMESTAMP                            NOT NULL,
  chat_type         CHATTYPE                             NOT NULL DEFAULT 'Open',
  src_char_id       INT                                  NOT NULL,
  dst_char_id       INT                                      NULL, --Null w przypadku rozmowy na każdym innym chatcie niż prywatny
  msg_text          VARCHAR(150)                         NOT NULL DEFAULT '',

  FOREIGN KEY (src_char_id) REFERENCES characters(id_char),
  FOREIGN KEY (dst_char_id) REFERENCES characters(id_char)
);









/*
https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-unique-constraint/
Zastanowić się nad trigerami, dodatkowymi indexami, proceduramiu składowymi, funkcjami
Jeżeli starczy czasu to dodać tabele dla mechaniki marketu - aukcje i market

Dodatkowe systemy, które jak czas pozwoli to warto dodać:
-Titles
-Achievments
-ChracterArchiveWhenDelte (czekanie 3 dni a następnie usunięcie)
Pseudokod dla zaplanowanej pracy (scheduled job) dla pgAgenta w związku z usunięciem po 3 dniach:
    CREATE SCHEDULED JOBS AccountDelteMechanism
    DELETE Account.* 
    Gdzie/IF/WHERE: AccountDeleteTime.AccountID = Account.ID AND AccountDeleteTime.Date + 3 = now()
    DELETE AccountDeleteTime.* 
    WHERE AccountDeleteTime.Date + 3 = NOW()

    Cascade delete lub po prostu kolejne rozkazy dla pgAgenta o usuwanie kolejnych rekordów w tabelach gdzie jest odpowiedni warunek
    );


Market i aukcje:

CREATE TABLE Auctions (
  AuctionId                   SERIAL PRIMARY KEY               NOT NULL,
  SellerId                    INT                              NOT NULL,
  BuyerId                     INT                              NOT NULL,
  PriceBuyNow                 INT                              NOT NULL,
  AuctionTimestamp            INT                              NOT NULL,
  AuctionItemId               INT                              NOT NULL,
  AuctionItemName             VARCHAR(50)                      NOT NULL,
  ItemType                    VARCHAR(20)                      NOT NULL,
  ItemsAmount                 INT                              NOT NULL DEFAULT 1,

  FOREIGN KEY (SellerId) REFERENCES Characters(CharId),
  FOREIGN KEY (BuyerId) REFERENCES Characters(CharId),
  FOREIGN KEY (AuctionItemId) REFERENCES Items(ItemsId)
);
*/