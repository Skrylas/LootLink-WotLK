
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangePrices")
local dewdrop = AceLibrary("Dewdrop-2.0")
local storage = AceLibrary("ItemStorage-1.0")

local MAX_ALT_CURRENCY = 5

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Prices"] = true,
	["Buy price:"] = true,
	["Tokens"] = true,
	["Displays lists of items that can be purchased for specific tokens."] = true,
	["PvP Points"] = true,
	["Displays lists of items that can be purchased for PvP points."] = true,
	["Display items purchased for %s."] = true,

	["Alliance Honor"] = true,
	["Horde Honor"] = true,
	["Arena Points"] = true,

	["Badge of Justice"] = true,
	["Spirit Shard"] = true,
	["Arcane Rune"] = true,
	["Holy Dust"] = true,
	["Haala Battle Token"] = true,
	["Haala Research Token"] = true,
} end)

local tokens = {
	{ name = L["Badge of Justice"], color = 4, texture = "Interface\\Icons\\Spell_Holy_ChampionsBond" },
	{ name = L["Haala Battle Token"], color = 2, texture = "Interface\\Icons\\INV_Misc_Rune_08" },
	{ name = L["Haala Research Token"], color = 2, texture = "Interface\\Icons\\INV_Misc_Rune_09" },
	{ name = L["Arcane Rune"], color = 1, texture = "Interface\\Icons\\INV_Misc_Rune_05" },
	{ name = L["Holy Dust"], color = 1, texture = "Interface\\Icons\\INV_Misc_Dust_06" },
	{ name = L["Spirit Shard"], color = 1, texture = "Interface\\Icons\\INV_Jewelry_FrostwolfTrinket_04" },
}

TooltipExchangePrices = TooltipExchange:NewModule(L["Prices"])

TooltipExchangePrices.defaults = {
	priceData = {},
}

TooltipExchangePrices.options = {
	points = {
		type = "group",
		name = L["PvP Points"],
		desc = L["Displays lists of items that can be purchased for PvP points."],
		args = {
			headerPoints = {
				type = "header",
				name = L["PvP Points"],
				order = 1,
			},
			alliance = {
				type = "execute",
				name = L["Alliance Honor"],
				desc = string.format(L["Display items purchased for %s."], L["Alliance Honor"]),
				func = function() TooltipExchangePrices:ShowItemsByPoints("A") dewdrop:Close() end,
				order = 101,
			},
			horde = {
				type = "execute",
				name = L["Horde Honor"],
				desc = string.format(L["Display items purchased for %s."], L["Horde Honor"]),
				func = function() TooltipExchangePrices:ShowItemsByPoints("H") dewdrop:Close() end,
				order = 102,
			},
			arena = {
				type = "execute",
				name = L["Arena Points"],
				desc = string.format(L["Display items purchased for %s."], L["Arena Points"]),
				func = function() TooltipExchangePrices:ShowItemsByPoints("a") dewdrop:Close() end,
				order = 101,
			},
		},
	},
	tokens = {
		type = "group",
		name = L["Tokens"],
		desc = L["Displays lists of items that can be purchased for specific tokens."],
		args = {
			headerTokens = {
				type = "header",
				name = L["Tokens"],
				order = 1,
			},
		},
	},
}

TooltipExchangePrices.revision = tonumber(string.sub("$Revision: 30093 $", 12, -3))

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangePrices:OnInitialize()
	self:BuildStaticMenu()
end

function TooltipExchangePrices:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW", "MerchantEvent")
	self:RegisterEvent("MERCHANT_UPDATE", "MerchantEvent")
	self:RegisterEvent("TooltipExchange_DataTooltipUpdate")
end

function TooltipExchangePrices:OnDisable()

end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

function TooltipExchangePrices:MerchantEvent()
	local n = GetMerchantNumItems()

	if n then
		for i = 1, n do
			local link = GetMerchantItemLink(i)

			if link then
				local _, _, itemID = string.find(link, "|c%x+|Hitem:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+|h%[.-%]|h|r")

				if itemID then
					itemID = tonumber(itemID)

					if storage:HasItem(self:GetStorage(), itemID) then
						self.db.profile.priceData[itemID] = self:PackInfo(self:BuildInfo(i))
					end
				end
			end
		end
	end
end

