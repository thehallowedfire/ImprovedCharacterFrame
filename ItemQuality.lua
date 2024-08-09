local _, ICF = ...;

local ICF_ITEMSLOTS = {
    [1] = CharacterHeadSlot,
    [2] = CharacterNeckSlot,
    [3] = CharacterShoulderSlot,
    [4] = CharacterShirtSlot,
    [5] = CharacterChestSlot,
    [6] = CharacterWaistSlot,
    [7] = CharacterLegsSlot,
    [8] = CharacterFeetSlot,
    [9] = CharacterWristSlot,
    [10] = CharacterHandsSlot,
    [11] = CharacterFinger0Slot,
    [12] = CharacterFinger1Slot,
    [13] = CharacterTrinket0Slot,
    [14] = CharacterTrinket1Slot,
    [15] = CharacterBackSlot,
    [16] = CharacterMainHandSlot,
    [17] = CharacterSecondaryHandSlot,
    [18] = CharacterRangedSlot,
    [19] = CharacterTabardSlot,
};

local function ICF_SetItemButtonBorder(button, asset)
    button.IconBorder:SetShown(asset ~= nil);
    if asset then
        button.IconBorder:SetTexture(asset);
    end
end

local function ICF_SetItemButtonBorderVertexColor(button, r, g, b)
    if button.IconBorder then
        button.IconBorder:SetVertexColor(r, g, b);
    end
end

local function ICF_SetItemButtonQuality(button, quality)
    if button and quality ~= 0 then
        local hasQuality = quality or BAG_ITEM_QUALITY_COLORS[quality];
        if hasQuality then
            ICF_SetItemButtonBorder(button, [[Interface\Common\WhiteIconFrame]]);
            local color = BAG_ITEM_QUALITY_COLORS[quality];
            ICF_SetItemButtonBorderVertexColor(button, color.r, color.g, color.b);
        else
            button.IconBorder:Hide();
        end
    end
end

function ICF.SetItemQuality(itemSlotID)
    local quality = GetInventoryItemQuality("player", itemSlotID);
    local itemSlot = ICF_ITEMSLOTS[itemSlotID];
    if quality and itemSlot:IsShown() then
        ICF_SetItemButtonQuality(itemSlot, quality);
    end
end

function ICF.ClearItemQuality(itemSlotID)
    local itemSlot = ICF_ITEMSLOTS[itemSlotID];
    itemSlot.IconBorder:Hide();
end

function ICF.UpdateAllItemQuality()
    for id, _ in pairs(ICF_ITEMSLOTS) do
        ICF.ClearItemQuality(id);
        ICF.SetItemQuality(id);
    end
end
