
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeOptions") 
local tablet = AceLibrary("Tablet-2.0") 

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["|cffeda55fClick|r to open search frame."] = true,
	["minimap"] = true,
	["Minimap"] = true,
	["Toggle the minimap button."] = true,
	["Hidden"] = true,
	["Shown"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["|cffeda55fClick|r to open search frame."] = "|cffeda55f클릭|r하면 검색창을 엽니다.",
	["minimap"] = "미니맵",
	["Minimap"] = "미니맵",
	["Toggle the minimap button."] = "미니맵 버튼을 토글합니다.",
	["Hidden"] = "숨기기",
	["Shown"] = "보기",
} end)

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

local deuce = TooltipExchange:NewModule("Options")
deuce.internalModule = true
deuce.consoleCmd = not FuBar and L["minimap"]
deuce.consoleOptions = not FuBar and {
	type = "toggle",
	name = L["Minimap"],
	desc = L["Toggle the minimap button."],
	get = function() return TooltipExchangeOptions.minimapFrame and TooltipExchangeOptions.minimapFrame:IsVisible() or false end,
	set = function(v) if v then TooltipExchangeOptions:Show() else TooltipExchangeOptions:Hide() end end,
	map = {[false] = L["Hidden"], [true] = L["Shown"]},
	hidden = function() return FuBar and true end,
} 

-------------------------------------------------------------------------------
-- FuBar Plugin
-------------------------------------------------------------------------------

TooltipExchangeOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
TooltipExchangeOptions.name = "FuBar - TooltipExchange"
TooltipExchangeOptions:RegisterDB("TooltipExchangeFubarDB")

TooltipExchangeOptions.hasIcon = "Interface\\Icons\\INV_Sword_62"
TooltipExchangeOptions.defaultMinimapPosition = 278
TooltipExchangeOptions.clickableTooltip = true 
TooltipExchangeOptions.cannotDetachTooltip = true
TooltipExchangeOptions.defaultPosition = "LEFT"
TooltipExchangeOptions.tooltipHiddenWhenEmpty = false
TooltipExchangeOptions.hideWithoutStandby = true
TooltipExchangeOptions.OnMenuRequest = deuce.core.options

local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(TooltipExchangeOptions)
for k, v in pairs(args) do
	if TooltipExchangeOptions.OnMenuRequest.args[k] == nil then
		TooltipExchangeOptions.OnMenuRequest.args[k] = v
	end
end

-------------------------------------------------------------------------------
-- FuBar Methods
-------------------------------------------------------------------------------

function TooltipExchangeOptions:OnClick()
	self:TriggerEvent("TooltipExchange_OpenUI")
end

function TooltipExchangeOptions:OnTooltipUpdate()
	tablet:SetHint(L["|cffeda55fClick|r to open search frame."])
end
