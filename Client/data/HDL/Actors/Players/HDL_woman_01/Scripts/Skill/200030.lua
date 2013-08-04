skills[200030] = 
{
	name = "特效技能",
	Actions = 
	{
		["A"] =
		{
			name = "sepcialskill",
			loop = false,
			stance = "ground_action",
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
					time = 0.6,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000802};
					end,
				},	
			},
		},	
	},
	
	IsReady = function()
		return true;
	end,
}