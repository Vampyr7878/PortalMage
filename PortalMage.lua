local PortalMage = LibStub("AceAddon-3.0"):NewAddon("PortalMage")
local L = LibStub("AceLocale-3.0"):GetLocale("PortalMage")
local group = {}
local Masque
local start = 180
local teleportRunes
local portalRunes

portalMageIndicesA = {"stormwind",
					  "ironforge",
					  "darnassus",
					  "exodar",
					  "theramore",
					  "shattrath"}

portalMageIndicesH = {"orgrimmar",
					  "undercity",
					  "thunderbluff",
					  "silvermoon",
					  "stonard",
					  "shattrath"}

portalMageSpells = {["stormwind"] = true,
					["orgrimmar"] = true,
					["ironforge"] = true,
					["undercity"] = true,
					["darnassus"] = true,
					["thunderbluff"] = true,
					["exodar"] = true,
					["silvermoon"] = true,
					["theramore"] = true,
					["stonard"] = true,
					["shattrath"] = true}

PortalMage.portals = {["stormwind"] = 10059,
					  ["orgrimmar"] = 11417,
					  ["ironforge"] = 11416,
					  ["undercity"] = 11418,
					  ["darnassus"] = 11419,
					  ["thunderbluff"] = 11420,
					  ["exodar"] = 32266,
					  ["silvermoon"] = 32267,
					  ["theramore"] = 49360,
					  ["stonard"] = 49361,
					  ["shattrathA"] = 33691,
					  ["shattrathH"] = 35717}

PortalMage.teleports = {["stormwind"] = 3561,
						["orgrimmar"] = 3567,
						["ironforge"] = 3562,
						["undercity"] = 3563,
						["darnassus"] = 3565,
						["thunderbluff"] = 3566,
						["exodar"] = 32271,
						["silvermoon"] = 32272,
						["theramore"] = 49359,
						["stonard"] = 49358,
						["shattrathA"] = 33690,
						["shattrathH"] = 35715}

PortalMage.icons = {["stormwind"] = "Interface/ICONS/Spell_Arcane_TeleportStormwind",
					["orgrimmar"] = "Interface/ICONS/Spell_Arcane_TeleportOrgrimmar",
					["ironforge"] = "Interface/ICONS/Spell_Arcane_TeleportIronforge",
					["undercity"] = "Interface/ICONS/Spell_Arcane_TeleportUndercity",
					["darnassus"] = "Interface/ICONS/Spell_Arcane_TeleportDarnassus",
					["thunderbluff"] = "Interface/ICONS/Spell_Arcane_TeleportThunderBluff",
					["exodar"] = "Interface/ICONS/Spell_Arcane_TeleportExodar",
					["silvermoon"] = "Interface/ICONS/Spell_Arcane_TeleportSilvermoon",
					["theramore"] = "Interface/ICONS/Spell_Arcane_TeleportTheramore",
					["stonard"] = "Interface/ICONS/Spell_Arcane_TeleportStonard",
					["shattrath"] = "Interface/ICONS/Spell_Arcane_TeleportShattrath"}

