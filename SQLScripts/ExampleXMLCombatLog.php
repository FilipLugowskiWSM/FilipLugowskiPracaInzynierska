<?xml version="1.0" encoding="UTF-8"?>
<Combat>
    <Party>
        <Player1>PlayerA</Player1>
        <Player1Lvl>1</Player1Lvl>

        <Player2>PlayerB</Player1>
        <Player2Lvl>1</Player2Lvl>

        <Player3>PlayerC</Player1>
        <Player3Lvl>1</Player3Lvl>

        <Player4>PlayerD</Player1>
        <Player4Lvl>1</Player4Lvl>
    </Party>
    <Enemies>
        <Enemy1>MonsterA</Enemy1>
        <Enemy1Lvl>1</Enemy1Lvl>

        <Enemy2>MonsterB</Enemy2>
        <Enemy2Lvl>1</Enemy2Lvl>

        <Enemy3>MonsterC</Enemy3>
        <Enemy3Lvl>1</Enemy3Lvl>

        <Enemy4>MonsterD</Enemy4>
        <Enemy4Lvl>1</Enemy4Lvl>
    </Enemies>
    <Fight> 
        <Source>PlayerA</Source>
        <Action>Attack</Acction>
        <Target>MonsterA</Target>
        <Value>10</Value>

        <Source>MonsterA</Source>
        <Action>Attack</Acction>
        <Target>PlayerA</Target>
        <Value>10</Value>

        <Source>PlayerB</Source>
        <Action>Heal</Acction>
        <Target>PlayerA</Target>
        <Value>10</Value>

        <Source>MonsterB</Source>
        <Action>Attack</Acction>
        <Target>PlayerA</Target>
        <Value>10</Value>

        <Source></Source>
        <Action>Death</Acction>
        <Target>MonsterA</Target>
        <Value></Value>
    </Fight>
</Combat>