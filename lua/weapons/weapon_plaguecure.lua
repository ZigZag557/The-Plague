
local localPlague = thePlague

SWEP.PrintName = "The Plague Cure"
SWEP.Author = "mind games"
SWEP.Purpose = "Left-click to cure, Right-click to find."

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local HealSound = Sound( "HealthKit.Touch" )

function SWEP:Initialize()

	self:SetHoldType( "slam" )

end

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( true )
	end

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 70,
		filter = self.Owner
	} )

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( false )
	end

	local ent = tr.Entity
	local owner = self:GetOwner()

	if  IsValid( ent ) && ent:IsPlayer() then
		
		if ent.Infected then
			ent:Lock()
			owner:Lock()
			owner:ChatPrint("You are curing "..ent:GetName().."...")
			ent:ChatPrint("You are being cured...")
			timer.Create("cureTime_"..ent:SteamID64(),3,1,function() CurePerson(ent,owner) end)
			local plyID = tostring(ent:SteamID64())
			timer.Remove("thePlague_"..plyID)
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )

		else
			owner:ChatPrint("This person doesn't have the plague.")
		end
	end
end

local function CurePerson(ply,doc)
	ply:UnLock()
	doc:UnLock()
	localPlague.RemoveInfection(ply)
end


function SWEP:SecondaryAttack()

	if CLIENT then return end

	self:SetNextSecondaryFire(CurTime() + 0.5)
	local minDistance = 10000
	local ply = self:GetOwner()


	for i,v in ipairs(localPlague.sickPeople) do
		if v:GetPos():Distance(ply:GetPos()) < minDistance then
			minDistance = v:GetPos():Distance(ply:GetPos())
		end
	end

	if minDistance >= 10000 then
		ply:ChatPrint("I don't sense the plague.") return
	end


	ply:ChatPrint("I sense the plague "..tostring(math.Round(minDistance)).. " units away.")

end



function SWEP:OnRemove()

	timer.Stop( "medkit_ammo" .. self:EntIndex() )
	timer.Stop( "weapon_idle" .. self:EntIndex() )

end

function SWEP:Holster()

	timer.Stop( "weapon_idle" .. self:EntIndex() )

	return true

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end
