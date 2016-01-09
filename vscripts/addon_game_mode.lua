-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:SetPreGameTime(5.0)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
Shua = 0
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
		if Shua == 0 then
			Shua = 1
			ShuaGuai()
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function ShuaGuai()
	local ShuaGuai_Entity = Entities:FindByName(nil, "ShuaGuai_1")
	local Guai = CreateUnitByName("npc_elite_centaur", ShuaGuai_Entity:GetOrigin(),false,nil,nil,DOTA_TEAM_BADGUYS)
	Guai:SetMustReachEachGoalEntity(true)
	Guai:SetInitialGoalEntity(ShuaGuai_Entity)
	Guai:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})
end
