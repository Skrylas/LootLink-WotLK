
local o = AbilityLinksDB2; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_ChatLinksMonitor2_SPELL_LINKS_FOUND: (msg, linksArray)
--
-- IterateDB: iterator, state, start = (keysOnly, sortedByName)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state)
	-- IterateDB_GetNextSortedPair: nextKey, nextVal = (state)
-- GetDBSize: size = ()
-- CombGetSpellLink: numNew, numUpdated = ([onlyNew][, maxID][, dbLookup])
-- BuildLink: link = (abilityID)
-- BuildChatlink: chatlink = (abilityID[, data])
-- CreateMatcher: matcher = (text)
-- IsDataMatch: isMatch = (data, matcher)
-- CreateSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (abilityID)
-- SetData: oldData, newData = (abilityID, newName)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.

o.activeDB = nil;
o.lookupCache = {}; -- [abilityID] = index to data in string table or false if missing;
-- activeDBSize = 0;
-- errata = AbilityLinksDB2_Errata;




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	o.EventsManager2.RegisterForEvent(o, nil, "ChatLinksMonitor2_SPELL_LINKS_FOUND", false, false);
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("AbilityLinksDB2_DB_SIZE_CHANGED", false);
	ACE("AbilityLinksDB2_ABILITY_NAME_CHANGED", false);
	
	local errata = AbilityLinksDB2_Errata;
	if (errata == nil) then
		errata = {};
		AbilityLinksDB2_Errata = errata;
	end
	o.errata = errata;
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local tonumber = tonumber;
	local dbLookup = {};
	local maxID = 0;
	local count = 0;
	for abilityID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
		abilityID = tonumber(abilityID);
		dbLookup[abilityID] = data;
		if (abilityID > maxID) then
			maxID = abilityID;
		end
		count = (count + 1);
	end
	
	local staticData;
	for abilityID, data in pairs(errata) do
		staticData = dbLookup[abilityID];
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[abilityID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry and the
				-- count has already been incremented by the preceding loop.
			end
		else
			-- There's no entry. Increment the count.
			count = (count + 1);
			-- Add this to the dbLookup, only because we're going to pass this to CombGetSpellLink().
			dbLookup[abilityID] = data;
		end
	end
	
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("AbilityLinksDB2_DB_SIZE_CHANGED", oldCount, count);
	end
	
	o.CombGetSpellLink(true, maxID, dbLookup);
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local ipairs = ipairs;
	local stringmatch = string.match;
	
	function o.OnEvent_ChatLinksMonitor2_SPELL_LINKS_FOUND(msg, linksArray)
		for index, linkIndex in ipairs(linksArray) do
			o.SetData(stringmatch(msg, "([^|]+)|h%[(.-)%]", (linkIndex + 18)));
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
		for abilityID in pairs(errata) do
			sortedErrataIDs[#sortedErrataIDs + 1] = abilityID;
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



function o.CombGetSpellLink(onlyNew, maxID, dbLookup)
	if (maxID == nil or dbLookup == nil) then
		local checkMaxID = (maxID == nil);
		if (checkMaxID == true) then
			maxID = 0;
		end
		local addToDBLookup = (dbLookup == nil);
		if (addToDBLookup == true) then
			dbLookup = {};
		end
		for abilityID, data in o.IterateDB(false, false) do
			if (addToDBLookup == true) then
				dbLookup[abilityID] = data;
			end
			if (checkMaxID == true and abilityID > maxID) then
				maxID = abilityID;
			end
		end
	end
	
	local GetSpellLink = GetSpellLink;
	local SetData = o.SetData;
	local stringmatch = string.match;
	local numNew = 0;
	local numUpdated = 0;
	
	local abilityID = 1;
	local numConsecBlanks = 0;
	local lookupData, link, name, oldData, newData;
	while (numConsecBlanks ~= 500 or abilityID < maxID) do
		if (onlyNew == true) then
			lookupData = dbLookup[abilityID];
		end
		if (onlyNew == true and lookupData ~= nil) then
			numConsecBlanks = 0;
		else
			link = GetSpellLink(abilityID);
			if (link ~= nil) then
				numConsecBlanks = 0;
				name = stringmatch(link, "[^|]+|h%[(.+)%]", 19);
				if (lookupData == nil) then
					lookupData = dbLookup[abilityID];
				end
				if (lookupData ~= name) then
					oldData, newData = SetData(abilityID, name);
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
		abilityID = (abilityID + 1);
	end
	
	return numNew, numUpdated;
end



function o.BuildLink(abilityID)
	return ("spell:" .. abilityID);
end


function o.BuildChatlink(abilityID, data)
	local link;
	if (data == nil) then
		link = GetSpellLink(abilityID);
	end
	if (link == nil) then
		if (data == nil) then
			data = o.GetData(abilityID);
		end
		if (data ~= nil) then
			link = ("|cff71d5ff|Hspell:%d|h[%s]|h|r"):format(abilityID, data);
		end
	end
	return link;
end



function o.CreateMatcher(text)
	return text;
end


--[[
function o.IsDataMatch(data, matcher)
	return (data:find(matcher));
end
--]]
o.IsDataMatch = string.find;



function o.CreateSorter(indexingKey, reverse, skipEquals, accessDB)
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
				for abilityID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(abilityID)] = data;
				end
				for abilityID, data in pairs(o.errata) do
					lookup[abilityID] = data;
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




do
	local tonumber = tonumber;
	
	function o.GetData(abilityID)
		abilityID = tonumber(abilityID);
		local data = o.errata[abilityID];
		if (data == nil) then
			local startPos = o.lookupCache[abilityID];
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



function o.SetData(abilityID, newName)
	abilityID = tonumber(abilityID);
	if (abilityID == nil) then
		error("AbilityLinksDB2.SetData: abilityID is nil", 2);
	end
	
	local oldData = o.GetData(abilityID);
	local newData = newName;
	
	if (oldData ~= newData) then
		o.errata[abilityID] = newData;
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("AbilityLinksDB2_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		o.EventsManager2.DispatchCustomEvent("AbilityLinksDB2_ABILITY_NAME_CHANGED", abilityID, oldData, newData);
		return oldData, newData;
	else
		return oldData, oldData;
	end
end
