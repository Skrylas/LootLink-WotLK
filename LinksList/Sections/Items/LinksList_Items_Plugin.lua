
local o = LinksList_Items;

-- Plugin_t_Init: ()
--
-- OnEvent_ItemLinksDB3_ITEM_NAME_CHANGED: (itemID, oldName, newName)
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
-- SortByCached: elem1First = (elem1, elem2)
--
-- ArrangeSearchSectionBox: (sectionBox)
--
-- RarityDD_Load: (rarityDD, data)
-- RarityDD_SetupText: (rarityDD, data)
-- RarityDD_Save: data = (rarityDD)
-- RarityDD_Init: ()
	-- RarityDD_Button_OnClick: (self, rarityDD, data)
--
-- CachedDD_Load: (cachedDD, cachedTypeIndex)
-- CachedDD_Init: ()
	-- CachedDD_Button_OnClick: (self, cachedDD, cachedTypeIndex)

o.CACHED_TYPE_DATA = {
	{ name = o.Localization.CACHED_EITHER; arg = nil; };
	{ name = o.Localization.CACHED_CACHED; arg = true; };
	{ name = o.Localization.CACHED_UNCACHED; arg = false; };
};
-- RARITY_DD = nil;
-- CACHED_DD = nil;




function o.Plugin_t_Init()
	o.Plugin_t_Init = nil;
	
	EventsManager2.RegisterForEvent(o.OnEvent_ItemLinksDB3_ITEM_NAME_CHANGED, nil, "ItemLinksDB3_ITEM_NAME_CHANGED", false, false);
	
	local sortTypes = {
		[1] = { name = o.Localization.NAME; sorterCreator = o.ItemLinksDB3.CreateNameSorter; nil, false, false, true };
		[2] = { name = o.Localization.RARITY; sorterCreator = o.ItemLinksDB3.CreateRaritySorter; nil, false, false, true };
		[3] = { name = o.Localization.CACHED; sorter = o.SortByCached; };
	};
	o.LinksList.Sections_t_AddSection("Items", o.Localization.ITEMS, "name", o, sortTypes, o.Localization.NAME, false);
end




