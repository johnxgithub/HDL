skills["Dash"] =
{
	name = "Dash",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(8);
		Self:PlayGlobalEffect{id=12,};
	end,
	
	Leave = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		[1] =
		{
			name = "c_BattleIdle",
			loop = false,
			stance = "ground_action",
			weapon = 1,
			switch = 0,
			priority = 0,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
		},	
	},	
}