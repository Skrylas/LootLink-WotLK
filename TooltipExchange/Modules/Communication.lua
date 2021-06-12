
assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeCommunication")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")
local storage = AceLibrary("ItemStorage-1.0")
local locale = GetLocale()

local PROTOCOL_VERSION = 6

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Toggles accepting responses via whispers. This greatly reduces global transport channel load and it is recommended to be always turned on."] = true,
	["Channel"] = true,
	["Close window"] = true,
	["Closes version query results."] = true,
	["Communication"] = true,
	["Custom Channel"] = true,
	["Green versions are newer than yours, red are older, and white are the same."] = true,
	["Guild"] = true,
	["Player"] = true,
	["Runs version query over communication channel."] = true,
	["Select communication medium for item transfer."] = true,
	["Set channel name for Custom Channel transport"] = true,
	["Suspend in Combat"] = true,
	["Toggle suspending communication while being in combat."] = true,
	["Transport"] = true,
	["Version Query"] = true,
	["Version"] = true,
	["Whisper Route"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Toggles accepting responses via whispers. This greatly reduces global transport channel load and it is recommended to be always turned on."] = "Toggles accepting responses via whispers. This greatly reduces global transport channel load and it is recommended to be always turned on.",
	["Channel"] = "채널",
	["Close window"] = "창 닫기",
	["Closes version query results."] = "버전 요청 결과창을 닫습니다.",
	["Communication"] = "커뮤니케이션",
	["Custom Channel"] = "사용자 채널",
	["Green versions are newer than yours, red are older, and white are the same."] = "녹색 : 최신, 붉은색 : 이전, 흰색 : 같음(자신 기준)",
	["Guild"] = "길드",
	["Player"] = "플레이어",
	["Runs version query over communication channel."] = "버전 요청을 커뮤니케이션 채널에 알림니다.",
	["Select communication medium for item transfer."] = "아이템 이전을 위한 커뮤니케이션 매체를 선택합니다.",
	["Set channel name for Custom Channel transport"] = "사용자 채널을 알리기 위한 채널 이름을 설정합니다.",
	["Suspend in Combat"] = "전투시 중지",
	["Toggle suspending communication while being in combat."] = "전투시에는 전송하지 않습니다.",
	["Transport"] = "전송",
	["Version Query"] = "버전 요청",
	["Version"] = "버전",
	["Whisper Route"] = "귓속말 루트",
} end)

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

TooltipExchangeCommunication = TooltipExchange:NewModule(L["Communication"], "AceComm-2.0")

TooltipExchangeCommunication.defaults = {
	transport = "GUILD",
	channel = "TooltipExchange",
	combatSuspend = false,
	whispers = true,
}

TooltipExchangeCommunication.options = {
	transport = {
		type = "text",
		name = L["Transport"],
		desc = L["Select communication medium for item transfer."],
		get = function() return TooltipExchangeCommunication.db.profile.transport end,
		set = function(v)
			TooltipExchangeCommunication.db.profile.transport = v
			TooltipExchangeCommunication:SetupTransport()
		end,
		validate = { ["GUILD"] = L["Guild"], ["CUSTOM"] = L["Custom Channel"] },
		order = 100,
	},
	channel = {
		type = "text",
		name = L["Channel"],
		desc = L["Set channel name for Custom Channel transport"],
		get = function() return TooltipExchangeCommunication.db.profile.channel end,
		set = function(v)
			TooltipExchangeCommunication.db.profile.channel = v
			TooltipExchangeCommunication:SetupTransport()
		end,
		usage = "<channel name>",
		disabled = function() return TooltipExchangeCommunication.db.profile.transport ~= "CUSTOM" end,
		order = 101,
	},
	whispers = {
		type = "toggle",
		name = L["Whisper Route"],
		desc = L["Toggles accepting responses via whispers. This greatly reduces global transport channel load and it is recommended to be always turned on."],
		get = function() return TooltipExchangeCommunication.db.profile.whispers end,
		set = function(v)
			TooltipExchangeCommunication.db.profile.whispers = v
			TooltipExchangeCommunication:SetupTransport()
		end,
		disabled = function() return true end,
		order = 102,
	},
	combatSuspend = {
		type = "toggle",
		name = L["Suspend in Combat"],
		desc = L["Toggle suspending communication while being in combat."],
		get = function() return TooltipExchangeCommunication.db.profile.combatSuspend end,
		set = function(v) TooltipExchangeCommunication.db.profile.combatSuspend = v end,
		order = 103,
	},
	versionQuery = {
		type = "execute",
		name = L["Version Query"],
		desc = L["Runs version query over communication channel."],
		func = function() TooltipExchangeCommunication:QueryVersion() dewdrop:Close() end,
		disabled = function() return not TooltipExchangeCommunication:Enabled() end,
		order = -1,
	},
}

TooltipExchangeCommunication.revision = tonumber(string.sub("$Revision: 25931 $", 12, -3))

TooltipExchangeCommunication:SetCommPrefix("TooltipExchange" .. PROTOCOL_VERSION)
TooltipExchangeCommunication:RegisterAsTransportModule()

TooltipExchangeCommunication.communicates = {}

function TooltipExchangeCommunication:RegisterCommunicate(module, messageType)
	if not self.communicates[messageType] then
		self.communicates[messageType] = {}
	end

	if not self.communicates[messageType][module] then
		self.communicates[messageType][module] = 1
	end
