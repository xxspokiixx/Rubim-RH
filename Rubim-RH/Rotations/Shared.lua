---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rubim.
--- DateTime: 12/07/2018 07:01
---

local HL = HeroLib
local Cache = HeroCache
local Unit = HL.Unit
local Player = Unit.Player
local Target = Unit.Target
local Spell = HL.Spell
local Item = HL.Item
local mainAddon = RubimRH

local ProlongedPower = Item(142117)
local Healthstone = 5512
local autoAttack = Spell(6603)

local trinket2 = 1030910
local trinket1 = 1030902

function Item:IsBuffTrinket()

end

local AreaTrinket = {
    159611,
}

local function IsAreaTrinket(itemID)
    for i, itemArray in pairs() do
        if itemID == itemArray then
            return true
        end
    end
    return false
end

local function trinketReady(trinketPosition)
    local inventoryPosition

    if trinketPosition == 1 then
        inventoryPosition = 13
    end
    if trinketPosition == 2 then
        inventoryPosition = 14
    end

    local start, duration, enable = GetInventoryItemCooldown("Player", inventoryPosition)

    if enable == 0 then
        return false
    end

    if start + duration - GetTime() > 0 then
        return false
    end

    return true
end

function QueueSkill()
    if RubimRH.QueuedSpell():ID() ~= 1 and Player:PrevGCDP(1, RubimRH.QueuedSpell()) then
        RubimRH.queuedSpell = { RubimRH.Spell[1].Empty, 0 }
    end
    if RubimRH.QueuedSpell():IsReadyQueue() then
        if RubimRH.QueuedSpell():ID() == 194844 and Player:RunicPower() <= 90 then
        else
            return RubimRH.QueuedSpell():Cast()
        end
    end

    if RubimRH.QueuedSpellAuto():ID() ~= 1 and Player:PrevGCDP(1, RubimRH.QueuedSpellAuto()) then
        RubimRH.queuedSpellAuto = { RubimRH.Spell[1].Empty, 0 }
    end

    if RubimRH.QueuedSpellAuto():IsReadyQueue() then
        return RubimRH.QueuedSpellAuto():Cast()
    end
end
--#TODO FIX THIS
-- 13.05.19 - Should now work as intended
function RubimRH.Shared()
    if Player:AffectingCombat() then

        if not Target:Exists() then
			--print("It works");  
			HL.GetEnemies(30)
			if Cache.EnemiesCount[30] >= 1 then
		        return 133015   
            end
        end

        if Player:ShouldStopCasting() and Player:IsCasting() then
            return 249170
        end

        if Item(Healthstone):IsReady() and Player:HealthPercentage() <= RubimRH.db.profile.mainOption.healthstoneper then
            return 538745
        end

        if Target:Exists() and ((Player:IsMelee() and Target:MaxDistanceToPlayer(true) <= 8) or (not Player:IsMelee())) and RubimRH.CDsON() and Player:CanAttack(Target) then
            for i = 1, #RubimRH.db.profile.mainOption.useTrinkets do
                if RubimRH.db.profile.mainOption.useTrinkets[1] == true then
                    if trinketReady(1) then
                        return trinket1
                    end
                end

                if RubimRH.db.profile.mainOption.useTrinkets[2] == true then
                    if trinketReady(2) then
                        return trinket2
                    end
                end
            end
        end

    end
end
