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

function PetBuffs.Pet.GetFilteredSortedList(filter, order)
    local pets = {}
    local filter_function = PetBuffs.Pet.FilterFunctions[filter]
    local order_function = PetBuffs.Pet.OrderFunctions[order]

    for _, pet in pairs(PetBuffs.Pets) do
        if filter_function == nil or filter_function(pet) then
            tinsert(pets, pet)
        end
    end
    table.sort(pets, order_function)

    return pets
end

function PetBuffs.Pet.CompareByName(pet1, pet2)
    return string.lower(pet1.name) < string.lower(pet2.name)
end

PetBuffs.Pet.FilterFunctions = { }

PetBuffs.Pet.OrderFunctions = {
    [PBC.NAME_ORDER] = PetBuffs.Pet.CompareByName
}
