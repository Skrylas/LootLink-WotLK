
assert(TooltipExchange, "TooltipExchange not found!")

------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeUI")
local dewdrop = AceLibrary("Dewdrop-2.0")
local periodic = LibStub:GetLibrary("LibPeriodicTable-3.1")
local storage = AceLibrary("ItemStorage-1.0")

local MIN_PATTERN = 3
local MAX_RESULTS = 50
local MAX_ITEMID = 50000

local ITEM_QUALITY_COLORS = {}
for i, v in pairs(_G.ITEM_QUALITY_COLORS) do
	ITEM_QUALITY_COLORS[i] = v
end
if not ITEM_QUALITY_COLORS[7] then
	ITEM_QUALITY_COLORS[7] = ITEM_QUALITY_COLORS[6]
end

local function periodic_ItemSearch(item)
	assert(type(item) == "number" or type(item) == "string", "Invalid arg1: item must be a number or item link")
	item = tonumber(item) or tonumber(item:match("item:(%d+)"))
	if item == 0 then
		self:error("Invalid arg1: invalid item.")
	end
	local matches = {}
	for k,v in pairs(periodic.sets) do
		local _, set = periodic:ItemInSet(item, k)
		if set then
			local have
			for _,v in ipairs(matches) do
				if v == set then
					have = true
				end
			end
			if not have then
				table.insert(matches, set)
			end
		end
	end
	if #matches > 0 then
		return matches
	end
end

