skills["Stun"] =
{
	name = "Stun",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Leave = function(this)
	end,
	
	Actions = 
	{
		["Stun"] =
		{
			name = "Stun",
			loop = true,
			stance = "stun",
			weapon = 0,
			switch = 0,
			priority = 0,
			nextAction = "Idle",
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
			    ["Sound"] = 
		     	{
					time = 0.0,
					Func = function(this)
						
					end,
		    	},	
            },
		},	
	},	
}