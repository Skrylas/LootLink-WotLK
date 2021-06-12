
local o;
do
	local VERSION = 20200;
	o = (QuestLinksDB2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(ChatLinksMonitor2, "QuestLinksDB2 requires ChatLinksMonitor2.");
		assert(EventsManager2, "QuestLinksDB2 requires EventsManager2.");
		assert(table.NicheDevTools_SortByLookup, "QuestLinksDB2 requires table.NicheDevTools_SortByLookup.");
		QuestLinksDB2 = o;
		o.OLD_VERSION = o.VERSION;
		o.VERSION = VERSION;
		o.SHOULD_LOAD = true;
	else
		return;
	end
end

o.EventsManager2 = EventsManager2;


function o.t_Init()
	o.t_Init = nil;
	
	local success, reason = LoadAddOn("Lib-QuestLinksDB2_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("QuestLinksDB2: Failed to load saved variables stub Lib-QuestLinksDB2_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
