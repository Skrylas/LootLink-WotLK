
local o = TradeskillLinksDB3; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_ChatLinksMonitor2_ENCHANT_LINKS_FOUND: (msg, linksArray)
-- OnEvent_TRADE_SKILL_UPDATE: ()
--
-- GetDBSize: size = ()
-- IterateDB: iterator, state, start = (keysOnly, sortedByName)
	-- IterateDB_GetNextPair: nextKey, nextVal = (state)
	-- IterateDB_GetNextSortedPair: nextKey, nextVal = (state)
-- BuildLink: link = (tsID)
-- BuildChatlink: chatlink = (tsID[, data])
-- CreateMatcher: matcher = ([tsPrefix][, text])
-- IsDataMatch: isMatch = (data, matcher)
-- CreateSorter: sorter, identicalTo = ([indexingKey][, reverse][, skipEquals][, accessDB])
--
-- GetData: data = (tsID)
-- SetData: oldData, newData = (tsID, newName)

-- STATIC_DB = (""); -- Populated from DefaultDatabase file.
o.TRADESKILL_TYPE_PREFIXES = o.Localization.TRADESKILL_TYPE_PREFIXES;
o.NUMBERS_TO_PREFIXES = {
	["1"] = o.TRADESKILL_TYPE_PREFIXES.ALCHEMY;
	["2"] = o.TRADESKILL_TYPE_PREFIXES.BLACKSMITHING;
	["3"] = o.TRADESKILL_TYPE_PREFIXES.COOKING;
	["4"] = o.TRADESKILL_TYPE_PREFIXES.ENCHANTING;
	["5"] = o.TRADESKILL_TYPE_PREFIXES.ENGINEERING;
	["6"] = o.TRADESKILL_TYPE_PREFIXES.FIRST_AID;
	["7"] = o.TRADESKILL_TYPE_PREFIXES.INSCRIPTION;
	["8"] = o.TRADESKILL_TYPE_PREFIXES.JEWELCRAFTING;
	["9"] = o.TRADESKILL_TYPE_PREFIXES.LEATHERWORKING;
	["A"] = o.TRADESKILL_TYPE_PREFIXES.MINING;
	["B"] = o.TRADESKILL_TYPE_PREFIXES.TAILORING;
};

