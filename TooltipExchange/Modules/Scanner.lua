
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeScanner")

local slots = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"RangedSlot",
}

local inventoryBags = { 0, 1, 2, 3, 4 }
local bankBags = { BANK_CONTAINER, 5, 6, 7, 8, 9, 10 }

local sourceSettings = {
	scanChat = {
		{ event = "CHAT_MSG_GUILD", handler = "ChatEvent" },
		{ event = "CHAT_MSG_PARTY", handler = "ChatEvent" },
		{ event = "CHAT_MSG_RAID", handler = "ChatEvent" },
		{ event = "CHAT_MSG_SAY", handler = "ChatEvent" },
		{ event = "CHAT_MSG_WHISPER", handler = "ChatEvent" },
		{ event = "CHAT_MSG_CHANNEL", handler = "ChatEvent" },
	},
	scanLoot = { { event = "CHAT_MSG_LOOT" } },
	scanTarget = { { event = "PLAYER_TARGET_CHANGED" } },
	scanInventory = { { event = "UNIT_INVENTORY_CHANGED", bucket = 15 } },
	scanBank = { { event = "BANKFRAME_OPENED" } },
	scanAuction = { { event = "AUCTION_ITEM_LIST_UPDATE" } },
	scanMerchant = {
		{ event = "MERCHANT_SHOW", handler = "MerchantEvent" },
		{ event = "MERCHANT_UPDATE", handler = "MerchantEvent" },
	},
}

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Auction"] = true,
	["Bank"] = true,
	["Chat"] = true,
	["Enables or disables auction house scans."] = true,
	["Enables or disables loot message scans."] = true,
	["Enables or disables player bank scans."] = true,
	["Enables or disables player inventory scans."] = true,
	["Enables or disables public chat scans."] = true,
	["Enables or disables target player scans."] = true,
	["Enables or disables merchant scans."] = true,
	["Inventory"] = true,
	["Item scan sources."] = true,
	["Loot"] = true,
	["Merchant"] = true,
	["Scanner"] = true,
	["Sources"] = true,
	["Suspend in Combat"] = true,
	["Target"] = true,
	["Toggle suspending scanner while being in combat."] = true,
	["Mine Links"] = true,
	["Makes sure item links seen in chat get downloaded to local item cache."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Auction"] = "경매",
	["Bank"] = "은행",
	["Chat"] = "대화창",
	["Enables or disables auction house scans."] = "경매창에서 수집을 토글합니다.",
	["Enables or disables loot message scans."] = "룻 메시지에서 수집을 토글합니다.",
	["Enables or disables player bank scans."] = "은행 아이템의 수집을 토글합니다.",
	["Enables or disables player inventory scans."] = "가방 아이템의 수집을 토글합니다.",
	["Enables or disables public chat scans."] = "대화창의 링크에서 수집을 토글합니다.",
	["Enables or disables target player scans."] = "대상에서의 수집을 토글합니다.",
	["Enables or disables merchant scans."] = "Enables or disables merchant scans.",
	["Inventory"] = "가방",
	["Item scan sources."] = "검색 아이템",
	["Loot"] = "아이템 획득",
	["Merchant"] = "Merchant",
	["Scanner"] = "아이템 수집",
	["Sources"] = "수집 대상",
	["Suspend in Combat"] = "전투시 중지",
	["Target"] = "대상",
	["Toggle suspending scanner while being in combat."] = "전투중에는 아이템을 수집하지 않습니다.",
	["Mine Links"] = "Mine Links",
	["Makes sure item links seen in chat get downloaded to local item cache."] = "Makes sure item links seen in chat get downloaded to local item cache.",
} end)

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

TooltipExchangeScanner = TooltipExchange:NewModule(L["Scanner"])

TooltipExchangeScanner.defaults = {
	scanChat = true,
	scanLoot = true,
	scanTarget = false,
	scanInventory = false,
	scanBank = false,
	scanAuction = false,
	scanMerchant = false,
	combatSuspend = true,
	mineLinks = true,
}

TooltipExchangeScanner.options = {
	sources = {
		type = "group",
		name = L["Sources"],
		desc = L["Item scan sources."],
		order = 100,
		args = {
			sourcesHeader = {
				type = "header",
				name = L["Sources"],
				order = 1,
			},
			chat = {
				type = "toggle",
				name = L["Chat"],
				desc = L["Enables or disables public chat scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanChat") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanChat", v) end,
			},
			loot = {
				type = "toggle",
				name = L["Loot"],
				desc = L["Enables or disables loot message scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanLoot") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanLoot", v) end,
			},
			target = {
				type = "toggle",
				name = L["Target"],
				desc = L["Enables or disables target player scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanTarget") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanTarget", v) end,
			},
			inventory = {
				type = "toggle",
				name = L["Inventory"],
				desc = L["Enables or disables player inventory scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanInventory") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanInventory", v) end,
			},
			bank = {
				type = "toggle",
				name = L["Bank"],
				desc = L["Enables or disables player bank scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanBank") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanBank", v) end,
			},
			auction = {
				type = "toggle",
				name = L["Auction"],
				desc = L["Enables or disables auction house scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanAuction") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanAuction", v) end,
			},
			target = {
				type = "toggle",
				name = L["Merchant"],
				desc = L["Enables or disables merchant scans."],
				get = function() return TooltipExchangeScanner:ToggleSource("scanMerchant") end,
				set = function(v) TooltipExchangeScanner:ToggleSource("scanMerchant", v) end,
			},
		},
	},
	mineLinks = {
		type = "toggle",
		name = L["Mine Links"],
		desc = L["Makes sure item links seen in chat get downloaded to local item cache."],
		get = function() return TooltipExchangeScanner.db.profile.mineLinks end,
		set = function(v) TooltipExchangeScanner.db.profile.mineLinks = v end,
		order = 110,
	},
	combatSuspend = {
		type = "toggle",
		name = L["Suspend in Combat"],
		desc = L["Toggle suspending scanner while being in combat."],
		get = function() return TooltipExchangeScanner.db.profile.combatSuspend end,
		set = function(v) TooltipExchangeScanner.db.profile.combatSuspend = v end,
		order = 120,
	},
}

