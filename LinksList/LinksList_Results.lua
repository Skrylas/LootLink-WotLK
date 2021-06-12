
local o = LinksList;

-- Results_Toggle: (enabled)
--
-- Results_PreSectionChanged: ()
-- Results_PostSectionChanged: ()
--
-- Results_OnResultsChanged: ()
-- Results_UpdateTitle: ()
-- Results_UpdateCurrentPage: ()
-- Results_ShowLinkButtonTooltip: (button)
--
-- Results_LinkButton_OnEnter: (self)
-- Results_LinkButton_OnLeave: ()
-- Results_LinkButton_OnClick: (self, key)
--
-- Results_TitleButton_OnEnter: ()
-- Results_TitleButton_OnClick: ()
--
-- Results_ScrollFrame_OnVerticalScroll: (self, offset)
--
-- Results_Frame_OnShow: ()
-- Results_Frame_OnHide: ()

-- Results_LINK_BUTTONS = {};

-- config = LinksList_Config;
o.Results_notYetShown = true;




function o.Results_Toggle(enable)
	local resultsFrame = LinksList_ResultsFrame;
	if (enable == nil) then
		enable = (not resultsFrame:IsShown());
	end
	enable = ((enable and true) or nil);
	
	if (enable == true) then
		if (o.Results_notYetShown == true) then
			o.Results_notYetShown = nil;
			if (o.config.lastViewedSection ~= nil) then
				local sectionInfo, index = o.Sections_GetSection(o.config.lastViewedSection);
				if (index ~= nil) then
					o.Sections_SetCurrent(index);
				end
			end
		end
		if (o.config.actAsPanel == true) then
			ShowUIPanel(resultsFrame);
		else
			resultsFrame:Show();
		end
	else
		if (o.config.actAsPanel == true) then
			HideUIPanel(resultsFrame);
		else
			resultsFrame:Hide();
		end
	end
end




function o.Results_PreSectionChanged()
	local oldSectionInfo = o.Sections_currSectionInfo;
	if (oldSectionInfo ~= nil) then
		oldSectionInfo.scrollVal = LinksList_ResultsFrame_ScrollFrameScrollBar:GetValue();
	end
end


function o.Results_PostSectionChanged()
	local newSectionInfo = o.Sections_currSectionInfo;
	
	if (newSectionInfo ~= nil) then
		LinksList_ResultsFrame_TitleButton:Enable();
		LinksList_ResultsFrame_AdvancedSearchButton:Enable();
		LinksList_ResultsFrame_ScrollFrameScrollBar:SetValue(newSectionInfo.scrollVal);
		
		if (newSectionInfo.needsFirstSearch ~= true) then
			o.Results_UpdateTitle();
			o.Results_UpdateCurrentPage();
		end
	else
		LinksList_ResultsFrame_TitleButton:Disable();
		LinksList_ResultsFrame_TitleButton:SetText("LinksList " .. GetAddOnMetadata("LinksList", "Version"));
		LinksList_ResultsFrame_TitleButtonText:SetTextColor(1.0, 1.0, 1.0);
		LinksList_ResultsFrame_AdvancedSearchButton:Disable();
		-- (frame, numInList, numButtons, buttonHeight, button, smallWidth, bigWidth, highlightFrame, smallHighlightWidth, bigHighlightWidth, alwaysShowScrollBar)
		FauxScrollFrame_Update(LinksList_ResultsFrame_ScrollFrame, 0, 22, 32, nil, nil, nil, nil, nil, nil, true);
		for index, button in ipairs(o.Results_LINK_BUTTONS) do
			button.linkID = nil;
			button:Hide();
		end
	end
end




function o.Results_OnResultsChanged(skipSort)
	LinksList_ResultsFrame_ScrollFrameScrollBar:SetValue(0);
	local info = o.Sections_currSectionInfo;
	info.hasNewLinks = nil;
	if (skipSort ~= true) then
		o.Sorting_SetSortType(info.sortTypeData, (info.sortIsReversed == true));
	else
		o.Results_UpdateCurrentPage();
	end
	o.Results_UpdateTitle();
	o.ToggleButton_OnNewLinksFlagChanged();
end



