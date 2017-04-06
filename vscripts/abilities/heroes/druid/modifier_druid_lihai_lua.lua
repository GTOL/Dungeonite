modifier_druid_lihai_lua = class({})

function modifier_druid_lihai_lua:IsPurgable()
	return true 
end

function modifier_druid_lihai_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_druid_lihai_lua:GetModifierBaseAttack_BonusDamage()
	local minjie = self:GetCaster():GetAgility()
	return 0.4*minjie
end