------------------------------------------------------------------------
-- Localization
------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Backdrop Alpha"] = true,
	["Close window"] = true,
	["Dress Up"] = true,
	["Find Similar"] = true,
	["Fixed Tooltip"] = true,
	["If entered, items with selected stat value greater or equal than this value will be returned."] = true,
	["Item equip location requirement. Have in mind multiple options may correspond to same location, because of game design."] = true,
	["Item name to be looked for."] = true,
	["Item rarity level requirement. Only items at given rarity level or better will be returned."] = true,
	["Item stat to be looked for during searching matching items. If no value is specified, then only existance of given stat is checked."] = true,
	["Item subtype requirement."] = true,
	["Item type requirement. Have in mind some types have subtypes while other dont."] = true,
	["Lock Position"] = true,
	["Locks item tooltip in place on the top of search frame."] = true,
	["Missing Weight"] = true,
	["Offset"] = true,
	["Open"] = true,
	["Opens or hides UI panel."] = true,
	["Options for item similarity compare."] = true,
	["Rarity / Location / Level"] = true,
	["Rows"] = true,
	["Search Options"] = true,
	["Search"] = true,
	["Sets result frame background transparency level."] = true,
	["Sets result row count.\n|cffff0000REQUIRES RELOADUI|r"] = true,
	["Sets tooltip placement on left or right from search frame."] = true,
	["Settings for advanced search options. Here you can set which search parameter lines will be displayed on the bottom of search frame."] = true,
	["Show"] = true,
	["Similarity cutoff value. The lower the value, the less likely items to be similar."] = true,
	["Similarity Options"] = true,
	["Stat %d"] = true,
	["The exponent value to which value difference is rised to. The higher the exponent, the more different items become."] = true,
	["The value to assign each time compared items have different type, subtype or equip location. The higher value is, the more different items become."] = true,
	["The value to assign each time item misses stat that exists on compared item. The higher value is, the more different items become."] = true,
	["Toggle rarity/equip location search options visibility."] = true,
	["Toggle stat %d search options visibility."] = true,
	["Toggle type/subtype search options visibility."] = true,
	["Toggles locking frame in place."] = true,
	["Tooltip Position"] = true,
	["Type / Subtype"] = true,
	["Type Weight"] = true,
	["User Interface"] = true,
	["Value Exponent"] = true,
	["|cff40ffc0Requesting item data...|r"] = true,
	["Instance Loot"] = true,
	["Instance bosses drop lists."] = true,
	["Mine"] = true,
	["Item level requirement."] = true,
	["Report"] = true,
	["Report current search results to given chat."] = true,
	["<name>"] = true,
	["Reports to %s chat."] = true,
	["Reports to given person."] = true,
	["Say"] = true,
	["Raid"] = true,
	["Party"] = true,
	["Guild"] = true,
	["Whisper"] = true,
	["Additional Item Data"] = true,
	["Toggles showing item ID and item level on item tooltips."] = true,
	["Source Info"] = true,
	["Toggles showing item drop information or crafting materials on item tooltips."] = true,
	["Dropped by:"] = true,
	["Crafted from:"] = true,
	["World drop"] = true,
	["Heroic"] = true,

	["Any"] = true,
	["Unequippable"] = true,
	["Bows"] = true,
	["Chest (Robe)"] = true,
	["Chest"] = true,
	["Cloaks"] = true,
	["Container"] = true,
	["Crossbows, Guns and Wands"] = true,
	["Feet"] = true,
	["Finger"] = true,
	["Hands"] = true,
	["Head"] = true,
	["Held In Off-Hand"] = true,
	["Legs"] = true,
	["Main-Hand Weapon"] = true,
	["Neck"] = true,
	["Off-Hand Weapon"] = true,
	["One-Hand Weapon"] = true,
	["Relics"] = true,
	["Shield"] = true,
	["Shirt"] = true,
	["Shoulder"] = true,
	["Tabard"] = true,
	["Trinkets"] = true,
	["Two-Handed"] = true,
	["Waist"] = true,
	["Wrist"] = true,

	["Armor"] = true,
	["Consumable"] = true,
	["Container"] = true,
	["Key"] = true,
	["Miscellaneous"] = true,
	["Projectile"] = true,
	["Reagent"] = true,
	["Recipe"] = true,
	["Quest"] = true,
	["Quiver"] = true,
	["Trade Goods"] = true,
	["Weapon"] = true,
	["Gem"] = true,

	["Alchemy"] = true,
	["Blacksmithing"] = true,
	["Book"] = true,
	["Cooking"] = true,
	["Enchanting"] = true,
	["Engineering"] = true,
	["First Aid"] = true,
	["Inscription"] = true,
	["Jewelcrafting"] = true,
	["Leatherworking"] = true,
	["Tailoring"] = true,

	["Cloth"] = true,
	["Idols"] = true,
	["Leather"] = true,
	["Librams"] = true,
	["Mail"] = true,
	["Miscellaneous"] = true,
	["Shields"] = true,
	["Totems"] = true,
	["Plate" ] = true,

	["Bows"] = true,
	["Crossbows"] = true,
	["Daggers"] = true,
	["Guns"] = true,
	["Fishing Pole"] = true,
	["Fist Weapons"] = true,
	["Miscellaneous"] = true,
	["One-Handed Axes"] = true,
	["One-Handed Maces"] = true,
	["One-Handed Swords"] = true,
	["Polearms"] = true,
	["Staves"] = true,
	["Thrown"] = true,
	["Two-Handed Axes"] = true,
	["Two-Handed Maces"] = true,
	["Two-Handed Swords"] = true,
	["Wands"] = true,
	["Devices"] = true,
	["Explosives"] = true,
	["Parts"] = true,
	["Trade Goods"] = true,

	["Blue"] = true,
	["Green"] = true,
	["Orange"] = true,
	["Meta"] = true,
	["Prismatic"] = true,
	["Purple"] = true,
	["Red"] = true,
	["Simple"] = true,
	["Yellow" ] = true,

	["None"] = true,
	["Required Level"] = true, ["Requires Level {0}"] = true,
	["Damage Per Second"] = true, ["({0} damage per second)"] = true,
	["Strength"] = true, ["+{0} Strength"] = true,
	["Agility"] = true, ["+{0} Agility"] = true,
	["Stamina"] = true, ["+{0} Stamina"] = true,
	["Intellect"] = true, ["+{0} Intellect"] = true,
	["Spirit"] = true, ["+{0} Spirit"] = true,
	["Arcane Resistance"] = true, ["+{0} Arcane Resistance"] = true,
	["Fire Resistance"] = true, ["+{0} Fire Resistance"] = true,
	["Frost Resistance"] = true, ["+{0} Frost Resistance"] = true,
	["Nature Resistance"] = true, ["+{0} Nature Resistance"] = true,
	["Shadow Resistance"] = true, ["+{0} Shadow Resistance"] = true,

	["Armor Penetration"] = true, ["Equip: Increases your armor penetration rating by {0}."] = true,
	["Attack Power"] = true, ["Equip: Increases attack power by {0}."] = true,
	["Block Rating"] = true, ["Equip: Increases your block rating by {0}."] = true,
	["Block Value"] = true, ["Equip: Increases the block value of your shield by {0}."] = true,
	["Critical Rating"] = true, ["Equip: Increases your critical strike rating by {0}."] = true,
	["Defense Rating"] = true, ["Equip: Increases defense rating by {0}."] = true,
	["Dodge Rating"] = true, ["Equip: Increases your dodge rating by {0}."] = true,
	["Expertise Rating"] = true, ["Equip: Increases your expertise rating by {0}."] = true,
	["Feral Attack Power"] = true, ["Equip: Increases attack power by {0} in Cat, Bear, Dire Bear, and Moonkin forms only."] = true,
	["Haste Rating"] = true, ["Equip: Improves haste rating by {0}."] = true,
	["Health Regeneration"] = true, ["Equip: Restores {0} health per 5 sec."] = true,
	["Hit Rating"] = true, ["Equip: Increases your hit rating by {0}."] = true,
	["Mana Regeneration"] = true, ["Equip: Restores {0} mana per 5 sec."] = true,
	["Parry Rating"] = true, ["Equip: Increases your parry rating by {0}."] = true,
	["Ranged Attack Power"] = true, ["Equip: Increases ranged attack power by {0}."] = true,
	["Spell Penetration"] = true, ["Equip: Increases your spell penetration by {0}."] = true,
	["Spell Power"] = true, ["Equip: Increases spell power by {0}."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Backdrop Alpha"] = "배경 투명도",
	["Close window"] = "닫기",
	["Dress Up"] = "입어보기",
	["Find Similar"] = "Find Similar",
	["Fixed Tooltip"] = "툴팁 수정",
	["If entered, items with selected stat value greater or equal than this value will be returned."] = "숫자를 입력하면 해당 착용 효과 이상만을 검색합니다.",
	["Item equip location requirement. Have in mind multiple options may correspond to same location, because of game design."] = "아이템의 장착위치를 선택합니다. 게임 디자인 때문에 동일한 장착 위치일때만 검색 됩니다.",
	["Item name to be looked for."] = "아이템의 이름을 입력합니다.",
	["Item rarity level requirement. Only items at given rarity level or better will be returned."] = "아이템 등급을 선택합니다. 선택한 등급 이상의 아이템만 검색합니다.",
	["Item stat to be looked for during searching matching items. If no value is specified, then only existance of given stat is checked."] = "아이템의 착용 효과를 선택합니다. 선택한 착용 효과만을 검색할 수 있습니다.",
	["Item subtype requirement."] = "아이템의 하위 분류를 선택합니다.",
	["Item type requirement. Have in mind some types have subtypes while other dont."] = "아이템의 종류를 선택합니다. 일부 아이템은 하위 분류도 선택해야 합니다.",
	["Lock Position"] = "위치 고정",
	["Locks item tooltip in place on the top of search frame."] = "아이템 정보가 검색창 보다 위에 나오도록 합니다.",
	["Missing Weight"] = "Missing Weight",
	["Offset"] = "Offset",
	["Open"] = "열기",
	["Opens or hides UI panel."] = "창을 닫거나 숨깁니다.",
	["Options for item similarity compare."] = "Options for item similarity compare.",
	["Rarity / Location / Level"] = "등급 / 위치",
	["Rows"] = "열",
	["Search Options"] = "검색 설정",
	["Search"] = "검색",
	["Sets result frame background transparency level."] = "검색창의 투명도를 변경합니다.",
	["Sets result row count.\n|cffff0000REQUIRES RELOADUI|r"] = "아이템 리스트 열의 수를 지정합니다.\n|cffff0000반드시 UI를 재시작해야 합니다.|r",
	["Sets tooltip placement on left or right from search frame."] = "아이템 정보의 위치를 왼쪽 오른쪽으로 지정합니다.",
	["Settings for advanced search options. Here you can set which search parameter lines will be displayed on the bottom of search frame."] = "확장 검색 설정",
	["Show"] = "보기",
	["Similarity cutoff value. The lower the value, the less likely items to be similar."] = "Similarity cutoff value. The lower the value, the less likely items to be similar.",
	["Similarity Options"] = "Similarity Options",
	["Stat %d"] = "아이템 효과 %d",
	["The exponent value to which value difference is rised to. The higher the exponent, the more different items become."] = "The exponent value to which value difference is rised to. The higher the exponent, the more different items become.",
	["The value to assign each time compared items have different type, subtype or equip location. The higher value is, the more different items become."] = "The value to assign each time compared items have different type, subtype or equip location. The higher value is, the more different items become.",
	["The value to assign each time item misses stat that exists on compared item. The higher value is, the more different items become."] = "The value to assign each time item misses stat that exists on compared item. The higher value is, the more different items become.",
	["Toggle rarity/equip location search options visibility."] = "등급/위치 검색을 토글합니다.",
	["Toggle stat %d search options visibility."] = "아이템 효과 %d 검색을 토글합니다.",
	["Toggle type/subtype search options visibility."] = "분류/하위 분류 검색을 토글합니다.",
	["Toggles locking frame in place."] = "검색창의 위치를 고정합니다",
	["Tooltip Position"] = "툴팁 위치",
	["Type / Subtype"] = "분류 / 하위분류",
	["Type Weight"] = "Type Weight",
	["User Interface"] = "사용자 UI",
	["Value Exponent"] = "Value Exponent",
	["|cff40ffc0Requesting item data...|r"] = "|cff40ffc0아이템을 찾고 있습니다.|r",
	["Instance Loot"] = "인스턴스 아이템",
	["Instance bosses drop lists."] = "인스턴스 던전의 보스 드랍 아이템리스트 표시",
	["Mine"] = "Mine",
	["Item level requirement."] = "Item level requirement.",
	["Report"] = "Report",
	["Report current search results to given chat."] = "Report current search results to given chat.",
	["<name>"] = "<이름>",
	["Reports to %s chat."] = "%s 대화창에 알림니다.",
	["Reports to given person."] = "지정된 사람에게 알립니다.",
	["Say"] = "일반",
	["Raid"] = "공격대",
	["Party"] = "파티",
	["Guild"] = "길드",
	["Whisper"] = "귓속말",
	["Additional Item Data"] = "Additional Item Data",
	["Toggles showing item ID and item level on item tooltips."] = "Toggles showing item ID and item level on item tooltips.",
	["Source Info"] = "Source Info",
	["Toggles showing item drop information or crafting materials on item tooltips."] = "Toggles showing item drop information or crafting materials on item tooltips.",
	["Dropped by:"] = "Dropped by:",
	["Crafted from:"] = "Crafted from:",
	["World drop"] = "World drop",
	["Heroic"] = "Heroic",

	["Any"] = "모두",
	["Unequippable"] = "비장착",
	["Bows"] = "활",
	["Chest (Robe)"] = "가슴",
	["Chest"] = "가슴",
	["Cloaks"] = "등",
	["Container"] = "가방",
	["Crossbows, Guns and Wands"] = "석궁, 총, 마법봉",
	["Feet"] = "발",
	["Finger"] = "손가락",
	["Hands"] = "손",
	["Head"] = "머리",
	["Held In Off-Hand"] = "보조장비",
	["Legs"] = "다리",
	["Main-Hand Weapon"] = "주장비",
	["Neck"] = "목",
	["Off-Hand Weapon"] = "보조장비(무기)",
	["One-Hand Weapon"] = "한손무기",
	["Relics"] = "성물",
	["Shield"] = "방패",
	["Shirt"] = "속옷",
	["Shoulder"] = "어깨",
	["Tabard"] = "겉옷",
	["Trinkets"] = "장신구",
	["Two-Handed"] = "양손 장비",
	["Waist"] = "허리",
	["Wrist"] = "손목",

	["Armor"] = "방어구",
	["Consumable"] = "소모품",
	["Container"] = "가방",
	["Key"] = "열쇠",
	["Miscellaneous"] = "기타",
	["Projectile"] = "투사체",
	["Reagent"] = "재료",
	["Recipe"] = "Recipe",
	["Quest"] = "퀘스트",
	["Quiver"] = "화살통",
	["Trade Goods"] = "거래 가능",
	["Weapon"] = "무기",

	["Alchemy"] = "Alchemy",
	["Blacksmithing"] = "Blacksmithing",
	["Book"] = "Book",
	["Cooking"] = "Cooking",
	["Enchanting"] = "Enchanting",
	["Engineering"] = "Engineering",
	["First Aid"] = "First Aid",
	["Inscription"] = "Inscription",
	["Jewelcrafting"] = "Jewelcrafting",
	["Leatherworking"] = "Leatherworking",
	["Tailoring"] = "Tailoring",

	["Cloth"] = "천",
	["Idols"] = "우상",
	["Leather"] = "가죽",
	["Librams"] = "성서",
	["Mail"] = "사슬",
	["Miscellaneous"] = "기타",
	["Shields"] = "방패",
	["Totems"] = "토템",
	["Plate" ] = "판금",

	["Bows"] = "활",
	["Crossbows"] = "석궁",
	["Daggers"] = "단검",
	["Guns"] = "총",
	["Fishing Pole"] = "낚시대",
	["Fist Weapons"] = "장착 무기",
	["Miscellaneous"] = "기타",
	["One-Handed Axes"] = "한손 도끼",
	["One-Handed Maces"] = "한손 둔기",
	["One-Handed Swords"] = "한손 도검",
	["Polearms"] = "장창류",
	["Staves"] = "지팡이",
	["Thrown"] = "투척 무기",
	["Two-Handed Axes"] = "양손 도끼",
	["Two-Handed Maces"] = "양손 둔기",
	["Two-Handed Swords"] = "양손 도검",
	["Wands"] = "마법봉",

	["Blue"] = true,
	["Green"] = true,
	["Orange"] = true,
	["Meta"] = true,
	["Prismatic"] = true,
	["Purple"] = true,
	["Red"] = true,
	["Simple"] = true,
	["Yellow" ] = true,

	["Devices"] = "Devices",
	["Explosives"] = "Explosives",
	["Parts"] = "Parts",
	["Trade Goods"] = "Trade Goods",

	["None"] = "없음",
	["Required Level"] = "최소 요구 레벨", ["Requires Level {0}"] = "최소 요구 레벨 {0}",
	["Damage Per Second"] = "초당 공격력", ["({0} damage per second)"] = "(초당 공격력 {0})",
	["Strength"] = "힘", ["+{0} Strength"] = "힘 +{0}",
	["Agility"] = "민첩", ["+{0} Agility"] = "민첩 +{0}",
	["Stamina"] = "체력", ["+{0} Stamina"] = "체력 +{0}",
	["Intellect"] = "지능", ["+{0} Intellect"] = "지능 +{0}",
	["Spirit"] = "정신력", ["+{0} Spirit"] = "정신력 +{0}",
	["Arcane Resistance"] = "비전 저항력", ["+{0} Arcane Resistance"] = "비전 저항력 +{0}",
	["Fire Resistance"] = "화염 저항력", ["+{0} Fire Resistance"] = "화염 저항력 +{0}",
	["Frost Resistance"] = "냉기 저항력", ["+{0} Frost Resistance"] = "냉기 저항력 +{0}",
	["Nature Resistance"] = "자연 저항력", ["+{0} Nature Resistance"] = "자연 저항력 +{0}",
	["Shadow Resistance"] = "암흑 저항력", ["+{0} Shadow Resistance"] = "암흑 저항력 +{0}",

--	["Armor Penetration"] = "Armor Penetration", ["Equip: Your attacks ignore {0} of your opponent's armor."] = "Equip: Your attacks ignore {0} of your opponent's armor.",
	["Attack Power"] = "전투력", ["Equip: Increases attack power by {0}."] = "착용 효과: 전투력이 {0}만큼 증가합니다.",
	["Block Rating"] = "방패 막기 숙련도", ["Equip: Increases your block rating by {0}."] = "착용 효과: 방패 막기 숙련도가 {0}만큼 증가합니다.",
	["Block Value"] = "피해 방어량", ["Equip: Increases the block value of your shield by {0}."] = "착용 효과: 방패의 피해 방어량이 {0}만큼 증가합니다.",
	["Critical Rating"] = "치명타 적중도", ["Equip: Increases your critical strike rating by {0}."] = "착용 효과: 치명타 적중도가 {0}만큼 증가합니다.",
	["Defense Rating"] = "방어 숙련도", ["Equip: Increases defense rating by {0}."] = "착용 효과: 방어 숙련도가 {0}만큼 증가합니다.",
	["Dodge Rating"] = "회피 숙련도", ["Equip: Increases your dodge rating by {0}."] = "착용 효과: 회피 숙련도가 {0}만큼 증가합니다.",
--	["Expertise Rating"] = "Expertise Rating", ["Equip: Increases your expertise rating by {0}."] = "Equip: Increases your expertise rating by {0}.",
--	["Feral Attack Power"] = "Feral Attack Power", ["Equip: Increases attack power by {0} in Cat, Bear, Dire Bear, and Moonkin forms only."] = "Equip: Increases attack power by {0} in Cat, Bear, Dire Bear, and Moonkin forms only.",
--	["Haste Rating"] = "Haste Rating", ["Equip: Improves haste rating by {0}."] = "Equip: Improves haste rating by {0}.",
--	["Health Regeneration"] = "Health Regeneration", ["Equip: Restores {0} health per 5 sec."] = "Equip: Restores {0} health per 5 sec.",
	["Hit Rating"] = "적중도", ["Equip: Increases your hit rating by {0}."] = "착용 효과: 적중도가 {0}만큼 증가합니다.",
--	["Mana Regeneration"] = "Mana Regeneration", ["Equip: Restores {0} mana per 5 sec."] = "Equip: Restores {0} mana per 5 sec.",
	["Parry Rating"] = "무기 막기 숙련도", ["Equip: Increases your parry rating by {0}."] = "착용 효과: 무기 막기 숙련도가 {0}만큼 증가합니다.",
	["Ranged Attack Power"] = "원거리 전투력", ["Equip: Increases ranged attack power by {0}."] = "착용 효과: 원거리 전투력이 {0}만큼 증가합니다.",
	["Spell Penetration"] = "마법 저항력 감소", ["Equip: Decreases the magical resistances of your spell targets by {0}."] = "착용 효과: 자신의 주문에 대한 대상의 마법 저항력을 {0}만큼 감소시킵니다.",
--	["Spell Power"] = true, ["Equip: Increases spell power by {0}."] = true,
} end)

