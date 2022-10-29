--SQL Script to Create Full DB with one query:

CREATE TABLE Login (
    AccountId       SERIAL PRIMARY KEY  NOT NULL,
    UserId          VARCHAR(20)         NOT NULL,
    UserPass        VARCHAR(20)         NOT NULL,
    Email           VARCHAR(40)         NOT NULL DEFAULT '',
    Active          BOOLEAN             NOT NULL DEFAULT TRUE,

    UNIQUE(UserID, Email)
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
    Gold                      INT                              NOT NULL DEFAULT 0,
    MaxHP                     INT                              NOT NULL DEFAULT 100,
    HP                        INT                              NOT NULL DEFAULT 100,
    Online                    BOOLEAN                          NOT NULL DEFAULT FALSE,
    LastOnline                TIMESTAMP                            NULL,
    InventorySlots            SMALLINT                         NOT NULL DEFAULT 100,
    CPartyId                  INT                              NOT NULL DEFAULT 0,
    CGuildId                  INT                              NOT NULL DEFAULT 0, 
    UNIQUE(CharName),
    FOREIGN KEY (OwnerAccountId) REFERENCES Login(AccountId)
);
CREATE INDEX PlayerOnlineIndex ON Characters (Online);

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

CREATE TABLE Party (
  PartyId             SERIAL PRIMARY KEY            NOT NULL,
  PartyName           VARCHAR(20)                   NOT NULL,
  LeaderId            INT                           NOT NULL,

  FOREIGN KEY (LeaderId) REFERENCES Characters(CharId)
);

CREATE TABLE Guild (
  GuildId             SERIAL PRIMARY KEY              NOT NULL,
  GuildName           VARCHAR(20)                     NOT NULL,
  GmCharId            INT                             NOT NULL,
  MaxMembers          SMALLINT                        NOT NULL DEFAULT 32,

  Unique(GuildName),
  FOREIGN KEY (GmCharId) REFERENCES Characters(CharId)
);

CREATE TABLE GuildStorage (
    GuildStorId            SERIAL PRIMARY KEY               NOT NULL,
    SGuildId               INT                              NOT NULL,
    StorItemId             INT                              NOT NULL,
    GAmount                INT                              NOT NULL,

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
    FOREIGN KEY (ActionCharId) REFERENCES Characters(CharId)
);

CREATE TABLE GuildExpulsion (
  ExplusionId           SERIAL PRIMARY KEY            NOT NULL,
  ExGuildId             INT                           NOT NULL,
  ExCharId              INT                           NOT NULL,

  FOREIGN KEY (ExGuildId) REFERENCES Guild(GuildId),
  FOREIGN KEY (ExCharId) REFERENCES Characters(CharId)
);

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
  DropItem1                 INT                                   NULL,
  DropRate1                 SMALLINT                              NULL DEFAULT 1,
  DropOption1               VARCHAR(20)                           NULL,
  DropItem2                 INT                                   NULL,
  DropRate2                 SMALLINT                              NULL DEFAULT 1,
  DropOption2               VARCHAR(20)                           NULL,
  DropItem3                 INT                                   NULL,
  DropRate3                 SMALLINT                              NULL DEFAULT 1,
  DropOption3               VARCHAR(20)                           NULL,
  DropItem4                 INT                                   NULL,
  DropRate4                 SMALLINT                              NULL DEFAULT 1,
  DropOption4               VARCHAR(20)                           NULL,

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
  ChatType         CHATRANGE                            NOT NULL DEFAULT 'O',
  SrcCharId        INT                                  NOT NULL,
  DstCharId        INT                                      NULL,
  MessageText      VARCHAR(150)                         NOT NULL DEFAULT '',

  FOREIGN KEY (SrcCharId) REFERENCES Characters(CharId),
  FOREIGN KEY (DstCharId) REFERENCES Characters(CharId)
);

ALTER TABLE Characters ADD CONSTRAINT fk_characters_guild
FOREIGN KEY (CGuildId) REFERENCES Guild(GuildId);

ALTER TABLE Characters ADD CONSTRAINT fk_characters_party
FOREIGN KEY (CPartyId) REFERENCES Party(PartyId);