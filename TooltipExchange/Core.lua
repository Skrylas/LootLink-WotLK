
-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchange")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")
local storage = AceLibrary("ItemStorage-1.0")

local DATABASE_VERSION = 6
local MAX_ITEMID = 50000

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Options for Database module."] = true,
	["Close window"] = true,
	["Closes the statistics."] = true,
	["Count"] = true,
	["Database Statistics"] = true,
	["Database"] = true,
	["Do It Baby!"] = true,
	["Does it baby!"] = true,
	["Enable or disable this module."] = true,
	["Enabled"] = true,
	["Internal Stat"] = true,
	["Invalid"] = true,
	["Item Count"] = true,
	["Item rarity level that the mod should be interested in. Items below rarity level wont be stored, nor found via search.\n\nSetting rarity at the higher level removes items from database that are below threshold."] = true,
	["Memory Usage Estimation"] = true,
	["Mine all invalid items in database.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"] = true,
	["Mine Cache"] = true,
	["Mine Invalid"] = true,
	["Mine Item"] = true,
	["Mines local client item cache for all valid items and adds them to item database.\n|cff00ff00Perfectly safe|r"] = true,
	["Mines specific item by item ID. Remember only items valid on current server may be mined this way.\n|cffff0000MAY CAUSE DISCONNECT|r"] = true,
	["Options for %s module."] = true,
	["Patterned Lines"] = true,
	["Patterns Count"] = true,
	["Patterns Length"] = true,
	["Prints database statistics."] = true,
	["Purge"] = true,
	["Rarity"] = true,
	["Removes all items from database. Be sure you really want to do it."] = true,
	["Database Statistics"] = "Database Statistics",
	["Toggle Tooltip Exchange"] = true,
	["Tooltip Exchange"] = true,
	["Unpatterned Length"] = true,
	["Unpatterned Lines"] = true,
	["Update Cache"] = true,
	["Updates all items in database, from valid items stored in local client cache.\n|cff00ff00Perfectly safe|r"] = true,
	["Valid"] = true,
	["Item Packs"] = true,
	["Load on demand item pack list."] = true,
	["|cffffffffVersion %d|r"] = true,
	["|cffff0000Injected|r"] = true,
	["|cff00ff00Up to date|r"] = true,
	["Refresh"] = true,
	["Re-injects all items from given item pack into database. Usefull after purging database when already current version of item pack was integrated into it."] = true,
	["Show Invalid"] = true,
	["Places all invalid items in results window."] = true,
	["Cache Statistics"] = true,
	["Prints game item cache statistics."] = true,
	["Auto Mine"] = true,
	["Set under what conditions you wish to perform automatic item cache mining."] = true,
	["Taxi"] = true,
	["Toggles automatic mining after getting on taxi."] = true,
	["Mine Results"] = true,
	["Mine all invalid items in results pane.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Options for Database module."] = "데이터베이스 모듈 설정",
	["Close window"] = "닫기",
	["Closes the statistics."] = "통계창을 닫습니다.",
	["Count"] = "갯수",
	["Database Statistics"] = "데이터베이스 통계",
	["Database"] = "데이터베이스",
	["Do It Baby!"] = "Do It Baby!",
	["Does it baby!"] = "Does it baby!",
	["Enable or disable this module."] = "이 모듈을 토글합니다.",
	["Enabled"] = "사용",
	["Internal Stat"] = "내부 통계",
	["Invalid"] = "오류",
	["Item Count"] = "아이템 갯수",
	["Item rarity level that the mod should be interested in. Items below rarity level wont be stored, nor found via search.\n\nSetting rarity at the higher level removes items from database that are below threshold."] = "저장하려는 아이템의 최소등급을 설정합니다. 해당 등급 이하의 아이템은 수집하지 않으며, 검색도 불가능합니다.",
	["Memory Usage Estimation"] = "메모리 점유율",
	["Mine all invalid items in database.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"] = "데이터베이스의 모든 아이템(오류 아이템 포함)을 수집합니다. 게임이 강제 종료될 수 있습니다.",
	["Mine Cache"] = "아이템 수집",
	["Mine Invalid"] = "오류아이템 수집",
	["Mine Item"] = "아이템ID 수집",
	["Mines local client item cache for all valid items and adds them to item database.\n|cff00ff00Perfectly safe|r"] = "캐쉬로부터 아이템 정보를 수집합니다.",
	["Mines specific item by item ID. Remember only items valid on current server may be mined this way.\n|cffff0000MAY CAUSE DISCONNECT|r"] = "아이템ID를 직접 입력하여 아이템정보를 수집합니다. 서버에 없는 아이템일 경우 게임이 종료될 수도 있습니다.",
	["Options for %s module."] = "%s 모듈의 설정",
	["Patterned Lines"] = "Patterned Lines",
	["Patterns Count"] = "Patterns Count",
	["Patterns Length"] = "Patterns Length",
	["Prints database statistics."] = "통계데이터를 봅니다.",
	["Purge"] = "데이터 삭제",
	["Rarity"] = "등급",
	["Removes all items from database. Be sure you really want to do it."] = "데이터베이스의 모든 아이템을 제거합니다. 정말로 당신은 제거하시겠습니까.",
	["Database Statistics"] ="Database Statistics",
	["Toggle Tooltip Exchange"] = "Tooltip Exchange 전환",
	["Tooltip Exchange"] = "Tooltip Exchange",
	["Unpatterned Length"] = "Unpatterned Length",
	["Unpatterned Lines"] = "Unpatterned Lines",
	["Update Cache"] = "캐쉬 업데이트",
	["Updates all items in database, from valid items stored in local client cache.\n|cff00ff00Perfectly safe|r"] = "데이터베이스에서 아이템정보를 업데이트 합니다. 캐쉬데이터에 올바른 아이템만 저장됩니다.",
	["Valid"] = "정상",
	["Item Packs"] = "Item Packs",
	["Load on demand item pack list."] = "Load on demand item pack list.",
	["|cffffffffVersion %d|r"] = "|cffffffffVersion %d|r",
	["|cffff0000Injected|r"] = "|cffff0000Injected|r",
	["|cff00ff00Up to date|r"] = "|cff00ff00Up to date|r",
	["Refresh"] = "Refresh",
	["Re-injects all items from given item pack into database. Usefull after purging database when already current version of item pack was integrated into it."] = "Re-injects all items from given item pack into database. Usefull after purging database when already current version of item pack was integrated into it.",
	["Show Invalid"] = "Show Invalid",
	["Places all invalid items in results window."] = "Places all invalid items in results window.",
	["Cache Statistics"] = "Cache Statistics",
	["Prints game item cache statistics."] = "Prints game item cache statistics.",
	["Auto Mine"] = "Auto Mine",
	["Set under what conditions you wish to perform automatic item cache mining."] = "Set under what conditions you wish to perform automatic item cache mining.",
	["Taxi"] = "Taxi",
	["Toggles automatic mining after getting on taxi."] = "Toggles automatic mining after getting on taxi.",
	["Mine Results"] = "Mine Results",
	["Mine all invalid items in results pane.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"] = "Mine all invalid items in results pane.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r",
} end)