local reportTargets = {
	{ chat = "SAY", },
	{ chat = "PARTY", isHidden = function() return GetNumPartyMembers() == 0 end },
	{ chat = "RAID", isHidden = function() return GetNumRaidMembers() == 0 end },
	{ chat = "GUILD", isHidden = function() return not IsInGuild() end },
}

local rarityList = {
	{ text = L["Any"], value = nil },
	{ text = ITEM_QUALITY_COLORS[0].hex .. _G["ITEM_QUALITY" .. 0 .. "_DESC"] .. "|r", value = 0 },
	{ text = ITEM_QUALITY_COLORS[1].hex .. _G["ITEM_QUALITY" .. 1 .. "_DESC"] .. "|r", value = 1 },
	{ text = ITEM_QUALITY_COLORS[2].hex .. _G["ITEM_QUALITY" .. 2 .. "_DESC"] .. "|r", value = 2 },
	{ text = ITEM_QUALITY_COLORS[3].hex .. _G["ITEM_QUALITY" .. 3 .. "_DESC"] .. "|r", value = 3 },
	{ text = ITEM_QUALITY_COLORS[4].hex .. _G["ITEM_QUALITY" .. 4 .. "_DESC"] .. "|r", value = 4 },
	{ text = ITEM_QUALITY_COLORS[5].hex .. _G["ITEM_QUALITY" .. 5 .. "_DESC"] .. "|r", value = 5 },
	{ text = ITEM_QUALITY_COLORS[6].hex .. _G["ITEM_QUALITY" .. 6 .. "_DESC"] .. "|r", value = 6 },
}

local equipList = {
	{ text = L["Any"], value = nil },
	{ text = L["Unequippable"], value = "" },
	{ text = L["Bows"], value = "INVTYPE_RANGED" },
	{ text = L["Chest (Robe)"], value = "INVTYPE_ROBE" },
	{ text = L["Chest"], value = "INVTYPE_CHEST" },
	{ text = L["Cloaks"], value = "INVTYPE_CLOAK" },
	{ text = L["Container"], value = "INVTYPE_BAG" },
	{ text = L["Crossbows, Guns and Wands"], value = "INVTYPE_RANGEDRIGHT" },
	{ text = L["Feet"], value = "INVTYPE_FEET" },
	{ text = L["Finger"], value = "INVTYPE_FINGER" },
	{ text = L["Hands"], value = "INVTYPE_HAND" },
	{ text = L["Head"], value = "INVTYPE_HEAD" },
	{ text = L["Held In Off-Hand"], value = "INVTYPE_HOLDABLE" },
	{ text = L["Legs"], value = "INVTYPE_LEGS" },
	{ text = L["Main-Hand Weapon"], value = "INVTYPE_WEAPONMAINHAND" },
	{ text = L["Neck"], value = "INVTYPE_NECK" },
	{ text = L["Off-Hand Weapon"], value = "INVTYPE_WEAPONOFFHAND" },
	{ text = L["One-Hand Weapon"], value = "INVTYPE_WEAPON" },
	{ text = L["Relics"], value = "INVTYPE_RELIC" },
	{ text = L["Shield"], value = "INVTYPE_SHIELD" },
	{ text = L["Shirt"], value = "INVTYPE_BODY" },
	{ text = L["Shoulder"], value = "INVTYPE_SHOULDER" },
	{ text = L["Tabard"], value = "INVTYPE_TABARD" },
	{ text = L["Trinkets"], value = "INVTYPE_TRINKET" },
	{ text = L["Two-Handed"], value = "INVTYPE_2HWEAPON" },
	{ text = L["Waist"], value = "INVTYPE_WAIST" },
	{ text = L["Wrist"], value = "INVTYPE_WRIST" },
}

local typeList = {
	{ text = L["Any"], value = nil },
	{ text = L["Armor"], value = "Armor" },
	{ text = L["Consumable"], value = "Consumable" },
	{ text = L["Container"], value = "Container" },
	{ text = L["Gem"], value = "Gem" },
	{ text = L["Key"], value = "Key" },
	{ text = L["Miscellaneous"], value = "Miscellaneous" },
	{ text = L["Reagent"], value = "Reagent" },
	{ text = L["Projectile"], value = "Projectile" },
	{ text = L["Quest"], value = "Quest" },
	{ text = L["Quiver"], value = "Quiver" },
	{ text = L["Recipe"], value = "Recipe" },
	{ text = L["Trade Goods"], value = "Trade Goods" },
	{ text = L["Weapon"], value = "Weapon" },
}

local subtypeList = {
	{ text = L["Any"], value = nil },

	{ parent = "Armor", text = L["Cloth"], value = "Cloth" },
	{ parent = "Armor", text = L["Idols"], value = "Idols" },
	{ parent = "Armor", text = L["Leather"], value = "Leather" },
	{ parent = "Armor", text = L["Librams"], value = "Librams" },
	{ parent = "Armor", text = L["Mail"], value = "Mail" },
	{ parent = "Armor", text = L["Miscellaneous"], value = "Miscellaneous" },
	{ parent = "Armor", text = L["Shields"], value = "Shields" },
	{ parent = "Armor", text = L["Totems"], value = "Totems" },
	{ parent = "Armor", text = L["Plate"], value = "Plate" },

	{ parent = "Gem", text = L["Blue"], value = "Blue" },
	{ parent = "Gem", text = L["Green"], value = "Green" },
	{ parent = "Gem", text = L["Orange"], value = "Orange" },
	{ parent = "Gem", text = L["Meta"], value = "Meta" },
	{ parent = "Gem", text = L["Prismatic"], value = "Prismatic" },
	{ parent = "Gem", text = L["Purple"], value = "Purple" },
	{ parent = "Gem", text = L["Red"], value = "Red" },
	{ parent = "Gem", text = L["Simple"], value = "Simple" },
	{ parent = "Gem", text = L["Yellow"], value = "Yellow" },

	{ parent = "Recipe", text = L["Alchemy"], value = "Alchemy" },
	{ parent = "Recipe", text = L["Blacksmithing"], value = "Blacksmithing" },
	{ parent = "Recipe", text = L["Book"], value = "Book" },
	{ parent = "Recipe", text = L["Cooking"], value = "Cooking" },
	{ parent = "Recipe", text = L["Enchanting"], value = "Enchanting" },
	{ parent = "Recipe", text = L["Engineering"], value = "Engineering" },
	{ parent = "Recipe", text = L["First Aid"], value = "First Aid" },
	{ parent = "Recipe", text = L["Inscription"], value = "Inscription" },
	{ parent = "Recipe", text = L["Jewelcrafting"], value = "Jewelcrafting" },
	{ parent = "Recipe", text = L["Leatherworking"], value = "Leatherworking" },
	{ parent = "Recipe", text = L["Tailoring"], value = "Tailoring" },

	{ parent = "Weapon", text = L["Bows"], value = "Bows" },
	{ parent = "Weapon", text = L["Crossbows"], value = "Crossbows" },
	{ parent = "Weapon", text = L["Daggers"], value = "Daggers" },
	{ parent = "Weapon", text = L["Guns"], value = "Guns" },
	{ parent = "Weapon", text = L["Fishing Pole"], value = "Fishing Pole" },
	{ parent = "Weapon", text = L["Fist Weapons"], value = "Fist Weapons" },
	{ parent = "Weapon", text = L["Miscellaneous"], value = "Miscellaneous" },
	{ parent = "Weapon", text = L["One-Handed Axes"], value = "One-Handed Axes" },
	{ parent = "Weapon", text = L["One-Handed Maces"], value = "One-Handed Maces" },
	{ parent = "Weapon", text = L["One-Handed Swords"], value = "One-Handed Swords" },
	{ parent = "Weapon", text = L["Polearms"], value = "Polearms" },
	{ parent = "Weapon", text = L["Staves"], value = "Staves" },
	{ parent = "Weapon", text = L["Thrown"], value = "Thrown" },
	{ parent = "Weapon", text = L["Two-Handed Axes"], value = "Two-Handed Axes" },
	{ parent = "Weapon", text = L["Two-Handed Maces"], value = "Two-Handed Maces" },
	{ parent = "Weapon", text = L["Two-Handed Swords"], value = "Two-Handed Swords" },
	{ parent = "Weapon", text = L["Wands"], value = "Wands" },

	{ parent = "Trade Goods", text = L["Devices"], value = "Devices" },
	{ parent = "Trade Goods", text = L["Explosives"], value = "Explosives" },
	{ parent = "Trade Goods", text = L["Parts"], value = "Parts" },
	{ parent = "Trade Goods", text = L["Trade Goods"], value = "Trade Goods" },
}

local statList = {
	{ text = L["None"], value = nil },
	{ text = L["Required Level"], value = L["Requires Level {0}"] },
	{ text = L["Damage Per Second"], value = L["({0} damage per second)"] },
	
	{ text = L["Strength"], value = L["+{0} Strength"] },
	{ text = L["Agility"], value = L["+{0} Agility"] },
	{ text = L["Stamina"], value = L["+{0} Stamina"] },
	{ text = L["Intellect"], value = L["+{0} Intellect"] },
	{ text = L["Spirit"], value = L["+{0} Spirit"] },
	
	{ text = L["Attack Power"], value = L["Equip: Increases attack power by {0}."] },
	{ text = L["Spell Power"], value = L["Equip: Increases spell power by {0}."] },
--	{ text = L["Ranged Attack Power"], value = L["Equip: Increases ranged attack power by {0}."] },
--	{ text = L["Feral Attack Power"], value = L["Equip: Increases attack power by {0} in Cat, Bear, Dire Bear, and Moonkin forms only."] },
	{ text = L["Critical Rating"], value = L["Equip: Increases your critical strike rating by {0}."] },
	{ text = L["Hit Rating"], value = L["Equip: Increases your hit rating by {0}."] },
	{ text = L["Expertise Rating"], value = L["Equip: Increases your expertise rating by {0}."] },
	{ text = L["Haste Rating"], value = L["Equip: Improves haste rating by {0}."] },
	{ text = L["Armor Penetration"], value = L["Equip: Increases your armor penetration rating by {0}."] },
	{ text = L["Spell Penetration"], value = L["Equip: Increases your spell penetration by {0}."] },
	
	{ text = L["Block Rating"], value = L["Equip: Increases your block rating by {0}."] },
	{ text = L["Block Value"], value = L["Equip: Increases the block value of your shield by {0}."] },
	{ text = L["Defense Rating"], value = L["Equip: Increases defense rating by {0}."] },
	{ text = L["Dodge Rating"], value = L["Equip: Increases your dodge rating by {0}."] },
	{ text = L["Parry Rating"], value = L["Equip: Increases your parry rating by {0}."] },

	{ text = L["Health Regeneration"], value = L["Equip: Restores {0} health per 5 sec."] },
	{ text = L["Mana Regeneration"], value = L["Equip: Restores {0} mana per 5 sec."] },
	
	{ text = L["Arcane Resistance"], value = L["+{0} Arcane Resistance"]},
	{ text = L["Fire Resistance"], value = L["+{0} Fire Resistance"]},
	{ text = L["Frost Resistance"], value = L["+{0} Frost Resistance"]},
	{ text = L["Nature Resistance"], value = L["+{0} Nature Resistance"]},
	{ text = L["Shadow Resistance"], value = L["+{0} Shadow Resistance"]},
}

