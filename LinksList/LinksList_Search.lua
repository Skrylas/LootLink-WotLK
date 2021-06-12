
local o = LinksList;

-- Search_Toggle: (enable)
--
-- Search_PreSectionChanged: ()
-- Search_PostSectionChanged: ()
--
-- Search_SearchByNameOnly: (text)
-- Search_PerformSearch: ()
	-- Search_CompareNumSubsectionChecks: elem2First = (elem1, elem2)
	-- Search_RunChecks: shouldInclude = (checks, ID, data)
--
-- Search_SetCurrentSubsection: (subsectionIndex)
	-- Search_SubsectionDD_Init: ()
--
-- Search_LeaseReusableObject: obj = (boxType, objectType, paramName1, paramName2, paramName3)
-- Search_CreateReusableObject: obj = (objectType)
-- Search_ReturnReusableObject: (boxType, object)
--
-- Search_SaveAllParams: ()
-- Search_ClearAllParams: ()
-- Search_LoadBoxParams: (objects, params)
-- Search_SaveBoxParams: (objects, params)
--
-- Search_Frame_OnShow: ()
-- Search_Frame_OnHide: (self)
-- Search_SearchButton_OnClick: ()
-- Search_ClearButton_OnClick: ()

o.Search_REUSABLE_OBJECT_INHERITEDS = {
	Frame = ("UIDropDownMenuTemplate");
	Button = ("UIPanelButtonTemplate");
	CheckButton = ("OptionsCheckButtonTemplate");
	EditBox = ("InputBoxTemplate");
};

-- Search_leasableObjectTotals = {};
-- Search_leasableObjects = { EditBox = {}; CheckButton = {}; Button = {}; Frame = {}; };
-- Search_leasedSectionBoxObjects = {};
-- Search_leasedSubsectionBoxObjects = {};




function o.Search_Toggle(enable)
	local searchFrame = LinksList_SearchFrame;
	if (enable == nil) then
		enable = (not searchFrame:IsShown());
	end
	enable = ((enable and true) or nil);
	
	if (enable == true) then
		searchFrame:Show();
	else
		searchFrame:Hide();
	end
end




function o.Search_PreSectionChanged()
	o.Search_Toggle(false);
end


function o.Search_PostSectionChanged()
	local newSectionInfo = o.Sections_currSectionInfo;
	if (newSectionInfo ~= nil) then
		local button = LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDDButton;
		if (button ~= nil) then
			if (newSectionInfo.subsections ~= nil) then
				button:Enable();
			else
				button:Disable();
			end
		end
		if (newSectionInfo.needsFirstSearch == true) then
			newSectionInfo.needsFirstSearch = nil;
			o.Search_PerformSearch();
		end
	end
end




function o.Search_SearchByNameOnly(text)
	local info = o.Sections_currSectionInfo;
	if (text == "") then
		text = nil;
	end
	
	local storedParams = info.searchParams;
	if (text ~= nil) then
		info.searchParams = { [info.searchNameKey] = text; };
	else
		info.searchParams = nil;
	end
	local storedSubParams;
	if (info.subsections ~= nil) then
		storedSubParams = {};
		for index, subsection in ipairs(info.subsections) do
			storedSubParams[subsection.name] = subsection.searchParams;
			subsection.searchParams = nil;
		end
	end
	
	o.Search_PerformSearch();
	
	if (info.subsections ~= nil) then
		for index, subsection in pairs(info.subsections) do
			subsection.searchParams = storedSubParams[subsection.name];
		end
	end
	info.searchParams = storedParams;
end



