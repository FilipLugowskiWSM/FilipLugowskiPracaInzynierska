CREATE TABLE Login (
    AccountId       SERIAL PRIMARY KEY  NOT NULL,
    UserId          VARCHAR(20)         NOT NULL,
    UserPass        VARCHAR(20)         NOT NULL, --jak będzie czas to by zmieniało na MD5
    Email           VARCHAR(40)         NOT NULL DEFAULT '',
    Active          BOOLEAN             NOT NULL DEFAULT TRUE,

    UNIQUE(UserID, Email) --Unikalny login by nie bylo takiego samego loginu do dwóch różnych kont.
);

CREATE TABLE Characters (
    CharId                    SERIAL PRIMARY KEY               NOT NULL,
    OwnerAccountId            INT                              NOT NULL,
    CharName                  VARCHAR(20)                      NOT NULL,
    Level                     SMALLINT                         NOT NULL DEFAULT 1,
    Exp                       BIGINT                           NOT NULL DEFAULT 0,
    Skillpoints               SMALLINT                         NOT NULL DEFAULT 1,
    Vit                       SMALLINT                         NOT NULL DEFAULT 0,                              
    Str                       SMALLINT                         NOT NULL DEFAULT 0,
    --Luc                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --Spd                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --Agi                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    --Int                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
    Gold                      INT                              NOT NULL DEFAULT 0,
    --Helmet                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Armour                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --BottomArmour              INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Boots                     INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Gloves                    INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --WeaponSlot1               INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --WeaponSlot2               INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    --Back                      INT                              NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    MaxHP                     INT                              NOT NULL DEFAULT 100,
    HP                        INT                              NOT NULL DEFAULT 100,
    Online                    BOOLEAN                          NOT NULL DEFAULT FALSE,
    LastOnline                TIMESTAMP                            NULL,
    --TitleId                   SMALLINT                         NOT NULL DEFAULT 0, -- ustawienie wyglądu postaci
    InventorySlots            SMALLINT                         NOT NULL DEFAULT 100,
    CPartyId                   INT                             NOT NULL DEFAULT 0, -- 0 oznacza brak party
    CGuildId                   INT                             NOT NULL DEFAULT 0, -- 0 oznacza brak gildii
    UNIQUE(CharName), --Unikalny CharName by nie bylo takiej samej osoby w tablicach wynikow.
    FOREIGN KEY (OwnerAccountId) REFERENCES Login(AccountId),
    FOREIGN KEY (CPartyId) REFERENCES Party(PartyId),
    FOREIGN KEY (CGuildId) REFERENCES Guild(GuildId)
);
CREATE INDEX PlayerOnlineIndex ON Characters (Online);


CREATE TABLE Equipment (
    EqId             SERIAL PRIMARY KEY               NOT NULL,
    EqCharId         INT                              NOT NULL,
    EqItemId         INT                              NOT NULL,
    EAmount          INT                              NOT NULL, 
    Equiped          BOOLEAN                          NOT NULL DEFAULT FALSE,
    FOREIGN KEY (EqCharId) REFERENCES Characters(CharId),
    FOREIGN KEY (EqItemId) REFERENCES Items(ItemId) 
);

CREATE TABLE Storage (
    StorId                SERIAL PRIMARY KEY               NOT NULL,
    StorAcctId            INT                              NOT NULL,
    StorItemId            INT                              NOT NULL,
    SAmount               INT                              NOT NULL,

    FOREIGN KEY (StorAcctId) REFERENCES Login(AccountId),
    FOREIGN KEY (StorItemId) REFERENCES Items(ItemId)
);

