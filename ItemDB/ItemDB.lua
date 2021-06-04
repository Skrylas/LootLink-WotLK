-- setting upvalues

local _G				= getfenv(0)

local collectgarbage	= _G.collectgarbage
local ipairs			= _G.ipairs
local loadstring		= _G.loadstring
local max				= _G.max
local min				= _G.min
local next				= _G.next
local pairs				= _G.pairs
local select			= _G.select
local tonumber			= _G.tonumber
local type				= _G.type

local string_find		= _G.string.find
local string_gsub		= _G.string.gsub
local string_lower		= _G.string.lower
local string_match		= _G.string.match
local string_rep		= _G.string.rep

local table_insert		= _G.table.insert
local table_remove		= _G.table.remove
local table_sort		= _G.table.sort
local table_wipe		= _G.table.wipe

local GetItemCount		= _G.GetItemCount
local GetItemIcon		= _G.GetItemIcon
local GetItemInfo		= _G.GetItemInfo
local GetItemStats		= _G.GetItemStats
local GetSpellInfo		= _G.GetSpellInfo
local GetSpellLink		= _G.GetSpellLink
local UnitLevel			= _G.UnitLevel

local LibInventory = LibStub("LibInventory-2.1")

if not ITEM_QUALITY_COLORS[7] then
--~ 	ITEM_QUALITY7_DESC = "Heirloom"
	ITEM_QUALITY_COLORS[7] = { };
	ITEM_QUALITY_COLORS[7].r,
	ITEM_QUALITY_COLORS[7].g,
	ITEM_QUALITY_COLORS[7].b,
	ITEM_QUALITY_COLORS[7].hex = GetItemQualityColor(7);
end


local ItemDB = LibStub("AceAddon-3.0"):NewAddon("ItemDB", "AceConsole-3.0")

local ItemDB_Browser = _G.ItemDB_Browser

-- declaration of frame scrits
local Script_AdvancedFilters_OnShow
local Script_AdvancedFilters_OnMouseWheel
local Script_AdvancedFilterButton_OnClick
local Script_AdvancedFiltersSlider_OnValueChanged
local Script_Browser_OnShow
local Script_Filter_RarityDropDown_OnClick
local Script_Filter_RarityDropDown_OnShow
local Script_Filter_RarityDropDown_Initialize
local Script_FilterButton_OnClick
local Script_FilterDropDown_OnClick
local Script_FilterDropDown_OnShow
local Script_FilterDropDown_Initialize
local Script_FilterScrollFrame_OnVerticalScroll
local Script_ItemButton_OnClick
local Script_ItemButton_OnEnter
local Script_ItemButton_OnLeave
local Script_ItemProviderTab_OnClick
local Script_ItemScrollFrame_OnVerticalScroll
local Script_ResetButton_OnClick
local Script_SearchButton_OnClick
local Script_ToggleFilter_OnClick

local frames_filterlist = {}
local frames_advancedfilterlist = {}
local frames_advancedfilterslider = nil
local frames_itemlist = {}
local frames_itemprovidertabs = {}

local advanced_filter_active = false
local advanced_filter = {}
local advanced_filter_itemstats = {}

local itemprovider = {[1] = {}}
local itemprovider_selected

local filters = {[1] = {}}
local filterlist_names = {}
local filterlist_depth = {}
local filterset = {}

function ItemDB:OnInitialize()
	-- create additional frames
	for i = 1, 15 do
		local frame = CreateFrame("Button", "ItemDB_Browser_FilterButton"..i, ItemDB_Browser, "ItemDB_Browser_FilterButtonTemplate")
		if i == 1 then
			frame:SetPoint("TOPLEFT", 23, -105)
		else
			frame:SetPoint("TOPLEFT", frames_filterlist[i-1], "BOTTOMLEFT")
		end
		frame:SetID(i)
		frame:SetScript("OnClick", Script_FilterButton_OnClick)
		table_insert(frames_filterlist, frame)
	end
	for i = 1, 8 do
		local frame = CreateFrame("Button", "ItemDB_Browser_ItemButton"..i, ItemDB_Browser, "ItemDB_Browser_ItemButtonTemplate")
		if i == 1 then
			frame:SetPoint("TOPLEFT", 195, -110)
		else
			frame:SetPoint("TOPLEFT", frames_itemlist[i-1], "BOTTOMLEFT")
		end
		frame:SetID(i)
		frame:SetScript("OnClick", Script_ItemButton_OnClick)
		frame:SetScript("OnEnter", Script_ItemButton_OnEnter)
		frame:SetScript("OnLeave", Script_ItemButton_OnLeave)
		_G["ItemDB_Browser_ItemButton"..i.."Item"]:EnableMouse(false)
		table_insert(frames_itemlist, frame)
	end
	
	self:AdvancedFilter_Initialize()
	
	-- set other frame scripts
	ItemDB_Browser_ResetButton:SetScript("OnClick", Script_ResetButton_OnClick)
	ItemDB_Browser_SearchButton:SetScript("OnClick", Script_SearchButton_OnClick)
	ItemDB_Browser:SetScript("OnShow", Script_Browser_OnShow)
	ItemDB_Browser:SetScript("OnMouseDown", Script_Browser_OnMouseDown)
	ItemDB_Browser:SetScript("OnMouseUp", Script_Browser_OnMouseUp)
	ItemDB_Browser_AdvancedFilters:SetScript("OnShow", Script_AdvancedFilters_OnShow)
	ItemDB_Browser_AdvancedFiltersCloseButton:SetScript("OnClick", Script_ToggleFilter_OnClick)
	ItemDB_Browser_FilterDropDown:SetScript("OnShow", Script_FilterDropDown_OnShow)
	ItemDB_Browser_Filter_RarityDropDown:SetScript("OnShow", Script_Filter_RarityDropDown_OnShow)
	ItemDB_Browser_FilterScrollFrame:SetScript("OnVerticalScroll", Script_FilterScrollFrame_OnVerticalScroll)
	ItemDB_Browser_ItemScrollFrame:SetScript("OnVerticalScroll", Script_ItemScrollFrame_OnVerticalScroll)
	ItemDB_Browser_Sort_Rarity:SetScript("OnClick", function() ItemDB:SetSorting("rarity") end)
	ItemDB_Browser_Sort_Name:SetScript("OnClick", function() ItemDB:SetSorting("name") end)
	ItemDB_Browser_Sort_MinLevel:SetScript("OnClick", function() ItemDB:SetSorting("minlevel") end)
	ItemDB_Browser_Sort_ItemLevel:SetScript("OnClick", function() ItemDB:SetSorting("itemlevel") end)
	ItemDB_Browser_Sort_Value:SetScript("OnClick", function() ItemDB:SetSorting("value") end)
	ItemDB_Browser_ToggleFilterButton:SetScript("OnClick", Script_ToggleFilter_OnClick)
	table_insert(UISpecialFrames, "ItemDB_Browser")

	-- set localized strings

	LibInventory.RegisterCallback(self, "LibInventory_StatusChanged", "LibInventory_StatusChanged")
	LibInventory.RegisterCallback(self, "LibInventory_TypesUpdated", "LibInventory_TypesUpdated")
