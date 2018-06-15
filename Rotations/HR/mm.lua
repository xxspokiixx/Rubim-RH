---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rubim.
--- DateTime: 14/06/2018 16:30
---

--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- AethysCore
local AC = AethysCore;
local Cache = AethysCache;
local Unit = AC.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = AC.Spell;
local Item = AC.Item;

-- Spells
if not Spell.Hunter then
    Spell.Hunter = {};
end
Spell.Hunter.Marksmanship = {
    -- Racials
    ArcaneTorrent = Spell(25046),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    GiftoftheNaaru = Spell(59547),
    Shadowmeld = Spell(58984),
    -- Abilities
    AimedShot = Spell(19434),
    ArcaneShot = Spell(185358),
    BurstingShot = Spell(186387),
    HuntersMark = Spell(185365),
    MarkedShot = Spell(185901),
    MarkingTargets = Spell(223138),
    MultiShot = Spell(2643),
    TrueShot = Spell(193526),
    Vulnerability = Spell(187131),
    -- Talents
    AMurderofCrows = Spell(131894),
    Barrage = Spell(120360),
    BindingShot = Spell(109248),
    BlackArrow = Spell(194599),
    ExplosiveShot = Spell(212431),
    LockandLoad = Spell(194594),
    PatientSniper = Spell(234588),
    PiercingShot = Spell(198670),
    Sentinel = Spell(206817),
    Sidewinders = Spell(214579),
    TrickShot = Spell(199522),
    Volley = Spell(194386),
    -- Artifact
    Windburst = Spell(204147),
    BullsEye = Spell(204090),
    -- Defensive
    AspectoftheTurtle = Spell(186265),
    Exhilaration = Spell(109304),
    -- Utility
    AspectoftheCheetah = Spell(186257),
    CounterShot = Spell(147362),
    Disengage = Spell(781),
    FreezingTrap = Spell(187650),
    FeignDeath = Spell(5384),
    TarTrap = Spell(187698),
    -- Legendaries
    SentinelsSight = Spell(208913),
    -- Misc
    CriticalAimed = Spell(242243),
    PotionOfProlongedPowerBuff = Spell(229206),
    SephuzBuff = Spell(208052),
    MKIIGyroscopicStabilizer = Spell(235691),
    PoolingSpell = Spell(9999000010),
    -- Macros
};
local S = Spell.Hunter.Marksmanship;
-- Items
if not Item.Hunter then
    Item.Hunter = {};
end
Item.Hunter.Marksmanship = {
    -- Legendaries
    SephuzSecret = Item(132452, { 11, 12 }),
    -- Trinkets
    ConvergenceofFates = Item(140806, { 13, 14 }),
    -- Potions
    PotionOfProlongedPower = Item(142117),
};
local I = Item.Hunter.Marksmanship;
-- Rotation Var
local ShouldReturn; -- Used to get the return string
local TrueshotCooldown = 0;
local Vuln_Window, Vuln_Aim_Casts, Can_GCD, WaitingForSentinel;
-- GUI Settings

-- Register for InFlight tracking
S.AimedShot:RegisterInFlight();
S.Windburst:RegisterInFlight();
S.MarkedShot:RegisterInFlight();
S.ArcaneShot:RegisterInFlight(S.MarkingTargets);
S.MultiShot:RegisterInFlight(S.MarkingTargets);
S.Sidewinders:RegisterInFlight(S.MarkingTargets);

local GCDPrev = Player:GCDRemains();
local function OffsetRemainsAuto (ExpirationTime, Offset)
    if type(Offset) == "number" then
        ExpirationTime = ExpirationTime - Offset;
    elseif type(Offset) == "string" then
        if Offset == "Auto" then
            local GCDRemain = Player:GCDRemains()
            local GCDelta = GCDRemain - GCDPrev;
            if GCDelta <= 0 or (GCDelta > 0 and Player.MMHunter.GCDDisable > 0) or Player:IsCasting() then
                ExpirationTime = ExpirationTime - math.max(GCDRemain, Player:CastRemains());
                GCDPrev = GCDRemain;
            else
                ExpirationTime = ExpirationTime - 0;
            end
        end
    else
        error("Invalid Offset.");
    end
    return ExpirationTime;
end

local function DebuffRemains (Spell, AnyCaster, Offset)
    local ExpirationTime = Target:Debuff(Spell, 7, AnyCaster);
    if ExpirationTime then
        if Offset then
            ExpirationTime = OffsetRemainsAuto(ExpirationTime, Offset);
        end
        local Remains = ExpirationTime - AC.GetTime();
        return Remains >= 0 and Remains or 0;
    else
        return 0;
    end
end

local function DebuffRemainsP (Spell, AnyCaster, Offset)
    return DebuffRemains(Spell, AnyCaster, Offset or "Auto");
end

local function DebuffP (Spell, AnyCaster, Offset)
    return DebuffRemains(Spell, AnyCaster, Offset or "Auto") > 0;
end

local function TargetDebuffRemainsP (Spell, AnyCaster, Offset)
    if Spell == S.Vulnerability and (S.Windburst:InFlight() or S.MarkedShot:InFlight() or Player:PrevGCDP(1, S.Windburst, true)) then
        return 7;
    else
        return DebuffRemainsP(Spell);
    end
end

