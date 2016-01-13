function Spawn(keys)
	ability_fungi_risk_attack = thisEntity:FindAbilityByName("fungi_risk_attack")
	thisEntity:SetContextThink("FungiHunterThink", FungiHunterThink, 1)
end

function FungiHunterThink()
	local health = thisEntity:GetHealth()
	if health ~= thisEntity:GetMaxHealth() then
		local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,unit in pairs(enemies) do
			thisEntity:CastAbilityOnTarget(unit, ability_fungi_risk_attack, -1)
			break
		end
	end
	return 1
end