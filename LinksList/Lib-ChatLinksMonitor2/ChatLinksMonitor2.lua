
local o;
do
	local VERSION = 20000;
	o = (ChatLinksMonitor2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert((EventsManager2 ~= nil), "ChatLinksMonitor2 requires EventsManager2.");
		ChatLinksMonitor2 = o;
		o.OLD_VERSION = o.VERSION;
		o.VERSION = VERSION;
	else
		return;
	end
end

o.EventsManager2 = EventsManager2;

-- t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- OnEvent_CHAT_MSG: (event, msg)

-- Store this from the previous version so we can unregister events from it.
o.old_OnEvent_CHAT_MSG = o.OnEvent_CHAT_MSG;
o.numLinksByType = (o.numLinksByType or { achievement = 0; enchant = 0; glyph = 0; item = 0; player = 0; quest = 0; spell = 0; talent = 0; });
if (o.linksByType == nil) then
	local linksByType = {};
	o.linksByType = linksByType;
	local weakMeta = { __mode = ("kv"); };
	for linkType in pairs(o.numLinksByType) do
		linksByType[linkType] = setmetatable({}, weakMeta);
	end
end




function o.t_Init()
	o.t_Init = nil;
	
	if (o.old_OnEvent_CHAT_MSG ~= nil) then
		o.EventsManager2.UnregisterForAllEvents(o.old_OnEvent_CHAT_MSG);
		o.old_OnEvent_CHAT_MSG = nil;
	end
	
	local ACE = o.EventsManager2.AddCustomEvent;
	for linkType in pairs(o.numLinksByType) do
		ACE(("ChatLinksMonitor2_" .. linkType:upper() .. "_LINKS_FOUND"), false);
	end
	
	local chatEventsToMonitor = {
		"SYSTEM", "SAY", "YELL", "LOOT", "CHANNEL", "GUILD", "OFFICER",
		"RAID", "PARTY", "WHISPER", "WHISPER_INFORM"
	};
	local RFE = o.EventsManager2.RegisterForEvent;
	local func = o.OnEvent_CHAT_MSG;
	for index, event in ipairs(chatEventsToMonitor) do
		RFE(func, nil, ("CHAT_MSG_" .. event), false, true);
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local pairs = pairs;
	local stringfind = string.find;
	
	function o.OnEvent_CHAT_MSG(event, msg)
		local startPos, endPos, linkType = stringfind(msg, "|cff%x%x%x%x%x%x|H([^:]+):[^|]+|h%[.-%]|h|r", 1);
		if (startPos ~= nil) then
			local linksByType = o.linksByType;
			local numLinksByType = o.numLinksByType;
			
			local numLinksForType;
			while (startPos ~= nil) do
				numLinksForType = numLinksByType[linkType];
				if (numLinksForType ~= nil) then
					numLinksForType = (numLinksForType + 1);
					numLinksByType[linkType] = numLinksForType;
					linksByType[linkType][numLinksForType] = startPos;
				end
				startPos, endPos, linkType = stringfind(msg, "|cff%x%x%x%x%x%x|H([^:]+):[^|]+|h%[.-%]|h|r", endPos);
			end
			
			for linkType, numLinksForType in pairs(numLinksByType) do
				if (numLinksForType ~= 0) then
					linksByType[linkType][numLinksForType + 1] = nil;
					o.EventsManager2.DispatchCustomEvent(("ChatLinksMonitor2_" .. linkType:upper() .. "_LINKS_FOUND"), msg, linksByType[linkType], event);
					numLinksByType[linkType] = 0;
				end
			end
		end
	end
end




o.t_Init();
