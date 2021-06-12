
local o = TalentLinksDB1; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_ChatLinksMonitor2_TALENT_LINKS_FOUND: (msg, linksArray)
--
-- IterateDB: iterator, state, start = (keysOnly, sortedByName)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state, prevKey)
	-- IterateDB_GetNextSortedPair: nextKey, nextVal = (state, prevKey)
-- GetDBSize: size = ()
-- BuildLink: link = (talentID[, rank])
-- BuildChatlink: chatlink = (talentID[, data][, rank])
-- CreateMatcher: matcher = (text)
-- IsDataMatch: isMatch = (data, matcher)
-- CreateNameSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateNameAndRankSorter: sorter = (talentIDKey, dataKey[, indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (talentID)
-- GetRank: rank = (talentID)
-- SplitData: name, numRanks = (data)
-- GetName: name = (talentID)
-- GetNumRanks: numRanks = (talentID)
-- SetData: oldData, newData = (talentID, newName, newNumRanks)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.

o.activeDB = nil;
o.lookupCache = {}; -- [talentID] = index to data in string table or false if missing;
-- activeDBSize = 0;
-- errata = {};




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	o.EventsManager2.RegisterForEvent(o, nil, "ChatLinksMonitor2_TALENT_LINKS_FOUND", false, false);
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("TalentLinksDB1_DB_SIZE_CHANGED", false);
	ACE("TalentLinksDB1_TALENT_NAME_CHANGED", false);
	ACE("TalentLinksDB1_TALENT_NUM_RANKS_CHANGED", false);
	
	local saved = TalentLinksDB1_SavedData;
	if (saved == nil) then
		saved = {
			errata = {};
		};
		TalentLinksDB1_SavedData = saved;
	end
	o.errata = saved.errata;
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local tonumber = tonumber;
	local dbLookup = {};
	local count = 0;
	for talentID, data, numRanks in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+([^\n]))") do
		dbLookup[tonumber(talentID)] = data;
		-- Add 1 to account for rank 0.
		count = (count + (numRanks + 1));
	end
	
	local errata = o.errata;
	local staticData;
	for talentID, data in pairs(errata) do
		staticData = dbLookup[talentID];
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[talentID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry and the
				-- count has already been incremented by the preceding loop.
			end
		else
			-- There's no entry. Increment the count.
			-- Add 1 to account for rank 0.
			count = (count + (data:sub(-1, -1) + 1));
			-- Add this to the dbLookup, only because we're going to use it down below.
			dbLookup[talentID] = data;
		end
	end
	
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("TalentLinksDB1_DB_SIZE_CHANGED", oldCount, count);
	end
	
	local tonumber = tonumber;
	local GetTalentLink = GetTalentLink;
	local GetTalentInfo = GetTalentInfo;
	local SetData = o.SetData;
	local numTabs = GetNumTalentTabs();
	local link, name, icon, tier, column, currRank, maxRank, talentID, dbLookupData;
	for index = 1, GetNumTalentTabs(), 1 do
		for subIndex = 1, GetNumTalents(index), 1 do
			link = GetTalentLink(index, subIndex, false);
			name, icon, tier, column, currRank, maxRank = GetTalentInfo(index, subIndex, false);
			talentID = tonumber(link:match("([^:]+)", 20));
			dbLookupData = dbLookup[talentID];
			if (dbLookupData == nil or dbLookupData ~= (name .. maxRank)) then
				SetData(talentID, name, maxRank);
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
	
	function o.OnEvent_ChatLinksMonitor2_TALENT_LINKS_FOUND(msg, linksArray)
		local talentID, rank, name;
		for index, linkIndex in ipairs(linksArray) do
			talentID, rank, name = stringmatch(msg, "([^:]+):([^|]+)|h%[(.-)%]", (linkIndex + 19));
			o.SetData(talentID, name, rank);
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
		for talentID in pairs(errata) do
			sortedErrataIDs[#sortedErrataIDs + 1] = talentID;
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
	local stringsub = string.sub;
	local mathfloor = math.floor;
	
	function o.IterateDB_GetNextPair(state, prevKey)
		if (prevKey ~= nil) then
			local rankInfo = mathfloor(prevKey / 100000);
			-- See if the next rank (current rank + 1) is less than or equal to the max rank.
			if ((mathfloor(rankInfo / 10) + 1) <= (rankInfo % 10)) then
				-- Staying on this one. Increment the current rank counter.
				return (prevKey + 1000000), state.prevVal;
			--else
				-- Time to move onto the next ID.
			end
		end
		
		local nextKey, nextVal;
		local errata = state.errata;
		local staticDBPos = state.staticDBPos;
		local numRanks;
		if (staticDBPos ~= nil) then
			if (state.keysOnly == true) then
				nextKey, numRanks, state.staticDBPos = stringmatch(state.staticDB, "\n([^~]+)~[^\n]+([^\n])()", staticDBPos);
			else
				nextKey, nextVal, numRanks, state.staticDBPos = stringmatch(state.staticDB, "\n([^~]+)~([^\n]+([^\n]))()", staticDBPos);
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
			nextKey, nextVal = next(errata, state.prevErrataKey);
			state.prevErrataKey = nextKey;
			if (state.keysOnly == true) then
				nextVal = nil;
			end
		end
		
		if (nextKey ~= nil) then
			nextKey = (nextKey + (100000 * ((numRanks or stringsub(nextVal, -1, -1)) + 1)) + (1000000 * 1));
		end
		state.prevVal = nextVal;
		return nextKey, nextVal;
	end
end


do
	local tonumber = tonumber;
	local stringmatch = string.match;
	local stringsub = string.sub;
	local mathfloor = math.floor;
	
	function o.IterateDB_GetNextSortedPair(state, prevKey)
		local nextKey, nextVal;
		if (prevKey ~= nil) then
			local rankInfo = mathfloor(prevKey / 100000);
			-- See if the next rank (current rank + 1) is less than or equal to the max rank.
			if ((mathfloor(rankInfo / 10) + 1) <= (rankInfo % 10)) then
				-- Staying on this one. Increment the current rank counter.
				return (prevKey + 1000000), state.prevVal;
			--else
				-- Time to move onto the next ID.
			end
		end
		
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
		
		if (nextKey ~= nil) then
			nextKey = (nextKey + (100000 * (stringsub(nextVal, -1, -1) + 1)) + (1000000 * 1));
		end
		if (state.keysOnly == true) then
			state.prevVal = nil;
			return nextKey, nil;
		else
			state.prevVal = nextVal;
			return nextKey, nextVal;
		end
	end
end



function o.BuildLink(talentID, rank)
	if (talentID > 1000000) then
		if (rank == nil) then
			rank = o.GetRank(talentID);
		end
		talentID = (talentID % 100000);
	end
	return ("talent:" .. talentID .. ":" .. ((rank or 0) - 1));
end


function o.BuildChatlink(talentID, data, rank)
	local link;
	if (talentID ~= nil and talentID > 1000000) then
		if (rank == nil) then
			rank = o.GetRank(talentID);
		end
		talentID = (talentID % 100000);
	end
	if (data == nil) then
		data = o.GetData(talentID);
	end
	if (data ~= nil) then
		local name, numRanks = o.SplitData(data);
		link = ("|cff4e96f7|H%s|h[%s]|h|r"):format(o.BuildLink(talentID, (rank or numRanks)), name);
	end
	return link;
end



function o.CreateMatcher(text)
	if (text:sub(-1, -1) == "$") then
		return (text:sub(1, -2) .. ".$");
	else
		return (text .. ".*.$");
	end
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
		accessor = ("(cacheParent[1][((" .. accessor .. " > 1000000) and (" .. accessor .. " %% 100000)) or " .. accessor .. "] or -1)");
	end
	
	local sorter = assert(loadstring(
		([[
		local o = ...;
		local cacheParent = setmetatable({}, {
			__index = (function(self, key)
				local tonumber = tonumber;
				local lookup = {};
				for talentID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(talentID)] = data;
				end
				for talentID, data in pairs(o.errata) do
					lookup[talentID] = data;
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


function o.CreateNameAndRankSorter(talentIDKey, dataKey, indexingKey, reverse, skipEquals, accessDB)
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
	local dataAccessor, rankAccessor;
	if (accessDB == true) then
		dataAccessor = ("(cacheParent[1][((" .. accessor .. " > 1000000) and (" .. accessor .. " %% 100000)) or " .. accessor .. "] or -1)");
		rankAccessor = ("mathfloor(mathfloor(%s / 100000) / 10)");
	else
		dataAccessor = (accessor .. "[" .. dataKey .. "]");
		rankAccessor = ("mathfloor(mathfloor(" .. accessor .. "[" .. talentIDKey .. "] / 100000) / 10)");
	end
	
	local sorter = assert(loadstring(
		([[
		local o, mathfloor = ...;
		local cacheParent = setmetatable({}, {
			__index = (function(self, key)
				local tonumber = tonumber;
				local lookup = {};
				for talentID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(talentID)] = data;
				end
				for talentID, data in pairs(o.errata) do
					lookup[talentID] = data;
				end
				-- Use [1] instead of .cache for faster lookup.
				self[1] = lookup;
				return lookup;
			end);
			__mode = ("kv");
		});
		return (function(e1, e2) local d1, d2 = %s, %s; if (d1 ~= d2) then return (d1 %s d2); else return (%s %s %s); end end);
		]]):format(
			dataAccessor:format("e1", "e1", "e1"), dataAccessor:format("e2", "e2", "e2"), comparator,
			rankAccessor:format("e1"), comparator, rankAccessor:format("e2")
		)
	))(o, math.floor);
	
	return sorter;
end




do
	local tonumber = tonumber;
	
	function o.GetData(talentID)
		talentID = tonumber(talentID);
		if (talentID ~= nil and talentID > 1000000) then
			talentID = (talentID % 100000);
		end
		local data = o.errata[talentID];
		if (data == nil) then
			local startPos = o.lookupCache[talentID];
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
	local mathfloor = math.floor;
	
	function o.GetRank(talentID)
		return ((talentID ~= nil and (mathfloor(mathfloor(talentID / 100000) / 10) - 1)) or nil);
	end
end


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


function o.GetName(talentID)
	local data = o.GetData(talentID);
	return ((data ~= nil and data:sub(1, -2)) or nil);
end


do
	local tonumber = tonumber;
	
	function o.GetNumRanks(talentID)
		local data = o.GetData(talentID);
		return ((data ~= nil and tonumber(data:sub(-1, -1))) or nil);
	end
end



function o.SetData(talentID, newName, newNumRanks)
	talentID = tonumber(talentID);
	newNumRanks = tonumber(newNumRanks);
	if (newNumRanks ~= nil and newNumRanks < 1) then
		newNumRanks = 1;
	end
	if (
		talentID == nil
		or (newName == nil and newNumRanks ~= nil)
		or (newName ~= nil and newNumRanks == nil)
		or (newName ~= nil and newName:len() == 0)
		or (newNumRanks ~= nil and (newNumRanks < 1 or newNumRanks > 5))
	) then
		error(
			("TalentLinksDB1.SetData: Invalid input data (talentID = %s, newName = \"%s\", newNumRanks = %s)."):format(
				tostring(talentID), tostring(newName), tostring(newNumRanks)
			), 2
		);
	end
	
	local withRank;
	if (talentID > 1000000) then
		withRank = talentID;
		talentID = (talentID % 100000);
	else
		withRank = (talentID + (1000000 * newNumRanks));
	end
	
	local oldData = o.GetData(talentID);
	local oldName, oldNumRanks = o.SplitData(oldData);
	local newData = nil;
	if (newName ~= nil and newNumRanks ~= nil) then
		newData = (newName .. newNumRanks);
	end
	
	if (oldName ~= newName or ((newNumRanks or 0) > (oldNumRanks or 0))) then
		o.errata[talentID] = newData;
		
		local change;
		if (newNumRanks ~= nil) then
			-- Add 1 to account for the rank 0.
			change = ((newNumRanks - ((oldNumRanks ~= nil and (oldNumRanks + 1)) or 0)) + 1);
		else
			if (oldNumRanks ~= nil) then
				change = -oldNumRanks;
			else
				change = 0;
			end
		end
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("TalentLinksDB1_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		if (oldName ~= newName) then
			o.EventsManager2.DispatchCustomEvent("TalentLinksDB1_TALENT_NAME_CHANGED", withRank, oldName, newName);
		end
		if (oldNumRanks ~= newNumRanks) then
			o.EventsManager2.DispatchCustomEvent("TalentLinksDB1_TALENT_NUM_RANKS_CHANGED", withRank, oldNumRanks, newNumRanks);
		end
		return oldData, newData;
	else
		return oldData, oldData;
	end
end
