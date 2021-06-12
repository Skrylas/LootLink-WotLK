
local o;
do
	local VERSION = 10201;
	o = (TalentLinksDB1 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(ChatLinksMonitor2, "TalentLinksDB1 requires ChatLinksMonitor2.");
		assert(EventsManager2, "TalentLinksDB1 requires EventsManager2.");
		assert(table.NicheDevTools_SortByLookup, "TalentLinksDB1 requires table.NicheDevTools_SortByLookup.");
		TalentLinksDB1 = o;
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
	
	local success, reason = LoadAddOn("Lib-TalentLinksDB1_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("TalentLinksDB1: Failed to load saved variables stub Lib-TalentLinksDB1_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