------------------------------------------------------------------------
-- Declaration
------------------------------------------------------------------------

TooltipExchangeUI = TooltipExchange:NewModule(L["User Interface"])
TooltipExchangeUI.notToggable = true

TooltipExchangeUI.defaults = {
	locked = false,
	additionalData = true,
	sourceInfo = true,
	fixedTooltip = true,
	resultRows = 15,
	backgroundAlpha = 0.75,
	tooltipPosition = "left",
	searchLine1 = true,
	searchLine2 = true,
	searchLine3 = false,
	searchLine4 = true,
	searchLine5 = false,
	searchLine6 = false,
	typeWeight = 2.00,
	missingWeight = 1.25,
	valueExponent = 2.50,
	cutoff = 0.00,
}

TooltipExchangeUI.commands = {
	open = {
		type = "execute",
		name = L["Open"],
		desc = L["Opens or hides UI panel."],
		func = function() TooltipExchangeUI:OpenUI() dewdrop:Close() end,
		order = 10,
	},
	report = {
		type = "group",
		name = L["Report"],
		desc = L["Report current search results to given chat."],
		order = 11,
		args = {},
	},
}

TooltipExchangeUI.options = {
	lock = {
		type = "toggle",
		name = L["Lock Position"],
		desc = L["Toggles locking frame in place."],
		get = function() return TooltipExchangeUI.db.profile.locked end,
		set = function(v) TooltipExchangeUI.db.profile.locked = v end,
		order = 110,
	},
	searchOptions = {
		type = "group",
		name = L["Search Options"],
		desc = L["Settings for advanced search options. Here you can set which search parameter lines will be displayed on the bottom of search frame."],
		args = {
			headerSearchOptions = {
				type = "header",
				name = L["Search Options"],
				order = 1,
			},
			rarityLocation = {
				type = "toggle",
				name = L["Rarity / Location / Level"],
				desc = L["Toggle rarity/equip location search options visibility."],
				get = function() return TooltipExchangeUI.db.profile.searchLine2 end,
				set = function(v) TooltipExchangeUI.db.profile.searchLine2 = v TooltipExchangeUI:SetupSearchLines() end,
				order = 110,
			},
			typeSubtype = {
				type = "toggle",
				name = L["Type / Subtype"],
				desc = L["Toggle type/subtype search options visibility."],
				get = function() return TooltipExchangeUI.db.profile.searchLine3 end,
				set = function(v) TooltipExchangeUI.db.profile.searchLine3 = v TooltipExchangeUI:SetupSearchLines() end,
				order = 120,
			},
			stat1 = {
				type = "toggle",
				name = string.format(L["Stat %d"] , 1),
				desc = string.format(L["Toggle stat %d search options visibility."], 1),
				get = function() return TooltipExchangeUI.db.profile.searchLine4 end,
				set = function(v) TooltipExchangeUI.db.profile.searchLine4 = v TooltipExchangeUI:SetupSearchLines() end,
				order = 130,
			},
			stat2 = {
				type = "toggle",
				name = string.format(L["Stat %d"] , 2),
				desc = string.format(L["Toggle stat %d search options visibility."], 2),
				get = function() return TooltipExchangeUI.db.profile.searchLine5 end,
				set = function(v) TooltipExchangeUI.db.profile.searchLine5 = v TooltipExchangeUI:SetupSearchLines() end,
				order = 140,
			},
			stat3 = {
				type = "toggle",
				name = string.format(L["Stat %d"] , 3),
				desc = string.format(L["Toggle stat %d search options visibility."], 3),
				get = function() return TooltipExchangeUI.db.profile.searchLine6 end,
				set = function(v) TooltipExchangeUI.db.profile.searchLine6 = v TooltipExchangeUI:SetupSearchLines() end,
				order = 150,
			},
		},
		order = 120,
	},
	additionalData = {
		type = "toggle",
		name = L["Additional Item Data"],
		desc = L["Toggles showing item ID and item level on item tooltips."],
		get = function() return TooltipExchangeUI.db.profile.additionalData end,
		set = function(v) TooltipExchangeUI.db.profile.additionalData = v end,
		order = 128,
	},
	sourceInfo = {
		type = "toggle",
		name = L["Source Info"],
		desc = L["Toggles showing item drop information or crafting materials on item tooltips."],
		get = function() return TooltipExchangeUI.db.profile.sourceInfo end,
		set = function(v) TooltipExchangeUI.db.profile.sourceInfo = v end,
		order = 129,
	},
	fixedTooltip = {
		type = "toggle",
		name = L["Fixed Tooltip"],
		desc = L["Locks item tooltip in place on the top of search frame."],
		get = function() return TooltipExchangeUI.db.profile.fixedTooltip end,
		set = function(v) TooltipExchangeUI.db.profile.fixedTooltip = v end,
		order = 130,
	},
	tooltipPosition = {
		type = "text",
		name = L["Tooltip Position"],
		desc = L["Sets tooltip placement on left or right from search frame."],
		get = function() return TooltipExchangeUI.db.profile.tooltipPosition end,
		set = function(v) TooltipExchangeUI.db.profile.tooltipPosition = v end,
		validate = {
			["left"] = "Left",
			["right"] = "Right",
		},
		order = 140,
	},
	rows = {
		type = "range",
		name = L["Rows"],
		desc = L["Sets result row count.\n|cffff0000REQUIRES RELOADUI|r"],
		min = 5,
		max = 25,
		step = 1,
		isPercent = false,
		get = function() return TooltipExchangeUI.db.profile.resultRows end,
		set = function(v) TooltipExchangeUI.db.profile.resultRows = v end,
		order = 150,
	},
	backgroundAlpha = {
		type = "range",
		name = L["Backdrop Alpha"],
		desc = L["Sets result frame background transparency level."],
		min = 0,
		max = 1,
		step = 0,
		isPercent = false,
		get = function() return TooltipExchangeUI.db.profile.backgroundAlpha end,
		set = function(v)
			TooltipExchangeUI.db.profile.backgroundAlpha = v
			TooltipExchangeUI:SetBackdropAlpha()
		end,
		order = 160,
	},
	similarity = {
		type = "group",
		name = L["Similarity Options"],
		desc = L["Options for item similarity compare."],
		order = 170,
		args = {
			headerSimilarity = {
				type = "header",
				name = L["Similarity Options"],
				order = 1,
			},
			typeWeight = {
				type = "range",
				name = L["Type Weight"],
				desc = L["The value to assign each time compared items have different type, subtype or equip location. The higher value is, the more different items become."],
				min = 0,
				max = 5,
				step = 0.05,
				get = function() return TooltipExchangeUI.db.profile.typeWeight end,
				set = function(v) TooltipExchangeUI.db.profile.typeWeight = v end,
				order = 10,
			},
			missingWeight = {
				type = "range",
				name = L["Missing Weight"],
				desc = L["The value to assign each time item misses stat that exists on compared item. The higher value is, the more different items become."],
				min = 0,
				max = 5,
				step = 0.05,
				get = function() return TooltipExchangeUI.db.profile.missingWeight end,
				set = function(v) TooltipExchangeUI.db.profile.missingWeight = v end,
				order = 20,
			},
			valueExponent = {
				type = "range",
				name = L["Value Exponent"],
				desc = L["The exponent value to which value difference is rised to. The higher the exponent, the more different items become."],
				min = 1,
				max = 5,
				step = 0.5,
				get = function() return TooltipExchangeUI.db.profile.valueExponent end,
				set = function(v) TooltipExchangeUI.db.profile.valueExponent = v end,
				order = 30,
			},
			cutoff = {
				type = "range",
				name = L["Offset"],
				desc = L["Similarity cutoff value. The lower the value, the less likely items to be similar."],
				min = -5,
				max = 5,
				step = 0.5,
				get = function() return TooltipExchangeUI.db.profile.cutoff end,
				set = function(v) TooltipExchangeUI.db.profile.cutoff = v end,
				order = 40,
			},
		},
	},
}

TooltipExchangeUI.revision = tonumber(string.sub("$Revision: 81578 $", 12, -3))

------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------

function TooltipExchangeUI:OnInitialize()
	self.searchID = nil
	self.searchResults = {}
	self.searchHash = {}
	
	self.resultRows = self.db.profile.resultRows

	self:RegisterMessage("DS")
	self:RegisterMessage("DM")
	self:RegisterMessage("DR")
	self:RegisterMessage("DI")
	self:RegisterMessage("DC")
	self:RegisterMessage("DT")

	self:CreateStaticMenu()
end

function TooltipExchangeUI:OnEnable()
	self:RegisterEvent("TooltipExchange_OpenUI")
	self:RegisterEvent("TooltipExchange_LocalResults")
	self:RegisterEvent("TooltipExchange_ExternalResults")
	self:RegisterEvent("TooltipExchange_PeriodicResults")
	self:RegisterEvent("TooltipExchange_ResultsChanged")
end

function TooltipExchangeUI:OnDisable()
	self.searchID = nil

	for k in pairs(self.searchResults) do
		self.searchResults[k] = nil
	end

	for k in pairs(self.searchHash) do
		self.searchHash[k] = nil
	end
end

------------------------------------------------------------------------
-- Events and Hooks
------------------------------------------------------------------------

function TooltipExchangeUI:TooltipExchange_OpenUI(dontHide)
	self:OpenUI(dontHide)
end

function TooltipExchangeUI:TooltipExchange_LocalResults(results)
	self:OpenUI(true)
	self:ClearResults()

	self.searchID = nil

	for itemID in pairs(results) do
		if not self.searchHash[itemID] and storage:HasItem(self:GetStorage(), itemID) then
			self.searchHash[itemID] = 1
			table.insert(self.searchResults, {
				i = itemID,
			})
		end
	end

	self:TriggerEvent("TooltipExchange_ResultsChanged")
end

function TooltipExchangeUI:TooltipExchange_ExternalResults(provider, results)
	self:OpenUI(true)
	self:ClearResults()

	self.searchID = nil

	for _, item in ipairs(results) do
		if not self.searchHash[item.i] then
			self.searchHash[item.i] = 1
			table.insert(self.searchResults, {
				i = item.i,
				n = item.n,
				c = item.c,
				o = item.o,
				p = provider,
			})
		end
	end

	self:TriggerEvent("TooltipExchange_ResultsChanged")
end

