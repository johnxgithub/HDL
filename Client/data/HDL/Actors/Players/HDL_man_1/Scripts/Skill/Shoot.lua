skills["Shoot"] =
{
	name = "Shoot",
	
	IsReady = function(this)
		return true;
	end, 
	
	Actions = 
	{
		["A"] =
		{
			name = "a_RunBack",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			upbody = {left="a_RunRight", right="a_RunRight", stand="a_Shoot",run="a_RunShoot", back="a_RunBack"},
			
			IsReady = function(this)
				return Self:GetWeaponID() == 1;
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
						Self:PlayGlobalEffect{id = 1000101};
					end,
				},	
				["Shoot2"] = 
				{
					time = 0.25,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000101};
					end,
				},	
				["Shoot3"] = 
				{
					time = 0.5,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000101};
					end,
				},	
				["Shoot4"] = 
				{
					time = 0.75,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000101};
					end,
				},	
			},
		},	
		
		[2] =
		{
			name = "b_RunBack",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			upbody = {left="b_RunLeft", right="b_RunRight", stand="b_Shoot",run="b_RunShoot", back="b_RunBack"},
			
			IsReady = function(this)
				return Self:GetWeaponID() == 2;
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
						Self:PlayGlobalEffect{id = 1000111};
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
		
		[3] =
		{
			name = "c_RunBack",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			upbody = {left="c_RunLeft", right="c_RunRight", stand="c_Shoot", run="c_RunShoot", back="c_RunBack"},
			
			IsReady = function(this)
				return Self:GetWeaponID() == 3;
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
						Self:PlayGlobalEffect{id = 1000121};
					end,
				},	
				["Shoot2"] = 
				{
					time = 0.25,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000121};
					end,
				},	
				["Shoot3"] = 
				{
					time = 0.5,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000121};
					end,
				},	
				["Shoot4"] = 
				{
					time = 0.75,
					Func = function(this)
						Self:PlayGlobalEffect{id = 1000121};
					end,
				},	
			},
		},	
	},	
}