-------------------------------------------------------------------------------
-- Bindings
-------------------------------------------------------------------------------

BINDING_HEADER_TOOLTIPEXCHANGE = L["Tooltip Exchange"]
BINDING_NAME_TOOLTIPEXCHANGE_TOGGLE = L["Toggle Tooltip Exchange"]

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

TooltipExchange = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0", "AceEvent-2.0", "AceModuleCore-2.0")

TooltipExchange.defaults = {
	rarity = 3,
	itemPacks = {},
	autoMine = {
		taxi = true,
	},
}

TooltipExchange.options = {
	type = "group",
	args = {
		spacerTop = {
			type = "header",
			order = 100,
			name = " ",
		},
		database = {
			type = "group",
			name = L["Database"],
			desc = L["Options for Database module."],
			order = 200,
			args = {
				moduleHeader = {
					type = "header",
					name = L["Database"],
					order = 1,
				},
				rarity = {
					type = "text",
					name = L["Rarity"],
					desc = L["Item rarity level that the mod should be interested in. Items below rarity level wont be stored, nor found via search.\n\nSetting rarity at the higher level removes items from database that are below threshold."],
					get = function() return tostring(TooltipExchange:ToggleRarity()) end,
					set = function(v) TooltipExchange:ToggleRarity(tonumber(v)) end,
					validate = {
						["0"] = "0. " .. ITEM_QUALITY_COLORS[0].hex .. _G["ITEM_QUALITY" .. 0 .. "_DESC"] .. "|r",
						["1"] = "1. " .. ITEM_QUALITY_COLORS[1].hex .. _G["ITEM_QUALITY" .. 1 .. "_DESC"] .. "|r",
						["2"] = "2. " .. ITEM_QUALITY_COLORS[2].hex .. _G["ITEM_QUALITY" .. 2 .. "_DESC"] .. "|r",
						["3"] = "3. " .. ITEM_QUALITY_COLORS[3].hex .. _G["ITEM_QUALITY" .. 3 .. "_DESC"] .. "|r",
						["4"] = "4. " .. ITEM_QUALITY_COLORS[4].hex .. _G["ITEM_QUALITY" .. 4 .. "_DESC"] .. "|r",
						["5"] = "5. " .. ITEM_QUALITY_COLORS[5].hex .. _G["ITEM_QUALITY" .. 5 .. "_DESC"] .. "|r",
						["6"] = "6. " .. ITEM_QUALITY_COLORS[6].hex .. _G["ITEM_QUALITY" .. 6 .. "_DESC"] .. "|r",
					},
					order = 2,
				},
				autoMine = {
					type = "group",
					name = L["Auto Mine"],
					desc = L["Set under what conditions you wish to perform automatic item cache mining."],
					order = 3,
					args = {
						taxi = {
							type = "toggle",
							name = L["Taxi"],
							desc = L["Toggles automatic mining after getting on taxi."],
							get = function() return TooltipExchange.db.profile.autoMine.taxi end,
							set = function(v) TooltipExchange.db.profile.autoMine.taxi = v end,
							order = 1,
						},
					},
				},
				mineCache = {
					type = "execute",
					name = L["Mine Cache"],
					desc = L["Mines local client item cache for all valid items and adds them to item database.\n|cff00ff00Perfectly safe|r"],
					func = "MineCache",
					order = 4,
				},
				updateCache = {
					type = "execute",
					name = L["Update Cache"],
					desc = L["Updates all items in database, from valid items stored in local client cache.\n|cff00ff00Perfectly safe|r"],
					func = "UpdateCache",
					order = 5,
				},
				mineItem = {
					type = "text",
					name = L["Mine Item"],
					desc = L["Mines specific item by item ID. Remember only items valid on current server may be mined this way.\n|cffff0000MAY CAUSE DISCONNECT|r"],
					usage = "<itemID>",
					get = false,
					set = function(v) TooltipExchange:MineItem(tonumber(v)) end,
					validate = function(v) return string.find(v, "^%d+$") and true or false end,
					order = 6,
				},
				mineInvalid = {
					type = "execute",
					name = L["Mine Invalid"],
					desc = L["Mine all invalid items in database.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"],
					func = "MineInvalid",
					order = 7,
				},
				mineResults = {
					type = "execute",
					name = L["Mine Results"],
					desc = L["Mine all invalid items in results pane.\n|cffff0000ALMOST ALWAYS CAUSES DISCONNECT. USE WITH EXTREME CAUTION!|r"],
					func = "MineResults",
					order = 8,
				},
				purge = {
					type = "group",
					name = L["Purge"],
					desc = L["Removes all items from database. Be sure you really want to do it."],
					order = 9,
					args = {
						doit = {
							type = "execute",
							name = L["Do It Baby!"],
							desc = L["Does it baby!"],
							func = "PurgeItems",
							order = 100,
						}
					},
				},
				databaseStat = {
					type = "execute",
					name = L["Database Statistics"],
					desc = L["Prints database statistics."],
					func = function() TooltipExchange:DatabaseStatistics() dewdrop:Close() end,
					order = -3,
				},
				cacheStat = {
					type = "execute",
					name = L["Cache Statistics"],
					desc = L["Prints game item cache statistics."],
					func = function() TooltipExchange:CacheStatistics() dewdrop:Close() end,
					order = -2,
				},
				showInvalid = {
					type = "execute",
					name = L["Show Invalid"],
					desc = L["Places all invalid items in results window."],
					func = function() TooltipExchange:ShowInvalid() dewdrop:Close() end,
					order = -1,
				},
			},
		},
		itemPacks = {
			type = "group",
			name = L["Item Packs"],
			desc = L["Load on demand item pack list."],
			args = {
				header = {
					type = "header",
					name = L["Item Packs"],
					order = 1,
				},
			},
			order = 200,
		},
	},
}

