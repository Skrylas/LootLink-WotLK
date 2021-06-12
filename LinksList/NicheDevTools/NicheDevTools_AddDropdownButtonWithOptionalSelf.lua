
do
	local NDT = NicheDevTools;
	if (NDT == nil) then
		NDT = {};
		NicheDevTools = NDT;
	end
	
	if (NDT.AddDropdownButtonWithOptionalSelf == nil) then
		local function l_CallRealWithoutSelf(self, ...)
			self.owner(...);
		end
		
		NDT.AddDropdownButtonWithOptionalSelf = function(info, level)
			local didSetOwner;
			if (info.noSelfForFunc and info.func and info.owner == nil) then
				didSetOwner = true;
				info.owner = info.func;
				info.func = l_CallRealWithoutSelf;
			end
			UIDropDownMenu_AddButton(info, level);
			if (didSetOwner == true) then
				info.func = info.owner;
				info.owner = nil;
			end
		end
	end
end
