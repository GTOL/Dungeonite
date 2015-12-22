function lightening_shield_dmg(keys)
    local caster = keys.caster;
    local target = keys.target;
    local ability = caster:GetAbilityByIndex(2);
    local location = target:GetAbsOrigin();
    local radius = 200;
	local ability_level = ability:GetLevel();
    local shield_particle = keys.shield_particle;
    local damage = ability:GetLevelSpecialValueFor("damage",ability_level);

    local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH;
    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC;
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE;

    local damage_table={};
    damage_table.attacker = target;
    damage_table.damage = damage;
    damage_table.damage_type = DAMAGE_TYPE_MAGICAL;
    damage_table.ability = caster:GetAbilityByIndex(2);

    local units = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false );
    for _,unit in pairs(units) do
        if unit~= target then
            local particle = ParticleManager:CreateParticle(shield_particle, PATTACH_POINT_FOLLOW, unit);
            --ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", location, true);
            ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true);
            ParticleManager:ReleaseParticleIndex(particle);

            damage_table.victim = unit;
            ApplyDamage(damage_table);
        end
    end
end 
