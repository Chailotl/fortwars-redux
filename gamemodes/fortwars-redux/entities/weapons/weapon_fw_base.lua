SWEP.Author = "Chai"

SWEP.UseHands = true

SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Punch			= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Sound			= Sound( "Weapon_Pistol.Single" )

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self:TakePrimaryAmmo( 1 )

	self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:ViewPunch( Angle( -self.Primary.Punch, 0, 0 ) )

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	return
end