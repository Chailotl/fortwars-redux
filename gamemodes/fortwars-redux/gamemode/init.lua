AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "UpdateRoundInfo" )

function UpdateRoundInfo()
	net.Start( "UpdateRoundInfo" )
		net.WriteUInt( GAMEMODE.Round )
	net.Send( ply )
end

net.Receive( "UpdateRoundInfo", function( len, ply )
	UpdateRoundInfo()
end )