
local o = LinksList;

-- ToggleButton_Toggle: (enable)
--
-- ToggleButton_OnNewLinksFlagChanged: ()
--
-- ToggleButton_OnEnter: (self)
-- ToggleButton_OnDragStop: (self)




function o.ToggleButton_Toggle(enable)
	local button = LinksList_ToggleButton;
	if (enable == nil) then
		enable = (not button:IsShown());
	end
	enable = ((enable and true) or nil);
	
	if (enable == true) then
		button:Show();
		o.ToggleButton_OnNewLinksFlagChanged();
	else
		button:Hide();
	end
end




function o.ToggleButton_OnNewLinksFlagChanged()
	if (LinksList_ToggleButton:IsShown() == nil) then
		return;
	end
	
	local sections = o.Sections_sections;
	local index = 1;
	local sectionInfo = sections[1];
	while (sectionInfo ~= nil and sectionInfo.hasNewLinks ~= true) do
		index = (index + 1);
		sectionInfo = sections[index];
	end
	
	if (sectionInfo ~= nil and sectionInfo.hasNewLinks == true) then
		LinksList_ToggleButtonText:SetTextColor(1.0, 1.0, 0.0);
	else
		LinksList_ToggleButtonText:SetTextColor(1.0, 1.0, 1.0);
	end
end




do
	local loc_RECENTLY_ADDED_TOOLTIP_HEADER = o.Localization.RECENTLY_ADDED_TOOLTIP_HEADER;
	
	function o.ToggleButton_OnEnter(self)
		local tooltip = GameTooltip;
		tooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
		tooltip:SetText(loc_RECENTLY_ADDED_TOOLTIP_HEADER);
		
		local recentlyAdded, GetLinkDisplayName;
		local index, ID;
		for sectionIndex, sectionInfo in ipairs(o.Sections_sections) do
			tooltip:AddLine(" ");
			if (sectionInfo.hasNewLinks == true) then
				tooltip:AddLine((sectionInfo.linkTypeName .. "..."), 1.0, 1.0, 0.0);
			else
				tooltip:AddLine(sectionInfo.linkTypeName .. "...");
			end
			
			recentlyAdded = sectionInfo.recentlyAdded;
			if (recentlyAdded ~= nil) then
				GetLinkDisplayName = sectionInfo.funcs.GetLinkDisplayName;
				index = 1;
				ID = recentlyAdded[1];
				while (index < 4 and ID ~= nil) do
					tooltip:AddLine("  " .. index .. ": " .. GetLinkDisplayName(ID));
					index = (index + 1);
					ID = recentlyAdded[index];
				end
			else
				tooltip:AddLine(NONE, 1.0, 1.0, 1.0);
			end
		end
		
		tooltip:Show();
	end
end



function o.ToggleButton_OnDragStop(self)
	self:StopMovingOrSizing();
	self:SetUserPlaced(false);
	o.config.toggleX, o.config.toggleY = self:GetCenter();
end
