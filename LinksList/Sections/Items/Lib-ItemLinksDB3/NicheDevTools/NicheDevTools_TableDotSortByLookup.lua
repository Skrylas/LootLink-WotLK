
if (table.NicheDevTools_SortByLookup == nil) then
	local l_lookupTable;
	local function l_CompareElements(elem1, elem2)
		return (l_lookupTable[elem1] < l_lookupTable[elem2]);
	end
	local function l_CompareElements_Reversed(elem1, elem2)
		return (l_lookupTable[elem1] > l_lookupTable[elem2]);
	end
	
	local tablesort = table.sort;
	table.NicheDevTools_SortByLookup = function(tbl, lookupTable, reverse)
		l_lookupTable = lookupTable;
		if (reverse == true) then
			tablesort(tbl, l_CompareElements_Reversed);
		else
			tablesort(tbl, l_CompareElements);
		end
		l_lookupTable = nil;
	end
end
