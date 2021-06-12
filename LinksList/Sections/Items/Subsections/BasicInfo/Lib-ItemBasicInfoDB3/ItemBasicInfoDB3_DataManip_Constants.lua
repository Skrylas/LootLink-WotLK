
local o = ItemBasicInfoDB3; if (o.SHOULD_LOAD == nil) then return; end


local loc = o.Localization.TYPES_AND_SUBTYPES;

o.TYPES_AND_SUBTYPES = {
	{ -- 1
		name = loc.ARMOR;
		subtypes = {
			loc.ARMOR_CLOTH; -- 1
			loc.ARMOR_LEATHER; -- 2
			loc.ARMOR_MAIL; -- 3
			loc.ARMOR_PLATE; -- 4
			loc.ARMOR_SHIELDS; -- 5
			loc.ARMOR_IDOLS; -- 6
			loc.ARMOR_LIBRAMS; -- 7
			loc.ARMOR_TOTEMS; -- 8
			loc.ARMOR_MISC; -- 9
			loc.ARMOR_SIGILS; -- 10
		};
	}; -- 1
	{ -- 2
		name = loc.WEAPON;
		subtypes = {
			loc.WEAPON_AXES_ONEHAND; -- 1
			loc.WEAPON_AXES_TWOHAND; -- 2
			loc.WEAPON_SWORDS_ONEHAND; -- 3
			loc.WEAPON_SWORDS_TWOHAND; -- 4
			loc.WEAPON_MACES_ONEHAND; -- 5
			loc.WEAPON_MACES_TWOHAND; -- 6
			loc.WEAPON_POLEARMS; -- 7
			loc.WEAPON_DAGGERS; -- 8
			loc.WEAPON_FIST_WEAPONS; -- 9
			loc.WEAPON_STAVES; -- 10
			loc.WEAPON_WANDS; -- 11
			loc.WEAPON_GUNS; -- 12
			loc.WEAPON_BOWS; -- 13
			loc.WEAPON_CROSSBOWS; -- 14
			loc.WEAPON_THROWN; -- 15
			loc.WEAPON_FISHING_POLES; -- 16
			loc.WEAPON_MISC; -- 17
		};
	}; -- 2
	{ -- 3
		name = loc.CONTAINER;
		subtypes = {
			loc.CONTAINER_BAG; -- 1
			loc.CONTAINER_HERB_BAG; -- 2
			loc.CONTAINER_ENCHANTING_BAG; -- 3
			loc.CONTAINER_GEM_BAG; -- 4
			loc.CONTAINER_MINING_BAG; -- 5
			loc.CONTAINER_ENGINEERING_BAG; -- 6
			loc.CONTAINER_SOUL_BAG; -- 7
			loc.CONTAINER_LEATHERWORKING_BAG; -- 8
			loc.CONTAINER_INSCRIPTION_BAG; -- 9
		};
	}; -- 3
	{ -- 4
		name = loc.CONSUMABLE;
		subtypes = {
			loc.CONSUMABLE_FOOD_AND_DRINK; -- 1
			loc.CONSUMABLE_BANDAGE; -- 2
			loc.CONSUMABLE_POTION; -- 3
			loc.CONSUMABLE_ELIXIR; -- 4
			loc.CONSUMABLE_FLASK; -- 5
			loc.CONSUMABLE_SCROLL; -- 6
			loc.CONSUMABLE_ITEM_ENHANCEMENT; -- 7
			loc.CONSUMABLE_CONSUMABLE; -- 8
			loc.CONSUMABLE_OTHER; -- 9
		};
	}; -- 4
	{ -- 5
		name = loc.TRADE_GOODS;
		subtypes = {
			loc.TRADE_GOODS_MEAT; -- 1
			loc.TRADE_GOODS_HERB; -- 2
			loc.TRADE_GOODS_LEATHER; -- 3
			loc.TRADE_GOODS_OTHER; -- 4
			loc.TRADE_GOODS_CLOTH; -- 5
			loc.TRADE_GOODS_METAL_AND_STONE; -- 6
			loc.TRADE_GOODS_PARTS; -- 7
			loc.TRADE_GOODS_EXPLOSIVES; -- 8
			loc.TRADE_GOODS_DEVICES; -- 9
			loc.TRADE_GOODS_ENCHANTING; -- 10
			loc.TRADE_GOODS_ELEMENTAL; -- 11
			loc.TRADE_GOODS_TRADE_GOODS; -- 12
			loc.TRADE_GOODS_JEWELCRAFTING; -- 13
			loc.TRADE_GOODS_MATERIALS; -- 14
			loc.TRADE_GOODS_ARMOR_ENCHANTMENT; -- 15
			loc.TRADE_GOODS_WEAPON_ENCHANTMENT; -- 16
		};
	}; -- 5
	{ -- 6
		name = loc.PROJECTILE;
		subtypes = {
			loc.PROJECTILE_ARROW; -- 1
			loc.PROJECTILE_BULLET; -- 2
		};
	}; -- 6
	{ -- 7
		name = loc.QUIVER;
		subtypes = {
			loc.QUIVER_QUIVER; -- 1
			loc.QUIVER_AMMO_POUCH; -- 2
		};
	}; -- 7
	{ -- 8
		name = loc.RECIPE;
		subtypes = {
			loc.RECIPE_ALCHEMY; -- 1
			loc.RECIPE_BLACKSMITHING; -- 2
			loc.RECIPE_COOKING; -- 3
			loc.RECIPE_ENCHANTING; -- 4
			loc.RECIPE_ENGINEERING; -- 5
			loc.RECIPE_FIRST_AID; -- 6
			loc.RECIPE_FISHING; -- 7
			loc.RECIPE_JEWELCRAFTING; -- 8
			loc.RECIPE_LEATHERWORKING; -- 9
			loc.RECIPE_TAILORING; -- 10
			loc.RECIPE_BOOK; -- 11
		};
	}; -- 8
	{ -- 9
		name = loc.GEM;
		subtypes = {
			loc.GEM_RED; -- 1
			loc.GEM_BLUE; -- 2
			loc.GEM_YELLOW; -- 3
			loc.GEM_PURPLE; -- 4
			loc.GEM_GREEN; -- 5
			loc.GEM_ORANGE; -- 6
			loc.GEM_META; -- 7
			loc.GEM_SIMPLE; -- 8
			loc.GEM_PRISMATIC; -- 9
		};
	}; -- 9
	{ -- 10
		name = loc.MISC;
		subtypes = {
			loc.MISC_JUNK; -- 1
			loc.MISC_REAGENT; -- 2
			loc.MISC_PET; -- 3
			loc.MISC_HOLIDAY; -- 4
			loc.MISC_OTHER; -- 5
			loc.MISC_MOUNT; -- 6
		};
	}; -- 10
	{ -- 11
		name = loc.QUEST;
		subtypes = {
			loc.QUEST_QUEST; -- 1
		};
	}; -- 11
	{ -- 12
		name = loc.REAGENT;
		subtypes = {
			loc.REAGENT_REAGENT; -- 1
		};
	}; -- 12
	{ -- 13
		name = loc.KEY;
		subtypes = {
			loc.KEY_KEY; -- 1
		};
	}; -- 13
	{ -- 14
		name = loc.GLYPH;
		subtypes = {
			loc.GLYPH_GLYPH; -- 1
			loc.GLYPH_DEATH_KNIGHT; -- 2
			loc.GLYPH_DRUID; -- 3
			loc.GLYPH_HUNTER; -- 4
			loc.GLYPH_MAGE; -- 5
			loc.GLYPH_PALADIN; -- 6
			loc.GLYPH_PRIEST; -- 7
			loc.GLYPH_ROGUE; -- 8
			loc.GLYPH_SHAMAN; -- 9
			loc.GLYPH_WARLOCK; -- 10
			loc.GLYPH_WARRIOR; -- 11
		};
	}; -- 14
	{ -- 15
		name = loc.MONEY;
		subtypes = {
			loc.MONEY_MONEY; -- 1
			loc.MONEY_OBSOLETE; -- 2
		};
	}; -- 15
};