do
	local loc_TITLE_BUTTON_TEXT = o.Localization.TITLE_BUTTON_TEXT;
	
	function o.Results_UpdateTitle()
		local info = o.Sections_currSectionInfo;
		local numTotal = info.funcs.GetDBSize();
		local numResults = #info.resultsArray;
		local percentage = ((numTotal == numResults and "100") or (("%5.3f"):format((numResults / numTotal) * 100)));
		LinksList_ResultsFrame_TitleButton:SetText(loc_TITLE_BUTTON_TEXT:format(numResults, percentage, numTotal, info.linkTypeName));
		LinksList_ResultsFrame_TitleButtonText:SetTextColor(1.0, 1.0, ((info.hasNewLinks == true and 0.0) or 1.0));
	end
end



function o.Results_UpdateCurrentPage()
	local info = o.Sections_currSectionInfo;
	local resultsArray = info.resultsArray;
	-- (frame, numInList, numButtons, buttonHeight, button, smallWidth, bigWidth, highlightFrame, smallHighlightWidth, bigHighlightWidth, alwaysShowScrollBar)
	FauxScrollFrame_Update(LinksList_ResultsFrame_ScrollFrame, #resultsArray, 22, 32, nil, nil, nil, nil, nil, nil, true);
	local offset = LinksList_ResultsFrame_ScrollFrame.offset;
	
	local GameTooltip = GameTooltip;
	local GetLinkDisplayName = info.funcs.GetLinkDisplayName;
	
	local linkID;
	for index, button in ipairs(o.Results_LINK_BUTTONS) do
		linkID = resultsArray[index + offset];
		if (linkID ~= nil) then
			button.linkID = linkID;
			button:SetText(GetLinkDisplayName(linkID));
			if (GameTooltip:IsOwned(button) ~= nil) then
				o.Results_ShowLinkButtonTooltip(button);
			end
			button:Show();
		else
			button.linkID = nil;
			button:Hide();
		end
	end
end



do
	local loc_NOT_SAFE_TO_LINK_HEADER = o.Localization.NOT_SAFE_TO_LINK_HEADER;
	local loc_NOT_SAFE_TO_LINK = o.Localization.NOT_SAFE_TO_LINK;
	
	function o.Results_ShowLinkButtonTooltip(button)
		local funcs = o.Sections_currSectionInfo.funcs;
		
		local link, name;
		local linkID = button.linkID;
		local IsLinkSafeToLink = funcs.IsLinkSafeToLink;
		if (funcs.IsLinkSafeToLink == nil or funcs.IsLinkSafeToLink(linkID) == true) then
			link = funcs.GetLinkTooltipHyperlink(linkID);
		else
			link = false;
			name = funcs.GetLinkDisplayName(linkID);
		end
		
		local tooltip = GameTooltip;
		tooltip:SetOwner(button, "ANCHOR_NONE");
		tooltip:SetPoint("TOPLEFT", LinksList_ResultsFrame, "TOPRIGHT", -30, -10);
		if (link) then
			tooltip:SetHyperlink(link);
		else
			tooltip:SetText(loc_NOT_SAFE_TO_LINK_HEADER);
			tooltip:AddLine(loc_NOT_SAFE_TO_LINK, 1.0, 0.82, 0.0, true);
			tooltip:AddLine(" ");
			local func = funcs.PopulateFakeLinkTooltip;
			if (func ~= nil) then
				func(tooltip, linkID);
			end
			if (func == nil or tooltip:NumLines() == numLines) then
				tooltip:AddLine(name);
			end
			tooltip:Show();
		end
	end
end




function o.Results_LinkButton_OnEnter(self)
	local highlightTexture = LinksList_ResultsFrameLinkHighlightTexture;
	highlightTexture:ClearAllPoints();
	highlightTexture:SetPoint("LEFT", self, "LEFT", 2, -1);
	highlightTexture:Show();
	
	o.Results_ShowLinkButtonTooltip(self);
end



function o.Results_LinkButton_OnLeave()
	LinksList_ResultsFrameLinkHighlightTexture:Hide();
	GameTooltip:Hide();
end



function o.Results_LinkButton_OnClick(self, key)
	if (key == "LeftButton") then
		local info = o.Sections_currSectionInfo;
		local linkID = self.linkID;
		local link = info.funcs.GetLinkChatHyperlink(linkID);
		
		if (IsModifiedClick("CHATLINK") ~= nil) then
			ChatEdit_InsertLink(link);
		elseif (IsModifiedClick("DRESSUP") ~= nil) then
			DressUpItemLink(link);
		else
			SetItemRef(link);
		end
	end
end




do
	local loc_RECENTLY_ADDED_TOOLTIP_HEADER = o.Localization.RECENTLY_ADDED_TOOLTIP_HEADER;
	local loc_RECENTLY_ADDED_TOOLTIP_TRAILER = o.Localization.RECENTLY_ADDED_TOOLTIP_TRAILER;
	local loc_RECENTLY_ADDED_TOOLTIP_TRAILER_BRUTE_FORCE = o.Localization.RECENTLY_ADDED_TOOLTIP_TRAILER_BRUTE_FORCE;
	
	function o.Results_TitleButton_OnEnter()
		local info = o.Sections_currSectionInfo;
		
		local tooltip = GameTooltip;
		tooltip:SetOwner(LinksList_ResultsFrame, "ANCHOR_NONE");
		tooltip:SetPoint("TOPLEFT", LinksList_ResultsFrame, "TOPRIGHT", -30, -10);
		tooltip:SetText(loc_RECENTLY_ADDED_TOOLTIP_HEADER);
		
		local recentlyAdded = info.recentlyAdded;
		if (recentlyAdded ~= nil) then
			local GetLinkDisplayName = info.funcs.GetLinkDisplayName;
			for index, ID in ipairs(recentlyAdded) do
				tooltip:AddLine(index .. ": " .. GetLinkDisplayName(ID));
			end
		else
			tooltip:AddLine(NONE, 1.0, 1.0, 1.0);
		end
		
		tooltip:AddLine(" ");
		local trailer = loc_RECENTLY_ADDED_TOOLTIP_TRAILER;
		if (info.funcs.AddByBruteForce ~= nil) then
			trailer = (trailer .. loc_RECENTLY_ADDED_TOOLTIP_TRAILER_BRUTE_FORCE);
		end
		tooltip:AddLine(trailer, 1.0, 0.82, 0.0, true);
		tooltip:Show();
	end
end



do
	local loc_BRUTE_FORCE_FEEDBACK = o.Localization.BRUTE_FORCE_FEEDBACK;
	local loc_BRUTE_FORCE_FEEDBACK_SUBSECTION = o.Localization.BRUTE_FORCE_FEEDBACK_SUBSECTION;
	
	function o.Results_TitleButton_OnClick()
		local info = o.Sections_currSectionInfo;
		if (IsAltKeyDown() ~= nil) then
			if (info.funcs.AddByBruteForce ~= nil) then
				local numNew, numUpdated = info.funcs.AddByBruteForce();
				DEFAULT_CHAT_FRAME:AddMessage(loc_BRUTE_FORCE_FEEDBACK:format(info.linkTypeName, numNew, numUpdated));
			end
			if (info.subsections ~= nil) then
				local subsectionNumNew, subsectionNumUpdated;
				for index, subsection in ipairs(info.subsections) do
					if (subsection.funcs.AddByBruteForce ~= nil) then
						subsectionNumNew, subsectionNumUpdated = subsection.funcs.AddByBruteForce();
						DEFAULT_CHAT_FRAME:AddMessage(
							loc_BRUTE_FORCE_FEEDBACK_SUBSECTION:format(info.linkTypeName, subsection.displayName, subsectionNumNew, subsectionNumUpdated)
						);
					end
				end
			end
		end
		
		if (info.searchParams ~= nil) then
			o.Search_PerformSearch();
		else
			o.Search_SearchByNameOnly(LinksList_ResultsFrame_QuickSearchFrame_EditBox:GetText());
		end
	end
end




function o.Results_ScrollFrame_OnVerticalScroll(self, offset)
	LinksList_ResultsFrame_ScrollFrameScrollBar:SetValue(offset);
	-- 32 is the height of the buttons.
	self.offset = math.floor((offset / 32) + 0.5);
	-- Can be nil when switching from a section with the scrollbar not at the top to the None section.
	if (o.Sections_currSectionInfo ~= nil) then
		o.Results_UpdateCurrentPage();
	end
end




function o.Results_Frame_OnShow()
	PlaySound("igMainMenuOpen");
end


function o.Results_Frame_OnHide(self)
	PlaySound("igMainMenuClose");
	o.Search_Toggle(false);
	GameTooltip:Hide();
	self:SetUserPlaced(false);
	o.config.resultsX, o.config.resultsY = self:GetCenter();
end