TooltipExchange.revision = tonumber(string.sub("$Revision: 45907 $", 12, -3))
TooltipExchange.maxRevision = TooltipExchange.revision
TooltipExchange.transportModules = {}

TooltipExchange:RegisterDB("TooltipExchangeDB", "TooltipExchangeDBPC")
TooltipExchange:RegisterDefaults("profile", TooltipExchange.defaults)
TooltipExchange:RegisterChatCommand({"/te", "/TooltipExchange"}, TooltipExchange.options)

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchange:OnInitialize()
	if not self.db.profile.version or self.db.profile.version < DATABASE_VERSION or not self.db.profile.storage then
		self.db.profile.version = DATABASE_VERSION
		self.db.profile.storage = storage:CreateStorage()
	end

	self:LoadExternalModules()

	local rev = self.revision

	for name, module in self:IterateModules() do
		if module.revision > rev then
			rev = module.revision
		end

		self:RegisterModule(name, module)
	end

	self.version = self.version .. " |cffff8888r".. rev .."|r" 
	self.maxRevision = rev

	self:InitializeItemPacks()
end

function TooltipExchange:OnEnable()
	self:RegisterEvent("TooltipExchange_ItemSeen")

	self.inCombat = false

	self:RegisterEvent("PLAYER_REGEN_DISABLED", function() self.inCombat = true end)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function() self.inCombat = false end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self.inCombat = false end)
	self:RegisterEvent("PLAYER_CONTROL_LOST")

	local S, R = self.db.profile.storage, self.db.profile.rarity

	for itemID, item in storage:IterateItems(S) do
		if storage:GetItemRarity(S, item) < R then
			storage:RemoveItem(S, itemID)
		end
	end
