
local o = TalentLinksDB1; if (o.SHOULD_LOAD == nil) then return; end

if (o.STATIC_DB ~= nil) then return; end
-- This database file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


-- The leading newline is important.
o.STATIC_DB = [[

2105~Abomination's Might2
1769~Absolution3
1997~Acclimation3
205~Adrenaline Rush1
982~Aftermath2
1122~Aggression5
1345~Aimed Shot1
1061~Amplify Curse1
2061~Ancestral Awakening3
581~Ancestral Healing3
614~Ancestral Knowledge5
137~Anger Management1
1799~Animal Handler2
2048~Annihilation3
2221~Anti-Magic Zone1
601~Anticipation3
1629~Anticipation5
138~Anticipation5
2218~Anticipation5
1847~Arcane Barrage1
75~Arcane Concentration5
1727~Arcane Empowerment3
1843~Arcane Flows2
76~Arcane Focus3
85~Arcane Fortitude3
421~Arcane Instability3
1142~Arcane Meditation3
77~Arcane Mind5
1725~Arcane Potency2
87~Arcane Power1
83~Arcane Shielding2
80~Arcane Stability5
74~Arcane Subtlety2
741~Arctic Reach2
1738~Arctic Winds5
1751~Ardent Defender5
2250~Armored to the Teeth3
2138~Aspect Mastery1
1894~Aspiration2
2050~Astral Shift3
1435~Aura Mastery1
1754~Avenger's Shield1
1888~Backdraft3
1817~Backlash3
1783~Balance of Power2
943~Bane5
1347~Barrage3
2192~Beacon of Light1
2139~Beast Mastery1
1407~Benediction5
1927~Berserk1
1390~Bestial Discipline2
1386~Bestial Wrath1
1973~Black Ice5
464~Blackout5
2017~Blade Barrier5
223~Blade Flurry1
1706~Blade Twisting2
1938~Bladed Armor5
1863~Bladestorm1
32~Blast Wave1
1731~Blazing Speed2
2198~Blessed Hands2
1744~Blessed Life3
1636~Blessed Recovery3
1765~Blessed Resilience3
1442~Blessing of Kings1
1431~Blessing of Sanctuary1
2060~Blessing of the Eternals2
1936~Blood Aura2
661~Blood Craze3
1664~Blood Frenzy2
2034~Blood Gorged5
2068~Blood Spatter2
2210~Blood of the North5
2004~Blood-Caked Blade3
1866~Bloodsurge3
167~Bloodthirst1
2128~Bloodthirsty1
1960~Bloodworms3
2015~Bloody Strikes3
1944~Bloody Vengeance3
2007~Bone Shield1
158~Booming Voice2
1202~Borrowed Time5
1854~Brain Freeze3
782~Brambles3
797~Brutal Impact2
2212~Burning Determination2
23~Burning Soul2
1851~Burnout5
1939~Butchery2
561~Call of Flame3
562~Call of Thunder1
244~Camouflage3
1806~Careful Aim3
941~Cataclysm3
1801~Catlike Reflexes3
784~Celestial Focus3
1891~Chaos Bolt1
1722~Cheat Death3
2033~Chilblains3
1981~Chill of the Grave2
1856~Chilled to the Bone5
2135~Chimera Shot1
1815~Circle of Healing1
2084~Cleanse Spirit1
182~Close Quarters Combat5
2118~Cobra Reflexes1
2137~Cobra Strikes3
280~Cold Blood2
72~Cold Snap1
1737~Cold as Ice2
1804~Combat Experience2
1753~Combat Expertise3
1825~Combat Potency5
36~Combustion1
154~Commanding Presence5
152~Concussion Blow1
563~Concussion5
1351~Concussive Barrage3
968~Conflagrate1
1669~Contagion5
564~Convection5
1411~Conviction5
1985~Corpse Explosion1
1312~Counterattack1
1893~Critical Block3
33~Critical Mass3
157~Cruelty5
1755~Crusade3
1823~Crusader Strike1
1962~Crypt Fever3
1081~Curse of Exhaustion1
2070~Cut to the Chase5
2246~Damage Shield2
1961~Dancing Rune Weapon1
1943~Dark Conviction5
1022~Dark Pact1
462~Darkness5
1723~Deadened Nerves3
1702~Deadliness5
2065~Deadly Brew2
2086~Death Rune Mastery3
165~Death Wish1
1875~Death's Embrace3
1980~Deathchill1
1857~Deep Freeze1
121~Deep Wounds3
1311~Deflection3
187~Deflection3
1403~Deflection5
130~Deflection5
1671~Demonic Aegis3
1225~Demonic Brutality3
1223~Demonic Embrace5
1884~Demonic Empathy3
1880~Demonic Empowerment1
1263~Demonic Knowledge3
1885~Demonic Pact5
983~Demonic Power2
1680~Demonic Resilience3
1281~Demonic Sacrifice1
1673~Demonic Tactics5
2226~Desecration5
442~Desperate Prayer1
964~Destructive Reach2
1666~Devastate1
981~Devastation1
2011~Dirge2
265~Dirty Deeds3
262~Dirty Tricks2
1910~Dispersion1
1895~Divine Aegis3
1433~Divine Favor1
1181~Divine Fury5
1630~Divine Guardian2
1747~Divine Illumination1
1449~Divine Intellect5
1905~Divine Providence5
1757~Divine Purpose2
351~Divine Spirit1
2150~Divine Storm1
2185~Divine Strength5
1735~Dragon's Breath1
1784~Dreamstate3
1692~Dual Wield Specialization3
221~Dual Wield Specialization5
1581~Dual Wield Specialization5
1690~Dual Wield1
1698~Earth Shield1
1928~Earth and Moon3
2101~Earth's Grasp2
2056~Earthen Power2
2043~Ebon Plaguebringer3
1924~Eclipse3
1342~Efficiency5
1645~Elemental Devastation3
574~Elemental Focus1
565~Elemental Fury5
573~Elemental Mastery1
2049~Elemental Oath2
1685~Elemental Precision3
1649~Elemental Precision3
1641~Elemental Reach2
1683~Elemental Shields3
1640~Elemental Warding3
611~Elemental Weapons3
247~Elusiveness3
966~Emberstorm5
1764~Empowered Corruption3
1734~Empowered Fire3
1740~Empowered Frostbolt2
1767~Empowered Healing5
2045~Empowered Imp3
1789~Empowered Rejuvenation5
1788~Empowered Touch2
1661~Endless Rage1
1971~Endless Winter2
1389~Endurance Training5
204~Endurance2
610~Enhancing Totems3
2191~Enlightened Judgements2
1772~Enlightenment5
155~Enrage5
1304~Entrapment3
1711~Enveloping Shadows3
1963~Epidemic2
1878~Eradication3
1876~Everlasting Affliction5
2145~Explosive Shot1
1812~Expose Weakness3
1632~Eye for an Eye2
1642~Eye of the Storm3
1759~Fanaticism5
1001~Fel Concentration3
1226~Fel Domination1
1883~Fel Synergy2
1242~Fel Vitality3
795~Feral Aggression5
804~Feral Charge1
799~Feral Instinct3
2058~Feral Spirit1
807~Feral Swiftness2
1800~Ferocious Inspiration3
796~Ferocity5
1393~Ferocity5
1848~Fiery Payback2
2079~Filthy Tricks2
1718~Find Weakness3
1853~Fingers of Frost2
35~Fire Power5
1890~Fire and Brimstone5
1849~Firestarter2
28~Flame Throwing2
1721~Fleet Footed3
602~Flurry5
156~Flurry5
2211~Focus Magic1
2197~Focused Aim3
2069~Focused Attacks3
1624~Focused Fire2
1695~Focused Mind3
1777~Focused Mind3
1771~Focused Power2
1660~Focused Rage3
1858~Focused Will3
1787~Force of Nature1
1006~Frailty2
1397~Frenzy5
1990~Frigid Dreadplate3
2029~Frost Aura2
66~Frost Channeling3
1975~Frost Strike1
70~Frost Warding2
38~Frostbite3
1736~Frozen Core3
1865~Furious Attacks2
822~Furor5
149~Gag Order2
1925~Gale Winds2
2238~Genesis5
303~Ghostly Strike1
828~Gift of Nature5
1916~Gift of the Earthmother5
2030~Glacier Rot2
1818~Go for the Throat2
1901~Grace2
1021~Grim Reach2
2194~Guarded by the Light2
1911~Guardian Spirit1
609~Guardian Totems2
1425~Guardian's Favor2
2040~Guile of Gorefiend3
2196~Hammer of the Righteous1
2041~Haunt1
1820~Hawk Eye3
410~Healing Focus2
587~Healing Focus3
1646~Healing Grace3
1444~Healing Light3
413~Healing Prayers2
1648~Healing Way3
1957~Heart Strike1
1464~Heart of the Crusader3
808~Heart of the Wild5
1701~Heightened Senses3
681~Hemorrhage1
1868~Heroic Fury1
1768~Holy Concentration3
1746~Holy Guidance5
1627~Holy Power5
1635~Holy Reach2
1430~Holy Shield1
1502~Holy Shock1
401~Holy Specialization5
2078~Honor Among Thieves3
1850~Hot Streak3
1989~Howling Blast1
2071~Hunger For Blood1
1999~Hungering Cold1
2228~Hunter vs. Wild3
2144~Hunting Party5
1954~Hysteria1
71~Ice Barrier1
62~Ice Floes3
73~Ice Shards3
2035~Icy Reach2
2042~Icy Talons5
69~Icy Veins1
34~Ignite5
1461~Illumination5
30~Impact3
662~Impale2
263~Improved Ambush2
1346~Improved Arcane Shot3
1382~Improved Aspect of the Hawk5
1381~Improved Aspect of the Monkey3
1821~Improved Barrage3
1541~Improved Berserker Rage2
1658~Improved Berserker Stance5
2248~Improved Blessing of Kings4
1401~Improved Blessing of Might2
1446~Improved Blessing of Wisdom2
1724~Improved Blink2
63~Improved Blizzard3
142~Improved Bloodrage2
1697~Improved Chain Heal2
126~Improved Charge2
166~Improved Cleave3
1450~Improved Concentration Aura3
1341~Improved Concussive Shot2
64~Improved Cone of Cold3
1003~Improved Corruption5
88~Improved Counterspell2
1284~Improved Curse of Agony2
1652~Improved Defensive Stance2
1882~Improved Demonic Tactics3
161~Improved Demoralizing Shout5
1422~Improved Devotion Aura3
151~Improved Disarm2
150~Improved Disciplines2
1770~Improved Divine Spirit2
1101~Improved Drain Soul2
2059~Improved Earth Shield2
1283~Improved Enslave Demon2
276~Improved Eviscerate3
1542~Improved Execute2
278~Improved Expose Armor2
1785~Improved Faerie Fire3
2205~Improved Fear2
1873~Improved Felhunter2
27~Improved Fire Blast2
567~Improved Fire Nova Totem2
26~Improved Fireball5
37~Improved Frostbolt5
605~Improved Ghost Wolf2
203~Improved Gouge3
1521~Improved Hammer of Justice3
129~Improved Hamstring3
586~Improved Healing Wave5
408~Improved Healing3
1224~Improved Health Funnel2
1221~Improved Healthstone2
124~Improved Heroic Strike3
1902~Improved Holy Concentration3
1668~Improved Howl of Terror2
1343~Improved Hunter's Mark3
2223~Improved Icy Talons1
2031~Improved Icy Touch3
961~Improved Immolate3
1222~Improved Imp3
346~Improved Inner Fire3
2239~Improved Insect Swarm3
134~Improved Intercept2
1631~Improved Judgements2
206~Improved Kick2
279~Improved Kidney Shot3
1443~Improved Lay on Hands2
1798~Improved Leader of the Pack2
1007~Improved Life Tap2
350~Improved Mana Burn2
1920~Improved Mangle3
821~Improved Mark of the Wild2
1385~Improved Mend Pet2
481~Improved Mind Blast5
763~Improved Moonfire2
1912~Improved Moonkin Form3
1824~Improved Mortal Strike3
131~Improved Overpower2
268~Improved Poisons5
344~Improved Power Word: Fortitude2
343~Improved Power Word: Shield3
542~Improved Psychic Scream2
825~Improved Regrowth5
589~Improved Reincarnation2
830~Improved Rejuvenation3
127~Improved Rend2
406~Improved Renew3
1405~Improved Retribution Aura2
147~Improved Revenge2
1625~Improved Revive Pet2
1501~Improved Righteous Fury3
1942~Improved Rune Tap3
25~Improved Scorch3
965~Improved Searing Pain3
944~Improved Shadow Bolt5
482~Improved Shadow Word: Pain2
1906~Improved Shadowform2
607~Improved Shields3
201~Improved Sinister Strike2
2233~Improved Slam2
1827~Improved Slice and Dice2
1889~Improved Soul Leech2
2247~Improved Spell Reflection2
2027~Improved Spirit Tap2
222~Improved Sprint2
2133~Improved Steady Shot3
1348~Improved Stings3
2054~Improved Stormstrike2
1243~Improved Succubus3
141~Improved Thunder Clap3
1623~Improved Tracking5
842~Improved Tranquility2
1930~Improved Tree of Life3
1638~Improved Vampiric Embrace2
1855~Improved Water Elemental3
583~Improved Water Shield3
1655~Improved Whirlwind2
1647~Improved Windfury Totem2
1305~Improved Wing Clip3
2005~Impurity5
1844~Incanter's Absorption3
1141~Incineration3
144~Incite3
1919~Infected Wounds3
2193~Infusion of Light2
245~Initiative3
348~Inner Focus1
788~Insect Swarm1
361~Inspiration3
1864~Intensify Rage3
985~Intensity2
829~Intensity3
1387~Intimidation1
2136~Invigoration2
641~Iron Will3
2200~Judgements of the Just2
2199~Judgements of the Pure5
1758~Judgements of the Wise3
1321~Killer Instinct3
2044~Killing Machine5
2076~Killing Spree1
2227~Kindred Spirits5
1921~King of the Jungle3
153~Last Stand1
2051~Lava Flows3
2249~Lava Lash1
809~Leader of the Pack1
1344~Lethal Shots5
269~Lethality5
2215~Lichborne1
1745~Light's Grace3
721~Lightning Mastery5
1686~Lightning Overload5
186~Lightning Reflexes5
1303~Lightning Reflexes5
1637~Lightwell1
1852~Living Bomb1
1922~Living Seed3
1797~Living Spirit3
1306~Lock and Load3
2140~Longevity3
1782~Lunar Guidance3
125~Mace Specialization5
184~Mace Specialization5
2057~Maelstrom Weapon5
1650~Magic Absorption2
82~Magic Attunement2
2009~Magic Suppression5
1667~Malediction3
270~Malice5
1681~Mana Feed3
590~Mana Tide Totem1
1796~Mangle1
1949~Mark of Blood1
2134~Marked for Death5
321~Martyrdom2
1261~Master Conjuror2
1244~Master Demonologist5
1807~Master Marksman5
1715~Master Poisoner3
1915~Master Shapeshifter2
1227~Master Summoner2
1813~Master Tactician5
241~Master of Deception4
1639~Master of Elements3
2085~Master of Ghouls1
1713~Master of Subtlety3
347~Meditation3
341~Mental Agility5
2083~Mental Dexterity3
1691~Mental Quickness3
1201~Mental Strength5
1993~Merciless Combat2
1886~Metamorphosis1
1958~Might of Mograine3
501~Mind Flay1
1728~Mind Mastery5
1781~Mind Melt2
1816~Misery3
2209~Missile Barrage5
1887~Molten Core3
1732~Molten Fury2
24~Molten Shields2
790~Moonfury3
783~Moonglow3
793~Moonkin Form1
1933~Morbidity3
1349~Mortal Shots5
135~Mortal Strike1
274~Murder2
1719~Mutilate2
1790~Natural Perfection3
2242~Natural Reaction3
826~Natural Shapeshifter3
824~Naturalist5
1696~Nature's Blessing3
823~Nature's Focus3
789~Nature's Grace3
1699~Nature's Guardian5
1822~Nature's Majesty2
764~Nature's Reach2
2240~Nature's Splendor1
591~Nature's Swiftness1
831~Nature's Swiftness1
2047~Necrosis5
2022~Nerves of Cold Steel3
1707~Nerves of Steel2
1679~Nether Protection3
1846~Netherwind Presence3
2225~Night of the Dead2
1002~Nightfall2
2141~Noxious Stings3
1792~Nurturing Instinct2
827~Omen of Clarity1
2039~On a Pale Horse2
702~One-Handed Weapon Specialization5
1429~One-Handed Weapon Specialization5
261~Opportunity2
2008~Outbreak3
281~Overkill1
1913~Owlkin Frenzy3
1774~Pain Suppression1
1909~Pain and Suffering3
2245~Pandemic3
1384~Pathfinding2
1897~Penance1
65~Permafrost3
160~Piercing Howl1
61~Piercing Ice3
2130~Piercing Shots3
1730~Playing with Fire3
2142~Point of No Escape2
132~Poleaxe Specialization5
322~Power Infusion1
1649~Precision3
1657~Precision3
181~Precision5
1795~Predatory Instincts3
803~Predatory Strikes3
381~Premeditation1
284~Preparation2
86~Presence of Mind1
2075~Prey on the Weak5
801~Primal Fury2
1914~Primal Precision2
1793~Primal Tenacity3
1726~Prismatic Cloak3
2241~Protector of the Pack3
1908~Psychic Horror2
146~Puncture3
277~Puncturing Wounds4
1742~Pure of Heart2
592~Purification5
1743~Purifying Power2
1634~Pursuit of Justice2
29~Pyroblast1
986~Pyroclasm2
1733~Pyromaniac3
1762~Quick Recovery3
2036~Rage of Rivendare5
1659~Rampage1
1362~Ranged Weapon Specialization5
1819~Rapid Killing2
2131~Rapid Recuperation2
1896~Rapture5
1934~Ravenous Dead3
1353~Readiness1
2001~Reaping3
1426~Reckoning5
1421~Redoubt3
1773~Reflective Shield3
2244~Relentless Strikes5
272~Remorseless Attacks3
1918~Rend and Tear5
2235~Renewed Hope2
1441~Repentance1
1929~Replenish3
1809~Resourcefulness3
588~Restorative Totems5
575~Reverberation5
2149~Righteous Vengeance5
1992~Rime3
301~Riposte1
2064~Riptide1
967~Ruin5
1941~Rune Tap1
2020~Runic Power Mastery3
273~Ruthlessness3
2190~Sacred Cleansing3
1750~Sacred Duty2
1870~Safeguard2
1465~Sanctified Light3
1756~Sanctified Retribution1
1761~Sanctified Seals3
2147~Sanctified Wrath2
2074~Savage Combat2
805~Savage Fury2
1621~Savage Strikes2
1814~Scatter Shot1
1948~Scent of Blood3
2216~Scourge Strike1
283~Seal Fate5
1481~Seal of Command1
1463~Seals of the Pure5
403~Searing Light2
1663~Second Wind2
1904~Serendipity3
1802~Serpent's Swiftness5
1123~Serrated Blades3
246~Setup4
466~Shadow Affinity3
2081~Shadow Dance1
1763~Shadow Embrace5
463~Shadow Focus3
1042~Shadow Mastery5
1778~Shadow Power5
881~Shadow Reach2
461~Shadow Weaving3
1677~Shadow and Flame5
1984~Shadow of Death1
963~Shadowburn1
521~Shadowform1
1676~Shadowfury1
1714~Shadowstep1
617~Shamanistic Focus1
1693~Shamanistic Rage1
798~Sharpened Claws3
67~Shatter3
2214~Shattered Barrier2
2179~Sheath of Light3
1654~Shield Mastery2
1601~Shield Specialization5
2204~Shield of the Templar3
1872~Shockwave1
802~Shredding Attacks2
541~Silence1
1808~Silencing Shot1
352~Silent Resolve3
1712~Sinister Calling5
1041~Siphon Life1
2080~Slaughter from the Shadows5
1700~Sleight of Hand2
1729~Slow1
2143~Sniper Training3
1678~Soul Leech3
1282~Soul Link1
1004~Soul Siphon2
2018~Spell Deflection3
81~Spell Impact3
1826~Spell Power2
411~Spell Warding5
1388~Spirit Bond2
465~Spirit Tap3
616~Spirit Weapons1
1561~Spirit of Redemption1
1432~Spiritual Focus5
402~Spiritual Guidance5
404~Spiritual Healing5
1926~Starfall1
762~Starlight Wrath5
2055~Static Shock3
1748~Stoicism3
2052~Storm, Earth and Fire5
901~Stormstrike1
1862~Strength of Arms2
1845~Student of the Mind3
841~Subtlety3
1945~Subversion3
1662~Sudden Death3
1955~Sudden Doom5
1672~Summon Felguard1
2000~Summon Gargoyle1
1741~Summon Water Elemental1
1005~Suppression3
1310~Surefooted3
1766~Surge of Light2
1709~Surprise Attacks1
1162~Survival Instincts1
1810~Survival Instincts2
1309~Survival Tactics2
1794~Survival of the Fittest3
1622~Survivalist5
133~Sweeping Strikes1
2148~Swift Retribution3
844~Swiftmend1
123~Sword Specialization5
242~Sword Specialization5
1871~Sword and Board3
2229~T.N.T.3
128~Tactical Mastery3
2232~Taste for Blood3
1903~Test of Faith3
2176~The Art of War2
1803~The Beast Within1
794~Thick Hide3
1395~Thick Hide3
1811~Thrill of the Hunt3
2072~Throwing Specialization2
613~Thundering Strikes5
2053~Thunderstorm1
593~Tidal Focus5
582~Tidal Force1
594~Tidal Mastery5
2063~Tidal Waves5
1867~Titan's Grip1
2222~Torment the Weak3
1687~Totem of Wrath1
595~Totemic Focus5
2195~Touched by the Light3
615~Toughness5
1968~Toughness5
140~Toughness5
1423~Toughness5
843~Tranquil Spirit5
1322~Trap Mastery1
1859~Trauma2
1791~Tree of Life1
1361~Trueshot Aura1
1998~Tundra Stalker5
2066~Turn the Tables3
1898~Twin Disciplines5
1907~Twisted Faith5
2217~Two-Handed Weapon Specialization2
1410~Two-Handed Weapon Specialization3
136~Two-Handed Weapon Specialization3
1923~Typhoon1
1979~Unbreakable Armor1
342~Unbreakable Will5
159~Unbridled Wrath5
2234~Unending Fury5
2073~Unfair Advantage2
2013~Unholy Aura2
1996~Unholy Blight1
2025~Unholy Command2
1262~Unholy Power5
1396~Unleashed Fury5
1689~Unleashed Rage5
1860~Unrelenting Assault2
1682~Unrelenting Storm5
1670~Unstable Affliction1
1628~Unyielding Faith2
2019~Vampiric Blood1
484~Vampiric Embrace1
1779~Vampiric Touch1
483~Veiled Shadows2
1953~Vendetta3
1402~Vengeance3
792~Vengeance5
1950~Veteran of the Third War3
2082~Vicious Strikes2
148~Vigilance1
382~Vigor2
682~Vile Poisons4
1633~Vindication2
1932~Virulence3
1705~Vitality3
1653~Vitality3
2003~Wandering Plague3
2236~Warbringer1
2077~Waylay2
1703~Weapon Expertise2
1543~Weapon Mastery2
1643~Weapon Mastery3
1917~Wild Growth1
2132~Wild Quiver3
1959~Will of the Necropolis3
68~Winter's Chill3
31~World in Flames3
1786~Wrath of Cenarius5
2231~Wrecking Crew5
1325~Wyvern Sting1]]
