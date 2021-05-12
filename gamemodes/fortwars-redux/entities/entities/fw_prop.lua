AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "Block"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Team" )
	--self:NetworkVar( "Entity", 0, "Player" )
end

function ENT:Initialize()
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMaxHealth( 100 )
		self:SetHealth( 100 )
	end
end

function ENT:OnTakeDamage( dmginfo )
	if dmginfo:IsDamageType( DMG_CLUB ) then
		local health = self:Health() - dmginfo:GetDamage()
		self:SetHealth( health )
		if health <= 0 then
			self:Remove()
		end
	end
end