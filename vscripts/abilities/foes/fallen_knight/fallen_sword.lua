

function ChangeLocation(keys)
	local target = keys.target
	local targetAngles = target:GetAngles()
	local caster = keys.caster
	local casterOrigin= caster:GetOrigin()
	local casterAngles = caster:GetAngles()
	local locationOffset = Vector(-72*math.cos(math.rad(casterAngles.y)), -72*math.sin(math.rad(casterAngles.y)), 0)
	origin = casterOrigin+locationOffset
	target:SetOrigin(origin)
	target:SetAngles(casterAngles.x, casterAngles.y,casterAngles.z)
	particle = ParticleManager:CreateParticle( keys.particleName, PATTACH_POINT_FOLLOW, target ) 
	ParticleManager:SetParticleControl( particle, 0, origin)
end


function EndSword(keys)
	local target = keys.target
	ParticleManager:DestroyParticle(particle,false)
end


function DamageAndHeal(keys)
	local caster = keys.caster
	local casterOrigin = caster:GetOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage_self = ability:GetLevelSpecialValueFor("damage_self", ability_level)
	local damage_ally = ability:GetLevelSpecialValueFor("damage_ally", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	
	local particleName = keys.particleName
	
	local damage_table ={}
	damage_table.damage_type=ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage_self
	damage_table.attacker=caster
		
	--heal self
	local units_to_damage = FindUnitsInRadius(caster:GetTeam(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)
	
	for _,v in pairs(units_to_damage) do
		-- Play the particle
		damage_particle = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW, v)
		ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(damage_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(damage_particle)
		damage_table.victim = v
		local damageDone = ApplyDamage(damage_table)
		caster:Heal(damageDone, caster)
	end
	
	--heal ally
	local units = FindUnitsInRadius(caster:GetTeam(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC,0,0,false)
	
	for _,c in pairs(units) do
		for _,v in pairs(units_to_damage) do
			-- Play the particle
			damage_particle = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW, v)
			ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(damage_particle, 1, c, PATTACH_POINT_FOLLOW, "attach_hitloc", c:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(damage_particle)
			damage_table.victim = v
			local damageDone = ApplyDamage(damage_table)
			c:Heal(damageDone, caster)
		end
	end
end

function Helper(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damageType = ability:GetAbilityDamageType()
	damageDone = ApplyDamage({victim=target,attacker=caster,damage=damage,damage_type=damageType})
	
	damage_particle = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(damage_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(damage_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(damage_particle)
	caster:Heal(damageDone,caster)
end