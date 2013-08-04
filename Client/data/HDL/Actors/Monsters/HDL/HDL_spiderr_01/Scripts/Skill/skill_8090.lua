skills[8090] = 
{
	name = "–Ó¡¶…¢…‰",
	Actions = 
	{
		["attack1"] = 
		{
			name = "Skill1",
			loop = true,
			stance = "ground_action",
			weapon = false,
			switch = true,
			priority = 0,
			nextAction = "Idle",
			fixTime = 2,
			
			IsReady = function()
				return true;
			end,
			
			Events = 
			{
				
				["Attack"] = 
				{
					time = 0.35,
					Func = function(this)
						Self:PlayGlobalEffect{id = 80901,};
					end,
				},	
			
				
					["Sound"] = 
				{
					time = 0,
					Func = function(this)
						--Self:PlaySound{path="M5_monster/Runencia/M_c_h_SkeletonSoldier/M_c_h_SkeletonSoldier_skill02.wav",  volume = 1.0, distance = 10};
					end,
				},	
			},
		},	
	},
	IsReady = function()
		return true;
	end,
}