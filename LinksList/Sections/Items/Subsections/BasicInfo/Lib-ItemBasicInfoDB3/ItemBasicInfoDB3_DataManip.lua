
local o = ItemBasicInfoDB3; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- IterateDB: iterator, state, start = (keysOnly)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state)
-- GetDBSize: size = ()
-- CombGetItemInfo: numNew, numUpdated = ([onlyNew][, maxID][, dbLookup])
-- CreateMatcher: matcher = ([itemTypesAndSubtypes][, equipLocs][, minItemLevel][, maxItemLevel][, minEquipLevel][, maxEquipLevel])
-- IsDataMatch: isMatch = (data, matcher)
-- CreateTypeAndSubtypeSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateEquipLocSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateItemLevelSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateEquipLevelSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (itemID)
-- SplitData: itemType, itemSubtype, equipLoc, itemLevel, equipLevel = (data)
-- SetData: oldData, newData = (itemID, newItemType, newItemSubtype, newEquipLoc, newItemLevel, newEquipLevel)
-- CombineData: data = (itemType, itemSubtype, equipLoc, itemLevel, equipLevel)
--
-- EncodeItemType: encoded = (itemType[, itemID])
-- DecodeItemType: itemType = (encoded)
-- EncodeItemSubtype: encoded = (itemType, itemSubtype[, itemID])
-- DecodeItemSubtype: itemSubtype = (itemType, encoded)
-- EncodeEquipLoc: encoded = (equipLoc[, itemID])
-- DecodeEquipLoc: equipLoc = (encoded)
--
-- GetTypeExcluded: isExcluded = (itemType)
-- SetTypeExcluded: (itemType, isExcluded)
--
-- t_CheckUnrecognized: (unrecognized)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.