local function TargetDebuffP (Spell, AnyCaster, Offset)
    if Spell == S.Vulnerability then
        return DebuffP(Spell) or S.Windburst:InFlight() or S.MarkedShot:InFlight() or Player:PrevGCDP(1, S.Windburst, true);
    elseif Spell == S.HuntersMark then
        return DebuffP(Spell) or S.ArcaneShot:InFlight(S.MarkingTargets) or S.MultiShot:InFlight(S.MarkingTargets) or S.Sidewinders:InFlight(S.MarkingTargets);
    else
        return DebuffP(Spell);
    end
end

local function PlayerFocusLossOnCastEnd ()
    if Player:IsCasting() then
        return Spell(Player:CastID()):Cost();
    elseif Player:PrevGCDP(1, S.AimedShot, true) then
        return S.AimedShot:Cost();
    elseif Player:PrevGCDP(1, S.Windburst, true) then
        return S.Windburst:Cost();
    else
        return 0;
    end
end

local function PlayerFocusRemainingCastRegen (Offset)
    if Player:FocusRegen() == 0 then
        return -1;
    end
    -- If we are casting, we check what we will regen until the end of the cast
    if Player:IsCasting() then
        return Player:FocusRegen() * (Player:CastRemains() + (Offset or 0));
        -- Else we'll use the remaining GCD as "CastTime"
    else
        return Player:FocusRegen() * (Player:GCDRemains() + (Offset or 0));
    end
end

local PFPPrev = math.floor((Player:Focus() + math.min(Player:FocusDeficit(), PlayerFocusRemainingCastRegen(Offset)) - PlayerFocusLossOnCastEnd()) + 0.5);
local function PlayerFocusPredicted (Offset)
    if Player:FocusRegen() == 0 then
        return -1;
    end
    --v2
    local FocusP = math.floor((Player:Focus() + math.min(Player:FocusDeficit(), PlayerFocusRemainingCastRegen(Offset)) - PlayerFocusLossOnCastEnd()) + 0.5);
    local FocusDelta = FocusP - PFPPrev
    --if (FocusDelta < -3 or FocusDelta > 0 and FocusDelta < 8 or S.ArcaneShot:TimeSinceLastCast() < 0.1 or S.MarkedShot:TimeSinceLastCast() < 0.1 or S.Sidewinders:TimeSinceLastCast() < 0.1 or S.MultiShot:TimeSinceLastCast() < 0.1 or Player:IsCasting()) then
    if (FocusDelta < -3 or FocusDelta > 0 and (FocusDelta < 8 or Player.MMHunter.GCDDisable > 0)) then
        PFPPrev = FocusP;
        return FocusP;
    else
        return PFPPrev;
    end
    --v1
    -- if math.abs(FocusP - 50) <= (8 - (Player:GCD() * Player:FocusRegen())) then
    --   return (Player:PrevGCD(1, S.ArcaneShot) and 60 or 49);
    -- else
    --   return FocusP;
end

local function PlayerFocusDeficitPredicted (Offset)
    return Player:FocusMax() - PlayerFocusPredicted(Offset);
end

local function IsCastableM (Spell)
    if not Player:IsMoving() or not Settings.Marksmanship.EnableMovementRotation then
        return true;
    end
    --Aimed Shot can sometimes be cast while moving
    if Spell == S.AimedShot then
        return Player:Buff(S.LockandLoad) or Player:Buff(S.MKIIGyroscopicStabilizer);
    elseif Spell == S.Windburst then
        return false;
    end
    return true
end

local function IsCastableP (Spell)
    if Spell == S.AimedShot then
        return Spell:IsCastable() and PlayerFocusPredicted() > Spell:Cost();
    elseif Spell == S.MarkedShot then
        return Spell:IsCastable() and PlayerFocusPredicted() > Spell:Cost() and TargetDebuffP(S.HuntersMark);
    elseif Spell == S.Windburst then
        return Spell:IsCastable() and not Player:PrevGCDP(1, S.Windburst, true) and not Player:IsCasting(S.Windburst);
    else
        return Spell:IsCastable();
    end
end

--- APL Main

local function Opener()
    --Use Black Arrow Icon Black Arrow on your kill target if you are talented into it.
    if S.BlackArrow:IsAvailable() and S.BlackArrow:IsCastable() then
        return S.BlackArrow:ID()
    end

    --Use Sidewinders Icon Sidewinders to apply Vulnerable Icon Vulnerable if you are talented into it.
    if S.Sidewinders:IsCastable() and S.DebuffRemains(S.Vulnerability) < 3 then
        return S.Sidewinders:ID()
    end

    --Use Arcane Shot Icon Arcane Shot/Multi-Shot Icon Multi-Shot when Marking Targets Icon Marking Targets procs.


    --Use Marked Shot Icon Marked Shot to apply Vulnerable Icon Vulnerable.
    --Cast Aimed Shot Icon Aimed Shot.
    if S.AimedShot:IsCastable() then
        return S.AimedShot:ID()
    end

    --Use Arcane Shot Icon Arcane Shot as a filler and to generate Focus.
    if S.ArcaneShot:IsCastable() then
        return S.ArcaneShot:ID()
    end

    --Use Marking Targets Icon Marking Targets procs to be able to use Marked Shot Icon Marked Shot.

    --Use Aimed Shot Icon Aimed Shots when Lock and Load Icon Lock and Load procs.
    --Use A Murder of Crows Icon A Murder of Crows if your teammate needs time to burst.
end

local function Burst()

end

local function Sustained()


end

function HunterMM ()

    if TargetIsValid() then


    end

end