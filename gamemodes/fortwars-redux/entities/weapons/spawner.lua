AddCSLuaFile()

SWEP.PrintName	= "Fort Builder"
SWEP.Purpose	= "Spawn props to build your fort!"
SWEP.Author		= "Chai"

SWEP.ViewModel	= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel	= "models/weapons/w_toolgun.mdl"
SWEP.HoldType	= "revolver"
SWEP.UseHands	= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Sound			= Sound( "Airboat.FireGunRevDown" )

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Slot		= 0
SWEP.SlotPos	= 5

SWEP.Selected	= 1
Props = {
	{ name = "Block", cost = "10", model = "models/hunter/blocks/cube1x1x1.mdl" },
	{ name = "Platform", cost = "5", model = "models/hunter/plates/plate1x1.mdl" },
	{ name = "Stairs", cost = "10", model = "models/hunter/misc/stair1x1.mdl" }
}
 
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:DoShootEffect( ply, tr )
	self:EmitSound( self.Primary.Sound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	ply:SetAnimation( PLAYER_ATTACK1 )

	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	effectdata:SetStart( ply:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self )
	util.Effect( "ToolTracer", effectdata )
end

SnapDistance = 6

function SWEP:GetLocation( tr, ent )
	local ply = self:GetOwner()
	local hitPos = tr.HitPos
	
	local pos = hitPos
	if ent:OBBCenter().z == 0 then
		pos = pos + Vector( 0, 0, -ent:OBBMins().z )
	end
	local ang = Angle( 0, ply:EyeAngles().y + 180, 0 )
	
	if ply:IsSprinting() then
		ang.y = ang.y - 90
	end
	
	if tr.HitNonWorld then
		local pos2 = tr.Entity:GetPos()
		ang = tr.Entity:GetAngles()
		
		if ply:IsSprinting() then
			ang.y = ang.y - 90
		end
		
		local pos3 = hitPos - pos2
		pos3:Rotate( -ang )
		
		if tr.HitNormal.z > 0.5 then
			-- Do nothing
			if ent:OBBCenter().z ~= 0 then
				pos = pos + Vector( 0, 0, ent:OBBCenter().z )
			end
		elseif math.abs( pos3.x ) > math.abs( pos3.y ) then
			pos = hitPos + tr.HitNormal * ent:OBBMaxs().x
		else
			pos = hitPos + tr.HitNormal * ent:OBBMaxs().y
		end
		
		-- Snap
		pos = pos - pos2
		pos:Rotate( -ang )
		pos = pos + pos2
		
		if math.abs( pos2.x - pos.x ) < SnapDistance then
			pos.x = pos2.x
		end
		if math.abs( pos2.y - pos.y ) < SnapDistance then
			pos.y = pos2.y
		end
		if math.abs( pos2.z - pos.z ) < SnapDistance then
			pos.z = pos2.z
		end
		
		pos = pos - pos2
		pos:Rotate( ang )
		pos = pos + pos2

		if ent:OBBCenter().z ~= 0 then
			pos = pos + Vector( 0, 0, -ent:OBBCenter().z )
		end
	end
	
	return pos, ang
end

function SWEP:PrimaryAttack()
	-- Get player
	local ply = self:GetOwner()
	if !ply:IsValid() then return end
	local tr = ply:GetEyeTrace()
	
	if tr.Hit && !tr.HitSky then
		-- Initialize
		local ent = ents.Create( "fw_prop" )
		if !ent:IsValid() then return end
		ent:SetModel( Props[ self:GetNWInt( "selected", 1 ) ].model )
		
		-- Spawn
		local pos, ang = self:GetLocation( tr, ent )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn()
		
		-- Freeze
		local phys = ent:GetPhysicsObject()
		if !phys:IsValid() then ent:Remove() end
		phys:EnableMotion( false )
		
		self:DoShootEffect( ply, tr )
	end
end

function SWEP:SecondaryAttack()
	-- Get player
	local ply = self:GetOwner()
	if !ply:IsValid() then return end
	local tr = ply:GetEyeTrace()
	
	if tr.Hit && tr.HitNonWorld then
		tr.Entity:Remove()
		self:DoShootEffect( ply, tr )
	end
end

function SWEP:Reload()
	if !self.Owner:KeyPressed( IN_RELOAD ) then return end
	
	local selected = self:GetNWInt( "selected", 1 ) + 1
	if selected > table.Count( Props ) then
		selected = 1
	end
	
	self:SetNWInt( "selected", selected )
	self:GetOwner():ChatPrint( "Selected " .. Props[ selected ].name )
end

function SWEP:Think()
	if CLIENT then
		local ent = self.GhostProp
		local selected = self:GetNWInt( "selected", 1 )
		
		if !IsValid( ent ) then
			-- Create client prop
			self.GhostProp = ents:CreateClientProp()
			ent = self.GhostProp
			
			-- Set properties
			ent:SetModel( Props[ selected ].model )
			ent:SetColor( Color( 255, 255, 255, 127 ) )
			ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
		end
		
		if ent:IsValid() then
			-- Update model
			if self.Selected != selected then
				self.Selected = selected
				ent:SetModel( Props[ selected ].model )
			end
			
			-- Get player
			local ply = self:GetOwner()
			if !ply:IsValid() then return end
			local tr = ply:GetEyeTrace()
			
			if tr.Hit && !tr.HitSky then
				local pos, ang = self:GetLocation( tr, ent )
				ent:SetPos( pos )
				ent:SetAngles( ang )
			end
		end
	end
end

function SWEP:RemoveGhost()
	if CLIENT && self.GhostProp:IsValid() then
		self.GhostProp:Remove()
	end
end

function SWEP:Holster()
	self:RemoveGhost()
	return true
end

function SWEP:OnRemove()
	self:RemoveGhost()
end

function SWEP:OwnerChanged()
	self:RemoveGhost()
end