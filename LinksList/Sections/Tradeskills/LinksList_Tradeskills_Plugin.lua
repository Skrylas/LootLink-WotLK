
local o = LinksList_Tradeskills;

-- Plugin_t_Init: ()
--
-- OnEvent_TradeskillLinksDB3_ENTRY_NAME_CHANGED: -- (tsID, oldName)
--
-- AddSearchChecks: (checksArray, params, allowRegExps)
--
-- GetDBSize: size = ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByDefault)
-- GetLinkDisplayName: name = (linkID)
-- GetLinkTooltipHyperlink: link = (linkID)
-- GetLinkChatHyperlink: link = (linkID)
-- BuildQuickSearchLinkNameMatcher: matcher, matchFunc, mismatchVal, getDataFunc = (text, allowRegExps)
--
-- ArrangeSearchSectionBox: (sectionBox)

o.NAME_CHECK = { func = nil; useNotEquals = true; value = nil; skipID = true; arg = nil; };




function o.Plugin_t_Init()
	o.Plugin_t_Init = nil;
	
	EventsManager2.RegisterForEvent(o.OnEvent_TradeskillLinksDB3_ENTRY_NAME_CHANGED, nil, "TradeskillLinksDB3_ENTRY_NAME_CHANGED", false, false);
	
	local sortTypes = {
		[1] = { name = o.Localization.NAME; sorterCreator = o.TradeskillLinksDB3.CreateSorter; nil, false, false, true };
	};
	o.LinksList.Sections_t_AddSection("Tradeskills", o.Localization.TRADESKILLS, "name", o, sortTypes, o.Localization.NAME, false);
end




function o.OnEvent_TradeskillLinksDB3_ENTRY_NAME_CHANGED(tsID, oldData)
	if (oldData == nil) then
		o.LinksList.Sections_OnLinkAdded("Tradeskills", tsID);
	end
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (params.name ~= nil) then
		local textToMatch = params.name;
		if (allowRegExps ~= true) then
			textToMatch = textToMatch:NicheDevTools_EscapePatterns();
		end
		textToMatch = textToMatch:NicheDevTools_CaseInsensitize();
		o.NAME_CHECK.func = o.TradeskillLinksDB3.IsDataMatch;
		o.NAME_CHECK.arg = o.TradeskillLinksDB3.CreateMatcher(nil, textToMatch);
		checksArray[#checksArray + 1] = o.NAME_CHECK;
	end
end




function o.GetDBSize()
	return o.TradeskillLinksDB3.GetDBSize();
end



function o.IterateDB(keysOnly, sortedByDefault)
	return o.TradeskillLinksDB3.IterateDB(keysOnly, sortedByDefault);
end



function o.GetLinkDisplayName(linkID)
	return ("|cffffd000" .. o.TradeskillLinksDB3.GetData(linkID) .. "|r");
end



function o.GetLinkTooltipHyperlink(linkID)
	return o.TradeskillLinksDB3.BuildLink(linkID);
end


function o.GetLinkChatHyperlink(linkID)
	return o.TradeskillLinksDB3.BuildChatlink(linkID);
end



function o.BuildQuickSearchLinkNameMatcher(text, allowRegExps)
	if (allowRegExps ~= true) then
		text = text:NicheDevTools_EscapePatterns();
	end
	text = text:NicheDevTools_CaseInsensitize();
	return o.TradeskillLinksDB3.CreateMatcher(nil, text), o.TradeskillLinksDB3.IsDataMatch, nil, o.TradeskillLinksDB3.GetData;
end




do
	local loc_NAME_LABEL = o.Localization.NAME_LABEL;
	
	function o.ArrangeSearchSectionBox(sectionBox)
		local nameEB = o.LinksList.Search_LeaseReusableObject("section", "EditBox", "name");
		nameEB:SetHeight(20);
		nameEB:SetWidth(200);
		nameEB:SetAutoFocus(false);
		nameEB:SetNumeric(false);
		nameEB:SetMaxLetters(128);
		nameEB:SetPoint("TOPLEFT", sectionBox, "TOPLEFT", 70, -70);
		nameEB:Show();
		nameEB.LABEL:SetText(loc_NAME_LABEL);
		nameEB.LABEL:Show();
	end
end
