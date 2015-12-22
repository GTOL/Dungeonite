function AncientPower(keys)
    local caster = keys.caster;
    local ability = keys.ability;
    local ability_level = ability:GetLevel();
    local ability1_name = "shaman_summon_totem";
    local ability3_name = "shaman_lightening_shield";
    
    local ability1 = caster:GetAbilityByIndex(0);
    local ability3 = caster:GetAbilityByIndex(2);

    local level1 = ability1:GetLevel();
    local level3 = ability3:GetLevel();

    local ability1_oldname = ability1:GetAbilityName();
    local ability3_oldname = ability3:GetAbilityName();
    
    local ability1_newname = ability1_name..ability_level;
    local ability3_newname = ability3_name..ability_level;
	
	print(ability3_newname);
    
    caster:AddAbility(ability1_newname);
    caster:SwapAbilities(ability1_oldname, ability1_newname, false, true);
    local handle_new_ability = caster:FindAbilityByName(ability1_newname);
    handle_new_ability:SetLevel(level1);
	handle_new_ability:StartCooldown(ability1:GetCooldownTimeRemaining());
    caster:RemoveAbility(ability1_oldname);
    
    caster:AddAbility(ability3_newname);
    caster:SwapAbilities(ability3_oldname, ability3_newname, false, true);
    local handle_new_ability2 = caster:FindAbilityByName(ability3_newname);
    handle_new_ability2:SetLevel(level3);
	handle_new_ability2:StartCooldown(ability3:GetCooldownTimeRemaining());
    caster:RemoveAbility(ability3_oldname);
    
end