CREATE TABLE Items (
    ItemId                            SERIAL PRIMARY KEY              NOT NULL,
    ItemName                          VARCHAR(40)                     NOT NULL,
    Type                              VARCHAR(20)                     NOT NULL,
    Subtype                           VARCHAR(20)                     NOT NULL,
    SellPrice                         INT                                 NULL DEFAULT 10,
    BuyPrice                          INT                                 NULL DEFAULT 10,
    Attack                            INT                                 NULL,
    Defense                           INT                                 NULL,
    OtherValue                        INT                                 NULL,
    MinEquipLevel                     SMALLINT                            NULL DEFAULT 1,
    LocationHelmet                    BOOLEAN                             NULL DEFAULT FALSE,
    LocationArmour                    BOOLEAN                             NULL DEFAULT FALSE,
    LocationBottomArmour              BOOLEAN                             NULL DEFAULT FALSE,
    LocationBoots                     BOOLEAN                             NULL DEFAULT FALSE,
    LocationGloves                    BOOLEAN                             NULL DEFAULT FALSE,
    LocationWeaponSlot1               BOOLEAN                             NULL DEFAULT FALSE,
    LocationWeaponSlot2               BOOLEAN                             NULL DEFAULT FALSE,
    StackAmount                       SMALLINT                            NULL,
    StackInventory                    BOOLEAN                             NULL,
    StackStorage                      BOOLEAN                             NULL,
    StackGuildStorage                 BOOLEAN                             NULL,
    UNIQUE(ItemName)
);
CREATE INDEX ItemIdIndex ON Items (ItemId);

CREATE TABLE Party (
  PartyId             SERIAL PRIMARY KEY            NOT NULL,
  PartyName           VARCHAR(20)                   NOT NULL,
  LeaderId            INT                           NOT NULL,

  FOREIGN KEY (LeaderId) REFERENCES Characters(CharId),
);

CREATE TABLE GuildStorage (
    GuildStorId            SERIAL PRIMARY KEY               NOT NULL,
    SGuildId               INT                              NOT NULL,
    StorItemId             INT                              NOT NULL,
    GAmount                 INT                             NOT NULL,

    FOREIGN KEY (SGuildId) REFERENCES Guild(GuildId),
    FOREIGN KEY (StorItemId) REFERENCES Items(ItemId)
);

CREATE TABLE GuildStorageLog (
    GuildStorId            SERIAL PRIMARY KEY               NOT NULL,
    SGuildId               INT                              NOT NULL,
    StorItemId             INT                              NOT NULL,
    GLogAmount             INT                              NOT NULL,
    ActionTime             TIMESTAMP                        NOT NULL,
    ActionCharId           INT                              NOT NULL,
    FOREIGN KEY (SGuildId) REFERENCES Guild(GuildId),
    FOREIGN KEY (StorItemId) REFERENCES Items(ItemId),
    FOREIGN KEY (ActionCharId) REFERENCES Characters(CharId),
);

CREATE TABLE Guild (
  GuildId             SERIAL PRIMARY KEY              NOT NULL,
  GuildName           VARCHAR(20)                     NOT NULL,
  GmCharId            INT                             NOT NULL,
  MaxMembers          SMALLINT                        NOT NULL DEFAULT 32,

  Unique(GuildName),
  FOREIGN KEY (GmCharId) REFERENCES Characters(CharId)
);

CREATE TABLE GuildExpulsion (
  ExplusionId           SERIAL PRIMARY KEY            NOT NULL,
  ExGuildId             INT                           NOT NULL,
  ExCharId              INT                           NOT NULL,

  FOREIGN KEY (ExGuildId) REFERENCES Guild(GuildId),
  FOREIGN KEY (ExCharId) REFERENCES Characters(CharId)
);

/*
CREATE TABLE GuildMembers (
  GuildMemberId         SERIAL PRIMARY KEY            NOT NULL,
  MGuildId              INT                           NOT NULL,
  GMemberCharId         INT                           NOT NULL,
  Position              SMALLINT                      NOT NULL DEFAULT '0',
  
  FOREIGN KEY (MGuildId) REFERENCES Guild(GuildId),
  FOREIGN KEY (GMemberCharId) REFERENCES Characters(CharId)
);
*/

