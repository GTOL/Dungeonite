phantom_arrow_lua = class({})


function pudge_rot_lua:OnToggle()
	-- Apply the rot modifier if the toggle is on
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_phantom_ranger_phantom_arrow", nil )

	else
		-- Remove it if it is off
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_phantom_ranger_phantom_arrow" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end