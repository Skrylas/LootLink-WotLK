
local o = {};
LinksList_Items_BasicInfo = o;

o.ItemBasicInfoDB3 = ItemBasicInfoDB3;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(ItemBasicInfoDB3);
	--]]
	
	o.Plugin_t_Init();
	
	o.Localization = nil;
end
