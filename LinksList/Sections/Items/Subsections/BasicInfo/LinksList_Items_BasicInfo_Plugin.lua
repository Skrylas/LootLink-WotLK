
local o = LinksList_Items_BasicInfo;

-- Plugin_t_Init: ()
--
-- GetData: data = (itemID)
-- AddByBruteForce: ()
--
-- AddSearchChecks: (checksArray, params, allowRegExps)
--
-- ArrangeSearchSubsectionBox: (subsectionBox)
	-- t_InitEquipLocs: ()
--
-- TypeAndSubtypeDD_Init: (frame, level)
	-- TypeAndSubtypeDD_Button_OnClick: (self, itemType, itemSubtype)
-- TypeAndSubtypeDD_SetupTextAndTooltip: ()
--
-- EquipLocDD_Init: (frame, level)
	-- EquipLocDD_Button_OnClick: (self, equipLoc)
-- EquipLocDD_SetupTextAndTooltip: ()

-- EQUIP_LOCS = { {}, {}, {} };
-- TYPE_AND_SUBTYPE_DD = nil;
-- EQUIP_LOC_DD = nil;




function o.Plugin_t_Init()
	o.Plugin_t_Init = nil;
	
	local sortTypes = {
		[1] = { name = o.Localization.SORT_BY_TYPE_AND_SUBTYPE; sorterCreator = o.ItemBasicInfoDB3.CreateTypeAndSubtypeSorter; nil, false, false, true };
		[2] = { name = o.Localization.SORT_BY_EQUIP_LOC; sorterCreator = o.ItemBasicInfoDB3.CreateEquipLocSorter; nil, false, false, true };
		[3] = { name = o.Localization.SORT_BY_ITEM_LEVEL; sorterCreator = o.ItemBasicInfoDB3.CreateItemLevelSorter; nil, false, false, true };
		[4] = { name = o.Localization.SORT_BY_EQUIP_LEVEL; sorterCreator = o.ItemBasicInfoDB3.CreateEquipLevelSorter; nil, false, false, true };
	};
	LinksList.Sections_t_AddSubsection("Items", "BasicInfo", o.Localization.BASIC_INFO, o, sortTypes, true);
end




function o.GetData(itemID)
	return o.ItemBasicInfoDB3.GetData(itemID);
end



function o.AddByBruteForce()
	return o.ItemBasicInfoDB3.CombGetItemInfo(false);
end




function o.AddSearchChecks(checksArray, params, allowRegExps)
	if (next(params) ~= nil) then
		checksArray[#checksArray + 1] = {
			func = o.ItemBasicInfoDB3.IsDataMatch;
			useNotEquals = true; value = nil; skipID = true;
			arg = o.ItemBasicInfoDB3.CreateMatcher(
				params.itemTypesAndSubtypes, params.equipLocs,
				params.minItemLevel, params.maxItemLevel,
				params.minEquipLevel, params.maxEquipLevel
			);
		};
	end
end