function o.OnEvent_ItemLinksDB3_ITEM_NAME_CHANGED(itemID, oldName)
	if (oldName == nil) then
		o.LinksList.Sections_OnLinkAdded("Items", itemID);
	end
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (params.cached ~= nil) then
		checksArray[#checksArray + 1] = { func = GetItemInfo; useNotEquals = params.cached; };
	end
	
	if (params.name ~= nil or params.rarity ~= nil) then
		local textToMatch = params.name;
		if (textToMatch ~= nil) then
			if (allowRegExps ~= true) then
				textToMatch = textToMatch:NicheDevTools_EscapePatterns();
			end
			textToMatch = textToMatch:NicheDevTools_CaseInsensitize();
		end
		checksArray[#checksArray + 1] = {
			func = o.ItemLinksDB3.IsDataMatch; useNotEquals = true; skipID = true; arg = o.ItemLinksDB3.CreateMatcher(textToMatch, params.rarity);
		};
	end
end




function o.GetDBSize()
	return o.ItemLinksDB3.GetDBSize();
end



function o.IterateDB(keysOnly, sortedByDefault)
	return o.ItemLinksDB3.IterateDB(keysOnly, sortedByDefault);
end



function o.GetLinkDisplayName(linkID)
	local name, rarity = o.ItemLinksDB3.SplitData(o.ItemLinksDB3.GetData(linkID));
	return (ITEM_QUALITY_COLORS[rarity].hex .. name .. "|r");
end



function o.IsLinkSafeToLink(linkID)
	return (GetItemInfo(linkID) ~= nil);
end



function o.GetLinkTooltipHyperlink(linkID)
	return o.ItemLinksDB3.BuildLink(linkID);
end


function o.GetLinkChatHyperlink(linkID)
	return o.ItemLinksDB3.BuildChatlink(linkID);
end



function o.AddByBruteForce()
	return o.ItemLinksDB3.CombGetItemInfo(false);
end



function o.BuildQuickSearchLinkNameMatcher(text, allowRegExps)
	if (allowRegExps ~= true) then
		text = text:NicheDevTools_EscapePatterns();
	end
	text = text:NicheDevTools_CaseInsensitize();
	return o.ItemLinksDB3.CreateMatcher(text, nil), o.ItemLinksDB3.IsDataMatch, nil, o.ItemLinksDB3.GetData;
end




do
	local GetItemInfo = GetItemInfo;
	
	function o.SortByCached(elem1, elem2)
		return (((GetItemInfo(elem1) ~= nil and 1) or 0) <= ((GetItemInfo(elem2) ~= nil and 1) or 0));
	end
end




do
	local loc_NAME_LABEL = o.Localization.NAME_LABEL;
	local loc_RARITY_LABEL = o.Localization.RARITY_LABEL;
	local loc_CACHED_LABEL = o.Localization.CACHED_LABEL;
	
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
		
		local rarityDD = o.LinksList.Search_LeaseReusableObject("section", "DropDown", "rarity");
		o.RARITY_DD = rarityDD;
		rarityDD:SetHeight(32);
		UIDropDownMenu_SetWidth(rarityDD, 120);
		rarityDD:SetPoint("TOPLEFT", nameEB, "BOTTOMLEFT", -70, -50);
		rarityDD.Load = o.RarityDD_Load;
		rarityDD.Save = o.RarityDD_Save;
		rarityDD.initialize = o.RarityDD_Init;
		rarityDD:Show();
		rarityDD.LABEL:SetText(loc_RARITY_LABEL);
		rarityDD.LABEL:Show();
		
		local cachedDD = o.LinksList.Search_LeaseReusableObject("section", "DropDown", "cached");
		o.CACHED_DD = cachedDD;
		cachedDD:SetHeight(32);
		UIDropDownMenu_SetWidth(cachedDD, 120);
		cachedDD:SetPoint("LEFT", rarityDD, "RIGHT", 10, 0);
		cachedDD.Load = o.CachedDD_Load;
		cachedDD.initialize = o.CachedDD_Init;
		cachedDD:Show();
		cachedDD.LABEL:SetText(loc_CACHED_LABEL);
		cachedDD.LABEL:Show();
	end
end




function o.RarityDD_Load(rarityDD, data)
	if (data == nil) then
		data = ("");
		for index = 0, #ITEM_QUALITY_COLORS, 1 do
			data = (data .. index);
		end
	else
		data = data:sub(2, -2); -- Cut off the brackets.
	end
	rarityDD.paramData = data;
	o.RarityDD_SetupText(data);
end



function o.RarityDD_Save(rarityDD)
	local data = rarityDD.paramData;
	-- Add 1 to account for the [0] index.
	if (data == "" or data:len() == (#ITEM_QUALITY_COLORS + 1)) then
		data = nil;
	else
		data = ("[" .. data .. "]");
	end
	return data;
end



do
	local loc_RARITY_NAMES = o.Localization.RARITY_NAMES;
	
	function o.RarityDD_Init()
		local data = o.RARITY_DD.paramData;
		local AddButton = UIDropDownMenu_AddButton;
		local info = UIDropDownMenu_CreateInfo();
		info.func = o.RarityDD_Button_OnClick;
		info.keepShownOnClick = true;
		
		local rarityColors = ITEM_QUALITY_COLORS;
		local rarityData;
		for index = 0, #rarityColors, 1 do
			rarityData = rarityColors[index];
			info.textR, info.textG, info.textB = rarityData.r, rarityData.g, rarityData.b;
			info.text = loc_RARITY_NAMES[index];
			info.arg1 = index;
			info.checked = ((data:find(index, 1, true) ~= nil) or nil);
			AddButton(info);
		end
	end
end


function o.RarityDD_Button_OnClick(self, index)
	local data = o.RARITY_DD.paramData;
	if (data:find(index, 1, true) ~= nil) then
		data = data:gsub(index, "", 1);
	else
		data = (data .. index);
	end
	o.RARITY_DD.paramData = data;
	o.RarityDD_SetupText(data);
end



function o.RarityDD_SetupText(data)
	local text;
	local rarityColors = ITEM_QUALITY_COLORS;
	for index = 0, #rarityColors, 1 do
		if (data:find(index, 1, true) ~= nil) then
			text = (((text ~= nil and (text .. " ")) or "") .. rarityColors[index].hex .. index .. "|r");
		end
	end
	o.RARITY_DD.TEXT:SetText(text);
end




function o.CachedDD_Load(cachedDD, data)
	local cachedTypeData = o.CACHED_TYPE_DATA;
	local index = 1;
	local cachedTypeInfo = cachedTypeData[1];
	while (cachedTypeInfo ~= nil and cachedTypeInfo.arg ~= data) do
		index = (index + 1);
		cachedTypeInfo = cachedTypeData[index];
	end
	cachedDD.TEXT:SetText(cachedTypeInfo.name);
end



function o.CachedDD_Init()
	local AddButton = UIDropDownMenu_AddButton;
	local info = UIDropDownMenu_CreateInfo();
	info.func = o.CachedDD_Button_OnClick;
	info.notCheckable = true;
	
	for index, cachedTypeData in ipairs(o.CACHED_TYPE_DATA) do
		info.text = cachedTypeData.name;
		info.arg1 = index;
		AddButton(info);
	end
end


function o.CachedDD_Button_OnClick(self, cachedTypeIndex)
	local cachedTypeInfo = o.CACHED_TYPE_DATA[cachedTypeIndex];
	o.CACHED_DD.paramData = cachedTypeInfo.arg;
	o.CACHED_DD.TEXT:SetText(cachedTypeInfo.name);
end
