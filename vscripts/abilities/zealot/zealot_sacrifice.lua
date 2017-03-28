function mana_sacrifice(keys)
  local LossPercentage = 0.25
	local hcaster = keys.caster
	local health = hcaster:GetMaxHealth()
	local loss = math.floor(health * LossPercentage)
	local thealth = self:GetMaxHealth() - loss
	hcaster:SetHealth(thealth)
	local mana = self:GetMana()
	hcaster:SetMana(mana+loss)
end

-- sacrifice certain percentage of hp to mp
