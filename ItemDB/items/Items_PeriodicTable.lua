local ItemDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB")
local PT = LibStub("LibPeriodicTable-3.1")

local _G = getfenv(0)

local string_match	= _G.string.match

local items = {}

items.name = "PeriodicTable"

items.filterset = { name = "PeriodicTable" }

local PT_unique = 0
local PT_unique_list
local PT_mastersets = {}

local function AddPTData(list, set)
	local unique_added = 0
	local iter, t = PT:IterateSet(set)
	repeat
		x, y, z = iter(t)
		if x and not list[x] then
			list[x] = true
			unique_added = unique_added + 1
		end
	until not z
	return unique_added
end

function items:GetItemList(filterset)
	if not PT_unique_list then
		for i = 1, GetNumAddOns() do
			local metadata = GetAddOnMetadata(i, "X-PeriodicTable-3.1-Module")
			if metadata then
				local name, _, _, enabled = GetAddOnInfo(i)
				if enabled then
					LoadAddOn(name)
				end
			end
		end

		PT_unique_list = {}
		PT_unique = 0
		for set in pairs(PT.sets) do
			local masterset = string_match(set, "^([^%.]+)")
			if masterset then
				PT_mastersets[masterset] = true
			end
		end
		for masterset in pairs(PT_mastersets) do
			PT_unique = PT_unique + AddPTData(PT_unique_list, masterset)
		end
	end
	if filterset.name == "PeriodicTable" then
		local setname = filterset[0] or ""
		local filterset_index = 1
		while filterset[filterset_index] do
			setname = setname.."."..filterset[filterset_index]
			filterset_index = filterset_index + 1
		end
		if setname == "" then
			return PT_unique_list, PT_unique, true
		else
			local setlist = {}
			AddPTData(setlist, setname)
			return setlist, PT_unique, true
		end
	else
		return PT_unique_list, PT_unique, false
	end
end

ItemDB:RegisterItemProvider(items)