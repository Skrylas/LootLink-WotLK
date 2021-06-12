
local o = LinksList_Items_BasicInfo;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
BASIC_INFO = ("Basic Info");

SORT_BY_TYPE_AND_SUBTYPE = ("Type & Subtype");
SORT_BY_EQUIP_LOC = ("Equip Location");
SORT_BY_ITEM_LEVEL = ("Item Level");
SORT_BY_EQUIP_LEVEL = ("Equip Level");

CHECK_ENTRIES_TOOLTIP = ("Check an entry to allow items which match its criteria to be included in potential search results.\n\nSelected entries follow...|cffffffff");
GENERIC_ANY = ("Any");
GENERIC_NONE = ("None");
GENERIC_SOME = ("Some");
TYPE_AND_SUBTYPE_ANY = ("Any Type - Any Subtype");
TYPE_AND_SUBTYPE_NONE = ("No Type - No Subtype");
TYPE_AND_SUBTYPE_LABEL = ("Type and Subtype...");
TYPE_AND_SUBTYPE_ANY_SUBTYPE = ("Any Subtype");
TYPE_AND_SUBTYPE_NO_SUBTYPE = ("No Subtype");
TYPE_AND_SUBTYPE_TOOLTIP_TITLE = ("Type and Subtype");
EQUIP_LOC_ANY = ("Any Equip Location");
EQUIP_LOC_NONE = ("No Equip Location");
EQUIP_LOC_LABEL = ("Equip Location...");
EQUIP_LOC_TOOLTIP_TITLE = ("Equip Location");
EQUIP_LOC_CATEGORY_ARMOR = ("Armor");
EQUIP_LOC_CATEGORY_WEAPONS = ("Weapons");
EQUIP_LOC_CATEGORY_ACCESSORIES = ("Accessories");
ITEM_LEVEL_LABEL = ("Item Level...");
EQUIP_LEVEL_LABEL = ("Equip Level...");
};
