function FiendsGripStopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

--[[Fiends grip mana drain
	Author: chrislotix, Pizzalol
	Date: 11.1.2015.
	Changed: 11.03.2015.
	Reason: Improved the code]]

--[[Author: Pizzalol
	Date: 11.03.2015.
	Reveals the target if its invisible]]