--slardar heal
--Author: GTOL
--Date: 31/12/2015
function Particle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf"
	target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

	ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

-- Destroys the particle when the modifier is destroyed
function EndParticle( event )
	local target = event.target
	ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
end