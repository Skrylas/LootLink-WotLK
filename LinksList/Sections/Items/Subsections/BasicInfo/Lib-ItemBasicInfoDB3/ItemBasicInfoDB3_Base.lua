
local o;
do
	local VERSION = 30102;
	o = (ItemBasicInfoDB3 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(EventsManager2, "ItemLinksDB3 requires EventsManager2.");
		ItemBasicInfoDB3 = o;
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
	
	local success, reason = LoadAddOn("Lib-ItemBasicInfoDB3_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.Localization = nil;
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("ItemBasicInfoDB3: Failed to load saved variables stub Lib-ItemBasicInfoDB3_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata and configurations cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
