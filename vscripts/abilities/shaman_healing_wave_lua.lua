shaman_healing_wave = class({})
hCaster = nil;
hTarget = nil;

function shaman_healing_wave:CastFilterResultTarget(hTarget)
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber());
	return nResult;
end

function shaman_healing_wave:GetHealingPower(nLevel)
	return self:GetLevelSpecialValueFor("Healing_Power",nLevel);
end

function shaman_healing_wave:GetUltiLevel()
	local res = hCaster:GetAbilityByIndex(4):GetLevel();
	return res;
end

function shaman_healing_wave:OnSpellStart()
	local ent = Entities:CreateByClassname("info_target");
	hCaster = self:GetCaster();
	hTarget = self:GetCursorTarget();
	
	if (hCaster==nil) or (hTarget==nil) or (hTarget:TriggerSpellAbsorb(this)) then
		return
	end
	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )
	local vHeal = hTarget:GetHealth();
	vHeal = vHeal + self:GetHealingPower(self:GetLevel());
	hTarget:SetHealth(vHeal);
	
	
	--countinuing finding heroes and imply healing
	for i=1,(3+self:GetUltiLevel())
	do
		require "timers"
		Timers:CreateTimer(i*0.5,function()
			org = hTarget:GetOrigin();
			local units = FindUnitsInRadius(hTarget:GetTeamNumber(),org,nil,400.0,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false);
			local nTarget = nil;
			for _,unit in pairs(units)
			do	
				--Find the unit with least health percentage
				--nTarget work as a buffer variable
				if(hTarget~=unit) then
					if (nTarget==nil) then
						nTarget = unit;
					else
						if hTarget:GetHealth()/hTarget:GetMaxHealth() > unit:GetHealth()/unit:GetMaxHealth() then
							nTarget = unit;
						end
					end
				end
			end
			if(not nTarget) then
				return;
			end
			nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nTargetFX, 1, nTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
			ParticleManager:ReleaseParticleIndex( nTargetFX )
			hTarget = nTarget;
			vHeal = hTarget:GetHealth();
			vHeal = vHeal + self:GetHealingPower(self:GetLevel());
			hTarget:SetHealth(vHeal);
		end);
	end
end