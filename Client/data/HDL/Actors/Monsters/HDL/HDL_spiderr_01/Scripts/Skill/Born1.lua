skills["Born1"] =
{
	name = "born1",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Born"] = 
		{
			name = "born1",
			loop = false,
			stance = "born",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
				
				["Particle"] = 
				{
					time = 0.8,
					Func = function(this)
						Self:PlayLocalEffect{id = 601199};
					end,
				},							
				["Sound"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlaySound{path="m5_BGM/devilplaza/Abomi_01_02.wav",  volume = 1, distance = 200};
					end,
					},

			},
		},
	},	
}