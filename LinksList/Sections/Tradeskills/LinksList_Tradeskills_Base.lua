
local o = {};
LinksList_Tradeskills = o;

o.TradeskillLinksDB3 = TradeskillLinksDB3;
o.LinksList = LinksList;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(EventsManager2);
	assert(TradeskillLinksDB3);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
