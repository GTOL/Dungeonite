function druid_haste(keys):
	local caster = keys.caster
	local ablity = keys.ability
	local ablevel = ability:GetLevel()
	local ability1_name = "druid_hid"
	local ability2_name = "druid_tear"

	local ab1 = caster:GetAbilityByIndex(0)
	local ab2 = caster:GetAbilityByIndex(1)

	local ab1lv = ab1.GetLevel()
	local ab2lv = ab2.GetLevel()

	local ab1_n = ab1.GetAbilityName()
	local ab2_n = ab2.GetAbilityName()

	local ab1_n1= ab1_n..ablevel
	local ab1_n2= ab2_n..ablevel

    caster:AddAbility(ab1_n1);
    caster:SwapAbilities(ab1_n, ab1_n1, false, true);
    local handle_new_ability = caster:FindAbilityByName(ab1_n1);
    handle_new_ability:SetLevel(ab1lv);
	handle_new_ability:StartCooldown(ab1:GetCooldownTimeRemaining());
    caster:RemoveAbility(ab1_n);

    caster:AddAbility(ab1_n2);
    caster:SwapAbilities(ab2_n, ab2_n1, false, true);
    local handle_new_ability = caster:FindAbilityByName(ab2_n1);
    handle_new_ability:SetLevel(ab2lv);
	handle_new_ability:StartCooldown(ab2:GetCooldownTimeRemaining());
    caster:RemoveAbility(ab2_n);

end