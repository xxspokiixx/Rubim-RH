--- Localize Vars
-- Addon
local RubimRH = LibStub("AceAddon-3.0"):GetAddon("RubimRH")
-- Addon
local addonName, addonTable = ...;
-- HeroLib
local HL = HeroLib;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;

local mainAddon = RubimRH

RubimRH.Spell[73] = {
    ArcaneTorrent = Spell(69179),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    Shadowmeld = Spell(58984),
    BloodFury  = Spell(20572),
    Berserking = Spell(26297),
    ArcaneTorrent = Spell(50613),
    LightsJudgment = Spell(255647),
    Fireblood = Spell(265221),
    AncestralCall = Spell(274738),
    -- Abilities
    BerserkerRage = Spell(18499),
    Charge = Spell(100), -- Unused
    DemoralizingShout = Spell(1160),
    Devastate = Spell(20243),
    HeroicLeap = Spell(6544), -- Unused
    HeroicThrow = Spell(57755), -- Unused
    Revenge = Spell(6572),
    RevengeBuff = Spell(5302),
    ShieldSlam = Spell(23922),
    ThunderClap = Spell(6343),
    VictoryRush = Spell(34428),
    Victorious = Spell(32216),
    LastStand = Spell(12975),
    Avatar = Spell(107574),
    BattleShout = Spell(6673),
	Intercept = Spell(198304),	  
    -- Talents
    BoomingVoice = Spell(202743),
    ImpendingVictory = Spell(202168),
    Shockwave = Spell(46968),
    CracklingThunder = Spell(203201),
    Vengeance = Spell(202572),
    VegeanceIP = Spell(202574),
    VegeanceRV = Spell(202573),
    UnstoppableForce = Spell(275336),
    Ravager = Spell(228920),
    Bolster = Spell(280001),
    DragonRoar = Spell(118000),
    -- PVP Talents
    ShieldBash = Spell(198912),
    -- Defensive
    IgnorePain = Spell(190456),
    Pummel = Spell(6552),
    ShieldBlock = Spell(2565),
    ShieldBlockBuff = Spell(132404),
    ShieldWall = Spell(871),
    Taunt = Spell(355),
    Opressor = Spell(205800),
    Intimidated = Spell(206891),
	-- Azerite
	DeafeningCrash = Spell(272824),
	BraceForImpact = Spell(277636),
    FreeRevenge = Spell(5302),
    AvatarBuff = Spell(107574),
    LastStandBuff = Spell(12975),
    IntimidatingShout = Spell(5246),
	Stormbolt = Spell(107570),
	Shockwave = Spell(46968),
	
	--8.2 Essences
  AnimaofDeath          = Spell(294926),
  AnimaofDeath2          = Spell(294926),
  AnimaofDeath3          = Spell(294926),
  AnimaofLife           = Spell(294964),
  AnimaofLife2           = Spell(294964),
  AnimaofLife3           = Spell(294964),
  UnleashHeartOfAzeroth = Spell(280431),
  BloodOfTheEnemy       = Spell(297108),
  BloodOfTheEnemy2      = Spell(298273),
  BloodOfTheEnemy3      = Spell(298277),
  ConcentratedFlame     = Spell(295373),
  ConcentratedFlame2    = Spell(299349),
  ConcentratedFlame3    = Spell(299353),
  GuardianOfAzeroth     = Spell(295840),
  GuardianOfAzeroth2    = Spell(299355),
  GuardianOfAzeroth3    = Spell(299358),
  FocusedAzeriteBeam    = Spell(295258),
  FocusedAzeriteBeam2   = Spell(299336),
  FocusedAzeriteBeam3   = Spell(299338),
  PurifyingBlast        = Spell(295337),
  PurifyingBlast2       = Spell(299345),
  PurifyingBlast3       = Spell(299347),
  TheUnboundForce       = Spell(298452),
  TheUnboundForce2      = Spell(299376),
  TheUnboundForce3      = Spell(299378),
  RippleInSpace         = Spell(302731),
  RippleInSpace2        = Spell(302982),
  RippleInSpace3        = Spell(302983),
  WorldveinResonance    = Spell(295186),
  WorldveinResonance2   = Spell(298628),
  WorldveinResonance3   = Spell(299334),
  MemoryOfLucidDreams   = Spell(298357),
  MemoryOfLucidDreams2  = Spell(299372),
  MemoryOfLucidDreams3  = Spell(299374),
	
}

