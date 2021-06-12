
local o = LinksList_Items;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
ITEMS = ("Items");
NAME = NAME;
NAME_LABEL = (NAME .. "...");
RARITY = RARITY;
RARITY_LABEL = (RARITY .. "...");
CACHED = ("Cached");
CACHED_LABEL = ("Cached status...");

CACHED_EITHER = ("Either");
CACHED_CACHED = ("Cached only");
CACHED_UNCACHED = ("Uncached only");
};

do
	local rarityNames = {};
	for index = 0, #ITEM_QUALITY_COLORS, 1 do
		rarityNames[index] = _G["ITEM_QUALITY" .. index .. "_DESC"];
	end
	o.Localization.RARITY_NAMES = rarityNames;
end
