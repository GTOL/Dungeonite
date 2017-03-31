function healing_buffing(keys):
	local target = keys.target
	local ability = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ablevel = ability:GetLevel()
	local he = ability.GetSpecialValueFor('heal',ablevel-1)
	local targetheal = target.GetHealth()
	local targetmax = target.GetMaxHealth()
	if targetheal+he > targetmax then
		target.SetHealth(targetmax)
	else
		target.SetHealth(targetheal+he)
	end
end