TooltipExchangeScanner.revision = tonumber(string.sub("$Revision: 29951 $", 12, -3))

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangeScanner:OnInitialize()

end

function TooltipExchangeScanner:OnEnable()
	self:SetupEvents()
end

function TooltipExchangeScanner:OnDisable()

end

function TooltipExchangeScanner:ToggleSource(source, value)
	if type(value) == "nil" then
		return self.db.profile[source]
	end

	self.db.profile[source] = value
	self:SetupEvents()
end

function TooltipExchangeScanner:SetupEvents()
	if not self:Enabled() then return end

	self:UnregisterAllBucketEvents()
	self:UnregisterAllEvents()

	for k, v in pairs(sourceSettings) do
		if self.db.profile[k] then
			for _, e in pairs(v) do
				if e.bucket then
					self:RegisterBucketEvent(e.event, e.bucket, e.handler)
				else
					self:RegisterEvent(e.event, e.handler)
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

function TooltipExchangeScanner:ChatEvent(message)
	if self:InCombat() and self.db.profile.combatSuspend then
		return
	end

	for link in string.gmatch(message, "|c%x+|Hitem:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r") do
		self:ParseLink(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
	end
end

function TooltipExchangeScanner:CHAT_MSG_LOOT(message)
	if self:InCombat() and self.db.profile.combatSuspend then
		return
	end

	self:ParseLink(message, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
end

function TooltipExchangeScanner:PLAYER_TARGET_CHANGED()
	if self:InCombat() and self.db.profile.combatSuspend then
		return
	end

	if not UnitIsUnit("target", "player") and UnitIsPlayer("target") and UnitIsFriend("target", "player") and CheckInteractDistance("target", 1) then
		self:InspectUnit("target")
	end
end

function TooltipExchangeScanner:UNIT_INVENTORY_CHANGED(units)
	if self:InCombat() and self.db.profile.combatSuspend then
		return
	end

	for unit in pairs(units) do
		if unit == "player" then
			self:InspectUnit("player")
			self:ScanContainers(inventoryBags)
			break
		end
	end
end

function TooltipExchangeScanner:BANKFRAME_OPENED()
	self:ScanContainers(bankBags)
end

function TooltipExchangeScanner:AUCTION_ITEM_LIST_UPDATE()
	self:ScanAuctions()
end

function TooltipExchangeScanner:MerchantEvent()
	self:ScanMerchant()
end

-------------------------------------------------------------------------------
-- Misc
-------------------------------------------------------------------------------

function TooltipExchangeScanner:ParseLink(link, pattern)
	local _, _, itemID = string.find(link, pattern)

	if itemID and tonumber(itemID) then
		if GetItemInfo(itemID) then
			self:TriggerEvent("TooltipExchange_ItemSeen", tonumber(itemID))
		elseif self.db.profile.mineLinks then
			self.core:Debug("M", link)

			SetItemRef(string.format("item:%d", itemID))
			ItemRefTooltip:Hide()

			self:ScheduleEvent(function()
				self:TriggerEvent("TooltipExchange_ItemSeen", tonumber(itemID))
			end, 1)
		end
	end
end

function TooltipExchangeScanner:InspectSlot(unit, slot)
	local link = GetInventoryItemLink(unit, slot)

	if link then
		self:ParseLink(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
	end
end

function TooltipExchangeScanner:InspectUnit(unit)
	for i = 1, #(slots), 1 do
		self:InspectSlot(unit, GetInventorySlotInfo(slots[i]))
	end
end

function TooltipExchangeScanner:ScanContainers(bags)
	for i = 1, getn(bags) do
		local n = GetContainerNumSlots(bags[i])

		if n then
			for j = 1, n do
				local link = GetContainerItemLink(bags[i], j)

				if link then
					self:ParseLink(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
				end
			end
		end
	end
end

function TooltipExchangeScanner:ScanAuctions()
	local n = GetNumAuctionItems("list")

	if n then
		for j = 1, n do
			local link = GetAuctionItemLink("list", j)

			if link then
				self:ParseLink(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
			end
		end
	end
end

function TooltipExchangeScanner:ScanMerchant()
	local n = GetMerchantNumItems()

	if n then
		for j = 1, n do
			local link = GetMerchantItemLink(j)

			if link then
				self:ParseLink(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")
			end
		end
	end
end
