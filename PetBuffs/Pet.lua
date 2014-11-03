-----------------------------------------------------------------
-- Pet module
-----------------------------------------------------------------

PetBuffs.Pet = PetBuffs:NewModule('Pet')
PetBuffs.Pet.__index = PetBuffs.Pet

-- function PetBuffs.Pet:At(landmark)
--     return self:Get(Addon.TamerLandmarks[landmark])
-- end

-- function PetBuffs.Pet:Get(id)
--     local data = PetBuffs.Pets[id]
--     if data then
--         local pet = setmetatable({
--             id = id,
--             name = data.name,
--             icon = data.icon,
--             model = data.model
--         }, self)

--         return pet
--     end
-- end

-- function PetBuffs.Pet:Display()
--     if GetAddOnEnableState(UnitName('player'), 'PetTracker_Journal') >= 2 then
--         PetJournal_LoadUI()
--         ShowUIPanel(PetJournalParent)
--         PetJournalParent_SetTab(PetJournalParent, 4)
--         PetTrackerTamerJournal:SetTamer(self)
--     end
-- end

function PetBuffs.Pet.CompareByName(pet1, pet2)
    return string.lower(pet1.name) < string.lower(pet2.name)
end
