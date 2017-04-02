function druid_haste(keys):
	local caster = keys.caster
	local ablity = keys.ability
	local ablevel = ability:GetLevel()
	local ab1_n = "druid_heal"

	local ab1 = caster:FindAbilityByName(ab1_n)
	local ab1lv = ab1:GetLevel()
	local ab1_n1= ab1_n..ablevel

    caster:AddAbility(ab1_n1)
    caster:SwapAbilities(ab1_n, ab1_n1, false, true)
    local handle_new_ability = caster:FindAbilityByName(ab1_n1)
    handle_new_ability:SetLevel(ab1lv)
    caster:RemoveAbility(ab1_n)

    require 'timers'
    Timers:CreateTimer(14,function()
    	caster:AddAbility(ab1_n)
    	caster:SwapAbilities(ab1_n1,ab1_n,false,true)
    	local oldAbilityHandler = caster:FindAbilityByName(ab1_n1)
    	local oldlv = oldAbilityHandler:GetLevel()
    	local FindAbilityByName = caster:FindAbilityByName(ab1_n)
    	handle_new_ability:SetLevel(oldlv)
    	caster:RemoveAbility(ab1_n1)

end