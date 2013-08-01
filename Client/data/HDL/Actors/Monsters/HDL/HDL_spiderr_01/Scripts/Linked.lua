skills = {}
stance = {}
SkillCtrl = {}

EventFunc = 
{
	Init = function(this, action)
		this.action = action;
	end,
	
	Update =  function(this)
		if this.time == nil then
			return;
		end
		
		if this.triggered == false and Self:Time() - this.beginTime >= this.time then
			this.triggered = true;
			
			if this.Func ~= nil then
				this:Func();
			end
		end
	end,
	
	SysEnter = function(this)
		this.beginTime = Self:Time();
		this.triggered = false;
	end,
	
	SysLeave = function(this)
	end,
}

ActionFunc =
{
	Init = function(this, skill)
		this.skill = skill;
		
		local skillAction = this.skill.Actions[this.nextAction];
		if skillAction ~= nil then
			this.time = Self:GetActionTime(this.name, skillAction.name);
		else
			this.time = Self:GetActionTime(this.name, this.nextAction);
		end
		
		--将动作时间设置为特定长度
		--if this.fixTime ~= nil then
		--	this.time = this.fixTime;
		--end
		
		if this.Events ~= nil then
			for k in pairs(this.Events) do
				SetTableFunc(this.Events[k], EventFunc);
				this.Events[k]:Init(this);
			end
		end
	end,
	
	SysEnter = function(this, isLoopEnter)
		Self:DebugPrint("[lua]Action Enter:" .. this.name .. " " .. this.time);
		--Self:ChangeAction(this.name);
		Self:SetUpbody(this.upbody);
		Self:SetStance(this.stance);
		this.beginTime = Self:Time();
		this.isActive = true;
		this.isPaused = false;
		this.pauseTime = 0;
		
		if isLoopEnter == nil then
			this.leftTime = this.fixTime;
		end
		
		if this.skill.isCollideDown then
			this:OnEvent("SysCollideDown");
		end
		
		if this.Events ~= nil then
			for k, v in pairs(this.Events) do
				v:SysEnter();
			end
			
			if this.Events.ActionBegin ~= nil then
				this.Events.ActionBegin:Func();
			end
		end
	end,
	
	SysLeave = function(this)
		if this.Events ~= nil then
			for k, v in pairs(this.Events) do
				v:SysLeave();
			end
			
			if this.Events.ActionEnd ~= nil then
				this.Events.ActionEnd:Func();
			end
		end
		
		Self:CancelEffect("ACTION");
	end,
	
	OnEvent = function(this, name, args)
		Self:DebugPrint("event:" .. name .. "------------------------");
		
		if this.Events ~= nil then
			local ent = this.Events[name];
			if ent ~= nil then
				ent.args = args;
				ent:Func();
			end
		end
		
		Self:DebugPrint("stance:" .. this.stance .. "------------------------");
		local curStance = stance[this.stance];
		if curStance ~= nil then
			local funcName = curStance[name];
			if funcName ~= nil then
				funcName(name, args);
			end
		end
	end,
	
	Update = function(this)
		if this.isActive == false then
			return;
		end
		
		if this.leftTime ~= nil then
			this.leftTime = this.leftTime - Self:TimeDelta();
			if this.leftTime <= 0 then
				this.isActive = false;
				
				return;
			end
		end
		
		if this.isPaused then
			local timeDelta = Self:TimeDelta();
			
			this.pauseTime = this.pauseTime - timeDelta;
			if this.pauseTime < 0 then
				this:Resume();
			else	
				this.beginTime = this.beginTime + timeDelta;
				
				if this.Events ~= nil then
					for k, v in pairs(this.Events) do
						v.beginTime = v.beginTime + timeDelta;
					end
				end
				
				return;
			end
		end
		
		if (Self:Time() - this.beginTime >= this.time) then
			if this.loop then
				this:SysEnter(true);
			else
				this.isActive = false;	
			end
		end
		
		if this.Events ~= nil then
			for k, v in pairs(this.Events) do
				v:Update();
			end
		end
		
		--上下半身分割的技能全身的动作早客户端来设置
		if this.upbody == nil then
			Self:ChangeAction(this.name);
		end
	end,
	
	IsEventTriggered = function(this, eventName)
		if this.Events ~= nil then
			for k, v in pairs(this.Events) do
				if k == eventName and v.triggered then
					return true;
				end
			end
		end
		
		return false;
	end,
	
	Pause = function(this, t)
		Self:PauseAction();
		this.isPaused = true;
		this.pauseTime = t;
	end,
	
	Resume = function(this)
		Self:ResumeAction();
		this.isPaused = false;
		this.pauseTime = 0;
	end,
}

