
SkillCtrl["Gather"] =
{
	CtrlEvent = function(this, eventName)
		if eventName == "SkillEnter" then
			this.isUpdate = true;
		end
	end,
	
	UpdateCtrl = function(this, actionName)
		
		Self:DebugPrint("gather update ctrl");
		
		if this.isUpdate == false then
			return;
		end
		
		Self:DebugPrint("gather 2");
		
		Config.gatherTime = Config.gatherTime - Self:TimeDelta();
		if Config.gatherTime <= 0.0 then
			Self:DebugPrint("gather 3:" .. Config.gatherTarget);
			Self:SendGatherObject(Config.gatherTarget);
			this.isUpdate = false;
		end
	end,	
}