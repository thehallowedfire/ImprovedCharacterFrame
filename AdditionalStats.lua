local _, ICF = ...;

ICF.ScanTooltip = CreateFrame("GameTooltip", "ICF_ScanTooltip");
local ITEM_SLOTS_WITH_DURABILITY = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
   [10] = _G.INVTYPE_HAND,
   [16] = _G.INVTYPE_WEAPONMAINHAND,
   [17] = _G.INVTYPE_WEAPONOFFHAND,
   [18] = _G.INVTYPE_RANGED,
};
local function ICF_GetTotalRepairCostAndDurability()
    local repairTotalCost = 0;
	local currentDurability = 0;
	local totalDurability = 0;

    for slotId in pairs(ITEM_SLOTS_WITH_DURABILITY) do
	    ICF.ScanTooltip:ClearLines();
	    local repairItemCost = select(3, ICF.ScanTooltip:SetInventoryItem("player", slotId));
	    repairTotalCost = repairTotalCost + (repairItemCost or 0);

		local currentItemDurability, totalItemDurability = GetInventoryItemDurability(slotId);
		currentDurability = currentDurability + (currentItemDurability or 0);
		totalDurability = totalDurability + (totalItemDurability or 0);
    end

	local durabilityPercent = 0;
	if totalDurability ~= 0 then
		durabilityPercent = currentDurability / totalDurability * 100;
	end

    return repairTotalCost, durabilityPercent;
end

local function ICF_RepairCostUpdateFunction(statFrame, unit)
    if (not unit) then
        unit = "player";
    end

    local repairCost, durabilityPercent = ICF_GetTotalRepairCostAndDurability();
	local repairCostShort = repairCost;
	if repairCost == 0 then
		statFrame:Hide();
		return;
	elseif repairCost > 999999 then
		repairCostShort = floor((repairCost + 500000) / 1000000) * 1000000;
	elseif repairCost > 9999 then
		repairCostShort = floor((repairCost + 5000) / 10000) * 10000;
	elseif repairCost > 99 then
		repairCostShort = floor((repairCost + 50) / 100) * 100;
	end
	
	local repairCostString = GetMoneyString(repairCostShort);

    local REPAIR_COST_LABEL = gsub(REPAIR_COST, ":", "");
    PaperDollFrame_SetLabelAndText(statFrame, REPAIR_COST_LABEL, repairCostString, false);
    statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, REPAIR_COST_LABEL).." "..GetMoneyString(repairCost)..FONT_COLOR_CODE_CLOSE;
    local ICF_STAT_REPAIR_DESCRIPTION = "Estimated repair cost (for currently equipped items).";
	statFrame.tooltip2 = ICF_STAT_REPAIR_DESCRIPTION.."\n"..DURABILITY..": "..floor(durabilityPercent).."%";
    statFrame:Show();
end


if IsAddOnLoaded("Blizzard_CharacterFrame") then
    tinsert(PAPERDOLL_STATCATEGORIES["GENERAL"].stats, "REPAIR_COST");
    PAPERDOLL_STATINFO["REPAIR_COST"] = {
        updateFunc = function(statFrame, unit) ICF_RepairCostUpdateFunction(statFrame, unit); end
    };
end