end

function TooltipExchange:OnDisable()

end

function TooltipExchange:LoadExternalModules()
	for i = 1, GetNumAddOns() do
		local addon, _, _, enabled = GetAddOnInfo(i)

		if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) and enabled then
			local name = GetAddOnMetadata(i, "X-TooltipExchange-Module")

			if name then
				LoadAddOn(addon)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Module Prototype
-------------------------------------------------------------------------------

TooltipExchange:SetModuleMixins("AceEvent-2.0")

TooltipExchange.modulePrototype.core = TooltipExchange
TooltipExchange.modulePrototype.revision = 1

function TooltipExchange.modulePrototype:Enabled()
	return self.core:IsModuleActive(self)
end

function TooltipExchange.modulePrototype:GetStorage()
	return self.core.db.profile.storage
end

function TooltipExchange.modulePrototype:GetRarityLevel()
	return self.core.db.profile.rarity
end

function TooltipExchange.modulePrototype:GetVersion()
	return self.core.maxRevision
end

function TooltipExchange.modulePrototype:InCombat()
	return self.core.inCombat
end

function TooltipExchange.modulePrototype:RegisterAsTransportModule()
	self.core.transportModules[self] = 1
end

function TooltipExchange.modulePrototype:SendMessage(destination, messageType, ...)
	for m in pairs(self.core.transportModules) do
		if self.core:IsModuleActive(m) then
			m:SendCommunicate(destination, messageType, ...)
		end
	end
