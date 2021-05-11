AddCSLuaFile()

SWEP.Base = "weapon_fw_base"

SWEP.PrintName	= "Dualies"

SWEP.ViewModel	= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.HoldType	= "duel"

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.Delay			= 0.1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Punch			= 1
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Sound			= Sound( "Weapon_Pistol.Single" )

SWEP.Slot		= 1
SWEP.SlotPos	= 5

SWEP.ViewModelFlip1 = true

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self:TakePrimaryAmmo( 1 )

	self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:ViewPunch( self:Clip1() % 2 == 0 && Angle( -self.Primary.Punch, -0.5, 0 ) || Angle( -self.Primary.Punch, 0.5, 0 ) )

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:ShootEffects()
	local side = self:Clip1() % 2 == 0 && 6 || 3
	if CurTime() - 0.1 > self:GetNextPrimaryFire() then side = side - 1 end

	local vm = self:GetOwner():GetViewModel( 0 )
	vm:SendViewModelMatchingSequence( side )
	
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
end