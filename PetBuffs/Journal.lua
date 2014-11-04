-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------

local Tabs = LibStub('SecureTabs-1.0')

-----------------------------------------------------------------
-- PetBuffsJournal methods
-----------------------------------------------------------------

function PetBuffsJournal:Startup()
    HybridScrollFrame_CreateButtons(self.List, 'PetBuffsEntry', 44, 0)
    hooksecurefunc('PetJournalParent_UpdateSelectedTab', function(...)
        Tabs:Update(...)
    end)

    self.Startup = function() end
    self:SetScript('OnShow', nil)
    self.List.scrollBar.doNotHide = true
    self.SearchBox:SetText('')
    self.SearchBox:SetScript('OnTextChanged', self.Search)

    self.filters = {
        [PBC.NON_EXOTIC_FILTER] = true,
        [PBC.EXOTIC_FILTER] = true
    }
    for i = 1, #PBC.BUFF_FILTERS do
        self.filters[PBC.BUFF_FILTERS[i]] = true
    end
    self.order = PBC.NAME_ORDER

    local pets = PetBuffs.Pet.GetFilteredSortedList(nil, self.order)
    self:SetPet(pets[1])
end

function PetBuffsJournal:SetPet(pet)
    self:Startup()
    self.List.selected = pet
    self.List:update()
    self:Update()
end

function PetBuffsJournal:Search()
    -- Addon.Sets.TamerSearch = self:GetText()
    -- self.Instructions:SetShown(self:GetText() == '')
    self:GetParent().List:update()
end

function PetBuffsJournal:SetFilter(filter, enabled)
    self.filters[filter] = enabled
end

function PetBuffsJournal:IsFilterEnabled(filter)
    return self.filters[filter]
end

function PetBuffsJournal:SetOrder(order)
    self.order = order
end

function PetBuffsJournal:GetOrder()
    return self.order
end

function PetBuffsJournal.List:update()
    local self = PetBuffsJournal.List
    local off = HybridScrollFrame_GetOffset(self)

    local pets = PetBuffs.Pet.GetFilteredSortedList(nil, PetBuffsJournal.order)

    for i, button in ipairs(self.buttons) do
        local pet = pets[i + off]

        if pet then
            button.name:SetText(pet.name)
            button.icon:SetTexture('Interface\\Icons\\' .. pet.icon)
            button.favorite:Hide()
            button.selected = false
            button.selectedTexture:SetShown(self.selected and pet.id == self.selected.id)
            button.DragButton.ActiveTexture:Hide()
        end

        button:SetShown(pet)
        button.pet = pet
    end

    HybridScrollFrame_Update(self, #pets * 46, self:GetHeight())
end

function PetBuffsJournal:Update()
    if self.PetModel:IsShown() then
        self.PetModel:Display(self.List.selected)
    end
end

function PetBuffsJournal.PetModel:Display(pet)
    self.model:SetDisplayInfo(pet.model)
    self.model:SetCamDistanceScale(pet.distance)
    self.model.rotation = pet.rotation
    self.model:SetRotation(pet.rotation)
end

-----------------------------------------------------------------
-- PetBuffs tab startup
-----------------------------------------------------------------

Tabs:Startup(PetJournalParent, MountJournal, PetJournal, ToyBox)
Tabs:Add(PetJournalParent, PetBuffsJournal, ADDON_NAME)
PetBuffsJournal:SetScript('OnShow', PetBuffsJournal.Startup)
