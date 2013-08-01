skills["Run"] =
{
	name = "Run",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(Config.moveSpeed);
	end,
	
	Leave = function(this)
		Self:SetMoveSpeed(0.0);
	end,
	
	Actions = 
	{
		["Run"] =
		{
			name = "Run",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Config.moveSpeed >= 5;
			end,
			
			Events = 
			{
				["LStep"] =
				{
					time = 0.02,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				
				["RStep"] =
				{
					time = 0.1,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
			},
		},	
		
		["Walk"] =
		{
			name = "Walk",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Config.moveSpeed < 5;
			end,
			
			Events = 
			{
				["LStep"] =
				{
					time = 0.02,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				
				["RStep"] =
				{
					time = 0.1,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
			},
		},	
	},	
}