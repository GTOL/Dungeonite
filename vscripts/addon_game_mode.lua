-- Generated from template
require("AI")
require("timers")

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
	GameRules:SetGoldPerTick(0)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetFirstBloodActive(false)
	-- 好像队伍设置不在这里改
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:SetPreGameTime(5.0)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CAddonTemplateGameMode, "OnPlayerSpawn"), self) --监听单位出生
end

-- Evaluate the state of the game
Shua = 0
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
		if Shua == 0 then
			Shua = 1
			ShuaGuaiKaiShi()
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
--1. 给英雄添加技能
function CAddonTemplateGameMode:OnPlayerSpawn(keys)
	--获取英雄
	local entity = EntIndexToHScript(keys.entindex)
	if entity.GetPlayerID and entity:IsHero() and not entity:IsIllusion() then
		--获取英雄天赋技能
		local ability = entity:GetAbilityByIndex(0)
		ability:SetLevel(1)
	end
end

function ShuaGuai(Guai_name, Ent_name, num)
	for i = 1,num do
		local ShuaGuai_Entity = Entities:FindByName(nil, Ent_name)
		local Guai = CreateUnitByName(Guai_name, ShuaGuai_Entity:GetOrigin(),false,nil,nil,DOTA_TEAM_BADGUYS)
		--Guai:SetMustReachEachGoalEntity(true)
		--Guai:SetInitialGoalEntity(ShuaGuai_Entity)
		Guai:AddNewModifier(nil,nil,"modifier_phased",{duration=0.1})
	end
end

function ShuaGuaiKaiShi()
	ShuaGuai("npc_bear", "jungle_bear", 1)
	ShuaGuai("npc_treant", "jungle_treant", 4)
	ShuaGuai("npc_kobold", "jungle_kobold", 4)
	ShuaGuai("npc_small_centaur", "mines_small_centaur", 3)
	ShuaGuai("npc_big_centaur", "mines_small_centaur", 2)
	ShuaGuai("npc_small_centaur", "mines_big_centaur", 5)
	ShuaGuai("npc_big_centaur", "mines_big_centaur", 1)
	ShuaGuai("npc_elite_centaur", "mines_big_centaur", 1)
	ShuaGuai("npc_small_centaur", "mines_medium_centaur", 5)
	ShuaGuai("npc_miner", "mines_medium_centaur", 4)
	ShuaGuai("npc_fallen_soldier", "mines_fallen_soldier", 4)
	ShuaGuai("npc_miner", "mines_fallen_soldier", 6)
	ShuaGuai("fallen_knight", "mines_fallen_knight", 1)
	ShuaGuai("npc_fallen_soldier", "mines_fallen_knight", 4)
-- 	ShuaGuai("npc_swamp_zombie", "swamp_zombie", 4)
end
