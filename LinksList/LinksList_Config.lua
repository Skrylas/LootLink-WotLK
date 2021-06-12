
local o = LinksList;

-- Config_t_Init: ()
-- Config_OnEvent_VARIABLES_LOADED: ()
-- Config_HandleSlashCmd_ToggleSection: (args)
--
-- Config_ToggleActAsPanel: (enabled)
-- Config_ToggleUseToggleButton: (enabled)
-- Config_ToggleAutoFocusQS: (enabled)

BINDING_HEADER_LINKSLIST = ("LinksList");

-- config = LinksList_Config;




function o.Config_t_Init()
	o.Config_t_Init = nil;
	
	WorldFrame.onVariablesLoadedHandlers[o.Config_OnEvent_VARIABLES_LOADED] = true;
	
	local cmds = o.Localization.SLASH_COMMANDS;
	local slashInfo = {
		[""] = o.Results_Toggle;
		[cmds.PANEL:match("^(%S+)")] = o.Config_ToggleActAsPanel;
		[cmds.TOGGLE_BUTTON:match("^(%S+)")] = o.Config_ToggleUseToggleButton;
		[cmds.AUTOFOCUS:match("^(%S+)")] = o.Config_ToggleAutoFocusQS;
		[false] = {
			[1] = cmds.UNKNOWN;
			[2] = cmds.RESULTS_TOGGLE;
			[3] = cmds.PANEL;
			[4] = cmds.TOGGLE_BUTTON;
			[5] = cmds.AUTOFOCUS;
		};
	};
	NicheDevTools.RegisterSlashCommand("LinksList", slashInfo, "/ll", "/linkslist");
end



function o.Config_OnEvent_VARIABLES_LOADED()
	o.Config_OnEvent_VARIABLES_LOADED = nil;
	
	-- This number only changes when we're changing the config.
	local VERSION = 20000;
	local config = LinksList_Config;
	if (config == nil) then
		local midX, midY = math.ceil(UIParent:GetWidth() / 2), math.ceil(UIParent:GetHeight() / 2);
		config = {
			version = VERSION;
			resultsX = midX; resultsY = midY;
			searchX = midX; searchY = midY;
			toggleX = midX; toggleY = midY;
			actAsPanel = nil;
			useToggleButton = true;
			autoFocusQS = true;
			lastViewedSection = nil;
		};
		LinksList_Config = config;
	else
		if (config.version == nil or config.version < VERSION) then
			if (config.version == nil) then
				config.actAsPanel = nil;
				config.useToggleButton = true;
				config.autoFocusQS = true;
			elseif (config.version < 120) then
				config.autoFocusQS = true;
			elseif (config.version < 130) then
				config.actAsPanel = nil;
			end
			config.version = VERSION;
		end
	end
	o.config = config;
	
	o.Config_ToggleActAsPanel((config.actAsPanel and true) or false);
	o.Config_ToggleUseToggleButton((config.useToggleButton and true) or false);
	o.Config_ToggleAutoFocusQS((config.autoFocusQS and true) or false);
	
	LinksList_ResultsFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", config.resultsX, config.resultsY);
	LinksList_SearchFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", config.searchX, config.searchY);
	LinksList_ToggleButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", config.toggleX, config.toggleY);
end




function o.Config_ToggleActAsPanel(enabled)
	if (enabled == nil) then
		enabled = (not o.config.actAsPanel);
	end
	enabled = ((enabled and true) or nil);
	o.config.actAsPanel = enabled;
	
	if (enabled == true) then
		if (UIPanelWindows["LinksList_ResultsFrame"] == nil) then
			o.Results_Toggle(false);
			UIPanelWindows["LinksList_ResultsFrame"] = { area = ("left"); pushable = 1; whileDead = true; };
			LinksList_ResultsFrame:RegisterForDrag(nil);
		end
	else
		if (UIPanelWindows["LinksList_ResultsFrame"] ~= nil) then
			o.Results_Toggle(false);
			UIPanelWindows["LinksList_ResultsFrame"] = nil;
			LinksList_ResultsFrame:RegisterForDrag("LeftButton", "RightButton");
		end
	end
end



function o.Config_ToggleUseToggleButton(enabled)
	if (enabled == nil) then
		enabled = (not o.config.useToggleButton);
	end
	enabled = ((enabled and true) or nil);
	o.config.useToggleButton = enabled;
	o.ToggleButton_Toggle(enabled or false);
end



function o.Config_ToggleAutoFocusQS(enabled)
	if (enabled == nil) then
		enabled = (not o.config.autoFocusQS);
	end
	enabled = ((enabled and true) or nil);
	o.config.autoFocusQS = enabled;
	o.QuickSearch_OnAutoFocusQSChanged(enabled);
end
