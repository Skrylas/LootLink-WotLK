assert(TooltipExchange, "TooltipExchange not found!")

-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("TooltipExchangeLoot")
local dewdrop = AceLibrary("Dewdrop-2.0")
local periodic = LibStub:GetLibrary("LibPeriodicTable-3.1")

-------------------------------------------------------------------------------
-- Localization
-------------------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Raid Loot"] = true,
	["Raid instance bosses drop lists."] = true,
	["All instance loot"] = true,
	["Displays all item that drop in given instance."] = true,
	["Browser"] = true,
} end)

-------------------------------------------------------------------------------
-- Declaration
-------------------------------------------------------------------------------

local instanceLoot = {
	{ header = L["Raid Loot"] },
	{ text = "Ulduar (Heroic)", zone = "Ulduar", heroic = true },
	{ text = "Naxxramas (Heroic)", zone = "Naxxramas", heroic = true },
	{ text = "The Eye of Eternity (Heroic)", zone = "The Eye of Eternity", heroic = true },
	{ text = "Obsidian Sanctum (Heroic)", zone = "Obsidian Sanctum", heroic = true },
	{ text = "Vault of Archavon (Heroic)", zone = "Vault of Archavon", heroic = true },
	{ header = " " },
	{ zone = "Ulduar" },
	{ zone = "Naxxramas" },
	{ zone = "The Eye of Eternity" },
	{ zone = "Obsidian Sanctum" },
	{ zone = "Vault of Archavon" },
--[[ -- Do we really need Classic and TBC raid loot shown here?
	{ header = " " },
	{ text = "Outland", zone = "World Bosses", bosses = { "Doom Lord Kazzak", "Doomwalker" } },
	{ zone = "Sunwell Plateau" },
	{ zone = "Black Temple" },
	{ zone = "Hyjal Summit" },
	{ text = "Tempest Keep", zone = "The Eye" },
	{ zone = "Serpentshrine Cavern" },
	{ zone = "Magtheridon's Lair" },
	{ zone = "Gruul's Lair" },
	{ zone = "Zul'Aman" },
	{ zone = "Karazhan" },
	{ header = " " },
	{ text = "Azeroth", zone = "World Bosses", bosses = { "Azuregos", "Lord Kazzak", "Emeriss", "Lethon", "Taerar", "Ysondre" } },
	{ zone = "Ahn'Qiraj" },
	{ zone = "Blackwing Lair" },
	{ zone = "Molten Core" },
	{ zone = "Onyxia's Lair" },
	{ zone = "Ruins of Ahn'Qiraj" },
	{ zone = "Zul'Gurub" },
]]
}

TooltipExchangeLoot = TooltipExchange:NewModule(L["Raid Loot"])
TooltipExchangeLoot.notToggable = true

TooltipExchangeLoot.commands = {
	raidLoot = {
		type = "group",
		name = L["Raid Loot"],
		desc = L["Raid instance bosses drop lists."],
		order = 15,
		args = {},
	},
	browser = {
		type = "group",
		name = L["Browser"],
		desc = " ",
		order = 16,
		args = {
			header = {
				type = "header",
				order = 1,
				name = L["Browser"],
			},
		},
	},
}

TooltipExchangeLoot.revision = tonumber(string.sub("$Revision: 78200 $", 12, -3))

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

function TooltipExchangeLoot:OnInitialize()
	self:CreateStaticMenu()
end

function TooltipExchangeLoot:OnEnable()

end

function TooltipExchangeLoot:OnDisable()

end

-------------------------------------------------------------------------------
-- Dynamic Menu
-------------------------------------------------------------------------------

function TooltipExchangeLoot:CreateStaticMenu()
	local a, o = self.commands.raidLoot.args, 100

	for _, v in ipairs(instanceLoot) do
		if v.header then
			a["header" .. o] = {
				type = "header",
				order = o,
				name = v.header,
			}
		elseif v.zone then
			local zz = string.gsub(v.text or v.zone, "[^%a]", "")
			local z, c = v.zone, 0

			a[zz] = {
				type = "group",
				name = v.text or v.zone,
				desc = v.text or v.zone,
				order = o,
				args = {
					header = {
						type = "header",
						order = 1,
						name = v.text or v.zone,
					},
				},
			}

			if v.bosses then
				for _, b in ipairs(v.bosses) do
					a[zz].args[string.gsub(b, "[^%a]", "")] = {
						type = "execute",
						name = b,
						desc = b,
						func = function()
							self:TriggerEvent("TooltipExchange_PeriodicResults", "InstanceLoot." .. z .. "." .. b)
							dewdrop:Close()
						end,
					}
					c = c + 1
				end
			else
				local s = "InstanceLoot" .. (v.heroic and "Heroic." or ".") .. z

				local t = periodic:GetSetTable(s)

				if t then
					for _, set in ipairs(t) do
						if set.set then
							local b = string.sub(set.set, string.len(s) + 2)

							a[zz].args[string.gsub(b, "[^%a]", "")] = {
								type = "execute",
								name = b,
								desc = b,
								func = function()
									self:TriggerEvent("TooltipExchange_PeriodicResults", s .. "." .. b)
									dewdrop:Close()
								end,
							}
							c = c + 1
						end
					end

					if c > 1 then
						local f = function()
							self:TriggerEvent("TooltipExchange_PeriodicResults", s)
							dewdrop:Close()
						end

						a[zz].onClick = f
						a[zz].args.allInstanceLoot = {
							type = "execute",
							name = L["All instance loot"],
							desc = L["Displays all item that drop in given instance."],
							func = f,
							order = -1,
						}
					end
				end
			end

			if c == 0 then
				a[zz] = nil
			end
		end

		o = o + 1
	end

	local periodicSets =
	{
		{ set = "TradeskillResultMats.Forward", offset = 3, name = "Trade Skills" },
		{ set = "InstanceLoot", offset = 2, name = "Instance Loot" },
		{ set = "InstanceLootHeroic", offset = 2, name = "Heroic Instance Loot" },
		{ set = "GearSet", offset = 2, name = "Item Sets" },
		{ set = "Reputation.Reward", offset = 3, name = "Reputation" },
	}

	for _, tt in pairs(periodicSets) do
		self.commands.browser.args[string.gsub(tt.name, "[^%w]", "")] = {
			type = "group",
			name = tt.name,
			desc = " ",
			args = {
				header = {
					type = "header",
					order = 1,
					name = tt.name,
				},
			},
		}

		local aa = self.commands.browser.args[string.gsub(tt.name, "[^%w]", "")].args

		for _, t in pairs(periodic:GetSetTable(tt.set)) do
			if t.set then
				local p = {}

				for w in string.gmatch(t.set, "[^%.]+") do
					table.insert(p, w)
				end

				local a = aa

				for i = tt.offset, #(p) - 1 do
					if not a[string.gsub(p[i], "[^%w]", "")] then
						a[string.gsub(p[i], "[^%w]", "")] = {
							type = "group",
							name = p[i],
							desc = " ",
							args = {
								header = {
									type = "header",
									order = 1,
									name = p[i],
								},
							},
						}
					end

					a = a[string.gsub(p[i], "[^%w]", "")].args
				end

				local s = t.set

				a[string.gsub(p[#(p)], "[^%w]", "")] = {
					type = "execute",
					name = p[#(p)],
					desc = " ",
					func = function()
						self:TriggerEvent("TooltipExchange_PeriodicResults", s)
						dewdrop:Close()
					end,
				}
			end
		end
	end
end
