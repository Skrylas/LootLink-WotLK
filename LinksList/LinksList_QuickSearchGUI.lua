
local o = LinksList;


do
	local CreateFrame = CreateFrame;
	
	local qsFrame = CreateFrame("Frame", "LinksList_ResultsFrame_QuickSearchFrame", LinksList_ResultsFrame, nil);
	qsFrame:Show();
	qsFrame:SetWidth(211);
	qsFrame:SetHeight(28);
	qsFrame:SetPoint("BOTTOMLEFT", LinksList_ResultsFrame, "BOTTOMLEFT", 12, 77);
	qsFrame:SetBackdrop({
		bgFile = ("Interface/Tooltips/UI-Tooltip-Background");
		edgeFile = ("Interface/Tooltips/UI-Tooltip-Border");
		tile = true; tileSize = 16; edgeSize = 16;
		insets = { left = 5; right = 5; top = 5; bottom = 5; };
	});
	qsFrame:SetBackdropColor(0.0, 0.0, 0.0, 1.0);
	qsFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1.0);
	
	local qsHelpText = qsFrame:CreateFontString("LinksList_ResultsFrame_QuickSearchFrameHelpText", "BACKGROUND", "ChatFontNormal");
	qsHelpText:SetPoint("CENTER", qsFrame, "CENTER", 0, 0);
	qsHelpText:SetJustifyH("CENTER");
	qsHelpText:SetTextColor(0.7, 0.7, 0.7, 1.0);
	qsHelpText:SetText(o.Localization.QUICK_SEARCH);
	
	local qseb = CreateFrame("EditBox", "LinksList_ResultsFrame_QuickSearchFrame_EditBox", qsFrame, nil);
	qseb:EnableMouse(false);
	qseb:SetAutoFocus(false);
	qseb:SetMaxLetters(64);
	qseb:SetWidth(200);
	qseb:SetHeight(20);
	qseb:SetPoint("LEFT", qsFrame, "LEFT", 8, -1);
	qseb:SetPoint("RIGHT", qsFrame, "RIGHT", -8, -1);
	qseb:SetFontObject("ChatFontNormal");
	qseb:SetTextColor(1.0, 1.0, 1.0, 1.0);
	qseb:SetShadowOffset(1, -1);
	qseb:SetShadowColor(0.0, 0.0, 0.0, 1.0);
	qseb:SetScript("OnEscapePressed", qseb.ClearFocus);
	qseb:SetScript("OnEditFocusGained", qseb.HighlightText);
	qseb:SetScript("OnEditFocusLost", o.QuickSearch_EditBox_OnEditFocusList);
	qseb:SetScript("OnTabPressed", o.QuickSearch_EditBox_OnTabPressed);
	qseb:SetScript("OnEnterPressed", o.QuickSearch_EditBox_OnEnterPressed);
	qseb:SetScript("OnTextChanged", o.QuickSearch_EditBox_OnTextChanged);
	NicheDevTools.SetupElementForSimpleTooltip(qseb, o.Localization.QUICK_SEARCH_TOOLTIP, o.Localization.QUICK_SEARCH, "ANCHOR_BOTTOMRIGHT");
end
