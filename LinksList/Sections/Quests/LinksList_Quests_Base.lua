
local o = {};
LinksList_Quests = o;

o.QuestLinksDB2 = QuestLinksDB2;
o.LinksList = LinksList;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(EventsManager2);
	assert(QuestLinksDB2);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
