-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON_NAME)

-----------------------------------------------------------------
-- Drop down menu
-----------------------------------------------------------------

function PetBuffsJournalFilterDropDown_OnLoad(self)
    UIDropDownMenu_Initialize(self, PetBuffsJournalFilterDropDown_Initialize, 'MENU')
end

function PetBuffsJournalFilterDropDown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.keepShownOnClick = true

    if level == 1 then
        info.text = L['FILTER_' .. PBC.NON_EXOTIC_FILTER]
        info.func = function(_, _, _, value)
            PetBuffsJournal:SetFilter(PBC.NON_EXOTIC_FILTER, value)
            PetBuffsJournal.List:update()
        end
        info.checked = function() return PetBuffsJournal:GetFilter(PBC.NON_EXOTIC_FILTER) end
        info.isNotRadio = true
        UIDropDownMenu_AddButton(info, level)

        info.disabled = nil

        info.text = L['FILTER_' .. PBC.EXOTIC_FILTER]
        info.func = function(_, _, _, value)
            PetBuffsJournal:SetFilter(PBC.EXOTIC_FILTER, value)
            PetBuffsJournal.List:update()
        end
        info.checked = function() return PetBuffsJournal:GetFilter(PBC.EXOTIC_FILTER) end
        info.isNotRadio = true
        UIDropDownMenu_AddButton(info, level)

        info.checked = nil
        info.isNotRadio = nil
        info.func =  nil
        info.hasArrow = true
        info.notCheckable = true

        info.text = L['BUFFS']
        info.value = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = RAID_FRAME_SORT_LABEL
        info.value = 2
        UIDropDownMenu_AddButton(info, level)
    else
        if UIDROPDOWNMENU_MENU_VALUE == 1 then
            info.hasArrow = false
            info.isNotRadio = true
            info.notCheckable = true


            info.text = CHECK_ALL
            info.func = function()
                for i = 1, #PBC.BUFF_FILTERS do
                    PetBuffsJournal:SetFilter(PBC.BUFF_FILTERS[i], true)
                end
                PetBuffsJournal.List:update()
                UIDropDownMenu_Refresh(PetBuffsJournalFilterDropDown, 1, 2)
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function()
                for i = 1, #PBC.BUFF_FILTERS do
                    PetBuffsJournal:SetFilter(PBC.BUFF_FILTERS[i], false)
                end
                PetBuffsJournal.List:update()
                UIDropDownMenu_Refresh(PetBuffsJournalFilterDropDown, 1, 2)
            end
            UIDropDownMenu_AddButton(info, level)

            info.notCheckable = false
            for i = 1, #PBC.BUFF_FILTERS do
                info.text = L['FILTER_' .. PBC.BUFF_FILTERS[i]]
                info.func = function(_, _, _, value)
                    PetBuffsJournal:SetFilter(PBC.BUFF_FILTERS[i], value)
                end
                PetBuffsJournal.List:update()
                info.checked = function() return PetBuffsJournal:GetFilter(PBC.BUFF_FILTERS[i]) end
                UIDropDownMenu_AddButton(info, level)
            end
        elseif UIDROPDOWNMENU_MENU_VALUE == 2 then
            info.hasArrow = false
            info.isNotRadio = nil
            info.notCheckable = nil
            info.keepShownOnClick = nil

            info.text = NAME
            info.func = function()
                PetBuffsJournal:SetOrder(PBC.NAME_ORDER)
                PetBuffsJournal.List:update()
            end
            info.checked = function() return PetBuffsJournal:GetOrder() == PBC.NAME_ORDER end
            UIDropDownMenu_AddButton(info, level)
        end
    end
end
