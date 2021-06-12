
local o = ItemLinksDB3; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_ChatLinksMonitor2_ITEM_LINKS_FOUND: (msg, linksArray)
--
-- GetDBSize: size = ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByName)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state)
	-- IterateDB_GetNextSortedPair: nextKey, nextVal = (state)
-- CombGetItemInfo: numNew, numUpdated = ([onlyNew][, maxID][, dbLookup])
-- BuildLink: link = (itemID[, level])
-- BuildChatlink: chatlink = (itemID[, data][, level])
-- CreateMatcher: matcher = ([name][, rarity])
-- IsDataMatch: isMatch = (data, matcher)
-- CreateNameSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateRaritySorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (itemID)
-- SplitData: name, rarity = (data)
-- GetName: name = (itemID)
-- GetRarity: rarity = (itemID)
-- SetData: oldData, newData = (itemID, newName, newRarity)
--
-- GetRarityExcluded: isExcluded = (rarity)
-- SetRarityExcluded: (rarity, isExcluded)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.
o.RARITY_HEX_TO_NUM = {
	["9d9d9d"] = 0;
	["ffffff"] = 1;
	["1eff00"] = 2;
	["0070dd"] = 3;
	["a335ee"] = 4;
	["ff8000"] = 5;
	["e6cc80"] = 7; -- Also goes to 6, but there are apparently no 6 items in the game, so meh.
};