--	if (LibInventory:GetStatus() ~= LibInventory.STATUS_READY) then
--		ItemDB_Browser_SearchButton:Disable()
--		ItemDB_Browser_ResetButton:Disable()
--	end

	-- register chat command
	self:RegisterChatCommand("itemdb", "ToggleBrowser", true)
end

-- function ItemDB:OnEnable()
-- end

-- function ItemDB:OnDisable()
-- end

function ItemDB:ToggleBrowser()
	if ItemDB_Browser:IsShown() then
		ItemDB_Browser:Hide()
	else
		ItemDB_Browser:Show()
	end
end

function ItemDB:LibInventory_StatusChanged(callback, newstatus)
--	if (newstatus == LibInventory.STATUS_READY) then
--		ItemDB_Browser_SearchButton:Enable()
--		ItemDB_Browser_ResetButton:Enable()
--	end
end

function ItemDB:LibInventory_TypesUpdated(callback)
	if (filterset.name) then
		self:FilterList_Create()
		self:FilterList_Update()
	end
end



-- -----
-- Item Provider Functions
-- -----

function ItemDB:RegisterItemProvider(items)
	if not items.name or itemprovider[items.name] then return false end
	itemprovider[items.name] = items
	
	itemprovider[1] = nil
	local keysort = {}
	for k in pairs(itemprovider) do
		table_insert(keysort, k)
	end
	table_sort(keysort)
	itemprovider[1] = keysort

	PanelTemplates_SetNumTabs(ItemDB_Browser, #keysort)

	for k, v in ipairs(keysort) do
		if not frames_itemprovidertabs[k] then
			local frame = CreateFrame("Button", "ItemDB_BrowserTab"..k, ItemDB_Browser, "CharacterFrameTabButtonTemplate")
			frame:SetID(k)
			if k == 1 then
				frame:SetPoint("TOPLEFT", ItemDB_Browser, "BOTTOMLEFT", 15, 11)
			else
				frame:SetPoint("TOPLEFT", frames_itemprovidertabs[k-1], "TOPRIGHT", -8, 0)
			end
			frame:SetScript("OnClick", Script_ItemProviderTab_OnClick)
			frames_itemprovidertabs[k] = frame
		end
		frames_itemprovidertabs[k]:SetText(v)
		if v == itemprovider_selected then
			PanelTemplates_SetTab(ItemDB_Browser, k)
		end
	end
end

function ItemDB:SelectItemProvider(id)
	if itemprovider[1][id] ~= itemprovider_selected then
		itemprovider_selected = itemprovider[1][id]
		PanelTemplates_SetTab(ItemDB_Browser, id)

		filterset = itemprovider[itemprovider_selected].filterset
		UIDropDownMenu_SetText(ItemDB_Browser_FilterDropDown, filterset.name)
		self:FilterList_Create()
		self:FilterList_Update()

		self:ResetItemList()
	end
end

function ItemDB:SelectItemProviderByName(name)
	for k, v in ipairs(itemprovider[1]) do
		if v == name then
			self:SelectItemProvider(k)
			return
		end
	end
end


-- -----
-- Filter Functions
-- -----

function ItemDB:RegisterFilter(filter)
	if not filter.name or filters[filter.name] then return false end
	filters[filter.name] = filter
	
	filters[1] = nil
	local keysort = {}
	for k in pairs(filters) do
		table_insert(keysort, k)
	end
	table_sort(keysort)
	filters[1] = keysort
end

function ItemDB:SelectFilterByName(name)
	if filterset.name ~= name then
		filterset.name = name
		UIDropDownMenu_SetText(ItemDB_Browser_FilterDropDown, name)
		local filterset_index = 0
		while filterset[filterset_index] do
			filterset[filterset_index] = nil
			filterset_index = filterset_index + 1
		end
		self:FilterList_Create()
		self:FilterList_Update()
	end
end



-- -----
-- Filter List Functions
-- -----

local function IsRelevantSubtree(t)
	if type(t) ~= "table" or #t[1] == 0 then
		return false
--~ 	elseif #t[1] > 1 then
--~ 		return true
--~ 	else
--~ 		local child = t[t[1][1]]
--~ 		return IsRelevantSubtree(child)
	end
	return true
end

local function CreateFilterListLevel(filterdata, depth)
	for fdk, fdv in ipairs(filterdata[1]) do
		table_insert(filterlist_names, fdv)
		table_insert(filterlist_depth, depth)
		if filterset[depth] == fdv and IsRelevantSubtree(filterdata[fdv]) then
			CreateFilterListLevel(filterdata[fdv], depth + 1)
		end
	end
end

function ItemDB:FilterList_Create()
	local filterdata = filters[filterset.name]:GetFilterData()

	for i = #filterlist_names, 1, -1 do
		filterlist_names[i] = nil
		filterlist_depth[i] = nil
	end
	CreateFilterListLevel(filterdata, 0)
end

function ItemDB:FilterList_Update()
	local offset = FauxScrollFrame_GetOffset(ItemDB_Browser_FilterScrollFrame)
	local num_filters = #filterlist_names
	if offset + 15 > num_filters then
		offset = (num_filters - 15) >= 0 and (num_filters - 15) or 0
		FauxScrollFrame_SetOffset(ItemDB_Browser_FilterScrollFrame, offset)
	end
	
	for i=1, 15 do
		local button = frames_filterlist[i]
		if num_filters > 15 then
			button:SetWidth(136)
		else
			button:SetWidth(156)
		end
		local index = offset + i
		if ( index <= num_filters ) then
			local normalText = _G[button:GetName().."NormalText"]
			local normalTexture = _G[button:GetName().."NormalTexture"]

			button:SetText(string_rep("  ", filterlist_depth[index])..filterlist_names[index])
			normalText:SetPoint("LEFT", button, "LEFT", 4, 0)
			normalTexture:SetAlpha(1.0)
			if filterset[filterlist_depth[index]] == filterlist_names[index] then
				button:LockHighlight()
			else
				button:UnlockHighlight()
			end
			button:Show()
		else
			button:Hide()
		end
	end
	FauxScrollFrame_Update(ItemDB_Browser_FilterScrollFrame, num_filters, 15, 20)
end



-- -----
-- Advanced Filter
-- -----

--[[
local LI = LibStub("LibInventory-2.1")
local maxId = select(3, LI:GetCounts())
itemStatsTable = itemStatsTable or {}
itemStatsLastId = itemStatsLastId or 0
local minScan = itemStatsLastId + 1
local maxScan = math.min(maxId, itemStatsLastId + 10000)
for i = minScan, maxScan do
   if LI:IsValidItem(i) then
      GetItemStats("item:"..i, itemStatsTable)
   end
   itemStatsLastId = i
end
print (itemStatsLastId)
if (itemStatsLastId == maxId) then
   for k, v in pairs(itemStatsTable) do
      print(k, v)
   end
end
]]

local advanced_filters = {
	"ITEM_MOD_STRENGTH_SHORT",
	"ITEM_MOD_AGILITY_SHORT",
	"ITEM_MOD_STAMINA_SHORT",
	"ITEM_MOD_INTELLECT_SHORT",
	"ITEM_MOD_SPIRIT_SHORT",
	"ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
-- 	"ITEM_MOD_ATTACK_POWER_SHORT",
	"ITEM_MOD_MELEE_ATTACK_POWER_SHORT",
	"ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
	"ITEM_MOD_SPELL_POWER_SHORT",
	"ITEM_MOD_SPELL_DAMAGE_DONE_SHORT",
	"ITEM_MOD_SPELL_HEALING_DONE_SHORT",
	"ITEM_MOD_PVP_POWER_SHORT",
	"ITEM_MOD_CRIT_RATING_SHORT",
	"ITEM_MOD_CRIT_RANGED_RATING_SHORT",
	"ITEM_MOD_EXPERTISE_RATING_SHORT",
	"ITEM_MOD_HASTE_RATING_SHORT",
	"ITEM_MOD_HIT_RATING_SHORT",
	"ITEM_MOD_MASTERY_RATING_SHORT",
--	"ITEM_MOD_SPELL_PENETRATION_SHORT", -- missing in 5.4
	"ITEM_MOD_DODGE_RATING_SHORT",
	"ITEM_MOD_PARRY_RATING_SHORT",
	"ITEM_MOD_RESILIENCE_RATING_SHORT",
	"ITEM_MOD_HEALTH_REGEN_SHORT",
	"ITEM_MOD_MANA_SHORT",
	"RESISTANCE0_NAME", -- Armor
	"RESISTANCE1_NAME", -- Holy Resistance
	"RESISTANCE2_NAME", -- Fire Resistance
	"RESISTANCE3_NAME", -- Nature Resistance
	"RESISTANCE4_NAME", -- Frost Resistance
	"RESISTANCE5_NAME", -- Shadow Resistance
	"RESISTANCE6_NAME", -- Arcane Resistance
-- 	"ITEM_MOD_ARCANE_RESISTANCE_SHORT",
-- 	"ITEM_MOD_FIRE_RESISTANCE_SHORT",
-- 	"ITEM_MOD_FROST_RESISTANCE_SHORT",
-- 	"ITEM_MOD_NATURE_RESISTANCE_SHORT",
-- 	"ITEM_MOD_SHADOW_RESISTANCE_SHORT",
	"EMPTY_SOCKET_META",
	"EMPTY_SOCKET_RED",
	"EMPTY_SOCKET_YELLOW",
	"EMPTY_SOCKET_BLUE",
	"EMPTY_SOCKET_PRISMATIC",
	"EMPTY_SOCKET_COGWHEEL",
	"EMPTY_SOCKET_HYDRAULIC",
-- 	"_SHORT",
}

local filter_conversion = {
	["ITEM_MOD_ATTACK_POWER_SHORT"] = {"ITEM_MOD_MELEE_ATTACK_POWER_SHORT", "ITEM_MOD_RANGED_ATTACK_POWER_SHORT"},
	["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = "RESISTANCE6_NAME",
	["ITEM_MOD_FIRE_RESISTANCE_SHORT"] = "RESISTANCE2_NAME",
	["ITEM_MOD_FROST_RESISTANCE_SHORT"] = "RESISTANCE4_NAME",
	["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = "RESISTANCE3_NAME",
	["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = "RESISTANCE5_NAME",
}

function ItemDB:TestAdvancedFilter(itemLink)
	table_wipe(advanced_filter_itemstats)
	advanced_filter_itemstats = GetItemStats(itemLink, advanced_filter_itemstats)
	for k, v in pairs(filter_conversion) do
		if advanced_filter_itemstats[k] then
			if type(v) == "table" then
				for _, v2 in pairs(v) do
					advanced_filter_itemstats[v2] = advanced_filter_itemstats[k]
				end
			else
				advanced_filter_itemstats[v] = advanced_filter_itemstats[k]
			end
		end
	end
	for k, v in pairs(advanced_filter) do
		if v == true and not advanced_filter_itemstats[k] or v == false and advanced_filter_itemstats[k] then
			return false
		end
	end
	return true
end

function ItemDB:AdvancedFilter_Initialize()
	-- create the lines
	for i = 1, 18 do
		local filterline = CreateFrame("button", nil, ItemDB_Browser_AdvancedFilters, "ItemDB_Browser_AdvancedFilterButtonTemplate")
		if i == 1 then
			filterline:SetPoint("TOPLEFT", ItemDB_Browser_AdvancedFilters, "TOPLEFT", 4, -12)
		else
			filterline:SetPoint("TOPLEFT", frames_advancedfilterlist[i-1], "BOTTOMLEFT")
		end
		filterline:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		filterline:SetScript("OnClick", Script_AdvancedFilterButton_OnClick)
		frames_advancedfilterlist[i] = filterline
	end
	-- create the slider
	local slider = CreateFrame("Slider", nil, ItemDB_Browser_AdvancedFilters)
	slider:SetOrientation("VERTICAL")
	slider:SetPoint("TOPRIGHT", ItemDB_Browser_AdvancedFilters, "TOPRIGHT", -10, -28)
	slider:SetPoint("BOTTOMRIGHT", ItemDB_Browser_AdvancedFilters, "BOTTOMRIGHT", -10, 8)
	slider:SetBackdrop({
		["bgFile"] = [[Interface\Buttons\UI-SliderBar-Background]],
		["edgeFile"] = [[Interface\Buttons\UI-SliderBar-Border]],
		["tile"] = true,
		["edgeSize"] = 8,
		["tileSize"] = 8,
		["insets"] = {
			["left"] = 3,
			["right"] = 3,
			["top"] = 3,
			["bottom"] = 3,
		},
	})
	slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	slider:SetMinMaxValues(0, #advanced_filters - 18)
	slider:SetValueStep(1)
	slider:SetWidth(12)
	slider:SetValue(0)
	slider:SetScript("OnValueChanged", Script_AdvancedFiltersSlider_OnValueChanged)
	frames_advancedfilterslider = slider
	ItemDB_Browser_AdvancedFilters:EnableMouseWheel(true)
	ItemDB_Browser_AdvancedFilters:SetScript("OnMouseWheel", Script_AdvancedFilters_OnMouseWheel)
end

function ItemDB:AdvancedFilter_Update()
	-- get slider offset
	-- populate the lines
	for i = 1, #frames_advancedfilterlist do
		local index = i + frames_advancedfilterslider:GetValue()
		local filter = advanced_filters[index]
		-- print(tostring(filter), tostring(_G[filter]))
		frames_advancedfilterlist[i].filter = filter
		if advanced_filter[filter] == true then
			frames_advancedfilterlist[i]:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:20:20|t|cff00ff00"..(_G[filter] or filter))
		elseif advanced_filter[filter] == false then
			frames_advancedfilterlist[i]:SetText("|TInterface\\RaidFrame\\ReadyCheck-NotReady:20:20|t|cffff0000"..(_G[filter] or filter))
		else
			frames_advancedfilterlist[i]:SetText("|TInterface\\RaidFrame\\ReadyCheck-Waiting:20:20|t|cff999999"..(_G[filter] or filter))
		end
	end
end



-- -----
-- Item List Functions
-- -----

local itemlist_filtered = {}
local filter_rarity = {[-2] = true, [-1] = true, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true}

-- sorting
local sort_settings = {
	{
		key = "rarity",
		dir = "desc",
	},
	{
		key = "name",
		dir = "asc",
	},
}

local sort_primarydir = {
	rarity = "desc",
	name = "asc",
	minlevel = "asc",
	itemlevel = "desc",
	value = "desc",
}

local sort_arrows = {
	rarity = ItemDB_Browser_Sort_Rarity_Arrow,
	name = ItemDB_Browser_Sort_Name_Arrow,
	minlevel = ItemDB_Browser_Sort_MinLevel_Arrow,
	itemlevel = ItemDB_Browser_Sort_ItemLevel_Arrow,
	value = ItemDB_Browser_Sort_Value_Arrow,
}

local sort_strings = {
	sort_initial = [[
		if a.rarity == -1 and b.rarity ~= -1 then	return false	end
		if a.rarity ~= -1 and b.rarity == -1 then	return true		end
		if a.rarity == -1 and b.rarity == -1 then
			return a.id < b.id	-- id can't be equal
		end
	]],
	sort_generic_asc = [[
		if a["$1"] and not b["$1"] then		return false	end
		if not a["$1"] and b["$1"] then		return true		end
		if a["$1"] and b["$1"] then
			if a["$1"] < b["$1"] then		return true		end
			if a["$1"] > b["$1"] then		return false	end
		end
	]],
	sort_generic_desc = [[
		if a["$1"] and not b["$1"] then		return true		end
		if not a["$1"] and b["$1"] then		return false	end
		if a["$1"] and b["$1"] then
			if a["$1"] < b["$1"] then		return false	end
			if a["$1"] > b["$1"] then		return true		end
		end
	]],
	sort_fallback = [[
		return a.id < b.id
	]],
}

local sort_sortfunction

function ItemDB:SetSorting(sort)
	if sort then
		if sort_settings[1].key == sort then
			sort_settings[1].dir = sort_settings[1].dir == "asc" and "desc" or "asc"
		else
			local t = table_remove(sort_settings)
			t.key = sort
			t.dir = sort_primarydir[sort]
			table_insert(sort_settings, 1, t)
		end
	end

	for sorttype, arrow in pairs(sort_arrows) do
		if sorttype == sort_settings[1].key then
			if sort_settings[1].dir == "asc" then
				arrow:SetTexCoord(0, 0.5625, 0, 1.0);
			else
				arrow:SetTexCoord(0, 0.5625, 1.0, 0);
			end
			arrow:SetAlpha(1)
			arrow:Show()
		elseif sorttype == sort_settings[2].key then
			if sort_settings[2].dir == "asc" then
				arrow:SetTexCoord(0, 0.5625, 0, 1.0);
			else
				arrow:SetTexCoord(0, 0.5625, 1.0, 0);
			end
			arrow:SetAlpha(0.5)
			arrow:Show()
		else
			arrow:Hide()
		end
	end

	local sortstring = sort_strings.sort_initial
	local has_sort_name = false
	for _, sortsetting in ipairs(sort_settings) do
		sortstring = sortstring .. string_gsub(sort_strings["sort_generic_"..sortsetting.dir], "$1", sortsetting.key)
		if sortsetting.key == "name" then has_sort_name = true end
	end
	if not has_sort_name then
		sortstring = sortstring .. string_gsub(sort_strings["sort_generic_asc"], "$1", "name")
	end
	sortstring = sortstring .. sort_strings.sort_fallback
	sort_sortfunction = loadstring("return function(a, b) "..sortstring.." end")()
	table_sort(itemlist_filtered, sort_sortfunction)
	self:ItemList_Update()
end

function ItemDB:ItemList_Update()
	local offset = FauxScrollFrame_GetOffset(ItemDB_Browser_ItemScrollFrame)
	local num_items = #itemlist_filtered
	if offset + 8 > num_items then
		offset = (num_items - 8) >= 0 and (num_items - 8) or 0
		FauxScrollFrame_SetOffset(ItemDB_Browser_ItemScrollFrame, offset)
	end
	
	local player_level = UnitLevel("player")

	for i=1, 8 do
		local index = offset + i
		local button = frames_itemlist[i]
		if ( index <= num_items ) then
			local itemdata = itemlist_filtered[index]

			local buttonName = button:GetName()
			local button_highlight = _G[buttonName.."Highlight"]
			local iconTexture = _G[buttonName.."ItemIconTexture"]
			local itemCount = _G[buttonName.."ItemCount"]
			local itemStack = _G[buttonName.."ItemStack"]
			local itemName = _G[buttonName.."Name"]
			local itemMinLevel = _G[buttonName.."MinLevel"]
			local itemItemLevel = _G[buttonName.."ItemLevel"]
			local moneyFrame = _G[buttonName.."MoneyFrame"]
			local unsellableText = _G[buttonName.."UnsellableText"]

			if itemdata.type == "item" then
				-- Set item texture, count, and usability
				iconTexture:SetTexture(GetItemIcon(itemdata.id) or "Interface\\Icons\\INV_Misc_QuestionMark")
	--~ 			if cur_item["safe"] then
					iconTexture:SetVertexColor(1.0, 1.0, 1.0)
	--~ 			else
	--~ 				iconTexture:SetVertexColor(1.0, 0.1, 0.1)
	--~ 			end
				local count = GetItemCount(itemdata.id, true)
				if count > 0 then
					itemCount:SetText(count < 1000 and count or "inf")
					itemCount:Show()
				else
					itemCount:Hide()
				end
				local stack = itemdata.stack
				if stack and stack > 1 then
					itemStack:SetText(stack < 1000 and stack or "inf")
					itemStack:Show()
				else
					itemStack:Hide()
				end

				-- Set name and quality color
				local color = ITEM_QUALITY_COLORS[itemdata.rarity]
				itemName:SetText(itemdata.name)
				itemName:SetVertexColor(color.r, color.g, color.b)

				-- Set level frames
				if itemdata.minlevel then
					if itemdata.minlevel > player_level then
						itemMinLevel:SetText(RED_FONT_COLOR_CODE..itemdata.minlevel..FONT_COLOR_CODE_CLOSE)
					else
						itemMinLevel:SetText(itemdata.minlevel)
					end
					itemMinLevel:Show()
				else
					itemMinLevel:Hide()
				end
				if itemdata.itemlevel then
					itemItemLevel:SetText(itemdata.itemlevel)
					itemItemLevel:Show()
				else
					itemItemLevel:Hide()
				end

				-- Set money frame
				local value = itemdata.value
				-- If not bidAmount set the bid amount to the min bid
				if ( value and value > 0 ) then
					MoneyFrame_Update(moneyFrame:GetName(), value)
					moneyFrame:Show()
					unsellableText:Hide()
				elseif ( value and value == 0 ) then
					moneyFrame:Hide()
					unsellableText:Show()
				else
					moneyFrame:Hide()
					unsellableText:Hide()
				end
			else --type == "spell"
				local spellIcon = select(3, GetSpellInfo(itemdata.id))
				iconTexture:SetTexture(spellIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
				itemCount:Hide()
				itemStack:Hide()
				itemName:SetText("|cff71d5ff"..itemdata.name..FONT_COLOR_CODE_CLOSE)
				itemName:SetVertexColor(113, 213, 255)
				itemMinLevel:Hide()
				itemItemLevel:Hide()
				moneyFrame:Hide()
				unsellableText:Hide()
			end

			if num_items > 8 then
				button:SetWidth(600)
				button_highlight:SetWidth(562)
			else
				button:SetWidth(625)
				button_highlight:SetWidth(589)
			end
			button:Show()
		else
			button:Hide()
		end
	end
	FauxScrollFrame_Update(ItemDB_Browser_ItemScrollFrame, num_items, 8, 37)
end

local searchOnUpdate = function()
	ItemDB:SearchStep()
end
local searchId = nil              -- current/last checked id
local searchItemList = nil
local searchItemListDone = nil
local searchItemListSize = nil
local searchFilterName = nil      -- name to match against
local searchFilterMinLevel = nil  -- minimal level requirement
local searchFilterMaxLevel = nil  -- maximal level requirement
local searchFilterMinILevel = nil -- minimal item level requirement
local searchFilterMaxILevel = nil -- maximal item level requirement
local searchPrefiltered = nil
local searchFilter = nil
function ItemDB:Search()
	ItemDB_Browser_ItemCount:SetText("searching...")
	ItemDB_Browser_SearchButton:Disable()
	ItemDB_Browser_ResetButton:Disable()

	-- clear the item table
	table_wipe(itemlist_filtered)
	self:ItemList_Update()

	searchFilterName = string_lower(ItemDB_Browser_Filter_Name:GetText())

	-- check if they are looking up an item/spell by ID
	searchId = string_match(searchFilterName, "^item:(%-?%d+)")
	if searchId then
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(searchId)
		local itemtable = {
			["id"]			= searchId,
			["type"]		= "item",
			["name"]		= itemName			or "item:"..searchId,
			["rarity"]		= itemRarity or -1,
			["itemlevel"]	= itemLevel,
			["minlevel"]	= itemMinLevel,
			["stack"]		= itemStackCount,
			["value"]		= itemSellPrice,
		}
		table_insert(itemlist_filtered, itemtable)
		ItemDB_Browser_ItemCount:SetText("lookup by id")
		self:SearchDone()
		return
	end
	searchId = string_match(searchFilterName, "^spell:(%-?%d+)")
	if searchId then
		local spellName, spellRank, spellTexture = GetSpellInfo(searchId)
		local itemtable = {
			["id"]			= searchId,
			["type"]		= "spell",
			["name"]		= spellName			or "spell:"..searchId,
			["rarity"]		= nil,
			["itemlevel"]	= nil,
			["minlevel"]	= nil,
			["stack"]		= nil,
			["value"]		= nil,
		}
		table_insert(itemlist_filtered, itemtable)
		ItemDB_Browser_ItemCount:SetText("lookup by id")
		self:SearchDone()
		return
	end

	local itemprovider = itemprovider[itemprovider_selected]
	searchItemList, searchItemListSize, searchPrefiltered = itemprovider:GetItemList(filterset)
	searchItemListDone = 0
	if searchPrefiltered then
		searchFilter = nil
	else
		searchFilter = filters[filterset.name]
		searchFilter:PrepareFilter(filterset)
	end
	
	searchFilterMinLevel = tonumber(ItemDB_Browser_Filter_MinLevel:GetText())
	searchFilterMaxLevel = tonumber(ItemDB_Browser_Filter_MaxLevel:GetText())
	searchFilterMinILevel = tonumber(ItemDB_Browser_Filter_MinILevel:GetText())
	searchFilterMaxILevel = tonumber(ItemDB_Browser_Filter_MaxILevel:GetText())
	
	-- self:SearchStep()
	ItemDB_Browser:SetScript("OnUpdate", searchOnUpdate)
end

function ItemDB:SearchStep()
	local searchCountStep = 1

	searchId = next(searchItemList, searchId)
	while searchId do
		local id = searchId
		local id_numeric = tonumber(id)
		local id_type
		if id_numeric then
			if id_numeric < 0 then
				id = -id_numeric
				id_type = "spell"
			else
				id = id_numeric
				id_type = "item"
			end
		else
			id_type = string_match(id, "^item:") and "item" or "spell"
			id = string_match(id, "^item:(%-?%d+)") or string_match(id, "^spell:(%-?%d+)")
		end
		if id_type == "item" then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
			itemRarity = itemRarity or -1
			if	filter_rarity[itemRarity] and (itemRarity < 0 or (		-- rarity / uncached
					(not searchFilterMinLevel or itemMinLevel >= searchFilterMinLevel)
				and (not searchFilterMaxLevel or itemMinLevel <= searchFilterMaxLevel)
				and (not searchFilterMinILevel or itemLevel >= searchFilterMinILevel)
				and (not searchFilterMaxILevel or itemLevel <= searchFilterMaxILevel)
				and (searchFilterName == "" or string_match(string_lower(itemName), searchFilterName))
				and (searchPrefiltered or searchFilter:TestItem(id, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture))
				and (not advanced_filter_active or self:TestAdvancedFilter(itemLink))
			  )) then
				local itemtable = {
					["id"]			= id,
					["type"]		= "item",
					["name"]		= itemName			or "item:"..id,
					["rarity"]		= itemRarity,
					["itemlevel"]	= itemLevel,
					["minlevel"]	= itemMinLevel,
					["stack"]		= itemStackCount,
					["value"]		= itemSellPrice,
				}
				table_insert(itemlist_filtered, itemtable)
			end
		else -- id_type == "spell"
			local spellName, spellRank, spellTexture = GetSpellInfo(id)
			if filter_rarity[-2]
				and (not spellName or searchFilterName == "" or string_match(string_lower(spellName), searchFilterName))
				and (searchPrefiltered or searchFilter:TestSpell(id, spellName, spellRank, spellTexture))
			  then
				if spellName and spellRank and spellRank ~= "" then
					spellName = spellName.." ("..spellRank..")"
				end
				local itemtable = {
					["id"]			= id,
					["type"]		= "spell",
					["name"]		= spellName			or "spell:"..id,
					["rarity"]		= nil,
					["itemlevel"]	= nil,
					["minlevel"]	= nil,
					["stack"]		= nil,
					["value"]		= nil,
				}
				table_insert(itemlist_filtered, itemtable)
			end
		end

		searchCountStep = searchCountStep + 1
		if searchCountStep > 100 then
			searchItemListDone = searchItemListDone + searchCountStep - 1
			ItemDB_Browser_ItemCount:SetFormattedText("searching... %0.1d%%", min(searchItemListDone / searchItemListSize * 100, 100))
			return
		end

		searchId = next(searchItemList, searchId)
	end

	ItemDB_Browser:SetScript("OnUpdate", nil)
	searchItemListDone = searchItemListDone + searchCountStep - 1
	self:SearchDone()
end

function ItemDB:SearchDone()
	table_sort(itemlist_filtered, sort_sortfunction)
	ItemDB_Browser_ItemCount:SetFormattedText("%d / %d items", #itemlist_filtered, max(searchItemListDone, searchItemListSize))
	ItemDB_Browser_SearchButton:Enable()
	ItemDB_Browser_ResetButton:Enable()

	if searchFilter then
		searchFilter:CleanupFilter()
	end
	searchId = nil
	searchItemList = nil
	searchItemListDone = nil
	searchItemListSize = nil
	searchFilterName = nil
	searchFilterMinLevel = nil
	searchFilterMaxLevel = nil
	searchFilterMinILevel = nil
	searchFilterMaxILevel = nil
	searchPrefiltered = nil
	searchFilter = nil
	
	FauxScrollFrame_SetOffset(ItemDB_Browser_ItemScrollFrame, 0)
	ItemDB_Browser_ItemScrollFrameScrollBar:SetValue(0)
	self:ItemList_Update()
end

function ItemDB:QueryList()
	for _, item in ipairs(itemlist_filtered) do
		if item.type == "item" and item.rarity < 0 then -- uncached item
			LibInventory:QueryItem(item.id)
		end
	end
end

function ItemDB:Reset()
	self:ResetFilter()
	self:ResetItemList()
end

function ItemDB:ResetFilter()
	ItemDB_Browser_Filter_Name:SetText("")
	ItemDB_Browser_Filter_MinLevel:SetText("")
	ItemDB_Browser_Filter_MaxLevel:SetText("")
	ItemDB_Browser_Filter_MinILevel:SetText("")
	ItemDB_Browser_Filter_MaxILevel:SetText("")
	for i = -2, 7 do
		filter_rarity[i] = true
	end

	local filterset_index = 0
	while filterset[filterset_index] do
		filterset[filterset_index] = nil
		filterset_index = filterset_index + 1
	end
	table_wipe(advanced_filter)
	self:AdvancedFilter_Update()
	self:FilterList_Create()
	self:FilterList_Update()
end

function ItemDB:ResetItemList()
	table_wipe(itemlist_filtered)
	self:ItemList_Update()

	local _, itemlist_size, _ = itemprovider[itemprovider_selected]:GetItemList(filterset)
	ItemDB_Browser_ItemCount:SetFormattedText("%d items", itemlist_size)

	collectgarbage("collect")
end



-- -----
-- Frame Scripts
-- -----

Script_AdvancedFilters_OnShow = function(self)
	ItemDB:AdvancedFilter_Update()
end

Script_AdvancedFilters_OnMouseWheel = function(self, delta)
	local slider = frames_advancedfilterslider
	local currentValue = slider:GetValue()
	local minValue,maxValue = slider:GetMinMaxValues()
	if delta < 0 and currentValue < maxValue then
		slider:SetValue(min(maxValue, currentValue + 5))
	elseif delta > 0 and currentValue > minValue then
		slider:SetValue(max(minValue, currentValue - 5))
	end
end


Script_AdvancedFilterButton_OnClick = function(self, button)
	if button == "LeftButton" then
		if advanced_filter[self.filter] == true then
			advanced_filter[self.filter] = nil
		else
			advanced_filter[self.filter] = true
		end
	elseif button == "RightButton" then
		if advanced_filter[self.filter] == false then
			advanced_filter[self.filter] = nil
		else
			advanced_filter[self.filter] = false
		end
	end
	ItemDB:AdvancedFilter_Update()
end

Script_AdvancedFiltersSlider_OnValueChanged = function()
	ItemDB:AdvancedFilter_Update()
end

Script_Browser_OnShow = function(self)
	ItemDB:SetSorting()
--~ 	if not filterset.name then
--~ 		filterset.name = filters[1][1]
--~ 		UIDropDownMenu_SetText(ItemDB_Browser_FilterDropDown, filterset.name)
--~ 		ItemDB:FilterList_Create()
--~ 		ItemDB:FilterList_Update()
--~ 	end
	if not itemprovider_selected then
		ItemDB:SelectItemProvider(1)
	end
end

Script_Browser_OnMouseDown = function(self, button)
	if button == "LeftButton" then
		self:StartMoving();
	end
end

Script_Browser_OnMouseUp = function(self, button)
	if button == "LeftButton" then
		self:StopMovingOrSizing();
	end
end

Script_Filter_RarityDropDown_OnShow = function(self)
	UIDropDownMenu_Initialize(self, Script_Filter_RarityDropDown_Initialize)
	UIDropDownMenu_SetText(self, FILTER)
	UIDropDownMenu_SetWidth(self, 130)
end

Script_Filter_RarityDropDown_Initialize = function(self)
	local info = {}
	info.text = "|cff71d5ff"..SPELLS..FONT_COLOR_CODE_CLOSE
	info.value = -2
	info.checked = filter_rarity[-2] and 1 or nil
	info.keepShownOnClick = 1
	info.func = Script_Filter_RarityDropDown_OnClick
	UIDropDownMenu_AddButton(info)

	info.text = "|cffff0000"..UNKNOWN..FONT_COLOR_CODE_CLOSE
	info.value = -1
	info.checked = filter_rarity[-1] and 1 or nil
	info.keepShownOnClick = 1
	info.func = Script_Filter_RarityDropDown_OnClick
	UIDropDownMenu_AddButton(info)

	for i = 0, #ITEM_QUALITY_COLORS do
		local color = ITEM_QUALITY_COLORS[i]
		info.text = color.hex.._G["ITEM_QUALITY"..i.."_DESC"]..FONT_COLOR_CODE_CLOSE
		info.value = i
		info.checked = filter_rarity[i] and 1 or nil
		info.keepShownOnClick = 1
		info.func = Script_Filter_RarityDropDown_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

Script_Filter_RarityDropDown_OnClick = function(self)
	if ( UIDropDownMenuButton_GetChecked(self) ) then
		filter_rarity[self.value] = true
	else
		filter_rarity[self.value] = nil
	end
end

Script_FilterButton_OnClick = function(self)
	local index = self:GetID() + FauxScrollFrame_GetOffset(ItemDB_Browser_FilterScrollFrame)
	local filterset_index = filterlist_depth[index]
	if filterset[filterset_index] ~= filterlist_names[index] then
		filterset[filterset_index] = filterlist_names[index]
		filterset_index = filterset_index + 1
	end
	while filterset[filterset_index] do
		filterset[filterset_index] = nil
		filterset_index = filterset_index + 1
	end
	ItemDB:FilterList_Create()
	ItemDB:FilterList_Update()
end

Script_FilterDropDown_OnShow = function(self)
	UIDropDownMenu_Initialize(self, Script_FilterDropDown_Initialize)
	UIDropDownMenu_SetText(self, filterset.name)
	UIDropDownMenu_SetWidth(self, 130)
end

Script_FilterDropDown_Initialize = function(self)
	for k, v in pairs(filters[1]) do
		local info = {}
		info.text = v
		info.value = v
		info.checked = filterset.name == v and 1 or nil
		info.func = Script_FilterDropDown_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

Script_FilterDropDown_OnClick = function(self)
	ItemDB:SelectFilterByName(self.value)
end

Script_FilterScrollFrame_OnVerticalScroll = function(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, 20, function() ItemDB:FilterList_Update() end) -- FilterButton height is 20
end

Script_ItemButton_OnClick = function(self, button)
	local item = itemlist_filtered[self:GetID() + FauxScrollFrame_GetOffset(ItemDB_Browser_ItemScrollFrame)]
	if item.type == "item" then
		if item.rarity < 0 then -- uncached item
			LibInventory:QueryItem(item.id)
		else
			local link = select(2, GetItemInfo(item.id))
			SetItemRef("item:"..item.id, link, button)
		end
	else -- .type == "spell"
		local link = GetSpellLink(item.id)
		SetItemRef("spell:"..item.id, link, button)
	end
end

Script_ItemButton_OnEnter = function(self)
	local item = itemlist_filtered[self:GetID() + FauxScrollFrame_GetOffset(ItemDB_Browser_ItemScrollFrame)]
	if not item then return end
	if item.type == "spell" then
		local link = GetSpellLink(item.id)
		if not link then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(link)
	else -- .type == "item"
		if item.rarity < 0 and GetItemInfo(item.id) then -- item new in cache since last search
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.id)
			item.name		= itemName
			item.rarity		= itemRarity
			item.itemlevel	= itemLevel
			item.minlevel	= itemMinLevel
			item.stack		= itemStackCount
			item.value		= itemSellPrice
			ItemDB:ItemList_Update()
		end
		if item.rarity >= 0 then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local link = select(2, GetItemInfo(item.id))
			if not link then return end
			GameTooltip:SetHyperlink(link)
			if IsModifiedClick("COMPAREITEMS") then
				GameTooltip_ShowCompareItem()
			end
			if IsModifiedClick("DRESSUP") then
				ShowInspectCursor()
			else
				ResetCursor()
			end
		end
	end
end

Script_ItemButton_OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

Script_ItemButton_OnUpdate = function(self)
	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end
Script_ItemProviderTab_OnClick = function(self)
	ItemDB:SelectItemProvider(self:GetID())
end

Script_ItemScrollFrame_OnVerticalScroll = function(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, 37, function() ItemDB:ItemList_Update() end) -- ItemButton height is 37
end

Script_ResetButton_OnClick = function(self)
	ItemDB:Reset()
end

Script_SearchButton_OnClick = function(self)
	if IsControlKeyDown() then
		ItemDB:QueryList()
	else
		if IsShiftKeyDown() then
			LibInventory:BuildLists(true)
		end
		ItemDB:Search()
	end
	collectgarbage("collect")
end

Script_ToggleFilter_OnClick = function(self)
	PlaySound("igMainMenuOptionCheckBoxOn")
	if advanced_filter_active then
		advanced_filter_active = false
		ItemDB_Browser_AdvancedFilters:Hide()
		ItemDB_Browser_ToggleFilterButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
		ItemDB_Browser_ToggleFilterButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
		ItemDB_Browser_ToggleFilterButton:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]])
	else
		advanced_filter_active = true
		ItemDB_Browser_AdvancedFilters:Show()
		ItemDB_Browser_ToggleFilterButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
		ItemDB_Browser_ToggleFilterButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]])
		ItemDB_Browser_ToggleFilterButton:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]])
	end
end