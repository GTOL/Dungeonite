own_item = class({})

--function sell:GetAOERadius()
--	return self:GetSpecialValueFor("radius")
--end



function own_item:OnSpellStart() 
	local hCaster = self:GetCaster() 
	for i = 0, 5 do
		local item = hCaster:GetItemInSlot( i )
		if item ~= nil then
		item:SetPurchaser(hCaster)
		end
	end
end