end

function TooltipExchange.modulePrototype:RegisterMessage(messageType)
	for m in pairs(self.core.transportModules) do
		m:RegisterCommunicate(self, messageType)
	end
end

function TooltipExchange:RegisterModule(name, module)
	if module.internalModule then
		return
	end

	self:RegisterDefaults(name, "profile", module.defaults or {})
	module.db = self:AcquireDBNamespace(name)

	if module.commands then
		for k, v in pairs(module.commands) do
			self.options.args[k] = v
		end
	end

	if not module.notToggable or module.options then
		local m = module
		local options = {
			type = "group",
			name = name,
			desc = string.format(L["Options for %s module."], name),
			order = 200,
			args = {
				moduleHeader = {
					type = "header",
					name = name,
					order = 1,
				},
			},
		}

		if not module.notToggable then
			options.args.enabled = {
				type = "toggle",
				name = L["Enabled"],
				desc = L["Enable or disable this module."],
				get = function() return m.core:IsModuleActive(m) end,
				set = function() m.core:ToggleModuleActive(m) end,
				order = 2,
			}
		end

		if module.options then
			if not module.notToggable then
				options.args.spacerHeader = {
					type = "header",
					order = 3,
					name = " ",
				}
			end

			for k, v in pairs(module.options) do
				options.args[k] = v
			end
		end

		self.options.args[string.gsub(name, "[^%w]", "")] = options
	end
end

-------------------------------------------------------------------------------
-- Item Packs
-------------------------------------------------------------------------------

function TooltipExchange:InitializeItemPacks()
	self.itemPacks = {}

	for i = 1, GetNumAddOns() do
		local addon, _, _, enabled = GetAddOnInfo(i)

		if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) and enabled then
			local name = GetAddOnMetadata(i, "X-TooltipExchange-ItemPack-Name")
			local version = GetAddOnMetadata(i, "X-TooltipExchange-ItemPack-Version")

			if name and version then
				version = tonumber(string.sub(version, 12, -3))

				if version then
					self.itemPacks[addon] = {
						name = name,
						version = version,
					}

					self.options.args.itemPacks.args[string.gsub(name, "[^%w]", "")] = {
						type = "group",
						name = name,
						desc = name,
						args = {
							header = {
								type = "header",
								name = name,
								order = 1,
							},
							version = {
								type = "header",
								name = string.format(L["|cffffffffVersion %d|r"], version),
								order = 2,
							},
							loaded = {
								type = "header",
								name = L["|cffff0000Injected|r"],
								hidden = function() return not IsAddOnLoaded(addon) end,
								order = 3,
							},
							unloaded = {
								type = "header",
								name = L["|cff00ff00Up to date|r"],
								hidden = function() return IsAddOnLoaded(addon) end,
								order = 4,
							},
							spacer = {
								type = "header",
								name = " ",
								hidden = function() return IsAddOnLoaded(addon) end,
								order = 5,
							},
							refresh = {
								type = "execute",
								name = L["Refresh"],
								desc = L["Re-injects all items from given item pack into database. Usefull after purging database when already current version of item pack was integrated into it."],
								func = function() LoadAddOn(addon) end,
								hidden = function() return IsAddOnLoaded(addon) end,
								order = 6,
							},
						},
					}

					if not self.db.profile.itemPacks[name] or self.db.profile.itemPacks[name] < version then
						LoadAddOn(addon)
					end
				end
			end
		end
	end

	local hasPacks = false

	for k, v in pairs(self.itemPacks) do
		hasPacks = true
		break
	end

	for k, v in pairs(self.db.profile.itemPacks) do
		hasPacks = true
		break
	end

	if not hasPacks then
		TooltipExchange.options.args.itemPacks = nil
	end