SkillFunc = 
{
	Init = function(this)
		if this.Actions ~= nil then
			for k in pairs(this.Actions) do
				SetTableFunc(this.Actions[k], ActionFunc);
				this.Actions[k]:Init(this);
			end
		end
	end,
	
	SysEnter = function(this)
		Self:OnSkillEnter(this.name);
		
		Self:EndSwordLight{};
		Self:EndGhost{hand = "body",};
		Self:EndGhost{hand = "both",};
		Self:ResumeAction();
		Self:SetJumpAccel(-10);
		this.isCollideDown = false;
		
		if this.Actions ~= nil then
			if this.randAction then
				this.curAction = this:SelectRandAction();--this.Actions[math.random(table.getn(this.Actions))];
			else
				this.curAction = this:SelectAction();
			end
		end
		
		if this.curAction ~= nil then
			if this.Enter ~= nil then
				this:Enter();
			end
			
			this.curAction:SysEnter();
		end
		
		this:OnCtrlEvent("SkillEnter");
	end,
	
	SysLeave = function(this)
		if this.curAction ~= nil then
			this.curAction:SysLeave();
		end
		
		Self:DebugPrint("Skill Leave:" .. this.name);
		if this.Leave ~= nil then
			this:Leave();
		end
		
		Self:OnSkillLeave();
		this:OnCtrlEvent("SkillLeave");
		Self:CancelEffect("SKILL");
	end,
	
	OnEvent = function(this, name, args)
		if name == "SysCollideDown" then
			this.isCollideDown = true;
		end
		
		if this.curAction ~= nil then
			this.curAction:OnEvent(name, args);
		end
	end,
	
	Update = function(this)
		if this.curAction ~= nil then
			this.curAction:Update();
			
			if this.curAction.isActive == false then
				this:NextAction();
			end
		end
		
		if this.UpdateCtrl ~= nil and Config.isMain then
			local curActionName = "";
			if this.curAction ~= nil then
				curActionName = this.curAction.name;
			end
			
			this:UpdateCtrl(curActionName);
		end
	end,	
	
	NextAction = function(this)
		if this.curAction ~= nil and this.curAction.nextAction ~= nil then
			this.curAction:SysLeave();
			this.curAction = this:FindActionByKey(this.curAction.nextAction);
			 
			if this.curAction ~= nil then
				this.curAction:SysEnter();
			end
		end
	end,
	
	FindActionByKey = function(this, key)
		if this.Actions ~= nil then
			--[[
			for k in pairs(this.Actions) do
				if this.Actions[k].name == actionName then
					return this.Actions[k];
				end
			end]]
			
			for k, v in pairs(this.Actions) do
				if k == key then
					return v;
				end
			end
		end
		
		return nil;
	end,
	
	SelectAction = function(this)
		if this.Actions == nil then
			return;
		end
		
		local selAction = nil;
		
		for k in pairs(this.Actions) do
			local curAction = this.Actions[k];
			if curAction.priority ~= nil and curAction.IsReady ~= nil and curAction.IsReady() then
				if selAction == nil then
					selAction = curAction;
				elseif selAction.priority < curAction.priority then
					selAction = curAction;
				end
			end
		end
		
		return selAction;
	end,
	
	SelectRandAction = function(this)
		local normalAction = this:SelectAction();
		if this:IsRandAction(normalAction) then
			local key = this.randAction[math.random(table.getn(this.randAction))];
			Self:DebugPrint("[lua]rand action:" .. key);
			return this.Actions[key];
		else
			return normalAction;
		end
	end,
	
	IsRandAction = function(this, act)
		for k, v in pairs(this.randAction) do
			if this.Actions[v] == act then
				return true;
			end
		end
		
		return false;
	end,
	
	IsEventTriggered = function(this, eventName)
		if this.Actions ~= nil then
			for k, v in pairs(this.Actions) do
				if v:IsEventTriggered(eventName) then
					return true;
				end
			end
		end
		
		return false;
	end,
	
	OnCtrlEvent = function(this, eventName)
		if this.CtrlEvent ~= nil and Config.isMain then
			this:CtrlEvent(eventName);
		end 
	end,
}