do
	local loc_CHECK_ENTRIES_TOOLTIP = o.Localization.CHECK_ENTRIES_TOOLTIP;
	local loc_TYPE_AND_SUBTYPE_LABEL = o.Localization.TYPE_AND_SUBTYPE_LABEL;
	local loc_TYPE_AND_SUBTYPE_TOOLTIP_TITLE = o.Localization.TYPE_AND_SUBTYPE_TOOLTIP_TITLE;
	local loc_EQUIP_LOC_LABEL = o.Localization.EQUIP_LOC_LABEL;
	local loc_EQUIP_LOC_TOOLTIP_TITLE = o.Localization.EQUIP_LOC_TOOLTIP_TITLE;
	local loc_ITEM_LEVEL_LABEL = o.Localization.ITEM_LEVEL_LABEL;
	local loc_EQUIP_LEVEL_LABEL = o.Localization.EQUIP_LEVEL_LABEL;
	
	function o.ArrangeSearchSubsectionBox(subsectionBox)
		local typeSubtypeDD = LinksList.Search_LeaseReusableObject("subsection", "DropDown", "itemTypesAndSubtypes");
		o.TYPE_AND_SUBTYPE_DD = typeSubtypeDD;
		typeSubtypeDD:SetHeight(32);
		UIDropDownMenu_SetWidth(typeSubtypeDD, 170);
		typeSubtypeDD:SetPoint("TOPLEFT", subsectionBox, "TOPLEFT", 5, -40);
		typeSubtypeDD.initialize = o.TypeAndSubtypeDD_Init;
		typeSubtypeDD.Load = o.TypeAndSubtypeDD_SetupTextAndTooltip;
		typeSubtypeDD.LABEL:SetText(loc_TYPE_AND_SUBTYPE_LABEL);
		typeSubtypeDD.LABEL:Show();
		typeSubtypeDD.TEXT:SetText(loc_TYPE_AND_SUBTYPE_TEXT);
		typeSubtypeDD.BUTTON.TOOLTIP_TITLE = loc_TYPE_AND_SUBTYPE_TOOLTIP_TITLE;
		typeSubtypeDD.BUTTON.TOOLTIP_TEXT = loc_CHECK_ENTRIES_TOOLTIP;
		typeSubtypeDD:Show();
		
		local equipLocDD = LinksList.Search_LeaseReusableObject("subsection", "DropDown", "equipLocs");
		o.EQUIP_LOC_DD = equipLocDD;
		equipLocDD:SetHeight(32);
		UIDropDownMenu_SetWidth(equipLocDD, 170);
		equipLocDD:SetPoint("TOPLEFT", typeSubtypeDD, "BOTTOMLEFT", 0, -35);
		equipLocDD.initialize = o.EquipLocDD_Init;
		equipLocDD.Load = o.EquipLocDD_SetupTextAndTooltip;
		equipLocDD.LABEL:SetText(loc_EQUIP_LOC_LABEL);
		equipLocDD.LABEL:Show();
		equipLocDD.TEXT:SetText(loc_EQUIP_LOC_TEXT);
		equipLocDD.BUTTON.TOOLTIP_TITLE = loc_EQUIP_LOC_TOOLTIP_TITLE;
		equipLocDD.BUTTON.TOOLTIP_TEXT = loc_CHECK_ENTRIES_TOOLTIP;
		equipLocDD:Show();
		
		local minItemLevelEB = LinksList.Search_LeaseReusableObject("subsection", "EditBox", "minItemLevel");
		minItemLevelEB:SetHeight(20);
		minItemLevelEB:SetWidth(35);
		minItemLevelEB:SetAutoFocus(false);
		minItemLevelEB:SetNumeric(true);
		minItemLevelEB:SetMaxLetters(3);
		minItemLevelEB:SetPoint("LEFT", typeSubtypeDD, "RIGHT", 10, 0);
		minItemLevelEB.LABEL:SetText(loc_ITEM_LEVEL_LABEL);
		minItemLevelEB.LABEL:Show();
		minItemLevelEB:Show();
		local maxItemLevelEB = LinksList.Search_LeaseReusableObject("subsection", "EditBox", "maxItemLevel");
		maxItemLevelEB:SetHeight(20);
		maxItemLevelEB:SetWidth(35);
		maxItemLevelEB:SetAutoFocus(false);
		maxItemLevelEB:SetNumeric(true);
		maxItemLevelEB:SetMaxLetters(3);
		maxItemLevelEB:SetPoint("LEFT", minItemLevelEB, "RIGHT", 20, 0);
		maxItemLevelEB.LABEL:Hide();
		maxItemLevelEB:Show();
		
		local minEquipLevelEB = LinksList.Search_LeaseReusableObject("subsection", "EditBox", "minEquipLevel");
		minEquipLevelEB:SetHeight(20);
		minEquipLevelEB:SetWidth(35);
		minEquipLevelEB:SetAutoFocus(false);
		minEquipLevelEB:SetNumeric(true);
		minEquipLevelEB:SetMaxLetters(3);
		minEquipLevelEB:SetPoint("TOPLEFT", minItemLevelEB, "BOTTOMLEFT", 0, -45);
		minEquipLevelEB.LABEL:SetText(loc_EQUIP_LEVEL_LABEL);
		minEquipLevelEB.LABEL:Show();
		minEquipLevelEB:Show();
		local maxEquipLevelEB = LinksList.Search_LeaseReusableObject("subsection", "EditBox", "maxEquipLevel");
		maxEquipLevelEB:SetHeight(20);
		maxEquipLevelEB:SetWidth(35);
		maxEquipLevelEB:SetAutoFocus(false);
		maxEquipLevelEB:SetNumeric(true);
		maxEquipLevelEB:SetMaxLetters(3);
		maxEquipLevelEB:SetPoint("LEFT", minEquipLevelEB, "RIGHT", 20, 0);
		maxEquipLevelEB.LABEL:Hide();
		maxEquipLevelEB:Show();
		
		if (o.t_InitEquipLocs ~= nil) then
			o.t_InitEquipLocs();
		end
	end