end

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangeCommunication:OnInitialize()
	self:RegisterMessage("VQ")
	self:RegisterMessage("VR")
end

function TooltipExchangeCommunication:OnEnable()
	self.routes = {}

	self:SetupTransport()
end

function TooltipExchangeCommunication:OnDisable()
	self.routes = nil
end

function TooltipExchangeCommunication:SetupTransport()
	if not self:Enabled() then return end

	self:UnregisterAllComms()

	if self.db.profile.transport == "CUSTOM" then
		self:RegisterComm("TooltipExchange" .. PROTOCOL_VERSION, "CUSTOM", self.db.profile.channel, "OnCustomReceive")
	else
		self:RegisterComm("TooltipExchange" .. PROTOCOL_VERSION, self.db.profile.transport, "OnReceive")
	end

	if self.db.profile.whispers then
		self:RegisterComm("TooltipExchange" .. PROTOCOL_VERSION, "WHISPER", "OnReceive")
	end
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

function TooltipExchangeCommunication:OnCustomReceive(prefix, sender, distribution, channel, locale, route, messageType, ...)
	self:ProcessCommunicate(sender, distribution, locale, route, messageType, ...)
end

function TooltipExchangeCommunication:OnReceive(prefix, sender, distribution, locale, route, messageType, ...)
	self:ProcessCommunicate(sender, distribution, locale, route, messageType, ...)
end

-------------------------------------------------------------------------------
-- Generic Communication Handlers
-------------------------------------------------------------------------------

function TooltipExchangeCommunication:SendCommunicate(destination, messageType, ...)
	if self:InCombat() and self.db.profile.combatSuspend then return end

	if false and self.db.profile.whispers and destination and self.routes[destination] then
		self:SendCommMessage("WHISPER", destination, locale, self.db.profile.whispers, messageType, ...)
	elseif self.db.profile.transport == "CUSTOM" then
		self:SendCommMessage("CUSTOM", self.db.profile.channel, locale, self.db.profile.whispers, messageType, ...)
	else
		self:SendCommMessage(self.db.profile.transport, locale, self.db.profile.whispers, messageType, ...)
	end
end

function TooltipExchangeCommunication:ProcessCommunicate(sender, distribution, locale, route, messageType, ...)
	if self:InCombat() and self.db.profile.combatSuspend then return end
	if locale ~= locale then return end
	if type(messageType) ~= "string" then return end

	self.routes[sender] = route and true or nil

	if self.communicates[messageType] then
		for m in pairs(self.communicates[messageType]) do
			if m[messageType] then
				m[messageType](m, sender, ...)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Module Specific Communication
-------------------------------------------------------------------------------

function TooltipExchangeCommunication:VQ(sender, queryID)
	self:SendMessage(sender, "VR", queryID, self:GetVersion())
end

function TooltipExchangeCommunication:VR(sender, queryID, version)
	if self.queryID == queryID then
		self.versions[sender] = version
		self:UpdateVersions(true)
	end
end

-------------------------------------------------------------------------------
-- Version Query
-------------------------------------------------------------------------------

function TooltipExchangeCommunication:QueryVersion()
	self.versions = { [UnitName("player")] = self:GetVersion() }
	self.queryID = math.random(1000000, 9999999)
	self:UpdateVersions()

	self:SendMessage(nil, "VQ", self.queryID)
end

function TooltipExchangeCommunication:UpdateVersions(update)
	if not tablet:IsRegistered("TooltipExchange_VersionQuery") then
		tablet:Register("TooltipExchange_VersionQuery",
			"children", function() tablet:SetTitle(L["Version Query"])
				self:OnTooltipUpdate()
			end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
				dewdrop:AddLine(
					"text", L["Version Query"],
					"tooltipTitle", L["Version Query"],
					"tooltipText", L["Runs version query over communication channel."],
					"func", function() self:QueryVersion() end)
				dewdrop:AddLine(
					"text", L["Close window"],
					"tooltipTitle", L["Close window"],
					"tooltipText", L["Closes version query results."],
					"func", function()
						tablet:Attach("TooltipExchange_VersionQuery")
						dewdrop:Close()
					end)
			end
		)
	end

	if update and tablet:IsAttached("TooltipExchange_VersionQuery") then
		return
	elseif tablet:IsAttached("TooltipExchange_VersionQuery") then
		tablet:Detach("TooltipExchange_VersionQuery")
	else
		tablet:Refresh("TooltipExchange_VersionQuery")
	end 
end

function TooltipExchangeCommunication:OnTooltipUpdate()
	local transportCat = tablet:AddCategory(
		"columns", 1,
		"text", L["Transport"],
		"child_justify1", "LEFT"
	)

	for k, v in pairs(self.options.transport.validate) do
		if k == self.db.profile.transport then
			if k == "CUSTOM" then
				transportCat:AddLine("text", v .. " |cffffffff(|r" .. self.db.profile.channel .. "|cffffffff)|r")
			else
				transportCat:AddLine("text", v)
			end
		end
	end

	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)

	for p, v in pairs(self.versions) do
		if v < self:GetVersion() then
			cat:AddLine("text", p, "text2", "|cffff0000" .. v .. "|r")
		elseif v > self:GetVersion() then
			cat:AddLine("text", p, "text2", "|cff00ff00" .. v .. "|r")
		else
			cat:AddLine("text", p, "text2", "|cffffffff" .. v .. "|r")
		end
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same."])
end
