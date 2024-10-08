local _, ICF = ...;

ICF.f = CreateFrame("Frame");

if IsAddOnLoaded("Blizzard_CharacterFrame") then
    PaperDollFrame:HookScript("OnShow", ICF.UpdateAllItemQuality);

    -- FIXES
    ICF.FixWeaponsSlots()
    ICF.FixStatBgStripes()
    ICF.HookCVarsChange()
else
    ICF.f:RegisterEvent("ADDON_LOADED");
end
ICF.f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
ICF.f:RegisterEvent("PLAYER_LOGIN");
ICF.f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_CharacterFrame" then
        PaperDollFrame:HookScript("OnShow", ICF.UpdateAllItemQuality);
        ICF.f:UnregisterEvent("ADDON_LOADED");

        -- FIXES
        ICF.FixWeaponsSlots();
        ICF.FixStatBgStripes();
        ICF.HookCVarsChange()
    elseif event == "PLAYER_LOGIN" then
        ICF.CheckMissingCVars();
        ICF.RestoreCurrentCharCvars();
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        ICF.ClearItemQuality(arg1);
        ICF.SetItemQuality(arg1);
    end
end);
