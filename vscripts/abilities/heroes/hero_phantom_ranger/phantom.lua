--[[Author: Pizzalol, Noya, Ractidous
	Date: 08.04.2015.
	Creates illusions while shuffling the positions]]
	
	
	bombOn = false
	
	function BombOn()
		bombOn	= true
		print("Bomb is on")
	end
	
	function BombOff()
		bombOn = false
	end
	
	realPhantomOn = false
	
	function RealPhantomOn(keys)
		local caster = keys.caster
		local ability = keys.ability
		local abilityLevel = ability:GetLevel()-1
		
		outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", abilityLevel )
		incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", abilityLevel )
		realPhantomOn = true
	end
	
	function RealPhantomOff()
		realPhantomOn = false
	end
	
	
	
function Phantasm( keys )
	
	print(bombOn)
	
	local caster = keys.caster
	local target = keys.target
	local player = caster:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local unit_name = "npc_dota_hero_riki"
	local images_count = ability:GetLevelSpecialValueFor( "images_count", ability_level )
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability_level )
	
	if not realPhantomOn then
		outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability_level )
		incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability_level )
	end
	
	local casterOrigin = caster:GetAbsOrigin()
	local targetOrigin = target:GetAbsOrigin()
	local targetAngles = target:GetAngles()
	local casterAngles = caster:GetAngles()
	-- Stop any actions of the caster otherwise its obvious which unit is real

	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.phantasm_illusions then
		caster.phantasm_illusions = {}
	end
	
	-- do not clean illusion table

	-- Setup a table of potential spawn positions
	--[[local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),		-- North
		Vector( 0, 72, 0 ),		-- East
		Vector( -72, 0, 0 ),	-- South
		Vector( 0, -72, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	-- Insert the center position and make sure that at least one of the units will be spawned on there.
	table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )
	--]]
	
	
	local locationOffset = Vector(72*math.cos(math.rad(targetAngles.y)), math.sin(math.rad(72*targetAngles.y)), 0)
	-- At first, move the main hero to one of the random spawn positions.
	--FindClearSpaceForUnit( targetOrigin, targetOrigin + table.remove( vRandomSpawnPos, 1 ), true )

	-- Spawn illusions

	local origin = targetOrigin + locationOffset

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)

	illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
	
	-- Level Up the unit to the casters level
	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility ~= nil then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end
	
	if not realPhantomOn then
		local illusionAbility = illusion:FindAbilityByName("phantom_ranger_majia")
		illusionAbility:SetLevel(1)
		illusionAbility = illusion:FindAbilityByName("phantom_ranger_majia_die")
		illusionAbility:SetLevel(1)
	end
	
	if bombOn then
		illusion:AddAbility("phantom_bomb")
		ability = caster:FindAbilityByName("phantom_ranger_ability3")
		abilityLevel = ability:GetLevel()
		illusionAbility = illusion:FindAbilityByName("phantom_bomb")
		illusionAbility:SetLevel(abilityLevel)
	end
	
	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	-- Set the illusion hp to be the same as the caster
	illusion:SetHealth(caster:GetHealth())

	-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
	table.insert(caster.phantasm_illusions, illusion)
	
end

function ToggleOff(keys)
	keys.caster:RemoveModifierByName("modifier_phantom_ranger_phantom_arrow")
end

function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	--create a illusion
	local illusion = CreateUnitByName("npc_dota_hero_riki", casterPos, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(caster:GetPlayerID(), false)
	illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
	--level up it
	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end
	
	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility ~= nil then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end
	
	if not realPhantomOn then
		local illusionAbility = illusion:FindAbilityByName("phantom_ranger_majia")
		illusionAbility:SetLevel(1)
		illusionAbility = illusion:FindAbilityByName("phantom_ranger_majia_die")
		illusionAbility:SetLevel(1)
	end
	
	if bombOn then
		illusion:AddAbility("phantom_bomb")
		ability = caster:FindAbilityByName("phantom_ranger_ability3")
		abilityLevel = ability:GetLevel()
		illusionAbility = illusion:FindAbilityByName("phantom_bomb")
		illusionAbility:SetLevel(abilityLevel)
	end
	
	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end
	
	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = 10, outgoing_damage = 0, incoming_damage = 100 })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	-- Set the illusion hp to be the same as the caster
	illusion:SetHealth(caster:GetHealth())
	
end

--[[Creates vision around the caster while shuffling the illusions]]
function PhantasmVision( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
	local vision_duration = ability:GetLevelSpecialValueFor("invuln_duration", ability_level)

	ability:CreateVisibilityNode(caster_location, vision_radius, vision_duration)
end