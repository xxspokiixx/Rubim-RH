--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroLib
local HL     = HeroLib
local Cache  = HeroCache
local Unit   = HL.Unit
local Player = Unit.Player
local Target = Unit.Target
local Pet    = Unit.Pet
local Spell  = HL.Spell
local Item   = HL.Item
local mainAddon = RubimRH

-- Spells
RubimRH.Spell[258] = {  
  WhispersoftheDamned                   = Spell(275722),
  SearingDialogue                       = Spell(272788),
  DeathThroes                           = Spell(278659),
  ThoughtHarvester                      = Spell(288340),
  SpitefulApparitions                   = Spell(277682),
  ShadowformBuff                        = Spell(232698),
  Shadowform                            = Spell(232698),
  MindBlast                             = Spell(8092),
  VampiricTouchDebuff                   = Spell(34914),
  VampiricTouch                         = Spell(34914),
  VoidEruption                          = Spell(228260),
  DarkAscension                         = Spell(280711),
  VoidformBuff                          = Spell(194249),
  MindSear                              = Spell(48045),
  HarvestedThoughtsBuff                 = Spell(288343),
  VoidBolt                              = Spell(205448),
  ShadowWordDeath                       = Spell(32379),
  SurrenderToMadness                    = Spell(193223),
  DarkVoid                              = Spell(263346),
  ShadowWordPainDebuff                  = Spell(589),
  Mindbender                            = Spell(200174),
  Shadowfiend                           = Spell(34433),
  ShadowCrash                           = Spell(205385),
  ShadowWordPain                        = Spell(589),
  Misery                                = Spell(238558),
  VoidTorrent                           = Spell(263165),
  MindFlay                              = Spell(15407),
  Berserking                            = Spell(26297),
  ShadowWordVoid                        = Spell(205351),
  LegacyOfTheVoid                       = Spell(193225),
  FortressOfTheMind                     = Spell(193195),
  Dispersion                            = Spell(47585),
  ShadowMend                            = Spell(186263),
  Silence                               = Spell(15487)
};
local S = RubimRH.Spell[258]

-- Items
if not Item.Priest then Item.Priest = {} end
Item.Priest.Shadow = {
  BattlePotionOfIntellect          = Item(163222)
};
local I = Item.Priest.Shadow;

-- Rotation Var
local ShouldReturn; -- Used to get the return string

-- Variables
local VarMindBlastTargets = 0;
local VarSwpTraitRanksCheck = 0;
local VarVtTraitRanksCheck = 0;
local VarVtMisTraitRanksCheck = 0;
local VarVtMisSdCheck = 0;
local VarDotsUp = 0;

S.MindbenderTalent = S.Mindbender

HL:RegisterForEvent(function()
  VarMindBlastTargets = 0
  VarSwpTraitRanksCheck = 0
  VarVtTraitRanksCheck = 0
  VarVtMisTraitRanksCheck = 0
  VarVtMisSdCheck = 0
  VarDotsUp = 0
end, "PLAYER_REGEN_ENABLED")

local EnemyRanges = {40}
local function UpdateRanges()
  for _, i in ipairs(EnemyRanges) do
    HL.GetEnemies(i);
  end
end


local function num(val)
  if val then return 1 else return 0 end
end

local function bool(val)
  return val ~= 0
end

local function InsanityThreshold()
	return S.LegacyOfTheVoid:IsAvailable() and 60 or 90;
end

local function ExecuteRange ()
	return 20;
end

-- SPvE AoE MultiDots as 2-10
local function SwitchTarget()
    if active_enemies() < 10 and CombatTime("player") > 0 and (not IsSpellInRange("target", 589) or (CombatTime("target") == 0)) and (MultiDots(40, 34914, 10, 1) >= 1) then
	    return 0, CacheGetSpellTexture(153911)
    end
end	