function PortalMage:OnInitialize()
	_, self.class = UnitClass("player")
	self.faction = UnitFactionGroup("player")
	if self.class == "MAGE" then
		self.frame = CreateFrame("FRAME", nil, UIParent)
		self.move = CreateFrame("FRAME", nil, self.frame, BackdropTemplateMixin and "BackdropTemplate")
		Masque = LibStub("Masque", true)
		if Masque ~= nil then
			group = Masque:Group("Portal Mage", "Buttons")
		end
		if not portalMageData then
			portalMageData = {}
		end
		if not portalMageData.X then
			portalMageData.X = start + 0
		end
		if not portalMageData.Y then
			portalMageData.Y = start + 0
		end
		if portalMageData.Vertical == nil then
			portalMageData.Vertical = false
		end
		if portalMageData.Scale == nil then
			portalMageData.Scale = 1
		end
		if portalMageData.Runes == nil then
			portalMageData.Runes = {}
		end
		if portalMageData.Runes.Portal == nil then
			portalMageData.Runes.Portal = {}
			portalMageData.Runes.Portal.show = true
			portalMageData.Runes.Portal.position = "TOPLEFT"
		end
		if portalMageData.Runes.Teleport == nil then
			portalMageData.Runes.Teleport = {}
			portalMageData.Runes.Teleport.show = true
			portalMageData.Runes.Teleport.position = "TOPRIGHT"
		end
		if portalMageData.Invert == nil then
			portalMageData.Invert = false
		end
		if portalMageData.Opacity == nil then
			portalMageData.Opacity = 1
		end
		if portalMageData.Mouseover == nil then
			portalMageData.Mouseover = false
		end
		if portalMageData.AnnouncePortal == nil then
			portalMageData.AnnouncePortal = false
		end
		if portalMageData.PortalAnnouncement == nil then
			portalMageData.PortalAnnouncement = "Casting %s!"
		end
		if portalMageData.AnnounceTeleport == nil then
			portalMageData.AnnounceTeleport = false
		end
		if portalMageData.TeleportAnnouncement == nil then
			portalMageData.TeleportAnnouncement = "Casting %s!"
		end
		teleportRunes = PortalMage:CountItems(17031)
		portalRunes = PortalMage:CountItems(17032)
		self:SetupFrame(self.frame)
		self:SetupMoveFrame(self.move)
		if self.faction == "Alliance" then
			local options = {
				name = L["Portal Mage"],
				handler = PortalMage,
				type = "group",
				args = {
					movable = {
						name = L["Set Movable"],
						type = "toggle",
						desc = L["makes bar movable"],
						set = "SetMove",
						get = "GetMove"
					},
					layout = {
						name = L["Layout"],
						type = "group",
						args = {
							vertical = {
								name = L["Layout"],
								type = "select",
								desc = L["select layout type"],
								values = {[true] = "Vertical", [false] = "Horizontal"},
								set = "SetLayout",
								get = "GetLayout",
								style = "radio"
							},
							scale = {
								name = L["Scale"],
								order = 1,
								type = "range",
								desc = L["you scale whole bar up or down"],
								width = "full",
								min = 0.5,
								max = 2,
								set = "SetScale",
								get = "GetScale"
							},
							portalRune = {
								name = "Rune of Portals",
								type = "group",
								args ={
									enable = {
										name = "Enable",
										type = "toggle",
										desc = "enable Rune of Portals display near the bar",
										set = "SetPortalRuneEnable",
										get = "GetPortalRuneEnable"
									},
									position = {
										name = "Position",
										type = "select",
										values = {["TOPLEFT"] = L["Top Left"], ["BOTTOMLEFT"] = L["Bottom Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMRIGHT"] = L["Bottom Right"]},
										style = "dropdown",
										set = "SetPortalRunePosition",
										get = "GetPortalRunePosition"
									}
								}
							},
							teleportRune = {
								name = "Rune of Teleportaion",
								type = "group",
								args ={
									enable = {
										name = "Enable",
										type = "toggle",
										desc = "enable Rune of Teleportaion display near the bar",
										set = "SetTeleportRuneEnable",
										get = "GetTeleportRuneEnable"
									},
									position = {
										name = "Position",
										type = "select",
										values = {["TOPLEFT"] = L["Top Left"], ["BOTTOMLEFT"] = L["Bottom Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMRIGHT"] = L["Bottom Right"]},
										style = "dropdown",
										set = "SetTeleportRunePosition",
										get = "GetTeleportRunePosition"
									}
								}
							},
							invert = {
								name = L["Invert mouse buttons"],
								type = "toggle",
								desc = L["when enabled left mouse button will cast teleport spell while right mouse button will cast portal spell"],
								set = "SetInvert",
								get = "GetInvert"
							},
							opacity = {
								name = L["Opacity"],
								order = 1,
								type = "range",
								desc = L["change bar opacity"],
								width = "full",
								min = 0.1,
								max = 1,
								set = "SetOpacity",
								get = "GetOpacity"
							},
							mouseover = {
								name = L["Show only on mouse over"],
								type = "toggle",
								width = "full",
								desc = L["when enabled bar will only be visible when you mouse over it"],
								set = "SetMouseover",
								get = "GetMouseover"
							}
						}
					},
					announcement = {
						name = L["Announcement"],
						type = "group",
						args = {
							announcePortal = {
								name = L["Announce portal"],
								type = "toggle",
								desc = L["when enabled you will announce portal on Say channel"],
								set = "SetAnnouncePortal",
								get = "GetAnnouncePortal"
							},
							portalAnnouncement ={
								name = L["Portal announcement"],
								type = "input",
								width = "full",
								desc = L["put your announcement for portal here, use %s as placeholder for spell name"],
								set = "SetPortalAnnouncement",
								get = "GetPortalAnnouncement"
							},
							announceTeleport = {
								name = L["Announce teleport"],
								type = "toggle",
								desc = L["when enabled you will announce teleport on Say channel"],
								set = "SetAnnounceTeleport",
								get = "GetAnnounceTeleport"
							},
							teleportAnnouncement ={
								name = L["Teleport announcement"],
								type = "input",
								width = "full",
								desc = L["put your announcement for tortal here, use %s as placeholder for spell name"],
								set = "SetTeleportAnnouncement",
								get = "GetTeleportAnnouncement"
							}
						}
					},
					portals = {
						name = L["Portals"],
						type = "group",
						args = {
							stormwind = {
								name = L["Stormwind"],
								type = "toggle",
								desc = L["toggles portal and teleport to Stormwind"],
								set = "Set",
								get = "Get"
							},
							ironforge = {
								name = L["Ironforge"],
								type = "toggle",
								desc = L["toggles portal and teleport to Ironforge"],
								set = "Set",
								get = "Get"
							},
							darnassus = {
								name = L["Darnassus"],
								type = "toggle",
								desc = L["toggles portal and teleport to Darnassus"],
								set = "Set",
								get = "Get"
							},
							exodar = {
								name = L["Exodar"],
								type = "toggle",
								desc = L["toggles portal and teleport to Exodar"],
								set = "Set",
								get = "Get"
							},
							theramore = {
								name = L["Theramore"],
								type = "toggle",
								desc = L["toggles portal and teleport to Theramore"],
								set = "Set",
								get = "Get"
							},
							shattrath = {
								name = L["Shattrath"],
								type = "toggle",
								desc = L["toggles portal and teleport to Shattrath"],
								set = "Set",
								get = "Get"
							}
						}
					}
				}
			}
			LibStub("AceConfig-3.0"):RegisterOptionsTable("PortalMage", options, nil)
			LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PortalMage", "Portal Mage")
		else
			local options = {
				name = L["Portal Mage"],
				handler = PortalMage,
				type = "group",
				args = {
					movable = {
						name = L["Set Movable"],
						type = "toggle",
						desc = L["makes bar movable"],
						set = "SetMove",
						get = "GetMove"
					},
					layout = {
						name = L["Layout"],
						type = "group",
						args = {
							vertical = {
								name = L["Layout"],
								type = "select",
								desc = L["select layout type"],
								values = {[true] = "Vertical", [false] = "Horizontal"},
								set = "SetLayout",
								get = "GetLayout",
								style = "radio"
							},
							scale = {
								name = L["Scale"],
								order = 1,
								type = "range",
								desc = L["you scale whole bar up or down"],
								width = "full",
								min = 0.5,
								max = 2,
								set = "SetScale",
								get = "GetScale"
							},
							portalRune = {
								name = "Rune of Portals",
								type = "group",
								args ={
									enable = {
										name = "Enable",
										type = "toggle",
										desc = "enable Rune of Portals display near the bar",
										set = "SetPortalRuneEnable",
										get = "GetPortalRuneEnable"
									},
									position = {
										name = "Position",
										type = "select",
										values = {["TOPLEFT"] = L["Top Left"], ["BOTTOMLEFT"] = L["Bottom Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMRIGHT"] = L["Bottom Right"]},
										style = "dropdown",
										set = "SetPortalRunePosition",
										get = "GetPortalRunePosition"
									}
								}
							},
							teleportRune = {
								name = "Rune of Teleportaion",
								type = "group",
								args ={
									enable = {
										name = "Enable",
										type = "toggle",
										desc = "enable Rune of Teleportaion display near the bar",
										set = "SetTeleportRuneEnable",
										get = "GetTeleportRuneEnable"
									},
									position = {
										name = "Position",
										type = "select",
										values = {["TOPLEFT"] = L["Top Left"], ["BOTTOMLEFT"] = L["Bottom Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMRIGHT"] = L["Bottom Right"]},
										style = "dropdown",
										set = "SetTeleportRunePosition",
										get = "GetTeleportRunePosition"
									}
								}
							},
							invert = {
								name = L["Invert mouse buttons"],
								type = "toggle",
								desc = L["when enabled left mouse button will cast teleport spell while right mouse button will cast portal spell"],
								set = "SetInvert",
								get = "GetInvert"
							},
							opacity = {
								name = L["Opacity"],
								order = 1,
								type = "range",
								desc = L["change bar opacity"],
								width = "full",
								min = 0.1,
								max = 1,
								set = "SetOpacity",
								get = "GetOpacity"
							},
							mouseover = {
								name = L["Show only on mouse over"],
								type = "toggle",
								width = "full",
								desc = L["when enabled bar will only be visible when you mouse over it"],
								set = "SetMouseover",
								get = "GetMouseover"
							}
						}
					},
					announcement = {
						name = L["Announcement"],
						type = "group",
						args = {
							announcePortal = {
								name = L["Announce portal"],
								type = "toggle",
								desc = L["when enabled you will announce portal on Say channel"],
								set = "SetAnnouncePortal",
								get = "GetAnnouncePortal"
							},
							portalAnnouncement ={
								name = L["Portal announcement"],
								type = "input",
								width = "full",
								desc = L["put your announcement for portal here, use %s as placeholder for spell name"],
								set = "SetPortalAnnouncement",
								get = "GetPortalAnnouncement"
							},
							announceTeleport = {
								name = L["Announce teleport"],
								type = "toggle",
								desc = L["when enabled you will announce teleport on Say channel"],
								set = "SetAnnounceTeleport",
								get = "GetAnnounceTeleport"
							},
							teleportAnnouncement ={
								name = L["Teleport announcement"],
								type = "input",
								width = "full",
								desc = L["put your announcement for tortal here, use %s as placeholder for spell name"],
								set = "SetTeleportAnnouncement",
								get = "GetTeleportAnnouncement"
							}
						}
					},
					portals = {
						name = L["Portals"],
						type = "group",
						args = {
							orgrimmar = {
								name = L["Orgrimmar"],
								type = "toggle",
								desc = L["toggles portal and teleport to Orgrimmar"],
								set = "Set",
								get = "Get"
							},
							undercity = {
								name = L["Undercity"],
								type = "toggle",
								desc = L["toggles portal and teleport to Undercity"],
								set = "Set",
								get = "Get"
							},
							thunderbluff = {
								name = L["Thunder Bluff"],
								type = "toggle",
								desc = L["toggles portal and teleport to Thunder Bluff"],
								set = "Set",
								get = "Get"
							},
							silvermoon = {
								name = L["Silvermoon"],
								type = "toggle",
								desc = L["toggles portal and teleport to Silvermoon"],
								set = "Set",
								get = "Get"
							},
							stonard = {
								name = L["Stonard"],
								type = "toggle",
								desc = L["toggles portal and teleport to Stonard"],
								set = "Set",
								get = "Get"
							},
							shattrath = {
								name = L["Shattrath"],
								type = "toggle",
								desc = L["toggles portal and teleport to Shattrath"],
								set = "Set",
								get = "Get"
							}
						}
					}
				}
			}
			LibStub("AceConfig-3.0"):RegisterOptionsTable("PortalMage", options, nil)
			LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PortalMage", "Portal Mage")
		end
	end