SkillMgr = 
{
	curSkill = nil,
	selectedSkill = nil,
	
	OnEvent = function(this, name, args)
		if this.curSkill ~= nil then
			this.curSkill:OnEvent(name, args);
		end
	end,
	
	ReEnter = function(this)
		if this.curSkill ~= nil then
			Self:DebugPrint("[lua]ReEnter");
			this.curSkill:SysEnter();
		end
	end,
	
	--播放技能
	PlaySkill = function(this, key)
		this:ChangeTo(skills[key]);
	end,
	
	CancelSkill = function(this, key)
		if this.curSkill ~= nil then
			this.curSkill:NextAction();
		end
	end,
	
	--播放被击
	PlayHit = function(this, hitName)
		this:ChangeTo(hit[hitName]);
	end,
	
	--内部转换函数
	ChangeTo = function(this, skill)
		if skill ~= nil then
			Self:DebugPrint("[lua]ChangeTo:" .. skill.name);
			
			if this.curSkill ~= nil then
				this.curSkill:SysLeave();
			end
			
			this.curSkill = skill;
			this.curSkill:SysEnter();
		end
	end,
	
	--技能当前是否可用
	IsSkillReady = function(this, skillID)
		local skill = skills[skillID];
		if skill ~= nil then
			return skill:IsReady();
		end
		
		return false;
	end,
	
	Update = function(this, delta)
		if this.curSkill ~= nil then
			this.curSkill:Update();
			if this.curSkill.curAction == nil then
				if this.curSkill.nextSkill ~= nil then
					this:PlaySkill(this.curSkill.nextSkill);
				else
					this.curSkill:SysLeave();
					this.curSkill = nil;
				end
			end
		end
		
		if this.curSkill == nil then
			this:PlaySkill("Idle");
		end
	end,	
}

function SetTableFunc(t0, t1)
	if t0 == nil or t1 == nil then
		return;
	end
	
	for k in pairs(t1) do
		t0[k] = t1[k];
	end
end

---------------------------------------------------------------------------------------------------------
--角色脚本初始化时调用一次
function Init()
	for k in pairs(skills) do
		SetTableFunc(skills[k], SkillFunc);
		SetTableFunc(skills[k], SkillCtrl[k]);
		skills[k]:Init();
	end
	
	Self:DebugPrint("[lua]Script inited");
	
	if Config.InitEffect ~= nil then
		Self:DebugPrint("[lua]InitEffect");
		for k, v in pairs(Config.InitEffect) do
			Self:DebugPrint("[lua]InitEffect" .. v);
			Self:PlayLocalEffect{id = v};
		end
	end
end

--每帧调用
function Update(delta)
	SkillMgr:Update(delta);
end

function PlaySkill(skillID)
	SkillMgr:PlaySkill(skillID);
end

function CancelSkill(skillID)
	SkillMgr:CancelSkill(skillID);
end

--播放基础动作
function PlayBase(actionName)
	SkillMgr:PlaySkill(actionName);
end

--重新播放当前动作
function ReEnter()
	SkillMgr:ReEnter();
end

function OnEvent(name, args)
	SkillMgr:OnEvent(name, args);
end

function SetConfig(key, value)
	Config[key] = value;
end

--设置技能动作的时间
function SetBaseTime(skillName, time)
	skill = skills[skillName];
	if skill ~= nil and skill.Actions ~= nil then
		for k, v in pairs(skill.Actions) do
			v.time = time;
			v.loop = false;
		end
	end
end



