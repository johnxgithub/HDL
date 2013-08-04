skills["Run"] =
{
	name = "Run",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(PlayerConfig.MoveSpeed);
	end,
	
	Leave = function(this)
		Self:SetMoveSpeed(0.0);
	end,
	
	Actions = 
	{
		[1] =
		{
			name = "a_Run",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return true;
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
		
		[2] =
		{
			name = "b_Run",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Self:GetWeaponID() == 2;
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

		[3] =
		{
			name = "c_Run",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Self:GetWeaponID() == 3;
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