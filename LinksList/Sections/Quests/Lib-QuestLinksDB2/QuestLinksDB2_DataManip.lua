
local o = QuestLinksDB2; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_ChatLinksMonitor2_QUEST_LINKS_FOUND: (msg, linksArray)
-- OnEvent_QUEST_LOG_UPDATE: ()
--
-- GetDBSize: size = ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByName)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state)
	-- IterateDB_GetNextSortedPair: nextKey, nextVal = (state)
-- BuildLink: link = (questID)
-- BuildChatlink: chatlink = (questID[, data])
-- CreateMatcher: matcher = ([name][, minLevel][, maxLevel])
-- IsDataMatch: isMatch = (data, matcher)
-- CreateNameSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
-- CreateLevelSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (questID)
-- SplitData: name, level = (data)
-- GetName: name = (questID)
-- GetLevel: level = (questID)
-- SetData: oldData, newData = (questID, newName, newLevel)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.

o.activeDB = nil;
o.lookupCache = {}; -- [questID] = index to data in string table or false if missing;
-- activeDBSize = 0;
-- errata = {};




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	o.EventsManager2.RegisterForEvent(o, nil, "ChatLinksMonitor2_QUEST_LINKS_FOUND", false, false);
	o.EventsManager2.RegisterForEvent(o, nil, "QUEST_LOG_UPDATE", false, false);
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("QuestLinksDB2_DB_SIZE_CHANGED", false);
	ACE("QuestLinksDB2_QUEST_NAME_CHANGED", false);
	ACE("QuestLinksDB2_QUEST_LEVEL_CHANGED", false);
	
	local saved = QuestLinksDB2_SavedData;
	if (saved == nil) then
		saved = {
			errata = {};
		};
		QuestLinksDB2_SavedData = saved;
	end
	o.errata = saved.errata;
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local tonumber = tonumber;
	local dbLookup = {};
	local count = 0;
	for questID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
		dbLookup[tonumber(questID)] = data;
		count = (count + 1);
	end
	
	local errata = o.errata;
	local staticData;
	for questID, data in pairs(errata) do
		staticData = dbLookup[questID];
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[questID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry and the
				-- count has already been incremented by the preceding loop.
			end
		else
			-- There's no entry. Increment the count.
			count = (count + 1);
		end
	end
	
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("QuestLinksDB2_DB_SIZE_CHANGED", oldCount, count);
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local ipairs = ipairs;
	local stringmatch = string.match;
	
	function o.OnEvent_ChatLinksMonitor2_QUEST_LINKS_FOUND(msg, linksArray)
		local questID, level, name;
		for index, linkIndex in ipairs(linksArray) do
			questID, level, name = stringmatch(msg, "([^:]+):([^|]+)|h%[(.-)%]", (linkIndex + 18));
			o.SetData(questID, name, level);
		end
	end
end



function o.OnEvent_QUEST_LOG_UPDATE()
	local link, questID, level, name;
	for index = GetNumQuestLogEntries(), 1, -1 do
		link = GetQuestLink(index);
		if (link ~= nil) then
			questID, level, name = link:match("([^:]+):([^|]+)|h%[(.-)%]", 19);
			o.SetData(questID, name, level);
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
		for questID in pairs(errata) do
			sortedErrataIDs[#sortedErrataIDs + 1] = questID;
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



function o.BuildLink(questID)
	local link;
	local level = o.GetLevel(questID);
	if (level ~= nil) then
		link = ("quest:" .. questID .. ":" .. level);
	end
	return link;
end


function o.BuildChatlink(questID, data)
	local link;
	if (data == nil) then
		data = o.GetData(questID);
	end
	if (data ~= nil) then
		local name, level = o.SplitData(data);
		link = ("|cffffff00|Hquest:%d:%d|h[%s]|h|r"):format(questID, level, name);
	end
	return link;
end



function o.CreateMatcher(name, minLevel, maxLevel)
	if (name ~= nil) then
		name = tostring(name);
		if (name == "") then
			name = nil;
		end
	end
	return { name, tonumber(minLevel), tonumber(maxLevel) };
end



do
	local stringfind = string.find;
	local stringmatch = string.match;
	local tonumber = tonumber;
	
	function o.IsDataMatch(data, matcher)
		local matcherName = matcher[1];
		local level;
		if (matcherName ~= nil) then
			local name;
			name, level = stringmatch(data, "^([^\1]+)\1(.+)$");
			if (stringfind(name, matcherName) == nil) then
				return nil;
			end
		end
		
		if (matcher[2] ~= nil) then
			if (level == nil) then
				level = stringmatch(data, "\1(.+)$");
			end
			level = tonumber(level);
			if (level < matcher[2]) then
				return nil;
			end
		end
		
		if (matcher[3] ~= nil) then
			if ((level or tonumber(stringmatch(data, "\1(.+)$"))) > matcher[3]) then
				return nil;
			end
		end
		
		return true;
	end
end



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
				for questID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(questID)] = data;
				end
				for questID, data in pairs(o.errata) do
					lookup[questID] = data;
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


function o.CreateLevelSorter(indexingKey, reverse, skipEquals, accessDB)
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
		accessor = ("(cacheParent[1][" .. accessor .. "] or -2)");
	else
		accessor = ("tonumber(stringmatch(" .. accessor .. ", \"\1(.+)$\"))");
	end
	
	local sorter = assert(loadstring(
		([[
		local o, tonumber, stringmatch = ...;
		local cacheParent = setmetatable({}, {
			__index = (function(self, key)
				local lookup = {};
				for questID, data in o.STATIC_DB:gmatch("\n([^~]+)~[^\1]+\1([^\n]+)") do
					lookup[tonumber(questID)] = tonumber(data);
				end
				for questID, data in pairs(o.errata) do
					lookup[questID] = tonumber(stringmatch(data, "\1(.+)$"));
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
	))(o, tonumber, string.match);
	
	return sorter, nil;
end




do
	local tonumber = tonumber;
	
	function o.GetData(questID)
		questID = tonumber(questID);
		local data = o.errata[questID];
		if (data == nil) then
			local startPos = o.lookupCache[questID];
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


function o.SplitData(data)
	local name, level;
	if (data ~= nil) then
		name, level = data:match("^([^\1]+)\1(.+)$");
		level = tonumber(level);
	end
	return name, level;
end


function o.GetName(questID)
	local name;
	local data = o.GetData(questID);
	if (data ~= nil) then
		name = data:match("^([^\1]+)");
	end
	return name;
end


function o.GetLevel(questID)
	local level;
	local data = o.GetData(questID);
	if (data ~= nil) then
		level = tonumber(data:match("\1(.+)$"));
	end
	return level;
end



function o.SetData(questID, newName, newLevel)
	questID = tonumber(questID);
	newLevel = tonumber(newLevel);
	if (
		questID == nil
		or (newName == nil and newLevel ~= nil)
		or (newName ~= nil and newLevel == nil)
		or (newName ~= nil and newName:len() == 0)
		or (newLevel ~= nil and (newLevel < -1 or newLevel > 200))
	) then
		error(
			("QuestLinksDB2.SetData: Invalid input data (questID = %s, newName = \"%s\", newLevel = %s)."):format(
				tostring(questID), tostring(newName), tostring(newLevel)
			), 2
		);
	end
	
	local oldData = o.GetData(questID);
	local newData = nil;
	if (newName ~= nil and newLevel ~= nil) then
		newData = (newName .. "\1" .. newLevel);
	end
	
	if (oldData ~= newData) then
		o.errata[questID] = newData;
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("QuestLinksDB2_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		local oldName, oldLevel = o.SplitData(oldData);
		if (oldName ~= newName) then
			o.EventsManager2.DispatchCustomEvent("QuestLinksDB2_QUEST_NAME_CHANGED", questID, oldName, newName);
		end
		if (oldLevel ~= newLevel) then
			o.EventsManager2.DispatchCustomEvent("QuestLinksDB2_QUEST_LEVEL_CHANGED", questID, oldLevel, newLevel);
		end
		return oldData, newData;
	else
		return oldData, oldData;
	end
end