end

function TooltipExchange:LoadItemPack(name, version, items)
	local valid = false

	for k, v in pairs(self.itemPacks) do
		if v.name == name then
			valid = true
			break
		end
	end

	if valid then
		local S, R = self.db.profile.storage, self.db.profile.rarity

		for _, item in pairs(items) do
			if item.c >= R then
				storage:Inject(S, item)
			end
		end

		self.db.profile.itemPacks[name] = version
	end
end

-------------------------------------------------------------------------------
-- Settings & Commands
-------------------------------------------------------------------------------

function TooltipExchange:ToggleRarity(value)
	if type(value) == "nil" then
		return self.db.profile.rarity
	end

	self.db.profile.rarity = value

	local S = self.db.profile.storage

	for itemID, item in storage:IterateItems(S) do
		if storage:GetItemRarity(S, item) < value then
			storage:RemoveItem(S, itemID)
		end
	end

	self:DatabaseStatistics(true)
end

function TooltipExchange:MineCache()
	local hidden = false

	if tablet:IsRegistered("TooltipExchange_DatabaseStatistics") and not tablet:IsAttached("TooltipExchange_DatabaseStatistics") then
		tablet:Attach("TooltipExchange_DatabaseStatistics")
		hidden = true
	end

	local S = self.db.profile.storage

	for i = 1, MAX_ITEMID, 1 do
		if not storage:HasItem(S, i) then
			self:TooltipExchange_ItemSeen(i)
		end
	end

	if hidden then
		self:DatabaseStatistics()
	end
end

function TooltipExchange:UpdateCache()
	local hidden = false

	if tablet:IsRegistered("TooltipExchange_DatabaseStatistics") and not tablet:IsAttached("TooltipExchange_DatabaseStatistics") then
		tablet:Attach("TooltipExchange_DatabaseStatistics")
		hidden = true
	end

	for itemID, _ in storage:IterateItems(self.db.profile.storage) do
		if GetItemInfo(itemID) then
			self:TooltipExchange_ItemSeen(itemID)
		end
	end

	if hidden then
		self:DatabaseStatistics()
	end
end

function TooltipExchange:MineItem(itemID)
	local itemID = itemID

	SetItemRef(string.format("item:%d", itemID))
	ItemRefTooltip:Hide()

	self:ScheduleEvent(function()
		self:TooltipExchange_ItemSeen(itemID)
	end, 1)
end

function TooltipExchange:LaunchMineLoop()
	self:ScheduleRepeatingEvent("TooltipExchange_MineInvalid", function()
		if self.invalidLastID then
			if GetItemInfo(self.invalidLastID) then
				self:TooltipExchange_ItemSeen(self.invalidLastID)
			else
				self.invalidTries = self.invalidTries + 1

				if self.invalidTries < 50 then
					return
				end
			end
		end

		if table.getn(self.invalidItems) == 0 then
			self:CancelScheduledEvent("TooltipExchange_MineInvalid")
			return
		end

		self.invalidLastID = table.remove(self.invalidItems)
		self.invalidTries = 0
		self:Debug("M", storage:GetItemLink(self.db.profile.storage, storage:GetItem(self.db.profile.storage, self.invalidLastID)))

		SetItemRef(string.format("item:%d", self.invalidLastID))
		ItemRefTooltip:Hide()
	end, 0.1)
end