local S = RubimRH.Spell[73]

-- Items
if not Item.Warrior then Item.Warrior = {} end
Item.Warrior.Protection = {
  BattlePotionofStrength           = Item(163224),
  GrongsPrimalRage                 = Item(165574)
};
local I = Item.Warrior.Protection;

local ShouldReturn;

local function num(val)
  if val then return 1 else return 0 end
end

local function bool(val)
  return val ~= 0
end

local EnemyRanges = {5, 10}
local function UpdateRanges()
  for _, i in ipairs(EnemyRanges) do
    HL.GetEnemies(i);
  end
end
-- Custom Warrior Protection functions

local function isCurrentlyTanking()
  -- is player currently tanking any enemies within 16 yard radius
  local IsTanking = Player:IsTankingAoE(16) or Player:IsTanking(Target);
  return IsTanking;
end

local function shouldCastIp()
  if Player:Buff(S.IgnorePain) then 
    local castIP = tonumber((GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D","")))
    local IPCap = math.floor(castIP * 1.3);
    local currentIp = Player:Buff(S.IgnorePain, 16, true)

    -- Dont cast IP if we are currently at 50% of IP Cap remaining
    if currentIp  < (0.5 * IPCap) then
      return true
    else
      return false
    end
  else
    -- No IP buff currently
    return true
  end
end

local function offensiveShieldBlock()
  if RubimRH.db.profile[73].UseShieldBlockDefensively == false then  
    return true
  else
    return false
  end
end

local function offensiveRage()
  if RubimRH.db.profile[73].UseRageDefensively == false then  
    return true
  else
    return false
  end
end

local function DetermineEssenceRanks()
  S.AnimaofDeath = S.AnimaofDeath2:IsAvailable() and S.AnimaofDeath2 or S.AnimaofDeath
  S.AnimaofDeath = S.AnimaofDeath3:IsAvailable() and S.AnimaofDeath3 or S.AnimaofDeath
  S.AnimaofLife = S.AnimaofLife2:IsAvailable() and S.AnimaofLife2 or S.AnimaofLife
  S.AnimaofLife = S.AnimaofLife3:IsAvailable() and S.AnimaofLife3 or S.AnimaofLife
  S.BloodOfTheEnemy = S.BloodOfTheEnemy2:IsAvailable() and S.BloodOfTheEnemy2 or S.BloodOfTheEnemy
  S.BloodOfTheEnemy = S.BloodOfTheEnemy3:IsAvailable() and S.BloodOfTheEnemy3 or S.BloodOfTheEnemy
  S.MemoryOfLucidDreams = S.MemoryOfLucidDreams2:IsAvailable() and S.MemoryOfLucidDreams2 or S.MemoryOfLucidDreams
  S.MemoryOfLucidDreams = S.MemoryOfLucidDreams3:IsAvailable() and S.MemoryOfLucidDreams3 or S.MemoryOfLucidDreams
  S.PurifyingBlast = S.PurifyingBlast2:IsAvailable() and S.PurifyingBlast2 or S.PurifyingBlast
  S.PurifyingBlast = S.PurifyingBlast3:IsAvailable() and S.PurifyingBlast3 or S.PurifyingBlast
  S.RippleInSpace = S.RippleInSpace2:IsAvailable() and S.RippleInSpace2 or S.RippleInSpace
  S.RippleInSpace = S.RippleInSpace3:IsAvailable() and S.RippleInSpace3 or S.RippleInSpace
  S.ConcentratedFlame = S.ConcentratedFlame2:IsAvailable() and S.ConcentratedFlame2 or S.ConcentratedFlame
  S.ConcentratedFlame = S.ConcentratedFlame3:IsAvailable() and S.ConcentratedFlame3 or S.ConcentratedFlame
  S.TheUnboundForce = S.TheUnboundForce2:IsAvailable() and S.TheUnboundForce2 or S.TheUnboundForce
  S.TheUnboundForce = S.TheUnboundForce3:IsAvailable() and S.TheUnboundForce3 or S.TheUnboundForce
  S.WorldveinResonance = S.WorldveinResonance2:IsAvailable() and S.WorldveinResonance2 or S.WorldveinResonance
  S.WorldveinResonance = S.WorldveinResonance3:IsAvailable() and S.WorldveinResonance3 or S.WorldveinResonance
  S.FocusedAzeriteBeam = S.FocusedAzeriteBeam2:IsAvailable() and S.FocusedAzeriteBeam2 or S.FocusedAzeriteBeam
  S.FocusedAzeriteBeam = S.FocusedAzeriteBeam3:IsAvailable() and S.FocusedAzeriteBeam3 or S.FocusedAzeriteBeam
end



--- ======= ACTION LISTS =======
local function APL()
  local Precombat_DBM, Precombat, Aoe, St, Defensive
  local gcdTime = Player:GCD()
  UpdateRanges()
  DetermineEssenceRanks()
  
  -- Precombat DBM function
  Precombat_DBM = function()
    -- flask
    -- food
    -- augmentation
    -- snapshot_stats
      -- potion
      if I.BattlePotionofStrength:IsReady() and RubimRH.PerfectPullON() then
          return I.BattlePotionofStrength:Cast()
      end
  end
  
  -- Precombat function
  Precombat = function()
    -- flask
    -- food
    -- augmentation
    -- snapshot_stats
  end
  -- Interrupt

  -- Defensives CDs
  Defensive = function()
    -- Shield Wall
    if S.ShieldWall:IsCastableP() and Player:HealthPercentage() <= RubimRH.db.profile[73].sk1 then
        return S.ShieldWall:Cast()
    end
	  -- Shield Block
    if S.ShieldBlock:IsReadyP('Melee') and (((not Player:Buff(S.ShieldBlockBuff) and (not Player:BuffP(S.LastStandBuff) or not S.Bolster:IsAvailable())) or Player:BuffRemains(S.ShieldBlockBuff) <= gcdTime + (gcdTime * 0.5)) and Player:HealthPercentage() < 50) then
        return S.ShieldBlock:Cast()
    end
	  -- Last Stand
    if S.LastStand:IsCastableP() and ((not Player:Buff(S.ShieldBlockBuff)) and Player:HealthPercentage() <= RubimRH.db.profile[73].sk2 and S.ShieldBlock:RechargeP() > (gcdTime * 2)) then
        return S.LastStand:Cast()
    end
  end
  
  -- Multi target
  Aoe = function()
    -- thunder_clap
    if S.ThunderClap:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.ThunderClap:Cast()
    end
    -- memory_of_lucid_dreams,if=buff.avatar.down
    if S.MemoryOfLucidDreams:IsCastableP('Melee') and (Player:BuffDownP(S.AvatarBuff)) and RubimRH.CDsON() then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- demoralizing_shout,if=talent.booming_voice.enabled
    if S.DemoralizingShout:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.DemoralizingShout:Cast()
    end
    -- anima_of_death,if=buff.last_stand.up
    if S.AnimaofDeath:IsCastableP('Melee') and (Player:BuffP(S.LastStandBuff)) then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- dragon_roar
    if S.DragonRoar:IsCastableP(5) and Cache.EnemiesCount[5] > 0 and RubimRH.CDsON() then
      return S.DragonRoar:Cast()
    end
    -- revenge
    if S.Revenge:IsReadyP() and Cache.EnemiesCount[5] > 0 and (Player:Buff(S.FreeRevenge) or Player:Rage() >= 60 or ((not isCurrentlyTanking()) and Player:Rage() >= 30)) then
      return S.Revenge:Cast()
    end
    -- use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.thunder_clap.remains>=4
    -- ravager
    if S.Ravager:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.Ravager:Cast()
    end
    -- shield_block,if=cooldown.shield_slam.ready&buff.shield_block.down
    if S.ShieldBlock:IsReadyP('Melee') and (S.ShieldSlam:CooldownUpP() and (not Player:BuffP(S.ShieldBlockBuff) and (not Player:BuffP(S.LastStandBuff) or not S.Bolster:IsAvailable()))) then
      return S.ShieldBlock:Cast()
    end
    -- shield_slam
    if S.ShieldSlam:IsCastableP('Melee') then
      return S.ShieldSlam:Cast()
    end
     -- devastate
     if S.Devastate:IsCastableP('Melee') then
      return S.Devastate:Cast()
    end
    
  end
  -- Single Target
  St = function()
    -- thunder_clap,if=spell_targets.thunder_clap=2&talent.unstoppable_force.enabled&buff.avatar.up
    if S.ThunderClap:IsCastableP() and (Cache.EnemiesCount[5] == 2 and S.UnstoppableForce:IsAvailable() and Player:BuffP(S.AvatarBuff)) then
      return S.ThunderClap:Cast()
    end
    -- shield_block,if=cooldown.shield_slam.ready&buff.shield_block.down
    if S.ShieldBlock:IsReadyP('Melee') and (S.ShieldSlam:CooldownUpP() and (not Player:BuffP(S.ShieldBlockBuff) and (not Player:BuffP(S.LastStandBuff) or not S.Bolster:IsAvailable()))) then
      return S.ShieldBlock:Cast()
    end
    -- shield_slam,if=buff.shield_block.up
    if S.ShieldSlam:IsCastableP("Melee") and (Player:BuffP(S.ShieldBlockBuff)) then
      return S.ShieldSlam:Cast()
    end
    -- thunder_clap,if=(talent.unstoppable_force.enabled&buff.avatar.up)
    if S.ThunderClap:IsCastableP() and Cache.EnemiesCount[5] > 0 and ((S.UnstoppableForce:IsAvailable() and Player:BuffP(S.AvatarBuff))) then
      return S.ThunderClap:Cast()
    end
    -- demoralizing_shout,if=talent.booming_voice.enabled
    if S.DemoralizingShout:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.DemoralizingShout:Cast()
    end
    -- anima_of_death,if=buff.last_stand.up
    if S.AnimaofDeath:IsCastableP('Melee') and (Player:BuffP(S.LastStandBuff)) then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- shield_slam
    if S.ShieldSlam:IsCastableP("Melee") then
      return S.ShieldSlam:Cast()
    end
    -- use_item,name=ashvanes_razor_coral,target_if=debuff.razor_coral_debuff.stack=0
    -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.stack>7&(cooldown.avatar.remains<5|buff.avatar.up)
    -- dragon_roar
    if S.DragonRoar:IsCastableP() and Cache.EnemiesCount[5] > 0 and RubimRH.CDsON() then
      return S.DragonRoar:Cast()
    end
    -- thunder_clap
    if S.ThunderClap:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.ThunderClap:Cast()
    end
    -- revenge
    if S.Revenge:IsReadyP() and Cache.EnemiesCount[5] > 0 and (Player:Buff(S.FreeRevenge) or Player:Rage() >= 60 or ((not isCurrentlyTanking()) and Player:Rage() >= 30)) then
      return S.Revenge:Cast()
    end
    -- actions.st+=/use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.shield_slam.remains>=4
    -- ravager
    if S.Ravager:IsCastableP() and Cache.EnemiesCount[5] > 0 then
      return S.Ravager:Cast()
    end
    -- devastate
    if S.Devastate:IsCastableP('Melee') then
      return S.Devastate:Cast()
    end
  end
  
  -- call precombat
  if not Player:AffectingCombat() then
    local ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
  end
  
  -- combat
  if RubimRH.TargetIsValid() then
      -- QueueSkill
	if QueueSkill() ~= nil then
		return QueueSkill()
  end
  
	-- Shockwave
   
	-- Pummel
    if S.Pummel:IsReady('Melee') and Target:IsInterruptible() and RubimRH.InterruptsON() then
        return S.Pummel:Cast()
    end
    -- Check defensives if tanking
    if isCurrentlyTanking() then
      local ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end
    end
    -- auto_attack
    -- intercept,if=time=0
    if S.Intercept:IsCastableP() and (HL.CombatTime() == 0 and not Target:IsInRange(8)) then
      return S.Intercept:Cast()
    end
    -- use_items,if=cooldown.avatar.remains>20
    -- use_item,name=grongs_primal_rage,if=buff.avatar.down
    --if I.GrongsPrimalRage:IsReady() and (Player:BuffDownP(S.AvatarBuff)) then
    --  return I.GrongsPrimalRage:Cast()
    --end
    -- blood_fury
    if S.BloodFury:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.BloodFury:Cast()
    end
    -- berserking
    if S.Berserking:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.Berserking:Cast()
    end
    -- arcane_torrent
    if S.ArcaneTorrent:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.ArcaneTorrent:Cast()
    end
    -- lights_judgment
    if S.LightsJudgment:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.LightsJudgment:Cast()
    end
    -- fireblood
    if S.Fireblood:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.Fireblood:Cast()
    end
    -- ancestral_call
    if S.AncestralCall:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.AncestralCall:Cast()
    end
    -- potion,if=buff.avatar.up|target.time_to_die<25
    --if I.BattlePotionofStrength:IsReady() and RubimRH.PerfectPullON() and (Player:BuffP(S.AvatarBuff) or Target:TimeToDie() < 25) then
    --  return I.BattlePotionofStrength:Cast()
    --end
  -- Impending Victory -> Cast when < 85% HP
    if S.ImpendingVictory:IsReady()
            and Player:HealthPercentage() <= 70 then
        return S.VictoryRush:Cast()
    end
    -- Victory Rush -> Buff about to expire
    if Player:BuffP(S.Victorious) and Player:HealthPercentage() <= 70 and S.VictoryRush:IsReady() then
        return S.VictoryRush:Cast()
    end	
    -- ignore_pain,if=rage.deficit<25+20*talent.booming_voice.enabled*cooldown.demoralizing_shout.ready
    if S.IgnorePain:IsReadyP() and (Player:RageDeficit() < 25 + 20 * num(S.BoomingVoice:IsAvailable()) * num(S.DemoralizingShout:CooldownUpP())) then
      return S.IgnorePain:Cast()
    end
    if S.IgnorePain:IsReadyP() and (Player:RageDeficit() < 25 + 20 * num(S.BoomingVoice:IsAvailable()) * num(S.DemoralizingShout:CooldownUpP()) and shouldCastIp() and isCurrentlyTanking()) then
      return S.IgnorePain:Cast()
    end
    -- worldvein_resonance,if=cooldown.avatar.remains<=2
    if S.WorldveinResonance:IsCastableP('Melee') and (S.Avatar:CooldownRemainsP() <= 2) and RubimRH.CDsON() then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- ripple_in_space
    if S.RippleInSpace:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- memory_of_lucid_dreams
    if S.MemoryOfLucidDreams:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- concentrated_flame,if=buff.avatar.down
    if S.ConcentratedFlame:IsCastableP('Melee') and (Player:BuffDownP(S.AvatarBuff)) and RubimRH.CDsON() then
      return S.UnleashHeartOfAzeroth:Cast()
    end
    -- last_stand,if=cooldown.anima_of_death.remains<=2
    -- avatar
    if S.Avatar:IsCastableP('Melee') and RubimRH.CDsON() then
      return S.Avatar:Cast()
    end
    -- run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
    if (Cache.EnemiesCount[5] >= 3) and RubimRH.AoEON() then
      return Aoe();
    end
    -- call_action_list,name=st
    if (true) then
      local ShouldReturn = St(); if ShouldReturn then return ShouldReturn; end
    end
  end
  return 0, 135328
end

RubimRH.Rotation.SetAPL(73, APL);

local function PASSIVE()
    return RubimRH.Shared()
end

RubimRH.Rotation.SetPASSIVE(73, PASSIVE);
