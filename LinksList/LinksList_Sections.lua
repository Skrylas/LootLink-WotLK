
local o = LinksList;

-- Sections_SetCurrent: (index)
	-- Sections_SectionDD_Init: ()
--
-- Sections_OnLinkAdded: (sectionName, ID)
-- Sections_GetSection: sectionInfo, index = (sectionName)
--
-- Sections_t_AddSection: (sectionName, linkTypeName, searchNameKey, funcs, sortTypes, startingSortType, noCachingForSearch)
-- Sections_t_AddSubsection: (sectionName, subsectionName, displayName, funcs, sortTypes, noCachingForSearch)

-- config = LinksList_Config
o.Sections_sections = {};
-- Sections_currSectionInfo = Sections_sections[index];




function o.Sections_SetCurrent(index)
	local oldSectionInfo = o.Sections_currSectionInfo;
	local newSectionInfo = o.Sections_sections[index];
	if (oldSectionInfo == newSectionInfo) then
		return;
	end
	
	o.Results_PreSectionChanged();
	o.QuickSearch_PreSectionChanged();
	o.Search_PreSectionChanged();
	
	o.Sections_currSectionInfo = newSectionInfo;
	
	o.Results_PostSectionChanged();
	o.Sorting_PostSectionChanged();
	o.QuickSearch_PostSectionChanged();
	o.Search_PostSectionChanged();
	
	if (newSectionInfo ~= nil) then
		o.config.lastViewedSection = newSectionInfo.sectionName;
		LinksList_ResultsFrame_SectionDDText:SetText(newSectionInfo.linkTypeName);
	else
		o.config.lastViewedSection = nil;
		LinksList_ResultsFrame_SectionDDText:SetText("");
		for index, sectionInfo in ipairs(o.Sections_sections) do
			sectionInfo.resultsArray = nil;
			sectionInfo.searchParams = nil;
			sectionInfo.needsFirstSearch = true;
			if (sectionInfo.subsections ~= nil) then
				for subIndex, subsectionInfo in ipairs(sectionInfo.subsections) do
					subsectionInfo.searchParams = nil;
				end
			end
		end
		collectgarbage("collect");
	end
end


function o.Sections_SectionDD_Init()
	local AddButton = NicheDevTools.AddDropdownButtonWithOptionalSelf;
	local info = UIDropDownMenu_CreateInfo();
	info.func = o.Sections_SetCurrent;
	info.noSelfForFunc = true;
	info.notCheckable = true;
	
	info.text = NONE;
	info.arg1 = nil;
	AddButton(info);
	
	for index, sectionInfo in ipairs(o.Sections_sections) do
		info.text = sectionInfo.linkTypeName;
		info.arg1 = index;
		AddButton(info);
	end
end




function o.Sections_OnLinkAdded(sectionName, ID)
	local sectionInfo = o.Sections_GetSection(sectionName);
	local recentlyAdded = sectionInfo.recentlyAdded;
	if (recentlyAdded == nil) then
		recentlyAdded = {};
		sectionInfo.recentlyAdded = recentlyAdded;
	end
	table.insert(recentlyAdded, 1, ID);
	recentlyAdded[21] = nil;
	sectionInfo.hasNewLinks = true;
	if (sectionInfo == o.Sections_currSectionInfo) then
		o.Results_UpdateTitle();
	end
	o.ToggleButton_OnNewLinksFlagChanged();
end



function o.Sections_GetSection(sectionName)
	for index, sectionInfo in ipairs(o.Sections_sections) do
		if (sectionInfo.sectionName == sectionName) then
			return sectionInfo, index;
		end
	end
	return nil, nil;
end




function o.Sections_t_AddSection(sectionName, linkTypeName, searchNameKey, funcs, sortTypes, startingSortType, noCachingForSearch)
	if (o.Sections_GetSection(sectionName) ~= nil) then
		error(("LinksList.Sections_AddSection: Section named %s already exists."):format(tostring(sectionName)), 2);
	end
	o.Sections_SetCurrent(nil);
	
	table.NicheDevTools_SortByKey(sortTypes, "name");
	local sortTypeIndex = 1;
	local sortTypeData = sortTypes[1];
	while (sortTypeData ~= nil and sortTypeData.name ~= startingSortType) do
		sortTypeIndex = (sortTypeIndex + 1);
		sortTypeData = sortTypes[sortTypeIndex];
	end
	if (sortTypeData == nil) then
		sortTypeData = sortTypes[1];
	end
	
	o.Sections_sections[#o.Sections_sections + 1] = {
		sectionName = sectionName;
		linkTypeName = linkTypeName;
		funcs = funcs;
		subsections = nil;
		currSubsectionIndex = nil;
		
		sortTypes = sortTypes;
		sortTypeData = sortTypeData;
		sortDefaultName = startingSortType;
		sortIsReversed = nil;
		
		recentlyAdded = nil;
		hasNewLinks = nil;
		
		searchParams = nil;
		searchNameKey = searchNameKey;
		needsFirstSearch = true;
		noCachingForSearch = ((noCachingForSearch and true) or nil);
		
		resultsArray = nil;
		scrollVal = 0;
		
		qsText = ("");
		qsIndex = 1;
	};
	table.NicheDevTools_SortByKey(o.Sections_sections, "linkTypeName");
end



function o.Sections_t_AddSubsection(sectionName, subsectionName, displayName, funcs, sortTypes, noCachingForSearch)
	local sectionInfo = o.Sections_GetSection(sectionName);
	if (o.Sections_currSectionInfo == sectionInfo) then
		o.Sections_SetCurrent(nil);
	end
	
	local subsections = sectionInfo.subsections;
	if (subsections == nil) then
		subsections = {};
		sectionInfo.subsections = subsections;
	else
		for index, subsection in ipairs(subsections) do
			if (subsection.name == subsectionName) then
				error(("LinksList.Sections_AddSubsection: Section %s already has a subsection named %s."):format(sectionName, tostring(subsectionName)), 2);
			end
		end
	end
	
	table.NicheDevTools_SortByKey(sortTypes, "name");
	
	local subsection = {
		name = subsectionName;
		displayName = displayName;
		funcs = funcs;
		sortTypes = sortTypes;
		noCachingForSearch = ((noCachingForSearch and true) or nil);
		searchParams = nil;
	};
	subsections[#subsections + 1] = subsection;
	table.NicheDevTools_SortByKey(subsections, "displayName");
end
