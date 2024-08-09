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

local function ICF_SaveDefaultCVars()
    ICF_SETTINGS = {};
    ICF_SETTINGS["CVars"] = {};
    for k, v in pairs(ICF_DEFAULT_SETTINGS["CVars"]) do
        ICF_SETTINGS["CVars"][k] = v;
    end
end

local REGULAR_CVARS = {
    "characterFrameCollapsed",
    "statCategoryOrder",
    "statCategoryOrder_2"
};
local BITFIELD_CVARS = {
    "statCategoriesCollapsed",
    "statCategoriesCollapsed_2"
};
local function tcontains(tbl, x)
    for _, v in ipairs(tbl) do
        if v == x then
            return true
        end
    end
    return false
end

function ICF.CheckMissingCVars()
    if C_CVar.GetCVar("characterFrameCollapsed") == nil then
        for _, cvar in ipairs(REGULAR_CVARS) do
            C_CVar.RegisterCVar(cvar);
        end
        for _, cvar in ipairs(BITFIELD_CVARS) do
            C_CVar.RegisterCVar(cvar);
        end
    end
end

function ICF.RestoreCurrentCharCvars()
    if ICF_SETTINGS == nil then
        ICF_SaveDefaultCVars();
    end

    for _, cvar in ipairs(REGULAR_CVARS) do
        C_CVar.SetCVar(cvar, ICF_SETTINGS["CVars"][cvar])
    end
    for _, cvar in ipairs(BITFIELD_CVARS) do
        for i=1, 7 do
            C_CVar.SetCVarBitfield(cvar, i, ICF_SETTINGS["CVars"][cvar][i])
        end
    end
end

function ICF.SaveCVar(name, value, index)
    if tcontains(REGULAR_CVARS, name) then
        ICF_SETTINGS["CVars"][name] = value;
    elseif tcontains(BITFIELD_CVARS, name) then
        ICF_SETTINGS["CVars"][name][index] = value;
    end
end

function ICF.HookCVarsChange()
    hooksecurefunc("SetCVar", function(name, value)
        if tcontains(REGULAR_CVARS, name) then
            ICF.SaveCVar(name, value);
        end
    end);
    hooksecurefunc("SetCVarBitfield", function(name, index, value)
        if tcontains(BITFIELD_CVARS, name) then
            ICF.SaveCVar(name, value, index);
        end
    end);
end
