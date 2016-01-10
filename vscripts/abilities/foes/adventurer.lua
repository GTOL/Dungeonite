function SurviveHeal(keys)
	local caster = keys.caster
	local maxHealth = caster:GetMaxHealth()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local percentage = ability:GetLevelSpecialValueFor("heal_percent", ability_level)
	local healHealth = maxHealth*percentage/100
	caster:Heal(healHealth,caster)
end

function CheckHealth(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local perc_celling = 0.4
	local health_perc = caster:GetHealth()/caster:GetMaxHealth()

	if health_perc <= perc_celling then
		print("addNewModifier")
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_last_stand_buff", nil)
	else
		caster:RemoveModifierByName("modifier_last_stand_buff")
	end
end