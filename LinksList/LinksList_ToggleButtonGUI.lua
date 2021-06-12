
local o = LinksList;


do
	local toggleButton = CreateFrame("Button", "LinksList_ToggleButton", UIParent, nil);
	toggleButton:Hide();
	toggleButton:SetMovable(true);
	toggleButton:EnableMouse(true);
	toggleButton:SetToplevel(true);
	toggleButton:SetWidth(33);
	toggleButton:SetHeight(33);
	
	toggleButton:SetNormalFontObject(GameFontNormal);
	toggleButton:SetText("LL");
	local fontstring = toggleButton:GetFontString();
	LinksList_ToggleButtonText = fontstring;
	fontstring:SetPoint("CENTER", toggleButton, "CENTER", -1, 3);
	fontstring:SetTextColor(1.0, 1.0, 1.0);
	
	toggleButton:RegisterForDrag("LeftButton", "RightButton");
	toggleButton:SetScript("OnDragStart", toggleButton.StartMoving);
	toggleButton:SetScript("OnDragStop", o.ToggleButton_OnDragStop);
	toggleButton:SetScript("OnClick", (function() o.Results_Toggle(); end));
	toggleButton:SetScript("OnEnter", o.ToggleButton_OnEnter);
	toggleButton:SetScript("OnLeave", NicheDevTools.HideGameTooltip);
	
	local borderTexture = toggleButton:CreateTexture("LinksList_ToggleButtonBorderTexture", "ARTWORK", nil);
	borderTexture:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
	borderTexture:SetWidth(52);
	borderTexture:SetHeight(52);
	borderTexture:SetPoint("TOPLEFT");
	
	local backgroundTexture = toggleButton:CreateTexture("LinksList_ToggleButtonBackgroundTexture", "BACKGROUND", nil);
	backgroundTexture:SetTexture(0.0, 0.0, 0.0, 1.0);
	backgroundTexture:SetWidth(20);
	backgroundTexture:SetHeight(20);
	backgroundTexture:SetPoint("CENTER", toggleButton, "CENTER", 0, 1);
end
