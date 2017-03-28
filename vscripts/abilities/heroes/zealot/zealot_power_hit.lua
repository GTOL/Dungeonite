-- normally deal magic damage to a unit
-- can be cast to both enemy and friendly units!

function zealot_power_hit(keys)
	local caster = keys.caster;
	local target = keys.target;
	local ability = caster:GetAbilityName('zealot_power_hit');
	local ablevel = ability:GetLevel();
	local dmg = ability:GetSpecialValueFor('damage',ablevel);
	local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH;
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC;
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	local damageTable = {}
	damageTable.attacker = caster;
	damageTable.damage = dmg;
	damageTable.damage_type = DAMAGE_TYPE_MAGICAL;
	damageTable.ability = ability;
	damageTable.victim = target;
	ApplyDamage(damageTable);
end
