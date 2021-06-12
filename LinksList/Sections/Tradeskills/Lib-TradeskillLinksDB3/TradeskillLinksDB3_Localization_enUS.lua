
local o = TradeskillLinksDB3; if (o.SHOULD_LOAD == nil) then return; end

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
TRADESKILL_TYPE_PREFIXES = {
	ALCHEMY = ("Alchemy: ");
	BLACKSMITHING = ("Blacksmithing: ");
	COOKING = ("Cooking: ");
	ENCHANTING = ("Enchanting: ");
	ENGINEERING = ("Engineering: ");
	FIRST_AID = ("First Aid: ");
	INSCRIPTION = ("Inscription: ");
	JEWELCRAFTING = ("Jewelcrafting: ");
	LEATHERWORKING = ("Leatherworking: ");
	MINING = ("Mining: ");
	TAILORING = ("Tailoring: ");
};
};
