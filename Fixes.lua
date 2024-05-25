local _, ICF = ...;

local ICF_DEFAULT_SETTINGS = {
    ["CVars"] = {
        ["characterFrameCollapsed"] = "1",
        ["statCategoryOrder"] = "",
        ["statCategoryOrder_2"] = "",
        ["statCategoriesCollapsed"] = {false, false, false, false, false, false, false},
        ["statCategoriesCollapsed_2"] = {false, false, false, false, false, false, false},
    },
};

function ICF_GetSetting(setting)
    if ICF_SETTINGS == nil then
        ICF_SETTINGS = {};
        for k, v in pairs(ICF_DEFAULT_SETTINGS) do
            ICF_SETTINGS[k] = v;
        end
    end
    return ICF_SETTINGS[setting]
end

function ICF.FixWeaponsSlots()
    local button = CharacterMainHandSlot;
    local size = button:GetSize();
    local _, _, _, currentX, currentY = button:GetPoint();
    button:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", currentX - size / 2, currentY);
end

function ICF.FixStatBgStripes()
    hooksecurefunc("PaperDollFrame_UpdateStatCategory", function()
        local STRIPE_COLOR = {r=0.9, g=0.9, b=1};
        local categoriesNum = 0;
        for _, _ in pairs(PAPERDOLL_STATCATEGORIES) do
            categoriesNum = categoriesNum+1;
        end
        
        for i=1, categoriesNum do
            local categoryFrame = _G["CharacterStatsPaneCategory"..i];
            if categoryFrame ~= nil and categoryFrame.Category ~= nil then
                local categoryInfo = PAPERDOLL_STATCATEGORIES[categoryFrame.Category];
                for s=1, #categoryInfo.stats do
                    local stat = _G[categoryFrame:GetName().."Stat"..s];
                    
                    if stat ~= nil and stat.Bg ~= nil then
                        stat.Bg:SetColorTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b);
                    end
                end
            end
        end
    end);
end

local function ICF_CopyCVarValueToSavedVariables(cvar)
    print("debug4")
    local value = C_CVar.GetCVar(cvar);
    local savedCvars = ICF_GetSetting("CVars")
    print("debug", cvar, value, savedCvars[cvar])
    if cvar == "statCategoriesCollapsed" or cvar == "statCategoriesCollapsed_2" then
        for i=1, 7 do
            savedCvars[cvar][i] = C_CVar.GetCVarBitfield(cvar, i);
        end
    else
        savedCvars[cvar] = value
    end
    print("debug2", value, savedCvars[cvar])
end
function ICF.FixMissingCVars()
    if C_CVar.GetCVar("characterFrameCollapsed") == nil then
        C_CVar.RegisterCVar("characterFrameCollapsed", "1");

        C_CVar.RegisterCVar("statCategoryOrder", "");
        C_CVar.RegisterCVar("statCategoryOrder_2", "");

        C_CVar.RegisterCVar("statCategoriesCollapsed");
        C_CVar.RegisterCVar("statCategoriesCollapsed_2");
        for i=1, 7 do
            C_CVar.SetCVarBitfield("statCategoriesCollapsed", i, false);
            C_CVar.SetCVarBitfield("statCategoriesCollapsed_2", i, false);
        end
    end
--[[ 
    -- Apply settings from SavedVariables
    print("debug3 >", "current state:", C_CVar.GetCVar("characterFrameCollapsed"), "new state:", ICF_GetSetting("CVars")["characterFrameCollapsed"])
    C_CVar.SetCVar("characterFrameCollapsed", ICF_GetSetting("CVars")["characterFrameCollapsed"])
    C_CVar.SetCVar("statCategoryOrder", ICF_GetSetting("CVars")["statCategoryOrder"])
    C_CVar.SetCVar("statCategoryOrder_2", ICF_GetSetting("CVars")["statCategoryOrder_2"])
    for i=1, 7 do
        C_CVar.SetCVarBitfield("statCategoriesCollapsed", i, ICF_GetSetting("CVars")["statCategoriesCollapsed"][i]);
        C_CVar.SetCVarBitfield("statCategoriesCollapsed_2", i, ICF_GetSetting("CVars")["statCategoriesCollapsed_2"][i]);
    end

    -- Hook CVars changes in order to save them per character via SavedVariables
    if CharacterFrameExpandButton then
        CharacterFrameExpandButton:HookScript("OnClick", function(self)
            print("debug Expand button on click")
            ICF_CopyCVarValueToSavedVariables("characterFrameCollapsed")
        end);
    end ]]
end