CREATE TABLE Friends (
  FriendId              SERIAl PRIMARY KEY            NOT NULL,
  CharId1              INT                           NOT NULL,
  CharId2               INT                           NOT NULL,
  FOREIGN KEY (CharId1) REFERENCES Characters(CharId),
  FOREIGN KEY (CharId2) REFERENCES Characters(CharId)
);

CREATE TABLE Store (
  StoreSlotId           SERIAL PRIMARY KEY                NOT NULL,
  StoreItemId           INT                               NOT NULL,
  Price                 INT                               NOT NULL,

  FOREIGN KEY (StoreItemId) REFERENCES Items(ItemId)
);

CREATE TABLE Mobs (
  MobId                     SERIAL PRIMARY KEY                NOT NULL,
  MobName                   VARCHAR(20)                       NOT NULL,
  level                     SMALLINT                          NOT NULL,
  Hp                        INT                               NOT NULL,
  Attack                    INT                               NOT NULL DEFAULT 10,
  Defense                   INT                               NOT NULL DEFAULT 0,
  Vit                       SMALLINT                          NOT NULL DEFAULT 0,
  Str                       SMALLINT                          NOT NULL DEFAULT 0,
  --Luc                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Spd                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Agi                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Int                       SMALLINT                         NOT NULL DEFAULT 0, --wymaga wprowdzanie dodatkowej mechaniki w grze
  --Element                   VARCHAR(20)                          NULL,           --wymaga wprowdzanie dodatkowej mechaniki w grze                              
  --ElementPower              SMALLINT                             NULL,                               
  DropItem1                 INT                                   NULL,
  DropRate1                 SMALLINT                              NULL DEFAULT 1,
  DropOption1               VARCHAR(20)                           NULL, --DropOption jest opcjonalne i może się przydać np. do ustalenia ilości danej rzeczy itd.
  DropItem2                 INT                                   NULL,
  DropRate2                 SMALLINT                              NULL DEFAULT 1,
  DropOption2               VARCHAR(20)                           NULL, --DropOption jest opcjonalne i może się przydać np. do ustalenia ilości danej rzeczy itd.
  DropItem3                 INT                                   NULL,
  DropRate3                 SMALLINT                              NULL DEFAULT 1,
  DropOption3               VARCHAR(20)                           NULL, --DropOption jest opcjonalne i może się przydać np. do ustalenia ilości danej rzeczy itd.
  DropItem4                 INT                                   NULL,
  DropRate4                 SMALLINT                              NULL DEFAULT 1,
  DropOption4               VARCHAR(20)                           NULL, --DropOption jest opcjonalne i może się przydać np. do ustalenia ilości danej rzeczy itd.

  UNIQUE(MobName),
  FOREIGN KEY (DropItem1) REFERENCES Items(ItemId),
  FOREIGN KEY (DropItem2) REFERENCES Items(ItemId),
  FOREIGN KEY (DropItem3) REFERENCES Items(ItemId),
  FOREIGN KEY (DropItem4) REFERENCES Items(ItemId)
);

CREATE TYPE CHATRANGE AS ENUM('O','W','P','G');

CREATE TABLE Chatlog (
  MsgId            BIGSERIAL PRIMARY KEY                NOT NULL,
  MsgTime          TIMESTAMP                            NOT NULL,
  ChatType         CHATRANGE                            NOT NULL DEFAULT 'O', --Open, Whisper, Party, Guild
  SrcCharId        INT                                  NOT NULL,
  DstCharId        INT                                      NULL, --Null w przypadku rozmowy na każdym innym chatcie niż prywatny
  MessageText      VARCHAR(150)                         NOT NULL DEFAULT '',

  FOREIGN KEY (SrcCharId) REFERENCES Characters(CharId),
  FOREIGN KEY (DstCharId) REFERENCES Characters(CharId)
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