--absorbs hp from around units
--both enemy and friendly

function life_abosrb(keys)
	local caster = keys.caster;
	local ability = caster:GetAbilityName('life_abosrb');
	local ablevel = ability:GetLevel();
	local radius = ability:GetSpecialValueFor('radius',ablevel);
	local dmg = ability:GetSpecialValueFor('damage',ablevel);

	local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH;
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC;
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE;

	local damagetable = {}
	damagetable.attacker = caster;
	damagetable.damage = dmg;
	damagetable.damage_type = DAMAGE_TYPE_MAGICAL;
	damagetable.ability = ability;

	absorbed = 0;
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false);
	for _,unit in pairs(units) do
		damagetable.victim = unit;
		uhealth = unit:GetHealth();
		ApplyDamage(damagetable);
		if ~unit:IsAlive() then
			absorbed = absorbed + uhealth;
		else
			absorbed = absorbed + uhealth - unit:GetHealth();
		end
	end
	cHealth = caster:GetHealth();
	if (cHealth+absorbed)>caster:GetMaxHealth() then
		caster:SetHealth(caster:GetMaxHealth());
	else
		caster:SetHealth(cHealth+absorbed);
	end
end
