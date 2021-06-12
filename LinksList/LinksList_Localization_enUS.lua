
local o = LinksList;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


BINDING_NAME_LINKSLIST_TOGGLE = ("Toggle Results Frame");

o.Localization = {
SLASH_COMMANDS = {
	RESULTS_TOGGLE = ("<nothing> - Toggles the results frame.");
	PANEL = ("panel - Toggles whether the results frame acts like a Blizzard UI panel (moves left and right as other such panels open and close). Disabling this requires a UI reload to take full effect.");
	TOGGLE_BUTTON = ("togglebutton - Toggles the use of the ToggleButton, a small, mobile, minimap-style button that can be clicked to toggle the results frame or dragged to move.");
	AUTOFOCUS = ("autofocus - Toggles whether the QuickSearch editbox is autofocused each time the results frame is shown.");
	UNKNOWN = ("Unknown or invalid slash command, \"%s\". Listing all slash commands...");
};

NOT_SAFE_TO_LINK_HEADER = ("Warning - Uncached");
NOT_SAFE_TO_LINK = ("This link is not cached, so attempting to display its real tooltip may disconnect you from the server. To attempt this anyway, click the link. If the tooltip never appears or fills out properly, the link simply cannot be displayed or linked at the present time.");

TITLE_BUTTON_TEXT = ("%d (%s%% of %d) %s");
RECENTLY_ADDED_TOOLTIP_HEADER = ("Recently Added Links");
RECENTLY_ADDED_TOOLTIP_TRAILER = ("If the title button's text is yellow, new links have been added to the database since you last refreshed the results list. Click the title button to rebuild the results list with the current search parameters.");
RECENTLY_ADDED_TOOLTIP_TRAILER_BRUTE_FORCE = (" Hold Alt while clicking to also attempt to brute-force search the game for new and updated links for this database.");
BRUTE_FORCE_FEEDBACK = ("LinksList: A brute-force search of the game for %s-type links revealed %d new and %d updated links.");
BRUTE_FORCE_FEEDBACK_SUBSECTION = ("LinksList: A brute-force search of the game for %s-type links in the %s subsection revealed %d new and %d updated pieces of extra link information.");

SECTION_DD_HEADER = ("Section...");
SORT_DD_HEADER = ("Sort by...");
ADVANCED_SEARCH = ("Advanced Search");

QUICK_SEARCH = ("QuickSearch");
QUICK_SEARCH_TOOLTIP = ("Type in the link name text for which you wish to search the currently selected links section.\n\nPress Enter to create a new set of search results, the contents of which are based solely on a name search of the text you typed.\n\nPress Tab to scroll through the existing results, stopping any time an entry whose name matches your search text is found.\n\nHold Control while pressing Enter or Tab to allow Lua patterns.\n\nHold Shift while pressing Enter or Tab to invert search results (scroll to or show everything which is not a match, rather than everything which is).");

SEARCH_TITLE = ("LinksList " .. GetAddOnMetadata("LinksList", "Version") .. " - Advanced Search");
SECTION_PARAMETERS_TITLE = ("Section parameters...");
SUBSECTION_PARAMETERS_TITLE = ("Subsection parameters...");
SEARCH_CLEAR = ("Clear");
SEARCH_MODIFIERS_TOOLTIP = ("Hold Control while clicking to allow Lua patterns on any text-based search parameters.\n\nHold Shift while clicking to invert search results (show everything which is not a match, rather than everything which is).");
};