function TooltipExchangePrices:TooltipExchange_DataTooltipUpdate(itemID, item, tooltip)
	local packed = self.db.profile.priceData[itemID]

	if packed then
		local info = self:UnpackInfo(packed)

		if info then
			self:SetAltCurrency(tooltip, info)
			return
		end
	end

	self:ClearAltCurrency(tooltip)
end

-------------------------------------------------------------------------------
-- Misc
-------------------------------------------------------------------------------

function TooltipExchangePrices:BuildInfo(index)
	local _, _, buy, _, _, _, extendedCost = GetMerchantItemInfo(index)
	local info, valid = {}, false

	if buy and buy > 0 then
		info.buy = buy
		valid = true
	end

	if extendedCost then
		local honor, arena, itemCount = GetMerchantItemCostInfo(index)
		
		if honor and honor > 0 then
			if UnitFactionGroup("player") == "Alliance" then
				info.alliance = honor
			else
				info.horde = honor
			end
			valid = true
		end

		if arena and arena > 0 then
			info.arena = arena
			valid = true
		end

		if itemCount and itemCount > 0 then
			info.items = {}
			valid = true

			for i = 1, itemCount do
				local texture, value = GetMerchantItemCostItem(index, i)

				if texture and value then
					table.insert(info.items, {
						texture = texture,
						value = value,
					})
				end
			end
		end
	end

	if valid then
		return info
	end
end