o.activeDB = nil;
o.lookupCache = nil;
-- activeDBSize = 0;
-- errata = ItemBasicInfoDB3_SavedData.errata;
-- excludedTypes = ItemBasicInfoDB3_SavedData.excludedTypes;
-- unrecognized = ItemBasicInfoDB3_SavedData.unrecognized;




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("ItemBasicInfoDB3_DB_SIZE_CHANGED", false);
	ACE("ItemBasicInfoDB3_ITEM_DATA_CHANGED", false);
	
	local saved = ItemBasicInfoDB3_SavedData;
	if (saved == nil) then
		saved = {
			errata = {};
			excludedTypes = {};
			unrecognized = {};
		};
		ItemBasicInfoDB3_SavedData = saved;
	else
		local errata = saved.errata;
		local k, v = next(errata);
		if (k ~= nil and type(v) == "number") then
			local function l_TranslateFromStorage(storedValue)
				return (((storedValue < 510) and storedValue) or (storedValue == 510 and 0) or nil);
			end
			local mathfloor = math.floor;
			local itemType, itemSubtype, equipLoc, itemLevel, equipLevel;
			for itemID, data in pairs(errata) do
				itemType, itemSubtype, equipLoc, itemLevel, equipLevel =
					l_TranslateFromStorage(mathfloor(data / 512^4) % 512), -- itemType
					l_TranslateFromStorage(mathfloor(data / 512^3) % 512), -- itemSubtype
					l_TranslateFromStorage(mathfloor(data / 512^2) % 512), -- equipLoc
					l_TranslateFromStorage(data % 512), -- itemLevel
					l_TranslateFromStorage(mathfloor(data / 512) % 512); -- equipLevel
				if (itemSubtype == nil) then
					-- There was a bug wherein items with a type but no subtype would have this stored as nil rather than 0.
					itemSubtype = 0;
				end
				errata[itemID] = o.CombineData(itemType, itemSubtype, equipLoc, itemLevel, equipLevel);
			end
		elseif (k ~= nil and v:find("^[\1-\20%z~]") == nil) then
			local stringmatch = string.match;
			local tonumber = tonumber;
			local function l_SplitData(data)
				local itemType, itemSubtype, equipLoc, itemLevel, equipLevel = stringmatch(data, "^(.)(.)(.)(...)(.*)$");
				return tonumber(itemType, 36), tonumber(itemSubtype, 36), tonumber(equipLoc, 36), tonumber(itemLevel), (tonumber(equipLevel) or 0);
			end
			for itemID, data in pairs(errata) do
				errata[itemID] = o.CombineData(l_SplitData(data));
			end
		end
	end
	o.errata = saved.errata;
	o.excludedTypes = saved.excludedTypes;
	o.unrecognized = saved.unrecognized;
	
	local excludedTypes = o.excludedTypes;
	if (next(excludedTypes) ~= nil) then
		local stringchar = string.char;
		local excludedTypesAsStrings = {};
		for itemType in pairs(excludedTypes) do
			excludedTypesAsStrings[stringchar(itemType)] = ("~~~~~~");
		end
		-- gsub will find "~~~~~~" for any item with a type that's on the list of excluded ones, and replace that entry with the blank.
		-- Any item with a type not on the exluded list will simply be left alone, since it will index to nil in the table.
		-- This is pretty much the absolute fastest way to do this. Unfortunately, no matter what, it's going to have to
		-- throw the old megastring in the garbage. Not a huge deal since it's only done once.
		o.STATIC_DB = o.STATIC_DB:gsub("(.).....", excludedTypesAsStrings);
		local errata = o.errata;
		for itemID, data in pairs(errata) do
			if (excludedTypes[data:byte(1, 1)] == true) then
				errata[itemID] = nil;
			end
		end
	end
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local staticDB = o.STATIC_DB;
	local maxID = (#staticDB / 6);
	local errata = o.errata;
	local count = 0;
	local index, b1, b2, b3, b4, b5, b6;
	local eb1, eb2, eb3, eb4, eb5, eb6;
	for itemID, data in pairs(errata) do
		index = (itemID * 6);
		b1, b2, b3, b4, b5, b6 = staticDB:byte((index - 5), index);
		-- itemLevelTo1 can only be 255 if the entry is blank.
		if (b4 ~= 255 and b1 ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			eb1, eb2, eb3, eb4, eb5, eb6 = data:byte(1, 6);
			if (b1 == eb1 and b2 == eb2 and b3 == eb3 and b4 == eb4 and b5 == eb5 and b6 == eb6) then
				-- It does match. Delete from the errata.
				errata[itemID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry, and
				-- the count is already accounted for by o.COUNT.
			end
		else
			-- There's no entry. Increment the count.
			count = (count + 1);
		end
	end
	
	count = (count + o.COUNT);
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("ItemBasicInfoDB3_DB_SIZE_CHANGED", oldCount, count);
	end
	
	o.CombGetItemInfo(true);
	
	local stillUnrecognized = o.t_CheckUnrecognized(saved.unrecognized);
	if (stillUnrecognized == true) then
		DEFAULT_CHAT_FRAME:AddMessage(o.Localization.STILL_UNRECOGNIZED_REMINDER);
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




function o.GetDBSize()
	return o.activeDBSize;
end



function o.IterateDB(keysOnly)
	local state = { staticDBPos = 1; prevErrataKey = nil; staticDB = o.STATIC_DB; keysOnly = ((keysOnly and true) or nil); };
	if (next(o.errata) ~= nil) then
		state.errata = o.errata;
	end
	return o.IterateDB_GetNextPair, state, nil;
end


do
	local next = next;
	local stringbyte = string.byte;
	
	function o.IterateDB_GetNextPair(state)
		local nextKey, nextVal;
		local errata = state.errata;
		local staticDBPos = state.staticDBPos;
		if (staticDBPos ~= nil) then
			local staticDB = state.staticDB;
			local itemLevelTo1;
			repeat
				itemLevelTo1 = stringbyte(staticDB, (staticDBPos + 3), (staticDBPos + 3));
				staticDBPos = (staticDBPos + 6);
			-- itemLevelTo1 can only be 255 in missing entries.
			until (itemLevelTo1 ~= 255);
			
			if (itemLevelTo1 ~= nil) then
				state.staticDBPos = staticDBPos;
				nextKey = ((staticDBPos - 1) / 6);
				if (errata ~= nil and errata[nextKey] ~= nil) then
					-- Return something from the errata. NOT necessarily the updated data for this key, just something.
					-- This is necessary because we don't know the iteration order of the errata, so returning the updated
					-- data could cause duplicate returns when we actually run out of things to return from the static DB.
					nextKey = nil;
				end
				if (nextKey ~= nil and state.keysOnly == nil) then
					nextVal = (staticDBPos - 1);
				end
			else
				-- Must've run past the end of the staticDB.
				state.staticDBPos = nil;
				state.staticDB = nil;
			end
		end
		if (nextKey == nil and errata ~= nil) then
			if (state.keysOnly == true) then
				nextKey = next(errata, state.prevErrataKey);
			else
				nextKey, nextVal = next(errata, state.prevErrataKey);
			end
			state.prevErrataKey = nextKey;
		end
		return nextKey, nextVal;
	end
end



function o.CombGetItemInfo(onlyNew)
	local GetItemInfo = GetItemInfo;
	local EncodeItemType = o.EncodeItemType;
	local EncodeItemSubtype = o.EncodeItemSubtype;
	local EncodeEquipLoc = o.EncodeEquipLoc;
	local GetData = o.GetData;
	local SplitData = o.SplitData;
	local SetData = o.SetData;
	local maxID = (#o.STATIC_DB / 6);
	local numNew = 0;
	local numUpdated = 0;
	
	local itemID = 1;
	local numConsecBlanks = 0;
	local _, itemLevel, equipLevel, itemType, itemSubtype, equipLoc, oldData, newData;
	local lookupData, lookupItemType, lookupItemSubtype, lookupEquipLoc, lookupItemLevel, lookupEquipLevel;
	while (numConsecBlanks < 500 or itemID < maxID) do
		if (onlyNew == true) then
			lookupData = GetData(itemID);
		end
		if (onlyNew == true and lookupData ~= nil) then
			numConsecBlanks = 0;
		else
			_, _, _, itemLevel, equipLevel, itemType, itemSubtype, _, equipLoc = GetItemInfo(itemID);
			if (itemLevel ~= nil) then
				numConsecBlanks = 0;
				itemType = EncodeItemType(itemType, itemID);
				itemSubtype = EncodeItemSubtype(itemType, itemSubtype, itemID);
				equipLoc = EncodeEquipLoc(equipLoc, itemID);
				if (lookupData == nil) then
					lookupData = GetData(itemID);
				end
				if (lookupData ~= nil) then
					lookupItemType, lookupItemSubtype, lookupEquipLoc, lookupItemLevel, lookupEquipLevel = SplitData(lookupData);
				end
				if (
					lookupData == nil
					or lookupItemType ~= itemType
					or lookupItemSubtype ~= itemSubtype
					or lookupEquipLoc ~= equipLoc
					or lookupItemLevel ~= itemLevel
					or lookupEquipLevel ~= equipLevel
				) then
					oldData, newData = SetData(itemID, itemType, itemSubtype, equipLoc, itemLevel, equipLevel);
					if (oldData == nil and newData ~= nil) then
						numNew = (numNew + 1);
					else
						if (oldData ~= newData) then
							numUpdated = (numUpdated + 1);
						end
					end
				end
			else
				numConsecBlanks = (numConsecBlanks + 1);
			end
		end
		lookupData = nil;
		itemID = (itemID + 1);
	end
	
	return numNew, numUpdated;
end



function o.CreateMatcher(itemTypesAndSubtypes, equipLocs, minItemLevel, maxItemLevel, minEquipLevel, maxEquipLevel)
	return {
		itemTypesAndSubtypes, equipLocs,
		tonumber(minItemLevel), tonumber(maxItemLevel),
		tonumber(minEquipLevel), tonumber(maxEquipLevel)
	};
end


function o.IsDataMatch(data, matcher)
	local itemType, itemSubtype, equipLoc, itemLevel, equipLevel = o.SplitData(data);
	
	if (matcher[1] ~= nil) then
		local allowedSubtypes = matcher[1][itemType];
		if (allowedSubtypes == nil) then
			return nil;
		end
		-- If allowedSubtypes is true, then all subtypes are allowed.
		if (allowedSubtypes ~= true) then
			if (allowedSubtypes[itemSubtype] == nil) then
				return nil;
			end
		end
	end
	
	if (matcher[2] ~= nil) then
		if (matcher[2][equipLoc] == nil) then
			return nil;
		end
	end
	
	if (matcher[3] ~= nil or matcher[4] ~= nil) then
		if (matcher[3] ~= nil) then
			if (itemLevel == nil or itemLevel < matcher[3]) then
				return nil;
			end
		end
		if (matcher[4] ~= nil) then
			if (itemLevel == nil or itemLevel > matcher[4]) then
				return nil;
			end
		end
	end
	
	if (matcher[5] ~= nil or matcher[6] ~= nil) then
		if (matcher[5] ~= nil) then
			if (equipLevel == nil or equipLevel < matcher[5]) then
				return nil;
			end
		end
		if (matcher[6] ~= nil) then
			if (equipLevel == nil or equipLevel > matcher[6]) then
				return nil;
			end
		end
	end
	
	return true;
end



function o.CreateTypeAndSubtypeSorter(indexingKey, reverse, skipEquals, accessDB)
	local comparator = ((reverse and ">") or "<");
	if (not skipEquals) then
		comparator = (comparator .. "=");
	end
	
	local accessor = ("%s");
	if (indexingKey ~= nil) then
		if (type(indexingKey) ~= "number") then
			indexingKey = ("\"" .. tostring(indexingKey) .. "\"");
		end
		accessor = (accessor .. "[" .. indexingKey .. "]");
	end
	
	local sorter;
	if (accessDB == true) then
		sorter = assert(loadstring(
			([[
			local o = ...;
			local stringbyte = string.byte;
			local l_STATIC_DB = o.STATIC_DB;
			return (function(e1, e2)
				e1, e2 = ((%s * 6) - 5), ((%s * 6) - 5);
				local i1, i2 = (stringbyte(l_STATIC_DB, e1, e1) or -1), (stringbyte(l_STATIC_DB, e2, e2) or -1);
				if (i1 ~= i2) then
					return (i1 %s i2);
				else
					return (stringbyte(l_STATIC_DB, (e1 + 1), (e1 + 1)) %s stringbyte(l_STATIC_DB, (e2 + 1), (e2 + 1)));
				end
			end);
			]]):format(
				accessor:format("e1"), accessor:format("e2"), comparator, comparator
			)
		))(o);
		comparator = nil;
	else
		-- Conveniently, we can just use basic string comparison to sort by type/subtype, since the data starts with type and then subtype.
		sorter = assert(loadstring(
			([[
			local o = ...;
			return (function(e1, e2) return (%s %s %s); end);
			]]):format(
				accessor:format("e1"), comparator, accessor:format("e2")
			)
		))(o);
	end
	
	return sorter, comparator;
end



function o.CreateEquipLocSorter(indexingKey, reverse, skipEquals, accessDB)
	local comparator = ((reverse and ">") or "<");
	if (not skipEquals) then
		comparator = (comparator .. "=");
	end
	
	local accessor = ("%s");
	if (indexingKey ~= nil) then
		if (type(indexingKey) ~= "number") then
			indexingKey = ("\"" .. tostring(indexingKey) .. "\"");
		end
		accessor = (accessor .. "[" .. indexingKey .. "]");
	end
	if (accessDB == true) then
		accessor = ("(stringbyte(l_STATIC_DB, ((" .. accessor .. " * 6) - 3), ((" .. accessor .. " * 6) - 3)) or -1)");
	else
		accessor = ("stringbyte(" .. accessor .. ", 3, 3)");
	end
	
	local sorter = assert(loadstring(
		([[
		local o = ...;
		local stringbyte = string.byte;
		local l_STATIC_DB = o.STATIC_DB;
		return (function(e1, e2) return (%s %s %s); end);
		]]):format(
			accessor:format("e1", "e1"), comparator, accessor:format("e2", "e2")
		)
	))(o);
	
	return sorter, nil;
end



function o.CreateItemLevelSorter(indexingKey, reverse, skipEquals, accessDB)
	local comparator = ((reverse and ">") or "<");
	if (not skipEquals) then
		comparator = (comparator .. "=");
	end
	
	local accessor = ("%s");
	if (indexingKey ~= nil) then
		if (type(indexingKey) ~= "number") then
			indexingKey = ("\"" .. tostring(indexingKey) .. "\"");
		end
		accessor = (accessor .. "[" .. indexingKey .. "]");
	end
	if (accessDB == true) then
		accessor = ("(((stringbyte(l_STATIC_DB, ((" .. accessor .. " * 6) - 2), ((" .. accessor .. " * 6) - 2)) or -1) * 256) + (stringbyte(l_STATIC_DB, ((" .. accessor .. " * 6) - 1), ((" .. accessor .. " * 6) - 1)) or -1))");
	else
		accessor = ("((stringbyte(" .. accessor .. ", 4, 4) * 256) + stringbyte(" .. accessor .. ", 5, 5))");
	end
	
	local sorter = assert(loadstring(
		([[
		local o = ...;
		local stringbyte = string.byte;
		local l_STATIC_DB = o.STATIC_DB;
		return (function(e1, e2) return (%s %s %s); end);
		]]):format(
			accessor:format("e1", "e1", "e1", "e1"), comparator, accessor:format("e2", "e2", "e2", "e2")
		)
	))(o);
	
	return sorter, nil;
end



function o.CreateEquipLevelSorter(indexingKey, reverse, skipEquals, accessDB)
	local comparator = ((reverse and ">") or "<");
	if (not skipEquals) then
		comparator = (comparator .. "=");
	end
	
	local accessor = ("%s");
	if (indexingKey ~= nil) then
		if (type(indexingKey) ~= "number") then
			indexingKey = ("\"" .. tostring(indexingKey) .. "\"");
		end
		accessor = (accessor .. "[" .. indexingKey .. "]");
	end
	if (accessDB == true) then
		accessor = ("(stringbyte(l_STATIC_DB, (" .. accessor .. " * 6), (" .. accessor .. " * 6)) or -1)");
	else
		accessor = ("stringbyte(" .. accessor .. ", 6, 6)");
	end
	
	local sorter = assert(loadstring(
		([[
		local o = ...;
		local stringbyte = string.byte;
		local l_STATIC_DB = o.STATIC_DB;
		return (function(e1, e2) return (%s %s %s); end);
		]]):format(
			accessor:format("e1", "e1"), comparator, accessor:format("e2", "e2")
		)
	))(o);
	
	return sorter, nil;
end




do
	local tonumber = tonumber;
	local stringbyte = string.byte;
	
	function o.GetData(itemID)
		itemID = tonumber(itemID);
		local data = o.errata[itemID];
		if (data == nil) then
			local index = (itemID * 6);
			-- The only way itemLevelTo1 can be 255 is if the entry is blank.
			local itemLevelTo1 = stringbyte(o.STATIC_DB, (index - 2), (index - 2));
			if (itemLevelTo1 ~= nil and itemLevelTo1 ~= 255) then
				data = index;
			end
		end
		return data;
	end
end



do
	local type = type;
	local stringbyte = string.byte;
	
	function o.SplitData(data)
		local itemType, itemSubtype, equipLoc, itemLevelTo1, itemLevelRest, equipLevel;
		if (type(data) == "number") then
			itemType, itemSubtype, equipLoc, itemLevelTo1, itemLevelRest, equipLevel = stringbyte(o.STATIC_DB, (data - 5), data);
		else
			itemType, itemSubtype, equipLoc, itemLevelTo1, itemLevelRest, equipLevel = stringbyte(data, 1, 6);
		end
		if (itemLevelTo1 == nil or itemLevelTo1 == 255) then
			return nil, nil, nil, nil, nil;
		end
		return
			((itemType ~= 126 and itemType) or nil),
			((itemSubtype ~= 126 and itemSubtype) or nil),
			((equipLoc ~= 126 and equipLoc) or nil),
			((itemLevelTo1 * 256) + itemLevelRest),
			equipLevel;
	end
end



function o.SetData(itemID, newItemType, newItemSubtype, newEquipLoc, newItemLevel, newEquipLevel)
	itemID = tonumber(itemID);
	if (itemID == nil) then
		error(("ItemBasicInfoDB3.SetData: Invalid input data (itemID = %s)."):format(tostring(itemID)), 2);
	end
	
	local oldData = o.GetData(itemID);
	local newData = nil;
	if (newItemType ~= nil or newItemSubtype ~= nil or newEquipLoc ~= nil or newItemLevel ~= nil or newEquipLevel ~= nil) then
		newData = o.CombineData(newItemType, newItemSubtype, newEquipLoc, newItemLevel, newEquipLevel);
	end
	
	if (oldData ~= newData and o.excludedTypes[newItemType] ~= true) then
		o.errata[itemID] = newData;
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("ItemBasicInfoDB3_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		o.EventsManager2.DispatchCustomEvent("ItemBasicInfoDB3_ITEM_DATA_CHANGED", itemID, oldData, newData);
		return oldData, newData;
	else
		return oldData, oldData;
	end
end



do
	local mathfloor = math.floor;
	local stringchar = string.char;
	
	function o.CombineData(itemType, itemSubtype, equipLoc, itemLevel, equipLevel)
		-- string.format doesn't accept nulls.
		return (
			((itemType ~= nil and stringchar(itemType)) or "~")
			.. ((itemSubtype ~= nil and stringchar(itemSubtype)) or "~")
			.. ((equipLoc ~= nil and stringchar(equipLoc)) or "~")
			.. stringchar(mathfloor(itemLevel / 256))
			.. stringchar((itemLevel % 256))
			.. stringchar(equipLevel)
		);
	end
end




do
	local loc_UNRECOGNIZED_TYPE = o.Localization.UNRECOGNIZED_TYPE;
	
	function o.EncodeItemType(itemType, itemID)
		if (itemType ~= nil and itemType ~= "") then
			for index, typeTable in pairs(o.TYPES_AND_SUBTYPES) do
				if (typeTable.name == itemType) then
					return index;
				end
			end
			
			itemID = tonumber(itemID);
			if (o.unrecognized.itemTypes == nil) then
				o.unrecognized.itemTypes = {};
			end
			local unrecognized = o.unrecognized.itemTypes[itemType];
			if (unrecognized == nil) then
				unrecognized = {};
				o.unrecognized.itemTypes[itemType] = unrecognized;
				DEFAULT_CHAT_FRAME:AddMessage(loc_UNRECOGNIZED_TYPE:format(itemType, itemID));
			end
			if (itemID ~= nil) then
				unrecognized[itemID] = true;
			end
			return nil;
		end
		return 0;
	end
end


function o.DecodeItemType(itemType)
	local typeTable = o.TYPES_AND_SUBTYPES[tonumber(itemType)];
	if (typeTable ~= nil) then
		return typeTable.name;
	else
		return nil;
	end
end



do
	local loc_UNRECOGNIZED_SUBTYPE = o.Localization.UNRECOGNIZED_SUBTYPE;
	
	function o.EncodeItemSubtype(itemType, itemSubtype, itemID)
		if (itemType ~= nil and itemType ~= "" and itemSubtype ~= nil and itemSubtype ~= "") then
			local typeTable = o.TYPES_AND_SUBTYPES[tonumber(itemType)];
			if (typeTable ~= nil and typeTable.subtypes ~= nil) then
				for index, subtypeName in pairs(typeTable.subtypes) do
					if (subtypeName == itemSubtype) then
						return index;
					end
				end
			end
			
			itemID = tonumber(itemID);
			if (o.unrecognized.itemSubtypes == nil) then
				o.unrecognized.itemSubtypes = {};
			end
			local unrecognized = o.unrecognized.itemSubtypes[itemType];
			if (unrecognized == nil) then
				unrecognized = {};
				o.unrecognized.itemSubtypes[itemType] = unrecognized;
			end
			unrecognized = unrecognized[itemSubtype];
			if (unrecognized == nil) then
				unrecognized = {};
				o.unrecognized.itemSubtypes[itemType][itemSubtype] = unrecognized;
				DEFAULT_CHAT_FRAME:AddMessage(loc_UNRECOGNIZED_SUBTYPE:format(itemSubtype, o.DecodeItemType(itemType), itemID));
			end
			if (itemID ~= nil) then
				unrecognized[itemID] = true;
			end
			return nil;
		end
		return 0;
	end
end


function o.DecodeItemSubtype(itemType, itemSubtype)
	local typeTable = o.TYPES_AND_SUBTYPES[tonumber(itemType)];
	if (typeTable ~= nil and typeTable.subtypes ~= nil) then
		return typeTable.subtypes[tonumber(itemSubtype)];
	else
		return nil;
	end
end



do
	local loc_UNRECOGNIZED_EQUIP_LOC = o.Localization.UNRECOGNIZED_EQUIP_LOC;
	
	function o.EncodeEquipLoc(equipLoc, itemID)
		if (equipLoc ~= nil and equipLoc ~= "") then
			for index, equipLocName in pairs(o.EQUIP_LOCATIONS) do
				if (equipLocName == equipLoc) then
					return index;
				end
			end
			
			itemID = tonumber(itemID);
			if (o.unrecognized.equipLocs ~= nil) then
				o.unrecognized.equipLocs = {};
			end
			local unrecognized = o.unrecognized.equipLocs[equipLoc];
			if (unrecognized == nil) then
				unrecognized = {};
				o.unrecognized.equipLocs[equipLoc] = unrecognized;
				DEFAULT_CHAT_FRAME:AddMessage(loc_UNRECOGNIZED_EQUIP_LOC:format(equipLoc, itemID));
			end
			if (itemID ~= nil) then
				unrecognized[itemID] = true;
			end
			return nil;
		end
		return 0;
	end
end


function o.DecodeEquipLoc(equipLoc)
	return o.EQUIP_LOCATIONS[tonumber(equipLoc)];
end




function o.GetTypeExcluded(itemType)
	return ((o.excludedTypes[itemType] and true) or false);
end


function o.SetTypeExcluded(itemType, isExcluded)
	o.excludedTypes[itemType] = isExcluded;
end




function o.t_CheckUnrecognized(unrecognized)
	o.t_CheckUnrecognized = nil;
	
	local next = next;
	local pairs = pairs;
	local stillUnrecognized = false;
	local itemType, itemSubtype, equipLoc, itemLevel, equipLevel;
	local data;
	
	local itemTypes = unrecognized.itemTypes;
	if (itemTypes ~= nil) then
		local realType;
		for unrecogType, itemIDs in pairs(itemTypes) do
			realType = o.EncodeItemType(unrecogType);
			if (realType ~= nil) then
				for itemID in pairs(itemIDs) do
					data = o.GetData(itemID);
					if (data ~= nil) then
						itemType, itemSubtype, equipLoc, itemLevel, equipLevel = o.SplitData(data);
						o.SetData(itemID, realType, itemSubtype, equipLoc, itemLevel, equipLevel);
					end
				end
				itemTypes[unrecogType] = nil;
			end
		end
		if (next(itemTypes) ~= nil) then
			stillUnrecognized = true;
		else
			unrecognized.itemTypes = nil;
		end
	end
	
	local itemSubtypes = unrecognized.itemSubtypes;
	if (itemSubtypes ~= nil) then
		local realSubtype;
		for unrecogType, subtypes in pairs(itemSubtypes) do
			for unrecogSubtype, itemIDs in pairs(subtypes) do
				realSubtype = o.EncodeItemSubtype(unrecogType, unrecogSubtype);
				if (realSubtype ~= nil) then
					for itemID in pairs(itemIDs) do
						data = o.GetData(itemID);
						if (data ~= nil) then
							itemType, itemSubtype, equipLoc, itemLevel, equipLevel = o.SplitData(data);
							o.SetData(itemID, itemType, realSubtype, equipLoc, itemLevel, equipLevel);
						end
					end
					subtypes[unrecogSubtype] = nil;
				end
			end
			if (next(subtypes) == nil) then
				itemSubtypes[unrecogType] = nil;
			end
		end
		if (next(itemSubtypes) ~= nil) then
			stillUnrecognized = true;
		else
			unrecognized.itemSubtypes = nil;
		end
	end
	
	local equipLocs = unrecognized.equipLocs;
	if (equipLocs ~= nil) then
		local realEquipLoc;
		for unrecogEquipLoc, itemIDs in pairs(equipLocs) do
			realEquipLoc = o.EncodeEquipLoc(unrecogEquipLoc);
			if (realEquipLoc ~= nil) then
				for itemID in pairs(itemIDs) do
					data = o.GetData(itemID);
					if (data ~= nil) then
						itemType, itemSubtype, equipLoc, itemLevel, equipLevel = o.SplitData(data);
						o.SetData(itemID, itemType, itemSubtype, realEquipLoc, itemLevel, equipLevel);
					end
				end
				equipLocs[unrecogEquipLoc] = nil;
			end
		end
		if (next(equipLocs) ~= nil) then
			stillUnrecognized = true;
		else
			unrecognized.equipLocs = nil;
		end
	end
	
	return stillUnrecognized;
end