o.activeDB = nil;
o.lookupCache = {}; -- [itemID] = index to data in string table or false if missing;
-- activeDBSize = 0;
-- errata = {};
-- excludedRarities = {};




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	if (ITEM_QUALITY_COLORS[7] == nil) then
		local r, g, b, hex = GetItemQualityColor(7);
		ITEM_QUALITY_COLORS[7] = { r = r; g = g; b = b; hex = hex; };
		ITEM_QUALITY7_DESC = ("Heirloom");
	end
	
	o.EventsManager2.RegisterForEvent(o, nil, "ChatLinksMonitor2_ITEM_LINKS_FOUND", false, false);
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("ItemLinksDB3_DB_SIZE_CHANGED", false);
	ACE("ItemLinksDB3_ITEM_NAME_CHANGED", false);
	ACE("ItemLinksDB3_ITEM_RARITY_CHANGED", false);
	
	local saved = ItemLinksDB3_SavedData;
	if (saved == nil) then
		saved = {
			errata = {};
			excludedRarities = {};
		};
		ItemLinksDB3_SavedData = saved;
	end
	o.errata = saved.errata;
	o.excludedRarities = saved.excludedRarities;
	
	local excludedRarities = o.excludedRarities;
	if (next(excludedRarities) ~= nil) then
		local tostring = tostring;
		local excludedRaritiesAsStrings = {};
		for rarity in pairs(excludedRarities) do
			excludedRaritiesAsStrings[tostring(rarity)] = ("");
		end
		-- gsub will find "" for any item with a rarity that's on the list of excluded ones, and replace that entry with the blank string.
		-- Any item with a rarity not on the exluded list will simply be left alone, since it will index to nil in the table.
		-- This is pretty much the absolute fastest way to do this. Unfortunately, no matter what, it's going to have to
		-- throw the old megastring in the garbage. Not a huge deal since it's only done once.
		o.STATIC_DB = o.STATIC_DB:gsub("\n[^~]+~[^\n]+([^\n])", excludedRaritiesAsStrings);
		local errata = o.errata;
		for itemID, data in pairs(errata) do
			if (excludedRaritiesAsStrings[data:sub(-1, -1)] == "") then
				errata[itemID] = nil;
			end
		end
	end
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local tonumber = tonumber;
	local dbLookup = {};
	local maxID = 0;
	local count = 0;
	for itemID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
		itemID = tonumber(itemID);
		dbLookup[itemID] = data;
		if (itemID > maxID) then
			maxID = itemID;
		end
		count = (count + 1);
	end
	
	local errata = o.errata;
	local staticData;
	for itemID, data in pairs(errata) do
		staticData = dbLookup[itemID];
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[itemID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry and the
				-- count has already been incremented by the preceding loop.
			end
		else
			-- There's no entry. Increment the count.
			count = (count + 1);
			-- Add this to the dbLookup, only because we're going to pass this to CombGetItemInfo().
			dbLookup[itemID] = data;
		end
	end
	
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("ItemLinksDB3_DB_SIZE_CHANGED", oldCount, count);
	end
	
	o.CombGetItemInfo(true, maxID, dbLookup);
	
	if (LootLink_Database ~= nil) then
		local SetData = o.SetData;
		for itemID, itemData in pairs(LootLink_Database) do
			if (dbLookup[itemID] == nil) then
				SetData(itemID, itemData[1], itemData[2]);
			end
		end
	end
	
	if (ItemLinks ~= nil) then
		local RARITY_HEX_TO_NUM = o.RARITY_HEX_TO_NUM;
		local SetData = o.SetData;
		local itemID, baseName, rarity;
		for name, data in pairs(ItemLinks) do
			itemID, suffixID = data.i:match("^(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:(%-?%d+):%-?%d+");
			itemID = tonumber(itemID);
			if (itemID ~= nil and dbLookup[itemID] == nil) then
				if (suffixID ~= "0") then
					baseName = name:match("^(.+) of");
				else
					baseName = name;
				end
				rarity = RARITY_HEX_TO_NUM[data.c:sub(3, -1)];
				if (baseName ~= nil and rarity ~= nil) then
					SetData(itemID, baseName, rarity);
				end
			end
		end
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local ipairs = ipairs;
	local stringmatch = string.match;
	
	function o.OnEvent_ChatLinksMonitor2_ITEM_LINKS_FOUND(msg, linksArray)
		local rarityHex, itemID, name;
		for index, linkIndex in ipairs(linksArray) do
			-- suffixID must be 0 for this to be valid.
			rarityHex, itemID, name = stringmatch(msg, "(%x%x%x%x%x%x)|Hitem:([^:]+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:0:[^|]+|h%[(.-)%]", (linkIndex + 4));
			if (itemID ~= nil) then
				o.SetData(itemID, name, o.RARITY_HEX_TO_NUM[rarityHex]);
			end
		end
	end
end




function o.GetDBSize()
	return o.activeDBSize;
end



function o.IterateDB(keysOnly, sortedByName)
	-- The vast majority of the time there's going to be errata, but if there's not, we can just use the normal iterator.
	local errata = o.errata;
	if (sortedByName == true and next(errata) == nil) then
		sortedByName = false;
	end
	
	local state = { staticDBPos = 1; staticDB = o.STATIC_DB; keysOnly = ((keysOnly and true) or nil); };
	local func;
	if (sortedByName == true) then
		func = o.IterateDB_GetNextSortedPair;
		local sortedErrataIDs = {};
		for itemID in pairs(errata) do
			sortedErrataIDs[#sortedErrataIDs + 1] = itemID;
		end
		-- Needs to be ZYX...CBA, not ABC...XYZ, so reverse it.
		table.NicheDevTools_SortByLookup(sortedErrataIDs, o.errata, true);
		state.sortedErrataIDs = sortedErrataIDs;
		state.topErrata = o.errata[sortedErrataIDs[#sortedErrataIDs]];
		-- Check to see if there's any errata to give soon.
		-- Average length of an entry is about 30. Look ahead 100 entries.
		local peekVal;
		peekVal, state.lastPeekPos = state.staticDB:match("\n[^~]+~([^\n]+)()", 300);
		if (peekVal == nil) then
			-- We must be past the end. Check the last entry instead.
			peekVal, state.lastPeekPos = state.staticDB:match("\n[^~]+~([^\n]+)()$");
		end
		state.watchingErrata = ((state.topErrata < peekVal) or nil);
	else
		func = o.IterateDB_GetNextPair;
		state.errata = ((next(errata) ~= nil and errata) or nil);
	end
	
	return func, state, nil;
end


do
	local tonumber = tonumber;
	local next = next;
	local stringmatch = string.match;
	
	function o.IterateDB_GetNextPair(state)
		local nextKey, nextVal;
		local errata = state.errata;
		local staticDBPos = state.staticDBPos;
		if (staticDBPos ~= nil) then
			if (state.keysOnly == true) then
				nextKey, state.staticDBPos = stringmatch(state.staticDB, "\n([^~]+)~[^\n]+()", staticDBPos);
			else
				nextKey, nextVal, state.staticDBPos = stringmatch(state.staticDB, "\n([^~]+)~([^\n]+)()", staticDBPos);
			end
			if (nextKey ~= nil) then
				nextKey = tonumber(nextKey);
				if (errata ~= nil and errata[nextKey] ~= nil) then
					-- Return something from the errata. NOT necessarily the updated data for this key, just something.
					-- This is necessary because we don't know the iteration order of the errata, so returning the updated
					-- data could cause duplicate returns when we actually run out of things to return from the static DB.
					nextKey = nil;
				end
			else
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


do
	local tonumber = tonumber;
	local stringmatch = string.match;
	
	function o.IterateDB_GetNextSortedPair(state)
		--[[
		static = "Ba Be Bu"
		errata = "Aa Bo Xy"
		topErrata = "Aa"
		First iteration returns "Aa" because topErrata ("Aa") < nextVal ("Ba"). topErrata becomes "Bo".
		Second iteration returns "Ba" because topErrata ("Bo") > nextVal ("Ba").
		Third iteration returns "Be" because topErrata ("Bo") > nextVal ("Be").
		Fourth iteration returns "Bo" because topErrata ("Bo") < nextVal ("Bu"). topErrata becomes "Xy".
		Fifth iteration returns "Bu" because topErrata ("Xy") > nextVal ("Bu").
		Sixth iteration returns "Xy" because nextVal == nil.
		This is kind of like a delayed version of the merging phase of mergesort, wherein the two arrays
		are the static DB and the sorted errata. The trouble is that the static DB can have the older version
		of an entry which we have errata stored for, so we have to check that.
		--]]
		local nextKey, nextVal;
		local topErrata = state.topErrata;
		local staticDBPos = state.staticDBPos;
		if (staticDBPos ~= nil) then
			local staticDB = state.staticDB;
			nextKey, nextVal, staticDBPos = stringmatch(staticDB, "\n([^~]+)~([^\n]+)()", staticDBPos);
			nextKey = tonumber(nextKey);
			-- Only bother doing the errata checking loop if there's errata remaining.
			if (topErrata ~= nil) then
				while (nextKey ~= nil and o.errata[nextKey] ~= nil) do
					-- Keep looping until we can find something in the static DB that doesn't have an entry in the errata.
					-- If we have some errata that actually comes before whatever we find during the loop, that'll be
					-- handled below. It won't make us do this loop again in the next iteration, because we're going to
					-- save the static DB position if we move past an entry that has something in the errata; this prevents
					-- us from looking at it again in subsequent iterations.
					state.staticDBPos = staticDBPos;
					nextKey, nextVal, staticDBPos = stringmatch(staticDB, "\n([^~]+)~([^\n]+)()", staticDBPos);
					nextKey = tonumber(nextKey);
				end
			end
			if (nextKey == nil) then
				state.staticDBPos = nil;
			end
		end
		
		local recheckPeek = false;
		if (nextVal ~= nil) then
			-- There's something from the static DB. But is there errata to give instead?
			if (state.watchingErrata ~= true or topErrata > nextVal) then
				-- Nothing to give. Update the static DB position.
				state.staticDBPos = staticDBPos;
				recheckPeek = (staticDBPos >= state.lastPeekPos);
			else
				-- There is something. Give the errata and update the remaining errata.
				nextVal = nil;
			end
		end
		
		if (nextVal == nil) then
			-- Give some errata.
			local sortedErrataIDs = state.sortedErrataIDs;
			local index = #sortedErrataIDs;
			nextKey = sortedErrataIDs[index];
			sortedErrataIDs[index] = nil;
			nextVal = topErrata;
			topErrata = o.errata[sortedErrataIDs[index - 1]];
			state.topErrata = topErrata;
			if (topErrata == nil) then
				state.watchingErrata = nil;
			end
			recheckPeek = true;
		end
		
		if (recheckPeek == true) then
			-- Check to see if there's any more errata to give soon.
			if (topErrata ~= nil) then
				local peekVal;
				if (staticDBPos ~= nil) then
					-- Average length of an entry is about 30. Look ahead 100 entries.
					peekVal, state.lastPeekPos = stringmatch(state.staticDB, "\n[^~]+~([^\n]+)()", (staticDBPos + 300));
				end
				if (peekVal == nil) then
					-- We must be past the end. Check the last entry instead.
					peekVal, state.lastPeekPos = stringmatch(state.staticDB, "\n[^~]+~([^\n]+)()$");
				end
				state.watchingErrata = ((topErrata < peekVal) or nil);
			else
				state.watchingErrata = nil;
			end
		end
		
		if (state.keysOnly == true) then
			return nextKey, nil;
		else
			return nextKey, nextVal;
		end
	end
end



function o.CombGetItemInfo(onlyNew, maxID, dbLookup)
	if (maxID == nil or dbLookup == nil) then
		local checkMaxID = (maxID == nil);
		if (checkMaxID == true) then
			maxID = 0;
		end
		local addToDBLookup = (dbLookup == nil);
		if (addToDBLookup == true) then
			dbLookup = {};
		end
		for itemID, data in o.IterateDB(false, false) do
			if (addToDBLookup == true) then
				dbLookup[itemID] = data;
			end
			if (checkMaxID == true and itemID > maxID) then
				maxID = itemID;
			end
		end
	end
	
	local GetItemInfo = GetItemInfo;
	local SetData = o.SetData;
	local numNew = 0;
	local numUpdated = 0;
	
	local itemID = 1;
	local numConsecBlanks = 0;
	local lookupData, name, _, rarity, oldData, newData;
	while (numConsecBlanks < 500 or itemID < maxID) do
		if (onlyNew == true) then
			lookupData = dbLookup[itemID];
		end
		if (onlyNew == true and lookupData ~= nil) then
			numConsecBlanks = 0;
		else
			name, _, rarity = GetItemInfo(itemID);
			if (name ~= nil) then
				numConsecBlanks = 0;
				if (lookupData == nil) then
					lookupData = dbLookup[itemID];
				end
				if (lookupData == nil or lookupData ~= (name .. rarity)) then
					oldData, newData = SetData(itemID, name, rarity);
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



function o.BuildLink(itemID, level)
	return ("item:%d:0:0:0:0:0:0:0:%d"):format(itemID, (level or UnitLevel("player")));
end


function o.BuildChatlink(itemID, data, level)
	local link;
	if (data == nil) then
		data = o.GetData(itemID);
	end
	if (data ~= nil) then
		local name, rarity = o.SplitData(data);
		link = ("%s|H%s|h[%s]|h|r"):format(ITEM_QUALITY_COLORS[rarity].hex, o.BuildLink(itemID, level), name);
	end
	return link;
end



function o.CreateMatcher(name, rarity)
	local matchString;
	if (name == nil or name == "") then
		if (rarity ~= nil and rarity ~= "") then
			matchString = (rarity .. "$");
		else
			matchString = ("");
		end
	else
		if (name:sub(-1, -1) == "$") then
			matchString = (name:sub(1, -2) .. (rarity or ".") .. "$");
		else
			matchString = (name .. ".*" .. (rarity or ".") .. "$");
		end
	end
	return matchString;
end


--[[
function o.IsDataMatch(data, matcher)
	return (data:find(matcher));
end
--]]
o.IsDataMatch = string.find;



function o.CreateNameSorter(indexingKey, reverse, skipEquals, accessDB)
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
		accessor = ("(cacheParent[1][" .. accessor .. "] or \"\")");
	end
	
	local sorter = assert(loadstring(
		([[
		local o = ...;
		local cacheParent = setmetatable({}, {
			__index = (function(self, key)
				local tonumber = tonumber;
				local lookup = {};
				for itemID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(itemID)] = data;
				end
				for itemID, data in pairs(o.errata) do
					lookup[itemID] = data;
				end
				-- Use [1] instead of .cache for faster lookup.
				self[1] = lookup;
				return lookup;
			end);
			__mode = ("kv");
		});
		return (function(e1, e2) return (%s %s %s); end);
		]]):format(
			accessor:format("e1"), comparator, accessor:format("e2")
		)
	))(o);
	
	if (accessDB == true) then
		comparator = nil;
	end
	return sorter, comparator;
end


function o.CreateRaritySorter(indexingKey, reverse, skipEquals, accessDB)
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
		accessor = ("(cacheParent[1][" .. accessor .. "] or 9)");
	else
		accessor = ("stringsub(" .. accessor .. ", -1, -1)");
	end
	
	local sorter = assert(loadstring(
		([[
		local o, stringsub = ...;
		local cacheParent = setmetatable({}, {
			__index = (function(self, key)
				local tonumber = tonumber;
				local lookup = {};
				for itemID, data in o.STATIC_DB:gmatch("\n([^~]+)~[^\n]+([^\n])") do
					lookup[tonumber(itemID)] = tonumber(data);
				end
				local stringsub = string.sub;
				for itemID, data in pairs(o.errata) do
					lookup[itemID] = tonumber(stringsub(data, -1, -1));
				end
				-- Use [1] instead of .cache for faster lookup.
				self[1] = lookup;
				return lookup;
			end);
			__mode = ("kv");
		});
		return (function(e1, e2) return (%s %s %s); end);
		]]):format(
			accessor:format("e1"), comparator, accessor:format("e2")
		)
	))(o, string.sub);
	
	return sorter, nil;
end




do
	local tonumber = tonumber;
	
	function o.GetData(itemID)
		itemID = tonumber(itemID);
		local data = o.errata[itemID];
		if (data == nil) then
			local startPos = o.lookupCache[itemID];
			if (startPos ~= false) then
				data = o.STATIC_DB:match("[^\n]+", startPos);
			end
		end
		return data;
	end
end


setmetatable(o.lookupCache, {
	__index = (function(self, key)
		local startPos, endPos = o.STATIC_DB:find(("\n" .. key .. "~"), 1, true);
		if (endPos ~= nil) then
			-- Add 1 to go past the tilde.
			endPos = (endPos + 1);
		else
			-- Store false to prevent duplicate lookups.
			endPos = false;
		end
		self[key] = endPos;
		return endPos;
	end);
});


do
	local tonumber = tonumber;
	
	function o.SplitData(data)
		if (data ~= nil) then
			return data:sub(1, -2), tonumber(data:sub(-1, -1));
		else
			return nil, nil;
		end
	end
end


function o.GetName(itemID)
	local data = o.GetData(itemID);
	return ((data ~= nil and data:sub(1, -2)) or nil);
end


do
	local tonumber = tonumber;
	
	function o.GetRarity(itemID)
		local data = o.GetData(itemID);
		return ((data ~= nil and tonumber(data:sub(-1, -1))) or nil);
	end
end



function o.SetData(itemID, newName, newRarity)
	itemID = tonumber(itemID);
	newRarity = tonumber(newRarity);
	if (
		itemID == nil
		or (newName == nil and newRarity ~= nil)
		or (newName ~= nil and newRarity == nil)
		or (newName ~= nil and newName:len() == 0)
		or (newRarity ~= nil and (newRarity < 0 or newRarity > 7))
	) then
		error(
			("ItemLinksDB3.SetData: Invalid input data (itemID = %s, newName = \"%s\", newRarity = %s)."):format(
				tostring(itemID), tostring(newName), tostring(newRarity)
			), 2
		);
	end
	
	local oldData = o.GetData(itemID);
	local newData = nil;
	if (newName ~= nil and newRarity ~= nil) then
		newData = (newName .. newRarity);
	end
	
	if (oldData ~= newData and o.excludedRarities[newRarity] ~= true) then
		o.errata[itemID] = newData;
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("ItemLinksDB3_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		local oldName, oldRarity = o.SplitData(oldData);
		if (oldName ~= newName) then
			o.EventsManager2.DispatchCustomEvent("ItemLinksDB3_ITEM_NAME_CHANGED", itemID, oldName, newName);
		end
		if (oldRarity ~= newRarity) then
			o.EventsManager2.DispatchCustomEvent("ItemLinksDB3_ITEM_RARITY_CHANGED", itemID, oldRarity, newRarity);
		end
		return oldData, newData;
	else
		return oldData, oldData;
	end
end




function o.GetRarityExcluded(rarity)
	rarity = tonumber(rarity);
	if (rarity == nil or rarity < 0 or rarity > 7) then
		error(("ItemLinksDB3.GetRarityExcluded: Invalid rarity, %s."):format(tostring(rarity)), 2);
	end
	return ((o.excludedRarities[math.floor(rarity)] and true) or false);
end


function o.SetRarityExcluded(rarity, isExcluded)
	rarity = tonumber(rarity);
	if (rarity == nil or rarity < 0 or rarity > 7) then
		error(("ItemLinksDB3.SetRarityExcluded: Invalid rarity, %s."):format(tostring(rarity)), 2);
	end
	o.excludedRarities[math.floor(rarity)] = ((isExcluded and true) or nil);
end
