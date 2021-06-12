
local o;
do
	local VERSION = 20400;
	o = (AbilityLinksDB2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(ChatLinksMonitor2, "AbilityLinksDB2 requires ChatLinksMonitor2.");
		assert(EventsManager2, "AbilityLinksDB2 requires EventsManager2.");
		assert(table.NicheDevTools_SortByLookup, "AbilityLinksDB2 requires table.NicheDevTools_SortByLookup.");
		AbilityLinksDB2 = o;
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
	
	local success, reason = LoadAddOn("Lib-AbilityLinksDB2_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("AbilityLinksDB2: Failed to load saved variables stub Lib-AbilityLinksDB2_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata and configurations cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