o.EQUIP_LOCATIONS = {
	("INVTYPE_CHEST"); -- 1, ARMOR
	("INVTYPE_ROBE"); -- 2, ARMOR
	("INVTYPE_FEET"); -- 3, ARMOR
	("INVTYPE_HAND"); -- 4, ARMOR
	("INVTYPE_HEAD"); -- 5, ARMOR
	("INVTYPE_LEGS"); -- 6, ARMOR
	("INVTYPE_SHIELD"); -- 7, ARMOR
	("INVTYPE_SHOULDER"); -- 8, ARMOR
	("INVTYPE_WAIST"); -- 9, ARMOR
	("INVTYPE_WRIST"); -- 10, ARMOR
	("INVTYPE_WEAPON"); -- 11, WEAPON
	("INVTYPE_WEAPONMAINHAND"); -- 12, WEAPON
	("INVTYPE_WEAPONOFFHAND"); -- 13, WEAPON
	("INVTYPE_2HWEAPON"); -- 14, WEAPON
	("INVTYPE_RANGED"); -- 15, WEAPON
	("INVTYPE_RANGEDRIGHT"); -- 16, WEAPON
	("INVTYPE_THROWN"); -- 17, WEAPON
	("INVTYPE_AMMO"); -- 18, OTHER
	("INVTYPE_CLOAK"); -- 19, OTHER
	("INVTYPE_BAG"); -- 20, OTHER
	("INVTYPE_FINGER"); -- 21, OTHER
	("INVTYPE_NECK"); -- 22, OTHER
	("INVTYPE_HOLDABLE"); -- 23, OTHER
	("INVTYPE_BODY"); -- 24, OTHER
	("INVTYPE_TABARD"); -- 25, OTHER
	("INVTYPE_TRINKET"); -- 26, OTHER
	("INVTYPE_RELIC"); -- 27, OTHER
};

o.EQUIP_LOCATIONS_ARMOR = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
o.EQUIP_LOCATIONS_WEAPONS = { 11, 12, 13, 14, 15, 16, 17 };
o.EQUIP_LOCATIONS_ACCESSORIES = { 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 };