function TooltipExchangePrices:PackInfo(info)
	if not info then
		return
	end

	local data = {}

	if info.buy then
		table.insert(data, "b:" .. info.buy)
	end

	if info.alliance then
		table.insert(data, "A:" .. info.alliance)
	end

	if info.horde then
		table.insert(data, "H:" .. info.horde)
	end

	if info.arena then
		table.insert(data, "a:" .. info.arena)
	end

	if info.items then
		table.insert(data, "c:" .. #(info.items))

		for i, item in ipairs(info.items) do
			table.insert(data, "t" .. i .. ":" .. string.gsub(item.texture, "Interface\\Icons\\", "{0}"))
			table.insert(data, "v" .. i .. ":" .. item.value)
		end
	end

	if #(data) > 0 then
		return table.concat(data, "·")
	end
end

function TooltipExchangePrices:UnpackInfo(compressed)
	local info = {}

	for p in string.gmatch(compressed, "[^·]+") do
		local _, _, s, v = string.find(p, "^([^:]+):([^:]+)$")

		if s == "b" then
			info.buy = tonumber(v)
		elseif s == "A" then
			info.alliance = tonumber(v)
		elseif s == "H" then
			info.horde = tonumber(v)
		elseif s == "a" then
			info.arena = tonumber(v)
		elseif s == "c" then
			info.items = {}
		elseif string.find(s, "^[tv]") then
			local _, _, x, i = string.find(s, "^([tv])(%d+)$")

			if x and i then
				i = tonumber(i)

				if not info.items[i] then
					info.items[i] = {}
				end

				if x == "t" then
					info.items[i].texture = string.gsub(v, "{0}", "Interface\\Icons\\")
				else
					info.items[i].value = tonumber(v)
				end
			end
		end
	end

	return info
end

function TooltipExchangePrices:ShowItemsByPoints(points)
	local a = {}

	for itemID, packed in pairs(self.db.profile.priceData) do
		a[itemID] = string.find(packed, points .. ":", 1, true) and true or nil
	end

	self:TriggerEvent("TooltipExchange_LocalResults", a)
end

function TooltipExchangePrices:ShowItemsByToken(texture)
	local t = string.gsub(texture, "Interface\\Icons\\", "{0}")
	local a = {}

	for itemID, packed in pairs(self.db.profile.priceData) do
		a[itemID] = string.find(packed, t, 1, true) and true or nil
	end

	self:TriggerEvent("TooltipExchange_LocalResults", a)
end

-------------------------------------------------------------------------------
-- User Interface
-------------------------------------------------------------------------------

function TooltipExchangePrices:AddAltCurrencyControls(tooltip)
	if tooltip.alt then
		return
	end

	tooltip.alt = {}

	local p

	for i = 1, MAX_ALT_CURRENCY do
		local f = CreateFrame("Frame", nil, tooltip)
		f:SetWidth(0)
		f:SetHeight(MONEY_ICON_WIDTH_SMALL)
		f:Hide()

		f.value = f:CreateFontString(nil, "BACKGROUND")
		f.value:SetWidth(0)
		f.value:SetHeight(MONEY_ICON_WIDTH_SMALL)
		f.value:SetFontObject(NumberFontNormal)
		f.value:SetJustifyH("LEFT")
		f.value:SetPoint("LEFT", f, "LEFT", 0, 0)

		f.texture = f:CreateTexture(nil, "ARTWORK")
		f.texture:SetWidth(MONEY_ICON_WIDTH_SMALL)
		f.texture:SetHeight(MONEY_ICON_WIDTH_SMALL)
		f.texture:SetPoint("LEFT", f.value, "RIGHT", 0, 0)

		if p then
			f:SetPoint("LEFT", p, "RIGHT", 4, 0)
		end

		table.insert(tooltip.alt, f)
		p = f
	end
end

function TooltipExchangePrices:ClearAltCurrency(tooltip)
	if not tooltip.alt then
		return
	end

	for i = 1, MAX_ALT_CURRENCY do
		tooltip.alt[i]:Hide()
	end
end

function TooltipExchangePrices:SetAltCurrency(tooltip, info)
	self:AddAltCurrencyControls(tooltip)

	local i = 1

	if info.buy then
		local gold = math.floor(info.buy / (COPPER_PER_SILVER * SILVER_PER_GOLD))
		local silver = math.floor((info.buy - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
		local copper = math.fmod(info.buy, COPPER_PER_SILVER)

		local f = tooltip.alt[i]
		f.value:SetText(gold)
		f.texture:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
		f.texture:SetTexCoord(0, 0.25, 0, 1)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1

		local f = tooltip.alt[i]
		f.value:SetText(silver)
		f.texture:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
		f.texture:SetTexCoord(0.25, 0.5, 0, 1)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1

		local f = tooltip.alt[i]
		f.value:SetText(copper)
		f.texture:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
		f.texture:SetTexCoord(0.5, 0.75, 0, 1)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1
	end

	if info.alliance then
		local f = tooltip.alt[i]
		f.value:SetText(info.alliance)
		f.texture:SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance")
		f.texture:SetTexCoord(0, MONEY_ICON_WIDTH_SMALL / 24, 0, MONEY_ICON_WIDTH_SMALL / 24)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1
	end

	if info.horde then
		local f = tooltip.alt[i]
		f.value:SetText(info.horde)
		f.texture:SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde")
		f.texture:SetTexCoord(0, MONEY_ICON_WIDTH_SMALL / 24, 0, MONEY_ICON_WIDTH_SMALL / 24)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1
	end

	if info.arena then
		local f = tooltip.alt[i]
		f.value:SetText(info.arena)
		f.texture:SetTexture("Interface\\PVPFrame\\PVP-ArenaPoints-Icon")
		f.texture:SetTexCoord(0, 1, 0, 1)
		f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
		f:Show()
		i = i + 1
	end

	if info.items then
		for _, item in ipairs(info.items) do
			local f = tooltip.alt[i]
			f.value:SetText(item.value)
			f.texture:SetTexture(item.texture)
			f.texture:SetTexCoord(0, 1, 0, 1)
			f:SetWidth(f.value:GetStringWidth() + MONEY_ICON_WIDTH_SMALL)
			f:Show()
			i = i + 1

			if i > MAX_ALT_CURRENCY then
				break
			end
		end
	end

	for j = i, MAX_ALT_CURRENCY do
		tooltip.alt[j]:Hide()
	end

	if i > 1 then
		tooltip:AddLine(L["Buy price:"], 1, 1, 1)

		tooltip.alt[1]:ClearAllPoints()
		tooltip.alt[1]:SetPoint("LEFT", tooltip:GetName() .. "TextLeft" .. tooltip:NumLines(), "RIGHT", 4, 0)
	end
end

function TooltipExchangePrices:BuildStaticMenu()
	local a = TooltipExchangePrices.options.tokens.args

	for i, token in ipairs(tokens) do
		a[string.gsub(token.name, "[^%w]", "")] = {
			type = "execute",
			name = ITEM_QUALITY_COLORS[token.color].hex .. token.name .. "|r",
			desc = string.format(L["Display items purchased for %s."], token.name),
			icon = token.texture,
			func = function() self:ShowItemsByToken(token.texture) dewdrop:Close() end,
			order = 100 + i,
		}
	end
end
