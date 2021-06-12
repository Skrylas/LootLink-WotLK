
local o = {};
LinksList = o;

-- config = {};


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(NicheDevTools);
	assert(NicheDevTools.AddDropdownButtonWithOptionalSelf);
	assert(NicheDevTools.HideGameTooltip);
	assert(NicheDevTools.RegisterSlashCommand);
	assert(NicheDevTools.SetupElementForSimpleTooltip);
	assert(string.NicheDevTools_CaseInsensitize);
	assert(string.NicheDevTools_EscapePatterns);
	assert(table.NicheDevTools_SortByKey);
	--]]
	
	o.Config_t_Init();
	
	o.Localization = nil;
end