end


function o.t_InitEquipLocs()
	o.t_InitEquipLocs = nil;
	
	o.EQUIP_LOCS = { {}, {}, {} };
	local equipLocNames = o.ItemBasicInfoDB3.EQUIP_LOCATIONS;
	local _G = _G;
	local armor = o.EQUIP_LOCS[1];
	for index, equipLocIndex in ipairs(o.ItemBasicInfoDB3.EQUIP_LOCATIONS_ARMOR) do
		armor[index] = { index = equipLocIndex, name = _G[equipLocNames[equipLocIndex]] };
	end
	table.NicheDevTools_SortByKey(armor, "name");
	local weapons = o.EQUIP_LOCS[2];
	for index, equipLocIndex in ipairs(o.ItemBasicInfoDB3.EQUIP_LOCATIONS_WEAPONS) do
		weapons[index] = { index = equipLocIndex, name = _G[equipLocNames[equipLocIndex]] };
	end
	table.NicheDevTools_SortByKey(weapons, "name");
	local accessories = o.EQUIP_LOCS[3];
	for index, equipLocIndex in ipairs(o.ItemBasicInfoDB3.EQUIP_LOCATIONS_ACCESSORIES) do
		accessories[index] = { index = equipLocIndex, name = _G[equipLocNames[equipLocIndex]] };
	end
	table.NicheDevTools_SortByKey(accessories, "name");
end




do
	local loc_GENERIC_ANY = o.Localization.GENERIC_ANY;
	local loc_GENERIC_NONE = o.Localization.GENERIC_NONE;
	
	function o.TypeAndSubtypeDD_Init(frame, level)
		local AddButton = UIDropDownMenu_AddButton;
		local info = UIDropDownMenu_CreateInfo();
		info.func = o.TypeAndSubtypeDD_Button_OnClick;
		local included = o.TYPE_AND_SUBTYPE_DD.paramData;
		
		if (level == 1) then
			info.text = loc_GENERIC_ANY;
			info.arg1 = nil;
			info.checked = (included == nil);
			AddButton(info, 1);
			
			info.keepShownOnClick = true;
			info.text = loc_GENERIC_NONE;
			info.arg1 = 0;
			info.checked = (included ~= nil and included[0] ~= nil);
			AddButton(info, 1);
			
			for index, data in ipairs(o.ItemBasicInfoDB3.TYPES_AND_SUBTYPES) do
				info.text = data.name;
				info.arg1 = index;
				info.hasArrow = (data.subtypes ~= nil);
				info.checked = (included ~= nil and included[index] ~= nil);
				AddButton(info, 1);
			end
			
		elseif (level == 2) then
			local parent = this;
			local itemType = (parent.arg1 or parent:GetParent().arg1);
			local includedSubtypes;
			if (included ~= nil) then
				includedSubtypes = included[itemType];
			end
			info.arg1 = itemType;
			
			info.keepShownOnClick = true;
			info.text = loc_GENERIC_NONE;
			info.arg2 = 0;
			info.checked = (includedSubtypes == true or (includedSubtypes ~= nil and includedSubtypes[0] ~= nil));
			AddButton(info, 2);
			
			for index, name in ipairs(o.ItemBasicInfoDB3.TYPES_AND_SUBTYPES[itemType].subtypes) do
				info.text = name;
				info.arg2 = index;
				info.checked = (includedSubtypes == true or (includedSubtypes ~= nil and includedSubtypes[index] ~= nil));
				AddButton(info, 2);
			end
		end
	end
