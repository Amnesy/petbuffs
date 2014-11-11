-----------------------------------------------------------------
-- Pet module
-----------------------------------------------------------------

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

PetBuffs.Pet = PetBuffs:NewModule('Pet')
PetBuffs.Pet.__index = PetBuffs.Pet

function PetBuffs.Pet.GetFilteredSortedList(filters, order)
    local pets = {}
    for _, pet in pairs(PetBuffs.Pets) do
        if PetBuffs.Pet.FilterName(pet, filters)
            and PetBuffs.Pet.FilterExoticism(pet, filters)
            and PetBuffs.Pet.FilterBuffs(pet, filters) then
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

function PetBuffs.Pet.FilterBuffs(pet, filters)
    for filter, enabled in pairs(filters) do
        if table.contains(PBC.BUFF_FILTERS, filter) then
            if enabled and table.contains(pet.buffs, filter) then
                return true
            end
        end
    end
    return false
end

function PetBuffs.Pet.CompareByName(pet1, pet2)
    return string.lower(pet1.name) < string.lower(pet2.name)
end

PetBuffs.Pet.OrderFunctions = {
    [PBC.NAME_ORDER] = PetBuffs.Pet.CompareByName
}
