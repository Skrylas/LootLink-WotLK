
local o = LinksList_Quests;

-- Plugin_t_Init: ()
--
-- OnEvent_QuestLinksDB2_QUEST_NAME_CHANGED: (questID, oldName)
--
-- GetRGBByLevel: r, g, b = (level)
--
-- AddSearchChecks: (checksArray, params, allowRegExps)
--
-- GetDBSize: ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByDefault)
-- GetLinkDisplayName: name = (linkID)
-- GetLinkTooltipHyperlink: link = (linkID)
-- GetLinkChatHyperlink: link = (linkID)
-- BuildQuickSearchLinkNameMatcher: matcher, matchFunc, mismatchVal, getDataFunc = (text, allowRegExps)
--
-- ArrangeSearchSectionBox: (sectionBox)

o.NAME_AND_LEVEL_CHECK = { func = nil; useNotEquals = true; value = nil; skipID = true; arg = nil };




function o.Plugin_t_Init()
	o.Plugin_t_Init = nil;
	
	EventsManager2.RegisterForEvent(o.OnEvent_QuestLinksDB2_QUEST_NAME_CHANGED, nil, "QuestLinksDB2_QUEST_NAME_CHANGED", false, false);
	
	local sortTypes = {
		[1] = { name = o.Localization.NAME; sorterCreator = o.QuestLinksDB2.CreateNameSorter; nil, false, false, true };
		[2] = { name = o.Localization.LEVEL; sorterCreator = o.QuestLinksDB2.CreateLevelSorter; nil, false, false, true };
	};
	o.LinksList.Sections_t_AddSection("Quests", o.Localization.QUESTS, "name", o, sortTypes, o.Localization.NAME, false);
end




function o.OnEvent_QuestLinksDB2_QUEST_NAME_CHANGED(questID, oldName)
	if (oldName == nil) then
		o.LinksList.Sections_OnLinkAdded("Quests", questID);
	end
end




function o.GetRGBByLevel(level)
	local colorTable;
	if (level == -1) then
		colorTable = QuestDifficultyColor["difficult"];
	else
		local levelDiff = (level - UnitLevel("player"));
		if (levelDiff >= 5) then
			colorTable = QuestDifficultyColor["impossible"];
		elseif (levelDiff >= 3) then
			colorTable = QuestDifficultyColor["verydifficult"];
		elseif (levelDiff >= -2) then
			colorTable = QuestDifficultyColor["difficult"];
		elseif (-levelDiff <= GetQuestGreenRange()) then
			colorTable = QuestDifficultyColor["standard"];
		else
			colorTable = QuestDifficultyColor["trivial"];
		end
	end
	return colorTable.r, colorTable.g, colorTable.b;
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (params.name ~= nil or params.minLevel ~= nil or params.maxLevel ~= nil) then
		local textToMatch = params.name;
		if (textToMatch ~= nil) then
			if (allowRegExps ~= true) then
				textToMatch = textToMatch:NicheDevTools_EscapePatterns();
			end
			textToMatch = textToMatch:NicheDevTools_CaseInsensitize();
		end
		o.NAME_AND_LEVEL_CHECK.func = o.QuestLinksDB2.IsDataMatch;
		o.NAME_AND_LEVEL_CHECK.arg = o.QuestLinksDB2.CreateMatcher(
			textToMatch, tonumber(params.minLevel), tonumber(params.maxLevel)
		);
		checksArray[#checksArray + 1] = o.NAME_AND_LEVEL_CHECK;
	end
end




function o.GetDBSize()
	return o.QuestLinksDB2.GetDBSize();
end



function o.IterateDB(keysOnly, sortedByDefault)
	return o.QuestLinksDB2.IterateDB(keysOnly, sortedByDefault);
end



function o.GetLinkDisplayName(linkID)
	local name, level = o.QuestLinksDB2.SplitData(o.QuestLinksDB2.GetData(linkID));
	local playerLevel = UnitLevel("player");
	if (level == -1) then
		level = playerLevel;
	end
	local levelDiff = (level - playerLevel);
	local colorTable;
	if (levelDiff >= 5) then
		colorTable = QuestDifficultyColor["impossible"];
	elseif (levelDiff >= 3) then
		colorTable = QuestDifficultyColor["verydifficult"];
	elseif (levelDiff >= -2) then
		colorTable = QuestDifficultyColor["difficult"];
	elseif (-levelDiff <= GetQuestGreenRange()) then
		colorTable = QuestDifficultyColor["standard"];
	else
		colorTable = QuestDifficultyColor["trivial"];
	end
	return ("|cff%02x%02x%02x[%d] %s|r"):format((colorTable.r * 255), (colorTable.g * 255), (colorTable.b * 255), level, name);
end



function o.GetLinkTooltipHyperlink(linkID)
	return o.QuestLinksDB2.BuildLink(linkID);
end


function o.GetLinkChatHyperlink(linkID)
	return o.QuestLinksDB2.BuildChatlink(linkID);
end



function o.BuildQuickSearchLinkNameMatcher(text, allowRegExps)
	if (allowRegExps ~= true) then
		text = text:NicheDevTools_EscapePatterns();
	end
	text = text:NicheDevTools_CaseInsensitize();
	return o.QuestLinksDB2.CreateMatcher(text, nil, nil), o.QuestLinksDB2.IsDataMatch, nil, o.QuestLinksDB2.GetData;
end




do
	local loc_NAME_LABEL = o.Localization.NAME_LABEL;
	local loc_LEVEL_LABEL = o.Localization.LEVEL_LABEL;
	
	function o.ArrangeSearchSectionBox(sectionBox)
		local nameEB = o.LinksList.Search_LeaseReusableObject("section", "EditBox", "name");
		nameEB:SetHeight(20);
		nameEB:SetWidth(200);
		nameEB:SetAutoFocus(false);
		nameEB:SetNumeric(false);
		nameEB:SetMaxLetters(128);
		nameEB:SetPoint("TOPLEFT", sectionBox, "TOPLEFT", 70, -35);
		nameEB:Show();
		nameEB.LABEL:SetText(loc_NAME_LABEL);
		nameEB.LABEL:Show();
		
		local minLevelEB = o.LinksList.Search_LeaseReusableObject("section", "EditBox", "minLevel");
		minLevelEB:SetHeight(20);
		minLevelEB:SetWidth(35);
		minLevelEB:SetAutoFocus(false);
		minLevelEB:SetNumeric(false);
		minLevelEB:SetMaxLetters(3);
		minLevelEB:SetPoint("TOPLEFT", nameEB, "BOTTOMLEFT", -25, -50);
		minLevelEB.LABEL:SetText(loc_LEVEL_LABEL);
		minLevelEB.LABEL:Show();
		minLevelEB:Show();
		local maxLevelEB = o.LinksList.Search_LeaseReusableObject("section", "EditBox", "maxLevel");
		maxLevelEB:SetHeight(20);
		maxLevelEB:SetWidth(35);
		maxLevelEB:SetAutoFocus(false);
		maxLevelEB:SetNumeric(false);
		maxLevelEB:SetMaxLetters(3);
		maxLevelEB:SetPoint("LEFT", minLevelEB, "RIGHT", 20, 0);
		maxLevelEB.LABEL:Hide();
		maxLevelEB:Show();
	end
end
