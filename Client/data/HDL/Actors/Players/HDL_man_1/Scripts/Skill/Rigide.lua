skills["Rigide"] =
{
	name = "Rigide",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
		Self:DebugPrint("Enter Rigide");
	end,
	
	Actions = 
	{
		[1] =
		{
			name = "hit",
			loop = false,
			stance = "rigide",
			weapon = 1,
			switch = 0,
			priority = 0,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
			
			Events =
			{
				["Rigide"] =
				{
					time = 0.04,
					
					Func = function(this)
						this.action:Pause(Config.rigidTime);
					end,	
				},
			},
		},	
		
		[2] = 
		{
			name = "hit_blades_a",
			loop = false,
			stance = "rigide",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return Self:HasEquipSubType("Glave");
			end,
			
			Events =
			{
				["Rigide"] =
				{
					time = 0.06,
					
					Func = function(this)
						this.action:Pause(Config.rigidTime);
					end,	
				},
			},
		},
		
		[3] = 
		{
			name = "hit_mace_a",
			loop = false,
			stance = "rigide",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return Self:HasEquipSubType("Hammer");
			end,
			
			Events =
			{
				["Rigide"] =
				{
					time = 0.04,
					
					Func = function(this)
						this.action:Pause(Config.rigidTime);
					end,	
				},
			},
		},
	},	
}