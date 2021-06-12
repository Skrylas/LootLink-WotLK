
do
	local NDT = NicheDevTools;
	if (NDT == nil) then
		NDT = {};
		NicheDevTools = NDT;
	end
	
	if (NDT.SetupElementForSimpleTooltip == nil) then
		local function l_Element_OnEnter(self)
			local tooltipText = self.TOOLTIP_TEXT;
			if (tooltipText ~= nil) then
				local tooltip = GameTooltip;
				tooltip:SetOwner(self, (self.TOOLTIP_ANCHOR or "ANCHOR_RIGHT"));
				if (self.TOOLTIP_TITLE ~= nil) then
					tooltip:SetText(self.TOOLTIP_TITLE);
				else
					tooltip:SetText(" ");
					GameTooltipTextLeft1:SetText("");
				end
				tooltip:AddLine(tooltipText, 1.0, 0.82, 0.0, true);
				tooltip:Show();
			end
		end
		
		if (NDT.HideGameTooltip == nil) then
			local GameTooltip = GameTooltip;
			NDT.HideGameTooltip = (function() GameTooltip:Hide(); end);
		end
		
		NDT.SetupElementForSimpleTooltip = function(element, tooltipText, titleText, tooltipAnchor)
			element:SetScript("OnEnter", l_Element_OnEnter);
			element:SetScript("OnLeave", NicheDevTools.HideGameTooltip);
			element.TOOLTIP_TITLE = titleText;
			element.TOOLTIP_TEXT = tooltipText;
			element.TOOLTIP_ANCHOR = tooltipAnchor;
		end
	end
end
