Config =
{
	--玩家是否是主角
	isMain = false,
	
	--普通攻击
	--normalSkill = 1111011,
	
	--当前右键技能
	--rightSkill = 1127011,	
	
	--硬值时间
	rigidTime = 0.0,
	
	--移动速度
	moveSpeed = 5.0,
	
	--跳的速度
	jumpSpeed = 5.0,
	
	--采集目标的ID
	gatherTarget = 0,
	
	--采集时间
	gatherTime = 3.0,
	
	--鼠标左右键的信息
	--ATK, MOVE, all other is skill
	mouseRight = "ATK",
	mouseLeft = "MOVE",
}

PlayerConfig = Self:GetPlayerConfig();

SkillTable = 
{
	["1"] = 1111011,
	["2"] = 100040,
	["3"] = 100050,
	["4"] = 100060,
	["5"] = 100070,
	["6"] = 100080,
	["Q"] = 100020,
	["E"] = 1111011,
}

function GetSkillID(name)
	if name == "Dash" then
	 	return 100040;
	elseif name == "ATK" then
		return 300010;
	end
end

function OnToolInit()
	Self:SetWeapon{id=3};
	--Self:SetWeapon{model="Equipments/Glave_001.MODEL", bone="Bip01 Prop2", weaponType="Glave", hand="LEFT",};
end