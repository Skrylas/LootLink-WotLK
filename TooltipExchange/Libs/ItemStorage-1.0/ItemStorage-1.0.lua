
--[[
Name: ItemStorage-1.0
Revision: $Rev: 29951 $
Author(s): Usz
Description: Item storage library.
Dependencies: AceLibrary
]]

local major, minor = "ItemStorage-1.0", "$Revision: 29951 $"

if not AceLibrary then error(major .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(major, minor) then return end

local tooltip = CreateFrame("GameTooltip", "ItemStorage_Tooltip" .. string.sub("$Revision: 29951 $", 12, -3), UIParent, "GameTooltipTemplate")

local lib = {}

---------------------------------------------------------------------
-- Localization
---------------------------------------------------------------------

local L_SET, L_SOCKETBONUS, L_REQUIRESLEVEL, L_SOCKET, L_REDSOCKET, L_YELLOWSOCKET, L_BLUESOCKET, L_METASOCKET, L_CLASS, L_CLASSPATTERN, L_PARTS

if GetLocale() == "xxXX" then

else -- enUS
	L_SET = "Set:"
	L_SOCKETBONUS = "^Socket Bonus"
	L_REQUIRESLEVEL = "Requires Level (%d+)"
	L_SOCKET = "^%a+ Socket$"
	L_REDSOCKET = "Red Socket"
	L_YELLOWSOCKET = "Yellow Socket"
	L_BLUESOCKET = "Blue Socket"
	L_METASOCKET = "Meta Socket"
	L_CLASS = "^Class"
	L_CLASSPATTERN = "^Class.*%s"
	L_PARTS = "^  "
end

---------------------------------------------------------------------
-- Locals
---------------------------------------------------------------------

local function PackString(storage, value, flag, readOnly)
	local i

	if not storage[flag][value] and not readOnly then
		i = storage[flag .. "c"] + 1
		storage[flag][value] = i
		storage[flag .. "c"] = i
	else
		i = storage[flag][value]
	end

	if not i and readOnly then
		i = -1
	end

	return i
end

local function UnpackString(storage, id, flag)
	local value

	for k, v in pairs(storage[flag]) do
		if v == id then
			value = k
			break
		end
	end

	return value
end

local patterns = {
	{ pattern = "^[^%d]*%d+%.%d+[^%d]*$", capture = "(%d+%.%d+)" },
	{ pattern = "^[^%d]*%d+[^%d]*$", capture = "(%d+)" },
}

local function ParseLine(line)
	local s, e, m = nil, nil, nil

	for _, p in ipairs(patterns) do
		if string.find(line, p.pattern) then
			if p.capture then
				s, e, m = string.find(line, p.capture)
				m = tonumber(m)
				break
			else
				m = ""
				break
			end
		end
	end

	if type(m) == "number" then
		local p = string.sub(line, 1, s - 1) .. "{0}" .. string.sub(line, e + 1)
		return p, tonumber(m)
	elseif type(m) == "string" then
		return line, 0
	else
		return line, nil
	end
end

local function BuildTooltipString(storage, item)
	if item.l then
		local a = {}

		for _, l in ipairs(item.l) do
			if type(l) == "string" then
				table.insert(a, l)
			else
				local s = string.gsub(UnpackString(storage, l, "p"), "{0}", item.a[l])
				table.insert(a, s)
			end
		end

		return table.concat(a, "»")
	end

	return ""
end

---------------------------------------------------------------------
-- Storage operations
---------------------------------------------------------------------

function lib:CreateStorage()
	return {
		p = {}, pc = 0,
		i = {}, ic = 0,
	}
end

function lib:HasItem(storage, itemID)
	return storage.i[itemID] and true or false
end

function lib:AddItem(storage, itemID)
	local n, _, c, x, _, t, s, _, e, o = GetItemInfo(itemID)

	if not n or t == "Recipe" then
		return
	end

	local item

	if storage.i[itemID] then
		item = storage.i[itemID]

		for k, v in pairs(item) do
			if type(v) ~= "table" then
				item[k] = nil
			end
		end

		if item.l then
			while #(item.l) > 0 do
				table.remove(item.l)
			end
		end

		if item.a then
			for k, _ in pairs(item.a) do
				item.a[k] = nil
			end
		end
	else
		item = {}
	end

	item.i = itemID
	item.n = n
	item.c = c
	item.t = t
	item.s = s
	item.e = e
	item.o = o and string.gsub(o, "Interface\\Icons\\", "{0}") or nil
	item.x = x

	tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	tooltip:SetHyperlink(string.format("item:%d", itemID))

	if not item.l and tooltip:NumLines() > 1 then
		item.l = {}
	end

	for i = 2, tooltip:NumLines() do
		local f, line = nil, ""

		f = getglobal(tooltip:GetName() .. "TextLeft" .. i)
		if f and f:IsShown() and f:GetText() then
			line = f:GetText()
		end

		f = getglobal(tooltip:GetName() .. "TextRight" .. i)
		if f and f:IsShown() and f:GetText() then
			line = line .. "·" .. f:GetText()
		end

		line = string.gsub(string.gsub(string.gsub(line, "^(.+) %(%d+/(%d+)%)$", "%1 (0/%2)"), "\10", ""), "\13", "")

		if not string.find(line, L_SET) and not string.find(line, L_PARTS) then
			if string.gsub(line, "%s+", "") == "" then
				table.insert(item.l, "")
			else
				local p, v = ParseLine(line)

				if type(v) == "nil" then
					table.insert(item.l, p)
				else
					if not item.a then
						item.a = {}
					end

					local a = PackString(storage, p, "p")

					item.a[a] = v
					table.insert(item.l, a)
				end
			end
		end
	end

	if item.l then
		while item.l[#(item.l)] == "" do
			table.remove(item.l, #(item.l))
		end
	end

	if not storage.i[itemID] then
		storage.ic = storage.ic + 1
	end

	storage.i[itemID] = item

	return item
end

function lib:RemoveItem(storage, itemID)
	if storage.i[itemID] then
		storage.i[itemID] = nil
		storage.ic = storage.ic - 1
	end
end

function lib:GetItem(storage, itemID)
	return storage.i[itemID]
end

function lib:IterateItems(storage)
	local t = {}

	for k in pairs(storage.i) do
		table.insert(t, k)
	end

	local i = 0

	return function()
		i = i + 1
		local x = t[i]

		if x then
			return x, storage.i[x]
		else
			t = nil
			return nil
		end
	end, nil, nil
end

function lib:Search(storage, data)
	local t = {}

	data.n = data.n and string.lower(data.n) or nil

	if data.a then
		for _, a in pairs(data.a) do
			if a.p then
				a.a = PackString(storage, a.p, "p")
			end
		end
	end

	for k, item in pairs(storage.i) do
		local match = true

		if match and data.n and not string.find(string.lower(item.n), data.n, 1, true) then match = false end
		if match and data.c and item.c < data.c then match = false end
		if match and data.t and item.t ~= data.t then match = false end
		if match and data.s and item.s ~= data.s then match = false end
		if match and data.e and item.e ~= data.e then match = false end
		if match and data.x and item.x < data.x then match = false end

		if match and data.a then
			if not item.a then
				match = false
			else
				for _, a in pairs(data.a) do
					if a.a then
						if not item.a[a.a] then
							match = false
							break
						elseif a.v and item.a[a.a] < a.v then
							match = false
							break
						end
					end
				end
			end
		end

		if match then
			table.insert(t, k)
		end
	end

	local i = 0

	return function()
		i = i + 1
		local x = t[i]

		if x then
			return x, storage.i[x]
		else
			t = nil
			return nil
		end
	end, nil, nil
end

function lib:Similar(storage, base, typeWeigth, missingWeight, valueExponent, cutoff)
	if type(typeWeigth) ~= "number" then typeWeigth = 2.00 end
	if type(missingWeight) ~= "number" then missingWeight = 1.25 end
	if type(valueExponent) ~= "number" then valueExponent = 2.50 end
	if type(cutoff) ~= "number" then cutoff = 0.00 end

	local t = {}

	for k, item in pairs(storage.i) do
		local distance = cutoff

		if item.t ~= base.t then distance = distance + typeWeigth end
		if item.s ~= base.s then distance = distance + typeWeigth end
		if item.e ~= base.e then distance = distance + typeWeigth end

		if base.a and item.a then
			for k, v in pairs(base.a) do
				if item.a[k] then
					distance = distance - math.pow(math.min(v, item.a[k]) / math.max(v, item.a[k]), valueExponent)
				else
					distance = distance + missingWeight
				end
			end

			for k, v in pairs(item.a) do
				if not base.a[k] then
					distance = distance + missingWeight
				end
			end
		end

		if distance < 0 then
			table.insert(t, k)
		end
	end

	local i = 0

	return function()
		i = i + 1
		local x = t[i]

		if x then
			return x, storage.i[x]
		else
			t = nil
			return nil
		end
	end, nil, nil
end

function lib:Stat(storage)
	local colors = {}
	local valid, invalid = 0, 0
	local patternLength, patternedLines, unpatternedLines, unpatternedLength = 0, 0, 0, 0
	local memory = 0

	for i = 0, #(ITEM_QUALITY_COLORS) do
		colors[i] = 0
	end

	for k, v in pairs(storage.p) do
		patternLength = patternLength + string.len(k)
	end

	for itemID, item in pairs(storage.i) do
		colors[item.c] = colors[item.c] + 1

		if GetItemInfo(itemID) then
			valid = valid + 1
		else
			invalid = invalid + 1
		end

		if item.l then
			for k, v in ipairs(item.l) do
				if type(v) == "string" then
					unpatternedLines = unpatternedLines + 1
					unpatternedLength = unpatternedLength + string.len(v)
				else
					patternedLines = patternedLines + 1
				end
			end
		end

		if item.o then
			unpatternedLength = unpatternedLength + string.len(item.o)
		end
		if item.n then
			unpatternedLength = unpatternedLength + string.len(item.n)
		end
	end

	memory = storage.ic * 1300
	-- memory = storage.ic * 416 + patternedLines * 32 + unpatternedLines * 16 + patternLength + storage.pc * 32 + unpatternedLength

	return storage.ic, valid, invalid, colors, storage.pc, patternLength, patternedLines, unpatternedLines, unpatternedLength, memory
end

---------------------------------------------------------------------
-- Item functions
---------------------------------------------------------------------

function lib:GetItemID(storage, item)
	return item.i
end

function lib:GetItemName(storage, item)
	return item.n
end

function lib:GetItemRarity(storage, item)
	return item.c
end

function lib:GetItemColor(storage, item)
	return item.c and string.sub(ITEM_QUALITY_COLORS[item.c].hex, 3) or nil
end

function lib:GetItemIcon(storage, item)
	return item.o and string.gsub(item.o, "{0}", "Interface\\Icons\\") or nil
end

function lib:GetItemLink(storage, item)
	return item.c and item.i and item.n and ITEM_QUALITY_COLORS[item.c].hex .. "|Hitem:" .. item.i .. ":0:0:0:0:0:0:0|h[" .. item.n .. "]|h|r" or nil
end

function lib:GetItemColoredName(storage, item)
	return item.c and item.n and ITEM_QUALITY_COLORS[item.c].hex .. item.n .. "|r" or nil
end

function lib:GetItemLevel(storage, item)
	return item.x
end

function lib:BuildItemTooltip(storage, item, tooltip)
	tooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
	tooltip:SetText(ITEM_QUALITY_COLORS[item.c].hex .. item.n .. "|r")

	local i = 2

	for line in string.gmatch(string.gsub(BuildTooltipString(storage, item), "»»", "»~»"), "[^»]+") do
		local left, right = line, nil

		if (string.find(line, "·")) then
			_, _, left, right = string.find(line, "(.*)·(.*)")
		end

		if (left == "~") then
			tooltip:AddLine("\n", 1, 1, 1, 1, 1)
		elseif string.find(left, L_SOCKET) then
			tooltip:AddLine(left, 0.5, 0.5, 0.5, 1, 1)

			if left == L_REDSOCKET then
				tooltip:AddTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Red")
			elseif left == L_YELLOWSOCKET then
				tooltip:AddTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow")
			elseif left == L_BLUESOCKET then
				tooltip:AddTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue")
			elseif left == L_METASOCKET then
				tooltip:AddTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta")
			end
		elseif string.find(left, L_REQUIRESLEVEL) then
			local _, _, level = string.find(left, L_REQUIRESLEVEL)

			if (left and tonumber(level) > UnitLevel("player")) then
				tooltip:AddLine(left, 1, 0, 0, 1, 1)
			else
				tooltip:AddLine(left, 1, 1, 1, 1, 1)
			end
		elseif string.find(left, ":") then
			if string.find(left, L_CLASS) then
				if (string.find(left, string.format(L_CLASSPATTERN, UnitClass("player")))) then
					tooltip:AddLine(left, 1, 1, 1, 1, 1)
				else
					tooltip:AddLine(left, 1, 0, 0, 1, 1)
				end
			elseif string.find(left, L_SOCKETBONUS) then
				tooltip:AddLine(left, 0.5, 0.5, 0.5, 1, 1)
			else
				tooltip:AddLine(left, 0, 1, 0, 1, 1)
			end
		elseif string.find(left, "\"") then
			tooltip:AddLine(left, 1, 0.8235, 0, 1, 1)
		elseif string.find(left, "%(%d+/%d+%)") then
			tooltip:AddLine(left, 1, 0.8235, 0, 1, 1)
		elseif string.find(left, L_PARTS) then
			tooltip:AddLine(left, 0.5, 0.5, 0.5, 1, 1)
		else
			tooltip:AddLine(left, 1, 1, 1, 1, 1)
		end

		if (right) then
			local row = getglobal(tooltip:GetName() .. "TextRight" .. i)
			row:SetText(right)
			row:SetTextColor(1, 1, 1)
			row:Show()
		end

		i = i + 1
	end
end

---------------------------------------------------------------------
-- Ejection and Injection
---------------------------------------------------------------------

function lib:Eject(storage, itemID, item)
	local itemInfo = storage.i[itemID]

	if itemInfo then
		if type(item) == "table" then
			for k, _ in pairs(item) do
				item[k] = nil
			end

			item.i = itemInfo.i
			item.n = itemInfo.n
			item.c = itemInfo.c
			item.t = itemInfo.t
			item.s = itemInfo.s
			item.e = itemInfo.e
			item.o = itemInfo.o and string.gsub(itemInfo.o, "{0}", "Interface\\Icons\\") or nil
			item.l = BuildTooltipString(storage, itemInfo)
			item.x = itemInfo.x

			return item
		else
			return {
				i = itemInfo.i,
				n = itemInfo.n,
				c = itemInfo.c,
				t = itemInfo.t,
				s = itemInfo.s,
				e = itemInfo.e,
				o = itemInfo.o and string.gsub(itemInfo.o, "{0}", "Interface\\Icons\\") or nil,
				l = BuildTooltipString(storage, itemInfo),
				x = itemInfo.x,
			}
		end
	end
end

function lib:Inject(storage, item)
	if not storage.i[item.i] then
		storage.ic = storage.ic + 1
	end

	storage.i[item.i] = {}

	storage.i[item.i].i = item.i
	storage.i[item.i].n = item.n
	storage.i[item.i].c = item.c
	storage.i[item.i].t = item.t
	storage.i[item.i].s = item.s
	storage.i[item.i].e = item.e
	storage.i[item.i].o = item.o and string.gsub(item.o, "Interface\\Icons\\", "{0}") or nil
	storage.i[item.i].x = item.x

	if item.l ~= "" then
		storage.i[item.i].l = {}
	end

	for line in string.gmatch(string.gsub(item.l, "»»", "»~»"), "[^»]+") do
		if line == "~" then
			table.insert(storage.i[item.i].l, "")
		else
			local p, v = ParseLine(line)

			if type(v) == "nil" then
				table.insert(storage.i[item.i].l, p)
			else
				if not storage.i[item.i].a then
					storage.i[item.i].a = {}
				end

				local a = PackString(storage, p, "p")

				storage.i[item.i].a[a] = v
				table.insert(storage.i[item.i].l, a)
			end
		end
	end
end

---------------------------------------------------------------------
-- Library registration
---------------------------------------------------------------------

AceLibrary:Register(lib, major, minor)
