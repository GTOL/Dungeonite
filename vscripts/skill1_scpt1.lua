Skill1 = class({})

function Skill1:CastFilterResultTarget(hTarget)
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber());
	return nResult;
end

function Skill1:GetHealingPower(nLevel)
	return self:GetSpecialValueFor("Healing_Power");
end


function Skill1:OnSpellStart()
	local hCaster = self:GetCaster();
	local hTarget = self:GetCursorTarget();
	
	if (hCaster==nil) or (hTarget==nil) or (hTarget:TriggerSpellAbsorb(this)) then
		return
	end
	
	local vHeal = hTarget:GetHealth();
	vHeal = vHeal + self:GetHealingPower(self:GetLevel());
	hTarget:SetHealth(vHeal);
	
	
	--countinuing finding heroes and imply healing
	for i=1,3
	do
		org = hTarget:GetOrigin();
		local units = FindUnitsInRadius(hTarget:GetTeamNumber(),org,nil,400.0,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false);
		local nTarget = nil;
		
		for _,unit in pairs(units)
		do	
			local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
			ParticleManager:ReleaseParticleIndex( nTargetFX )
				
			--Find the unit with least health percentage
			--nTarget work as a buffer variable
			if(hTarget~=unit) then
				if (nTarget==nil) then
					nTarget = unit;
				else
					if unit:GetHealth()/unit:GetMaxHealth() < unit:GetHealth/unit:GetMaxHealth() then
						nTarget = unit;
					end
			end
		end
		
		hTarget = nTarget;
		vHeal = hTarget:GetHealth();
		vHeal = vHeal + self:GetHealingPower(self:GetLevel());
		hTarget:SetHealth(vHeal);
	end
	
end