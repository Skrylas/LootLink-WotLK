local ItemDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB")
local LibInventory = LibStub("LibInventory-2.1")

local items = {}

items.name = "Cache"

items.filterset = { name = "Types" }

function items:GetItemList(filterset)
	local itemlist = LibInventory:GetItems()
	local items_known = LibInventory:GetCounts()
	return itemlist, items_known, false
end

ItemDB:RegisterItemProvider(items)