o.activeDB = nil;
o.lookupCache = {}; -- [tsID] = index to data in string table or false if missing;
-- activeDBSize = 0;
-- errata = {};




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;
	
	o.EventsManager2.RegisterForEvent(o, nil, "ChatLinksMonitor2_ENCHANT_LINKS_FOUND", false, false);
	o.EventsManager2.RegisterForEvent(o, nil, "TRADE_SKILL_UPDATE", false, false);
	o.EventsManager2.UnregisterForEvent(o, "TRADE_SKILL_SHOW");
	
	local ACE = o.EventsManager2.AddCustomEvent;
	ACE("TradeskillLinksDB3_DB_SIZE_CHANGED", false);
	ACE("TradeskillLinksDB3_ENTRY_NAME_CHANGED", false);
	
	local VERSION = 30300;
	local saved = TradeskillLinksDB3_SavedData;
	if (saved == nil) then
		saved = {
			version = VERSION;
			errata = {};
		};
		TradeskillLinksDB3_SavedData = saved;
	else
		if ((saved.version or 0) < VERSION) then
			if (saved.version == nil) then
				local next = next;
				local NUMBERS_TO_PREFIXES = o.NUMBERS_TO_PREFIXES;
				local errata = saved.errata;
				local number, prefix;
				for tsID, name in pairs(errata) do
					number, prefix = next(NUMBERS_TO_PREFIXES);
					while (number ~= nil and name ~= nil) do
						if (name:sub(1, #prefix) == prefix) then
							errata[tsID] = (number .. name:sub((#prefix + 1), -1));
							name = nil;
						else
							number, prefix = next(NUMBERS_TO_PREFIXES, number);
						end
					end
					if (name ~= nil) then
						errata[tsID] = nil;
					end
				end
			end
			saved.version = VERSION;
		end
	end
	o.errata = saved.errata;
	
	-- We could pretty easily merge the errata into the static DB right now with string.gsub,
	-- but there's not really a point. All subsequent operations of the library are going to have
	-- to check the errata regardless, since it's impractical to do this merger for every errata
	-- found after loading (too much memory wasted from the junked megastrings).
	
	local tonumber = tonumber;
	local dbLookup = {};
	local count = 0;
	for tsID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
		dbLookup[tonumber(tsID)] = data;
		count = (count + 1);
	end
	
	local errata = o.errata;
	local staticData;
	for tsID, data in pairs(errata) do
		staticData = dbLookup[tsID];
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[tsID] = nil;
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
		o.EventsManager2.DispatchCustomEvent("TradeskillLinksDB3_DB_SIZE_CHANGED", oldCount, count);
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local ipairs = ipairs;
	local stringmatch = string.match;
	
	function o.OnEvent_ChatLinksMonitor2_ENCHANT_LINKS_FOUND(msg, linksArray)
		for index, linkIndex in ipairs(linksArray) do
			o.SetData(stringmatch(msg, "([^|]+)|h%[(.-)%]", (linkIndex + 20)));
		end
	end
end



function o.OnEvent_TRADE_SKILL_UPDATE()
	local link;
	for index = 1, GetNumTradeSkills(), 1 do
		link = GetTradeSkillRecipeLink(index);
		if (link ~= nil) then
			o.SetData(link:match("([^|]+)|h%[(.-)%]", 21));
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
		for tsID in pairs(errata) do
			sortedErrataIDs[#sortedErrataIDs + 1] = tsID;
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
		if (nextVal ~= nil) then
			nextVal = ((o.NUMBERS_TO_PREFIXES[stringsub(nextVal, 1, 1)] or "") .. stringsub(nextVal, 2, -1));
		end
		return nextKey, nextVal;
	end
end


do
	local tonumber = tonumber;
	local stringmatch = string.match;
	local stringsub = string.sub;
	
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
			if (nextVal ~= nil) then
				nextVal = ((o.NUMBERS_TO_PREFIXES[stringsub(nextVal, 1, 1)] or "") .. stringsub(nextVal, 2, -1));
			end
			return nextKey, nextVal;
		end
	end
end



function o.BuildLink(tsID)
	return ("enchant:" .. tsID);
end


function o.BuildChatlink(tsID, data)
	local link;
	if (data == nil) then
		data = o.GetData(tsID);
	end
	if (data ~= nil) then
		link = ("|cffffd000|H%s|h[%s]|h|r"):format(o.BuildLink(tsID), data);
	end
	return link;
end



function o.CreateMatcher(tsPrefix, text)
	local matchString;
	if (text == nil or text == "") then
		if (tsPrefix ~= nil and tsPrefix ~= "") then
			matchString = ("^" .. tsPrefix);
		else
			matchString = ("");
		end
	else
		if (text:sub(1, 1) == "^") then
			matchString = ("^" .. (tsPrefix or "") .. text:sub(2, -1));
		else
			matchString = (((tsPrefix ~= nil and ("^" .. tsPrefix .. ".*")) or "") .. text);
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
				for tsID, data in o.STATIC_DB:gmatch("\n([^~]+)~([^\n]+)") do
					lookup[tonumber(tsID)] = data;
				end
				for tsID, data in pairs(o.errata) do
					lookup[tsID] = data;
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
	local stringsub = string.sub;
	
	function o.GetData(tsID)
		tsID = tonumber(tsID);
		local data = o.errata[tsID];
		if (data == nil) then
			local startPos = o.lookupCache[tsID];
			if (startPos ~= false) then
				data = o.STATIC_DB:match("[^\n]+", startPos);
			end
		end
		if (data ~= nil) then
			data = ((o.NUMBERS_TO_PREFIXES[stringsub(data, 1, 1)] or "") .. stringsub(data, 2, -1));
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



function o.SetData(tsID, newName)
	tsID = tonumber(tsID);
	if (tsID == nil) then
		error("TradeskillLinksDB3.SetData: tsID is nil", 2);
	end
	
	local oldData = o.GetData(tsID);
	local newData = newName;
	
	if (oldData ~= newData) then
		if (newData ~= nil) then
			local compacted = nil;
			local next = next;
			local NUMBERS_TO_PREFIXES = o.NUMBERS_TO_PREFIXES;
			local number, prefix = next(NUMBERS_TO_PREFIXES);
			while (number ~= nil and compacted == nil) do
				if (newName:sub(1, #prefix) == prefix) then
					compacted = (number .. newName:sub((#prefix + 1), -1));
				else
					number, prefix = next(NUMBERS_TO_PREFIXES, number);
				end
			end
			o.errata[tsID] = compacted;
			if (compacted == nil) then
				if (oldData == nil) then
					return oldData, oldData;
				else
					newData = nil;
				end
			end
		end
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("TradeskillLinksDB3_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		o.EventsManager2.DispatchCustomEvent("TradeskillLinksDB3_ENTRY_NAME_CHANGED", tsID, oldData, newData);
		return oldData, newData;
	else
		return oldData, oldData;
	end
end
