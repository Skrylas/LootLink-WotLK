
local o = LinksList;

-- Sorting_PostSectionChanged: ()
--
-- Sorting_SetSortType: (sortTypeIndex, subsectionIndex, reverse)
	-- Sorting_SortTypeDD_Init: (frame, level)
		-- Sorting_SortTypeDD_Button_OnClick: (self, sortTypeIndex, subsectionIndex)
--
-- Sorting_MergeSort: (array, comparison, reverse)
	-- l_SortAndMerge: (left, right)
-- Sorting_GetSorter: sorter = (sortTypeData)




function o.Sorting_PostSectionChanged()
	local newSectionInfo = o.Sections_currSectionInfo;
	
	if (newSectionInfo ~= nil) then
		LinksList_ResultsFrame_SortTypeDDButton:Enable();
		LinksList_ResultsFrame_SortTypeDDText:SetText(newSectionInfo.sortTypeData.name);
	else
		LinksList_ResultsFrame_SortTypeDDButton:Disable();
		LinksList_ResultsFrame_SortTypeDDText:SetText("");
	end
end




function o.Sorting_SetSortType(sortTypeData, reverse)
	local info = o.Sections_currSectionInfo;
	if (sortTypeData ~= info.sortTypeData) then
		info.sortTypeData = sortTypeData;
	else
		-- Only automatically toggle reverse if we're in the same sort type as last time.
		if (reverse == nil) then
			reverse = ((info.sortIsReversed == nil and true) or nil);
		end
	end
	reverse = ((reverse and true) or nil);
	info.sortIsReversed = reverse;
	
	local name = sortTypeData.name;
	LinksList_ResultsFrame_SortTypeDDText:SetText(name);
	info.sortTypeName = name;
	o.Sorting_MergeSort(info.resultsArray, o.Sorting_GetSorter(sortTypeData), reverse);
	o.Results_UpdateCurrentPage();
end


function o.Sorting_SortTypeDD_Init(frame, level)
	local AddButton = UIDropDownMenu_AddButton;
	local info = UIDropDownMenu_CreateInfo();
	info.notCheckable = true;
	info.func = o.Sorting_SortTypeDD_Button_OnClick;
	
	if (level == 1) then
		for index, sortTypeData in ipairs(o.Sections_currSectionInfo.sortTypes) do
			info.text = sortTypeData.name;
			info.arg1 = index;
			AddButton(info, 1);
		end
		
		local subsections = o.Sections_currSectionInfo.subsections;
		if (subsections ~= nil) then
			info.hasArrow = true;
			info.notClickable = true;
			for index, subsection in ipairs(subsections) do
				if (subsection.sortTypes ~= nil) then
					info.text = subsection.displayName;
					info.arg1 = index;
					AddButton(info, 1);
				end
			end
		end
	else
		-- "this" is currently the arrow from the level 1 button.
		info.arg2 = this:GetParent().arg1;
		for index, sortTypeData in ipairs(o.Sections_currSectionInfo.subsections[info.arg2].sortTypes) do
			info.text = sortTypeData.name;
			info.arg1 = index;
			AddButton(info, 2);
		end
	end
end


function o.Sorting_SortTypeDD_Button_OnClick(self, sortTypeIndex, subsectionIndex)
	local sortTypeData;
	if (subsectionIndex == nil) then
		sortTypeData = o.Sections_currSectionInfo.sortTypes[sortTypeIndex];
	else
		sortTypeData = o.Sections_currSectionInfo.subsections[subsectionIndex].sortTypes[sortTypeIndex];
	end
	o.Sorting_SetSortType(sortTypeData, nil);
end




do
	local l_SortAndMerge;
	local l_array, l_tempArray, l_comparison, l_reverse;
	
	function o.Sorting_MergeSort(array, comparison, reverse)
		if (#array < 2) then
			return;
		end
		
		l_array = array;
		l_tempArray = {};
		l_comparison = comparison;
		l_reverse = ((reverse and true) or false);
		
		l_SortAndMerge(1, (#array + 1));
		
		l_array = nil;
		l_tempArray = nil;
		l_comparison = nil;
		l_reverse = nil;
	end
	
	
	do
		local mathfloor = math.floor;
		
		function l_SortAndMerge(left, right)
			if (right == (left + 1)) then
				return;
			end
			
			local length = (right - left);
			local middle = (left + mathfloor(length / 2));
			
			l_SortAndMerge(left, middle);
			l_SortAndMerge(middle, right);
			
			local leftMobile = left;
			local rightMobile = middle;
			local takeFromLeft;
			local leftValue, rightValue;
			for index = 1, length, 1 do
				if (leftMobile < middle) then
					if (rightMobile == right) then
						leftValue = l_array[leftMobile];
						takeFromLeft = true;
					else
						leftValue = l_array[leftMobile];
						rightValue = l_array[rightMobile];
						if (l_reverse ~= true) then
							takeFromLeft = l_comparison(leftValue, rightValue);
						else
							takeFromLeft = l_comparison(rightValue, leftValue);
						end
					end
				else
					rightValue = l_array[rightMobile];
					takeFromLeft = false;
				end
				if (takeFromLeft) then
					l_tempArray[index] = leftValue;
					leftMobile = (leftMobile + 1);
				else
					l_tempArray[index] = rightValue;
					rightMobile = (rightMobile + 1);
				end
			end
			
			for index = left, (right - 1), 1 do
				l_array[index] = l_tempArray[(1 + index) - left];
			end
		end
	end
end



function o.Sorting_GetSorter(sortTypeData)
	local sorter = sortTypeData.sorter;
	if (sorter == nil) then
		sorter = sortTypeData.sorterCreator(unpack(sortTypeData));
		sortTypeData.sorterCreator = nil;
		for index = #sortTypeData, 1, -1 do
			sortTypeData[index] = nil;
		end
		sortTypeData.sorter = sorter;
	end
	return sorter;
end
