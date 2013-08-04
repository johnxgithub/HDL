SkillCtrl["Shoot"] =
{
	CtrlEvent = function(this, eventName)
		if eventName == "SkillEnter" then
			this.useTime = 0.0;
			this.waitingLeave = 0.3;
		end
		
		if eventName == "SkillLeave" then
			this:Stop();
			this.switching = false;
			Self:DebugPrint("ctrl event skillleave");
		end
	end,
	
	UpdateCtrl = function(this, actionName)
		this.useTime = this.useTime + Self:TimeDelta();
		
		if this.switching then
			return;
		end
		
		--控制角色的移动与停止
		if Ctrl:IsKeyboardRun() then
			Ctrl:TurnToKeyboardDir(false);
			Self:SetMoveSpeed(3);
			this.isMoving = true;
			Self:DebugPrint("ctrl event move");
		elseif this.isMoving then
			this:Stop();
		end
		
		if not Self:IsMouseRDown() then
			this.waitingLeave = this.waitingLeave - Self:TimeDelta();
			if this.waitingLeave < 0.0 then
				this:Stop();
				this.switching = true;
				Ctrl:PlayAction("Idle");
			end
		else
			this.waitingLeave = 0.3;
		end
	end,	
	
	Stop = function(this)
		Self:SetMoveSpeed(0);
		Ctrl:StopMove();
		this.isMoving = false;
		Self:DebugPrint("ctrl event stop move");
	end,
}