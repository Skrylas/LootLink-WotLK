local ItemDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB")
local PT = LibStub("LibPeriodicTable-3.1")

local _G = getfenv(0)
local ipairs	= _G.ipairs
local pairs		= _G.pairs
local select	= _G.select
local type		= _G.type

local string_match	= _G.string.match
local table_insert	= _G.table.insert
local table_sort	= _G.table.sort

local filter = {}

filter.name = "PeriodicTable"

local PT_tree
local PT_filterset
local PT_mastersets = { }

local function AddPTData(list, set)
	local iter, t = PT:IterateSet(set)
	local x, y, z
	repeat
		x, y, z = iter(t)
		if x and not list[x] then list[x] = true end
	until not z
end

local function GrowTree(tree, s)
	local key, rest = string_match(s, "^([^%.]+).?(.*)$")
--~ 	print(key, rest)
	if rest and rest ~= "" then
		tree[key] = tree[key] or {}
		GrowTree(tree[key], rest)
	else
		tree[key] = tree[key] or true
	end
end

local function SortTree(tree)
	local tsort = {}
	for k, v in pairs(tree) do
		table_insert(tsort, k)
		if type(v) == "table" then
			SortTree(v)
		end
	end
	table_sort(tsort)
	tree[1] = tsort
end

function filter:GetFilterData()
	if not PT_tree then
		for i = 1, GetNumAddOns() do
			local metadata = GetAddOnMetadata(i, "X-PeriodicTable-3.1-Module")
			if metadata then
				local name, _, _, enabled = GetAddOnInfo(i)
				if enabled then
					LoadAddOn(name)
				end
			end
		end

		PT_tree = {}
		for set in pairs(PT.sets) do
			local masterset = string_match(set, "^([^%.]+)")
			if masterset then
				PT_mastersets[masterset] = true
			end
		end
		for masterset in pairs(PT_mastersets) do
			local t = PT:GetSetTable(masterset)
			for _, v in pairs(t) do
				if v.set then
					GrowTree(PT_tree, v.set)
				end
			end
		end
		SortTree(PT_tree)
	end
	return PT_tree
end

function filter:PrepareFilter(filterset)
	if filterset.name ~= self.name then return false end

	local setname = filterset[0] or ""
	local filterset_index = 1
	while filterset[filterset_index] do
		setname = setname.."."..filterset[filterset_index]
		filterset_index = filterset_index + 1
	end
	PT_filterset = {}
	if setname == "" then
		for masterset in ipairs(PT_mastersets) do
			AddPTData(PT_filterset, masterset)
		end
	else
		AddPTData(PT_filterset, setname)
	end
	return true
end

function filter:CleanupFilter()
	PT_filterset = nil
end

function filter:TestItem(id, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture)
	return not not PT_filterset[id]
end

function filter:TestSpell(id, spellName, spellRank, spellTexture)
	return not not PT_filterset[-id]
end

ItemDB:RegisterFilter(filter)