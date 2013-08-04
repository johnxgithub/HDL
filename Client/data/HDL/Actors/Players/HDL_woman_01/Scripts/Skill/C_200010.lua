skills[200010] = 
{
	name = "ÊÖÇ¹¹¥»÷",
	Actions = 
	{
		[0] =
		{
			name = "c_RunBack",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			upbody = {left="c_RunLeft", right="c_RunRight", stand="c_Shoot", run="c_RunShoot", back="c_RunBack"},
			
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
				["RStep"] =
				{
					time = 0.71,
					Func = function(this)
						Self:PlaySound{path="fst-female-dirt-metal-R.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				["Shoot1"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000101};
					end,
				},	
				["Shoot2"] = 
				{
					time = 0.25,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000101};
					end,
				},	
				["Shoot3"] = 
				{
					time = 0.5,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000101};
					end,
				},	
				["Shoot4"] = 
				{
					time = 0.75,
					Func = function(this)
						Self:PlayGlobalEffect{id = 2000101};
					end,
				},	
			},
		},	
	},
	
	IsReady = function()
		return true;
	end,
}