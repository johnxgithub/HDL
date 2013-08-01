skills[200020] = 
{
	name = "´«ËÍ",
	
	Enter = function()
		Self:DecSP(PlayerConfig.SpecSkillSP);
	end,
	
	Actions = 
	{
		["A"] =
		{
			name = "transfer",
			loop = false,
			stance = "ground",
			weapon = 0,
			switch = 1,
			priority = 0,
			nextAction = "Idle",
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
				["Shoot1"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlayLocalEffect{id = 2000201};
					end,
				},
				
				["Shoot2"] = 
				{
					time = 0.95,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000201};
					end,
				},
			},
		},	
	},
	
	IsReady = function()
		return true;
	end,
}