skills["Roll"] =
{
	name = "Roll",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		
	end,
	
	Actions = 
	{
		--normal
		["normal0"] =
		{
			name = "Roll_1",
			loop = false,
			stance = "hang_free",
			weapon = 0,
			switch = 1,
			priority = 0,
			nextAction = "normal1",
			
			IsReady = function(this)
				return true;
			end,
		},	
		
		["normal1"] =
		{
			name = "Roll_2",
			loop = false,
			stance = "hang_free",
			weapon = 1,
			switch = 0,
			priority = 0,
			nextAction = "normal2",
			
			Events = 
			{
				["Begin"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlayLocalEffect{id = 2000301};
						Self:SetMoveSpeed(1000);
					end,
				},	
			},
		},	
		
		["normal2"] =
		{
			name = "Roll_3",
			loop = false,
			stance = "ground_action",
			weapon = 1,
			switch = 0,
			priority = 0,
			nextAction = "Idle",
			
			Events = 
			{
				["Begin"] = 
				{
					time = 0.25,
					Func = function(this)
						--Self:PlayGlobalEffect{id = 2000802};
						Self:SetMoveSpeed(0);
					end,
				},	
			},
		},	
	},	
}