
local o = LinksList_Abilities;

-- Plugin_t_Init: ()
--
-- OnEvent_AbilityLinksDB2_ABILITY_NAME_CHANGED: (abilityID, oldName)
--
-- AddSearchChecks: (checksArray, params, allowRegExps)
--
-- GetDBSize: size = ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByDefault)
-- GetLinkDisplayName: name = (linkID)
-- IsLinkSafeToLink: isSafe = (linkID)
-- GetLinkTooltipHyperlink: link = (linkID)
-- GetLinkChatHyperlink: link = (linkID)
-- AddByBruteForce: numNew, numUpdated = ()
-- BuildQuickSearchLinkNameMatcher: matcher, matchFunc, mismatchVal, getDataFunc = (text, allowRegExps)
--
-- ArrangeSearchSectionBox: (sectionBox)




function o.Plugin_t_Init()
	o.Plugin_t_Init = nil;
	
	EventsManager2.RegisterForEvent(o.OnEvent_AbilityLinksDB2_ABILITY_NAME_CHANGED, nil, "AbilityLinksDB2_ABILITY_NAME_CHANGED", false, false);
	
	local sortTypes = {
		[1] = { name = o.Localization.NAME; sorterCreator = o.AbilityLinksDB2.CreateSorter; nil, false, false, true };
	};
	o.LinksList.Sections_t_AddSection("Abilities", o.Localization.ABILITIES, "name", o, sortTypes, o.Localization.NAME, false);
end




function o.OnEvent_AbilityLinksDB2_ABILITY_NAME_CHANGED(abilityID, oldName)
	if (oldName == nil) then
		o.LinksList.Sections_OnLinkAdded("Abilities", abilityID);
	end
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (params.name ~= nil) then
		local textToMatch = params.name;
		if (allowRegExps ~= true) then
			textToMatch = textToMatch:NicheDevTools_EscapePatterns();
		end
		textToMatch = textToMatch:NicheDevTools_CaseInsensitize();
		checksArray[#checksArray + 1] = {
			func = o.AbilityLinksDB2.IsDataMatch; useNotEquals = true; skipID = true; arg = o.AbilityLinksDB2.CreateMatcher(textToMatch);
		};
	end
end




function o.GetDBSize()
	return o.AbilityLinksDB2.GetDBSize();
end



function o.IterateDB(keysOnly, sortedByDefault)
	return o.AbilityLinksDB2.IterateDB(keysOnly, sortedByDefault);
end



function o.GetLinkDisplayName(linkID)
	return ("|cff71d5ff" .. o.AbilityLinksDB2.GetData(linkID) .. "|r");
end



function o.IsLinkSafeToLink(linkID)
	return (GetSpellLink(linkID) ~= nil);
end



function o.GetLinkTooltipHyperlink(linkID)
	return o.AbilityLinksDB2.BuildLink(linkID);
end


function o.GetLinkChatHyperlink(linkID)
	return o.AbilityLinksDB2.BuildChatlink(linkID);
end



function o.AddByBruteForce()
	return o.AbilityLinksDB2.CombGetSpellLink(false);
end



function o.BuildQuickSearchLinkNameMatcher(text, allowRegExps)
	if (allowRegExps ~= true) then
		text = text:NicheDevTools_EscapePatterns();
	end
	text = text:NicheDevTools_CaseInsensitize();
	return o.AbilityLinksDB2.CreateMatcher(text), o.AbilityLinksDB2.IsDataMatch, nil, o.AbilityLinksDB2.GetData;
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
