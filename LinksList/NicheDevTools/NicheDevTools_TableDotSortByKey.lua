
if (table.NicheDevTools_SortByKey == nil) then
	local l_key = nil;
	local function l_CompareElements(elem1, elem2)
		return (elem1[l_key] < elem2[l_key]);
	end
	local function l_CompareElements_Reversed(elem1, elem2)
		return (elem1[l_key] > elem2[l_key]);
	end
	local function l_CompareLengths(elem1, elem2)
		return (#elem1 < #elem2);
	end
	local function l_CompareLengths_Reversed(elem1, elem2)
		return (#elem1 > #elem2);
	end
	
	local tablesort = table.sort;
	table.NicheDevTools_SortByKey = function(tbl, key, reverse)
		if (key ~= "#") then
			l_key = key;
			if (reverse == true) then
				tablesort(tbl, l_CompareElements_Reversed);
			else
				tablesort(tbl, l_CompareElements);
			end
			l_key = nil;
		else
			if (reverse == true) then
				tablesort(tbl, l_CompareLengths_Reversed);
			else
				tablesort(tbl, l_CompareLengths);
			end
		end
	end
end
