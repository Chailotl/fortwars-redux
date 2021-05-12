GM.Name			= "Fortwars Redux"
GM.Author		= "Chai"
GM.Email		= "N/A"
GM.Website		= "N/A"
GM.TeamBased	= true

TEAM_RED	= 1
TEAM_BLUE	= 2

ROUND_WAIT		= 1
ROUND_BUILD		= 2
ROUND_ACTIVE	= 3
ROUND_POST		= 4

function GM:Initialize()
	MsgN( "Fortwars Redux gamemode initializing..." )
	SetGlobalInt( "round_state", ROUND_WAIT )
end

function GM:CreateTeams()
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 0, 0 ) )
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 0, 0, 255 ) )
end