end


function o.TypeAndSubtypeDD_Button_OnClick(self, itemType, itemSubtype)
	if (itemType == nil) then
		o.TYPE_AND_SUBTYPE_DD.paramData = nil;
		o.TypeAndSubtypeDD_SetupTextAndTooltip();
		return;
	end
	
	local included = o.TYPE_AND_SUBTYPE_DD.paramData;
	if (included == nil) then
		DropDownList1Button1Check:Hide();
		included = {};
		o.TYPE_AND_SUBTYPE_DD.paramData = included;
	end
	
	if (itemSubtype ~= nil) then
		local includedSubtypes = included[itemType];
		if (includedSubtypes == nil or includedSubtypes == true) then
			if (includedSubtypes == nil) then
				local _, level1Button = this:GetParent():GetPoint(1);
				_G[level1Button:GetName() .. "Check"]:Show();
				level1Button.checked = true;
				includedSubtypes = {};
			else
				includedSubtypes = { [0] = true };
				for index = 1, #o.ItemBasicInfoDB3.TYPES_AND_SUBTYPES[itemType].subtypes, 1 do
					includedSubtypes[index] = true;
				end
			end
			included[itemType] = includedSubtypes;
		end
		if (includedSubtypes[itemSubtype] == nil) then
			includedSubtypes[itemSubtype] = true;
		else
			includedSubtypes[itemSubtype] = nil;
		end
		if (next(includedSubtypes) == nil) then
			included[itemType] = nil;
			local _, level1Button = this:GetParent():GetPoint(1);
			_G[level1Button:GetName() .. "Check"]:Hide();
			level1Button.checked = nil;
		end
	else
		if (included[itemType] == nil) then
			included[itemType] = true;
		else
			included[itemType] = nil;
		end
		CloseDropDownMenus(2);
	end
	
	if (next(included) == nil) then
		DropDownList1Button1Check:Show();
		o.TYPE_AND_SUBTYPE_DD.paramData = nil;
	end
	
	o.TypeAndSubtypeDD_SetupTextAndTooltip();
end



