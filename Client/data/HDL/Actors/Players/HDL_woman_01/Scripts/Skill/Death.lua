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
			name = "a_Die_01",
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
					time = 0.07,
					Func = function(this)
						Self:PlaySound{path="A_Die_Voice.wav", time = 1.0, volume = 1.0, distance = 10};
					end,
				},	
			},
		},	
	},	
}