end

function PortalMage:SetMove(info, val)
	if val then
		self.move:Show()
		self.frame:SetAlpha(1)
	else
		self.move:Hide()
	if portalMageData.Mouseover then
		self.frame:SetAlpha(0)
	else
		self.frame:SetAlpha(portalMageData.Opacity)
	end
	end
end

function PortalMage:GetMove(info)
	return self.move:IsShown()
end

function PortalMage:SetLayout(info, val)
	portalMageData.Vertical = val
	if portalMageData.Vertical then
		self:SetupButtonsVertical(self.frame, self.move)
	else
		self:SetupButtonsHorizontal(self.frame, self.move)
	end
end

function PortalMage:GetLayout(info)
	return portalMageData.Vertical
end

function PortalMage:SetScale(info, val)
	portalMageData.Scale = val;
	self.frame:SetScale(0.8 * portalMageData.Scale)
end

function PortalMage:GetScale(info)
	return portalMageData.Scale
end

function PortalMage:SetPortalRuneEnable(info, val)
	portalMageData.Runes.Portal.show = val
	if portalMageData.Runes.Portal.show then
		self.frame.portals:Show()
	else
		self.frame.portals:Hide()
	end
end

function PortalMage:GetPortalRuneEnable(info)
	return portalMageData.Runes.Portal.show
