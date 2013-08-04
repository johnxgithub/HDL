skills["Idle"] =
{
	name = "Idle",
	--randAction = {"Idle", "Idle1", "Idle2",},
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Idle"] =
		{
			name = "Idle",
			loop = true,
			stance = "stand_free",
			weapon = 0,
			switch = 0,
			priority = 0,
			
			IsReady = function(this)
				return true;
			end,
		},
		
		
		["CombatIdle"] =
		{
			name = "combatidle",
			loop = true,
			stance = "stand_free",
			weapon = 0,
			switch = 1,
			priority = 1,
			
			IsReady = function(this)
				return Config.isBattleState;
			end,
		},	
	},	
}