do
	local loc_CHECK_ENTRIES_TOOLTIP = o.Localization.CHECK_ENTRIES_TOOLTIP;
	local loc_TYPE_AND_SUBTYPE_ANY = o.Localization.TYPE_AND_SUBTYPE_ANY;
	local loc_TYPE_AND_SUBTYPE_NONE = o.Localization.TYPE_AND_SUBTYPE_NONE;
	local loc_TYPE_AND_SUBTYPE_ANY_SUBTYPE = o.Localization.TYPE_AND_SUBTYPE_ANY_SUBTYPE;
	local loc_TYPE_AND_SUBTYPE_NO_SUBTYPE = o.Localization.TYPE_AND_SUBTYPE_NO_SUBTYPE;
	local loc_GENERIC_ANY = o.Localization.GENERIC_ANY;
	local loc_GENERIC_SOME = o.Localization.GENERIC_SOME;
	
	function o.TypeAndSubtypeDD_SetupTextAndTooltip()
		local DecodeItemType = o.ItemBasicInfoDB3.DecodeItemType;
		local DecodeItemSubtype = o.ItemBasicInfoDB3.DecodeItemSubtype;
		
		local typeSubtypeDD = o.TYPE_AND_SUBTYPE_DD;
		local included = typeSubtypeDD.paramData;
		
		
		local text;
		if (included == nil) then
			text = loc_TYPE_AND_SUBTYPE_ANY;
		else
			local first, firstVal = next(included);
			if (first ~= nil and first ~= 0) then
				text = DecodeItemType(first);
				if (firstVal == true or next(firstVal) == nil) then
					text = (text .. " - " .. loc_GENERIC_ANY);
				else
					local firstSubKey, firstSubValue = next(firstVal);
					if (next(firstVal, firstSubKey) ~= nil) then
						-- There's more than one subtype selected.
						text = (text .. " - " .. loc_GENERIC_SOME);
					else
						-- Only one subtype selected.
						if (firstSubKey == 0) then
							text = (text .. " - " .. loc_TYPE_AND_SUBTYPE_NO_SUBTYPE);
						else
							text = (text .. " - " .. DecodeItemSubtype(first, firstSubKey));
						end
					end
				end
			else
				text = loc_TYPE_AND_SUBTYPE_NONE;
			end
			if (first ~= nil) then
				if (next(included, first) ~= nil) then
					text = (text .. "  |  ...");
				end
			end
		end
		typeSubtypeDD.TEXT:SetText(text);
		
		
		local tooltipText = loc_CHECK_ENTRIES_TOOLTIP;
		if (included ~= nil) then
			if (included[0] ~= nil) then
				tooltipText = (tooltipText .. "\n    " .. loc_TYPE_AND_SUBTYPE_NONE);
			end
			
			local currIncludedSubtypes;
			local foundMissing;
			for index, data in ipairs(o.ItemBasicInfoDB3.TYPES_AND_SUBTYPES) do
				currIncludedSubtypes = included[index];
				if (currIncludedSubtypes ~= nil) then
					tooltipText = (tooltipText .. "\n  " .. DecodeItemType(index));
					if (data.subtypes ~= nil) then
						if (currIncludedSubtypes == true) then
							tooltipText = (tooltipText .. "\n    " .. loc_TYPE_AND_SUBTYPE_ANY_SUBTYPE);
						else
							foundMissing = false;
							if (currIncludedSubtypes[0] ~= nil) then
								tooltipText = (tooltipText .. "\n    " .. loc_TYPE_AND_SUBTYPE_NO_SUBTYPE);
							else
								foundMissing = true;
							end
							for subIndex, subtypeName in ipairs(data.subtypes) do
								if (currIncludedSubtypes[subIndex] ~= nil) then
									tooltipText = (tooltipText .. "\n    " .. DecodeItemSubtype(index, subIndex));
								else
									foundMissing = true;
								end
							end
							if (foundMissing == false) then
								-- This clump of subtypes is actually the full type. Fix it.
								included[index] = true;
							end
						end
					end
				end
			end
		end
		typeSubtypeDD.BUTTON.TOOLTIP_TEXT = tooltipText;
	end
end