end

function PortalMage:SetPortalRunePosition(info, val)
	portalMageData.Runes.Portal.position = val
	if portalMageData.Vertical then
		self:SetupButtonsVertical(self.frame, self.move)
	else
		self:SetupButtonsHorizontal(self.frame, self.move)
	end
end

function PortalMage:GetPortalRunePosition(info)
	return portalMageData.Runes.Portal.position
end

function PortalMage:SetTeleportRuneEnable(info, val)
	portalMageData.Runes.Teleport.show = val
	if portalMageData.Runes.Teleport.show then
		self.frame.teleports:Show()
	else
		self.frame.teleports:Hide()
	end
end

function PortalMage:GetTeleportRuneEnable(info)
	return portalMageData.Runes.Teleport.show
end

function PortalMage:SetTeleportRunePosition(info, val)
	portalMageData.Runes.Teleport.position = val
	if portalMageData.Vertical then
		self:SetupButtonsVertical(self.frame, self.move)
	else
		self:SetupButtonsHorizontal(self.frame, self.move)
	end
end

function PortalMage:GetTeleportRunePosition(info)
	return portalMageData.Runes.Teleport.position
end

function PortalMage:SetInvert(info, val)
	portalMageData.Invert = val
	if portalMageData.Vertical then
		self:SetupButtonsVertical(self.frame, self.move)
	else
		self:SetupButtonsHorizontal(self.frame, self.move)
	end
