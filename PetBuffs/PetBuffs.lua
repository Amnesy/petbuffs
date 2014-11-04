-----------------------------------------------------------------
-- AceAddon init
-----------------------------------------------------------------

local PetBuffs = LibStub('AceAddon-3.0'):NewAddon(ADDON_NAME, 'AceConsole-3.0')
_G.PetBuffs = PetBuffs

-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------

local AceConfig = LibStub('AceConfig-3.0')
local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceDB = LibStub('AceDB-3.0')
local AceDBOptions = LibStub('AceDBOptions-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON_NAME)
local ldb = LibStub:GetLibrary('LibDataBroker-1.1')

-----------------------------------------------------------------
-- Default DB
-----------------------------------------------------------------

local profileDB
local DEFAULT_DB = {
    profile = {
        msg = 'ok1'
    }
}

-----------------------------------------------------------------
-- AceConfig options
-----------------------------------------------------------------

PetBuffs.options = {
    type = 'group',
    name = ADDON_NAME,
    args = {
        general = {
            type = 'group',
            name = 'General Settings',
            cmdInline = true,
            args = {
                separator1 = {
                    type = 'header',
                    name = 'Display Options',
                },
                msg = {
                    type = 'input',
                    name = 'Test Message',
                    desc = 'Test message for my addon',
                    get = function()
                        return profileDB.msg
                    end,
                    set = function(key, value)
                        profileDB.msg = value
                    end
                }
            }
        }
    }
}

-----------------------------------------------------------------
-- PetBuffs methods
-----------------------------------------------------------------

function PetBuffs:OnInitialize()
    self.db = AceDB:New('PetBuffsDB', DEFAULT_DB, true)

    self.db.RegisterCallback(self, 'OnProfileChanged', 'OnProfileChanged')
    self.db.RegisterCallback(self, 'OnProfileCopied', 'OnProfileChanged')
    self.db.RegisterCallback(self, 'OnProfileReset', 'OnProfileChanged')

    profileDB = self.db.profile

    self.options.args.profile = AceDBOptions:GetOptionsTable(self.db)

    AceConfig:RegisterOptionsTable(ADDON_NAME, self.options)

    self.optionsFrames = {}
    self.optionsFrames.general = AceConfigDialog:AddToBlizOptions(ADDON_NAME, nil, nil, 'general')
    self.optionsFrames.profile = AceConfigDialog:AddToBlizOptions(ADDON_NAME, 'Profiles', ADDON_NAME, 'profile')

    self:RegisterChatCommand('petbuffs', 'SlashPetBuffs')
end

function PetBuffs:OnProfileChanged(event, database, newProfileKey)
    profileDB = database.profile
end

function PetBuffs:Open()
    if not PetJournalParent:IsShown() then
        TogglePetJournal()
    end
    for i = 1, PetJournalParent.numTabs do
        local tab = _G['PetJournalParentTab' .. i]
        if tab:GetText() == ADDON_NAME then
            PanelTemplates_SetTab(PetJournalParent, i)
        end
    end
end

function PetBuffs:OpenConfig()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.general)
    -- first one only opens the "Game" tab, second one opens the "Add-ons" tab
end

function PetBuffs:SlashPetBuffs(input)
    self:Print(profileDB.msg)
    PetBuffs:Open()
end

-----------------------------------------------------------------
-- LibDataBroker data object
-----------------------------------------------------------------

PetBuffs.obj = ldb:NewDataObject(ADDON_NAME, {
    type = 'data source',
    label = ADDON_NAME,
    text = ADDON_NAME,
    icon = 'Interface\\Icons\\Ability_Hunter_MendPet',
    OnClick = function(frame, msg)
        if msg == 'LeftButton' then
            PetBuffs:Open()
        elseif msg == 'RightButton' then
            PetBuffs:OpenConfig()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine(ADDON_NAME .. ' ' .. GetAddOnMetadata(ADDON_NAME, 'Version'))
        tooltip:AddLine(L['LEFT_CLICK_HINT'])
        tooltip:AddLine(L['RIGHT_CLICK_HINT'])
    end
})