Ctrl = 
{
	MOVE = 0,
	ATK = 1,
	
	TurnToKeyboardDir = function(this, rotate)
		local kd = nil;
		if this:IsRunUp() and this:IsRunLeft() then
			kd = "WA";
		elseif this:IsRunUp() and this:IsRunRight() then
			kd = "WD";
		elseif this:IsRunLeft() and this:IsRunDown() then
			kd = "AS";
		elseif this:IsRunDown() and this:IsRunRight() then
			kd = "SD";
		elseif this:IsRunUp() then
			kd = "W";
		elseif this:IsRunLeft() then
			kd = "A";
		elseif this:IsRunDown() then
			kd = "S";
		elseif this:IsRunRight() then
			kd = "D";
		end
		
		if rotate == nil then
			rotate = true;
		end
		
		if kd ~= nil then
			Self:TurnToDir(kd);
		end
		
		return kd;
	end,
	
	TurnToRandDir = function(this)
		local dirset = {"WA", "WD", "AS", "SD", "W", "A", "S", "D",};
		local kd = dirset[math.random(table.getn(dirset))];
		Self:TurnToDir(kd);
	end,
	
	TurnToMouse = function(this)
		Self:TurnToMouse();
	end,
	
	HaveAttackTarget = function(this)
		return Self:HaveAttackTarget();
	end,
	
	TurnToAttackTarget = function(this)
		Self:TurnToAttackTarget();
	end,
	
	IsKeyboardRun = function(this)
		return this:IsRunLeft() or this:IsRunRight() or this:IsRunUp() or this:IsRunDown();
	end,
	
	IsRunLeft = function(this)
		return Self:IsKeyDown(CtrlMap["RunLeft"].Key);
	end,	
	
	IsRunRight = function(this)
		return Self:IsKeyDown(CtrlMap["RunRight"].Key);
	end,
	
	IsRunUp = function(this)
		return Self:IsKeyDown(CtrlMap["RunUp"].Key);
	end,
	
	IsRunDown = function(this)
		return Self:IsKeyDown(CtrlMap["RunDown"].Key);
	end,
	
	IsJump = function(this)
		return Self:IsKeyClicked(CtrlMap["Jump"].Key);
	end,
	
	IsDefense = function(this)
		return Self:IsKeyClicked(CtrlMap["Defense"].Key);
	end,
	
	IsDash = function(this)
		--1.双击WSAD
		--[[
		if Self:IsKeyDoubleClicked(CtrlMap["RunLeft"].Key) or 
		   Self:IsKeyDoubleClicked(CtrlMap["RunRight"].Key) or 
		   Self:IsKeyDoubleClicked(CtrlMap["RunUp"].Key) or 
		   Self:IsKeyDoubleClicked(CtrlMap["RunDown"].Key) then
			return true;
		end]]
		
		--2.Shift + WSAD
		if this:IsKeyboardRun() and Self:IsKeyClicked("LSHIFT") then
			return true;
		end
		
		return false;
	end,
	
	--使用技能的条件
	IsUseSkill = function(this)
		--使用普通攻击
		if this:IsUseAtk() then
			return GetSkillID(Ctrl.ATK);
		end
		
		--点击键盘对应快捷键（如上图1、2、3、4、5、6、Q、E）后直接施放；
		if SkillTable ~= nil then
			for k, v in pairs(SkillTable) do
				if Self:IsKeyClicked(k) then
					return v;
				end
			end
		end
		
		--将技能ICON拖入鼠标右键快捷栏框中时，按下鼠标右键后
		if Config.mouseRight ~= Ctrl.MOVE and Config.mouseRight ~= Ctrl.ATK and Self:IsMouseRClicked() then
			return Config.mouseRight;
		end
		
		return 0;
	end,
	
	--使用的技能是否为常按状态
	IsUseSkillPressed = function(this, skillID)
		Self:DebugPrint("[skillpressed]right:" .. Config.mouseRight .. " left:" .. Config.mouseLeft);
		
		if GetSkillID(Ctrl.ATK) == skillID then
			skillID = Ctrl.ATK;
		end
		
		if Config.mouseRight == skillID and Self:IsMouseRDown() then
			Self:DebugPrint("[skillpressed]is mouse r down");
			
			return true;
		end
		
		if Config.mouseLeft == skillID and Self:IsMouseLDown() then
			Self:DebugPrint("[skillpressed]is mouse l down");
			
			return true;
		end
		
		Self:DebugPrint("[skillpressed]nothing is mouse r down");
		
		return false;
	end,
	
	--施放普通攻击的条件
	IsUseAtk = function(this)
		if Config.mouseLeft == Ctrl.ATK and Self:IsMouseLClicked() then
			return true;
		elseif Config.mouseRight == Ctrl.ATK and Self:IsMouseRClicked() then
			return true;
		else
			return false;
		end
	end,
	
	--是否是鼠标移动
	IsAutoRun = function(this)
		if Config.mouseLeft == Ctrl.MOVE and Self:IsMouseLClicked() then
			return true;
		elseif Config.mouseRight == Ctrl.MOVE and Self:IsMouseRClicked() then
			return true;
		else
			return false;
		end
	end,
	
	--是否与NPC对话
	IsClickNpc = function(this)
		return Self:IsMouseLClicked() and Self:GetMouseActorType() == "NPC";
	end,
	
	ClickNpc = function(this)

	end,
	
	--使用技能时与服务器通信
	UseSkill = function(this, skillID)
		SkillMgr:PlaySkill(skillID);
	end,
	
	--技能之间进行连接时使用，此时不简查当前技能能否施放
	LinkSkill = function(this, skillID)
		SkillMgr:PlaySkill(skillID);
	end,
	
	--取消技能
	CancelSkill = function(this)
		--Self:SendMsg{name = "CancelSkill", };
	end,
	
	--切换基础动作
	PlayAction = function(this, actionName)
		SkillMgr:PlaySkill(actionName);
		--Self:SendPlayAction(actionName);
		--Self:DebugPrint("[move]PlayAction:" .. actionName);
	end,
	
	StartMove = function(this)
		--Self:SendStartMove();
		--Self:DebugPrint("[luamove]startmove");
	end,
	
	StopMove = function(this)
		--Self:SendStopMove();
		--Self:DebugPrint("[luamove]stopmove");
	end,
	
	--简查技能当前是否处在下一个边接的区间内
	IsNextSkillRange = function(this, skillTable)
		return skillTable:IsEventTriggered("NextBegin");-- and (not skillTable:IsEventTriggered("NextEnd"));
	end,
	
	UpdateLinkSkill = function(this, skillTable, groupID, skillID)
		if Ctrl:IsNextSkillRange(skillTable) and skillTable.isInput then
			Ctrl:TurnToMouse();
			Ctrl:LinkSkill(skillID);
			skillTable.isInput = false;
		else
			if (Ctrl:IsUseSkill() == groupID) then
				skillTable.isInput = true;
			elseif Ctrl:IsUseSkillPressed(groupID) then
				skillTable.isInput = true;
			end
		end
	end,
	
	UpdateUseSkill = function(this, skillTable, groupID, skillID)
		if Ctrl:IsNextSkillRange(skillTable) and skillTable.isInput then
			Ctrl:TurnToAttackTarget();
			Ctrl:UseSkill(skillID);
			skillTable.isInput = false;
		else
			if (Ctrl:IsUseSkill() == groupID) then
				skillTable.isInput = true;
			end
		end
	end,
	
	--一个技能连接到其他技能，
	--skillTable 控制脚本
	--ent 在事件后
	--from 当前技能号
	--to 要切换到的技能组
	UpdateUseSkillSet = function(this, skillTable, ent, from, to)
		if skillTable:IsEventTriggered(ent) then 
			local skillID = Ctrl:IsUseSkill();
			
			if to ~= nil then
				for k, v in pairs(to) do
					if to[k] == skillID then
						Ctrl:TurnToAttackTarget();
						Ctrl:UseSkill(skillID);
						break;
					end
				end
			else
				if skillID ~= 0 and skillID ~= from then
					Ctrl:TurnToAttackTarget();
					Ctrl:UseSkill(skillID);
				end
			end
		end
	end,
	
	GetMouseActorType = function(this)
		return Self:GetMouseActorType();
	end,
	
	GetAttackTargetType = function(this)
		return Self:GetAttackTargetType();
	end,
	
	--Idle
	UpdateIdle = function(this, skillTable)
		if Ctrl:IsClickNpc() then
			Ctrl:ClickNpc();
		else
			if Self:IsKeyClicked(1) then
				Ctrl:TurnToMouse();
				SkillMgr:PlaySkill(200020);
				--Ctrl:LinkSkill(200020);
				return;
			end
			
			if Self:IsMouseRDown() then
				if Self:GetWeaponID() == 1 then
					SkillMgr:PlaySkill(200011);
				elseif Self:GetWeaponID() == 2 then
					SkillMgr:PlaySkill(200012);
				else
					SkillMgr:PlaySkill(200010);
				end
			elseif Ctrl:IsKeyboardRun() then
				Ctrl:TurnToKeyboardDir();
				Ctrl:PlayAction("Run");
			--[[
			elseif Ctrl:IsAutoRun() then
				Ctrl:PlayAction("AutoRun");
			elseif Ctrl:IsJump() then
				Ctrl:PlayAction("Jump");
			else
				local skillID = Ctrl:IsUseSkill();
				if skillID ~= 0 then
					Ctrl:TurnToMouse();
					Ctrl:UseSkill(skillID);
				end]]
			end
		end
	end,
	
	UpdateRun = function(this, skillTable)
		if Ctrl:IsDash() then
			Ctrl:UseSkill(GetSkillID("Dash"));
		elseif Ctrl:IsKeyboardRun() then
			if Self:IsMouseRDown() then
				if Self:GetWeaponID() == 1 then
					SkillMgr:PlaySkill(200011);
				elseif Self:GetWeaponID() == 2 then
					SkillMgr:PlaySkill(200012);
				else
					SkillMgr:PlaySkill(200010);
				end
			elseif Ctrl:IsJump() then
				Ctrl:PlayAction("JumpForward");
			elseif Ctrl:IsUseSkill() ~= 0 then
				Ctrl:TurnToMouse();
				Ctrl:UseSkill(Ctrl:IsUseSkill());
			else
				Ctrl:TurnToKeyboardDir();
			end
		else
			Ctrl:PlayAction("Idle");
		end
	end,
	
	UpdateAutoRun = function(this)
		if Ctrl:IsDash() then
			Ctrl:UseSkill(GetSkillID("Dash"));
		elseif Ctrl:IsUseSkill() ~= 0 then
			Ctrl:TurnToMouse();
			Ctrl:UseSkill(Ctrl:IsUseSkill());
		elseif Ctrl:IsKeyboardRun() then
			Ctrl:TurnToKeyboardDir();
			Ctrl:PlayAction("Run");
		elseif Ctrl:IsAutoRun() then
			Ctrl:PlayAction("AutoRun");
		end
	end,
}