end

function PortalMage:GetInvert(info)
	return portalMageData.Invert
end

function PortalMage:SetOpacity(info, val)
	portalMageData.Opacity = val
	if portalMageData.Mouseover then
		self.frame:SetAlpha(0)
	else
		self.frame:SetAlpha(val)
	end
end

function PortalMage:GetOpacity(info)
	return portalMageData.Opacity
end

function PortalMage:SetMouseover(info, val)
	portalMageData.Mouseover = val
	if portalMageData.Mouseover then
		self.frame:SetAlpha(0)
	else
		self.frame:SetAlpha(portalMageData.Opacity)
	end
end

function PortalMage:GetMouseover(info)
	return portalMageData.Mouseover
end

function PortalMage:SetAnnouncePortal(info, val)
	portalMageData.AnnouncePortal = val
end

function PortalMage:GetAnnouncePortal(info)
	return portalMageData.AnnouncePortal
end

function PortalMage:SetPortalAnnouncement(info, val)
	portalMageData.PortalAnnouncement = val
end

function PortalMage:GetPortalAnnouncement(info)
	return portalMageData.PortalAnnouncement
end

function PortalMage:SetAnnounceTeleport(info, val)
	portalMageData.AnnounceTeleport = val
end

function PortalMage:GetAnnounceTeleport(info)
	return portalMageData.AnnounceTeleport
end

function PortalMage:SetTeleportAnnouncement(info, val)
	portalMageData.TeleportAnnouncement = val
end

function PortalMage:GetTeleportAnnouncement(info)
	return portalMageData.TeleportAnnouncement
end

