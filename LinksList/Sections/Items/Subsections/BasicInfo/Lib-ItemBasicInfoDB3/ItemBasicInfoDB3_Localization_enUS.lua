
local o = ItemBasicInfoDB3; if (o.SHOULD_LOAD == nil) then return; end

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
-- These are the item type and subtype values exactly as they are returned from GetItemInfo.
-- They are not available unlocalized from the API, so must be delocalized for storage in the database.
TYPES_AND_SUBTYPES = {
	ARMOR = ("Armor");
		ARMOR_CLOTH = ("Cloth");
		ARMOR_LEATHER = ("Leather");
		ARMOR_MAIL = ("Mail");
		ARMOR_PLATE = ("Plate");
		ARMOR_SHIELDS = ("Shields");
		ARMOR_IDOLS = ("Idols");
		ARMOR_LIBRAMS = ("Librams");
		ARMOR_TOTEMS = ("Totems");
		ARMOR_SIGILS = ("Sigils");
		ARMOR_MISC = ("Miscellaneous");
	WEAPON = ("Weapon");
		WEAPON_AXES_ONEHAND = ("One-Handed Axes");
		WEAPON_AXES_TWOHAND = ("Two-Handed Axes");
		WEAPON_SWORDS_ONEHAND = ("One-Handed Swords");
		WEAPON_SWORDS_TWOHAND = ("Two-Handed Swords");
		WEAPON_MACES_ONEHAND = ("One-Handed Maces");
		WEAPON_MACES_TWOHAND = ("Two-Handed Maces");
		WEAPON_POLEARMS = ("Polearms");
		WEAPON_DAGGERS = ("Daggers");
		WEAPON_FIST_WEAPONS = ("Fist Weapons");
		WEAPON_STAVES = ("Staves");
		WEAPON_WANDS = ("Wands");
		WEAPON_GUNS = ("Guns");
		WEAPON_BOWS = ("Bows");
		WEAPON_CROSSBOWS = ("Crossbows");
		WEAPON_THROWN = ("Thrown");
		WEAPON_FISHING_POLES = ("Fishing Poles");
		WEAPON_MISC = ("Miscellaneous");
	CONTAINER = ("Container");
		-- All of the Container type's subtypes have non-plural names.
		CONTAINER_BAG = ("Bag");
		CONTAINER_HERB_BAG = ("Herb Bag");
		CONTAINER_ENCHANTING_BAG = ("Enchanting Bag");
		CONTAINER_GEM_BAG = ("Gem Bag");
		CONTAINER_MINING_BAG = ("Mining Bag");
		CONTAINER_ENGINEERING_BAG = ("Engineering Bag");
		CONTAINER_SOUL_BAG = ("Soul Bag");
		CONTAINER_LEATHERWORKING_BAG = ("Leatherworking Bag");
		CONTAINER_INSCRIPTION_BAG = ("Inscription Bag");
	CONSUMABLE = ("Consumable");
		CONSUMABLE_FOOD_AND_DRINK = ("Food & Drink");
		CONSUMABLE_BANDAGE = ("Bandage");
		CONSUMABLE_POTION = ("Potion");
		CONSUMABLE_ELIXIR = ("Elixir");
		CONSUMABLE_FLASK = ("Flask");
		CONSUMABLE_SCROLL = ("Scroll");
		CONSUMABLE_ITEM_ENHANCEMENT = ("Item Enhancement");
		CONSUMABLE_CONSUMABLE = ("Consumable");
		CONSUMABLE_OTHER = ("Other");
	TRADE_GOODS = ("Trade Goods"); -- Conspicuously plural, unlike most other type names.
		TRADE_GOODS_MEAT = ("Meat");
		TRADE_GOODS_HERB = ("Herb");
		TRADE_GOODS_LEATHER = ("Leather");
		TRADE_GOODS_OTHER = ("Other");
		TRADE_GOODS_CLOTH = ("Cloth");
		TRADE_GOODS_METAL_AND_STONE = ("Metal & Stone");
		TRADE_GOODS_PARTS = ("Parts");
		TRADE_GOODS_EXPLOSIVES = ("Explosives");
		TRADE_GOODS_DEVICES = ("Devices");
		TRADE_GOODS_ENCHANTING = ("Enchanting");
		TRADE_GOODS_ELEMENTAL = ("Elemental");
		TRADE_GOODS_TRADE_GOODS = ("Trade Goods");
		TRADE_GOODS_JEWELCRAFTING = ("Jewelcrafting");
		TRADE_GOODS_MATERIALS = ("Materials");
		TRADE_GOODS_ARMOR_ENCHANTMENT = ("Armor Enchantment");
		TRADE_GOODS_WEAPON_ENCHANTMENT = ("Weapon Enchantment");
	PROJECTILE = ("Projectile");
		-- All of the Projectile type's subtypes have non-plural names.
		PROJECTILE_ARROW = ("Arrow");
		PROJECTILE_BULLET = ("Bullet");
	QUIVER = ("Quiver");
		-- All of the Quiver type's subtypes have non-plural names.
		QUIVER_QUIVER = ("Quiver");
		QUIVER_AMMO_POUCH = ("Ammo Pouch");
	RECIPE = ("Recipe");
		RECIPE_ALCHEMY = ("Alchemy");
		RECIPE_BLACKSMITHING = ("Blacksmithing");
		RECIPE_COOKING = ("Cooking");
		RECIPE_ENCHANTING = ("Enchanting");
		RECIPE_ENGINEERING = ("Engineering");
		RECIPE_FIRST_AID = ("First Aid");
		RECIPE_FISHING = ("Fishing");
		RECIPE_JEWELCRAFTING = ("Jewelcrafting");
		RECIPE_LEATHERWORKING = ("Leatherworking");
		RECIPE_TAILORING = ("Tailoring");
		RECIPE_BOOK = ("Book"); -- Conspicuously non-plural.
	GEM = ("Gem");
		GEM_RED = ("Red");
		GEM_BLUE = ("Blue");
		GEM_YELLOW = ("Yellow");
		GEM_PURPLE = ("Purple");
		GEM_GREEN = ("Green");
		GEM_ORANGE = ("Orange");
		GEM_META = ("Meta");
		GEM_SIMPLE = ("Simple");
		GEM_PRISMATIC = ("Prismatic");
	MISC = ("Miscellaneous");
		MISC_JUNK = ("Junk");
		MISC_REAGENT = ("Reagent");
		MISC_PET = ("Pet");
		MISC_HOLIDAY = ("Holiday");
		MISC_OTHER = ("Other");
		MISC_MOUNT = ("Mount");
	QUEST = ("Quest");
		QUEST_QUEST = ("Quest");
	REAGENT = ("Reagent");
		REAGENT_REAGENT = ("Reagent");
	KEY = ("Key");
		KEY_KEY = ("Key");
	GLYPH = ("Glyph");
		GLYPH_GLYPH = ("Glyph");
		GLYPH_DEATH_KNIGHT = ("Death Knight");
		GLYPH_DRUID = ("Druid");
		GLYPH_HUNTER = ("Hunter");
		GLYPH_MAGE = ("Mage");
		GLYPH_PALADIN = ("Paladin");
		GLYPH_PRIEST = ("Priest");
		GLYPH_ROGUE = ("Rogue");
		GLYPH_SHAMAN = ("Shaman");
		GLYPH_WARLOCK = ("Warlock");
		GLYPH_WARRIOR = ("Warrior");
	MONEY = ("Money");
		MONEY_MONEY = ("Money");
		MONEY_OBSOLETE = ("Money(OBSOLETE)");
};

UNRECOGNIZED_TYPE = ("ItemBasicInfoDB3: Found an unrecognized type, \"%s\". Please report this type, as well as the ID of the first item upon which it was found (%s), to saeris.sanoora@gmail.com.");
UNRECOGNIZED_SUBTYPE = ("ItemBasicInfoDB3: Found an unrecognized subtype, \"%s\", of type \"%s\". Please report this type and subtype, as well as the ID of the first item upon which it was found (%s), to saeris.sanoora@gmail.com.");
UNRECOGNIZED_EQUIP_LOC = ("ItemBasicInfoDB3: Found an unrecognized equip location, \"%s\". Please report this value, as well as the ID of the first item upon which it was found (%s), to saeris.sanoora@gmail.com.");

STILL_UNRECOGNIZED_REMINDER = ("ItemBasicInfoDB3: There are unrecognized types, subtypes, or equip locations in memory. Please update to the latest version to gain support for these categories. If this message persists, please report these disparities to the author by attaching your <WoW>/WTF/Account/<account name>/SavedVariables/Lib-ItemBasicInfoDB3_SavedVariables.lua file in an email to saeris.sanoora@gmail.com.");
};
