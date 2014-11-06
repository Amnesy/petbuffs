-----------------------------------------------------------------
-- Pet module
-----------------------------------------------------------------

PetBuffs.Pet = PetBuffs:NewModule('Pet')
PetBuffs.Pet.__index = PetBuffs.Pet

function PetBuffs.Pet.GetFilteredSortedList(filters, order)
    PetBuffs:Print(filters[PBC.NAME_FILTER])
    local pets = {}
    for _, pet in pairs(PetBuffs.Pets) do
        if PetBuffs.Pet.FilterName(pet, filters)
            and PetBuffs.Pet.FilterExoticism(pet, filters) then
            tinsert(pets, pet)
        end
    end

    table.sort(pets, PetBuffs.Pet.OrderFunctions[order])

    return pets
end

function PetBuffs.Pet.FilterName(pet, filters)
    return not filters[PBC.NAME_FILTER]
        or pet.name:lower():find(filters[PBC.NAME_FILTER])
end

function PetBuffs.Pet.FilterExoticism(pet, filters)
    return filters[PBC.NON_EXOTIC_FILTER] and not pet.exotic
        or filters[PBC.EXOTIC_FILTER] and pet.exotic
end

function PetBuffs.Pet.CompareByName(pet1, pet2)
    return string.lower(pet1.name) < string.lower(pet2.name)
end

PetBuffs.Pet.OrderFunctions = {
    [PBC.NAME_ORDER] = PetBuffs.Pet.CompareByName
}