function PortalMage:Set(info, val)
	portalMageSpells[info[#info]] = val
	if portalMageData.Vertical then
		self:SetupButtonsVertical(self.frame, self.move)
	else
		self:SetupButtonsHorizontal(self.frame, self.move)
	end
	if Masque ~= nil then
		self:RemoveMasqueButtons()
		self:AddMasqueButtons()
		group:ReSkin()
	end
end

function PortalMage:Get(info)
	return portalMageSpells[info[#info]]
end

function PortalMage:AddMasqueButtons()
	if self.faction == "Alliance" then
		for i = 1, table.getn(portalMageIndicesA), 1 do
			if portalMageSpells[portalMageIndicesA[i]] then
				group:AddButton(self.buttons[i])
			end
		end
	else
		for i = 1, table.getn(portalMageIndicesH), 1 do
			if portalMageSpells[portalMageIndicesH[i]] then
				group:AddButton(self.buttons[i])
			end
		end
	end
end

function PortalMage:RemoveMasqueButtons()
	for i = 1, table.getn(portalMageIndicesA), 1 do
		group:RemoveButton(self.buttons[i])
	end
end

function PortalMage.frameOnEvent(self, event, arg1, _, arg3)
	if event == "PLAYER_LOGIN" then
		teleportRunes = PortalMage:CountItems(17031)
		portalRunes = PortalMage:CountItems(17032)
		self.teleports:SetText(teleportRunes)
		self.portals:SetText(portalRunes)
		self:SetHeight(44)
		PortalMage.move:SetHeight(44);
		PortalMage.buttons = {}
		if portalMageData.Vertical then
			PortalMage:SetupButtonsVertical(self, PortalMage.move)
		else
			PortalMage:SetupButtonsHorizontal(self, PortalMage.move)
		end
		if Masque ~= nil then
			PortalMage:AddMasqueButtons()
			group:ReSkin()
		end
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "LEARNED_SPELL_IN_SKILL_LINE" and PortalMage:NewSpell(arg1) then
		self:SetHeight(44)
		PortalMage.move:SetHeight(44);
		PortalMage.buttons = {}
		if portalMageData.Vertical then
			PortalMage:SetupButtonsVertical(self, PortalMage.move)
		else
			PortalMage:SetupButtonsHorizontal(self, PortalMage.move)
		end
		if Masque ~= nil then
			PortalMage:RemoveMasqueButtons()
			PortalMage:AddMasqueButtons()
			group:ReSkin()
		end
	elseif event == "BAG_UPDATE" then
		teleportRunes = PortalMage:CountItems(17031)
		portalRunes = PortalMage:CountItems(17032)
		self.teleports:SetText(teleportRunes)
		self.portals:SetText(portalRunes)
		AdjustReagentDisplay(self)
	elseif event == "UNIT_SPELLCAST_START" then
		if IsInGroup() or IsInRaid() then
			if arg1 == "player" and PortalMage:SpellIsPortal(arg3) and portalMageData.AnnouncePortal then
				local msg = string.format(portalMageData.PortalAnnouncement, C_Spell.GetSpellInfo(arg3).name)
				SendChatMessage(msg, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
			elseif arg1 == "player" and PortalMage:SpellIsTeleport(arg3) and portalMageData.AnnounceTeleport then
				local msg = string.format(portalMageData.TeleportAnnouncement, C_Spell.GetSpellInfo(arg3).name)
				SendChatMessage(msg, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
			end
		end
	end
end

function PortalMage.frameOnDragStart(self)
	PortalMage.frame:StartMoving()
end

function PortalMage.frameOnDragStop(self)
	PortalMage.frame:StopMovingOrSizing()
	portalMageData.X = PortalMage.frame:GetLeft()
	portalMageData.Y = PortalMage.frame:GetBottom()
end

function PortalMage:NewSpell(id)
	if self:SpellOnList(id) then
		for i = start + 1,317,1 do
			_, spell = GetActionInfo(i)
			if spell == id then
				return false
			end
		end
		return true
	end
	return false
end

function PortalMage:SpellIsPortal(id)
	for k, v in pairs(self.portals) do
		if id == v then 
			return true
		end
	end
	return false
end

function PortalMage:SpellIsTeleport(id)
	for k, v in pairs(self.teleports) do
		if id == v then 
			return true
		end
	end
	return false
end

function PortalMage:SpellOnList(id)
	local name = C_Spell.GetSpellInfo(id)
	for k, v in pairs(self.portals) do
		if name == v then 
			return true
		end
	end
	return false
end

function PortalMage:SetupFrame(frame)
	frame:SetMovable(true)
	frame:SetPoint("BOTTOMLEFT", portalMageData.X, portalMageData.Y)
	frame:SetScale(0.8 * portalMageData.Scale)
	frame:SetFrameStrata("LOW")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
	frame:RegisterEvent("UNIT_SPELLCAST_START")
	frame:SetScript("OnEvent", PortalMage.frameOnEvent)
	frame.teleports = frame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	frame.teleports:SetTextColor(1, 1, 0)
	frame.teleports:SetText(teleportRunes)
	frame.portals = frame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	frame.portals:SetTextColor(0, 1, 0)
	frame.portals:SetText(portalRunes)
	if portalMageData.Runes.Portal.show then
		frame.portals:Show()
	else
		frame.portals:Hide()
	end
	if portalMageData.Runes.Teleport.show then
		frame.teleports:Show()
	else
		frame.teleports:Hide()
	end
	if portalMageData.Mouseover then
		frame:SetAlpha(0)
	else
		frame:SetAlpha(portalMageData.Opacity)
	end
end

function PortalMage:SetupMoveFrame(frame)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetPoint("BOTTOMLEFT", 0, 0)
	frame:SetFrameStrata("HIGH")
	local backdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = false,
		tileSize = 0,
	}
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0.75, 0.25, 0.75)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", PortalMage.frameOnDragStart)
	frame:SetScript("OnDragStop", PortalMage.frameOnDragStop)
	frame:Hide()
end

function PortalMage:CountItems(item)
	local count = 0
	for bag = 0 ,NUM_BAG_SLOTS do
		for slot = 1, C_Container.GetContainerNumSlots(bag) do
			if item == C_Container.GetContainerItemID(bag, slot) then
				local info = C_Container.GetContainerItemInfo(bag, slot)
				if info then
					count = count + info.stackCount
				end
			end
		end
	end
	return count
end

function PortalMage:IsFactionSplit(index)
	if index == "shattrath" or index == "tolbarad" or index == "pandaria" then
		if self.faction == "Alliance" then
			return index .. "A"
		else
			return index .. "H"
		end
	end
	return index
end

function PortalMage:SetupButtonsVertical(frame, move)
	self:ClearButtons()
	local length = 0
	local index = "0"
	local name = ""
	if self.faction == "Alliance" then
		for i = 1, table.getn(portalMageIndicesA), 1 do
			index = portalMageIndicesA[i]
			name = self:IsFactionSplit(index)
			if portalMageSpells[index] then
				self.buttons[i], length = self:SetupButtonVertical("PortalMageButton" .. i, self.buttons[i], length, name, start + 1, frame, PortalMage.icons[index])
			end
		end
	else
		for i = 1, table.getn(portalMageIndicesH), 1 do
			index = portalMageIndicesH[i]
			name = self:IsFactionSplit(index)
			if portalMageSpells[index] then
				self.buttons[i], length = self:SetupButtonVertical("PortalMageButton" .. i, self.buttons[i], length, name, start + 1, frame, PortalMage.icons[index])
			end
		end
	end
	frame:SetWidth(44)
	move:SetWidth(44)
	frame:SetHeight(-length)
	move:SetHeight(-length)
	AdjustReagentDisplay(frame)
	collectgarbage("collect")
end

function PortalMage:SetupButtonsHorizontal(frame, move)
	self:ClearButtons()
	local length = 0
	local index = "0"
	local name = ""
	if self.faction == "Alliance" then
		for i = 1, table.getn(portalMageIndicesA), 1 do
			index = portalMageIndicesA[i]
			name = self:IsFactionSplit(index)
			if portalMageSpells[index] then
				self.buttons[i], length = self:SetupButtonHorizontal("PortalMageButton" .. i, self.buttons[i], length, name, start + 1, frame, PortalMage.icons[index])
			end
		end
	else
		for i = 1, table.getn(portalMageIndicesH), 1 do
			index = portalMageIndicesH[i]
			name = self:IsFactionSplit(index)
			if portalMageSpells[index] then
				self.buttons[i], length = self:SetupButtonHorizontal("PortalMageButton" .. i, self.buttons[i], length, name, start + 1, frame, PortalMage.icons[index])
			end
		end
	end
	frame:SetWidth(length)
	move:SetWidth(length)
	frame:SetHeight(44)
	move:SetHeight(44)
	AdjustReagentDisplay(frame)
	collectgarbage("collect")
end

function AdjustReagentDisplay(frame)
	frame.portals:ClearAllPoints()
	frame.teleports:ClearAllPoints()
	local offset = 15
	if portalRunes > 99 then
		offset = offset + 17
	elseif portalRunes > 9 then
		offset = offset + 7
	end
	if string.find(portalMageData.Runes.Portal.position, "LEFT") then
		offset = -offset
	end
	frame.portals:SetPoint(portalMageData.Runes.Portal.position, offset, 0)
	offset = 15
	if teleportRunes > 99 then
		offset = offset + 17
	elseif teleportRunes > 9 then
		offset = offset + 7
	end
	if string.find(portalMageData.Runes.Teleport.position, "LEFT") then
		offset = -offset
	end
	frame.teleports:SetPoint(portalMageData.Runes.Teleport.position, offset, 0)
end

function PortalMage:SetupButtonVertical(name, button, y, index, id, frame, icon)
	if button == nil then
		button = CreateFrame("CHECKBUTTON", name, frame, BackdropTemplateMixin and "BackdropTemplate, SecureActionButtonTemplate, ActionBarButtonTemplate")
	end
	button:Show()
	button:SetWidth(44)
	button:SetHeight(44)
	button:SetPoint("TOPLEFT", 0, y)
	self:SetupButton(button, index, id, icon)
	return button, y - 44
end

function PortalMage:SetupButtonHorizontal(name, button, x, index, id, frame, icon)
	if button == nil then
		button = CreateFrame("CHECKBUTTON", name, frame, BackdropTemplateMixin and "BackdropTemplate, SecureActionButtonTemplate, ActionBarButtonTemplate")
	end
	button:Show()
	button:SetWidth(44)
	button:SetHeight(44)
	button:SetPoint("TOPLEFT", x, 0)
	self:SetupButton(button, index, id, icon)
	return button, x + 44
end

function PortalMage:SetupButton(button, index, id, icon)
	button:SetFrameStrata("MEDIUM")
	button:SetAttribute("showgrid", 1)
	button:SetAttribute("action", id)
	button:SetAttribute("type", "spell")
	if portalMageData.Invert then
		button:SetAttribute("spell2", self.portals[index])
		button:SetAttribute("spell1", self.teleports[index])
		button:SetScript("OnEnter", function(self) 
						PortalMage.frame:SetAlpha(1)
						GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
						PortalMage:SetTooltipText(L["Left Click:"], L["Right Click:"], self:GetAttribute("spell1"), self:GetAttribute("spell2"))
						GameTooltip:Show()
						end)
	else
		button:SetAttribute("spell1", self.portals[index])
		button:SetAttribute("spell2", self.teleports[index])
		button:SetScript("OnEnter", function(self) 
						PortalMage.frame:SetAlpha(1)
						GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
						PortalMage:SetTooltipText(L["Left Click:"], L["Right Click:"], self:GetAttribute("spell1"), self:GetAttribute("spell2"))
						GameTooltip:Show()
						end)
	end
	button:SetScript("OnLeave", function(self)
					if portalMageData.Mouseover then
						PortalMage.frame:SetAlpha(0)
					else
						PortalMage.frame:SetAlpha(portalMageData.Opacity)
					end
					GameTooltip:Hide()
					end)
	button:SetBackdrop({bgFile = icon,
					   tile = false,
					   insets = {left = 2,
								 right = 2,
								 top = 2,
								 bottom = 2}})
end

function PortalMage:SetTooltipText(button1, button2, spell1, spell2)
	local leftText = {}
	local rightText = {}
	local colors = {}
	local index
	leftText[1] = button1
	rightText[1] = nil
	colors[1] = 0
	GameTooltip:SetSpellByID(spell1)
	for i = 1, GameTooltip:NumLines() do 
		index = i + 1
		leftText[index] = _G["GameTooltipTextLeft"..i]:GetText()
		rightText[index] = _G["GameTooltipTextRight"..i]:GetText()
		if i == GameTooltip:NumLines() then
			colors[index] = 0
		else
			colors[index] = 1
		end
	end
	leftText[index + 1] = "\n"
	rightText[index + 1] = nil
	colors[index + 1] = 0
	leftText[index + 2] = button2
	rightText[index + 2] = nil
	colors[index + 2] = 0
	GameTooltip:SetSpellByID(spell2)
	for i = 1, GameTooltip:NumLines() do 
		leftText[i + index + 2] = _G["GameTooltipTextLeft"..i]:GetText()
		rightText[i + index + 2] = _G["GameTooltipTextRight"..i]:GetText()
		if i == GameTooltip:NumLines() then
			colors[i + index + 2] = 0
		else
			colors[i + index + 2] = 1
		end
	end
	GameTooltip:ClearLines()
	for i = 1, table.getn(leftText) do
		if rightText[i] == nil then
			GameTooltip:AddLine(leftText[i], 1, 1, colors[i], true)
		else
			GameTooltip:AddDoubleLine(leftText[i], rightText[i], 1, 1, colors[i], 1, 1, colors[i])
		end
	end
end

function PortalMage:ClearButtons()
	for i = 1, table.getn(portalMageIndicesA), 1 do
		self:ClearButton(self.buttons[i], start + i)
	end
end

function PortalMage:ClearButton(button, id)
	if button ~= nil then
		button:Hide()
		button:SetAttribute("showgrid", 0)
		button:SetAttribute("action", id)
		button:SetAttribute("type", "spell")
	end
end