skills["Idle"] =
{
	name = "Idle",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		[1] =
		{
			name = "a_BattleIdle",
			loop = true,
			stance = "stand_free",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return true;
			end,
		},	
		
		[2] =
		{
			name = "b_BattleIdle",
			loop = true,
			stance = "stand_free",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Self:GetWeaponID() == 2;
			end,
		},	
		
		[3] =
		{
			name = "c_BattleIdle",
			loop = true,
			stance = "stand_free",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Self:GetWeaponID() == 3;
			end,
		},	
	},	
}