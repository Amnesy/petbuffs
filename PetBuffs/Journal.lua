-----------------------------------------------------------------
-- PetBuffs tab
-----------------------------------------------------------------

local Journal = PetBuffsJournal

-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------

local Tabs = LibStub('SecureTabs-1.0')

-----------------------------------------------------------------
-- Journal methods
-----------------------------------------------------------------

function Journal:Startup()
    HybridScrollFrame_CreateButtons(self.List, 'PetBuffsEntry', 44, 0)
    hooksecurefunc('PetJournalParent_UpdateSelectedTab', function(...)
        Tabs:Update(...)
    end)

    self.Startup = function() end
    self:SetScript('OnShow', nil)
    self.List.scrollBar.doNotHide = true
    self.SearchBox:SetText('')
    self.SearchBox:SetScript('OnTextChanged', self.Search)
end

function Journal:SetPet(pet)
    self:Startup()
    self.List.selected = pet
    self.List:update()
    self:Update()
end

function Journal:Search()
    -- Addon.Sets.TamerSearch = self:GetText()
    -- self.Instructions:SetShown(self:GetText() == '')
    self:GetParent().List:update()
end

function Journal.List:update()
    local self = Journal.List
    local off = HybridScrollFrame_GetOffset(self)
    local pets = {}

    for i, pet in pairs(PetBuffs.Pets) do
        -- PetBuffs:Print(type(pet))
        -- PetBuffs:Print(i)
        -- local pet = PetBuffs.Pet:Get(i)
        -- if Addon:Filter(tamer, Addon.Sets.TamerSearch) then
            tinsert(pets, pet)
        -- end
    end
    table.sort(pets, PetBuffs.Pet.CompareByName)

    for i, button in ipairs(self.buttons) do
        local pet = pets[i + off]

        if pet then
            button.name:SetText(pet.name)
            button.icon:SetTexture('Interface\\Icons\\' .. pet.icon)
            button.favorite:Hide();
            button.selected = false;
            button.selectedTexture:SetShown(self.selected and pet.id == self.selected.id)
            button.DragButton.ActiveTexture:Hide()
        end

        button:SetShown(pet)
        button.pet = pet
    end

    HybridScrollFrame_Update(self, #pets * 46, self:GetHeight())
end

function Journal:Update()
    if self.PetModel:IsShown() then
        self.PetModel:Display(self.List.selected)
    end
end

function Journal.PetModel:Display(pet)
    self.model:SetDisplayInfo(pet.model)
    self.model:SetDoBlend(false);
    self.model:SetRotation(-.9)
end

-----------------------------------------------------------------
-- PetBuffs tab startup
-----------------------------------------------------------------

Tabs:Startup(PetJournalParent, MountJournal, PetJournal, ToyBox)
Tabs:Add(PetJournalParent, Journal, ADDON_NAME)
Journal:SetScript('OnShow', Journal.Startup)