function TooltipExchange:MineInvalid()
	if not self.invalidItems then
		self.invalidItems = {}
	else
		for k in pairs(self.invalidItems) do
			self.invalidItems[k] = nil
		end
	end

	self.invalidLastID = nil

	for itemID, _ in storage:IterateItems(self.db.profile.storage) do
		if not GetItemInfo(itemID) then
			table.insert(self.invalidItems, itemID)
		end
	end

	self:LaunchMineLoop()
end

function TooltipExchange:MineResults()
	if not self.invalidItems then
		self.invalidItems = {}
	else
		for k in pairs(self.invalidItems) do
			self.invalidItems[k] = nil
		end
	end

	self.invalidLastID = nil

	if TooltipExchangeUI and TooltipExchangeUI.searchHash then
		for itemID, _ in pairs(TooltipExchangeUI.searchHash) do
			if not GetItemInfo(itemID) then
				table.insert(self.invalidItems, itemID)
			end
		end

		self:LaunchMineLoop()
	end
end

function TooltipExchange:PurgeItems()
	self.db.profile.storage = storage:CreateStorage()
	self:DatabaseStatistics(true)
end

function TooltipExchange:ShowInvalid()
	local a = {}

	for itemID, _ in storage:IterateItems(self.db.profile.storage) do
		if not GetItemInfo(itemID) then
			a[itemID] = true
		end
	end

	self:TriggerEvent("TooltipExchange_LocalResults", a)
end

-------------------------------------------------------------------------------
-- Events & Hooks
-------------------------------------------------------------------------------

function TooltipExchange:TooltipExchange_ItemSeen(itemID)
	local n, _, c, x, _, t, s, _, e, o = GetItemInfo(itemID)

	if n then
		local hadItem = storage:HasItem(self.db.profile.storage, itemID)

		if (hadItem or c >= self.db.profile.rarity) and t ~= "Recipe" then
			local item = storage:AddItem(self.db.profile.storage, itemID)

			if not hadItem and item then
				self:Debug("A", storage:GetItemLink(self.db.profile.storage, item))
				self:DatabaseStatistics(true)
			end
		end
	end
end

function TooltipExchange:PLAYER_CONTROL_LOST()
	if self.db.profile.autoMine.taxi then
		self:ScheduleEvent(function()
			if UnitOnTaxi("player") then
				self:MineCache()
			end
		end, 1)
	end
end

-------------------------------------------------------------------------------
-- Database Statistics Tablet
-------------------------------------------------------------------------------

function TooltipExchange:DatabaseStatistics(update)
	if not tablet:IsRegistered("TooltipExchange_DatabaseStatistics") then
		tablet:Register("TooltipExchange_DatabaseStatistics",
			"children", function()
				tablet:SetTitle(L["Database Statistics"])
				self:DatabaseStatisticsUpdate()
			end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
				dewdrop:AddLine(
					"text", L["Database Statistics"],
					"tooltipTitle", L["Database Statistics"],
					"tooltipText", L["Prints database statistics."],
					"func", function() self:DatabaseStatistics() end)
				dewdrop:AddLine(
					"text", L["Close window"],
					"tooltipTitle", L["Close window"],
					"tooltipText", L["Closes the statistics."],

					"func", function()
						tablet:Attach("TooltipExchange_DatabaseStatistics")
						dewdrop:Close()
					end)
			end
		)
	end

	if update and tablet:IsAttached("TooltipExchange_DatabaseStatistics") then
		return
	elseif tablet:IsAttached("TooltipExchange_DatabaseStatistics") then
		tablet:Detach("TooltipExchange_DatabaseStatistics")
	else
		tablet:Refresh("TooltipExchange_DatabaseStatistics")
	end 
end

