
local o = LinksList_Talents;

-- Plugin_t_Init: ()
--
-- OnEvent_TalentLinksDB1_TALENT_NUM_RANKS_CHANGED: (talentID, oldNumRanks, newNumRanks)
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
	
	EventsManager2.RegisterForEvent(o.OnEvent_TalentLinksDB1_TALENT_NUM_RANKS_CHANGED, nil, "TalentLinksDB1_TALENT_NUM_RANKS_CHANGED", false, false);
	
	local sortTypes = {
		[1] = { name = o.Localization.NAME; sorterCreator = o.TalentLinksDB1.CreateNameAndRankSorter; nil, nil, nil, false, false, true };
	};
	o.LinksList.Sections_t_AddSection("Talents", o.Localization.TALENTS, "name", o, sortTypes, o.Localization.NAME, false);
end




function o.OnEvent_TalentLinksDB1_TALENT_NUM_RANKS_CHANGED(talentID)
	o.LinksList.Sections_OnLinkAdded("Talents", talentID);
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (params.name ~= nil) then
		local textToMatch = params.name;
		if (allowRegExps ~= true) then
			textToMatch = textToMatch:NicheDevTools_EscapePatterns();
		end
		textToMatch = textToMatch:NicheDevTools_CaseInsensitize();
		o.NAME_CHECK.func = o.TalentLinksDB1.IsDataMatch;
		o.NAME_CHECK.arg = o.TalentLinksDB1.CreateMatcher(textToMatch);
		checksArray[#checksArray + 1] = o.NAME_CHECK;
	end
end




function o.GetDBSize()
	return o.TalentLinksDB1.GetDBSize();
end



function o.IterateDB(keysOnly, sortedByDefault)
	return o.TalentLinksDB1.IterateDB(keysOnly, sortedByDefault);
end



function o.GetLinkDisplayName(linkID)
	local name, numRanks = o.TalentLinksDB1.SplitData(o.TalentLinksDB1.GetData(linkID));
	local rank = o.TalentLinksDB1.GetRank(linkID);
	return ("|cff4e96f7%s (%d/%d)|r"):format(name, rank, numRanks);
end



function o.GetLinkTooltipHyperlink(linkID)
	return o.TalentLinksDB1.BuildLink(linkID);
end


function o.GetLinkChatHyperlink(linkID)
	return o.TalentLinksDB1.BuildChatlink(linkID);
end



function o.BuildQuickSearchLinkNameMatcher(text, allowRegExps)
	if (allowRegExps ~= true) then
		text = text:NicheDevTools_EscapePatterns();
	end
	text = text:NicheDevTools_CaseInsensitize();
	return o.TalentLinksDB1.CreateMatcher(text), o.TalentLinksDB1.IsDataMatch, nil, o.TalentLinksDB1.GetData;
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
