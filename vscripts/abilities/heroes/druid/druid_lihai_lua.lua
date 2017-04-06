druid_lihai_lua = class({})

LinkLuaModifier("modifier_druid_lihai_lua", LUA_MODIFIER_MOTION_NONE)

function druid_lihai_lua:OnSpellStart()
	local druid_lihai_dur = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_druid_lihai_lua", {druation=druid_lihai_dur})

end