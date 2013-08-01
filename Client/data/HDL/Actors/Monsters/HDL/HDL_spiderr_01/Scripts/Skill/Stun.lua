skills["Stun"] =
{
	name = "Stun",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Stun"] = 
		{
			name = "Stun",
			loop = true,
			stance = "stun",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
		},
	},	
}