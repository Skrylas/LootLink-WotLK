
local o;
do
	local VERSION = 30301;
	o = (TradeskillLinksDB3 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(ChatLinksMonitor2, "TradeskillLinksDB3 requires ChatLinksMonitor2.");
		assert(EventsManager2, "TradeskillLinksDB3 requires EventsManager2.");
		assert(table.NicheDevTools_SortByLookup, "TradeskillLinksDB3 requires table.NicheDevTools_SortByLookup.");
		TradeskillLinksDB3 = o;
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
	
	local success, reason = LoadAddOn("Lib-TradeskillLinksDB3_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.Localization = nil;
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("TradeskillLinksDB3: Failed to load saved variables stub Lib-TradeskillLinksDB3_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
