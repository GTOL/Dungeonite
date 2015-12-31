function Die( keys )
	local caster = keys.caster
	caster:ForceKill(false)
end

function Effect(keys)
	local caster = keys.caster
	
	local particleID = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN, caster)
	
	ParticleManager:SetParticleControl(particleID,0,caster:GetOrigin())
end