CtrlMap = {}

CtrlMap["RunUp"] =
{
	Key = "W",	
}

CtrlMap["RunDown"] =
{
	Key = "S",	
}

CtrlMap["RunLeft"] =
{
	Key = "A",		
}

CtrlMap["RunRight"] =
{
	Key = "D",	
}

CtrlMap["Jump"] =
{
	Key = "SPACE",	
}

CtrlMap["Defense"] =
{
	Key = "Q",		
}

CtrlMap["UseSkill"] =
{
	Mouse = "RIGHT",	
}

CtrlMap["Dash"] =
{
	Key = "LALT",	
}
stance["stand_free"] =
{
	["Rigide"] = function(name, args)
		Config.rigidTime = args["Time"];
		SkillMgr:PlaySkill("Rigide");
	end,
	
	["Float"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = 0;
		SkillMgr:PlaySkill("Float");
	end,
	
	["BlowOff"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = args["MoveSpeed"];
		SkillMgr:PlaySkill("BlowOff");
	end,
	
	["Dismembered"] = function(name, args)
		SkillMgr:PlaySkill("Dismembered");
	end,
}

stance["ground_action"] =
{
	["Rigide"] = function(name, args)
		Config.rigidTime = args["Time"];
		SkillMgr:PlaySkill("Rigide");
	end,
	
	["Float"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = 0;
		SkillMgr:PlaySkill("Float");
	end,
	
	["BlowOff"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = args["MoveSpeed"];
		SkillMgr:PlaySkill("BlowOff");
	end,
	
	["Dismembered"] = function(name, args)
		SkillMgr:PlaySkill("Dismembered");
	end,
}

stance["rigide"] =
{
	["Rigide"] = function(name, args)
		Config.rigidTime = args["Time"];
		SkillMgr:PlaySkill("RigideSecond");
	end,
	
	["Float"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = 0;
		SkillMgr:PlaySkill("Float");
	end,
	
	["BlowOff"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = args["MoveSpeed"];
		SkillMgr:PlaySkill("BlowOff");
	end,
	
	["Dismembered"] = function(name, args)
		SkillMgr:PlaySkill("Dismembered");
	end,
}

stance["rigidsecond"] =
{
	["Rigide"] = function(name, args)
		Config.rigidTime = args["Time"];
		SkillMgr:PlaySkill("Rigide");
	end,
	
	["Float"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = 0;
		SkillMgr:PlaySkill("Float");
	end,
	
	["BlowOff"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = args["MoveSpeed"];
		SkillMgr:PlaySkill("BlowOff");
	end,
	
	["Dismembered"] = function(name, args)
		SkillMgr:PlaySkill("Dismembered");
	end,
}

stance["down"] =
{

	

}

stance["float"] =
{
	
	["Float"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = 0;
		SkillMgr:PlaySkill("FloatHit");
	end,
	
	["BlowOff"] = function(name, args)
		Config.jumpSpeed = args["JumpSpeed"];
		Config.moveSpeed = args["MoveSpeed"];
		SkillMgr:PlaySkill("BlowOff");
	end,
}
Config =
{
	isMain = false,
	normalSkill = 1111011,
	rightSkill = 0,	
	rigidTime =0,
	
	--服务器设置的移动速度
	moveSpeed = 2.0,
	--服务器上升速度
	jumpSpeed = 5.0,
	--服务器设置的战斗态
	isBattleState = true,
	InitEffect = {602900,},	
}

MonsterConfig = Self:GetMonsterConfig();
skills["Born1"] =
{
	name = "born1",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Born"] = 
		{
			name = "born1",
			loop = false,
			stance = "born",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
			
			Events = 
			{
				
				["Particle"] = 
				{
					time = 0.8,
					Func = function(this)
						Self:PlayLocalEffect{id = 601199};
					end,
				},							
				["Sound"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlaySound{path="m5_BGM/devilplaza/Abomi_01_02.wav",  volume = 1, distance = 200};
					end,
					},

			},
		},
	},	
}
skills["Born2"] =
{
	name = "Born2",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Born"] = 
		{
			name = "born2",
			loop = false,
			stance = "born",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
		Events = 
			{
				
				["Particle"] = 
				{
					time = 0.8,
					Func = function(this)
						Self:PlayLocalEffect{id = 601199};
					end,
				},							
				["Sound"] = 
				{
					time = 0.01,
					Func = function(this)
						Self:PlaySound{path="m5_BGM/devilplaza/Abomi_01_02.wav",  volume = 1, distance = 200};
					end,
					},

			},
			
		},
	},	
}
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
			name = "death",
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
					time = 0.01,
					Func = function(this)
						--Self:PlaySound{path="m5_BGM/devilplaza/Abomi_02_02.wav",  volume = 1, distance =200};
					end,
					},
			 },
		},	
	},	
}
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
skills["Idle"] =
{
	name = "Idle",
	--randAction = {"Idle", "Idle1", "Idle2",},
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
		--Self:PlayGlobalEffect{id = 101,};
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
skills["Run"] =
{
	name = "Run",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(Config.moveSpeed);
	end,
	
	Leave = function(this)
		Self:SetMoveSpeed(0.0);
	end,
	
	Actions = 
	{
		["Run"] =
		{
			name = "Run",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Config.moveSpeed >= 5;
			end,
			
			Events = 
			{
				["LStep"] =
				{
					time = 0.02,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				
				["RStep"] =
				{
					time = 0.1,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
			},
		},	
		
		["Walk"] =
		{
			name = "Walk",
			loop = true,
			stance = "move",
			weapon = 0,
			switch = 1,
			priority = 0,
			
			IsReady = function(this)
				return Config.moveSpeed < 5;
			end,
			
			Events = 
			{
				["LStep"] =
				{
					time = 0.02,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
				
				["RStep"] =
				{
					time = 0.1,
					Func = function(this)
						Self:PlaySound{path="robot_run.wav", time = 1.0, volume = 1.0, distance = 10};
					end,	
				},	
			},
		},	
	},	
}
skills[8090] = 
{
	name = "蓄力散射",
	Actions = 
	{
		["attack1"] = 
		{
			name = "Skill1",
			loop = false,
			stance = "ground_action",
			weapon = false,
			switch = true,
			priority = 0,
			nextAction = "Idle",
			
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
skills["Stun"] =
{
	name = "Stun",
	
	IsReady = function(this)
		return true;
	end, 
	
	Enter = function(this)
		Self:SetMoveSpeed(0);
	end,
	
	Actions = 
	{
		["Stun"] = 
		{
			name = "Stun",
			loop = true,
			stance = "stun",	
			weapon = 1,
			switch = 0,
			priority = 1,
			nextAction = "idle",
			
			IsReady = function(this)
				return true;
			end,
		},
	},	
}
