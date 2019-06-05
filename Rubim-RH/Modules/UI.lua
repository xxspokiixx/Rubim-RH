local HL = HeroLib;
local Cache = HeroCache;
local StdUi = LibStub('StdUi')
local AceGUI = LibStub("AceGUI-3.0")


function AllMenu(selectedTab, point, relativeTo, relativePoint, xOfs, yOfs)
    local window = StdUi:Window(UIParent, 'Class Config', 450, 500);

    window:SetPoint('CENTER');
    
    if point ~= nil then
        window:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end

    local tabs = {
        {
            name = 'firstTab',
            title = 'General',
        },
        {
            name = 'secondTab',
            title = select(2, GetSpecializationInfo(GetSpecialization())),
        },
        {
            name = 'thirdTab',
            title = 'Spells',
        },
        {
            name = 'forthTab',
            title = 'Interrupt',
        },
        {
            name = 'fifthTab',
            title = 'System',
        },
        {
            name = 'sixthTab',
            title = 'Healer',
        },
       {
            name = 'seventhTab',
            title = 'MSG Actions',
        },
    }
    local tabFrame = StdUi:TabPanel(window, nil, nil, tabs);
    StdUi:GlueAcross(tabFrame, window, 10, -40, -10, 20);

    if selectedTab ~= nil then
        tabFrame:SelectTab(selectedTab)
    end

    tabFrame:EnumerateTabs(function(tab)
        if tab.title == "General" then
            local gn_title = StdUi:FontString(tab.frame, 'Interface');
            StdUi:GlueTop(gn_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(gn_separator, gn_title, 0, -12);

            local config1_0 = StdUi:Checkbox(tab.frame, 'Glow Action Bar');
            StdUi:GlueTop(config1_0, gn_separator, -100, -24, 'LEFT');
            config1_0:SetChecked(RubimRH.db.profile.mainOption.glowactionbar)
            function config1_0:OnValueChanged(self, state, value)
                RubimRH.GlowActionBarToggle()
            end

            local config1_1 = StdUi:Checkbox(tab.frame, 'Mute Sounds');
            StdUi:GlueTop(config1_1, gn_separator, 100, -24, 'RIGHT');
            config1_1:SetChecked(RubimRH.db.profile.mainOption.mute)
            function config1_1:OnValueChanged(self, state, value)
                RubimRH.MuteToggle()
            end

            local config2_0 = StdUi:Checkbox(tab.frame, 'Debug Verbose');
            StdUi:GlueTop(config2_0, config1_0, 0, -24, 'LEFT');
            config2_0:SetChecked(RubimRH.db.profile.mainOption.debug)
            function config2_0:OnValueChanged(self, state, value)
                RubimRH.DebugToggle()
            end

            local ic_title = StdUi:FontString(tab.frame, 'Icon');
            StdUi:GlueTop(ic_title, tab.frame, 0, -110);
            local ic_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(ic_separator, ic_title, 0, -12);

            local ic_1_0 = StdUi:Checkbox(tab.frame, 'Lock Icon');
            StdUi:GlueTop(ic_1_0, ic_separator, -100, -24, 'LEFT');
            ic_1_0:SetChecked(RubimRH.db.profile.mainOption.mainIconLock)
            function ic_1_0:OnValueChanged(self, state, value)
                RubimRH.MainIconLockToggle()
            end

            local ic_1_1 = StdUi:Checkbox(tab.frame, 'Enable Icon');
            StdUi:GlueTop(ic_1_1, ic_separator, 100, -24, 'RIGHT');
            ic_1_1:SetChecked(RubimRH.db.profile.mainOption.mainIcon)
            function ic_1_1:OnValueChanged(self, state, value)
                RubimRH.MainIconToggle()
            end

            local ic_2_0 = StdUi:Checkbox(tab.frame, 'Hide Texture');
            StdUi:GlueTop(ic_2_0, ic_1_0, 0, -24, 'LEFT');
            ic_2_0:SetChecked(RubimRH.db.profile.mainOption.hidetexture)
            function ic_2_0:OnValueChanged(self, state, value)
                RubimRH.HideTextureToggle()
            end

            local ic_2_1 = StdUi:Checkbox(tab.frame, 'Debug Verbose');
            StdUi:GlueTop(ic_2_1, ic_1_1, 0, -24, 'RIGHT');
            ic_2_1:SetChecked(RubimRH.db.profile.mainOption.glowactionbar)
            function ic_2_1:OnValueChanged(self, state, value)
                RubimRH.GlowActionBarToggle()
            end

            ic_2_1:Hide()

            local ic_3_0 = StdUi:Slider(tab.frame, 125, 16, RubimRH.db.profile.mainOption.mainIconOpacity, false, 0, 100)
            StdUi:GlueBelow(ic_3_0, ic_2_0, 0, -24, 'LEFT');
            local config3_1Label = StdUi:FontString(tab.frame, "Icon Opacity: " .. RubimRH.db.profile.mainOption.mainIconOpacity)
            StdUi:GlueTop(config3_1Label, ic_3_0, 0, 16);
            StdUi:FrameTooltip(ic_3_0, "Controls the opacity of the main icon", 'TOPLEFT', 'TOPRIGHT', true);
            function ic_3_0:OnValueChanged(value)
                value = (math.floor((value * ((100) + 0.5)) / (100)))
                RubimRH.db.profile.mainOption.mainIconOpacity = value
                ic_3_0 = value
                config3_1Label:SetText("Icon Opacity: " .. RubimRH.db.profile.mainOption.mainIconOpacity)
            end

            local ic_3_1 = StdUi:Slider(tab.frame, 125, 16, RubimRH.db.profile.mainOption.mainIconScale / 10, false, 5, 75)
            StdUi:GlueBelow(ic_3_1, ic_2_1, 0, -24, 'RIGT');
            local config3_1Label = StdUi:FontString(tab.frame, "Icon Size: " .. RubimRH.db.profile.mainOption.mainIconScale)
            StdUi:GlueTop(config3_1Label, ic_3_1, 0, 16);
            StdUi:FrameTooltip(ic_3_1, "Controls the opacity of the main icon", 'TOPLEFT', 'TOPRIGHT', true);
            function ic_3_1:OnValueChanged(value)
                local value = math.floor(value) * 10
                RubimRH.db.profile.mainOption.mainIconScale = value
                ic_3_1 = value
                config3_1Label:SetText("Icon Size: " .. RubimRH.db.profile.mainOption.mainIconScale)
            end

            local ex_title = StdUi:FontString(tab.frame, 'Extra');
            StdUi:GlueTop(ex_title, tab.frame, 0, -250);
            local ex_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(ex_separator, ex_title, 0, -12);

            local ex_title = StdUi:FontString(tab.frame, 'Keybind section was moved to the WoW Keybind interface.\nESC -> KEY BINDING > RUBIMRH');
            StdUi:GlueBelow(ex_title, ex_separator, 0, -25, "CENTER");


        end
        if tab.title == select(2, GetSpecializationInfo(GetSpecialization())) then
            local sk1 = RubimRH.db.profile[RubimRH.playerSpec].sk1 or -1
            local sk1id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk1id) or RubimRH.db.profile[RubimRH.playerSpec].sk1id or "") .. ": "
            local sk1tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk1tooltip or ""

            local sk2 = RubimRH.db.profile[RubimRH.playerSpec].sk2 or -1
            local sk2id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk2id) or RubimRH.db.profile[RubimRH.playerSpec].sk2id or "") .. ": "
            local sk2tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk2tooltip or ""

            local sk3 = RubimRH.db.profile[RubimRH.playerSpec].sk3 or -1
            local sk3id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk3id) or RubimRH.db.profile[RubimRH.playerSpec].sk3id or "") .. ": "
            local sk3tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk3tooltip or ""

            local sk4 = RubimRH.db.profile[RubimRH.playerSpec].sk4 or -1
            local sk4id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk4id) or RubimRH.db.profile[RubimRH.playerSpec].sk4id or "") .. ": "
            local sk4tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk4tooltip or ""

            local sk5 = RubimRH.db.profile[RubimRH.playerSpec].sk5 or -1
            local sk5id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk5id) or RubimRH.db.profile[RubimRH.playerSpec].sk5id or "") .. ": "
            local sk5tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk5tooltip or ""

            local sk6 = RubimRH.db.profile[RubimRH.playerSpec].sk6 or -1
            local sk6id = (GetSpellInfo(RubimRH.db.profile[RubimRH.playerSpec].sk6id) or RubimRH.db.profile[RubimRH.playerSpec].sk6id or "") .. ": "
            local sk6tooltip = RubimRH.db.profile[RubimRH.playerSpec].sk6tooltip or ""

            local windowHeight = 380
            local extraPosition = -280
            if sk3 >= 0 then
                windowHeight = 428
                extraPosition = -328
            end
            if sk6 >= 0 then
                windowHeight = 456
                extraPosition = -368
            end

            --local window = StdUi:Window(UIParent, select(2, UnitClass("player")) .. " - " .. select(2, GetSpecializationInfo(GetSpecialization())), 350, windowHeight);
            --window:SetPoint('CENTER');
            --if point ~= nil then
            --window:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
            --end

            local gn_title = StdUi:FontString(tab.frame, select(2, UnitClass("player")) .. " - " .. select(2, GetSpecializationInfo(GetSpecialization())));
            StdUi:GlueTop(gn_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(gn_separator, gn_title, 0, -12);

            local gn_1_0 = StdUi:Checkbox(tab.frame, 'Auto Suggest W/O Target');
            StdUi:FrameTooltip(gn_1_0, 'When you are in combat, it will suggest skills even without a target.', 'TOPLEFT', 'TOPRIGHT', true);
            gn_1_0:SetChecked(RubimRH.db.profile.mainOption.startattack)
            StdUi:GlueBelow(gn_1_0, gn_separator, -100, -8, 'LEFT');
            function gn_1_0:OnValueChanged(value)
                RubimRH.AttackToggle()
            end

            local trinketOptions = {
                { text = 'Trinket 1', value = 1 },
                { text = 'Trinket 2', value = 2 },
            }

            local gn_1_1 = StdUi:Dropdown(tab.frame, 125, 24, trinketOptions, nil, true);
            gn_1_1:SetPlaceholder(' -- Trinkets --');
            item1 = gn_1_1.optsFrame.scrollChild.items[1]
            item2 = gn_1_1.optsFrame.scrollChild.items[2]
            StdUi:GlueBelow(gn_1_1, gn_separator, 100, -8, 'RIGHT');
            gn_1_1.OnValueChanged = function(self, value)
                local option1, option2 = unpack(value)

                if option1 == 1 or option2 == 1 then
                    RubimRH.db.profile.mainOption.useTrinkets[1] = true
                end

                if option1 == 2 or option2 == 2 then
                    RubimRH.db.profile.mainOption.useTrinkets[2] = true
                end

            end;

            if RubimRH.db.profile.mainOption.useTrinkets[1] == true then
                gn_1_1:ToggleValue(1, true)
                gn_1_1.optsFrame.scrollChild.items[1]:SetChecked(true)
            end

            if RubimRH.db.profile.mainOption.useTrinkets[2] == true then
                gn_1_1:ToggleValue(2, true)
                gn_1_1.optsFrame.scrollChild.items[2]:SetChecked(true)
            end

            local gn_2_0 = StdUi:Checkbox(tab.frame, 'Perfect Pull');
            StdUi:FrameTooltip(gn_2_0, 'WIP Auto prepots & prepull from DBM Pull Timer', 'TOPLEFT', 'TOPRIGHT', true);
            gn_2_0:SetChecked(RubimRH.db.profile.mainOption.PerfectPull)
            StdUi:GlueBelow(gn_2_0, gn_1_0, 0, -15, 'LEFT');
            function gn_2_0:OnValueChanged(value)
                RubimRH.PerfectPull()
            end
            
            local gn_2_1 = StdUi:Slider(tab.frame, 125, 16, RubimRH.db.profile.mainOption.healthstoneper / 2.5, false, 0, 40)
            StdUi:GlueBelow(gn_2_1, gn_1_1, 0, -24, 'RIGHT');
            local gn_2_1Label = StdUi:FontString(tab.frame, 'Healthstone: |cff00ff00' .. RubimRH.db.profile.mainOption.healthstoneper);

            StdUi:GlueTop(gn_2_1Label, gn_2_1, 0, 16);
            StdUi:FrameTooltip(gn_2_1, 'Percent HP to use Healthstone.', 'TOPLEFT', 'TOPRIGHT', true);
            function gn_2_1:OnValueChanged(value)
                local value = math.floor(value) * 2.5
                RubimRH.db.profile.mainOption.healthstoneper = value
                gn_2_1Label:SetText('Healthstone: ' .. RubimRH.db.profile.mainOption.healthstoneper)
            end

            local gn_3_0 = StdUi:Checkbox(tab.frame, 'CD Mode: Burst');
            gn_3_0:SetChecked(RubimRH.db.profile.mainOption.burstCD)
            StdUi:FrameTooltip(gn_3_0, "This will make the CD to be turned off after 10 seconds.\n\nUseful if you want a Burst button.", 'TOPLEFT', 'TOPRIGHT', true);
            function gn_3_0:OnValueChanged(value)
                RubimRH.burstCDToggle()
            end

            StdUi:GlueBelow(gn_3_0, gn_2_0, 0, -15, 'LEFT');
            
            -- precombat toggle
            local gn_4_0 = StdUi:Checkbox(tab.frame, 'Auto Precombat');
            StdUi:FrameTooltip(gn_4_0, 'Activate prepull functions', 'TOPLEFT', 'TOPRIGHT', true);
            gn_4_0:SetChecked(RubimRH.db.profile.mainOption.Precombat)
            function gn_4_0:OnValueChanged(value)
                RubimRH.PrecombatToggle()
            end
            
            StdUi:GlueBelow(gn_4_0, gn_3_0, 0, -15, 'LEFT');

            
            local cdOptions = {
                { text = 'Everything', value = "Everything" },
                { text = 'Boss Only', value = "Boss Only" },
            }
            local gn_3_1 = StdUi:Dropdown(tab.frame, 125, 24, cdOptions, nil, nil);
            StdUi:FrameTooltip(gn_3_1, 'Everything - Every mob available\nBosses - Only Bosses or Rares', 'TOPLEFT', 'TOPRIGHT', true);
            gn_3_1:SetPlaceholder("|cfff0f8ffCD: |r" .. RubimRH.db.profile.mainOption.cooldownsUsage);
            gn_3_1.OnValueChanged = function(self, val)
                RubimRH.db.profile.mainOption.cooldownsUsage = val
                if val == "Everything" then
                    print("CDs will be used on every mob")
                else
                    print("CDs will only be used on Bosses/Rares")
                end
                gn_3_1:SetText("|cfff0f8ffCD: |r" .. RubimRH.db.profile.mainOption.cooldownsUsage);
            end
            StdUi:GlueBelow(gn_3_1, gn_2_1, 0, -24, 'RIGHT');

            --------------------------------------------------
            local sk_title = StdUi:FontString(tab.frame, 'Class Specific');
            StdUi:GlueTop(sk_title, tab.frame, 0, -190);
            local sk_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(sk_separator, sk_title, 0, -12);

            local sk_1_0
            if sk1 >= 0 then
                sk_1_0 = StdUi:Slider(tab.frame, 125, 16, sk1 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_1_0, sk_separator, -100, -24, 'LEFT');
                local sk_1_0Label = StdUi:FontString(tab.frame, sk1id .. sk1);
                StdUi:GlueTop(sk_1_0Label, sk_1_0, 0, 16);
                StdUi:FrameTooltip(sk_1_0, sk1tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_1_0:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk1 = value
                    sk1 = value
                    sk_1_0Label:SetText(sk1id .. sk1)
                end
            end

            local sk_1_1
            if sk2 >= 0 then
                sk_1_1 = StdUi:Slider(tab.frame, 125, 16, sk2 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_1_1, sk_separator, 100, -24, 'RIGHT');
                local sk_1_1Label = StdUi:FontString(tab.frame, sk2id .. sk2);
                StdUi:GlueTop(sk_1_1Label, sk_1_1, 0, 16);
                StdUi:FrameTooltip(sk_1_1, sk2tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_1_1:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk2 = value
                    sk2 = value
                    sk_1_1Label:SetText(sk2id .. sk2)
                end
            end

            local sk_2_0
            if sk3 >= 0 then
                sk_2_0 = StdUi:Slider(tab.frame, 125, 16, sk3 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_2_0, sk_1_0, 0, -24, 'LEFT');
                local sk_2_0Label = StdUi:FontString(tab.frame, sk3id .. sk3);
                StdUi:GlueTop(sk_2_0Label, sk_2_0, 0, 16);
                StdUi:FrameTooltip(sk_2_0, sk3tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_2_0:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk3 = value
                    sk3 = value
                    sk_2_0Label:SetText(sk3id .. sk3)
                end
            end

            --ROGUE Sub
            if RubimRH.playerSpec == Subtlety or RubimRH.playerSpec == Assassination or RubimRH.playerSpec == Outlaw then
                local sk_2_1 = StdUi:Checkbox(tab.frame, "Vanish Attack");
                sk_2_1:SetChecked(RubimRH.db.profile[RubimRH.playerSpec].vanishattack)
                StdUi:GlueBelow(sk_2_1, sk_1_1, 15, -24, 'RIGHT');
                function sk_2_1:OnValueChanged(value)
                    if RubimRH.db.profile[RubimRH.playerSpec].vanishattack then
                        RubimRH.db.profile[RubimRH.playerSpec].vanishattack = false
                    else
                        RubimRH.db.profile[RubimRH.playerSpec].vanishattack = true
                    end
                end
                
                -- Dice
                if RubimRH.playerSpec == Outlaw then
                local dice = {
                        { text = 'Simcraft', value = "Simcraft" },
                        { text = 'SoloMode', value = "SoloMode" },
                        { text = '1+ Buff', value = "1+ Buff" },
                        { text = 'Broadsides', value = "Broadsides" },
                        { text = 'Buried Treasure', value = "Buried Treasure" },
                        { text = 'Grand Melee', value = "Grand Melee" },
                        { text = 'Jolly Roger', value = "Jolly Roger" },
                        { text = 'Shark Infested Waters', value = "Shark Infested Waters" },
                        { text = 'Ture Bearing', value = "Ture Bearing" },
                        { text = 'Mythic +', value = "Mythic +" },
                    }
                    local diceRoll = StdUi:Dropdown(tab.frame, 125, 24, dice, nil, nil);
                    --StdUi:FrameTooltip(diceRoll, 'Everything - Every mob available\nBosses - Only Bosses or Rares', 'TOPLEFT', 'TOPRIGHT', true);
                    diceRoll:SetPlaceholder("|cfff0f8ffCD: |r" .. RubimRH.db.profile[RubimRH.playerSpec].dice);
                    diceRoll.OnValueChanged = function(self, val)
                    RubimRH.db.profile[RubimRH.playerSpec].dice = val

                    if val == "SoloMode" then
                         print("Dice profil set on SoloMode")
                    elseif val == "1+ Buff" then
                         print("Dice profil set on 1+ Buff")
                    elseif val == "Broadsides" then
                         print("Dice profil set on Broadsides")
                    elseif val == "Buried Treasure" then
                         print("Dice profil set on Buried Treasure")
                    elseif val == "Grand Melee" then
                         print("Dice profil set on Grand Melee")
                    elseif val == "Jolly Roger" then
                         print("Dice profil set on Jolly Roger")
                    elseif val == "Shark Infested Waters" then
                         print("Dice profil set on Shark Infested Waters")
                    elseif val == "Ture Bearing" then
                         print("Dice profil set on Ture Bearing")
                    elseif val == "Mythic +" then
                         print("Dice profil set on Mythic +")
                    else
                        print("Dice profil set on Simcraft")
                        diceRoll:SetText("|cfff0f8ffDice: |r" .. RubimRH.db.profile[RubimRH.playerSpec].dice);
                    end
                    end
                    StdUi:GlueBelow(diceRoll, sk_1_0, 0, -64, 'LEFT');
                end
            
            end
            
            
            

            
            
            --DESTRUCTION LOCK
                if RubimRH.playerSpec == Destruction then
                    local color = {
                        { text = 'Auto', value = 1 },
                        { text = 'Green', value = 2 },
                        { text = 'Orange', value = 3 },
                    };

                    local colorRoll = StdUi:Dropdown(tab.frame, 125, 24, color, 1);
                    StdUi:GlueBelow(colorRoll, sk_1_0, 0, -64, 'LEFT');
                    StdUi:AddLabel(tab.frame, colorRoll, 'Flames Color', 'TOP');
                    function colorRoll:OnValueChanged(value)
                        RubimRH.db.profile[RubimRH.playerSpec].color = self:GetText()
                        print("Flames Color set on: " .. RubimRH.db.profile[RubimRH.playerSpec].color)
                    end
                end
                
				-- ARCANE MAGE
                if RubimRH.playerSpec == Arcane then
                    local useSplashData = {
                        { text = 'Enabled', value = "Enabled" },
                        { text = 'Disabled', value = "Disabled" },
                    }
                    local choosedata = StdUi:Dropdown(tab.frame, 125, 24, useSplashData, nil, nil);
                    choosedata:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    StdUi:AddLabel(tab.frame, choosedata, 'Use Experimental Aoe Detection', 'TOP');
                    StdUi:FrameTooltip(choosedata, 'Use Combat Log to detect real numbers of enemies around your target', 'TOPLEFT', 'TOPRIGHT', true);                
                    
                    choosedata.OnValueChanged = function(self, val)
                    RubimRH.db.profile[RubimRH.playerSpec].useSplashData = val

                    if val == "Enabled" then
                        print("Experimental Aoe Detection Enabled")
                    else
                        print("Experimental Aoe Detection Disabled")
                        choosedata:SetText("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    end
                    end
                    StdUi:GlueBelow(choosedata, sk_1_0, 0, -64, 'LEFT');
                end
                
                
                -- SHAMAN ELEMENTAL
                if RubimRH.playerSpec == Elemental then
                    local useSplashData = {
                        { text = 'Enabled', value = "Enabled" },
                        { text = 'Disabled', value = "Disabled" },
                    }
                    local choosedata = StdUi:Dropdown(tab.frame, 125, 24, useSplashData, nil, nil);
                    choosedata:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    StdUi:AddLabel(tab.frame, choosedata, 'Use Experimental Aoe Detection', 'TOP');
                    StdUi:FrameTooltip(choosedata, 'Use Combat Log to detect real numbers of enemies around your target', 'TOPLEFT', 'TOPRIGHT', true);                
                    
                    choosedata.OnValueChanged = function(self, val)
                    RubimRH.db.profile[RubimRH.playerSpec].useSplashData = val

                    if val == "Enabled" then
                        print("Experimental Aoe Detection Enabled")
                    else
                        print("Experimental Aoe Detection Disabled")
                        choosedata:SetText("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    end
                    end
                    StdUi:GlueBelow(choosedata, sk_1_0, 0, -64, 'LEFT');
                end

                
                -- HUNTER MARKMANSHIP

                if RubimRH.playerSpec == Marksmanship then
                    local useSplashData = {
                        { text = 'Enabled', value = "Enabled" },
                        { text = 'Disabled', value = "Disabled" },
                    }
                    local choosedata = StdUi:Dropdown(tab.frame, 125, 24, useSplashData, nil, nil);
                    choosedata:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    StdUi:AddLabel(tab.frame, choosedata, 'Use Experimental Aoe Detection', 'TOP');
                    StdUi:FrameTooltip(choosedata, 'Use Combat Log to detect real numbers of enemies around your target', 'TOPLEFT', 'TOPRIGHT', true);                
                    
                    choosedata.OnValueChanged = function(self, val)
                    RubimRH.db.profile[RubimRH.playerSpec].useSplashData = val

                    if val == "Enabled" then
                        print("Experimental Aoe Detection Enabled")
                    else
                        print("Experimental Aoe Detection Disabled")
                        choosedata:SetText("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    end
                    end
                    StdUi:GlueBelow(choosedata, sk_1_0, 0, -64, 'LEFT');
                end
                
                -- HUNTER BEAST MASTER

                if RubimRH.playerSpec == BeastMastery then
                    local useSplashData = {
                        { text = 'Enabled', value = "Enabled" },
                        { text = 'Disabled', value = "Disabled" },
                    }
                    local choosedata = StdUi:Dropdown(tab.frame, 125, 24, useSplashData, nil, nil);
                    choosedata:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    StdUi:AddLabel(tab.frame, choosedata, 'Use Experimental Aoe Detection', 'TOP');
                    StdUi:FrameTooltip(choosedata, 'Use Combat Log to detect real numbers of enemies around your target', 'TOPLEFT', 'TOPRIGHT', true);                
                    
                    choosedata.OnValueChanged = function(self, val)
                    RubimRH.db.profile[RubimRH.playerSpec].useSplashData = val

                    if val == "Enabled" then
                        print("Experimental Aoe Detection Enabled")
                    else
                        print("Experimental Aoe Detection Disabled")
                        choosedata:SetText("|cfff0f8ff|r" .. RubimRH.db.profile[RubimRH.playerSpec].useSplashData);
                    end
                    end
                    StdUi:GlueBelow(choosedata, sk_1_0, 0, -64, 'LEFT');
                end
            

            local sk_2_1
            if sk4 >= 0 then
                sk_2_1 = StdUi:Slider(tab.frame, 125, 16, sk4 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_2_1, sk_1_1, 0, -24, 'RIGHT');
                local sk_2_1Label = StdUi:FontString(tab.frame, sk4id .. sk4);
                StdUi:GlueTop(sk_2_1Label, sk_2_1, 0, 16);
                StdUi:FrameTooltip(sk_2_1, sk4tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_2_1:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk4 = value
                    sk4 = value
                    sk_2_1Label:SetText(sk4id .. sk4)
                end

            end

            if sk5 >= 0 then
                local sk_3_0 = StdUi:Slider(tab.frame, 125, 16, sk5 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_3_0, sk_2_0, 0, -24, 'LEFT');
                local sk_3_0Label = StdUi:FontString(tab.frame, sk5id .. sk5);
                StdUi:GlueTop(sk_3_0Label, sk_3_0, 0, 16);
                StdUi:FrameTooltip(sk_3_0, sk5tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_3_0:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk5 = value
                    sk5 = value
                    sk_3_0Label:SetText(sk5id .. sk5)
                end
            end

            if sk6 >= 0 then
                local sk_3_1 = StdUi:Slider(tab.frame, 125, 16, sk6 / 2.5, false, 0, 40)
                StdUi:GlueBelow(sk_3_1, sk_2_1, 0, -24, 'RIGHT');
                local sk_3_1Label = StdUi:FontString(tab.frame, sk6id .. sk6);
                StdUi:GlueTop(sk_3_1Label, sk_3_1, 0, 16);
                StdUi:FrameTooltip(sk_3_1, sk6tooltip, 'TOPLEFT', 'TOPRIGHT', true);
                function sk_3_1:OnValueChanged(value)
                    local value = math.floor(value) * 2.5
                    RubimRH.db.profile[RubimRH.playerSpec].sk6 = value
                    sk6 = value
                    sk_3_1Label:SetText(sk6id .. sk6)
                end
            end

        end
        if tab.title == "Spells" then
            local spellBlocker_title = StdUi:FontString(tab.frame, 'Spell Blocker');
            StdUi:GlueTop(spellBlocker_title, tab.frame, 0, -10, 'CENTER');

            local function showTooltip(frame, show, spellId)
                if show then
                    GameTooltip:SetOwner(frame);
                    GameTooltip:SetPoint('RIGHT');
                    GameTooltip:SetSpellByID(spellId)
                else
                    GameTooltip:Hide();
                end

            end

            local data = {};
            local cols = {

                {
                    name = 'Enabled',
                    width = 60,
                    align = 'LEFT',
                    index = 'enabled',
                    format = 'string',
                    color = function(table, value, rowData, columnData)
                        if value == "True" then
                            return { r = 0, g = 1, b = 0, a = 1 }
                        end
                        if value == "False" then
                            return { r = 1, g = 0, b = 0, a = 1 }
                        end
                    end
                },

                {
                    name = 'Spell ID',
                    width = 60,
                    align = 'LEFT',
                    index = 'spellId',
                    format = 'number',
                    color = function(table, value)
                        --local x = value / 200000;
                        --return { r = x, g = 1 - x, b = 0, a = 1 };
                    end
                },
                {
                    name = 'Spell Name',
                    width = 160,
                    align = 'LEFT',
                    index = 'name',
                    format = 'string',
                },

                {
                    name = 'Icon',
                    width = 40,
                    align = 'LEFT',
                    index = 'icon',
                    format = 'icon',
                    sortable = false,
                    events = {
                        OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            local cellData = rowData[columnData.index];
                            showTooltip(cellFrame, true, rowData.spellId);
                            return false;
                        end,
                        OnLeave = function(rowFrame, cellFrame)
                            showTooltip(cellFrame, false);
                            return false;
                        end,
                    },
                },
            }

            local st = StdUi:ScrollTable(tab.frame, cols, 12, 20);
            st:EnableSelection(true);
            StdUi:GlueTop(st, tab.frame, 0, -60);

            local function addSpell(spellID)
                local name = nil;
                local icon, castTime, minRange, maxRange, spellId;

                name, _, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID);
                local enabled = "True"
                if RubimRH.db.profile.mainOption.disabledSpells[spellID] == true then
                    enabled = "False"
                end

                return {
                    enabled = enabled,
                    name = name,
                    icon = icon,
                    castTime = castTime,
                    minRange = minRange,
                    maxRange = maxRange,
                    spellId = spellId;
                };
            end

            local data = {};

            for key, spell in pairs(HeroCache.Persistent.SpellLearned.Player) do
                if IsPassiveSpell(key) == false then
                    tinsert(data, addSpell(key));
                end
            end

            for key, spell in pairs(HeroCache.Persistent.SpellLearned.Pet) do
                if IsPassiveSpell(key) == false then
                    tinsert(data, addSpell(key));
                end
            end

            -- update scroll table data
            st:SetData(data);

            local function btn_blockSpell()
                if data[st:GetSelection()] ~= nil then
                    local spellID = data[st:GetSelection()].spellId
                    if RubimRH.db.profile.mainOption.disabledSpells[spellID] ~= nil then
                        RubimRH.db.profile.mainOption.disabledSpells[spellID] = nil
                        data[st:GetSelection()].enabled = "True"
                        print("Removed: " .. GetSpellLink(spellID))
                    else
                        RubimRH.db.profile.mainOption.disabledSpells[spellID] = true
                        print("Added: " .. GetSpellLink(spellID))
                        data[st:GetSelection()].enabled = "False"
                    end
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    st:ClearSelection()
                    --window:Hide()
                    --local point, relativeTo, relativePoint, xOfs, yOfs = window:GetPoint()
                    --AllMenu("thirdTab", point, relativeTo, relativePoint, xOfs, yOfs)
                    --RubimRH.SpellBlocker(nil, point, relativeTo, relativePoint, xOfs, yOfs)
                    --

                    return
                end
                print("No Spell Selected")
            end

            local function btn_createMacro()
                if data[st:GetSelection()] ~= nil then
                    local SpellDATA = data[st:GetSelection()]
                    local SpellVAR = nil

                    for key, Spell in pairs(RubimRH.Spell[RubimRH.playerSpec]) do
                        if Spell:ID() == SpellDATA.spellId then
                            SpellVAR = key
                        end
                    end
                    RubimRH.print("Macro for: " .. GetSpellLink(SpellDATA.spellId) .. " was created. Check your Character Macros.")
                    CreateMacro(SpellDATA.name, SpellDATA.icon, "#showtooltip " .. GetSpellInfo(SpellDATA.spellId) .. "\n/run HeroLib.Spell(" .. tostring(SpellDATA.spellId) .. "):Queue()", 1)
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    st:ClearSelection()
                    return
                end
                print("No Spell Selected")
            end

            local btn = StdUi:Button(tab.frame, 125, 24, 'Block Spell');
            StdUi:GlueBelow(btn, st, 0, -24, "LEFT");
            btn:SetScript('OnClick', btn_blockSpell);
            StdUi:FrameTooltip(btn, 'This will block the spell from the spellist of the rotation aka it will never cast it.', 'TOPLEFT', 'TOPRIGHT', true);

            local btn2 = StdUi:Button(tab.frame, 125, 24, 'Create Macro');
            StdUi:GlueBelow(btn2, st, 0, -24, "RIGHT");
            btn2:SetScript('OnClick', btn_createMacro);
            StdUi:FrameTooltip(btn2, 'This will create a Queue macro :).', 'TOPLEFT', 'TOPRIGHT', true);

            --local blockingTip = StdUi:FontString(tab.frame, 'You can macro the spell blocker by using:\n/run RubimRH.SpellBlocker(spellID)');
            --StdUi:GlueTop(blockingTip, btn, 0, -30);
        end
        
        if tab.title == "Interrupt" then
            local interruptList_title = StdUi:FontString(tab.frame, 'Custom Interrupt');
            StdUi:GlueTop(interruptList_title, tab.frame, 0, -10, 'CENTER');

            local function showTooltip(frame, show, spellId)
                if show then
                    GameTooltip:SetOwner(frame);
                    GameTooltip:SetPoint('RIGHT');
                    GameTooltip:SetSpellByID(spellId)
                else
                    GameTooltip:Hide();
                end

            end
            local selectedSpell = {}
            local data = {};
            local cols = {

            {
                    name = 'Icon',
                    width = 40,
                    align = 'LEFT',
                    index = 'icon',
                    format = 'icon',
                    sortable = false,
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,

                        OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            local cellData = rowData[columnData.index];
                            showTooltip(cellFrame, true, rowData.spellId);
                            return false;
                        end,
                        OnLeave = function(rowFrame, cellFrame)
                            showTooltip(cellFrame, false);
                            return false;
                        end,
                    },
                },
            
                {
                    name = 'Spell ID',
                    width = 60,
                    align = 'LEFT',
                    index = 'spellId',
                    format = 'number',
                    color = function(table, value)
                        --local x = value / 200000;
                        --return { r = x, g = 1 - x, b = 0, a = 1 };
                    end,
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,
                    }
                },
                {
                    name = 'Spell Name',
                    width = 180,
                    align = 'LEFT',
                    index = 'name',
                    format = 'string',
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,
                    }
                },
                
                {
                    name = 'Zone',
                    width = 100,
                    align = 'LEFT',
                    index = 'zone',
                    format = 'string',
                    events = {
                        OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                            selectedSpell = rowData.spellId
                        end,
                    }
                },


            }    

            local st = StdUi:ScrollTable(tab.frame, cols, 5, 35);
            st:EnableSelection(true);
            StdUi:GlueTop(st, tab.frame, 2, -130);                
                        
            
            --  Custom profils interrupts v2 part 1               
            local interruptProfilschoice = {
                { text = 'Mythic+', value = "Mythic+" },
                { text = 'PvP', value = "PvP" },
                { text = 'Mixed PvE PvP', value = "Mixed PvE PvP" },
                { text = 'Custom', value = "Custom" },
            }
            local chooseprofil = StdUi:Dropdown(tab.frame, 100, 24, interruptProfilschoice, nil, nil);
                chooseprofil:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile.mainOption.activeList);
                StdUi:AddLabel(tab.frame, chooseprofil, 'Selected Profil', 'TOP');
                StdUi:FrameTooltip(chooseprofil, 'Choose between interrupts profils', 'TOPLEFT', 'TOPRIGHT', true);                
                --st:SetData(data);  
                --currentList = RubimRH.db.profile.mainOption.mythicList
                 chooseprofil.OnValueChanged = function(self, val)
                --RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice = val
                --local currentprofil = "Mythic+"
                --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mythicList
                --RubimRH.RefreshList()
                
                if val == "Mythic+" then
                    print("Interrupt profil set on Mythic+")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeList = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mythicList
                    currentList = RubimRH.db.profile.mainOption.mythicList
                    RubimRH.RefreshList()

                    
                elseif val == "PvP" then
                    print("Interrupt profil set on PvP")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeList = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.pvpList
                    currentList = RubimRH.db.profile.mainOption.pvpList
                    RubimRH.RefreshList()

                    
                elseif val == "Mixed PvE PvP" then
                    print("Interrupt profil set on Mixed PvE PvP")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeList = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mixedList
                    currentList = RubimRH.db.profile.mainOption.mixedList
                    RubimRH.RefreshList()
               
               elseif val == "Custom" then
                    print("Interrupt profil set on Custom")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeList = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mixedList
                    currentList = RubimRH.db.profile.mainOption.customList
                    RubimRH.RefreshList()
                else
                    print("An error as occured, no data :(")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.RefreshList()

                end
                return currentList
            end
            StdUi:GlueTop(chooseprofil, tab.frame, 10, -60, 'LEFT');    
            
            
            -- Custom profils interrupts part 2
            -- = ""

            
            local function addSpell(spellID)
                local name = nil;
                local icon, castTime, minRange, maxRange, spellId;

                name, _, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellID);

                return {
                    name = name,
                    icon = icon,
                    castTime = castTime,
                    minRange = minRange,
                    maxRange = maxRange,
                    spellId = spellId;
                };
            end

            local data = {};
            -- Checking for current list not nil
            if currentList ~= nil then 
                -- If currentList not nil insert currentList values
                for i, spell in pairs(currentList) do
                    table.insert(data, addSpell(i));
                end
            end

            -- update scroll table data
            st:SetData(data);

            local tempAddSpell = 0
            local function btn_addSpell()

                if not GetSpellInfo(tempAddSpell) then
                    return
                end

                if tempAddSpell ~= 0 and currentList[tempAddSpell] == nil then
                    currentList[tempAddSpell] = true
                end

                local data = {};
                for i, spell in pairs(currentList) do
                    table.insert(data, addSpell(i));
                end
                st:SetData(data);
            end

            function RubimRH.RefreshList()
                local data = {};
                for i, spell in pairs(currentList) do
                    table.insert(data, addSpell(i));
                end
                st:SetData(data);
                st:ClearSelection()
            end
            local function btn_delSpell()
                if selectedSpell ~= nil then
                    RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                    currentList[selectedSpell] = nil
                    selectedSpell = nil

                    local data = {};
                    for i, spell in pairs(currentList) do
                        table.insert(data, addSpell(i));
                    end
                    st:SetData(data);
                    st:ClearSelection()
                    return
                end
                print("No Spell Selected")
            end

            local btn = StdUi:Button(tab.frame, 125, 24, 'Add Spell');
            StdUi:GlueBelow(btn, st, 0, -24, "LEFT");
            btn:SetScript('OnClick', btn_addSpell);
            StdUi:FrameTooltip(btn, 'Add spell to the White or Black list.', 'TOPLEFT', 'TOPRIGHT', true);

            local btn_num = StdUi:NumericBox(tab.frame, 125, 24, 1);
            btn_num:SetMaxValue(9999999);
            btn_num:SetMinValue(0);
            StdUi:GlueBelow(btn_num, btn, 0, -20, 'LEFT');
            btn_num:SetScript("OnTextChanged", function(self, bool, value)
                showTooltip(self, true, self:GetNumber())
                tempAddSpell = self:GetNumber()
            end)

            btn_num:SetScript("OnEnterPressed", function(self, bool, value)
                showTooltip(self, false)
                tempAddSpell = self:GetNumber()
                btn_addSpell()
            end)

            local btn2 = StdUi:Button(tab.frame, 125, 24, 'Delete Spell');
            StdUi:GlueBelow(btn2, st, 0, -24, "RIGHT");
            btn2:SetScript('OnClick', btn_delSpell);
            StdUi:FrameTooltip(btn2, 'Delete a Spell.', 'TOPLEFT', 'TOPRIGHT', true);

            local whiteListOptions = {
                { text = 'Whitelist', value = "Whitelist" },
                { text = 'Blacklist', value = "Blacklist" },
            }

            local whiteListText = (RubimRH.db.profile.mainOption.whiteList == true and 'Whitelist' or 'Blacklist')

            local gn_2_1 = StdUi:Dropdown(tab.frame, 125, 20, whiteListOptions, nil, nil);
            gn_2_1:SetPlaceholder(whiteListText);
            gn_2_1.OnValueChanged = function(self, val)
                RubimRH.db.profile.mainOption.whiteList = (val == "Whitelist" and true or false)
                whiteListText = (RubimRH.db.profile.mainOption.whiteList == true and 'Whitelist' or 'Blacklist')
                gn_2_1:SetText(whiteListText);
            end
            StdUi:GlueBelow(gn_2_1, btn2, 0, -24, 'RIGHT');


            local ic_2_1 = StdUi:Checkbox(tab.frame, 'Whitelist');
            StdUi:GlueBelow(ic_2_1, btn2, 0, -24, 'RIGHT');
            ic_2_1:SetChecked(RubimRH.db.profile.mainOption.whiteList)
            function ic_2_1:OnValueChanged(self, state, value)
                if RubimRH.db.profile.mainOption.whiteList then
                    RubimRH.db.profile.mainOption.whiteList = false
                else
                    RubimRH.db.profile.mainOption.whiteList = true
                end
            end
        end
        
        if tab.title == "System" then
            local system_title = StdUi:FontString(tab.frame, 'System Configuration');
            StdUi:GlueTop(system_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(gn_separator, system_title, 0, -12);

            local system1_0 = StdUi:Checkbox(tab.frame, 'FPS Optimization');
            StdUi:GlueTop(system1_0, gn_separator, -100, -24, 'LEFT');
            system1_0:SetChecked(RubimRH.db.profile.mainOption.fps)
            StdUi:FrameTooltip(system1_0, 'Optimize your game settings for better FPS', 'TOPLEFT', 'TOPRIGHT', true);
            function system1_0:OnValueChanged(self, state, value)
                if RubimRH.db.profile.mainOption.fps then
                    RubimRH.db.profile.mainOption.fps = false
                else
                    RubimRH.db.profile.mainOption.fps = true
                end
            end

            local system1_1 = StdUi:Checkbox(tab.frame, 'LOS System');
            StdUi:GlueTop(system1_1, gn_separator, -100, -48, 'LEFT');
            system1_1:SetChecked(RubimRH.db.profile.mainOption.los)
            StdUi:FrameTooltip(system1_1, 'Activate LOS check System', 'TOPLEFT', 'TOPRIGHT', true);
            function system1_1:OnValueChanged(self, state, value)
                if RubimRH.db.profile.mainOption.los then
                    RubimRH.db.profile.mainOption.los = false
                else
                    RubimRH.db.profile.mainOption.los = true
                end
            end
            
            local system1_2 = StdUi:Checkbox(tab.frame, 'DBM System');
            StdUi:GlueTop(system1_2, gn_separator, -100, -72, 'LEFT');
            system1_2:SetChecked(RubimRH.db.profile.mainOption.dbm)
            StdUi:FrameTooltip(system1_2, 'Activate DBM Timers synchronization with your CD\'s', 'TOPLEFT', 'TOPRIGHT', true);
            function system1_2:OnValueChanged(self, state, value)
                if RubimRH.db.profile.mainOption.dbm then
                    RubimRH.db.profile.mainOption.dbm = false
                else
                    RubimRH.db.profile.mainOption.dbm = true
                end
            end


            --  Custom language switcher               
            local localesOptions = {
                { text = 'Français', value = "Français" },
                { text = 'English', value = "English" },
                { text = 'Pусский', value = "Pусский" },
            }
            local sys_lang = StdUi:Dropdown(tab.frame, 80, -24, localesOptions, nil, nil);
                sys_lang:SetPlaceholder("|cfff0f8ff|r" .. RubimRH.db.profile.mainOption.activeLanguage);
                StdUi:AddLabel(tab.frame, sys_lang, 'Selected Language', 'TOP');
                StdUi:FrameTooltip(sys_lang, 'Choose between languages', 'TOPLEFT', 'TOPRIGHT', true);                
                 sys_lang.OnValueChanged = function(self, val)

                
                if val == "Français" then
                    print("Langue définie sur Français")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeLanguage = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mythicList
                    --currentLanguage = RubimRH.db.profile.mainOption.french
                    --RubimRH.RefreshUI()

                    
                elseif val == "English" then
                    print("Language set on English")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeLanguage = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.pvpList
                    --currentLanguage = RubimRH.db.profile.mainOption.english
                    --RubimRH.RefreshUI()

                    
                elseif val == "Pусский" then
                    print("Язык установлен на русский")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    RubimRH.db.profile.mainOption.activeLanguage = val
                    --RubimRH.db.profile.mainOption.currentList = RubimRH.db.profile.mainOption.mixedList
                    --currentLanguage = RubimRH.db.profile.mainOption.russian
                    --RubimRH.RefreshUI()
                else
                    print("An error as occured, no data :(")
                    --currentprofil = RubimRH.db.profile[RubimRH.playerSpec].interruptProfilschoice
                    --RubimRH.RefreshUI()

                end
                --return currentLanguage
            end
            --StdUi:GlueTop(sys_lang, tab.frame, -100, -24, 'RIGHT');
            StdUi:GlueTop(sys_lang, gn_separator, 50, -68, 'RIGHT');
            
           -- local ic_title = StdUi:FontString(tab.frame, 'Icon');
           -- StdUi:GlueTop(ic_title, tab.frame, 0, -110);
            --local ic_separator = StdUi:FontString(tab.frame, '===================');
            --StdUi:GlueTop(ic_separator, ic_title, 0, -12);
            
            -- Color Picker mainframe
            local colortitle = StdUi:FontString(tab.frame, 'Main UI color :')
            StdUi:GlueTop(colortitle, system1_2, 0, -100, 'LEFT');			
            
            local r, g, b, a = RubimRH.db.profile.mainOption.mainframeColor_r, RubimRH.db.profile.mainOption.mainframeColor_g, RubimRH.db.profile.mainOption.mainframeColor_b, RubimRH.db.profile.mainOption.mainframeColor_a                         
            			
			window:SetBackdropColor(r, g, b, a)    
            local colorInput = StdUi:ColorInput(tab.frame, '', 40, 40, r, g, b, a);
            StdUi:FrameTooltip(colorInput, 'Click to open the color picker', 'TOPLEFT', 'TOPRIGHT', true);        
            --colorInput:GetColor('rgba')            
            StdUi:GlueTop(colorInput, system1_2, 72, -85, 'LEFT');
            --colorInput:SetColor(r, g, b, a)
            function colorInput:OnValueChanged(r, g, b, a)
                window:SetBackdropColor(r, g, b, a)                
                RubimRH.db.profile.mainOption.mainframeColor_r = r 
                RubimRH.db.profile.mainOption.mainframeColor_g = g 
                RubimRH.db.profile.mainOption.mainframeColor_b = b 
                RubimRH.db.profile.mainOption.mainframeColor_a = a 
            end
			
            --[[-- Color Picker text
            local colortitle2 = StdUi:FontString(tab.frame, 'Main UI color :')
            StdUi:GlueTop(colortitle2, system1_2, 0, -120, 'LEFT');
            
            local rr,gg,bb,aa = RubimRH.db.profile.mainOption.textColor_r,    RubimRH.db.profile.mainOption.textColor_g, RubimRH.db.profile.mainOption.textColor_b, RubimRH.db.profile.mainOption.textColor_a                         
            -- replace by text 
			--tabFrame:SetTextColor(rr, gg, bb, aa)
			tab.title:SetTextColor(rr, gg, bb, aa)
				window:SetTextColor(rr, gg, bb, aa)
			--window:SetBackdropColor(r, g, b, a)    
            local colorInputtext = StdUi:ColorInput(tab.frame, '', 40, 40, rr, gg, bb, aa);
            StdUi:FrameTooltip(colorInputtext, 'Click me to change the main UI color', 'TOPLEFT', 'TOPRIGHT', true);        
            --colorInput:GetColor('rgba')            
            StdUi:GlueTop(colorInputtext, system1_2, 72, -105, 'LEFT');
            --colorInput:SetColor(r, g, b, a)
            function colorInputtext:OnValueChanged(rr, gg, bb, aa)
                --replace by text
				tab.title:SetTextColor(rr, gg, bb, aa)
				--tabFrame:SetTextColor(rr, gg, bb, aa)
				window:SetTextColor(rr, gg, bb, aa)
				--SetTextColor
				--window:SetBackdropColor(r, g, b, a)                
                RubimRH.db.profile.mainOption.textColor_r = rr 
                RubimRH.db.profile.mainOption.textColor_g = gg 
                RubimRH.db.profile.mainOption.textColor_b = bb 
                RubimRH.db.profile.mainOption.textColor_a = aa 
            end]]--
			

			-- Load defaults settings
            local function Loaddefaults()
                -- default color ui
				optionsList = {system1_0,system1_1,system1_2}
				window:SetBackdropColor(0.06, 0.05, 0.03, 0.75)
				colorInput:SetColor(0.06, 0.05, 0.03, 0.75)
				for i=1, 3 do
				    if system1_0:GetChecked() ~= true then			
                        system1_0:SetChecked(RubimRH.db.profile.mainOption.fps)	
                    elseif system1_1:GetChecked() ~= true then					
				        system1_1:SetChecked(RubimRH.db.profile.mainOption.los)
				    elseif system1_2:GetChecked() ~= true then	
				       system1_2:SetChecked(RubimRH.db.profile.mainOption.dbm)                   	
                    else
                        print("All checks done")
                    end	
                end					
            end	
			
            local system1_3 = StdUi:Button(tab.frame, 80, 40, 'Load Defaults Settings');
            StdUi:GlueTop(system1_3, system1_2, 0, -40, 'LEFT');
            system1_3:SetScript('OnClick', Loaddefaults);

        end
        
        if tab.title == "Healer" then
            local heal_title = StdUi:FontString(tab.frame, 'Healer Options');
            StdUi:GlueTop(heal_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(heal_title, gn_separator, 0, -12);

            -- content here

        end
        
		-- MSG Addon things
        if tab.title == "MSG Actions" then
		
            local msg_title = StdUi:FontString(tab.frame, 'Action Message Macro');
            StdUi:GlueTop(msg_title, tab.frame, 0, -10);
            local gn_separator = StdUi:FontString(tab.frame, '===================');
            StdUi:GlueTop(gn_separator, msg_title, 0, -12);

			-- Leap of Faith macro
            local function btn_creategrip()
                RubimRH.print("Macro for Leap of Faith was created. Check your Character Macros and give the macro to your mate")
				CreateMacro("Leap of Faith","priest_spell_leapoffaith_a", "/script C_ChatInfo.SendAddonMessage(\"grip\", UnitName(\"player\"), \"RAID\")", 1)
                RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                --print("Macro creation worked")
            end     
            local btngrip = StdUi:Button(tab.frame, 120, 24, 'Create Grip Macro');
            --StdUi:GlueBelow(btngrip, tab.frame, 0, -24, "RIGHT");
			StdUi:GlueTop(btngrip, tab.frame, 10, -40, 'LEFT');
            btngrip:SetScript('OnClick', btn_creategrip);
            StdUi:FrameTooltip(btngrip, 'This will create a Leap of Faith macro to give to your mate :)', 'TOPLEFT', 'TOPRIGHT', true);

			-- Ironbark macro todo
            local function btn_createbark()
                RubimRH.print("Macro for Ironbark  was created. Check your Character Macros and give the macro to your mate")
				CreateMacro("Ironbark ","spell_druid_ironbark", "/script C_ChatInfo.SendAddonMessage(\"bark\", UnitName(\"player\"), \"RAID\")", 1)
                RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                --print("Macro creation worked")
            end     
            local btnbark = StdUi:Button(tab.frame, 120, 24, 'Create Bark Macro');
            --StdUi:GlueBelow(btngrip, tab.frame, 0, -24, "RIGHT");
			StdUi:GlueTop(btnbark, tab.frame, 10, -70, 'LEFT');
            btnbark:SetScript('OnClick', btn_createbark);
            StdUi:FrameTooltip(btnbark, 'This will create an Ironbark macro to give to your mate :)', 'TOPLEFT', 'TOPRIGHT', true);

			-- Priestt life swap macro todo
            local function btn_createswap()
                RubimRH.print("Macro for Void Shift was created. Check your Character Macros and give the macro to your mate")
				CreateMacro("Void Shift","spell_priest_voidshift", "/script C_ChatInfo.SendAddonMessage(\"swap\", UnitName(\"player\"), \"RAID\")", 1)
                RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                --print("Macro creation worked")
            end     
            local btnswap = StdUi:Button(tab.frame, 120, 24, 'Create Void Shift Macro');
            --StdUi:GlueBelow(btngrip, tab.frame, 0, -24, "RIGHT");
			StdUi:GlueTop(btnswap, tab.frame, 10, -100, 'LEFT');
            btnswap:SetScript('OnClick', btn_createswap);
            StdUi:FrameTooltip(btnswap, 'This will create a Void Shift macro to give to your mate :)', 'TOPLEFT', 'TOPRIGHT', true);

			-- Paladin bop macro todo
            local function btn_createbop()
                RubimRH.print("Macro for Blessing of Protection was created. Check your Character Macros and give the macro to your mate")
				CreateMacro("Blessing of Protection","spell_holy_sealofprotection", "/script C_ChatInfo.SendAddonMessage(\"bop\", UnitName(\"player\"), \"RAID\")", 1)
                RubimRH.playSoundR("Interface\\Addons\\Rubim-RH\\Media\\button.ogg")
                --print("Macro creation worked")
            end     
            local btnbop = StdUi:Button(tab.frame, 120, 24, 'Create Bop Macro');
            --StdUi:GlueBelow(btngrip, tab.frame, 0, -24, "RIGHT");
			StdUi:GlueTop(btnbop, tab.frame, 10, -130, 'LEFT');
            btnbop:SetScript('OnClick', btn_createbop);
            StdUi:FrameTooltip(btnbop, 'This will create a Blessing of Protection macro to give to your mate :)', 'TOPLEFT', 'TOPRIGHT', true);			
			

           -- end           
        end

    end);
end

function RubimRH.SpellBlocker(spellID, point, relativeTo, relativePoint, xOfs, yOfs)
    if spellID ~= nil then
        if RubimRH.db.profile.mainOption.disabledSpells[spellID] ~= nil then
            RubimRH.db.profile.mainOption.disabledSpells[spellID] = nil
            print("Removed: " .. GetSpellLink(spellID))
        else
            RubimRH.db.profile.mainOption.disabledSpells[spellID] = true
            print("Added: " .. GetSpellLink(spellID))
        end
        return
    end
end

function RubimRH.ClassConfig(specID)
    AllMenu('secondTab')
end
