
local o = LinksList_Abilities;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
ABILITIES = ("Abilities");
NAME = NAME;
NAME_LABEL = (NAME .. "...");
};
