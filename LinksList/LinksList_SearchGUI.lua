
local o = LinksList;


do
	local CreateFrame = CreateFrame;
	
	local searchFrame = CreateFrame("Frame", "LinksList_SearchFrame", UIParent, nil);
	searchFrame:Hide();
	searchFrame:SetToplevel(true);
	searchFrame:SetFrameStrata("MEDIUM");
	searchFrame:SetWidth(384);
	searchFrame:SetHeight(469);
	searchFrame:EnableMouse(true);
	searchFrame:SetMovable(true);
	searchFrame:SetBackdrop({
		bgFile = ("Interface/DialogFrame/UI-DialogBox-Background");
		edgeFile = ("Interface/DialogFrame/UI-DialogBox-Border");
		tile = true; tileSize = 32; edgeSize = 32;
		insets = { left = 11; right = 12; top = 12; bottom = 11; };
	});
	searchFrame:RegisterForDrag("LeftButton", "RightButton");
	searchFrame:SetScript("OnDragStart", searchFrame.StartMoving);
	searchFrame:SetScript("OnDragStop", searchFrame.StopMovingOrSizing);
	searchFrame:SetScript("OnShow", o.Search_Frame_OnShow);
	searchFrame:SetScript("OnHide", o.Search_Frame_OnHide);
	
	local titleBox = searchFrame:CreateTexture("LinksList_SearchFrameTitleBoxTexture", "ARTWORK", nil);
	titleBox:SetTexture("Interface/DialogFrame/UI-DialogBox-Header");
	titleBox:SetWidth(512);
	titleBox:SetHeight(64);
	titleBox:SetPoint("TOP", searchFrame, "TOP", 0, 12);
	
	local titleText = searchFrame:CreateFontString("LinksList_SearchFrameTitleBoxText", "OVERLAY", "GameFontNormal");
	titleText:SetPoint("TOP", searchFrame, "TOP", 0, -2);
	titleText:SetText(o.Localization.SEARCH_TITLE);
	
	
	local sectionBox = CreateFrame("Frame", "LinksList_SearchFrame_SectionParametersFrame", searchFrame, "OptionsBoxTemplate");
	sectionBox:SetBackdropColor(0.4, 0.4, 0.4);
	sectionBox:SetBackdropBorderColor(0.8, 0.8, 0.8);
	sectionBox:SetWidth(350);
	sectionBox:SetHeight(165);
	sectionBox:SetPoint("TOPLEFT", searchFrame, "TOPLEFT", 17, -45);
	local sectionTitleText = LinksList_SearchFrame_SectionParametersFrameTitle;
	sectionTitleText:SetTextColor(1.0, 0.82, 0.0);
	sectionTitleText:SetText(o.Localization.SECTION_PARAMETERS_TITLE);
	
	
	local subsectionBox = CreateFrame("Frame", "LinksList_SearchFrame_SubsectionParametersFrame", searchFrame, "OptionsBoxTemplate");
	subsectionBox:SetBackdropColor(0.4, 0.4, 0.4);
	subsectionBox:SetBackdropBorderColor(0.8, 0.8, 0.8);
	subsectionBox:SetWidth(350);
	subsectionBox:SetHeight(165);
	subsectionBox:SetPoint("TOPLEFT", sectionBox, "BOTTOMLEFT", 0, -40);
	local subsectionTitleText = LinksList_SearchFrame_SubsectionParametersFrameTitle;
	subsectionTitleText:SetPoint("BOTTOMLEFT", subsectionBox, "TOPLEFT", 9, 7);
	subsectionTitleText:SetTextColor(1.0, 0.82, 0.0);
	subsectionTitleText:SetText(o.Localization.SUBSECTION_PARAMETERS_TITLE);
	
	local subsectionDD = CreateFrame("Frame", "LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDD", subsectionBox, "UIDropDownMenuTemplate");
	subsectionDD:EnableMouse(true);
	UIDropDownMenu_SetWidth(subsectionDD, 110);
	subsectionDD:SetPoint("BOTTOMRIGHT", subsectionBox, "TOPRIGHT", 0, -5);
	subsectionDD.initialize = o.Search_SubsectionDD_Init;
	local subsectionDDText = LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDDText;
	subsectionDD.TEXT = subsectionDDText;
	subsectionDDText:SetJustifyH("CENTER");
	
	
	local searchButton = CreateFrame("Button", "LinksList_SearchFrame_SearchButton", searchFrame, "UIPanelButtonTemplate");
	searchButton:SetWidth(100);
	searchButton:SetHeight(25);
	searchButton:SetPoint("BOTTOMLEFT", searchFrame, "BOTTOMLEFT", 16, 16);
	searchButton:SetText(SEARCH);
	NicheDevTools.SetupElementForSimpleTooltip(searchButton, o.Localization.SEARCH_MODIFIERS_TOOLTIP, SEARCH);
	searchButton:SetScript("OnClick", o.Search_SearchButton_OnClick);
	
	local clearButton = CreateFrame("Button", "LinksList_SearchFrame_ClearButton", searchFrame, "UIPanelButtonTemplate");
	clearButton:SetWidth(100);
	clearButton:SetHeight(25);
	clearButton:SetPoint("BOTTOM", searchFrame, "BOTTOM", 0, 16);
	clearButton:SetText(o.Localization.SEARCH_CLEAR);
	clearButton:SetScript("OnClick", o.Search_ClearButton_OnClick);
	
	local closeButton = CreateFrame("Button", "LinksList_SearchFrame_CloseButton", searchFrame, "UIPanelButtonTemplate");
	closeButton:SetWidth(100);
	closeButton:SetHeight(25);
	closeButton:SetPoint("BOTTOMRIGHT", searchFrame, "BOTTOMRIGHT", -16, 16);
	closeButton:SetText(CLOSE);
	closeButton:SetScript("OnClick", (function() o.Search_Toggle(false); end));
end