do
	local loc_GENERIC_ANY = o.Localization.GENERIC_ANY;
	local loc_GENERIC_NONE = o.Localization.GENERIC_NONE;
	local loc_EQUIP_LOC_CATEGORIES = {
		o.Localization.EQUIP_LOC_CATEGORY_ARMOR,
		o.Localization.EQUIP_LOC_CATEGORY_WEAPONS,
		o.Localization.EQUIP_LOC_CATEGORY_ACCESSORIES
	};
	
	function o.EquipLocDD_Init(frame, level)
		local AddButton = UIDropDownMenu_AddButton;
		local info = UIDropDownMenu_CreateInfo();
		info.func = o.EquipLocDD_Button_OnClick;
		local included = o.EQUIP_LOC_DD.paramData;
		
		if (level == 1) then
			info.text = loc_GENERIC_ANY;
			info.arg1 = nil;
			info.checked = (included == nil);
			AddButton(info, 1);
			
			info.keepShownOnClick = true;
			info.text = loc_GENERIC_NONE;
			info.arg1 = 0;
			info.checked = (included ~= nil and included[0] ~= nil);
			AddButton(info, 1);
			
			info.checked = nil;
			info.notClickable = true;
			info.notCheckable = true;
			info.hasArrow = true;
			for index, name in ipairs(loc_EQUIP_LOC_CATEGORIES) do
				info.text = name;
				info.arg1 = o.EQUIP_LOCS[index];
				AddButton(info, 1);
			end
			
		else
			info.keepShownOnClick = true;
			for index, data in ipairs(this:GetParent().arg1) do
				info.text = data.name;
				info.arg1 = data.index;
				info.checked = (included ~= nil and included[data.index] ~= nil);
				AddButton(info, 2);
			end
		end
	end
end


function o.EquipLocDD_Button_OnClick(self, equipLoc)
	if (equipLoc == nil) then
		o.EQUIP_LOC_DD.paramData = nil;
		o.EquipLocDD_SetupTextAndTooltip();
		return;
	end
	
	local included = o.EQUIP_LOC_DD.paramData;
	if (included == nil) then
		DropDownList1Button1Check:Hide();
		included = {};
		o.EQUIP_LOC_DD.paramData = included;
	end
	
	if (included[equipLoc] == nil) then
		included[equipLoc] = true;
	else
		included[equipLoc] = nil;
		if (next(included) == nil) then
			DropDownList1Button1Check:Show();
			o.EQUIP_LOC_DD.paramData = nil;
		end
	end
	
	o.EquipLocDD_SetupTextAndTooltip();
end



do
	local _G = _G;
	local loc_CHECK_ENTRIES_TOOLTIP = o.Localization.CHECK_ENTRIES_TOOLTIP;
	local loc_EQUIP_LOC_ANY = o.Localization.EQUIP_LOC_ANY;
	local loc_EQUIP_LOC_NONE = o.Localization.EQUIP_LOC_NONE;
	
	function o.EquipLocDD_SetupTextAndTooltip()
		local equipLocDD = o.EQUIP_LOC_DD;
		local included = equipLocDD.paramData;
		
		local text;
		if (included == nil) then
			text = loc_EQUIP_LOC_ANY;
		else
			local first = next(included);
			if (first ~= nil) then
				text = ((first == 0 and loc_EQUIP_LOC_NONE) or _G[o.ItemBasicInfoDB3.DecodeEquipLoc(first)]);
				local second = next(included, first);
				if (second ~= nil) then
					text = (text .. "  |  " .. ((second == 0 and loc_EQUIP_LOC_NONE) or _G[o.ItemBasicInfoDB3.DecodeEquipLoc(second)]));
					local third = next(included, second);
					if (third ~= nil) then
						text = (text .. "  |  " .. ((third == 0 and loc_EQUIP_LOC_NONE) or _G[o.ItemBasicInfoDB3.DecodeEquipLoc(third)]));
						if (next(included, third) ~= nil) then
							text = (text .. "  |  ...");
						end
					end
				end
			end
		end
		equipLocDD.TEXT:SetText(text);
		
		local tooltipText = loc_CHECK_ENTRIES_TOOLTIP;
		if (included ~= nil) then
			if (included[0] ~= nil) then
				tooltipText = (tooltipText .. "\n  " .. loc_EQUIP_LOC_NONE);
			end
			
			for index, category in ipairs(o.EQUIP_LOCS) do
				for subIndex, data in ipairs(category) do
					if (included[data.index] ~= nil) then
						tooltipText = (tooltipText .. "\n  " .. _G[o.ItemBasicInfoDB3.DecodeEquipLoc(data.index)]);
					end
				end
			end
		end
		equipLocDD.BUTTON.TOOLTIP_TEXT = tooltipText;
	end
end
