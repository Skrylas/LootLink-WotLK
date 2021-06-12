
local o = {};
LinksList_Items = o;

o.ItemLinksDB3 = ItemLinksDB3;
o.LinksList = LinksList;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(EventsManager2);
	assert(ItemLinksDB3);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
