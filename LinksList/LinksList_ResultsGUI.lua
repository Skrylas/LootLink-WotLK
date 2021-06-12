
local o = LinksList;


do
	local CreateFrame = CreateFrame;
	
	local resultsFrame = CreateFrame("Frame", "LinksList_ResultsFrame", UIParent, nil);
	table.insert(UISpecialFrames, "LinksList_ResultsFrame"); -- So it's closable with Esc.
	resultsFrame:Hide();
	resultsFrame:SetToplevel(true);
	resultsFrame:SetFrameStrata("MEDIUM");
	resultsFrame:SetWidth(384);
	resultsFrame:SetHeight(512);
	resultsFrame:SetHitRectInsets(0, 35, 0, 75);
	resultsFrame:EnableMouse(true);
	resultsFrame:SetMovable(true);
	resultsFrame:SetScript("OnShow", o.Results_Frame_OnShow);
	resultsFrame:SetScript("OnHide", o.Results_Frame_OnHide);
	resultsFrame:SetScript("OnDragStart", resultsFrame.StartMoving);
	resultsFrame:SetScript("OnDragStop", resultsFrame.StopMovingOrSizing);
	
	local topLeft = resultsFrame:CreateTexture("LinksList_ResultsFrameTopLeftTexture", "ARTWORK", nil);
	topLeft:SetTexture("Interface/TaxiFrame/UI-TaxiFrame-TopLeft");
	topLeft:SetWidth(256);
	topLeft:SetHeight(256);
	topLeft:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 0, 0);
	local topRight = resultsFrame:CreateTexture("LinksList_ResultsFrameTopRightTexture", "ARTWORK", nil);
	topRight:SetTexture("Interface/TaxiFrame/UI-TaxiFrame-TopRight");
	topRight:SetWidth(128);
	topRight:SetHeight(256);
	topRight:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 256, 0);
	local bottomLeft = resultsFrame:CreateTexture("LinksList_ResultsFrameBottomLeftTexture", "ARTWORK", nil);
	bottomLeft:SetTexture("Interface/TaxiFrame/UI-TaxiFrame-BotLeft");
	bottomLeft:SetWidth(256);
	bottomLeft:SetHeight(256);
	bottomLeft:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 0, -256);
	local bottomRight = resultsFrame:CreateTexture("LinksList_ResultsFrameBottomRightTexture", "ARTWORK", nil);
	bottomRight:SetTexture("Interface/TaxiFrame/UI-TaxiFrame-BotRight");
	bottomRight:SetWidth(128);
	bottomRight:SetHeight(256);
	bottomRight:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 256, -256);
	
	local portraitBackground = resultsFrame:CreateTexture("LinksList_ResultsFramePortraitBackground", "BACKGROUND", nil);
	portraitBackground:SetTexture("Interface/Spellbook/Spellbook-Icon");
	portraitBackground:SetVertexColor(0.6, 0.6, 0.6, 1.0);
	portraitBackground:SetWidth(58);
	portraitBackground:SetHeight(58);
	portraitBackground:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 10, -8);
	local portraitNameText = resultsFrame:CreateFontString("LinksList_ResultsFramePortraitNameText", "OVERLAY", "GameFontNormalLarge");
	portraitNameText:SetJustifyH("CENTER");
	portraitNameText:SetFormattedText("Links\nList");
	portraitNameText:SetPoint("CENTER", portraitBackground, "CENTER", -2, 7);
	local portraitVersionText = resultsFrame:CreateFontString("LinksList_ResultsFramePortraitVersionText", "OVERLAY", "GameFontNormalSmall");
	portraitVersionText:SetJustifyH("CENTER");
	portraitVersionText:SetFormattedText(GetAddOnMetadata("LinksList", "Version"));
	portraitVersionText:SetPoint("BOTTOM", portraitBackground, "BOTTOM", -2, 7);
	
	local closeButton = CreateFrame("Button", "LinksList_ResultsFrame_CloseButton", resultsFrame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", resultsFrame, "TOPRIGHT", -30, -8);
	
	local titleButton = CreateFrame("Button", "LinksList_ResultsFrame_TitleButton", resultsFrame, nil);
	titleButton:SetNormalFontObject(GameFontNormal);
	titleButton:SetText("LinksList " .. GetAddOnMetadata("LinksList", "Version"));
	LinksList_ResultsFrame_TitleButtonText = titleButton:GetFontString();
	LinksList_ResultsFrame_TitleButtonText:SetTextColor(1.0, 1.0, 1.0);
	titleButton:Disable();
	titleButton:SetWidth(255);
	titleButton:SetHeight(14);
	titleButton:SetPoint("TOP", resultsFrame, "TOP", 3, -16);
	titleButton:EnableMouse(true);
	titleButton:SetScript("OnEnter", o.Results_TitleButton_OnEnter);
	titleButton:SetScript("OnLeave", NicheDevTools.HideGameTooltip);
	titleButton:SetScript("OnClick", o.Results_TitleButton_OnClick);
	
	local sectionDD = CreateFrame("Frame", "LinksList_ResultsFrame_SectionDD", resultsFrame, "UIDropDownMenuTemplate");
	sectionDD:EnableMouse(true);
	UIDropDownMenu_SetWidth(sectionDD, 110);
	sectionDD:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 60, -45);
	sectionDD.initialize = o.Sections_SectionDD_Init;
	local sectionDDText = LinksList_ResultsFrame_SectionDDText;
	sectionDDText:SetJustifyH("CENTER");
	local sectionDDHeader = sectionDD:CreateFontString("LinksList_ResultsFrame_SectionDDHeaderText", "OVERLAY", "GameFontNormalSmall");
	sectionDDHeader:SetPoint("BOTTOMLEFT", sectionDD, "TOPLEFT", 20, 0);
	sectionDDHeader:SetJustifyH("LEFT");
	sectionDDHeader:SetText(o.Localization.SECTION_DD_HEADER);
	
	local sortDD = CreateFrame("Frame", "LinksList_ResultsFrame_SortTypeDD", resultsFrame, "UIDropDownMenuTemplate");
	sortDD:EnableMouse(true);
	LinksList_ResultsFrame_SortTypeDDButton:Disable();
	UIDropDownMenu_SetWidth(sortDD, 110);
	sortDD:SetPoint("LEFT", sectionDD, "RIGHT", -25, 0);
	sortDD.initialize = o.Sorting_SortTypeDD_Init;
	local sortDDText = LinksList_ResultsFrame_SortTypeDDText;
	sortDDText:SetJustifyH("CENTER");
	local sortDDHeader = sectionDD:CreateFontString("LinksList_ResultsFrame_SortTypeDDHeaderText", "OVERLAY", "GameFontNormalSmall");
	sortDDHeader:SetPoint("BOTTOMLEFT", sortDD, "TOPLEFT", 20, 0);
	sortDDHeader:SetJustifyH("LEFT");
	sortDDHeader:SetText(o.Localization.SORT_DD_HEADER);
	
	
	local scrollFrame = CreateFrame("ScrollFrame", "LinksList_ResultsFrame_ScrollFrame", resultsFrame, "FauxScrollFrameTemplate");
	scrollFrame:SetWidth(298);
	scrollFrame:SetHeight(332);
	scrollFrame:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 19, -75);
	LinksList_ResultsFrame_ScrollFrame:SetScript("OnVerticalScroll", o.Results_ScrollFrame_OnVerticalScroll);
	local topTexture = scrollFrame:CreateTexture("LinksList_ResultsFrame_ScrollFrameTopTexture", "ARTWORK", nil);
	topTexture:SetTexture("Interface/PaperDollInfoFrame/UI-Character-ScrollBar");
	topTexture:SetTexCoord(0.0, 0.484375, 0.0, 1.0);
	topTexture:SetWidth(31);
	topTexture:SetHeight(256);
	topTexture:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -2, 5);
	local bottomTexture = scrollFrame:CreateTexture("LinksList_ResultsFrame_ScrollFrameBottomTexture", "ARTWORK", nil);
	bottomTexture:SetTexture("Interface/PaperDollInfoFrame/UI-Character-ScrollBar");
	bottomTexture:SetTexCoord(0.515625, 1.0, 0.0, 0.4140625);
	bottomTexture:SetWidth(31);
	bottomTexture:SetHeight(106);
	bottomTexture:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", -2, -2);
	
	
	local linkButtons = {};
	o.Results_LINK_BUTTONS = linkButtons;
	local button, buttonText;
	
	for index = 1, 22, 1 do
		button = CreateFrame("Button", ("LinksList_ResultsFrame_LinkButton" .. index), resultsFrame, nil);
		linkButtons[index] = button;
		button:Hide();
		button:SetID(index);
		button:SetWidth(300);
		button:SetHeight(16);
		button:SetScript("OnEnter", o.Results_LinkButton_OnEnter);
		button:SetScript("OnLeave", o.Results_LinkButton_OnLeave);
		button:SetScript("OnClick", o.Results_LinkButton_OnClick);
		button:EnableMouse(true);
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		if (index == 1) then
			button:SetPoint("TOPLEFT", resultsFrame, "TOPLEFT", 19, -76);
		else
			button:SetPoint("TOPLEFT", linkButtons[index - 1], "BOTTOMLEFT", 0, 1);
		end
		
		buttonText = button:CreateFontString(("LinksList_ResultsFrame_LinkButton" .. index .. "Text"), "OVERLAY", "GameFontNormal");
		button.TEXT = buttonText;
		button:SetFontString(buttonText);
		buttonText:SetJustifyH("LEFT");
		buttonText:SetWidth(290);
		buttonText:SetHeight(12);
		buttonText:ClearAllPoints();
		buttonText:SetPoint("LEFT", button, "LEFT", 5, 0);
	end
	
	-- This has to be a region of one of the link buttons instead of the results frame itself. Otherwise it'll be on the wrong draw level and underlap every button.
	local highlightTexture = linkButtons[1]:CreateTexture("LinksList_ResultsFrameLinkHighlightTexture", "BACKGROUND", nil);
	highlightTexture:Hide();
	highlightTexture:SetTexture(0.25, 0.25, 0.25, 1.0);
	highlightTexture:SetWidth(295);
	highlightTexture:SetHeight(16);
	
	
	local advSearchButton = CreateFrame("Button", "LinksList_ResultsFrame_AdvancedSearchButton", resultsFrame, "GameMenuButtonTemplate");
	advSearchButton:Disable();
	advSearchButton:SetWidth(130);
	advSearchButton:SetHeight(25);
	local fontObj = advSearchButton:GetNormalFontObject();
	fontObj:SetTextColor(1.0, 0.82, 0.0);
	advSearchButton:SetNormalFontObject(fontObj);
	advSearchButton:SetText(o.Localization.ADVANCED_SEARCH);
	advSearchButton:SetPoint("BOTTOMRIGHT", resultsFrame, "BOTTOMRIGHT", -36, 79);
	advSearchButton:SetScript("OnClick", (function() o.Search_Toggle(); end));
end
