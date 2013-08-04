skills[200012] = 
{
	name = "µÚ¶þ°ÑÇ¹",
	Actions = 
	{
		[0] =
		{
			name = "b_RunBack",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			upbody = {left="b_RunLeft", right="b_RunRight", stand="b_Shoot",run="b_RunShoot", back="b_RunBack"},
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
				["LStep"] =
				{
					time = 0.11,
					Func = function(this)
						Self:PlaySound{path="fst-female-dirt-metal-L.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				["Particle2"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000121};
						Self:PlaySound{path="A_C_Roll_1.wav", time = 1.0, volume = 1.0, distance = 10};
					end,
				},				
				["RStep"] =
				{
					time = 0.71,
					Func = function(this)
						Self:PlaySound{path="fst-female-dirt-metal-R.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
			},
		},	
	},
	
	IsReady = function()
		return true;
	end,
}