function TooltipExchangeUI:TooltipExchange_PeriodicResults(set)
	self:OpenUI(true)
	self:ClearResults()

	self.searchID = math.random(1000000, 9999999)

	local a = nil

	for itemID in periodic:IterateSet(set) do
		if not self.searchHash[itemID] then
			if storage:HasItem(self:GetStorage(), itemID) then
				self.searchHash[itemID] = 1
				table.insert(self.searchResults, {
					i = itemID,
				})
			else
				local n, _, c, _, _, _, _, _, _, o = GetItemInfo(itemID)

				if n then
					self.searchHash[itemID] = 1
					table.insert(self.searchResults, {
						i = itemID,
						c = c,
						n = n,
						o = o,
					})
				else
					if not a then
						a = {}
					end

					table.insert(a, itemID)
				end
			end
		end
	end

	self:TriggerEvent("TooltipExchange_ResultsChanged")

	if a and #(a) < MAX_RESULTS then
		self:SendMessage(nil, "DT", self.searchID, a)
	end
end

function TooltipExchangeUI:TooltipExchange_ResultsChanged()
	local I = self:GetStorage().i

	table.sort(self.searchResults, function(a, b)
		if not a.n then
			a = I[a.i] -- Dirty hack
		end
		if not b.n then
			b = I[b.i] -- Dirty hack
		end

		if a.c == b.c then
			if a.n == b.n then
				return a.i < b.i
			else
				return a.n < b.n
			end
		else
			return a.c > b.c
		end
	end)

	self:UpdateResults()
end

------------------------------------------------------------------------
-- Module Specific Communication
------------------------------------------------------------------------

function TooltipExchangeUI:DS(sender, searchID, definition, searchHash)
	local matches, n = {}, 0

	for itemID, item in storage:Search(self:GetStorage(), definition) do
		if not searchHash[itemID] then
			table.insert(matches, {
				i = storage:GetItemID(self:GetStorage(), item),
				c = storage:GetItemRarity(self:GetStorage(), item),
				n = storage:GetItemName(self:GetStorage(), item),
				o = storage:GetItemIcon(self:GetStorage(), item),
			})
			n = n + 1

			if n >= MAX_RESULTS then
				break
			end
		end
	end

	if n > 0 and n < MAX_RESULTS then
		self:SendMessage(sender, "DM", searchID, matches)
	end
end

function TooltipExchangeUI:DM(sender, searchID, matches)
	if self.searchID == searchID then
		for _, item in pairs(matches) do
			if not storage:HasItem(self:GetStorage(), item.i) then
				self:TriggerEvent("TooltipExchange_ItemSeen", item.i)
			end
		end

		local n = 0

		for _, item in ipairs(matches) do
			if not self.searchHash[item.i] then
				self.searchHash[item.i] = 1
				table.insert(self.searchResults, {
					i = item.i,
					n = item.n,
					c = item.c,
					o = item.o,
					p = sender,
				})

				n = n + 1
			end
		end

		if n > 0 then
			self:TriggerEvent("TooltipExchange_ResultsChanged")
		end
	end
end

function TooltipExchangeUI:DR(sender, itemID, provider)
	if not provider or provider == UnitName("player") then
		if storage:HasItem(self:GetStorage(), itemID) then
			local item = {}

			storage:Eject(self:GetStorage(), itemID, item)

			self:SendMessage(sender, "DI", item)
		end
	end
end

function TooltipExchangeUI:DI(sender, item)
	local show = self.tooltips and self.tooltips.show and self.tooltips.show.requestedID == item.i and self.tooltips.show:IsVisible()

	if not storage:HasItem(self:GetStorage(), item.i) and (show or item.c >= self.core.db.profile.rarity) then
		storage:Inject(self:GetStorage(), item)
	end

	if show then
		self.tooltips.show.requestedID = nil

		local item = storage:GetItem(self:GetStorage(), item.i)

		self.tooltips.show:Hide()
		storage:BuildItemTooltip(self:GetStorage(), item, self.tooltips.show)
		self.tooltips.show:Show()
		self:UpdateDataTooltip(item.i, item)
	end
end


function TooltipExchangeUI:DC(sender, searchID, base, searchHash, typeWeight, missingWeight, valueExponent, cutoff)
	local matches, n = {}, 0

	if not storage:HasItem(self:GetStorage(), base.i) then
		storage:Inject(self:GetStorage(), base)
	end

	for itemID, item in storage:Similar(self:GetStorage(), storage:GetItem(self:GetStorage(), base.i), typeWeight, missingWeight, valueExponent, cutoff) do
		if not searchHash[itemID] then
			table.insert(matches, {
				i = storage:GetItemID(self:GetStorage(), item),
				c = storage:GetItemRarity(self:GetStorage(), item),
				n = storage:GetItemName(self:GetStorage(), item),
				o = storage:GetItemIcon(self:GetStorage(), item),
			})
			n = n + 1

			if n >= MAX_RESULTS then
				break
			end
		end
	end

	if n > 0 and n < MAX_RESULTS then
		self:SendMessage(sender, "DM", searchID, matches)
	end
end

function TooltipExchangeUI:DT(sender, searchID, tab)
	local matches, n = {}, 0

	for _, itemID in ipairs(tab) do
		local item = storage:GetItem(self:GetStorage(), itemID)

		if item then
			table.insert(matches, {
				i = storage:GetItemID(self:GetStorage(), item),
				c = storage:GetItemRarity(self:GetStorage(), item),
				n = storage:GetItemName(self:GetStorage(), item),
				o = storage:GetItemIcon(self:GetStorage(), item),
			})
			n = n + 1

			if n >= MAX_RESULTS then
				break
			end
		end
	end

	if n > 0 and n < MAX_RESULTS then
		self:SendMessage(sender, "DM", searchID, matches)
	end
end

------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------

function TooltipExchangeUI:ClearResults()
	self.searchID = nil

	for k in pairs(self.searchResults) do
		self.searchResults[k] = nil
	end

	for k in pairs(self.searchHash) do
		self.searchHash[k] = nil
	end

	self:UpdateResults()
end

function TooltipExchangeUI:Search(pattern, rarity, equiploc, ilvl, _type, subtype, stat1, value1, stat2, value2, stat3, value3)
	if string.len(pattern) < MIN_PATTERN and not rarity and not equiploc and not ilvl and not _type and not subtype and not stat1 and not stat2 and not stat3 then
		return
	end

	self:OpenUI(true)
	self:ClearResults()
	self.searchID = math.random(1000000, 9999999)

	local definition = {
		n = pattern,
		c = rarity,
		x = ilvl,
		t = _type,
		s = subtype,
		e = equiploc,
	}

	if stat1 or stat2 or stat3 then
		definition.a = {}

		if stat1 then table.insert(definition.a, { p = stat1, v = value1 }) end
		if stat2 then table.insert(definition.a, { p = stat2, v = value2 }) end
		if stat3 then table.insert(definition.a, { p = stat3, v = value3 }) end
	end

	if not _type or _type ~= "Recipe" then
		for itemID, _ in storage:Search(self:GetStorage(), definition) do
			self.searchHash[itemID] = 1
			table.insert(self.searchResults, {
				i = itemID,
			})
		end
	end

	if not definition.a then
		for i = 1, MAX_ITEMID do
			if not storage:HasItem(self:GetStorage(), i) then
				local n, _, c, x, _, t, s, _, e, o = GetItemInfo(i)
				local match = n and true or false

				if match and definition.n and not string.find(string.lower(n), definition.n, 1, true) then match = false end
				if match and definition.c and c < definition.c then match = false end
				if match and definition.t and t ~= definition.t then match = false end
				if match and definition.s and s ~= definition.s then match = false end
				if match and definition.e and e ~= definition.e then match = false end
				if match and definition.x and x < definition.x then match = false end

				if match then
					self.searchHash[i] = 1
					table.insert(self.searchResults, {
						i = i,
						c = c,
						n = n,
						o = o,
					})
				end
			end
		end
	end

	self:TriggerEvent("TooltipExchange_ResultsChanged")

	if (not _type or _type ~= "Recipe") and #(self.searchResults) < MAX_RESULTS then
		self:SendMessage(nil, "DS", self.searchID, definition, self.searchHash)
	end

	return true
end

function TooltipExchangeUI:Similar(itemID)
	self:OpenUI(true)
	self:ClearResults()
	self.searchID = math.random(1000000, 9999999)

	for itemID, _ in storage:Similar(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID), self.db.profile.typeWeight, self.db.profile.missingWeight, self.db.profile.valueExponent, self.db.profile.cutoff) do
		self.searchHash[itemID] = 1
		table.insert(self.searchResults, {
			i = itemID,
		})
	end

	self:TriggerEvent("TooltipExchange_ResultsChanged")

	if #(self.searchResults) < MAX_RESULTS then
		local item = {}

		storage:Eject(self:GetStorage(), itemID, item)

		self:SendMessage(nil, "DC", self.searchID, item, self.searchHash, self.db.profile.typeWeight, self.db.profile.missingWeight, self.db.profile.valueExponent, self.db.profile.cutoff)
	end
end

function TooltipExchangeUI:ReportResults(target)
	local whisper, privateChat, sent = true, false, false

	if string.find(target, "^:.+") then
		privateChat = true
		target = string.sub(target, 2)
	else
		for _, t in ipairs(reportTargets) do
			if t.chat == target then
				whisper = false
				break
			end
		end
	end

	local p = function(message)
		if privateChat then
			PrivateChat:SendTo(target, message)
		elseif not whisper then
			SendChatMessage(message, target)
		else
			SendChatMessage(message, "WHISPER", nil, target)
		end
	end

	p(string.format("[[ %s ]]", "Tooltip Exchange"))

	for _, item in ipairs(self.searchResults) do
		local _, l = GetItemInfo(item.i)

		if l then
			p(l)
		end
	end
end

------------------------------------------------------------------------
-- Interface
------------------------------------------------------------------------

function TooltipExchangeUI:OpenUI(dontHide)
	self:CreateUI()

	if not self.frames.main:IsShown() then
		self.frames.main:Show()
	elseif not dontHide then
		self.frames.main:Hide()
	end
end

