
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeTypeLink")
local storage = AceLibrary("ItemStorage-1.0")
local MAX_ITEMID = 35000

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Type-a-Link"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Type-a-Link"] = "대화창에 입력하여 링크",
} end)

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

TooltipExchangeTypeLink = TooltipExchange:NewModule(L["Type-a-Link"], "AceHook-2.1")

TooltipExchangeTypeLink.revision = tonumber(string.sub("$Revision: 29951 $", 12, -3))

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangeTypeLink:OnInitialize()

end

function TooltipExchangeTypeLink:OnEnable()
	self:SecureHook("ChatEdit_OnTextChanged")
	self:SecureHook("ChatEdit_OnTabPressed")
end

function TooltipExchangeTypeLink:OnDisable()

end

-------------------------------------------------------------------------------
-- Events and Hooks
-------------------------------------------------------------------------------

function TooltipExchangeTypeLink:ChatEdit_OnTextChanged()
	local text = ChatFrameEditBox:GetText()

	if string.sub(text, -1, -1) == "]" then
		local s, _, name = string.find(text, "%[([^%[%]|]-)%]$")

		if name then
			name = string.lower(name)

			for i = 1, MAX_ITEMID do
				local n, l = GetItemInfo(i)

				if n and string.lower(n) == name then
					text = string.sub(text, 1, s - 1) .. l

					if string.len(text) <= ChatFrameEditBox:GetMaxLetters() then
						ChatFrameEditBox:SetText(text)
					end

					break
				end
			end
		end
	end

	if self.tab and text ~= self.tab.current then
		self.tab = nil
	end
end

function TooltipExchangeTypeLink:ChatEdit_OnTabPressed()
	local text = ChatFrameEditBox:GetText()

	if not self.tab then
		local s, _, name = string.find(text, "%[([^%[%]|]-)$")

		if name then
			name, text = string.lower(name), string.sub(text, 1, s - 1)
			local namelen, textlen = string.len(name), string.len(text)

			for i = 1, MAX_ITEMID do
				local n, l = GetItemInfo(i)

				if n and string.sub(string.lower(n), 1, namelen) == name then
					if textlen + string.len(l) <= ChatFrameEditBox:GetMaxLetters() then
						if not self.tab then
							self.tab = {
								matches = {},
								text = text,
								index = 1,
							}
						end

						table.insert(self.tab.matches, l)
					end
				end
			end
		end
	end

	if self.tab then
		self.tab.current = self.tab.text .. self.tab.matches[self.tab.index]
		ChatFrameEditBox:SetText(self.tab.current)

		self.tab.index = self.tab.index + 1
		if self.tab.index > #(self.tab.matches) then
			self.tab.index = 1
		end
	end
end
