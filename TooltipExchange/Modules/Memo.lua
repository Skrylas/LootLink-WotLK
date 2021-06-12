
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeMemo")
local dewdrop = AceLibrary("Dewdrop-2.0")
local storage = AceLibrary("ItemStorage-1.0")

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["%s memo list options."] = true,
	["%s public memo lists."] = true,
	["<name>"] = true,
	["Add List"] = true,
	["Adds a new memo list. You will be later able to add items into newly created memo list via context menus in item search panel, accessed with right clicking on some item."] = true,
	["Copy"] = true,
	["Makes local private copy of selected memo list, under specified name."] = true,
	["Memo Type"] = true,
	["Memo"] = true,
	["Memorized item lists."] = true,
	["Private"] = true,
	["Public"] = true,
	["Rarity"] = true,
	["Refresh Remotes"] = true,
	["Reloads remote memo lists."] = true,
	["Remote"] = true,
	["Remove"] = true,
	["Removes memo list."] = true,
	["Rename"] = true,
	["Renames memo list."] = true,
	["Sets Memo list type."] = true,
	["Show"] = true,
	["Shows memo list items."] = true,

} end)

L:RegisterTranslations("koKR", function() return {
	["%s memo list options."] = "%s 메모 목록 옵션",
	["%s public memo lists."] = "%s 일반 메모 목록",
	["<name>"] = "<이름>",
	["Add List"] = "리스트 추가",
	["Adds a new memo list. You will be later able to add items into newly created memo list via context menus in item search panel, accessed with right clicking on some item."] = "새로운 메모 리스트를 작성합니다. 아이템에 오른쪽 클릭으로 접근하여 아이템 검색 패널의 문맥 메뉴를 통해 새로 만들어진 메모 목록으로 아이템을 더할 수 있습니다.",
	["Copy"] = "복사",
	["Makes local private copy of selected memo list, under specified name."] = "명시된 이름 아래 선정된 메모 목록을 복사합니다.",
	["Memo Type"] = "메모 유형",
	["Memo"] = "메모",
	["Memorized item lists."] = "아이템 리스트를 저장합니다.",
	["Private"] = "개인",
	["Public"] = "공개",
	["Rarity"] = "등급",
	["Refresh Remotes"] = "리모트 리프레시",
	["Reloads remote memo lists."] = "리모트 메모 목을를 재로드 합니다.",
	["Remote"] = "리모트",
	["Remove"] = "삭제",
	["Removes memo list."] = "메모 리스트에서 삭제합니다.",
	["Rename"] = "이름 변경",
	["Renames memo list."] = "메모 리스트의 이름을 변경합니다.",
	["Sets Memo list type."] = "메모 리스트의 유형을 설정합니다.",
	["Show"] = "보기",
	["Shows memo list items."] = "메모 리스트의 아이템을 봅니다.",
} end)

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

TooltipExchangeMemo = TooltipExchange:NewModule(L["Memo"])
TooltipExchangeMemo.notToggable = true

TooltipExchangeMemo.defaults = {
	memoLists = {},
}

TooltipExchangeMemo.commands = {
	memo = {
		type = "group",
		name = L["Memo"],
		desc = L["Memorized item lists."],
		args = {},
		order = 20,
	},
}

TooltipExchangeMemo.revision = tonumber(string.sub("$Revision: 49865 $", 12, -3))

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangeMemo:OnInitialize()
	for _, listInfo in ipairs(self.db.profile.memoLists) do
		if not listInfo.id then
			listInfo.id = math.random(1000000, 9999999)
		end
	end

	self.remoteLists = {}

	self:RegisterMessage("MQ")
	self:RegisterMessage("ML")
	self:RegisterMessage("MR")
	self:RegisterMessage("MM")

	self:PopulateMemoList()
end

function TooltipExchangeMemo:OnEnable()
	self:RegisterEvent("TooltipExchange_UIItemContextMenuCreated")
end

function TooltipExchangeMemo:OnDisable()

end

-------------------------------------------------------------------------------
-- Evetns and Hooks
-------------------------------------------------------------------------------

function TooltipExchangeMemo:TooltipExchange_UIItemContextMenuCreated(itemID, level, value1, value2, value3)
	if #(self.db.profile.memoLists) > 0 then
		if level == 1 then
			dewdrop:AddLine(
				'value', "MemoSubmenu",
				'hasArrow', true,
				'text', L["Memo"]
			)
		end

		if level == 2 and value1 == "MemoSubmenu" then
			dewdrop:AddLine(
				'isTitle', true,
				'text', L["Memo"]
			)

			for _, listInfo in ipairs(self.db.profile.memoLists) do
				local items = listInfo.items

				dewdrop:AddLine(
					'text', listInfo.name,
					'checked', items[itemID] and true or false,
					'func', function()
						if not items[itemID] then
							items[itemID] = 1
						else
							items[itemID] = nil
						end
					end
				)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Module Specific Communication
