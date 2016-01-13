function Leap(keys)
	local caster = keys.caster
	local target = keys.target
	local casterOrigin = caster:GetAbsOrigin()
	local targetOrigin = target:GetAbsOrigin()
	local ability = keys.ability
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)
	local x_origin = -casterOrigin.x+targetOrigin.x
	local y_origin = -casterOrigin.y+targetOrigin.y
	local normalize = math.sqrt(x_origin*x_origin+y_origin*y_origin)
	ability.leap_direction = Vector(x_origin/normalize, y_origin/normalize, 0)
	ability.leap_distance = normalize
	ability.leap_speed = 1600/30
	ability.leap_traveled = 0
	ability.leap_z=0
end
--[[
function Leap2(keys)
	print("Spore jump")
	local caster = keys.caster
	local point = keys.target_points[1]
	local casterOrigin = caster:GetAbsOrigin()
	local targetOrigin = point
	local ability = keys.ability
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)
	local x_origin = -casterOrigin.x+targetOrigin.x
	local y_origin = -casterOrigin.y+targetOrigin.y
	local normalize = math.sqrt(x_origin*x_origin+y_origin*y_origin)
	ability.leap_direction = Vector(x_origin/normalize, y_origin/normalize, 0)
	ability.leap_distance = normalize
	ability.leap_speed = 1600/30
	ability.leap_traveled = 0
	ability.leap_z=0
end
]]--

function LeapHorizontal( keys )
	local caster = keys.target
	local ability = keys.ability

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
		caster:InterruptMotionControllers(true)
	end
end

function LeapVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.leap_traveled < ability.leap_distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.leap_z = ability.leap_z + ability.leap_speed/2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	else
		-- Go down
		ability.leap_z = ability.leap_z - ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	end
end

function RiskAttack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local curHealth = caster:GetHealth()
	local damage = curHealth - 1
	caster:SetHealth(1)
	local damage_table ={}
	damage_table.damage_type=ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage
	damage_table.attacker=caster
	damage_table.victim = target
	ApplyDamage(damage_table)
end


function Summon(keys)
	local caster = keys.caster
	local casterOrigin = caster:GetAbsOrigin()
	local vRandomSpawnPos = {
		Vector( 172, 172, 0 ),		-- North
		Vector( -172, 72, 0 ),		-- East
		Vector( 172, -172, 0 ),	-- South
		Vector( -172, -172, 0 ),	-- West
	}
	local casterAngles = caster:GetAngles()
	
	for i=1, 4 do
		local origin = casterOrigin + table.remove(vRandomSpawnPos, 1)
		local summonFungi = CreateUnitByName("npc_fungi_hunter", origin, true, caster, nil, caster:GetTeamNumber())
		summonFungi:SetAngles(casterAngles.x, casterAngles.y, casterAngles.z)
		summonFungi:AddNewModifier(caster, ability, "modifier_phased",	{duration = 0.03} )
		ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW, summonFungi)
	end
end

function SporeSummon(keys)
	local caster = keys.caster
	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()
	local ability = keys.ability
	local curHealth = caster:GetHealth()
	local dmgHealth = caster:GetMaxHealth()/5
	caster:SetHealth(curHealth-dmgHealth)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	--summon spore in 600 radius
	for i=1,4 do
		local distance = math.random(200, 600)
		local angle = math.random(-90, 90)
		local sporeAngle = casterAngles.y+angle
		local spore = CreateUnitByName(keys.unit_name, casterOrigin+Vector(distance*math.cos(math.rad(sporeAngle)), distance*math.sin(math.rad(sporeAngle)), 0), true, caster,nil,caster:GetTeamNumber())
		
		--effect
		summon_particle = ParticleManager:CreateParticle(keys.effect_name_1, PATTACH_ABSORIGIN_FOLLOW, spore)
		
		ParticleManager:SetParticleControl(summon_particle,0,spore:GetOrigin())
		
		spore:AddNewModifier(caster, ability, "modifier_phased",	{duration = 0.03} )
	end
end

counter = 0
startIncrement = 0

function Absorb(keys)
	local caster = keys.caster
	local casterOrigin = caster:GetAbsOrigin()
	local ability = keys.ability
	local heal_1 = caster:GetMaxHealth()/160
	local fungs = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
	if startIncrement == 1 then
		counter = counter + 1
	end
	
	for _,unit in pairs(fungs) do
		if unit:GetUnitName() == keys.unit_name then
			caster:Heal(heal_1, caster)
			startIncrement = 1
			
			--effect
			--create a tracking projectile
			
			local info = {
				Target = caster,
				Source = unit,
				Ability = ability,
				EffectName = keys.effect_name_1,
				iMoveSpeed = 400,
				vSourceLoc = unit:GetAbsOrigin(),
				bVisibleToEnemies = true
			}
			
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			unit:EmitSound(keys.sound_name)
			
			--[[
			heal_particle = ParticleManager:CreateParticle(keys.effect_name_1, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(heal_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(heal_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(heal_particle)]]--
			
			if counter == 9 then
				death_particle = ParticleManager:CreateParticle(keys.effect_name_2, PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:SetParticleControl(death_particle,0,unit:GetOrigin())
				
				unit:RemoveAbility("fungi_cry")
				unit:RemoveModifierByName("modifier_fungi_cry_datadriven")
				unit:ForceKill(false)
				startIncrement = 0
			end
		end
		
	end
	if counter == 9 then
		counter = 0
	end
end

function SetTarget(keys)
	target = keys.target
	caster = keys.caster
end

function ShareDamage(keys)
	caster = keys.caster
	local ability = keys.ability
	local damage_table={}
	damage_table.damage_type=ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = keys.DamageTaken*2
	damage_table.attacker=caster
	damage_table.victim = target
	ApplyDamage(damage_table)
	
	--effect
	damage_particle = ParticleManager:CreateParticle(keys.effect_name_1, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(damage_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(damage_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(damage_particle)
	
	--sound
	--这段音效播放不出来，原因未知
	caster:EmitSound(keys.sound_name)
end

function DamageLink(keys)
	local ability = keys.ability
	local damage = target:GetMaxHealth()/100
	local damage_table={}
	damage_table.damage_type=ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage
	damage_table.attacker=caster
	damage_table.victim = target
	local damageDone = ApplyDamage(damage_table)
	
	--effect
	--vamp_particle = ParticleManager:CreateParticle(keys.effect_name_1, PATTACH_ABSORIGIN_FOLLOW, target)
	--ParticleManager:SetParticleControlEnt(vamp_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	--ParticleManager:SetParticleControlEnt(vamp_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	--ParticleManager:ReleaseParticleIndex(vamp_particle)
	
	caster:Heal(damageDone, caster)
end


function DestroyEffect(keys)
	--ParticleManager:DestroyParticle(vamp_particle, true)
end