function TooltipExchange:DatabaseStatisticsUpdate()
	local itemCount, validCound, invalidCount, colors, patternCount, patternLength, patternedLines, unpatternedLines, unpatternedLength, memory = storage:Stat(self.db.profile.storage)

	local cat = tablet:AddCategory(
		"columns", 1,
		"text", L["Item Count"],
		"child_justify1", "LEFT"
	)
	cat:AddLine("text", itemCount)

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Valid"],
		"text2", L["Invalid"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	cat:AddLine("text", "|cff00ff00" .. validCound .. "|r", "text2", "|cffff0000" .. invalidCount .. "|r")

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Rarity"],
		"text2", L["Count"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	for i = #(ITEM_QUALITY_COLORS), 0, -1 do
		if colors[i] > 0 then
			cat:AddLine("text", ITEM_QUALITY_COLORS[i].hex .. _G["ITEM_QUALITY" .. i .. "_DESC"] .. "|r", "text2", colors[i]) 
		end
	end

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Internal Stat"],
		"text2", "Value",
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	cat:AddLine("text", L["Patterns Count"], "text2", patternCount)
	cat:AddLine("text", L["Patterns Length"], "text2", patternLength)
	cat:AddLine("text", L["Patterned Lines"], "text2", patternedLines)
	cat:AddLine("text", L["Unpatterned Lines"], "text2", unpatternedLines)
	cat:AddLine("text", L["Unpatterned Length"], "text2", unpatternedLength)

	local cat = tablet:AddCategory(
		"columns", 1,
		"text", L["Memory Usage Estimation"],
		"child_justify1", "LEFT"
	)
	cat:AddLine("text", memory)
end

-------------------------------------------------------------------------------
-- Cache Statistics Tablet
-------------------------------------------------------------------------------

function TooltipExchange:CacheStatistics(update)
	if not tablet:IsRegistered("TooltipExchange_CacheStatistics") then
		tablet:Register("TooltipExchange_CacheStatistics",
			"children", function()
				tablet:SetTitle(L["Cache Statistics"])
				self:CacheStatisticsUpdate()
			end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
				dewdrop:AddLine(
					"text", L["Cache Statistics"],
					"tooltipTitle", L["Cache Statistics"],
					"tooltipText", L["Prints game item cache statistics."],
					"func", function() self:CacheStatistics() end)
				dewdrop:AddLine(
					"text", L["Close window"],
					"tooltipTitle", L["Close window"],
					"tooltipText", L["Closes the statistics."],

					"func", function()
						tablet:Attach("TooltipExchange_CacheStatistics")
						dewdrop:Close()
					end)
			end
		)
	end

	if update and tablet:IsAttached("TooltipExchange_CacheStatistics") then
		return
	elseif tablet:IsAttached("TooltipExchange_CacheStatistics") then
		tablet:Detach("TooltipExchange_CacheStatistics")
	else
		tablet:Refresh("TooltipExchange_CacheStatistics")
	end 
end

function TooltipExchange:CacheStatisticsUpdate()
	local validCount, colors = 0, {}

	for i = 0, #(ITEM_QUALITY_COLORS) do
		colors[i] = 0
	end

	for i = 1, MAX_ITEMID, 1 do
		local n, _, c = GetItemInfo(i)

		if n then
			colors[c] = colors[c] + 1
			validCount = validCount + 1
		end
	end

	local cat = tablet:AddCategory(
		"columns", 1,
		"text", L["Item Count"],
		"child_justify1", "LEFT"
	)
	cat:AddLine("text", "??")

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Valid"],
		"text2", L["Invalid"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	cat:AddLine("text", "|cff00ff00" .. validCount .. "|r", "text2", "|cffff0000" .. "??" .. "|r")

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Rarity"],
		"text2", L["Count"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	for i = #(ITEM_QUALITY_COLORS), 0, -1 do
		if colors[i] > 0 then
			cat:AddLine("text", ITEM_QUALITY_COLORS[i].hex .. _G["ITEM_QUALITY" .. i .. "_DESC"] .. "|r", "text2", colors[i]) 
		end
	end
end