-------------------------------------------------------------------------------

function TooltipExchangeMemo:MQ(sender, queryID)
	local list = {}

	for _, listInfo in ipairs(self.db.profile.memoLists) do
		if listInfo.type == 2 then
			table.insert(list, {
				id = listInfo.id,
				name = listInfo.name,
			})
		end
	end

	if #(list) > 0 then
		self:SendMessage(sender, "ML", queryID, list)
	end
end

function TooltipExchangeMemo:ML(sender, queryID, list)
	if self.queryID == queryID then
		if not self.remoteLists[sender] then
			self.remoteLists[sender] = {}
		end

		for _, memo in ipairs(list) do
			self.remoteLists[sender][memo.name] = memo.id
		end

		self:PopulateMemoList()
		dewdrop:Refresh(2)
	end
end

function TooltipExchangeMemo:MR(sender, id, requestID, provider)
	if UnitName("player") == provider then

		for _, listInfo in ipairs(self.db.profile.memoLists) do
			if listInfo.id == id then

				local items = {}

				for itemID in pairs(listInfo.items) do
					if storage:HasItem(self:GetStorage(), itemID) then
						table.insert(items, {
							i = storage:GetItemID(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
							c = storage:GetItemRarity(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
							n = storage:GetItemName(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
							o = storage:GetItemIcon(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
						})
					end
				end

				if #(items) > 0 then
					self:SendMessage(sender, "MM", requestID, items)
				end

				break
			end
		end

	end
end

function TooltipExchangeMemo:MM(sender, requestID, items)
	if self.requestID == requestID then
		for _, item in ipairs(items) do
			if not storage:HasItem(self:GetStorage(), item.i) then
				self:TriggerEvent("TooltipExchange_ItemSeen", item.i)
			end
		end

		if self.copyFrom == requestID then
			for _, listInfo in ipairs(self.db.profile.memoLists) do
				if listInfo.name == self.copyTo then
					for _, item in ipairs(items) do
						listInfo.items[item.i] = 1

						if not storage:HasItem(self:GetStorage(), item.i) then
							self:SendMessage(sender, "DR", item.i, sender)
						end
					end

					break
				end
			end

			self.copyFrom = nil
			self.copyTo = nil
		else
			self:TriggerEvent("TooltipExchange_ExternalResults", sender, items)
		end

		self.requestID = nil
	end
end

-------------------------------------------------------------------------------
-- Memo Lists
-------------------------------------------------------------------------------

function TooltipExchangeMemo:RefreshRemoteLists()
	self.remoteLists = {}

	self:PopulateMemoList()
	dewdrop:Refresh(2)

	self.queryID = math.random(1000000, 9999999)
	self:SendMessage(nil, "MQ", self.queryID)

	return self.queryID
end

function TooltipExchangeMemo:RequestRemoteMemo(provider, id)
	self.requestID = math.random(1000000, 9999999)
	self:SendMessage(provider, "MR", id, self.requestID, provider)

	return self.requestID
end

function TooltipExchangeMemo:CopyRemoteMemo(provider, id, name)
	self.copyTo = name
	self:AddMemoList(name)
	self.copyFrom = self:RequestRemoteMemo(provider, id)
end

function TooltipExchangeMemo:ValidateMemoName(name)
	if not string.find(name, "^[^%s+].*$") then
		return false
	end

	for _, listInfo in ipairs(self.db.profile.memoLists) do
		if string.lower(listInfo.name) == string.lower(name) then
			return false
		end
	end

	return true
end

function TooltipExchangeMemo:AddMemoList(list)
	table.insert(self.db.profile.memoLists, {
		id = math.random(1000000, 9999999),
		name = list,
		type = 1,
		items = {},
	})

	table.sort(self.db.profile.memoLists, function(a, b)
		return a.name < b.name
	end)

	self:PopulateMemoList()
end

function TooltipExchangeMemo:RemoveMemoList(list)
	for k, listInfo in ipairs(self.db.profile.memoLists) do
		if listInfo.name == list then
			table.remove(self.db.profile.memoLists, k)
		end
	end

	self:PopulateMemoList()
end

function TooltipExchangeMemo:RenameMemoList(list, newName)
	for k, listInfo in ipairs(self.db.profile.memoLists) do
		if listInfo.name == list then
			listInfo.name = newName
			break
		end
	end

	self:PopulateMemoList()
end

function TooltipExchangeMemo:ShowMemoList(list)
	for _, listInfo in ipairs(self.db.profile.memoLists) do
		if listInfo.name == list then
			self:TriggerEvent("TooltipExchange_LocalResults", listInfo.items)
			break
		end
	end
end

function TooltipExchangeMemo:PopulateMemoList()
	self.commands.memo.args = {}

	self.commands.memo.args.memoHeader = { type = "header", order = 1, name = L["Memo"] }

	self.commands.memo.args.add = {
		type = 'text',
		name = L["Add List"],
		desc = L["Adds a new memo list. You will be later able to add items into newly created memo list via context menus in item search panel, accessed with right clicking on some item."],
		get = false,
		set = function(v) self:AddMemoList(v) dewdrop:Refresh(2) end,
		usage = L["<name>"],
		order = 2,
		validate = function(v) return self:ValidateMemoName(v) end,
	}

	local texts = { L["Private"], L["Public"], L["Remote"] }
	local types = {}

	for _, listInfo in ipairs(self.db.profile.memoLists) do
		if listInfo.type then
			types[listInfo.type] = 1
		end
	end

	for _, _ in pairs(self.remoteLists) do
		types[3] = 1
		break
	end

	for k in pairs(types) do
		self.commands.memo.args["spacer" .. k] = { type = "header", order = 100 * (1 + k) + 1 }
		self.commands.memo.args["header" .. k] = { type = "header", order = 100 * (1 + k) + 2, name = texts[k] }
	end

	for _, listInfo in ipairs(self.db.profile.memoLists) do
		local listInfo, l = listInfo, string.gsub(listInfo.name, "[^%w]", "")

		self.commands.memo.args[l] = {
			type = 'group',
			name = listInfo.name,
			desc = string.format(L["%s memo list options."], listInfo.name),
			order = 100 * (1 + (listInfo.type or 1)) + 3,
			onClick = function() self:ShowMemoList(listInfo.name) dewdrop:Close() end,
			args = {},
		}

		self.commands.memo.args[l].args.memoHeader = { type = "header", order = 1, name = listInfo.name }

		self.commands.memo.args[l].args.show = {
			type = 'execute',
			name = L["Show"],
			desc = L["Shows memo list items."],
			func = function() self:ShowMemoList(listInfo.name) dewdrop:Close() end,
			order = 2,
		}

		self.commands.memo.args[l].args.rename = {
			type = 'text',
			name = L["Rename"],
			desc = L["Renames memo list."],
			get = function() return listInfo.name end,
			set = function(v) self:RenameMemoList(listInfo.name, v) dewdrop:Close(3) dewdrop:Refresh(2) end,
			usage = L["<name>"],
			validate = function(v) return self:ValidateMemoName(v) end,
			order = 3,
		}

		self.commands.memo.args[l].args.remove = {
			type = 'execute',
			name = L["Remove"],
			desc = L["Removes memo list."],
			func = function() self:RemoveMemoList(listInfo.name) dewdrop:Close(3) dewdrop:Refresh(2) end,
			order = 4,
		}

		self.commands.memo.args[l].args.isPublic = {
			type = 'text',
			name = L["Memo Type"],
			desc = L["Sets Memo list type."],
			get = function() return tostring(listInfo.type) or "1" end,
			set = function(v) listInfo.type = tonumber(v) self:PopulateMemoList() dewdrop:Refresh(2) end,
			validate = { ["1"] = L["Private"], ["2"] = L["Public"] },
			order = 5,
		}
	end

	for provider, lists in pairs(self.remoteLists) do
		local p = provider

		self.commands.memo.args[p] = {
			type = 'group',
			name = provider,
			desc = string.format(L["%s public memo lists."], p),
			order = 100 * (1 + 3) + 3,
			args = {},
		}

		for name, id in pairs(lists) do
			local i, n, name = id, string.gsub(name, "[^%w]", ""), name

			self.commands.memo.args[p].args[n] = {
				type = 'group',
				name = name,
				desc = string.format(L["%s memo list options."], name),
				args = {},
			}

			self.commands.memo.args[p].args[n].args.memoHeader = { type = "header", order = 1, name = name }

			self.commands.memo.args[p].args[n].args.show = {
				type = 'execute',
				name = L["Show"],
				desc = L["Shows memo list items."],
				func = function() self:RequestRemoteMemo(p, i) dewdrop:Close() end,
				order = 1,
			}

			self.commands.memo.args[p].args[n].args.copy = {
				type = 'text',
				name = L["Copy"],
				desc = L["Makes local private copy of selected memo list, under specified name."],
				get = function() return name end,
				set = function(v) self:CopyRemoteMemo(p, i, v) dewdrop:Refresh(2) end,
				usage = L["<name>"],
				validate = function(v) return self:ValidateMemoName(v) end,
				order = 2,
			}
		end
	end

	self.commands.memo.args["refresh"] = {
		type = 'execute',
		name = L["Refresh Remotes"],
		desc = L["Reloads remote memo lists."],
		func = function() self:RefreshRemoteLists() end,
		order = -10,
	}
end
