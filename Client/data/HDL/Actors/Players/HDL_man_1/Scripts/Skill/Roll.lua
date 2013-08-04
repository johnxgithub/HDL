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
			name = "a_Roll_1",
			loop = false,
			stance = "hang_free",
			weapon = 0,
			switch = 1,
			priority = 0,
			nextAction = "normal1",
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
				["Begin"] = 
				{
					time = 0.18,
					Func = function(this)
						Self:PlayLocalEffect{id = 2000301};
						Self:SetMoveSpeed(1000);
					end,
				},	
			},
		},	
		
		["normal1"] =
		{
			name = "a_Roll_2",
			loop = false,
			stance = "hang_free",
			weapon = 1,
			switch = 0,
			priority = 0,
			nextAction = "normal2",
		},	
		
		["normal2"] =
		{
			name = "a_Roll_3",
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
					time = 0.49,
					Func = function(this)
						--Self:PlayGlobalEffect{id = 2000802};
						Self:SetMoveSpeed(0);
					end,
				},	
			},
		},	
	},	
}