--- ======= ACTION LISTS =======
local function APL()
  local Precombat_DBM, Precombat, Cleave, Single, AutoDotCycle
  UpdateRanges()
  
    Precombat_DBM = function()
      -- potion
      --if I.BattlePotionofIntellect:IsReady() and RubimRH.UsePotions then
      --  return I.BattlePotionofIntellect:Cast()
      --end
      -- variable,name=mind_blast_targets,op=set,value=floor((4.5+azerite.whispers_of_the_damned.rank)%(1+0.27*azerite.searing_dialogue.rank))
      if (true) then
        VarMindBlastTargets = math.floor((4.5 + S.WhispersoftheDamned:AzeriteRank()) / (1 + 0.27 * S.SearingDialogue:AzeriteRank()))
      end
      -- variable,name=swp_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank+0.2*azerite.thought_harvester.rank)*(1-0.09*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
      if (true) then
        VarSwpTraitRanksCheck = (1 - 0.07 * S.DeathThroes:AzeriteRank() + 0.2 * S.ThoughtHarvester:AzeriteRank()) * (1 - 0.09 * S.ThoughtHarvester:AzeriteRank() * S.SearingDialogue:AzeriteRank())
      end
      -- variable,name=vt_trait_ranks_check,op=set,value=(1-0.04*azerite.thought_harvester.rank-0.05*azerite.spiteful_apparitions.rank)
      if (true) then
        VarVtTraitRanksCheck = (1 - 0.04 * S.ThoughtHarvester:AzeriteRank() - 0.05 * S.SpitefulApparitions:AzeriteRank())
      end
      -- variable,name=vt_mis_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank-0.03*azerite.thought_harvester.rank-0.055*azerite.spiteful_apparitions.rank)*(1-0.027*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
      if (true) then
        VarVtMisTraitRanksCheck = (1 - 0.07 * S.DeathThroes:AzeriteRank() - 0.03 * S.ThoughtHarvester:AzeriteRank() - 0.055 * S.SpitefulApparitions:AzeriteRank()) * (1 - 0.027 * S.ThoughtHarvester:AzeriteRank() * S.SearingDialogue:AzeriteRank())
      end
      -- variable,name=vt_mis_sd_check,op=set,value=1-0.014*azerite.searing_dialogue.rank
      if (true) then
        VarVtMisSdCheck = 1 - 0.014 * S.SearingDialogue:AzeriteRank()
      end
      -- Mindbender management
      --S.Mindbender = S.MindbenderTalent:IsAvailable() and S.MindbenderTalent or S.Shadowfiend
      -- shadowform,if=!buff.shadowform.up
	  
      if S.Shadowform:IsCastableP() and Player:BuffDownP(S.ShadowformBuff) and (not Player:BuffP(S.ShadowformBuff)) then
        return S.Shadowform:Cast() 
      end
	   -- pre potion mind blast
      if I.BattlePotionOfIntellect:IsReady() and not S.ShadowWordVoid:IsAvailable() and RubimRH.DBM_PullTimer() > S.MindBlast:CastTime() + 1 and RubimRH.DBM_PullTimer() <= S.MindBlast:CastTime() + 2 then
        return 967532
      end
	    -- pre potion shadow word void
      if I.BattlePotionOfIntellect:IsReady() and S.ShadowWordVoid:IsAvailable() and RubimRH.DBM_PullTimer() > S.ShadowWordVoid:CastTime() + 1 and RubimRH.DBM_PullTimer() <= S.ShadowWordVoid:CastTime() + 2 then
        return 967532
      end
      -- mind_blast,if=spell_targets.mind_sear<2|azerite.thought_harvester.rank=0
      if S.MindBlast:IsCastableP() and RubimRH.DBM_PullTimer() > 0.1 and RubimRH.DBM_PullTimer() <= S.MindBlast:CastTime() and (Cache.EnemiesCount[40] < 2 or S.ThoughtHarvester:AzeriteRank() == 0) and not Player:IsCasting(S.MindBlast)  then
        return S.MindBlast:Cast() 
      end
      -- shadow_word_void (added)
      if S.ShadowWordVoid:IsCastableP() and RubimRH.DBM_PullTimer() > 0.1 and RubimRH.DBM_PullTimer() <= S.ShadowWordVoid:CastTime() and (Cache.EnemiesCount[40] < 2 or S.ThoughtHarvester:AzeriteRank() == 0) and not Player:IsCasting(S.ShadowWordVoid) then
        return S.ShadowWordVoid:Cast() 
      end

  end
  
  
  Precombat = function()
      -- potion
      --if I.BattlePotionofIntellect:IsReady() and RubimRH.UsePotions then
      --  return I.BattlePotionofIntellect:Cast()
      --end
      -- variable,name=mind_blast_targets,op=set,value=floor((4.5+azerite.whispers_of_the_damned.rank)%(1+0.27*azerite.searing_dialogue.rank))
      if (true) then
        VarMindBlastTargets = math.floor((4.5 + S.WhispersoftheDamned:AzeriteRank()) / (1 + 0.27 * S.SearingDialogue:AzeriteRank()))
      end
      -- variable,name=swp_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank+0.2*azerite.thought_harvester.rank)*(1-0.09*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
      if (true) then
        VarSwpTraitRanksCheck = (1 - 0.07 * S.DeathThroes:AzeriteRank() + 0.2 * S.ThoughtHarvester:AzeriteRank()) * (1 - 0.09 * S.ThoughtHarvester:AzeriteRank() * S.SearingDialogue:AzeriteRank())
      end
      -- variable,name=vt_trait_ranks_check,op=set,value=(1-0.04*azerite.thought_harvester.rank-0.05*azerite.spiteful_apparitions.rank)
      if (true) then
        VarVtTraitRanksCheck = (1 - 0.04 * S.ThoughtHarvester:AzeriteRank() - 0.05 * S.SpitefulApparitions:AzeriteRank())
      end
      -- variable,name=vt_mis_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank-0.03*azerite.thought_harvester.rank-0.055*azerite.spiteful_apparitions.rank)*(1-0.027*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
      if (true) then
        VarVtMisTraitRanksCheck = (1 - 0.07 * S.DeathThroes:AzeriteRank() - 0.03 * S.ThoughtHarvester:AzeriteRank() - 0.055 * S.SpitefulApparitions:AzeriteRank()) * (1 - 0.027 * S.ThoughtHarvester:AzeriteRank() * S.SearingDialogue:AzeriteRank())
      end
      -- variable,name=vt_mis_sd_check,op=set,value=1-0.014*azerite.searing_dialogue.rank
      if (true) then
        VarVtMisSdCheck = 1 - 0.014 * S.SearingDialogue:AzeriteRank()
      end
      -- Mindbender management
      --S.Mindbender = S.MindbenderTalent:IsAvailable() and S.MindbenderTalent or S.Shadowfiend
      -- shadowform,if=!buff.shadowform.up
      if S.Shadowform:IsCastableP() and Player:BuffDownP(S.ShadowformBuff) and (not Player:BuffP(S.ShadowformBuff)) then
        return S.Shadowform:Cast() 
      end
      -- mind_blast,if=spell_targets.mind_sear<2|azerite.thought_harvester.rank=0
      if S.MindBlast:IsCastableP() and (Cache.EnemiesCount[40] < 2 or S.ThoughtHarvester:AzeriteRank() == 0) and not Player:IsCasting(S.MindBlast) then
        return S.MindBlast:Cast() 
      end
      -- shadow_word_void (added)
      if S.ShadowWordVoid:IsCastableP() and (Cache.EnemiesCount[40] < 2 or S.ThoughtHarvester:AzeriteRank() == 0) and not Player:IsCasting(S.ShadowWordVoid) then
        return S.ShadowWordVoid:Cast() 
      end
      -- vampiric_touch
      if S.VampiricTouch:IsCastableP() and Player:DebuffDownP(S.VampiricTouchDebuff) and not Player:IsCasting(S.VampiricTouch) then
        return S.VampiricTouch:Cast() 
      end
  end
  
  Cleave = function()
    -- void_eruption
    if S.VoidEruption:IsCastableP() and Player:Insanity() >= InsanityThreshold() and not Player:IsCasting(S.VoidEruption) then
      return S.VoidEruption:Cast() 
    end
    -- dark_ascension,if=buff.voidform.down
    if S.DarkAscension:IsCastableP() and (Player:BuffDownP(S.VoidformBuff)) and not Player:IsCasting(S.VoidEruption) then
      return S.DarkAscension:Cast() 
    end
    -- vampiric_touch,if=!ticking&azerite.thought_harvester.rank>=1
    if S.VampiricTouch:IsCastableP() and (not Target:DebuffP(S.VampiricTouchDebuff) and S.ThoughtHarvester:AzeriteRank() >= 1) and not Player:IsCasting(S.VampiricTouch) then
      return S.VampiricTouch:Cast() 
    end
    -- mind_sear,if=buff.harvested_thoughts.up
    if S.MindSear:IsCastableP() and Player:BuffP(S.HarvestedThoughtsBuff) then
      return S.MindSear:Cast() 
    end
    -- void_bolt
    if (Player:BuffP(S.VoidformBuff) and S.VoidBolt:CooldownRemainsP() < 0.2) or Player:IsCasting(S.VoidEruption) then
      return S.VoidBolt:Cast()
    end
    -- shadow_word_death,target_if=target.time_to_die<3|buff.voidform.down
    if S.ShadowWordDeath:IsCastableP() and (Target:TimeToDie() < 3 or Player:BuffDownP(S.VoidformBuff)) and (Target:HealthPercentage() < ExecuteRange ()) then
      return S.ShadowWordDeath:Cast() 
    end
    -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
    if S.SurrenderToMadness:IsCastableP() and (Player:BuffStackP(S.VoidformBuff) > 10 + (10 * num(Player:HasHeroism()))) then
      return S.SurrenderToMadness:Cast()
    end
    -- dark_void,if=raid_event.adds.in>10&(dot.shadow_word_pain.refreshable|target.time_to_die>30)
    if S.DarkVoid:IsCastableP() and (Target:DebuffRefreshableCP(S.ShadowWordPainDebuff) or Target:TimeToDie() > 30) and not Player:IsCasting(S.DarkVoid) then
      return S.DarkVoid:Cast() 
    end
    -- mindbender
    if S.Mindbender:IsReadyP() and S.MindbenderTalent:IsAvailable() then
      return S.Mindbender:Cast()
    end
	-- shadowfiend
    if S.Shadowfiend:IsReadyP() and RubimRH.CDsON() then
      return S.Shadowfiend:Cast()
    end
    -- mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
    if S.MindBlast:IsCastableP() and not Player:IsCasting(S.MindBlast) and Cache.EnemiesCount[40] < VarMindBlastTargets then
      return S.MindBlast:Cast()
    end
    -- shadow_word_void (added)
    if S.ShadowWordVoid:IsCastableP() and Cache.EnemiesCount[40] < VarMindBlastTargets and not (Player:IsCasting(S.ShadowWordVoid) and S.ShadowWordVoid:ChargesP() == 1) then
      return S.ShadowWordVoid:Cast()
    end
    -- shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
    if S.ShadowCrash:IsCastableP() and not Player:IsCasting(S.ShadowCrash) then
      return S.ShadowCrash:Cast() 
    end
    -- shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
    if S.ShadowWordPain:IsCastableP() and (Target:DebuffRefreshableCP(S.ShadowWordPainDebuff) and Target:TimeToDie() > ((num(true) - 1.2 + 3.3 * Cache.EnemiesCount[40]) * VarSwpTraitRanksCheck * (1 - 0.012 * S.SearingDialogue:AzeriteRank() * Cache.EnemiesCount[40]))) and (not S.Misery:IsAvailable()) then
      return S.ShadowWordPain:Cast() 
    end
    -- vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
    if S.VampiricTouch:IsCastableP() and not Player:IsCasting(S.VampiricTouch) and (Target:DebuffRefreshableCP(S.VampiricTouchDebuff)) and (Target:TimeToDie() > ((1 + 3.3 * Cache.EnemiesCount[40]) * VarVtTraitRanksCheck * (1 + 0.10 * S.SearingDialogue:AzeriteRank() * Cache.EnemiesCount[40]))) then
      return S.VampiricTouch:Cast() 
    end
    -- vampiric_touch,target_if=dot.shadow_word_pain.refreshable,if=(talent.misery.enabled&target.time_to_die>((1.0+2.0*spell_targets.mind_sear)*variable.vt_mis_trait_ranks_check*(variable.vt_mis_sd_check*spell_targets.mind_sear)))
    if S.VampiricTouch:IsCastableP() and not Player:IsCasting(S.VampiricTouch) and (Target:DebuffRefreshableCP(S.ShadowWordPainDebuff)) and ((S.Misery:IsAvailable() and Target:TimeToDie() > ((1.0 + 2.0 * Cache.EnemiesCount[40]) * VarVtMisTraitRanksCheck * (VarVtMisSdCheck * Cache.EnemiesCount[40])))) then
      return S.VampiricTouch:Cast()
    end
    -- void_torrent,if=buff.voidform.up
    if S.VoidTorrent:IsCastableP() and (Player:BuffP(S.VoidformBuff)) and not Player:IsCasting(S.VoidTorrent) then
      return S.VoidTorrent:Cast()
    end
    -- mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    if S.MindSear:IsCastableP() and active_enemies() > 1 then
      return S.MindSear:Cast()
    end
    -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
   -- if S.MindFlay:IsCastableP() and not S.VoidBolt:IsCastable() then
   --   return S.MindFlay:Cast()
  --  end
    -- shadow_word_pain
    --if S.ShadowWordPain:IsCastableP() then
    --  return S.ShadowWordPain:Cast()
    --end
  end
  
  -- Auto switch target function
  --AutoDotCycle = function()
  --  if S.VampiricTouch:IsCastableP() and S.ShadowWordPain:IsCastableP() then
  --      if Target:DebuffRemainsP(S.VampiricTouchDebuff) >= 17 and Target:DebuffRemainsP(S.ShadowWordPainDebuff) >= 13 then
--			return 0, CacheGetSpellTexture(153911)     
--		end		
--	end
 --- end
  
  Single = function()
    -- void_eruption
    if S.VoidEruption:IsCastableP() and Player:Insanity() >= InsanityThreshold() and not Player:IsCasting(S.VoidEruption) then
      return S.VoidEruption:Cast()
    end
    -- dark_ascension,if=buff.voidform.down
    if S.DarkAscension:IsCastableP() and (Player:BuffDownP(S.VoidformBuff)) and not Player:IsCasting(S.VoidEruption) then
      return S.DarkAscension:Cast()
    end
    -- void_bolt
    if (Player:BuffP(S.VoidformBuff) and S.VoidBolt:CooldownRemainsP() < 0.2) or Player:IsCasting(S.VoidEruption) then
      return S.VoidBolt:Cast()
    end
    -- mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
   -- if S.MindSear:IsCastableP() and Player:BuffP(S.HarvestedThoughtsBuff) and S.VoidBolt:CooldownRemainsP() >= 1.5 and S.SearingDialogue:AzeriteRank() >= 1 then
   --   return S.MindSear:Cast()
   -- end
    -- shadow_word_death,if=target.time_to_die<3|cooldown.shadow_word_death.charges=2|(cooldown.shadow_word_death.charges=1&cooldown.shadow_word_death.remains<gcd.max)
    if S.ShadowWordDeath:IsCastableP() and (Target:TimeToDie() < 3 or S.ShadowWordDeath:ChargesP() == 2 or (S.ShadowWordDeath:ChargesP() == 1 and S.ShadowWordDeath:CooldownRemainsP() < Player:GCD())) and Target:HealthPercentage() < ExecuteRange () then
      return S.ShadowWordDeath:Cast()
    end
    -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
    if S.SurrenderToMadness:IsCastableP() and (Player:BuffStackP(S.VoidformBuff) > 10 + (10 * num(Player:HasHeroism()))) then
      return S.SurrenderToMadness:Cast() 
    end
    -- dark_void,if=raid_event.adds.in>10
    if S.DarkVoid:IsCastableP() then
      return S.DarkVoid:Cast()
    end
	-- mindbender,if=talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
    if S.Mindbender:IsReadyP() and S.MindbenderTalent:IsAvailable() or (S.Mindbender:IsReadyP() and (Player:BuffStackP(S.VoidformBuff) > 18 or Target:TimeToDie() < 15)) then
      return S.Mindbender:Cast()
    end
	-- shadowfiend,if=!talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
    if S.Shadowfiend:IsReadyP() and RubimRH.CDsON() or (RubimRH.CDsON() and S.Shadowfiend:IsReadyP() and (Player:BuffStackP(S.VoidformBuff) > 18))  then
      return S.Shadowfiend:Cast()
    end
    -- shadow_word_death,if=!buff.voidform.up|(cooldown.shadow_word_death.charges=2&buff.voidform.stack<15)
    if S.ShadowWordDeath:IsCastableP() and (not Player:BuffP(S.VoidformBuff) or (S.ShadowWordDeath:ChargesP() == 2 and Player:BuffStackP(S.VoidformBuff) < 15)) and Target:HealthPercentage() < ExecuteRange () then
      return S.ShadowWordDeath:Cast()
    end
    -- shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
    if S.ShadowCrash:IsCastableP() and not Player:IsCasting(S.ShadowCrash) then
      return S.ShadowCrash:Cast()
    end
    -- mind_blast,if=variable.dots_up&((raid_event.movement.in>cast_time+0.5&raid_event.movement.in<4)|!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
    if S.MindBlast:IsCastableP() and (bool(VarDotsUp) and (not S.ShadowWordVoid:IsAvailable() or Player:BuffDownP(S.VoidformBuff) or Player:BuffStackP(S.VoidformBuff) > 14 and (Player:Insanity() < 70 or S.MindBlast:ChargesFractionalP() > 1.33) or Player:BuffStackP(S.VoidformBuff) <= 14 and (Player:Insanity() < 60 or S.MindBlast:ChargesFractionalP() > 1.33))) and not Player:IsCasting(S.MindBlast) then
      return S.MindBlast:Cast()
    end
    -- shadow_word_void (added)
    if S.ShadowWordVoid:IsCastableP() and bool(VarDotsUp) and not Player:IsCasting(S.ShadowWordVoid) then
      return S.ShadowWordVoid:Cast()
    end
    -- void_torrent,if=dot.shadow_word_pain.remains>4&dot.vampiric_touch.remains>4&buff.voidform.up
    if S.VoidTorrent:IsCastableP() and Target:DebuffRemainsP(S.ShadowWordPainDebuff) > 4 and Target:DebuffRemainsP(S.VampiricTouchDebuff) > 4 and Player:BuffP(S.VoidformBuff) then
      return S.VoidTorrent:Cast()
    end
    -- shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
    if S.ShadowWordPain:IsCastableP() and Target:DebuffRefreshableCP(S.ShadowWordPainDebuff) and Target:TimeToDie() > 4 and not S.Misery:IsAvailable() and not S.DarkVoid:IsAvailable() then
      return S.ShadowWordPain:Cast()
    end
    -- vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
    if S.VampiricTouch:IsCastableP() and not Player:IsCasting(S.VampiricTouch) and Target:DebuffRefreshableCP(S.VampiricTouchDebuff) and Target:TimeToDie() > 6 or (S.Misery:IsAvailable() and Target:DebuffRefreshableCP(S.ShadowWordPainDebuff)) and not Player:IsCasting(S.VampiricTouch) then
      return S.VampiricTouch:Cast()
    end
    -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
    if S.MindFlay:IsCastableP() then
      return S.MindFlay:Cast()
    end
    -- shadow_word_pain
    --if S.ShadowWordPain:IsCastableP() then
    --  return S.ShadowWordPain:Cast()
    --end
  end
  
      -- call DBM precombat
	if not Player:AffectingCombat() and RubimRH.PrecombatON() and RubimRH.PerfectPullON() and not Player:IsCasting() then
        return Precombat_DBM()
	end
    -- call non DBM precombat
	if not Player:AffectingCombat() and RubimRH.PrecombatON() and not RubimRH.PerfectPullON() and not Player:IsCasting() then		
        return Precombat()
	end
  
  	--if Player:IsChanneling() then
    --    return 0, 236353
	--end
  
  if RubimRH.TargetIsValid() then
    -- use_item,slot=trinket2
    -- potion,if=buff.bloodlust.react|target.time_to_die<=80|target.health.pct<35
    --if I.BattlePotionofIntellect:IsReady() and Settings.Commons.UsePotions and (Player:HasHeroism() or Target:TimeToDie() <= 80 or Target:HealthPercentage() < 35) then
    --  return I.BattlePotionofIntellect:Cast() "battle_potion_of_intellect 283"; end
    --end
	-- void_bolt
	if Player:BuffP(S.VoidformBuff) and S.VoidBolt:CooldownRemainsP() < 0.2 then
      return S.VoidBolt:Cast()
    end
    -- variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
    if (true) then
      VarDotsUp = num(Target:DebuffP(S.ShadowWordPainDebuff) and Target:DebuffP(S.VampiricTouchDebuff))
    end
	-- auto switch to next target
    if (MultiDots(40, S.VampiricTouch, 10, 1) >= 1) and RubimRH.AoEON() and active_enemies() >= 2 and Target:DebuffRemainsP(S.ShadowWordPainDebuff) > S.ShadowWordPain:BaseDuration() * 0.75 and Target:DebuffRemainsP(S.VampiricTouchDebuff) > S.VampiricTouch:BaseDuration() * 0.75 then
        return 133015 
    end
    -- SwitchTarget()
    -- Silence
    if S.Silence:IsCastableP() and RubimRH.InterruptsON() and Target:IsInterruptible() then
      return S.Silence:Cast()
    end	
	-- Dispersion
    if S.Dispersion:IsCastableP() and Player:HealthPercentage() <= RubimRH.db.profile[258].sk1 then
        return S.Dispersion:Cast()
    end
    -- ShadowMend
    if S.ShadowMend:IsCastableP() and Player:HealthPercentage() <= RubimRH.db.profile[258].sk2 then
        return S.ShadowMend:Cast()
    end
    -- berserking
    if S.Berserking:IsCastableP() and RubimRH.CDsON() then
      return S.Berserking:Cast()
    end
	-- run_action_list,name=cleave,if=active_enemies>1
    if active_enemies() > 1 and RubimRH.AoEON() then
      return Cleave();
    end
	-- run_action_list,name=single,if=active_enemies=1
    if active_enemies() < 2 or not RubimRH.AoEON() then
      return Single();
    end
  end
  return 0, 135328
end   

RubimRH.Rotation.SetAPL(258, APL)

local function PASSIVE()
	--print(MultiDots(40, S.VampiricTouch, 10, 1));
    return RubimRH.Shared()
end

RubimRH.Rotation.SetPASSIVE(258, PASSIVE)