function o.Search_PerformSearch()
	local info = o.Sections_currSectionInfo;
	local allowRegExps = (IsControlKeyDown() ~= nil);
	local invertResults = (IsShiftKeyDown() ~= nil);
	
	-- First decide the search order, with the subsection having the most parameters to match being the first, and so on.
	-- The base is always first, because the base is the essential data needed to generate the link, without which the other data is useless.
	local subsectionOrder = nil;
	if (info.subsections ~= nil) then
		local subsectionInfo = {};
		local dbLookup;
		for index, subsection in ipairs(info.subsections) do
			if (subsection.searchParams ~= nil) then
				subsection.funcs.AddSearchChecks(subsectionInfo, subsection.searchParams, allowRegExps);
				if (#subsectionInfo ~= 0) then
					if (subsection.noCachingForSearch == true) then
						subsectionInfo.GetData = subsection.funcs.GetData;
					else
						-- We have to cache this or it could be a linear lookup every time. Hurgh.
						dbLookup = {};
						subsectionInfo.dbLookup = dbLookup;
						for ID, data in subsection.funcs.IterateDB(false) do
							dbLookup[ID] = data;
						end
					end
					if (subsectionOrder == nil) then
						subsectionOrder = {};
					end
					subsectionOrder[#subsectionOrder + 1] = subsectionInfo;
					subsectionInfo = {};
				end
			end
		end
		if (subsectionOrder ~= nil and #subsectionOrder > 1) then
			table.NicheDevTools_SortByKey(subsectionOrder, "#");
		end
	end
	
	local checks;
	if (info.searchParams ~= nil) then
		checks = {};
		info.funcs.AddSearchChecks(checks, info.searchParams, allowRegExps);
		if (#checks == 0) then
			checks = nil;
		end
	end
	local resultsArray = info.resultsArray;
	if (resultsArray == nil) then
		resultsArray = {};
		info.resultsArray = resultsArray;
	end
	local numResults = 0;
	
	local sortByDefault = false;
	if (info.sortTypeData.name == info.sortDefaultName and info.sortIsReversed == nil) then
		sortByDefault = true;
	end
	
	if (checks == nil and subsectionOrder == nil) then
		if (invertResults == false) then
			for ID in info.funcs.IterateDB(true, sortByDefault) do
				numResults = (numResults + 1);
				resultsArray[numResults] = ID;
			end
		end
	else
		local RunChecks = o.Search_RunChecks;
		local subsectionIndex, subsectionInfo, dbLookup, subsectionData;
		local shouldInclude;
		
		for ID, data in info.funcs.IterateDB((checks == nil), sortByDefault) do
			shouldInclude = true;
			
			if (checks ~= nil) then
				shouldInclude = RunChecks(checks, ID, data);
			end
			
			if (subsectionOrder ~= nil and shouldInclude == true) then
				subsectionIndex = 1;
				subsectionInfo = subsectionOrder[1];
				while (subsectionInfo ~= nil and shouldInclude == true) do
					dbLookup = subsectionInfo.dbLookup;
					if (dbLookup ~= nil) then
						subsectionData = dbLookup[ID];
					else
						subsectionData = subsectionInfo.GetData(ID);
					end
					if (subsectionData == nil) then
						-- It can't pass any of the checks if it's nil, so don't even bother checking.
						shouldInclude = false;
					else
						shouldInclude = RunChecks(subsectionInfo, ID, subsectionData);
					end
					subsectionIndex = (subsectionIndex + 1);
					subsectionInfo = subsectionOrder[subsectionIndex];
				end
			end
			
			if (invertResults == true) then
				shouldInclude = (not shouldInclude);
			end
			
			if (shouldInclude == true) then
				numResults = (numResults + 1);
				resultsArray[numResults] = ID;
			end
		end
	end
	
	for index = #resultsArray, (numResults + 1), -1 do
		resultsArray[index] = nil;
	end
	
	o.Results_OnResultsChanged(sortByDefault);
end


function o.Search_CompareNumSubsectionChecks(elem1, elem2)
	-- Higher first.
	return (#elem1 < #elem2);
end


do
	local ipairs = ipairs;
	
	function o.Search_RunChecks(checks, ID, data)
		for index, check in ipairs(checks) do
			if (check.useNotEquals == true) then
				if (check.skipID == true) then
					if ((check.func(data, check.arg) ~= check.value) ~= true) then
						return false;
					end
				else
					if ((check.func(ID, data, check.arg) ~= check.value) ~= true) then
						return false;
					end
				end
			else
				if (check.skipID == true) then
					if ((check.func(data, check.arg) == check.value) ~= true) then
						return false;
					end
				else
					if ((check.func(ID, data, check.arg) == check.value) ~= true) then
						return false;
					end
				end
			end
		end
		return true;
	end
end




function o.Search_SetCurrentSubsection(subsectionIndex)
	local info = o.Sections_currSectionInfo;
	
	if (info.subsections ~= nil) then
		local oldSubsection = info.subsections[info.currSubsectionIndex];
		if (oldSubsection ~= nil) then
			oldSubsection.searchParams = o.Search_SaveBoxParams(o.Search_leasedSubsectionBoxObjects, oldSubsection.searchParams);
			for object in pairs(o.Search_leasedSubsectionBoxObjects) do
				o.Search_ReturnReusableObject("subsection", object);
			end
		end
		
		if (subsectionIndex == nil) then
			subsectionIndex = 1;
		end
		info.currSubsectionIndex = subsectionIndex;
		local newSubsection = info.subsections[subsectionIndex];
		if (newSubsection ~= nil) then
			LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDDText:SetText(newSubsection.displayName);
			newSubsection.funcs.ArrangeSearchSubsectionBox(LinksList_SearchFrame_SubsectionParametersFrame);
			o.Search_LoadBoxParams(o.Search_leasedSubsectionBoxObjects, newSubsection.searchParams);
		else
			LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDDText:SetText("");
		end
	else
		LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDDText:SetText("");		
	end
end


function o.Search_SubsectionDD_Init()
	local AddButton = NicheDevTools.AddDropdownButtonWithOptionalSelf;
	local info = UIDropDownMenu_CreateInfo();
	info.func = o.Search_SetCurrentSubsection;
	info.noSelfForFunc = true;
	
	for index, subsection in ipairs(o.Sections_currSectionInfo.subsections) do
		info.text = subsection.displayName;
		info.arg1 = index;
		info.checked = ((subsection.searchParams ~= nil and true) or nil);
		AddButton(info);
	end
end




function o.Search_LeaseReusableObject(boxType, objectType, paramName)
	if (objectType == "DropDown") then
		objectType = ("Frame");
	end
	
	local leasable = o.Search_leasableObjects;
	if (leasable == nil) then
		leasable = {};
		o.Search_leasableObjects = leasable;
	end
	local leasableForType = leasable[objectType];
	if (leasableForType == nil) then
		leasableForType = {};
		leasable[objectType] = leasableForType;
	end
	
	local object = table.remove(leasableForType);
	if (object == nil) then
		object = o.Search_CreateReusableObject(objectType);
	end
	
	local leased;
	if (boxType == "section") then
		leased = o.Search_leasedSectionBoxObjects;
		if (leased == nil) then
			leased = {};
			o.Search_leasedSectionBoxObjects = leased;
		end
	else
		leased = o.Search_leasedSubsectionBoxObjects;
		if (leased == nil) then
			leased = {};
			o.Search_leasedSubsectionBoxObjects = leased;
		end
	end
	leased[object] = paramName;
	
	return object;
end



function o.Search_CreateReusableObject(objectType)
	local totals = o.Search_leasableObjectTotals;
	if (totals == nil) then
		totals = {};
		o.Search_leasableObjectTotals = totals;
	end
	local num = ((totals[objectType] or 0) + 1);
	totals[objectType] = num;
	
	local object = CreateFrame(
		objectType,
		("LinksList_SearchFrame_Reusable" .. objectType .. num),
		LinksList_SearchFrame,
		o.Search_REUSABLE_OBJECT_INHERITEDS[objectType]
	);
	object:Hide();
	
	local label;
	if (objectType == "EditBox") then
		label = object:CreateFontString(("LinksList_SearchFrame_Reusable" .. objectType .. num .. "Label"), "OVERLAY", "GameFontNormalSmall");
		label:SetJustifyH("LEFT");
		label:SetPoint("BOTTOMLEFT", object, "TOPLEFT", 0, 5);
		NicheDevTools.SetupElementForSimpleTooltip(object);
	elseif (objectType == "Frame") then
		-- This is really a dropdown, not a generic Frame.
		label = object:CreateFontString(("LinksList_SearchFrame_Reusable" .. objectType .. num .. "Label"), "OVERLAY", "GameFontNormalSmall");
		label:SetJustifyH("LEFT");
		label:SetPoint("BOTTOMLEFT", object, "TOPLEFT", 20, 0);
		local text = _G["LinksList_SearchFrame_Reusable" .. objectType .. num .. "Text"];
		object.TEXT = text;
		text:SetJustifyH("CENTER");
		local button = _G[object:GetName() .. "Button"];
		object.BUTTON = button;
		NicheDevTools.SetupElementForSimpleTooltip(button);
	elseif (objectType == "CheckButton") then
		label = _G["LinksList_SearchFrame_Reusable" .. objectType .. num .. "Text"];
		NicheDevTools.SetupElementForSimpleTooltip(object);
	end
	object:SetToplevel(true);
	object.LABEL = label;
	
	return object;
end



function o.Search_ReturnReusableObject(boxType, object)
	if (boxType == "section") then
		o.Search_leasedSectionBoxObjects[object] = nil;
	elseif (boxType == "subsection") then
		o.Search_leasedSubsectionBoxObjects[object] = nil;
	end
	
	object:Hide();
	object:ClearAllPoints();
	object.Load = nil;
	object.Save = nil;
	object.initialize = nil;
	object.paramData = nil;
	if (object.BUTTON ~= nil) then
		object.BUTTON.TOOLTIP_TITLE = nil;
		object.BUTTON.TOOLTIP_TEXT = nil;
	else
		object.TOOLTIP_TITLE = nil;
		object.TOOLTIP_TEXT = nil;
	end
	
	local leasable = o.Search_leasableObjects[object:GetFrameType()];
	leasable[#leasable + 1] = object;
end




function o.Search_SaveAllParams()
	local info = o.Sections_currSectionInfo;
	info.searchParams = o.Search_SaveBoxParams(o.Search_leasedSectionBoxObjects, info.searchParams);
	
	if (info.subsections ~= nil) then
		local subsection = info.subsections[info.currSubsectionIndex];
		if (subsection ~= nil) then
			subsection.searchParams = o.Search_SaveBoxParams(o.Search_leasedSubsectionBoxObjects, subsection.searchParams);
		end
	end
end



function o.Search_ClearAllParams()
	local info = o.Sections_currSectionInfo;
	
	info.searchParams = nil;
	if (info.subsections ~= nil) then
		for index, subsection in ipairs(info.subsections) do
			subsection.searchParams = nil;
		end
	end
	
	o.Search_LoadBoxParams(o.Search_leasedSectionBoxObjects, nil);
	if (info.subsections ~= nil) then
		local subsection = info.subsections[info.currSubsectionIndex];
		if (subsection ~= nil) then
			o.Search_LoadBoxParams(o.Search_leasedSubsectionBoxObjects, nil);
		end
	end
end




function o.Search_LoadBoxParams(objects, params)
	if (objects == nil) then
		return;
	end
	
	local objectType;
	for object, paramName in pairs(objects) do
		object.paramData = ((params ~= nil and params[paramName]) or nil);
		if (object.Load ~= nil) then
			object:Load(object.paramData);
		else
			objectType = object:GetFrameType();
			if (objectType == "EditBox") then
				object:SetText((params ~= nil and params[paramName]) or "");
			elseif (objectType == "CheckButton") then
				object:SetChecked((params ~= nil and params[paramName]) or false);
			end
		end
	end
end



function o.Search_SaveBoxParams(objects, params)
	if (objects == nil) then
		return;
	end
	
	local tonumber = tonumber;
	local objectType, data;
	for object, paramName in pairs(objects) do
		if (object.Save ~= nil) then
			data = object:Save();
		else
			objectType = object:GetFrameType();
			if (objectType == "EditBox") then
				data = object:GetText();
				if (data == "") then
					data = nil;
				else
					if (object:IsNumeric() ~= nil) then
						data = tonumber(data);
					end
				end
			elseif (objectType == "CheckButton") then
				data = ((object:GetChecked() and true) or nil);
			else
				data = object.paramData;
			end
		end
		if (data ~= nil) then
			if (params == nil) then
				params = {};
			end
			params[paramName] = data;
		else
			if (params ~= nil) then
				params[paramName] = nil;
			end
		end
	end
	
	if (params ~= nil and next(params) == nil) then
		params = nil;
	end
	return params;
end




function o.Search_Frame_OnShow()
	PlaySound("igMainMenuOpen");
	
	local info = o.Sections_currSectionInfo;
	info.funcs.ArrangeSearchSectionBox(LinksList_SearchFrame_SectionParametersFrame);
	o.Search_LoadBoxParams(o.Search_leasedSectionBoxObjects, info.searchParams);
	o.Search_SetCurrentSubsection(info.currSubsectionIndex);
end


function o.Search_Frame_OnHide(self)
	PlaySound("igMainMenuClose");
	
	o.Search_SaveAllParams();
	
	if (o.Search_leasedSectionBoxObjects ~= nil) then
		for object in pairs(o.Search_leasedSectionBoxObjects) do
			o.Search_ReturnReusableObject("section", object);
		end
	end
	if (o.Search_leasedSubsectionBoxObjects ~= nil) then
		for object in pairs(o.Search_leasedSubsectionBoxObjects) do
			o.Search_ReturnReusableObject("subsection", object);
		end
	end
	
	self:SetUserPlaced(false);
	o.config.searchX, o.config.searchY = self:GetCenter();
end



function o.Search_SearchButton_OnClick()
	PlaySound("gsTitleOptionOk");
	o.Search_SaveAllParams();
	o.Search_PerformSearch();
end



function o.Search_ClearButton_OnClick()
	PlaySound("gsTitleOptionOk");
	o.Search_ClearAllParams();
end
