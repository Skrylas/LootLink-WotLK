
local o = {};
LinksList_Abilities = o;

o.AbilityLinksDB2 = AbilityLinksDB2;
o.LinksList = LinksList;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(EventsManager2);
	assert(AbilityLinksDB2);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
