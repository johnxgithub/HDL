skills["Die"] =
{
	name = "Die",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Die"] =
		{
			name = "die",
			loop = true,
			stance = "die",
			weapon = 0,
			switch = 0,
			priority = 0,
			
			IsReady = function(this)
				return true;
			end,
		},	
	},	
}