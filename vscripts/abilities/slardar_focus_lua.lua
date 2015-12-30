function attack_amplification( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	local damage_by_level = ability:GetLevelSpecialValueFor("damage", level - 1)

	if target:HasModifier("modifier_focus_enemy") then
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage_by_level,
			damage_type = DAMAGE_TYPE_PHYSICAL
		}
		ApplyDamage(damageTable)
	end
end

function damage_reduction( keys )
	local attacker = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	local reduction = ability:GetLevelSpecialValueFor("reduction", level - 1) / 100
	local incoming = keys.damage
	local health = caster:GetHealth()

	if attacker:HasModifier("modifier_focus_enemy") then
		--check if the reduced damage is lethal
		if ((health - incoming * (1 - reduction)) >= 1) then
			caster:SetHealth(incoming * reduction + health)
		end
	end
end