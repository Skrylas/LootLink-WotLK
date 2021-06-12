
local o = {};
LinksList_Talents = o;

o.TalentLinksDB1 = TalentLinksDB1;
o.LinksList = LinksList;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(EventsManager2);
	assert(TalentLinksDB1);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
