function torrent_particle( keys )
	local target = keys.target
	local particleName = "particles/slardar_torrent.vpcf"
	local particleID = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particleID, 0, target:GetAbsOrigin() )
end



function torrent_particle_damage( keys )
	local target = keys.target
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	local particleID = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particleID, 0, target:GetAbsOrigin() )
end


function  torrent_prepare( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability

	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local torrent_modifier = keys.torrent_modifier
	local remaining_duration = duration - (GameRules:GetGameTime() - target.torrent_start_time)

	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false )
--对每个英雄操作
	for _,unit in pairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = target_location - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()	--向中心向量
		local rotation = Vector(direction.y, - direction.x, direction.z)	--垂直向量

		if unit.pull_speed == nil then
			unit.pull_speed = distance * 1/(remaining_duration) * 1/30
		end

		if not unit:HasModifier(torrent_modifier) then
			ability:ApplyDataDrivenModifier(caster, unit, torrent_modifier, {duration = remaining_duration})
		end
		
		unit:SetAbsOrigin(unit_location + direction * unit.pull_speed + 3 * rotation) 

	end
end

function torrent_prepare_start( keys )
	local target = keys.target
	target.torrent_start_time = GameRules:GetGameTime()
end