local ItemDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB")
local LibInventory = LibStub("LibInventory-2.1")

local _G = getfenv(0)
local select = _G.select

local filter = {}

local filter_type
local filter_subtype
local filter_equiplocation

filter.name = "Types"

function filter:GetFilterData()
	local filterdata = LibInventory:GetTypesTables()
	return filterdata
end

function filter:PrepareFilter(filterset)
	if filterset.name ~= self.name then return false end
	filter_type = filterset[0]
	filter_subtype = filterset[1]
	filter_equiplocation = filterset[2]
	return true
end

function filter:CleanupFilter()
	filter_type = nil
	filter_subtype = nil
	filter_equiplocation = nil
end

function filter:TestItem(item, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture)
	itemEquipLoc = _G[itemEquipLoc]
	if (not itemType or itemType == "") then
		itemType = LibInventory.LOCALE_INVTYPE_OTHER
	end
	if (not itemSubType or itemSubType == "") then
		itemSubType = LibInventory.LOCALE_INVTYPE_OTHER
	end
	if (not itemEquipLoc or itemEquipLoc == "") then
		itemEquipLoc = LibInventory.LOCALE_INVTYPE_OTHER
	end
	if (not filter_type or itemType == filter_type) and (not filter_subtype or itemSubType == filter_subtype) and (not filter_equiplocation or itemEquipLoc == filter_equiplocation) then
		return true
	else
		return false
	end
end

function filter:TestSpell(id, spellName, spellRank, spellTexture)
	return false
end

ItemDB:RegisterFilter(filter)