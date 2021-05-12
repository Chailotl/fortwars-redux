include( "shared.lua" )

function GM:InitPostEntity()
	net.Start( "UpdateRoundInfo" )
	net.SendToServer()
end

net.Receive( "UpdateRoundInfo", function( len, ply )
	GAMEMODE.Round = net.ReadUInt()
end )