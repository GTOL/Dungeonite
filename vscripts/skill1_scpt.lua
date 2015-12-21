require ("socket")

Skill1 = class({})

function Skill1:CastFilterResultTarget(hTarget)
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber());
	return nResult;
end

function Skill1:GetHealingPower(nLevel)
	return self:GetSpecialValueFor("Healing_Power");
end


function Skill1:OnSpellStart()
	hCaster = self:GetCaster();
	hTarget = self:GetCursorTarget();
	
	if (hCaster==nil) or (hTarget==nil) or (hTarget:TriggerSpellAbsorb(this)) then
		return
	end
	
	local vHeal = hTarget:GetHealth();
	vHeal = vHeal + self:GetHealingPower(self:GetLevel());
	hTarget:SetHealth(vHeal);
	
	for i=1,4
	do
		org = hTarget:GetOrigin();
		adder = 0;
		for _,unit in pairs(FindUnitsInRadius(hTarget:GetTeamNumber(),org,nil,400.0,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false))
		do	
			adder = adder + 1;
			if(adder == 2) then
 
				local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
				ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nTargetFX )
				
				if(hTarget==unit) then
					adder = adder - 1;
				else	
					socket.select(nil,nil,1);
 					hCaster = hTarget;
					hTarget = unit;
					adder = 0;
					break;
				end
			end
		end
		
		vHeal = hTarget:GetHealth();
		vHeal = vHeal + self:GetHealingPower(self:GetLevel());
		hTarget:SetHealth(vHeal);
	end
	
end