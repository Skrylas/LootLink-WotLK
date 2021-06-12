
local o = LinksList;

-- QuickSearch_PreSectionChanged: ()
-- QuickSearch_PostSectionChanged: ()
-- QuickSearch_OnAutoFocusQSChanged: (enabled)
--
-- QuickSearch_ScrollToNextMatch: (text)
-- QuickSearch_FindNextMatchIndex: nextMatchIndex = (currentIndex, text)
--
-- QuickSearch_EditBox_OnShow: (self)
-- QuickSearch_EditBox_OnUpdate: (self)
-- QuickSearch_EditBox_OnEditFocusLost: (self)
-- QuickSearch_EditBox_OnTabPressed: (self)
-- QuickSearch_EditBox_OnEnterPressed: (self)
-- QuickSearch_EditBox_OnTextChanged: (self)

-- Sections_currSectionInfo;
-- QuickSearch_currentIndex = 0;
o.QuickSearch_dbLookupParent = {};




function o.QuickSearch_PreSectionChanged()
	local oldSectionInfo = o.Sections_currSectionInfo;
	if (oldSectionInfo ~= nil) then
		oldSectionInfo.qsIndex = o.QuickSearch_currentIndex;
		oldSectionInfo.qsText = LinksList_ResultsFrame_QuickSearchFrame_EditBox:GetText();
	end
end


function o.QuickSearch_PostSectionChanged()
	local newSectionInfo = o.Sections_currSectionInfo;
	if (newSectionInfo ~= nil) then
		o.QuickSearch_currentIndex = newSectionInfo.qsIndex;
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:EnableMouse(true);
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:SetText(newSectionInfo.qsText);
	else
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:EnableMouse(false);
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:SetText("");
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:ClearFocus();
	end
	o.QuickSearch_dbLookupParent[1] = nil;
end



function o.QuickSearch_OnAutoFocusQSChanged(enabled)
	if (enabled == true) then
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:SetScript("OnShow", o.QuickSearch_EditBox_OnShow);
	else
		LinksList_ResultsFrame_QuickSearchFrame_EditBox:SetScript("OnShow", nil);
	end
end




function o.QuickSearch_ScrollToNextMatch(text)
	local nextIndex = o.QuickSearch_FindNextMatchIndex(o.QuickSearch_currentIndex, text);
	if (nextIndex ~= nil) then
		o.QuickSearch_currentIndex = nextIndex;
		LinksList_ResultsFrame_QuickSearchFrame:SetBackdropBorderColor(0.5, 0.5, 0.5);
		
		-- 22 is the number of displayed link buttons.
		local offset = (nextIndex - 1);
		local numResults = #o.Sections_currSectionInfo.resultsArray;
		if ((offset + 22) > numResults) then
			offset = (numResults - 22);
		end
		if (offset < 0) then offset = 0; end
		-- 32 is the height of the buttons.
		LinksList_ResultsFrame_ScrollFrameScrollBar:SetValue(math.ceil(offset * 32));
		o.Results_LinkButton_OnEnter(o.Results_LINK_BUTTONS[nextIndex - offset]);
	else
		LinksList_ResultsFrame_QuickSearchFrame:SetBackdropBorderColor(0.8, 0.0, 0.0);
	end
end



setmetatable(o.QuickSearch_dbLookupParent, {
	__index = (function(self, key)
		local dbLookup = {};
		self[1] = dbLookup;
		for ID, data in o.Sections_currSectionInfo.funcs.IterateDB(false, false) do
			dbLookup[ID] = data;
		end
		return dbLookup;
	end);
	__mode = ("kv");
});



function o.QuickSearch_FindNextMatchIndex(currentIndex, text)
	local info = o.Sections_currSectionInfo;
	local funcs = info.funcs;
	
	local type = type;
	local resultsArray = info.resultsArray;
	local allowRegExps = (IsControlKeyDown() ~= nil);
	local expectedValue = (IsShiftKeyDown() == nil);
	local linkMatcher, linkMatchFunc, linkMismatchVal, linkGetDataFunc = funcs.BuildQuickSearchLinkNameMatcher(text, allowRegExps);
	local linkID;
	
	if (currentIndex > #resultsArray) then
		currentIndex = 1;
	end
	
	local cache = nil;
	if (info.noCachingForSearch == nil) then
		cache = o.QuickSearch_dbLookupParent[1];
	end
	
	for index = (currentIndex + 1), #resultsArray, 1 do
		linkID = resultsArray[index];
		if ((linkMatchFunc(((cache ~= nil and cache[linkID]) or linkGetDataFunc(linkID)), linkMatcher) ~= linkMismatchVal) == expectedValue) then
			return index;
		end
	end
	
	for index = 1, currentIndex, 1 do
		linkID = resultsArray[index];
		if ((linkMatchFunc(((cache ~= nil and cache[linkID]) or linkGetDataFunc(linkID)), linkMatcher) ~= linkMismatchVal) == expectedValue) then
			return index;
		end
	end
	
	return nil;
end




function o.QuickSearch_EditBox_OnShow(self)
	if (o.Sections_currSectionInfo ~= nil) then
		self:SetScript("OnUpdate", o.QuickSearch_EditBox_OnUpdate);
	end
end


-- If an editbox is autofocus and it is shown by a keybinding, it will gain the text of that keybinding. This is a workaround.
-- This code waits one frame before setting the focus to the editbox, thus avoiding the keybinding.
function o.QuickSearch_EditBox_OnUpdate(self)
	self:SetFocus();
	self:SetScript("OnUpdate", nil);
end



function o.QuickSearch_EditBox_OnEditFocusLost(self)
	self:HighlightText(0, 0);
end



function o.QuickSearch_EditBox_OnTabPressed(self)
	o.QuickSearch_ScrollToNextMatch(self:GetText());
end


function o.QuickSearch_EditBox_OnEnterPressed(self)
	o.Search_SearchByNameOnly(self:GetText());
end



function o.QuickSearch_EditBox_OnTextChanged(self)
	if (self:GetText() == "") then
		LinksList_ResultsFrame_QuickSearchFrameHelpText:SetTextColor(0.7, 0.7, 0.7);
	else
		LinksList_ResultsFrame_QuickSearchFrameHelpText:SetTextColor(0.3, 0.3, 0.3);
	end
end
