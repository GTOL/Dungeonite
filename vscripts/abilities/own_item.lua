own_item = class({})

--function sell:GetAOERadius()
--	return self:GetSpecialValueFor("radius")
--end
--把这个技能设置为隐藏被动
function own_item:OnInventoryContentsChanged() 
	local hCaster = self:GetCaster() 
	for i = 0, 5 do
		local item = hCaster:GetItemInSlot( i )
		if item ~= nil then
		item:SetPurchaser(hCaster)
		end
	end
end