function TooltipExchangeUI:CreateUI()
	if self.frames then
		return
	end

	self.frames = {}
	self.tooltips = {}
	self.lines = {}

	--[[-----------------------------------------------------------------
	  Main Frame
	-----------------------------------------------------------------]]--

	local f = CreateFrame("Frame", nil, UIParent)
	f:Hide()
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(270)
	f:SetHeight(29 + 19 * self.resultRows)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	})
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton") 
	f:SetScript("OnDragStart", function(this)
		if not self.db.profile.locked then
			this:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(this)
		if not self.db.profile.locked then
			this:StopMovingOrSizing()
			self:SavePosition()
		end
	end)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	f.menuButton = CreateFrame("Button", nil, f)
	f.menuButton:SetWidth(240)
	f.menuButton:SetHeight(19)
	f.menuButton:RegisterForDrag("LeftButton")
	f.menuButton:SetScript("OnDragStart", function(this)
		if not self.db.profile.locked then
			this:GetParent():StartMoving()
		end
	end)
	f.menuButton:SetScript("OnDragStop", function(this)
		if not self.db.profile.locked then
			this:GetParent():StopMovingOrSizing()
			self:SavePosition()
		end
	end)
	f.menuButton:RegisterForClicks("RightButtonUp")
	f.menuButton:SetScript("OnClick", function(this, btn)
		if dewdrop:IsOpen(f) then
			dewdrop:Close()
		else
			dewdrop:Open(f, 'children', function()
				if not self.saneOptions then
					self.saneOptions = {
						type = "group",
						args = {
							addonHeader = {
								type = "header",
								name = self.core.title,
								order = 1,
							},
						},
						handler = self.core.options.handler,
					}

					for k, v in pairs(self.core.options.args) do
						if v.order and v.order > 0 then
							self.saneOptions.args[k] = v
						end
					end
				end

				dewdrop:FeedAceOptionsTable(self.saneOptions)
			end)
		end
	end)
	f.menuButton:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5)

	f.headerBar = f:CreateTexture(nil, "ARTWORK")
	f.headerBar:SetWidth(260)
	f.headerBar:SetHeight(19)
	f.headerBar:SetTexture("Interface\\AddOns\\TooltipExchange\\Textures\\otravi.tga")
	f.headerBar:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5)
	f.headerBar:SetGradient("HORIZONTAL", 0.8, 0, 0, 0.4, 0, 0)

	f.headerText = f:CreateFontString(nil, "OVERLAY")
	f.headerText:SetWidth(240)
	f.headerText:SetHeight(12)
	f.headerText:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -8)
	f.headerText:SetFontObject(GameFontNormal)
	f.headerText:SetJustifyH("LEFT")
	f.headerText:SetTextColor(1, 1, 1)
	f.headerText:SetText("Tooltip Exchange")

	f.closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	f.closeButton:SetWidth(27)
	f.closeButton:SetHeight(27)
	f.closeButton:SetPoint("TOPRIGHT", f) 

	f.scroll = CreateFrame("ScrollFrame", "TooltipExchange_ItemsScrollFrame", f, "FauxScrollFrameTemplate")
	f.scroll:SetScript("OnVerticalScroll", function(this, value)
		FauxScrollFrame_OnVerticalScroll(this, value, 19, function()
			self:UpdateResults()
		end)
	end)
	f.scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -23)
	f.scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 5)

	self.frames.main = f

	--[[-----------------------------------------------------------------
	  Item Rows
	-----------------------------------------------------------------]]--

	self.frames.main.items = {}

	local p

	for i = 1, self.resultRows do
		local f = CreateFrame("Button", nil, self.frames.main)
		f.itemID = nil
		f:SetWidth(240)
		f:SetHeight(18)
		f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		f:SetScript("OnEnter", function(this)
			if this:IsVisible() then
				self:ShowItemTooltip(this.itemID, this.icon:GetTexture())
				this.highlight:Show()
			end
		end)
		f:SetScript("OnLeave", function(this)
			self.tooltips.show:Hide()
			self.tooltips.data:Hide()
			this.highlight:Hide()
		end)
		f:SetScript("OnClick", function(this, btn)
			if this:IsVisible() then
				if btn == "LeftButton" then
					local itemID = f.itemID
					local link

					if storage:HasItem(self:GetStorage(), itemID) then
						link = storage:GetItemLink(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID))
					else
						for _, v in ipairs(self.searchResults) do
							if v.i == itemID and type(v.n) == "string" and type(v.c) == "number" then
								link = ITEM_QUALITY_COLORS[v.c].hex .. "|Hitem:" .. v.i .. ":0:0:0:0:0:0:0|h[" .. v.n .. "]|h|r"
								break
							end
						end
					end

					if (IsControlKeyDown() or IsShiftKeyDown()) and GetItemInfo(itemID) then
						if link then
							if IsControlKeyDown() then
								DressUpItemLink(link)
							elseif IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
								ChatFrameEditBox:Insert(link)
							end
						end

						return
					end

					if self.doubleClickCheck then
						self.doubleClickCheck = nil

						if not GetItemInfo(itemID) then
							self.core:Debug("M", link)

							SetItemRef(string.format("item:%d", itemID))
							ItemRefTooltip:Hide()

							self:ScheduleEvent(function()
								self:TriggerEvent("TooltipExchange_ItemSeen", tonumber(itemID))

								if GetItemInfo(itemID) then
									f.icon:SetVertexColor(1, 1, 1)
								else
									f.icon:SetVertexColor(1, 0, 0)
								end
							end, 1)
						end
					else
						self.doubleClickCheck = true

						self:ScheduleEvent(function()
							self.doubleClickCheck = nil
						end, 0.5)
					end
				elseif btn == "RightButton" then
					if dewdrop:IsOpen(f) then
						dewdrop:Close()
					else
						dewdrop:Open(f, 'point', "TOPLEFT", 'relativePoint', "TOPRIGHT", 'children', function(level, value1, value2, value3)
							local itemID = f.itemID

							if level == 1 then
								dewdrop:AddLine(
									'isTitle', true,
									'text', f.name:GetText(),
									'icon', f.icon:GetTexture()
								)
								dewdrop:AddLine(
									'text', L["Find Similar"],
									'func', function() self:Similar(itemID) dewdrop:Close() end
								)

								if GetItemInfo(itemID) then
									dewdrop:AddLine(
										'text', L["Dress Up"],
										'func', function() DressUpItemLink(string.format("item:%d", itemID)) dewdrop:Close() end
									)
								else
									dewdrop:AddLine(
										'text', L["Mine"],
										'func', function()
											local link

											if storage:HasItem(self:GetStorage(), itemID) then
												link = storage:GetItemLink(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID))
											else
												for _, v in ipairs(self.searchResults) do
													if v.i == itemID and type(v.n) == "string" and type(v.c) == "number" then
														link = ITEM_QUALITY_COLORS[v.c].hex .. "|Hitem:" .. v.i .. ":0:0:0:0:0:0:0|h[" .. v.n .. "]|h|r"
														break
													end
												end
											end

											self.core:Debug("M", link)

											SetItemRef(string.format("item:%d", itemID))
											ItemRefTooltip:Hide()

											self:ScheduleEvent(function()
												self:TriggerEvent("TooltipExchange_ItemSeen", tonumber(itemID))

												if GetItemInfo(itemID) then
													f.icon:SetVertexColor(1, 1, 1)
												else
													f.icon:SetVertexColor(1, 0, 0)
												end
											end, 1)

											dewdrop:Close()
										end
									)
								end
							end

							self:TriggerEvent("TooltipExchange_UIItemContextMenuCreated", itemID, level, value1, value2, value3)

							if level == 1 then
								dewdrop:AddLine(
									'notClickable', true
								)
								dewdrop:AddLine(
									'text', L["Close window"],
									'func', function() dewdrop:Close() end
								)
							end
						end)
					end
				end
			end
		end)

		f.icon = f:CreateTexture(nil, "OVERLAY")
		f.icon:SetWidth(18)
		f.icon:SetHeight(18)
		f.icon:SetPoint("LEFT", f, "LEFT", 0, 0)

		f.highlight = f:CreateTexture(nil, "ARTWORK")
		f.highlight:SetWidth(242)
		f.highlight:SetHeight(18)
		f.highlight:SetTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
		f.highlight:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
		f.highlight:SetTexCoord(0, 1, 0, 0.578125)
		f.highlight:Hide()

		f.name = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		f.name:SetWidth(220)
		f.name:SetHeight(18)
		f.name:SetJustifyH("LEFT")
		f.name:SetPoint("LEFT", f, "LEFT", 19, 0)

		if i == 1 then
			f:SetPoint("TOPLEFT", self.frames.main, "TOPLEFT", 6, -25)
		else
			f:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 0, -1)
		end

		table.insert(self.frames.main.items, f)
		p = f
	end

	--[[-----------------------------------------------------------------
	  Search Form
	-----------------------------------------------------------------]]--

	-- Line 1 :

	self.frames.main.nameTextBox = TooltipExchangeUI:CreateTextBox(self.frames.main, {
		width = 145,
		hint = L["Item name to be looked for."],
		func = function() self:SubmitSearch() end,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, 2 },
	})

	self.frames.main.searchButton = TooltipExchangeUI:CreateButton(self.frames.main, {
		width = 60,
		text = L["Search"],
		func = function() self:SubmitSearch() end,
		anchor = { "LEFT", self.frames.main.nameTextBox, "RIGHT", -1, 0 },
	})

	self.frames.main.resetButton = TooltipExchangeUI:CreateButton(self.frames.main, {
		width = 60,
		text = "Clear",
		func = function() self:ClearSearch() self:ClearResults() end,
		anchor = { "LEFT", self.frames.main.searchButton, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.nameTextBox, controls = { self.frames.main.nameTextBox, self.frames.main.searchButton, self.frames.main.resetButton }})

	-- Line 2 :

	self.frames.main.rarityDropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 90,
		hint = L["Item rarity level requirement. Only items at given rarity level or better will be returned."],
		list = rarityList,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, -19 },
		default = self:GetRarityLevel() + 2,
	})

	self.frames.main.equipDropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 140,
		hint = L["Item equip location requirement. Have in mind multiple options may correspond to same location, because of game design."],
		list = equipList,
		anchor = { "LEFT", self.frames.main.rarityDropDown, "RIGHT", -1, 0 },
	})

	self.frames.main.itemLevelTextBox = TooltipExchangeUI:CreateTextBox(self.frames.main, {
		width = 35,
		hint = L["Item level requirement."],
		length = 3,
		isNumeric = true,
		justify = "RIGHT",
		func = function() self:SubmitSearch() end,
		anchor = { "LEFT", self.frames.main.equipDropDown, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.rarityDropDown, controls = { self.frames.main.rarityDropDown, self.frames.main.equipDropDown, self.frames.main.itemLevelTextBox }})

	-- Line 3 :

	self.frames.main.typeDropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 132,
		hint = L["Item type requirement. Have in mind some types have subtypes while other dont."],
		list = typeList,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, -40 },
	})

	self.frames.main.subtypeDropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 132,
		hint = L["Item subtype requirement."],
		list = subtypeList,
		parent = self.frames.main.typeDropDown,
		anchor = { "LEFT", self.frames.main.typeDropDown, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.typeDropDown, controls = { self.frames.main.typeDropDown, self.frames.main.subtypeDropDown }})

	-- Line 4 :

	self.frames.main.stat1DropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 221,
		hint = L["Item stat to be looked for during searching matching items. If no value is specified, then only existance of given stat is checked."],
		list = statList,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, -61 },
	})

	self.frames.main.stat1TextBox = TooltipExchangeUI:CreateTextBox(self.frames.main, {
		width = 43,
		hint = L["If entered, items with selected stat value greater or equal than this value will be returned."],
		length = 4,
		isNumeric = true,
		justify = "RIGHT",
		func = function() self:SubmitSearch() end,
		anchor = { "LEFT", self.frames.main.stat1DropDown, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.stat1DropDown, controls = { self.frames.main.stat1DropDown, self.frames.main.stat1TextBox }})

	-- Line 5 :

	self.frames.main.stat2DropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 221,
		hint = L["Item stat to be looked for during searching matching items. If no value is specified, then only existance of given stat is checked."],
		list = statList,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, -61 },
	})

	self.frames.main.stat2TextBox = TooltipExchangeUI:CreateTextBox(self.frames.main, {
		width = 43,
		hint = L["If entered, items with selected stat value greater or equal than this value will be returned."],
		length = 4,
		isNumeric = true,
		justify = "RIGHT",
		func = function() self:SubmitSearch() end,
		anchor = { "LEFT", self.frames.main.stat2DropDown, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.stat2DropDown, controls = { self.frames.main.stat2DropDown, self.frames.main.stat2TextBox }})

	-- Line 6 :

	self.frames.main.stat3DropDown = TooltipExchangeUI:CreateDropDownMenu(self.frames.main, {
		width = 221,
		hint = L["Item stat to be looked for during searching matching items. If no value is specified, then only existance of given stat is checked."],
		list = statList,
		anchor = { "TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, -61 },
	})

	self.frames.main.stat3TextBox = TooltipExchangeUI:CreateTextBox(self.frames.main, {
		width = 43,
		hint = L["If entered, items with selected stat value greater or equal than this value will be returned."],
		length = 4,
		isNumeric = true,
		justify = "RIGHT",
		func = function() self:SubmitSearch() end,
		anchor = { "LEFT", self.frames.main.stat3DropDown, "RIGHT", -1, 0 },
	})

	table.insert(self.lines, { main = self.frames.main.stat3DropDown, controls = { self.frames.main.stat3DropDown, self.frames.main.stat3TextBox }})

	--[[-----------------------------------------------------------------
	  Item Tooltip
	-----------------------------------------------------------------]]--

	local f = CreateFrame("GameTooltip", "TooltipExchange_TooltipShow", UIParent, "GameTooltipTemplate")

	f.icon = f:CreateTexture(nil, "ARTWORK")
	f.icon:SetWidth(39)
	f.icon:SetHeight(39)

	self.tooltips.show = f

	local f = CreateFrame("GameTooltip", "TooltipExchange_TooltipAdditional", UIParent, "GameTooltipTemplate")

	self.tooltips.data = f

	--[[-----------------------------------------------------------------
	  Settings
	-----------------------------------------------------------------]]--

	self:SetupSearchLines()
	self:SetBackdropAlpha()
	self:RestorePosition()
	self:UpdateResults()
end

function TooltipExchangeUI:SetupSearchLines()
	if not self.lines then
		return
	end

	local offset = 2

	for i, v in ipairs(self.lines) do
		local shown = self.db.profile["searchLine" .. i]

		v.main:ClearAllPoints()

		if shown then
			v.main:SetPoint("TOPLEFT", self.frames.main, "BOTTOMLEFT", 3, offset)
			offset = offset - 21
		end

		for _, c in ipairs(v.controls) do
			if shown then
				c:Show()
			else
				c:Hide()
			end
		end
	end
end

function TooltipExchangeUI:SubmitSearch()
	if self:Search(
			self.frames.main.nameTextBox:IsVisible() and self.frames.main.nameTextBox:GetText() or nil,
			self.frames.main.rarityDropDown:IsVisible() and self.frames.main.rarityDropDown.value or nil,
			self.frames.main.equipDropDown:IsVisible() and self.frames.main.equipDropDown.value or nil,
			self.frames.main.itemLevelTextBox:IsVisible() and tonumber(self.frames.main.itemLevelTextBox:GetText()) or nil,
			self.frames.main.typeDropDown:IsVisible() and self.frames.main.typeDropDown.value or nil,
			self.frames.main.subtypeDropDown:IsVisible() and self.frames.main.subtypeDropDown.value or nil,
			self.frames.main.stat1DropDown:IsVisible() and self.frames.main.stat1DropDown.value or nil,
			self.frames.main.stat1TextBox:IsVisible() and tonumber(self.frames.main.stat1TextBox:GetText()) or nil,
			self.frames.main.stat2DropDown:IsVisible() and self.frames.main.stat2DropDown.value or nil,
			self.frames.main.stat2TextBox:IsVisible() and tonumber(self.frames.main.stat2TextBox:GetText()) or nil,
			self.frames.main.stat3DropDown:IsVisible() and self.frames.main.stat3DropDown.value or nil,
			self.frames.main.stat3TextBox:IsVisible() and tonumber(self.frames.main.stat3TextBox:GetText()) or nil
	) then
		for _, v in ipairs(self.lines) do
			for _, c in ipairs(v.controls) do
				if c["ClearFocus"] then
					c:ClearFocus()
				end
			end
		end

		self.frames.main.searchButton:Disable()
		self:ScheduleEvent(function()
			self.frames.main.searchButton:Enable()
		end, 3)
	else
		self.frames.main.nameTextBox:SetFocus()
	end
end

function TooltipExchangeUI:ClearSearch()
	for _, v in ipairs(self.lines) do
		for _, c in ipairs(v.controls) do
			if c["Reset"] then
				c:Reset()
			end

			if c["ClearFocus"] then
				c:ClearFocus()
			end
		end
	end
end

function TooltipExchangeUI:UpdateResults()
	if not self.frames then
		return
	end

	FauxScrollFrame_Update(self.frames.main.scroll, #(self.searchResults), self.resultRows, 19);

	for i = 1, self.resultRows do
		local index = i + FauxScrollFrame_GetOffset(self.frames.main.scroll)

		if (index <= #(self.searchResults)) then
			if not self.searchResults[index].n then
				local item = storage:GetItem(self:GetStorage(), self.searchResults[index].i)

				self.frames.main.items[i].itemID = storage:GetItemID(self:GetStorage(), item)
				self.frames.main.items[i].icon:SetTexture(storage:GetItemIcon(self:GetStorage(), item))
				self.frames.main.items[i].name:SetText(storage:GetItemColoredName(self:GetStorage(), item))
			else
				local item = self.searchResults[index]

				self.frames.main.items[i].itemID = item.i
				self.frames.main.items[i].icon:SetTexture(item.o)
				self.frames.main.items[i].name:SetText(ITEM_QUALITY_COLORS[item.c].hex .. item.n .. "|r")
			end

			if GetItemInfo(self.searchResults[index].i) then
				self.frames.main.items[i].icon:SetVertexColor(1, 1, 1)
			else
				self.frames.main.items[i].icon:SetVertexColor(1, 0, 0)
			end

			self.frames.main.items[i]:Show()
		else
			self.frames.main.items[i]:Hide()
		end
	end

	self.frames.main.headerText:SetText(string.format("Tooltip Exchange (%d)", #(self.searchResults)))
end

function TooltipExchangeUI:PlaceTooltip()
	if self.db.profile.tooltipPosition == "left" then
		self.tooltips.show.icon:ClearAllPoints()
		self.tooltips.show.icon:SetPoint("TOPLEFT", self.tooltips.show, "TOPLEFT", -37, -3)

		if self.db.profile.fixedTooltip then
			self.tooltips.show:SetOwner(self.frames.main.items[1], "ANCHOR_BOTTOMLEFT", -2, 43)
		else
			self.tooltips.show:SetOwner(this, "ANCHOR_BOTTOMLEFT")
		end
	else
		self.tooltips.show.icon:ClearAllPoints()
		self.tooltips.show.icon:SetPoint("TOPRIGHT", self.tooltips.show, "TOPRIGHT", 37, -3)

		if self.db.profile.fixedTooltip then
			self.tooltips.show:SetOwner(self.frames.main.items[1], "ANCHOR_BOTTOMRIGHT", 20, 43)
		else
			self.tooltips.show:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
		end
	end

	self.tooltips.data:SetOwner(self.tooltips.show, "ANCHOR_NONE")
	self.tooltips.data:ClearAllPoints()
	self.tooltips.data:SetPoint("TOPLEFT", self.tooltips.show, "BOTTOMLEFT", 0, 3)
--	self.tooltips.data:SetPoint("TOPRIGHT", self.tooltips.show, "BOTTOMRIGHT", 0, 3)
end

function TooltipExchangeUI:UpdateDataTooltip(itemID, item)
	local n, x, c

	n, _, c, x = GetItemInfo(itemID)

	if n then
		n = ITEM_QUALITY_COLORS[c].hex .. n .. "|r" 
	elseif item then
		local s = self:GetStorage()

		n = storage:GetItemColoredName(s, item)
		x = storage:GetItemLevel(s, item)
	end

	if not n or not x then
		return
	end

	self.tooltips.data:AddLine(n)

	if self.db.profile.additionalData then
		self.tooltips.data:AddDoubleLine(string.format("ID: %d", itemID), string.format("Level: %d", x), 0.25, 1, 0.75, 0.25, 1, 0.75)
	end

	if self.db.profile.sourceInfo then
		local d = periodic_ItemSearch(itemID)

		if d and #(d) > 0 then
			local a = {}
			local drops, mats, instance

			for _, set in ipairs(d) do
				if type(drops) ~= "boolean" and string.find(set, "InstanceLoot", 1, true) then
					for w in string.gmatch(set, "[^%.]+") do
						table.insert(a, w)
					end

					if #(a) == 3 then
						if not drops then
							drops = {}
						end

						if instance and instance ~= a[2] then
							drops = true
						else
							instance = a[2] 
							table.insert(drops, {
								instance = a[2],
								boss = a[3],
								heroic = a[1] == "InstanceLootHeroic" and true or nil
							})
						end
					end
				elseif string.find(set, "TradeskillResultMats.Forward", 1, true) then
					if mats then
						mats = true
					else
						local m = periodic:GetSetTable(set)[itemID]

						if m then
							mats = {}

							for itemID, count in string.gmatch(m, "(%d+)x(%d+)") do
								itemID = tonumber(itemID)
								count = tonumber(count)

								local n, _, c, _, _, _, _, _, _, t = GetItemInfo(itemID)

								if n then
									table.insert(mats, {
										name = ITEM_QUALITY_COLORS[c].hex .. n .. "|r",
										count = count,
										icon = t,
									})
								elseif storage:HasItem(self:GetStorage(), itemID) then
									table.insert(mats, {
										name = storage:GetItemColoredName(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
										count = count,
										icon = storage:GetItemIcon(self:GetStorage(), storage:GetItem(self:GetStorage(), itemID)),
									})
								else
									table.insert(mats, {
										name = "|cffff0000" .. itemID .. "|r",
										count = count,
										icon = "Interface\\Icons\\INV_Misc_QuestionMark",
									})
								end
							end
						end
					end
				end

				while #(a) > 0 do
					table.remove(a)
				end
			end

			if type(drops) == "table" then
				self.tooltips.data:AddLine(L["Dropped by:"], 1, 1, 1)

				for _, b in ipairs(drops) do
					self.tooltips.data:AddLine(string.format("  |cffaaaaff%s|r |cff808080(%s|r%s|cff808080)|r", b.boss, b.instance, b.heroic and " |cffcc9933" .. L["Heroic"] .. "|r" or ""), nil, nil, nil, 1)
				end
			end

			if type(drops) == "boolean" then
				self.tooltips.data:AddLine(L["Dropped by:"], 1, 1, 1)
				self.tooltips.data:AddLine(string.format("  |cff00ff00%s|r", L["World drop"]), nil, nil, nil, 1)
			end

			if type(mats) == "table" then
				self.tooltips.data:AddLine(L["Crafted from:"], 1, 1, 1)

				for _, m in ipairs(mats) do
					self.tooltips.data:AddLine(string.format("%s %s", m.name, m.count > 1 and "x" .. m.count or ""), 1, 1, 1)
					self.tooltips.data:AddTexture(m.icon)
				end
			end
		end
	end

	self:TriggerEvent("TooltipExchange_DataTooltipUpdate", itemID, item, self.tooltips.data)

	if self.tooltips.data:NumLines() > 1 then
		local width = 0

		for i = 1, self.tooltips.data:NumLines() do
			local l = getglobal(self.tooltips.data:GetName() .. "TextLeft" .. i)
			local r = getglobal(self.tooltips.data:GetName() .. "TextRight" .. i)

			local w

			if r:GetText() then
				w = l:GetWidth() + r:GetWidth() + 40
			else
				w = l:GetWidth() + 20
			end

			if w > width then
				width = w
			end
		end

		if width > 225 then
			width = 225
		end

		if width > self.tooltips.show:GetWidth() - 10 then
			self.tooltips.show:SetMinimumWidth(width)
			self.tooltips.show:Show()
		end

		self.tooltips.data:SetMinimumWidth(self.tooltips.show:GetWidth() - 21)
		self.tooltips.data:Show()
	end
end

function TooltipExchangeUI:ShowItemTooltip(itemID, icon)
	if GetItemInfo(itemID) then
		local item = storage:GetItem(self:GetStorage(), itemID)

		self:PlaceTooltip()
		self.tooltips.show:SetHyperlink(string.format("item:%d", itemID))
		self.tooltips.show.icon:SetTexture(icon)
		self:UpdateDataTooltip(itemID, item)

	elseif storage:HasItem(self:GetStorage(), itemID) then
		local item = storage:GetItem(self:GetStorage(), itemID)

		self:PlaceTooltip()
		storage:BuildItemTooltip(self:GetStorage(), item, self.tooltips.show)
		self.tooltips.show:Show()
		self.tooltips.show.icon:SetTexture(icon)
		self:UpdateDataTooltip(item.i, item)

	else
		local provider

		for _, item in ipairs(self.searchResults) do
			if item.i == itemID then
				provider = item.p
				break
			end
		end

		if provider then
			self:PlaceTooltip()
			self.tooltips.show.requestedID = itemID
			self.tooltips.show:SetOwner(UIParent, "ANCHOR_PRESERVE")
			self.tooltips.show:SetText(L["|cff40ffc0Requesting item data...|r"])
			self.tooltips.show:Show()
			self.tooltips.show.icon:SetTexture(icon)

			self:SendMessage(provider, "DR", itemID, provider)
		end
	end
end

function TooltipExchangeUI:SetBackdropAlpha()
	if not self.frames or not self.lines then
		return
	end

	self.frames.main:SetBackdropColor(0, 0, 0, self.db.profile.backgroundAlpha)

	for _, v in ipairs(self.lines) do
		for _, c in ipairs(v.controls) do
			if c["SetBackdropColor"] then c:SetBackdropColor(0, 0, 0, self.db.profile.backgroundAlpha) end
		end
	end
end

function TooltipExchangeUI:SavePosition()
	if not self.frames then
		return
	end

	local x, y, s = self.frames.main:GetLeft(), self.frames.main:GetTop(), self.frames.main:GetEffectiveScale()

	x, y = x * s, y * s

	self.db.profile.mainPositionX = x
	self.db.profile.mainPositionY = y
end

function TooltipExchangeUI:RestorePosition()
	if not self.frames then
		return
	end

	local x, y, s = self.db.profile.mainPositionX, self.db.profile.mainPositionY, self.frames.main:GetEffectiveScale()

	if not x or not y or not s then
		return
	end

	x, y = x / s, y / s

	self.frames.main:ClearAllPoints()
	self.frames.main:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
end

------------------------------------------------------------------------
-- Dynamic Menu
------------------------------------------------------------------------

function TooltipExchangeUI:CreateStaticMenu()
	local a = self.commands.report.args

	a.report = { type = 'header', name = L["Report"], order = 1 }

	for i = 1, #(reportTargets) do
		local target = reportTargets[i].chat

		a[string.lower(target)] = {
			type = 'execute',
			name = L[string.upper(string.sub(target, 1, 1)) .. string.lower(string.sub(target, 2))],
			desc = string.format(L["Reports to %s chat."], string.lower(target)),
			order = 100 + i,
			func = function() return self:ReportResults(target) end,
			hidden = reportTargets[i].isHidden,
		}
	end

	a["whisper"] = {
		type = 'text',
		name = L["Whisper"],
		desc = L["Reports to given person."],
		get = false,
		set = function(v) self:ReportResults(v) end,
		usage = L["<name>"],
		order = 200,
		validate = function(v) return string.find(v, "^(%S+)$") end,	
	}

	if PrivateChat then
		for _, channel in pairs(PrivateChat.db.profile.channels) do
			local target = channel.name

			a[string.gsub(target, "[^%w]", "")] = {
				type = 'execute',
				name = target,
				desc = string.format(L["Reports to %s chat."], string.lower(target)),
				order = 300,
				func = function() return self:ReportResults(":" .. target) end,
			}
		end
	end
end

------------------------------------------------------------------------
-- Generic UI Code
------------------------------------------------------------------------

--[[--------------------------------------------------------------------
  CreateTextBox(parent, spec)

	width (80)
	hint (nil)
	length (255)
	isNumeric (false)
	justify ("LEFT")
	func (nil)
	anchor (nil)
--------------------------------------------------------------------]]--

function TooltipExchangeUI:CreateTextBox(parent, spec)
	local f = CreateFrame("EditBox", nil, parent)
	f:SetWidth(spec.width or 80)
	f:SetHeight(22)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0, 0, 0, 1)
	f:SetFontObject(GameFontHighlightSmall)
	f:SetTextInsets(5, 5, 0, 0)
	f:SetAutoFocus(false)
	f:SetMaxLetters(spec.length or 50)
	f:SetNumeric(spec.isNumeric and true or false)
	f:SetJustifyH(spec.justify or "LEFT")
	f:SetScript("OnEscapePressed", function() f:ClearFocus() end)
	if spec.hint then
		f:EnableMouse(true)
		f:SetScript("OnEnter", function() GameTooltip:SetOwner(f) GameTooltip:SetText(spec.hint, nil, nil, nil, nil, 1) end)
		f:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	if spec.func and type(spec.func) == "function" then
		f:SetScript("OnEnterPressed", function() spec.func() end)
	end
	if spec.anchor and type(spec.anchor) == "table" then
		f:SetPoint(spec.anchor[1], spec.anchor[2], spec.anchor[3], spec.anchor[4], spec.anchor[5])
	end
	f.Reset = function(self)
		f:SetText("")
	end
	return f
end

--[[-----------------------------------------------------------------
  CreateDropDownMenu(parent, spec)

	width (80)
	hint (nil)
	justify ("RIGHT")
	list (nil)
	parent (nil)
	anchor (nil)
	default (nil)
-----------------------------------------------------------------]]--

function TooltipExchangeUI:CreateDropDownMenu(parent, spec)
	local f = CreateFrame("Frame", nil, parent)
	f.children = {}
	f.parent = spec.parent or nil
	if f.parent then
		table.insert(f.parent.children, f)
	end
	f:SetWidth(spec.width or 80)
	f:SetHeight(22)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0, 0, 0, 1)
	if spec.hint then
		f:EnableMouse(true)
		f:SetScript("OnEnter", function() GameTooltip:SetOwner(f) GameTooltip:SetText(spec.hint, nil, nil, nil, nil, 1) end)
		f:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	f.selection = f:CreateFontString(nil, "BACKGROUND")
	f.selection:SetWidth(f:GetWidth() - 22)
	f.selection:SetHeight(16)
	f.selection:SetFontObject(GameFontHighlightSmall)
	f.selection:SetJustifyH(spec.justify or "RIGHT")
	f.selection:SetPoint("RIGHT", f, "RIGHT", -22, 0)

	f.button = CreateFrame("Button", nil, f)
	f.button:SetWidth(20)
	f.button:SetHeight(20)
	f.button:SetPoint("RIGHT", f, "RIGHT", -1, 0)
	f.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	f.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	f.button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	f.button.highlightTexture = f.button:CreateTexture()
	f.button.highlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	f.button.highlightTexture:SetBlendMode("ADD")
	f.button.highlightTexture:SetAllPoints(f.button)
	f.button:SetHighlightTexture(f.button.highlightTexture)
	f.button:SetScript("OnHide", function() dewdrop:Close() end)
	f.button:SetScript("OnClick", function()
		PlaySound("igMainMenuOptionCheckBoxOn")
		if dewdrop:IsOpen(f) then
			dewdrop:Close()
		else
			dewdrop:Open(f, 'point', "BOTTOMRIGHT", 'relativePoint', "TOPRIGHT", 'children', function()
				for _, i in ipairs(spec.list) do
					if not f.parent or not i.parent or i.parent == f.parent.value then
						dewdrop:AddLine(
							'text', i.text,
							'func', function(t, v)
								f.value = v
								f.selection:SetText(t)
								for _, g in ipairs(f.children) do
									g:Reset()
								end
								dewdrop:Close()
							end,
							'arg1', i.text,
							'arg2', i.value,
							'isRadio', true,
							'checked',  i.value == f.value
						)
					end
				end
			end)
		end
	end)
	
	if spec.anchor and type(spec.anchor) == "table" then
		f:SetPoint(spec.anchor[1], spec.anchor[2], spec.anchor[3], spec.anchor[4], spec.anchor[5])
	end

	function f:Reset()
		if f.parent then
			local enabled = false

			if f.parent.value then
				for _, i in ipairs(spec.list) do
					if i.parent == f.parent.value then
						enabled = true
						break
					end
				end
			end

			if enabled then
				f.selection:SetFontObject(GameFontHighlightSmall)
				f.button:Enable()
			else
				f.selection:SetFontObject(GameFontDisableSmall)
				f.button:Disable()
			end
		end

		f.value = spec.list and spec.list[spec.default or 1] and spec.list[spec.default or 1].value or nil
		f.selection:SetText(spec.list and spec.list[spec.default or 1] and spec.list[spec.default or 1].text or "")

		for _, g in ipairs(f.children) do
			g:Reset()
		end
	end

	f:Reset()

	return f
end

--[[-----------------------------------------------------------------
  CreateButton(parent, spec)

	width (80)
	text ("")
	func (nil)
	anchor (nil)
-----------------------------------------------------------------]]--

function TooltipExchangeUI:CreateButton(parent, spec)
	local f = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	f:SetWidth(spec.width or 80)
	f:SetHeight(22)
	f:SetText(spec.text or "")
	if spec.func and type(spec.func) == "function" then
		f:SetScript("OnClick", function() spec.func() end)
	end
	if spec.anchor and type(spec.anchor) == "table" then
		f:SetPoint(spec.anchor[1], spec.anchor[2], spec.anchor[3], spec.anchor[4], spec.anchor[5])
	end
	return f
end
