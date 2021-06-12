
assert(TooltipExchange, "TooltipExchange not found!")

------------------------------------------------------------------------
--	Locals
------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeOptions")
local dew = AceLibrary("Dewdrop-2.0")
local TooltipExchange = TooltipExchange

------------------------------------------------------------------------
--	Localization
------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Click to open the search frame"] = true,
	["Right-click for options"] = true,
	["Minimap icon"] = true,
	["Toggle showing the minimap icon"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Click to open the search frame"] = "클릭하면 검색창을 엽니다",
--	["Right-click for options"] = true,
--	["Minimap icon"] = true,
--	["Toggle showing the minimap icon"] = true,
} end)

------------------------------------------------------------------------
--	DataBroker Plugin
------------------------------------------------------------------------

local obj = LibStub("LibDataBroker-1.1"):NewDataObject("TooltipExchange", {
	type = "launcher",
	icon = "Interface\\Icons\\INV_Sword_62",
	label = "TooltipExchange",
})

local TooltipExchangeOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")
local icon = LibStub("LibDBIcon-1.0", true)

------------------------------------------------------------------------
--	Menu Handling
------------------------------------------------------------------------

function TooltipExchangeOptions:OnInitialize()
	if not icon then return end

	self.db = TooltipExchange:AcquireDBNamespace("Options")
	TooltipExchange:RegisterDefaults("Options", "profile", { show = true })

	icon:Register("TooltipExchange", obj, self.db.profile)

	TooltipExchange.options.args.minimap = {
		type = "toggle",
		name = L["Minimap icon"],
		desc = L["Toggle showing the minimap icon"],
		get = function() return not self.db.profile.hide end,
		set = function(v)
			if v then
				self.db.profile.hide = nil
				icon:Show("TooltipExchange")
			else
				self.db.profile.hide = true
				icon:Hide("TooltipExchange")
			end
		end,
		order = -6,
	}
	TooltipExchange.options.args.minimapSpacer = {
		type = "header",
		name = " ",
		order = -5,
	}
end

------------------------------------------------------------------------
--	Menu Methods
------------------------------------------------------------------------

local function menu()
	--Don't create a new function every time we open the menu.
	dew:FeedAceOptionsTable(TooltipExchange.options)
end

function obj.OnClick(self, button)
	if button == "RightButton" then
		dew:Open(self, "children", menu)
	else
		TooltipExchange:TriggerEvent("TooltipExchange_OpenUI")
	end
end

function obj.OnTooltipShow(tt)
	tt:AddLine("Tooltip Exchange")
	tt:AddLine(L["Click to open the search frame"], 0.2, 1, 0.2, 1)
	tt:AddLine(L["Right-click for options"], 0.2, 1, 0.2, 1)
end

------------------------------------------------------------------------