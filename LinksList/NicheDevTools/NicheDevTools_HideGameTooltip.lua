

do
	local NDT = NicheDevTools;
	if (NDT == nil) then
		NDT = {};
		NicheDevTools = NDT;
	end
	
	if (NDT.HideGameTooltip == nil) then
		local GameTooltip = GameTooltip;
		NDT.HideGameTooltip = (function() GameTooltip:Hide(); end);
	end
end
