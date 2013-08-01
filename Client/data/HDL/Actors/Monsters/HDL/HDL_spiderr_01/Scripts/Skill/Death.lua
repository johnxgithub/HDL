skills["Death"] =
{
	name = "Death",
	nextSkill = "Die",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Death"] =
		{
			name = "death",
			loop = false,
			stance = "death",
			weapon = 0,
			switch = 0,
			priority = 0,
			nextAction = "Die",
			
			IsReady = function(this)
				return true;
			end,
			Events =
			{
			["Sound"] = 
				{
					time = 0.01,
					Func = function(this)
						--Self:PlaySound{path="m5_BGM/devilplaza/Abomi_02_02.wav",  volume = 1, distance =200};
					end,
					},
			 },
		},	
	},	
}