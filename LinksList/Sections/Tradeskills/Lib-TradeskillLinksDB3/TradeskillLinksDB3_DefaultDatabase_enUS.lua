
local o = TradeskillLinksDB3; if (o.SHOULD_LOAD == nil) then return; end

if (o.STATIC_DB ~= nil) then return; end
-- This file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


-- The leading newline is important.
o.STATIC_DB = [[

33740~1Adept's Elixir
17632~1Alchemist's Stone
11461~1Arcane Elixir
7836~1Blackmouth Oil
12609~1Catseye Elixir
41458~1Cauldron of Major Arcane Protection
41503~1Cauldron of Major Shadow Protection
6619~1Cowardly Flight Potion
28565~1Destruction Potion
4508~1Discolored Healing Potion
15833~1Dreamless Sleep Potion
39637~1Earthen Elixir
11449~1Elixir of Agility
17557~1Elixir of Brute Force
28543~1Elixir of Camouflage
3177~1Elixir of Defense
11477~1Elixir of Demonslaying
11478~1Elixir of Detect Demon
3453~1Elixir of Detect Lesser Invisibility
11460~1Elixir of Detect Undead
39638~1Elixir of Draenic Wisdom
11468~1Elixir of Dream Vision
28578~1Elixir of Empowerment
7845~1Elixir of Firepower
3450~1Elixir of Fortitude
21923~1Elixir of Frost Power
8240~1Elixir of Giant Growth
11472~1Elixir of Giants
11467~1Elixir of Greater Agility
11450~1Elixir of Greater Defense
26277~1Elixir of Greater Firepower
11465~1Elixir of Greater Intellect
22808~1Elixir of Greater Water Breathing
28545~1Elixir of Healing Power
39639~1Elixir of Ironskin
2333~1Elixir of Lesser Agility
2329~1Elixir of Lion's Strength
28553~1Elixir of Major Agility
28557~1Elixir of Major Defense
28556~1Elixir of Major Firepower
39636~1Elixir of Major Fortitude
28549~1Elixir of Major Frost Power
28570~1Elixir of Major Mageblood
28558~1Elixir of Major Shadow Power
28544~1Elixir of Major Strength
33741~1Elixir of Mastery
3230~1Elixir of Minor Agility
7183~1Elixir of Minor Defense
2334~1Elixir of Minor Fortitude
3188~1Elixir of Ogre's Strength
11476~1Elixir of Shadow Power
17554~1Elixir of Superior Defense
2336~1Elixir of Tongues
7179~1Elixir of Water Breathing
11447~1Elixir of Waterwalking
3171~1Elixir of Wisdom
17571~1Elixir of the Mongoose
17555~1Elixir of the Sages
38961~1Fel Mana Potion
38962~1Fel Regeneration Potion
38960~1Fel Strength Elixir
7837~1Fire Oil
7257~1Fire Protection Potion
28590~1Flask of Blinding Light
17638~1Flask of Chromatic Resistance
42736~1Flask of Chromatic Wonder
17636~1Flask of Distilled Wisdom
28587~1Flask of Fortification
28588~1Flask of Mighty Restoration
17634~1Flask of Petrification
28591~1Flask of Pure Death
54213~1Flask of Pure Mojo
28589~1Flask of Relentless Assault
17637~1Flask of Supreme Power
17635~1Flask of the Titans
6624~1Free Action Potion
3454~1Frost Oil
7258~1Frost Protection Potion
11473~1Ghost Dye
11466~1Gift of Arthas
11456~1Goblin Rocket Fuel
6618~1Great Rage Potion
17573~1Greater Arcane Elixir
17577~1Greater Arcane Protection Potion
17574~1Greater Fire Protection Potion
17575~1Greater Frost Protection Potion
7181~1Greater Healing Potion
17579~1Greater Holy Protection Potion
11448~1Greater Mana Potion
17576~1Greater Nature Protection Potion
17578~1Greater Shadow Protection Potion
17570~1Greater Stoneshield Potion
28564~1Haste Potion
3447~1Healing Potion
28563~1Heroic Potion
7255~1Holy Protection Potion
28550~1Insane Strength Potion
11464~1Invisibility Potion
28579~1Ironshield Potion
2337~1Lesser Healing Potion
3448~1Lesser Invisibility Potion
3173~1Lesser Mana Potion
4942~1Lesser Stoneshield Potion
3175~1Limited Invulnerability Potion
45061~1Mad Alchemist's Potion
11453~1Magic Resistance Potion
28575~1Major Arcane Protection Potion
28562~1Major Dreamless Sleep Potion
28571~1Major Fire Protection Potion
17556~1Major Healing Potion
17580~1Major Mana Potion
28573~1Major Nature Protection Potion
3452~1Mana Potion
38070~1Mercurial Stone
17552~1Mighty Rage Potion
3451~1Mighty Troll's Blood Elixir
2330~1Minor Healing Potion
3172~1Minor Magic Resistance Potion
2331~1Minor Mana Potion
2332~1Minor Rejuvenation Potion
7259~1Nature Protection Potion
11451~1Oil of Immolation
33738~1Onslaught Elixir
11459~1Philosopher's Stone
3174~1Potion of Curing
17572~1Purification Potion
6617~1Rage Potion
11452~1Restorative Potion
3449~1Shadow Oil
7256~1Shadow Protection Potion
28546~1Sneaking Potion
17551~1Stonescale Oil
3176~1Strong Troll's Blood Elixir
28551~1Super Healing Potion
28555~1Super Mana Potion
28586~1Super Rejuvenation Potion
11457~1Superior Healing Potion
17553~1Superior Mana Potion
2335~1Swiftness Potion
7841~1Swim Speed Potion
17559~1Transmute: Air to Fire
17187~1Transmute: Arcanite
17566~1Transmute: Earth to Life
17561~1Transmute: Earth to Water
32765~1Transmute: Earthstorm Diamond
17560~1Transmute: Fire to Earth
11479~1Transmute: Iron to Gold
17565~1Transmute: Life to Earth
11480~1Transmute: Mithril to Truesilver
28566~1Transmute: Primal Air to Fire
28585~1Transmute: Primal Earth to Life
28567~1Transmute: Primal Earth to Water
28568~1Transmute: Primal Fire to Earth
28583~1Transmute: Primal Fire to Mana
28584~1Transmute: Primal Life to Earth
28582~1Transmute: Primal Mana to Fire
29688~1Transmute: Primal Might
28580~1Transmute: Primal Shadow to Water
28569~1Transmute: Primal Water to Air
28581~1Transmute: Primal Water to Shadow
32766~1Transmute: Skyfire Diamond
60350~1Transmute: Titanium
17563~1Transmute: Undeath to Water
17562~1Transmute: Water to Air
17564~1Transmute: Water to Undeath
33733~1Unstable Mana Potion
33732~1Volatile Healing Potion
3170~1Weak Troll's Blood Elixir
11458~1Wildvine Potion
29606~2Adamantite Breastplate
29568~2Adamantite Cleaver
29569~2Adamantite Dagger
29566~2Adamantite Maul
29603~2Adamantite Plate Bracers
29605~2Adamantite Plate Gloves
29571~2Adamantite Rapier
32656~2Adamantite Rod
29656~2Adamantite Sharpening Stone
34608~2Adamantite Weightstone
16991~2Annihilator
16990~2Arcanite Champion
16994~2Arcanite Reaper
20201~2Arcanite Rod
19669~2Arcanite Skeleton Key
9818~2Barbaric Iron Boots
9813~2Barbaric Iron Breastplate
9820~2Barbaric Iron Gloves
9814~2Barbaric Iron Helm
9811~2Barbaric Iron Shoulders
10001~2Big Black Mace
3491~2Big Bronze Knife
16978~2Blazing Rapier
16965~2Bleakwood Hew
29672~2Blessed Bracers
10011~2Blight
16986~2Blood Talon
9995~2Blue Glittering Axe
29671~2Bracers of the Green Fortress
2741~2Bronze Axe
9987~2Bronze Battle Axe
9986~2Bronze Greatsword
2740~2Bronze Mace
2742~2Bronze Shortsword
9985~2Bronze Warhammer
3326~2Coarse Grinding Stone
2665~2Coarse Sharpening Stone
3116~2Coarse Weightstone
2738~2Copper Axe
3293~2Copper Battle Axe
2663~2Copper Bracers
2661~2Copper Chain Belt
3319~2Copper Chain Boots
2662~2Copper Chain Pants
3321~2Copper Chain Vest
9983~2Copper Claymore
8880~2Copper Dagger
2737~2Copper Mace
2739~2Copper Shortsword
16985~2Corruption
15293~2Dark Iron Mail
15296~2Dark Iron Plate
15292~2Dark Iron Pulverizer
15295~2Dark Iron Shoulders
15294~2Dark Iron Sunderer
16987~2Darkspear
16970~2Dawn's Edge
16660~2Dawnbringer Shoulders
10005~2Dazzling Mithril Rapier
3295~2Deadly Bronze Poniard
16667~2Demon Forged Breastplate
16639~2Dense Grinding Stone
16641~2Dense Sharpening Stone
16640~2Dense Weightstone
29699~2Dirge
36122~2Earthforged Leggings
29649~2Earthpeace Breastplate
10013~2Ebon Shiv
21913~2Edge of Winter
29608~2Enchanted Adamantite Belt
29611~2Enchanted Adamantite Boots
29610~2Enchanted Adamantite Breastplate
16973~2Enchanted Battlehammer
34982~2Enchanted Thorium Blades
16745~2Enchanted Thorium Breastplate
16742~2Enchanted Thorium Helm
16744~2Enchanted Thorium Leggings
29698~2Eternium Runed Blade
29694~2Fel Edged Battleaxe
29697~2Fel Hardened Maul
29550~2Fel Iron Breastplate
29553~2Fel Iron Chain Bracers
29551~2Fel Iron Chain Coif
29552~2Fel Iron Chain Gloves
29556~2Fel Iron Chain Tunic
29565~2Fel Iron Greatsword
29558~2Fel Iron Hammer
29557~2Fel Iron Hatchet
29547~2Fel Iron Plate Belt
29548~2Fel Iron Plate Boots
29545~2Fel Iron Plate Gloves
29549~2Fel Iron Plate Pants
32655~2Fel Iron Rod
29654~2Fel Sharpening Stone
34607~2Fel Weightstone
29619~2Felsteel Gloves
29621~2Felsteel Helm
29620~2Felsteel Leggings
29692~2Felsteel Longblade
29695~2Felsteel Reaper
29657~2Felsteel Shield Spike
34983~2Felsteel Whisper Knives
16655~2Fiery Plate Gauntlets
34535~2Fireguard
29614~2Flamebane Bracers
29617~2Flamebane Breastplate
29616~2Flamebane Gloves
29615~2Flamebane Helm
3497~2Frost Tiger Blade
16992~2Frostguard
3325~2Gemmed Copper Gauntlets
15972~2Glinting Steel Dagger
3495~2Golden Iron Destroyer
14379~2Golden Rod
3515~2Golden Scale Boots
7223~2Golden Scale Bracers
3503~2Golden Scale Coif
3511~2Golden Scale Cuirass
11643~2Golden Scale Gauntlets
3507~2Golden Scale Leggings
3505~2Golden Scale Shoulders
19667~2Golden Skeleton Key
32285~2Greater Rune of Warding
3334~2Green Iron Boots
3501~2Green Iron Bracers
3336~2Green Iron Gauntlets
3508~2Green Iron Hauberk
3502~2Green Iron Helm
3506~2Green Iron Leggings
3504~2Green Iron Shoulders
16988~2Hammer of the Titans
3492~2Hardened Iron Shortsword
16995~2Heartseeker
3296~2Heavy Bronze Mace
3292~2Heavy Copper Broadsword
7408~2Heavy Copper Maul
3337~2Heavy Grinding Stone
9993~2Heavy Mithril Axe
9968~2Heavy Mithril Boots
9959~2Heavy Mithril Breastplate
9928~2Heavy Mithril Gauntlet
9970~2Heavy Mithril Helm
9933~2Heavy Mithril Pants
9926~2Heavy Mithril Shoulder
2674~2Heavy Sharpening Stone
3117~2Heavy Weightstone
16728~2Helm of the Great Chief
16971~2Huge Thorium Battleaxe
16647~2Imperial Plate Belt
16657~2Imperial Plate Boots
16649~2Imperial Plate Bracers
16663~2Imperial Plate Chest
16658~2Imperial Plate Helm
16730~2Imperial Plate Leggings
16646~2Imperial Plate Shoulders
11454~2Inlaid Mithril Cylinder
16967~2Inlaid Thorium Hammer
16746~2Invulnerable Mail
6518~2Iridescent Hammer
8768~2Iron Buckle
7222~2Iron Counterweight
7221~2Iron Shield Spike
8367~2Ironforge Breastplate
8366~2Ironforge Chain
8368~2Ironforge Gauntlets
3493~2Jade Serpentblade
29628~2Khorium Belt
29630~2Khorium Boots
29629~2Khorium Pants
32284~2Lesser Rune of Warding
29728~2Lesser Ward of Shielding
36125~2Light Earthforged Blade
36128~2Light Emberforged Hammer
36126~2Light Skyforged Axe
34538~2Lionheart Blade
16729~2Lionheart Helm
3498~2Massive Iron Axe
16993~2Masterwork Stormhammer
3297~2Mighty Iron Hammer
9961~2Mithril Coif
9937~2Mithril Scale Bracers
9942~2Mithril Scale Gloves
9931~2Mithril Scale Pants
9966~2Mithril Scale Shoulders
9939~2Mithril Shield Spike
9964~2Mithril Spurs
3496~2Moonsteel Broadsword
29668~2Oathkeeper's Helm
9957~2Orcish War Leggings
9979~2Ornate Mithril Boots
9972~2Ornate Mithril Breastplate
9950~2Ornate Mithril Gloves
9980~2Ornate Mithril Helm
9945~2Ornate Mithril Pants
9952~2Ornate Mithril Shoulder
16969~2Ornate Thorium Handaxe
2672~2Patterned Bronze Bracers
6517~2Pearl-handled Dagger
10007~2Phantom Blade
3513~2Polished Steel Boots
16645~2Radiant Belt
16656~2Radiant Boots
16648~2Radiant Breastplate
16659~2Radiant Circlet
16654~2Radiant Gloves
16725~2Radiant Leggings
29645~2Ragesteel Breastplate
29642~2Ragesteel Gloves
29643~2Ragesteel Helm
42662~2Ragesteel Shoulders
36390~2Red Belt of Battle
7817~2Rough Bronze Boots
2671~2Rough Bronze Bracers
2670~2Rough Bronze Cuirass
2668~2Rough Bronze Leggings
3328~2Rough Bronze Shoulders
12260~2Rough Copper Vest
3320~2Rough Grinding Stone
2660~2Rough Sharpening Stone
3115~2Rough Weightstone
16980~2Rune Edge
2666~2Runed Copper Belt
2664~2Runed Copper Bracers
2667~2Runed Copper Breastplate
3323~2Runed Copper Gauntlets
3324~2Runed Copper Pants
10009~2Runed Mithril Hammer
16731~2Runic Breastplate
29696~2Runic Hammer
16665~2Runic Plate Boots
16726~2Runic Plate Helm
16732~2Runic Plate Leggings
16664~2Runic Plate Shoulders
15973~2Searing Golden Blade
16983~2Serenity
3500~2Shadow Crescent Axe
2675~2Shining Silver Breastplate
7818~2Silver Rod
19666~2Silver Skeleton Key
3331~2Silvered Bronze Boots
2673~2Silvered Bronze Breastplate
3333~2Silvered Bronze Gauntlets
12259~2Silvered Bronze Leggings
3330~2Silvered Bronze Shoulders
9920~2Solid Grinding Stone
3494~2Solid Iron Maul
9918~2Solid Sharpening Stone
9921~2Solid Weightstone
9916~2Steel Breastplate
9935~2Steel Plate Helm
7224~2Steel Weapon Chain
29662~2Steelgrip Gauntlets
36133~2Stoneforged Claymore
16661~2Storm Gauntlets
29663~2Storm Helm
16741~2Stronghold Gauntlets
29648~2Swiftsteel Gloves
55376~2Tempered Titansteel Treads
10003~2The Shatterer
34979~2Thick Bronze Darts
3294~2Thick War Axe
16642~2Thorium Armor
16643~2Thorium Belt
16652~2Thorium Boots
16644~2Thorium Bracers
16960~2Thorium Greatsword
16653~2Thorium Helm
16662~2Thorium Leggings
16651~2Thorium Shield Spike
9974~2Truesilver Breastplate
10015~2Truesilver Champion
9954~2Truesilver Gauntlets
14380~2Truesilver Rod
19668~2Truesilver Skeleton Key
16984~2Volcanic Hammer
34981~2Whirling Steel Axes
16724~2Whitesoul Helm
9997~2Wicked Mithril Blade
38476~2Wildguard Helm
38475~2Wildguard Leggings
16650~2Wildthorn Mail
36124~2Windforged Leggings
36131~2Windforged Rapier
45569~3Baked Manta Ray
18247~3Baked Salmon
4094~3Barbecued Buzzard Wing
33278~3Bat Bites
2795~3Beer Basted Boar Ribs
3397~3Big Bear Steak
33286~3Blackened Basilisk
33292~3Blackened Sporefish
33290~3Blackened Trout
3371~3Blood Sausage
6499~3Boiled Clams
7751~3Brilliant Smallfish
7755~3Bristle Whisker Catfish
43761~3Broiled Bloodfin
33279~3Buzzard Bites
15863~3Carrion Surprise
46684~3Charred Bear Kabobs
2538~3Charred Wolf Meat
36210~3Clam Bar
6501~3Clam Chowder
2545~3Cooked Crab Claw
18239~3Cooked Glossy Mightfish
2541~3Coyote Steak
2544~3Crab Cake
15935~3Crispy Bat Wing
6418~3Crispy Lizard Tail
3373~3Crocolisk Gumbo
3370~3Crocolisk Steak
38868~3Crunchy Serpent
28267~3Crunchy Spider Surprise
3376~3Curiously Tasty Omelet
58065~3Dalaran Clam Chowder
43779~3Delicious Chocolate Cake
6417~3Dig Rat Stew
15906~3Dragonbreath Chili
2546~3Dry Pork Ribs
21144~3Egg Nog
33291~3Feltail Delight
18241~3Filet of Redgill
6415~3Fillet of Frenzy
42302~3Fisherman's Feast
7213~3Giant Clam Scorcho
21143~3Gingerbread Cookie
6500~3Goblin Deviled Clams
33295~3Golden Fish Sticks
13028~3Goldthorn Tea
3377~3Gooey Spider Cake
2542~3Goretusk Liver Pie
45554~3Great Feast
45561~3Grilled Bonescale
33293~3Grilled Mudfish
45563~3Grilled Sculpin
18240~3Grilled Squid
24418~3Heavy Crocolisk Stew
15910~3Heavy Kodo Stew
8604~3Herb Baked Egg
45022~3Hot Apple Cider
42305~3Hot Buttered Trout
3398~3Hot Lion Chops
18242~3Hot Smoked Bass
15856~3Hot Wolf Ribs
46688~3Juicy Bear Burger
15861~3Jungle Stew
6412~3Kaldorei Spider Kabob
43772~3Kibler's Bits
6419~3Lean Venison
15853~3Lean Wolf Steak
18245~3Lobster Stew
7754~3Loch Frenzy Delight
7753~3Longjaw Mud Snapper
33276~3Lynx Steak
45549~3Mammoth Meal
18246~3Mightfish Steak
20916~3Mithril Head Trout
38867~3Mok'Nathal Shortribs
15933~3Monster Omelet
3372~3Murloc Fin Soup
15865~3Mystery Stew
18243~3Nightfin Soup
45566~3Pickled Fangtooth
33294~3Poached Bluefish
45565~3Poached Nettlefish
18244~3Poached Sunscale Salmon
7827~3Rainbow Fin Albacore
33284~3Ravager Dog
2547~3Redridge Goulash
45553~3Rhino Dogs
15855~3Roast Raptor
2540~3Roasted Boar Meat
33287~3Roasted Clefthoof
6414~3Roasted Kodo Meat
45552~3Roasted Worg
7828~3Rockscale Cod
22761~3Runn Tum Tuber Surprise
25954~3Sagefish Delight
45562~3Sauteed Goby
8238~3Savory Deviate Delight
6413~3Scorpid Surprise
2549~3Seasoned Wolf Kabob
45550~3Shoveltusk Steak
43707~3Skullfish Soup
7752~3Slitherskin Mackerel
8607~3Smoked Bear Meat
24801~3Smoked Desert Dumplings
45560~3Smoked Rockfin
25704~3Smoked Sagefish
45564~3Smoked Salmon
3400~3Soothing Turtle Bisque
37836~3Spice Bread
15915~3Spiced Chili Crab
2539~3Spiced Wolf Meat
33296~3Spicy Crawdad
43765~3Spicy Hot Talbuk
21175~3Spider Sausage
33285~3Sporeling Snack
18238~3Spotted Yellowtail
42296~3Stewed Trout
43758~3Stormchops
6416~3Strider Stew
2548~3Succulent Pork Ribs
33289~3Talbuk Steak
3399~3Tasty Lion Steak
22480~3Tender Wolf Steak
9513~3Thistle Tea
20626~3Undermine Clam Chowder
33288~3Warp Burger
2543~3Westfall Stew
45551~3Wyrm Delight
27837~4Enchant 2H Weapon - Agility
13937~4Enchant 2H Weapon - Greater Impact
44630~4Enchant 2H Weapon - Greater Savagery
13695~4Enchant 2H Weapon - Impact
13529~4Enchant 2H Weapon - Lesser Impact
7793~4Enchant 2H Weapon - Lesser Intellect
13380~4Enchant 2H Weapon - Lesser Spirit
27977~4Enchant 2H Weapon - Major Agility
20036~4Enchant 2H Weapon - Major Intellect
20035~4Enchant 2H Weapon - Major Spirit
60691~4Enchant 2H Weapon - Massacre
7745~4Enchant 2H Weapon - Minor Impact
27971~4Enchant 2H Weapon - Savagery
44595~4Enchant 2H Weapon - Scourgebane
20030~4Enchant 2H Weapon - Superior Impact
13935~4Enchant Boots - Agility
60606~4Enchant Boots - Assault
34008~4Enchant Boots - Boar's Speed
34007~4Enchant Boots - Cat's Swiftness
27951~4Enchant Boots - Dexterity
27950~4Enchant Boots - Fortitude
20023~4Enchant Boots - Greater Agility
60763~4Enchant Boots - Greater Assault
44528~4Enchant Boots - Greater Fortitude
44508~4Enchant Boots - Greater Spirit
20020~4Enchant Boots - Greater Stamina
44584~4Enchant Boots - Greater Vitality
60623~4Enchant Boots - Icewalker
13637~4Enchant Boots - Lesser Agility
13687~4Enchant Boots - Lesser Spirit
13644~4Enchant Boots - Lesser Stamina
7867~4Enchant Boots - Minor Agility
13890~4Enchant Boots - Minor Speed
7863~4Enchant Boots - Minor Stamina
20024~4Enchant Boots - Spirit
13836~4Enchant Boots - Stamina
44589~4Enchant Boots - Superior Agility
27954~4Enchant Boots - Surefooted
47901~4Enchant Boots - Tuskarr's Vitality
27948~4Enchant Boots - Vitality
34002~4Enchant Bracer - Assault
27899~4Enchant Bracer - Brawn
13931~4Enchant Bracer - Deflection
27914~4Enchant Bracer - Fortitude
20008~4Enchant Bracer - Greater Intellect
13846~4Enchant Bracer - Greater Spirit
13945~4Enchant Bracer - Greater Stamina
13939~4Enchant Bracer - Greater Strength
23802~4Enchant Bracer - Healing Power
13822~4Enchant Bracer - Intellect
13646~4Enchant Bracer - Lesser Deflection
13622~4Enchant Bracer - Lesser Intellect
7859~4Enchant Bracer - Lesser Spirit
13501~4Enchant Bracer - Lesser Stamina
13536~4Enchant Bracer - Lesser Strength
27906~4Enchant Bracer - Major Defense
34001~4Enchant Bracer - Major Intellect
23801~4Enchant Bracer - Mana Regeneration
7779~4Enchant Bracer - Minor Agility
7428~4Enchant Bracer - Minor Deflection
7418~4Enchant Bracer - Minor Health
7766~4Enchant Bracer - Minor Spirit
7457~4Enchant Bracer - Minor Stamina
7782~4Enchant Bracer - Minor Strength
27913~4Enchant Bracer - Restore Mana Prime
27917~4Enchant Bracer - Spellpower
13642~4Enchant Bracer - Spirit
13648~4Enchant Bracer - Stamina
27905~4Enchant Bracer - Stats
13661~4Enchant Bracer - Strength
27911~4Enchant Bracer - Superior Healing
20009~4Enchant Bracer - Superior Spirit
20011~4Enchant Bracer - Superior Stamina
20010~4Enchant Bracer - Superior Strength
44555~4Enchant Bracers - Exceptional Intellect
44598~4Enchant Bracers - Expertise
44575~4Enchant Bracers - Greater Assault
44635~4Enchant Bracers - Greater Spellpower
44616~4Enchant Bracers - Greater Stats
44593~4Enchant Bracers - Major Spirit
60616~4Enchant Bracers - Striking
60767~4Enchant Bracers - Superior Spellpower
46594~4Enchant Chest - Defense
27957~4Enchant Chest - Exceptional Health
27958~4Enchant Chest - Exceptional Mana
44588~4Enchant Chest - Exceptional Resilience
27960~4Enchant Chest - Exceptional Stats
47766~4Enchant Chest - Greater Defense
13640~4Enchant Chest - Greater Health
13663~4Enchant Chest - Greater Mana
44509~4Enchant Chest - Greater Mana Restoration
20025~4Enchant Chest - Greater Stats
7857~4Enchant Chest - Health
13538~4Enchant Chest - Lesser Absorption
7748~4Enchant Chest - Lesser Health
7776~4Enchant Chest - Lesser Mana
13700~4Enchant Chest - Lesser Stats
20026~4Enchant Chest - Major Health
20028~4Enchant Chest - Major Mana
33992~4Enchant Chest - Major Resilience
33990~4Enchant Chest - Major Spirit
13607~4Enchant Chest - Mana
44492~4Enchant Chest - Mighty Health
7426~4Enchant Chest - Minor Absorption
7420~4Enchant Chest - Minor Health
7443~4Enchant Chest - Minor Mana
13626~4Enchant Chest - Minor Stats
60692~4Enchant Chest - Powerful Stats
33991~4Enchant Chest - Restore Mana Prime
13941~4Enchant Chest - Stats
47900~4Enchant Chest - Super Health
44623~4Enchant Chest - Super Stats
13858~4Enchant Chest - Superior Health
13917~4Enchant Chest - Superior Mana
13635~4Enchant Cloak - Defense
25086~4Enchant Cloak - Dodge
13657~4Enchant Cloak - Fire Resistance
34004~4Enchant Cloak - Greater Agility
13746~4Enchant Cloak - Greater Defense
25081~4Enchant Cloak - Greater Fire Resistance
20014~4Enchant Cloak - Greater Resistance
34006~4Enchant Cloak - Greater Shadow Resistance
47898~4Enchant Cloak - Greater Speed
13882~4Enchant Cloak - Lesser Agility
7861~4Enchant Cloak - Lesser Fire Resistance
13421~4Enchant Cloak - Lesser Protection
13522~4Enchant Cloak - Lesser Shadow Resistance
60663~4Enchant Cloak - Major Agility
27961~4Enchant Cloak - Major Armor
27962~4Enchant Cloak - Major Resistance
47672~4Enchant Cloak - Mighty Armor
13419~4Enchant Cloak - Minor Agility
7771~4Enchant Cloak - Minor Protection
7454~4Enchant Cloak - Minor Resistance
13794~4Enchant Cloak - Resistance
44631~4Enchant Cloak - Shadow Armor
60609~4Enchant Cloak - Speed
34003~4Enchant Cloak - Spell Penetration
44582~4Enchant Cloak - Spell Piercing
25083~4Enchant Cloak - Stealth
47051~4Enchant Cloak - Steelweave
25084~4Enchant Cloak - Subtlety
44500~4Enchant Cloak - Superior Agility
20015~4Enchant Cloak - Superior Defense
44556~4Enchant Cloak - Superior Fire Resistance
44591~4Enchant Cloak - Titanweave
47899~4Enchant Cloak - Wisdom
13868~4Enchant Gloves - Advanced Herbalism
13841~4Enchant Gloves - Advanced Mining
13815~4Enchant Gloves - Agility
44625~4Enchant Gloves - Armsman
33996~4Enchant Gloves - Assault
33993~4Enchant Gloves - Blasting
60668~4Enchant Gloves - Crusher
44592~4Enchant Gloves - Exceptional Spellpower
44484~4Enchant Gloves - Expertise
13620~4Enchant Gloves - Fishing
44506~4Enchant Gloves - Gatherer
20012~4Enchant Gloves - Greater Agility
44513~4Enchant Gloves - Greater Assault
20013~4Enchant Gloves - Greater Strength
13617~4Enchant Gloves - Herbalism
44529~4Enchant Gloves - Major Agility
33999~4Enchant Gloves - Major Healing
33997~4Enchant Gloves - Major Spellpower
33995~4Enchant Gloves - Major Strength
13612~4Enchant Gloves - Mining
13948~4Enchant Gloves - Minor Haste
33994~4Enchant Gloves - Precise Strikes
44488~4Enchant Gloves - Precision
13947~4Enchant Gloves - Riding Skill
13698~4Enchant Gloves - Skinning
13887~4Enchant Gloves - Strength
25080~4Enchant Gloves - Superior Agility
25072~4Enchant Gloves - Threat
44645~4Enchant Ring - Assault
44636~4Enchant Ring - Greater Spellpower
27926~4Enchant Ring - Healing Power
27924~4Enchant Ring - Spellpower
59636~4Enchant Ring - Stamina
27927~4Enchant Ring - Stats
27920~4Enchant Ring - Striking
44489~4Enchant Shield - Defense
13933~4Enchant Shield - Frost Resistance
60653~4Enchant Shield - Greater Intellect
13905~4Enchant Shield - Greater Spirit
20017~4Enchant Shield - Greater Stamina
27945~4Enchant Shield - Intellect
13689~4Enchant Shield - Lesser Block
13464~4Enchant Shield - Lesser Protection
13485~4Enchant Shield - Lesser Spirit
13631~4Enchant Shield - Lesser Stamina
34009~4Enchant Shield - Major Stamina
13378~4Enchant Shield - Minor Stamina
44383~4Enchant Shield - Resilience
27947~4Enchant Shield - Resistance
27946~4Enchant Shield - Shield Block
13659~4Enchant Shield - Spirit
13817~4Enchant Shield - Stamina
20016~4Enchant Shield - Superior Spirit
27944~4Enchant Shield - Tough Shield
59619~4Enchant Weapon - Accuracy
23800~4Enchant Weapon - Agility
28004~4Enchant Weapon - Battlemaster
59621~4Enchant Weapon - Berserking
59625~4Enchant Weapon - Black Magic
20034~4Enchant Weapon - Crusader
46578~4Enchant Weapon - Deathfrost
13915~4Enchant Weapon - Demonslaying
44633~4Enchant Weapon - Exceptional Agility
44629~4Enchant Weapon - Exceptional Spellpower
44510~4Enchant Weapon - Exceptional Spirit
42974~4Enchant Weapon - Executioner
13898~4Enchant Weapon - Fiery Weapon
44621~4Enchant Weapon - Giant Slayer
42620~4Enchant Weapon - Greater Agility
60621~4Enchant Weapon - Greater Potency
13943~4Enchant Weapon - Greater Striking
44524~4Enchant Weapon - Icebreaker
20029~4Enchant Weapon - Icy Chill
13653~4Enchant Weapon - Lesser Beastslayer
13655~4Enchant Weapon - Lesser Elemental Slayer
13503~4Enchant Weapon - Lesser Striking
20032~4Enchant Weapon - Lifestealing
44576~4Enchant Weapon - Lifeward
34010~4Enchant Weapon - Major Healing
27968~4Enchant Weapon - Major Intellect
27975~4Enchant Weapon - Major Spellpower
27967~4Enchant Weapon - Major Striking
23804~4Enchant Weapon - Mighty Intellect
60714~4Enchant Weapon - Mighty Spellpower
23803~4Enchant Weapon - Mighty Spirit
7786~4Enchant Weapon - Minor Beastslayer
7788~4Enchant Weapon - Minor Striking
27984~4Enchant Weapon - Mongoose
27972~4Enchant Weapon - Potency
27982~4Enchant Weapon - Soulfrost
28003~4Enchant Weapon - Spellsurge
23799~4Enchant Weapon - Strength
13693~4Enchant Weapon - Striking
27981~4Enchant Weapon - Sunfire
60707~4Enchant Weapon - Superior Potency
20031~4Enchant Weapon - Superior Striking
20033~4Enchant Weapon - Unholy Weapon
21931~4Enchant Weapon - Winter's Might
17181~4Enchanted Leather
17180~4Enchanted Thorium
14807~4Greater Magic Wand
14810~4Greater Mystic Wand
28022~4Large Prismatic Shard
14293~4Lesser Magic Wand
25127~4Lesser Mana Oil
14809~4Lesser Mystic Wand
25126~4Lesser Wizard Oil
25125~4Minor Mana Oil
25124~4Minor Wizard Oil
42613~4Nexus Transformation
28027~4Prismatic Sphere
32665~4Runed Adamantite Rod
20051~4Runed Arcanite Rod
7421~4Runed Copper Rod
32667~4Runed Eternium Rod
32664~4Runed Fel Iron Rod
13628~4Runed Golden Rod
7795~4Runed Silver Rod
60619~4Runed Titanium Rod
13702~4Runed Truesilver Rod
42615~4Small Prismatic Shard
15596~4Smoking Heart of the Mountain
28016~4Superior Mana Oil
28019~4Superior Wizard Oil
45765~4Void Shatter
28028~4Void Sphere
25128~4Wizard Oil
3979~5Accurate Scope
43676~5Adamantite Arrow Maker
30306~5Adamantite Frame
30311~5Adamantite Grenade
30313~5Adamantite Rifle
30329~5Adamantite Scope
30347~5Adamantite Shell Machine
3965~5Advanced Target Dummy
23096~5Alarm-O-Bot
9271~5Aquadynamic Fish Attractor
19831~5Arcane Bomb
19830~5Arcanite Dragonling
7430~5Arclight Spanner
3950~5Big Bronze Bomb
3967~5Big Iron Bomb
24357~5Bloodvine Lens
23067~5Blue Firework
26423~5Blue Rocket Cluster
12587~5Bright-Eye Goggles
3953~5Bronze Framework
3938~5Bronze Tube
12607~5Catseye Ultra Goggles
3929~5Coarse Blasting Powder
3931~5Coarse Dynamite
56460~5Cobalt Frag Bomb
30316~5Cogspinner Goggles
3963~5Compact Harvest Reaper Kit
3926~5Copper Modulator
3924~5Copper Tube
3930~5Crafted Heavy Shot
3920~5Crafted Light Shot
3947~5Crafted Solid Shot
3966~5Craftsman's Monocle
30337~5Crashin' Thrashin' Robot
3977~5Crude Scope
19799~5Dark Iron Bomb
19796~5Dark Iron Rifle
3936~5Deadly Blunderbuss
12597~5Deadly Scope
41317~5Deathblow X11 Goggles
12617~5Deepdive Helmet
19815~5Delicate Arcanite Converter
19788~5Dense Blasting Powder
23070~5Dense Dynamite
41320~5Destruction Holo-gogs
36954~5Dimensional Ripper - Area 52
23486~5Dimensional Ripper - Everlook
3959~5Discombobulator Ray
8339~5EZ-Thro Dynamite
23069~5EZ-Thro Dynamite II
30303~5Elemental Blasting Powder
30547~5Elemental Seaforium Charge
12719~5Explosive Arrow
3955~5Explosive Sheep
30310~5Fel Iron Bomb
30304~5Fel Iron Casing
30312~5Fel Iron Musket
30346~5Fel Iron Shells
30348~5Fel Iron Toolbox
30314~5Felsteel Boomstick
30309~5Felsteel Stabilizer
44391~5Field Repair Bot 110G
22704~5Field Repair Bot 74A
12594~5Fire Goggles
26443~5Firework Cluster Launcher
26442~5Firework Launcher
3944~5Flame Deflector
8243~5Flash Bomb
19833~5Flawless Arcanite Rifle
55002~5Flexweave Underlay
44155~5Flying Machine
3934~5Flying Tiger Goggles
30565~5Foreman's Enchanted Helmet
30566~5Foreman's Reinforced Helmet
39973~5Frost Grenades
40274~5Furious Gizmatic Goggles
39895~5Fused Wiring
41315~5Gadgetstorm Goggles
56462~5Gnomish Army Knife
12906~5Gnomish Battle Chicken
30575~5Gnomish Battle Goggles
3971~5Gnomish Cloaking Device
12759~5Gnomish Death Ray
30568~5Gnomish Flame Turret
12897~5Gnomish Goggles
12904~5Gnomish Ham Radio
12903~5Gnomish Harm Prevention Belt
12907~5Gnomish Mind Control Cap
12902~5Gnomish Net-o-Matic Projector
30569~5Gnomish Poultryizer
30574~5Gnomish Power Goggles
12905~5Gnomish Rocket Boots
12899~5Gnomish Shrink Ray
9269~5Gnomish Universal Remote
12720~5Goblin "Boom" Box
12755~5Goblin Bomb Dispenser
12718~5Goblin Construction Helmet
12908~5Goblin Dragon Gun
9273~5Goblin Jumper Cables
23078~5Goblin Jumper Cables XL
3968~5Goblin Land Mine
12717~5Goblin Mining Helmet
12716~5Goblin Mortar
12722~5Goblin Radio
8895~5Goblin Rocket Boots
12715~5Goblin Rocket Fuel Recipe
12758~5Goblin Rocket Helmet
30563~5Goblin Rocket Launcher
12760~5Goblin Sapper Charge
12584~5Gold Power Core
23068~5Green Firework
12622~5Green Lens
26424~5Green Rocket Cluster
30344~5Green Smoke Flare
3956~5Green Tinted Goggles
41307~5Gyro-balanced Khorium Destroyer
3961~5Gyrochronatom
23077~5Gyrofreeze Ice Reflector
12590~5Gyromatic Micro-Adjustor
54998~5Hand-Mounted Pyro Rocket
56349~5Handful of Cobalt Bolts
3922~5Handful of Copper Bolts
30305~5Handful of Fel Iron Bolts
30307~5Hardened Adamantite Tube
30551~5Healing Potion Injector
3945~5Heavy Blasting Powder
3946~5Heavy Dynamite
12619~5Hi-Explosive Bomb
12596~5Hi-Impact Mithril Slugs
23081~5Hyper-Radiant Flame Reflector
3957~5Ice Deflector
39971~5Icy Blasting Primers
12895~5Inlaid Mithril Cylinder Plans
3962~5Iron Grenade
3958~5Iron Strut
41311~5Justicebringer 2000 Specs
30308~5Khorium Power Core
30332~5Khorium Scope
26420~5Large Blue Rocket
3937~5Large Copper Bomb
26421~5Large Green Rocket
26422~5Large Red Rocket
3972~5Large Seaforium Charge
19793~5Lifelike Mechanical Toad
15633~5Lil' Smoky
41316~5Living Replicator Specs
3939~5Lovingly Crafted Boomstick
56472~5MOLL-E
41319~5Magnified Moon Specs
23079~5Major Recombobulator
19825~5Master Engineer's Goggles
19814~5Masterwork Target Dummy
3969~5Mechanical Dragonling
15255~5Mechanical Repair Kit
3928~5Mechanical Squirrel
3952~5Minor Recombobulator
12595~5Mithril Blunderbuss
12599~5Mithril Casing
12603~5Mithril Frag Bomb
12621~5Mithril Gyro-Shot
12614~5Mithril Heavy-bore Rifle
12624~5Mithril Mechanical Dragonling
12589~5Mithril Tube
12900~5Mobile Alarm
3954~5Moonsight Rifle
30570~5Nigh-Invulnerability Belt
55016~5Nitro Boosts
30315~5Ornate Khorium Rifle
6458~5Ornate Spyglass
12616~5Parachute Cloak
54736~5Personal Electromagnetic Pulse Generator
15628~5Pet Bombling
3960~5Portable Bronze Mortar
30317~5Power Amplification Goggles
23080~5Powerful Seaforium Charge
41321~5Powerheal 4000 Lens
8334~5Practice Lock
32814~5Purple Smoke Flare
23066~5Red Firework
26425~5Red Rocket Cluster
30556~5Rocket Boots Xtreme
46697~5Rocket Boots Xtreme Lite
12618~5Rose Colored Goggles
3918~5Rough Blasting Powder
3925~5Rough Boomstick
3923~5Rough Copper Bomb
3919~5Rough Dynamite
19567~5Salt Shaker
3940~5Shadow Goggles
3973~5Silver Contact
3949~5Silver-plated Shotgun
26416~5Small Blue Rocket
3941~5Small Bronze Bomb
26417~5Small Green Rocket
26418~5Small Red Rocket
3933~5Small Seaforium Charge
12620~5Sniper Scope
21940~5Snowmaster 9000
12585~5Solid Blasting Powder
12586~5Solid Dynamite
12615~5Spellpower Goggles Xtreme
19794~5Spellpower Goggles Xtreme Plus
30334~5Stabilized Eternium Scope
3978~5Standard Scope
28327~5Steam Tonk Controller
30560~5Super Sapper Charge
41314~5Surestrike Goggles v2.0
41312~5Tankatronic Goggles
3932~5Target Dummy
12754~5The Big One
30558~5The Bigger One
13240~5The Mortar: Reloaded
19790~5Thorium Grenade
19792~5Thorium Rifle
19800~5Thorium Shells
19795~5Thorium Tube
19791~5Thorium Widget
26011~5Tranquil Mechanical Yeti
23071~5Truesilver Transformer
44157~5Turbo-Charged Flying Machine
23082~5Ultra-Flash Shadow Reflector
30318~5Ultra-Spectropic Detection Goggles
23489~5Ultrasafe Transporter - Gadgetzan
36955~5Ultrasafe Transporter - Toshley's Station
12591~5Unstable Trigger
19819~5Voice Amplification Modulator
53281~5Volatile Blasting Trigger
3942~5Whirring Bronze Gizmo
30341~5White Smoke Flare
41318~5Wonderheal XT40 Shades
23129~5World Enlarger
30548~5Zapthrottle Mote Extractor
7934~6Anti-Venom
3276~6Heavy Linen Bandage
10841~6Heavy Mageweave Bandage
27033~6Heavy Netherweave Bandage
18630~6Heavy Runecloth Bandage
7929~6Heavy Silk Bandage
3278~6Heavy Wool Bandage
3275~6Linen Bandage
10840~6Mageweave Bandage
27032~6Netherweave Bandage
23787~6Powerful Anti-Venom
18629~6Runecloth Bandage
7928~6Silk Bandage
7935~6Strong Anti-Venom
3277~6Wool Bandage
59487~7Arcane Tarot
52739~7Armor Vellum
59499~7Armor Vellum II
59500~7Armor Vellum III
59496~7Book of Clever Tricks
59490~7Book of Stars
59478~7Book of Survival
57709~7Celestial Ink
59387~7Certificate of Ownership
57714~7Darkflame Ink
59502~7Darkmoon Card
59504~7Darkmoon Card of the North
57706~7Dawnstar Ink
57713~7Ethereal Ink
59498~7Faces of Doom
57710~7Fiery Ink
59489~7Fire Eater's Guide
56994~7Glyph of Aimed Shot
57113~7Glyph of Ambush
57207~7Glyph of Anti-Magic Shell
56991~7Glyph of Arcane Blast
56968~7Glyph of Arcane Explosion
58303~7Glyph of Arcane Intellect
56971~7Glyph of Arcane Missiles
56972~7Glyph of Arcane Power
56995~7Glyph of Arcane Shot
56997~7Glyph of Aspect of the Monkey
56998~7Glyph of Aspect of the Viper
58329~7Glyph of Astral Recall
57114~7Glyph of Backstab
57257~7Glyph of Banish
57151~7Glyph of Barbaric Insults
58342~7Glyph of Battle
56999~7Glyph of Bestial Wrath
56990~7Glyph of Blast Wave
58314~7Glyph of Blessing of Might
58312~7Glyph of Blessing of Wisdom
56973~7Glyph of Blink
59339~7Glyph of Blood Strike
57209~7Glyph of Blood Tap
58343~7Glyph of Bloodrage
57153~7Glyph of Bloodthirst
58323~7Glyph of Blurred Speed
57210~7Glyph of Bone Shield
57232~7Glyph of Chain Heal
58344~7Glyph of Charge
57020~7Glyph of Cleansing
57154~7Glyph of Cleaving
57023~7Glyph of Consecration
57229~7Glyph of Corpse Explosion
57259~7Glyph of Corruption
57024~7Glyph of Crusader Strike
57260~7Glyph of Curse of Agony
59315~7Glyph of Dash
57117~7Glyph of Deadly Throw
57213~7Glyph of Death Grip
59340~7Glyph of Death Strike
57215~7Glyph of Death's Embrace
57000~7Glyph of Deterrence
57001~7Glyph of Disengage
57183~7Glyph of Dispel Magic
57031~7Glyph of Divinity
58337~7Glyph of Drain Soul
57236~7Glyph of Earthliving Weapon
57250~7Glyph of Elemental Mastery
58347~7Glyph of Enduring Victory
58339~7Glyph of Enslave Demon
48121~7Glyph of Entangling Roots
57119~7Glyph of Evasion
57120~7Glyph of Eviscerate
56974~7Glyph of Evocation
57156~7Glyph of Execution
57025~7Glyph of Exorcism
57121~7Glyph of Expose Armor
57184~7Glyph of Fade
58317~7Glyph of Fading
57262~7Glyph of Fear
57185~7Glyph of Fear Ward
57122~7Glyph of Feint
57264~7Glyph of Felhunter
57238~7Glyph of Fire Nova Totem
58305~7Glyph of Fire Ward
56975~7Glyph of Fireball
57239~7Glyph of Flame Shock
57240~7Glyph of Flametongue Weapon
57186~7Glyph of Flash Heal
57026~7Glyph of Flash of Light
62162~7Glyph of Focus
58318~7Glyph of Fortitude
57002~7Glyph of Freezing Trap
56943~7Glyph of Frenzied Regeneration
58306~7Glyph of Frost Armor
56976~7Glyph of Frost Nova
57241~7Glyph of Frost Shock
57216~7Glyph of Frost Strike
57003~7Glyph of Frost Trap
58307~7Glyph of Frost Ward
61677~7Glyph of Frostfire
57123~7Glyph of Garrote
59326~7Glyph of Ghost Wolf
57125~7Glyph of Gouge
57027~7Glyph of Hammer of Justice
57157~7Glyph of Hamstring
57242~7Glyph of Healing Stream Totem
56945~7Glyph of Healing Touch
57265~7Glyph of Health Funnel
57266~7Glyph of Healthstone
57158~7Glyph of Heroic Strike
57029~7Glyph of Holy Light
57187~7Glyph of Holy Nova
57004~7Glyph of Hunter's Mark
56978~7Glyph of Ice Armor
56979~7Glyph of Ice Block
56980~7Glyph of Ice Lance
57219~7Glyph of Icy Touch
56981~7Glyph of Icy Veins
57268~7Glyph of Immolate
57005~7Glyph of Immolation Trap
57269~7Glyph of Imp
57006~7Glyph of Improved Aspect of the Hawk
56982~7Glyph of Improved Scorch
57188~7Glyph of Inner Fire
56948~7Glyph of Insect Swarm
57159~7Glyph of Intervene
56983~7Glyph of Invisibility
57030~7Glyph of Judgement
58340~7Glyph of Kilrogg
57234~7Glyph of Lava
57249~7Glyph of Lava Lash
58313~7Glyph of Lay on Hands
57244~7Glyph of Lesser Healing Wave
58319~7Glyph of Levitate
56949~7Glyph of Lifebloom
57245~7Glyph of Lightning Bolt
57246~7Glyph of Lightning Shield
56984~7Glyph of Mage Armor
56985~7Glyph of Mana Gem
57247~7Glyph of Mana Tide Totem
56950~7Glyph of Mangle
56961~7Glyph of Maul
58301~7Glyph of Mend Pet
57192~7Glyph of Mind Flay
58345~7Glyph of Mocking Blow
56951~7Glyph of Moonfire
57007~7Glyph of Multi-Shot
57220~7Glyph of Obliterate
57161~7Glyph of Overpower
58325~7Glyph of Pick Lock
58326~7Glyph of Pick Pocket
57221~7Glyph of Plague Strike
56987~7Glyph of Polymorph
58300~7Glyph of Possessed Strength
57194~7Glyph of Power Word: Shield
57195~7Glyph of Prayer of Healing
57196~7Glyph of Psychic Scream
57228~7Glyph of Raise Dead
56952~7Glyph of Rake
57162~7Glyph of Rapid Charge
57008~7Glyph of Rapid Fire
56953~7Glyph of Rebirth
56954~7Glyph of Regrowth
56955~7Glyph of Rejuvenation
57163~7Glyph of Rending
57197~7Glyph of Renew
58330~7Glyph of Renewed Life
57165~7Glyph of Revenge
57032~7Glyph of Righteous Defense
56956~7Glyph of Rip
57223~7Glyph of Rune Strike
59338~7Glyph of Rune Tap
57129~7Glyph of Sap
58298~7Glyph of Scare Beast
57198~7Glyph of Scourge Imprisonment
57224~7Glyph of Scourge Strike
59559~7Glyph of Seal of Blood
57033~7Glyph of Seal of Command
57270~7Glyph of Searing Pain
58315~7Glyph of Sense Undead
57009~7Glyph of Serpent Sting
58320~7Glyph of Shackle Undead
57271~7Glyph of Shadow Bolt
58321~7Glyph of Shadow Protection
57200~7Glyph of Shadow Word: Pain
57272~7Glyph of Shadowburn
58322~7Glyph of Shadowfiend
57235~7Glyph of Shocking
56957~7Glyph of Shred
57131~7Glyph of Sinister Strike
57273~7Glyph of Siphon Life
57132~7Glyph of Slice and Dice
58308~7Glyph of Slow Fall
57201~7Glyph of Smite
57010~7Glyph of Snake Trap
58341~7Glyph of Souls
57274~7Glyph of Soulstone
57022~7Glyph of Spiritual Attunement
57133~7Glyph of Sprint
56958~7Glyph of Starfall
56959~7Glyph of Starfire
57248~7Glyph of Stormstrike
57225~7Glyph of Strangulate
57275~7Glyph of Succubus
57167~7Glyph of Sunder Armor
57168~7Glyph of Sweeping Strikes
58289~7Glyph of Thorns
57036~7Glyph of Turn Evil
57226~7Glyph of Unbreakable Armor
58288~7Glyph of Unburdened Rebirth
58336~7Glyph of Unending Breath
57227~7Glyph of Vampiric Blood
58328~7Glyph of Vanish
57277~7Glyph of Voidwalker
57013~7Glyph of Volley
56989~7Glyph of Water Elemental
57251~7Glyph of Water Mastery
58333~7Glyph of Water Walking
57172~7Glyph of Whirlwind
57252~7Glyph of Windfury Weapon
56963~7Glyph of Wrath
57222~7Glyph of the Ghoul
58297~7Glyph of the Pack
58310~7Glyph of the Penguin
58296~7Glyph of the Wild
58316~7Glyph of the Wise
59503~7Greater Darkmoon Card
59495~7Hellfire Tome
57703~7Hunter's Ink
57715~7Ink of the Sea
57712~7Ink of the Sky
59497~7Iron-bound Tome
52738~7Ivory Ink
57707~7Jadefire Ink
57704~7Lion's Ink
59494~7Manual of Clouds
61117~7Master's Inscription of the Axe
61118~7Master's Inscription of the Crag
61119~7Master's Inscription of the Pinnacle
61120~7Master's Inscription of the Storm
53462~7Midnight Ink
61288~7Minor Inscription Research
52843~7Moonglow Ink
48247~7Mysterious Tarot
58565~7Mystic Tome
61177~7Northrend Inscription Research
59486~7Royal Guide of Escape Routes
57708~7Royal Ink
58472~7Scroll of Agility
58473~7Scroll of Agility II
58476~7Scroll of Agility III
58478~7Scroll of Agility IV
58480~7Scroll of Agility V
58481~7Scroll of Agility VI
58482~7Scroll of Agility VII
58483~7Scroll of Agility VIII
48114~7Scroll of Intellect
50598~7Scroll of Intellect II
50599~7Scroll of Intellect III
50600~7Scroll of Intellect IV
50601~7Scroll of Intellect V
50602~7Scroll of Intellect VI
50603~7Scroll of Intellect VII
50604~7Scroll of Intellect VIII
48248~7Scroll of Recall
60336~7Scroll of Recall II
60337~7Scroll of Recall III
48116~7Scroll of Spirit
50605~7Scroll of Spirit II
50606~7Scroll of Spirit III
50607~7Scroll of Spirit IV
50608~7Scroll of Spirit V
50609~7Scroll of Spirit VI
50610~7Scroll of Spirit VII
50611~7Scroll of Spirit VIII
45382~7Scroll of Stamina
50612~7Scroll of Stamina II
50614~7Scroll of Stamina III
50616~7Scroll of Stamina IV
50617~7Scroll of Stamina V
50618~7Scroll of Stamina VI
50619~7Scroll of Stamina VII
50620~7Scroll of Stamina VIII
58484~7Scroll of Strength
58485~7Scroll of Strength II
58486~7Scroll of Strength III
58487~7Scroll of Strength IV
58488~7Scroll of Strength V
58489~7Scroll of Strength VI
58490~7Scroll of Strength VII
58491~7Scroll of Strength VIII
59491~7Shadowy Tarot
57711~7Shimmering Ink
57716~7Snowfall Ink
59493~7Stormbound Tome
59480~7Strange Tarot
59484~7Tome of Kings
59475~7Tome of the Dawn
52840~7Weapon Vellum
59488~7Weapon Vellum II
59501~7Weapon Vellum III
53892~8Accurate Huge Citrine
25339~8Amulet of the Moon
26876~8Aquamarine Pendant of the Warrior
26874~8Aquamarine Signet
31050~8Azure Moonstone Ring
53866~8Balanced Shadow Crystal
26916~8Band of Natural Fire
25498~8Barbaric Iron Collar
25617~8Blazing Citrine Ring
56193~8Bloodstone Band
28905~8Bold Blood Garnet
53831~8Bold Bloodstone
31084~8Bold Living Ruby
32867~8Bracing Earthstorm Diamond
25493~8Braided Copper Ring
34590~8Bright Blood Garnet
53835~8Bright Bloodstone
31089~8Bright Living Ruby
47280~8Brilliant Glass
28938~8Brilliant Golden Draenite
36523~8Brilliant Necklace
41414~8Brilliant Pearl Band
53852~8Brilliant Sun Crystal
37818~8Bronze Band of Force
25278~8Bronze Setting
38175~8Bronze Torc
32869~8Brutal Earthstorm Diamond
53874~8Champion's Huge Citrine
25621~8Citrine Ring of Rapid Healing
32801~8Coarse Stone Statue
58142~8Crystal Chalcedony Amulet
58141~8Crystal Citrine Necklace
56205~8Dark Jade Focusing Lens
53926~8Dazzling Dark Jade
31112~8Dazzling Talasite
53880~8Deft Huge Citrine
53832~8Delicate Bloodstone
25255~8Delicate Copper Wire
32809~8Dense Stone Statue
32871~8Destructive Skyfire Diamond
36526~8Diamond Focus Ring
25280~8Elegant Silver Ring
26906~8Emerald Crown of Destruction
34961~8Emerald Lion Ring
53918~8Enduring Dark Jade
28918~8Enduring Deep Peridot
31110~8Enduring Talasite
53930~8Energized Dark Jade
25620~8Engraved Truesilver Ring
32874~8Enigmatic Skyfire Diamond
53873~8Etched Huge Citrine
31071~8Eye of the Night
42590~8Falling Star
31048~8Fel Iron Blood Ring
53876~8Fierce Huge Citrine
26875~8Figurine - Black Pearl Panther
26909~8Figurine - Emerald Owl
26873~8Figurine - Golden Hare
26872~8Figurine - Jade Owl
26900~8Figurine - Ruby Serpent
26882~8Figurine - Truesilver Boar
26881~8Figurine - Truesilver Crab
53844~8Flashing Bloodstone
31091~8Flashing Living Ruby
53920~8Forceful Dark Jade
53845~8Fractured Bloodstone
26896~8Gem Studded Band
28944~8Gleaming Golden Draenite
28914~8Glinting Flame Spessarite
53878~8Glinting Huge Citrine
31109~8Glinting Noble Topaz
25287~8Gloom Band
31104~8Glowing Nightseye
53862~8Glowing Shadow Crystal
28925~8Glowing Shadow Draenite
34960~8Glowing Thorium Band
31049~8Golden Draenite Ring
25613~8Golden Dragon Ring
34955~8Golden Ring of Power
39451~8Great Golden Draenite
53871~8Guardian's Shadow Crystal
31052~8Heavy Adamantite Ring
26926~8Heavy Copper Ring
25320~8Heavy Golden Necklace of Battle
25612~8Heavy Iron Knuckles
36524~8Heavy Jade Ring
25305~8Heavy Silver Ring
32807~8Heavy Stone Statue
53867~8Infused Shadow Crystal
25283~8Inlaid Malachite Ring
28910~8Inscribed Flame Spessarite
53872~8Inscribed Huge Citrine
32870~8Insightful Earthstorm Diamond
53925~8Intricate Dark Jade
25618~8Jade Pendant of Blasting
53916~8Jagged Dark Jade
28917~8Jagged Deep Peridot
31054~8Khorium Band of Frost
31055~8Khorium Inferno Band
53928~8Lambent Dark Jade
26911~8Living Emerald Pendant
28912~8Luminous Flame Spessarite
53881~8Luminous Huge Citrine
31108~8Luminous Noble Topaz
53941~8Lustrous Chalcedony
32178~8Malachite Pendant
38068~8Mercurial Adamantite
53922~8Misty Dark Jade
25615~8Mithril Filigree
25321~8Moonsoul Crown
31101~8Mystic Dawnstone
40514~8Necklace of the Deep
26915~8Necklace of the Diamond Tower
26907~8Onslaught Ring
26897~8Opal Necklace of Impact
26928~8Ornate Tigerseye Necklace
25610~8Pendant of the Agate Shield
53882~8Potent Huge Citrine
32866~8Powerful Earthstorm Diamond
54017~8Precise Bloodstone
53887~8Pristine Huge Citrine
53870~8Puissant Shadow Crystal
41420~8Purified Jaggal Pearl
53863~8Purified Shadow Crystal
41429~8Purified Shadow Pearl
53856~8Quick Sun Crystal
53931~8Radiant Dark Jade
28916~8Radiant Deep Peridot
31111~8Radiant Talasite
36525~8Red Ring of Destruction
53893~8Resolute Huge Citrine
28948~8Rigid Golden Draenite
53854~8Rigid Sun Crystal
26910~8Ring of Bitter Shadows
25317~8Ring of Silver Might
25318~8Ring of Twilight Shadows
32259~8Rough Stone Statue
31105~8Royal Nightseye
53864~8Royal Shadow Crystal
28927~8Royal Shadow Draenite
26878~8Ruby Crown of Restoration
26883~8Ruby Pendant of Fire
53834~8Runed Bloodstone
31088~8Runed Living Ruby
26908~8Sapphire Pendant of Winter Night
26903~8Sapphire Signet
53921~8Seer's Dark Jade
58146~8Shadowmight Ring
31103~8Shifting Nightseye
53860~8Shifting Shadow Crystal
28933~8Shifting Shadow Draenite
53923~8Shining Dark Jade
26902~8Simple Opal Ring
25284~8Simple Pearl Ring
34069~8Smooth Golden Draenite
53853~8Smooth Sun Crystal
28950~8Solid Azure Moonstone
25490~8Solid Bronze Ring
53934~8Solid Chalcedony
31092~8Solid Star of Elune
32808~8Solid Stone Statue
31102~8Sovereign Nightseye
53859~8Sovereign Shadow Crystal
28936~8Sovereign Shadow Draenite
28953~8Sparkling Azure Moonstone
53940~8Sparkling Chalcedony
53890~8Stalwart Huge Citrine
53889~8Stark Huge Citrine
43493~8Steady Talasite
56194~8Sun Rock Ring
53927~8Sundered Dark Jade
32873~8Swift Skyfire Diamond
28903~8Teardrop Blood Garnet
31087~8Teardrop Living Ruby
53861~8Tenuous Shadow Crystal
26887~8The Aquamarine Ward
41415~8The Black Pearl
25619~8The Jade Eye
31051~8Thick Adamantite Necklace
26927~8Thick Bronze Necklace
53855~8Thick Sun Crystal
26880~8Thorium Setting
39963~8Thundering Skyfire Diamond
32179~8Tigerseye Band
53894~8Timeless Dark Jade
34959~8Truesilver Commander's Ring
26885~8Truesilver Healing Ring
39466~8Veiled Flame Spessarite
53883~8Veiled Huge Citrine
39467~8Wicked Flame Spessarite
53886~8Wicked Huge Citrine
25323~8Wicked Moonstone Ring
39471~8Wicked Noble Topaz
26925~8Woven Copper Ring
45117~9Bag of Many Hides
3779~9Barbaric Belt
23399~9Barbaric Bracers
3771~9Barbaric Gloves
6661~9Barbaric Harness
7149~9Barbaric Leggings
7151~9Barbaric Shoulders
36352~9Belt of the Black Eagle
10562~9Big Voodoo Cloak
10531~9Big Voodoo Mask
10560~9Big Voodoo Pants
10520~9Big Voodoo Robe
19085~9Black Dragonscale Breastplate
19107~9Black Dragonscale Leggings
19094~9Black Dragonscale Shoulders
9070~9Black Whelp Cloak
35537~9Blastguard Belt
19077~9Blue Dragonscale Breastplate
24654~9Blue Dragonscale Leggings
19089~9Blue Dragonscale Shoulders
19063~9Chimeric Boots
19053~9Chimeric Gloves
19073~9Chimeric Leggings
19081~9Chimeric Vest
35555~9Clefthide Leg Armor
35549~9Cobrahide Leg Armor
10490~9Comfortable Leather Hat
3818~9Cured Heavy Hide
3816~9Cured Light Hide
3817~9Cured Medium Hide
19047~9Cured Rugged Hide
10482~9Cured Thick Hide
3766~9Dark Leather Belt
2167~9Dark Leather Boots
2168~9Dark Leather Cloak
3765~9Dark Leather Gloves
7135~9Dark Leather Pants
3769~9Dark Leather Shoulders
2169~9Dark Leather Tunic
7955~9Deviate Scale Belt
7953~9Deviate Scale Cloak
7954~9Deviate Scale Gloves
19084~9Devilsaur Gauntlets
19097~9Devilsaur Leggings
10650~9Dragonscale Breastplate
10619~9Dragonscale Gauntlets
36076~9Dragonstrike Leggings
35540~9Drums of War
9206~9Dusky Belt
9207~9Dusky Boots
9201~9Dusky Bracers
9196~9Dusky Leather Armor
9195~9Dusky Leather Leggings
9147~9Earthen Leather Shoulders
35576~9Ebon Netherscale Belt
35577~9Ebon Netherscale Bracers
35575~9Ebon Netherscale Breastplate
2161~9Embossed Leather Boots
2162~9Embossed Leather Cloak
3756~9Embossed Leather Gloves
3759~9Embossed Leather Pants
2160~9Embossed Leather Vest
10647~9Feathered Breastplate
32490~9Fel Leather Gloves
32463~9Felscale Boots
32465~9Felscale Breastplate
32462~9Felscale Gloves
32464~9Felscale Pants
32498~9Felstalker Belt
32499~9Felstalker Bracer
32500~9Felstalker Breastplate
3763~9Fine Leather Belt
2158~9Fine Leather Boots
2159~9Fine Leather Cloak
2164~9Fine Leather Gloves
7133~9Fine Leather Pants
3761~9Fine Leather Tunic
35528~9Flamescale Boots
9145~9Fletcher's Gloves
35522~9Frost Armor Kit
9198~9Frost Leather Cloak
19066~9Frostsaber Boots
19087~9Frostsaber Gloves
19074~9Frostsaber Leggings
19104~9Frostsaber Tunic
10630~9Gauntlets of the Sea
3778~9Gem-studded Leather Belt
44770~9Glove Reinforcements
36079~9Golden Dragonstrike Breastplate
19050~9Green Dragonscale Breastplate
24655~9Green Dragonscale Gauntlets
19060~9Green Dragonscale Leggings
3772~9Green Leather Armor
3774~9Green Leather Belt
3776~9Green Leather Bracers
9197~9Green Whelp Armor
9202~9Green Whelp Bracers
3773~9Guardian Armor
3775~9Guardian Belt
7153~9Guardian Cloak
7156~9Guardian Gloves
3777~9Guardian Leather Bracers
7147~9Guardian Pants
3753~9Handstitched Leather Belt
2149~9Handstitched Leather Boots
9059~9Handstitched Leather Bracers
9058~9Handstitched Leather Cloak
2153~9Handstitched Leather Pants
7126~9Handstitched Leather Vest
3780~9Heavy Armor Kit
32497~9Heavy Clefthoof Boots
32496~9Heavy Clefthoof Leggings
32495~9Heavy Clefthoof Vest
9149~9Heavy Earthen Gloves
44970~9Heavy Knothide Armor Kit
32455~9Heavy Knothide Leather
20649~9Heavy Leather
9194~9Heavy Leather Ammo Pouch
23190~9Heavy Leather Ball
9193~9Heavy Quiver
19070~9Heavy Scorpid Belt
19048~9Heavy Scorpid Bracers
19064~9Heavy Scorpid Gauntlets
19088~9Heavy Scorpid Helm
19075~9Heavy Scorpid Leggings
19100~9Heavy Scorpid Shoulders
19051~9Heavy Scorpid Vest
10632~9Helm of Fire
9146~9Herbalist's Gloves
3767~9Hillman's Belt
3760~9Hillman's Cloak
3764~9Hillman's Leather Gloves
3762~9Hillman's Leather Vest
3768~9Hillman's Shoulders
35561~9Hood of Primal Life
19086~9Ironfeather Breastplate
19062~9Ironfeather Shoulders
32456~9Knothide Armor Kit
32454~9Knothide Leather
44344~9Knothide Quiver
5244~9Kodo Hide Bag
2152~9Light Armor Kit
2881~9Light Leather
9065~9Light Leather Bracers
9068~9Light Leather Pants
9060~9Light Leather Quiver
19095~9Living Breastplate
35564~9Living Dragonscale Helm
19078~9Living Leggings
19061~9Living Shoulders
2165~9Medium Armor Kit
20648~9Medium Leather
8322~9Moonglow Vest
6702~9Murloc Scale Belt
6705~9Murloc Scale Bracers
6703~9Murloc Scale Breastplate
35557~9Nethercleft Leg Armor
35554~9Nethercobra Leg Armor
35573~9Netherdrake Gloves
32501~9Netherfury Belt
32502~9Netherfury Leggings
44768~9Netherscale Ammo Pouch
10558~9Nightscape Boots
10550~9Nightscape Cloak
10507~9Nightscape Headband
10548~9Nightscape Pants
10516~9Nightscape Shoulders
10499~9Nightscape Tunic
9074~9Nimble Leather Gloves
19106~9Onyxia Scale Breastplate
19093~9Onyxia Scale Cloak
9148~9Pilferer's Gloves
14930~9Quickdraw Quiver
44359~9Quiver of a Thousand Feathers
4097~9Raptor Hide Belt
4096~9Raptor Hide Harness
19054~9Red Dragonscale Breastplate
9072~9Red Whelp Gloves
35530~9Reinforced Mining Bag
32461~9Riding Crop
19058~9Rugged Armor Kit
22331~9Rugged Leather
9064~9Rugged Leather Pants
19102~9Runic Leather Armor
19072~9Runic Leather Belt
19065~9Runic Leather Bracers
19055~9Runic Leather Gauntlets
19082~9Runic Leather Headband
19091~9Runic Leather Pants
19103~9Runic Leather Shoulders
32469~9Scaled Draenic Boots
32467~9Scaled Draenic Gloves
32466~9Scaled Draenic Pants
32468~9Scaled Draenic Vest
42731~9Shadowprowler's Chestguard
9062~9Small Leather Ammo Pouch
19079~9Stormshroud Armor
19067~9Stormshroud Pants
19090~9Stormshroud Shoulders
32487~9Stylin' Adventure Hat
32489~9Stylin' Jungle Hat
32485~9Stylin' Purple Hat
9208~9Swift Boots
10487~9Thick Armor Kit
32472~9Thick Draenic Boots
32470~9Thick Draenic Gloves
32471~9Thick Draenic Pants
32473~9Thick Draenic Vest
20650~9Thick Leather
14932~9Thick Leather Ammo Pouch
6704~9Thick Murloc Armor
35574~9Thick Netherscale Breastplate
10554~9Tough Scorpid Boots
10533~9Tough Scorpid Bracers
10525~9Tough Scorpid Breastplate
10542~9Tough Scorpid Gloves
10570~9Tough Scorpid Helm
10568~9Tough Scorpid Leggings
10564~9Tough Scorpid Shoulders
2166~9Toughened Leather Armor
3770~9Toughened Leather Gloves
10518~9Turtle Scale Bracers
10511~9Turtle Scale Breastplate
10509~9Turtle Scale Gloves
10552~9Turtle Scale Helm
10556~9Turtle Scale Leggings
19076~9Volcanic Breastplate
19059~9Volcanic Leggings
19101~9Volcanic Shoulders
19068~9Warbear Harness
19080~9Warbear Woolies
2163~9White Leather Jerkin
19098~9Wicked Leather Armor
19092~9Wicked Leather Belt
19052~9Wicked Leather Bracers
19049~9Wicked Leather Gauntlets
19071~9Wicked Leather Headband
19083~9Wicked Leather Pants
32478~9Wild Draenish Boots
32479~9Wild Draenish Gloves
32480~9Wild Draenish Leggings
32481~9Wild Draenish Vest
10566~9Wild Leather Boots
10574~9Wild Leather Cloak
10546~9Wild Leather Helmet
10572~9Wild Leather Leggings
10529~9Wild Leather Shoulders
10544~9Wild Leather Vest
35563~9Windslayer Wraps
44953~9Winter Boots
10621~9Wolfshead Helm
35750~AEarth Shatter
35751~AFire Sunder
29358~ASmelt Adamantite
2659~ASmelt Bronze
2657~ASmelt Copper
14891~ASmelt Dark Iron
29359~ASmelt Eternium
29356~ASmelt Fel Iron
29360~ASmelt Felsteel
3308~ASmelt Gold
29686~ASmelt Hardened Adamantite
3307~ASmelt Iron
29361~ASmelt Khorium
10097~ASmelt Mithril
2658~ASmelt Silver
3569~ASmelt Steel
16153~ASmelt Thorium
3304~ASmelt Tin
55208~ASmelt Titansteel
10098~ASmelt Truesilver
12081~BAdmiral's Hat
26783~BArcanoweave Boots
26782~BArcanoweave Bracers
26784~BArcanoweave Robe
56023~BAurora Slippers
8795~BAzure Shoulders
8766~BAzure Silk Belt
8786~BAzure Silk Cloak
3854~BAzure Silk Gloves
8760~BAzure Silk Hood
8758~BAzure Silk Pants
3859~BAzure Silk Vest
56010~BAzure Spellthread
31459~BBag of Jewels
2395~BBarbaric Linen Vest
31456~BBattlecast Hood
31453~BBattlecast Pants
36315~BBelt of Blasting
27660~BBig Bag of Enchantment
55925~BBlack Duskweave Leggings
55941~BBlack Duskweave Robe
55943~BBlack Duskweave Wristwraps
12073~BBlack Mageweave Boots
12053~BBlack Mageweave Gloves
12072~BBlack Mageweave Headband
12049~BBlack Mageweave Leggings
12050~BBlack Mageweave Robe
12074~BBlack Mageweave Shoulders
12048~BBlack Mageweave Vest
6695~BBlack Silk Pack
3873~BBlack Swashbuckler's Shirt
31437~BBlackstrike Bracers
7633~BBlue Linen Robe
2394~BBlue Linen Shirt
7630~BBlue Linen Vest
7639~BBlue Overalls
55899~BBolt of Frostweave
55900~BBolt of Imbued Frostweave
26747~BBolt of Imbued Netherweave
2963~BBolt of Linen Cloth
3865~BBolt of Mageweave
26745~BBolt of Netherweave
18401~BBolt of Runecloth
3839~BBolt of Silk Cloth
26750~BBolt of Soulcloth
2964~BBolt of Woolen Cloth
8778~BBoots of Darkness
3860~BBoots of the Enchanter
18455~BBottomless Bag
31435~BBracers of Havok
3869~BBright Yellow Shirt
18420~BBrightcloth Cloak
18415~BBrightcloth Gloves
18439~BBrightcloth Pants
18414~BBrightcloth Robe
3914~BBrown Linen Pants
7623~BBrown Linen Robe
3915~BBrown Linen Shirt
2385~BBrown Linen Vest
27724~BCenarion Herb Bag
12088~BCindercloth Boots
18418~BCindercloth Cloak
18412~BCindercloth Gloves
18434~BCindercloth Pants
12069~BCindercloth Robe
18408~BCindercloth Vest
37873~BCloak of Arcane Evasion
31440~BCloak of Eternity
18422~BCloak of Fire
56015~BCloak of Frozen Spirits
31438~BCloak of the Black Void
56014~BCloak of the Moon
12047~BColorful Kilt
8772~BCrimson Silk Belt
8789~BCrimson Silk Cloak
8804~BCrimson Silk Gloves
8799~BCrimson Silk Pantaloons
8802~BCrimson Silk Robe
8793~BCrimson Silk Shoulders
8791~BCrimson Silk Vest
3870~BDark Silk Shirt
55769~BDarkglow Embroidery
56020~BDeep Frozen Cord
3848~BDouble-stitched Woolen Shoulders
12092~BDreamweave Circlet
12067~BDreamweave Gloves
12070~BDreamweave Vest
55914~BDuskweave Belt
55924~BDuskweave Boots
55919~BDuskweave Cowl
55922~BDuskweave Gloves
55901~BDuskweave Leggings
55921~BDuskweave Robe
55923~BDuskweave Shoulders
55920~BDuskweave Wristwraps
8797~BEarthen Silk Belt
8764~BEarthen Vest
26759~BEbon Shadowbag
56002~BEbonweave
27658~BEnchanted Mageweave Pouch
27659~BEnchanted Runecloth Bag
3857~BEnchanter's Cowl
26086~BFelcloth Bag
18437~BFelcloth Boots
18442~BFelcloth Hood
18419~BFelcloth Pants
18451~BFelcloth Robe
18453~BFelcloth Shoulders
26403~BFestival Dress
26407~BFestive Red Pant Suit
37882~BFlameheart Bracers
37883~BFlameheart Gloves
37884~BFlameheart Vest
60969~BFlying Carpet
3871~BFormal White Shirt
56021~BFrostmoon Pants
59582~BFrostsavage Belt
59585~BFrostsavage Boots
59583~BFrostsavage Bracers
59589~BFrostsavage Cowl
59586~BFrostsavage Gloves
59588~BFrostsavage Leggings
59587~BFrostsavage Robe
59584~BFrostsavage Shoulders
56007~BFrostweave Bag
18411~BFrostweave Gloves
55898~BFrostweave Net
18424~BFrostweave Pants
18404~BFrostweave Robe
18403~BFrostweave Tunic
55908~BFrostwoven Belt
55906~BFrostwoven Boots
55907~BFrostwoven Cowl
55904~BFrostwoven Gloves
56030~BFrostwoven Leggings
55903~BFrostwoven Robe
55902~BFrostwoven Shoulders
56031~BFrostwoven Wristwraps
18410~BGhostweave Belt
18413~BGhostweave Gloves
18441~BGhostweave Pants
18416~BGhostweave Vest
31443~BGirdle of Ruination
56005~BGlacial Bag
60993~BGlacial Robe
60994~BGlacial Slippers
60990~BGlacial Waistband
3852~BGloves of Meditation
18454~BGloves of Spell Mastery
31433~BGolden Spellthread
2403~BGray Woolen Robe
2406~BGray Woolen Shirt
7643~BGreater Adept's Robe
3841~BGreen Linen Bracers
2396~BGreen Linen Shirt
8784~BGreen Silk Armor
6693~BGreen Silk Pack
8774~BGreen Silken Shoulders
44950~BGreen Winter Clothes
3758~BGreen Woolen Bag
7636~BGreen Woolen Robe
2399~BGreen Woolen Vest
56000~BGreen Workman's Shirt
8780~BHands of Darkness
3842~BHandstitched Linen Britches
56018~BHat of Wintry Doom
3840~BHeavy Linen Gloves
3844~BHeavy Woolen Cloak
3843~BHeavy Woolen Gloves
3850~BHeavy Woolen Pants
3862~BIcy Cloak
26749~BImbued Netherweave Bag
26776~BImbued Netherweave Boots
26775~BImbued Netherweave Pants
26777~BImbued Netherweave Robe
26778~BImbued Netherweave Tunic
12075~BLavender Mageweave Shirt
6690~BLesser Wizard's Robe
56022~BLight Blessed Mittens
3755~BLinen Bag
8776~BLinen Belt
2386~BLinen Boots
2387~BLinen Cloak
3861~BLong Silken Cloak
12065~BMageweave Bag
60971~BMagnificent Flying Carpet
31450~BManaweave Cloak
56034~BMaster's Spellthread
18560~BMooncloth
18445~BMooncloth Bag
19435~BMooncloth Boots
18452~BMooncloth Circlet
18440~BMooncloth Leggings
22902~BMooncloth Robe
18448~BMooncloth Shoulders
18447~BMooncloth Vest
56001~BMoonshroud
50194~BMycah's Botanical Bag
55911~BMystic Frostwoven Robe
55910~BMystic Frostwoven Shoulders
55913~BMystic Frostwoven Wristwraps
31430~BMystic Spellthread
26746~BNetherweave Bag
26765~BNetherweave Belt
26772~BNetherweave Boots
26764~BNetherweave Bracers
26770~BNetherweave Gloves
31460~BNetherweave Net
26771~BNetherweave Pants
26773~BNetherweave Robe
26774~BNetherweave Tunic
12061~BOrange Mageweave Shirt
12064~BOrange Martial Shirt
6521~BPearl-clasped Cloak
3868~BPhoenix Gloves
3851~BPhoenix Pants
12080~BPink Mageweave Shirt
26751~BPrimal Mooncloth
26763~BPrimal Mooncloth Bag
26760~BPrimal Mooncloth Belt
26762~BPrimal Mooncloth Robe
26761~BPrimal Mooncloth Shoulders
6686~BRed Linen Bag
2389~BRed Linen Robe
2392~BRed Linen Shirt
7629~BRed Linen Vest
12079~BRed Mageweave Bag
12066~BRed Mageweave Gloves
12084~BRed Mageweave Headband
12060~BRed Mageweave Pants
12078~BRed Mageweave Shoulders
12056~BRed Mageweave Vest
8489~BRed Swashbuckler's Shirt
44958~BRed Winter Clothes
6688~BRed Woolen Bag
3847~BRed Woolen Boots
2397~BReinforced Linen Cape
3849~BReinforced Woolen Shoulders
31448~BResolute Cape
3872~BRich Purple Silk Shirt
8770~BRobe of Power
18436~BRobe of Winter Night
18457~BRobe of the Archmage
18458~BRobe of the Void
6692~BRobes of Arcana
18405~BRunecloth Bag
18402~BRunecloth Belt
18423~BRunecloth Boots
18409~BRunecloth Cloak
18417~BRunecloth Gloves
18444~BRunecloth Headband
18438~BRunecloth Pants
18406~BRunecloth Robe
18449~BRunecloth Shoulders
18407~BRunecloth Tunic
31432~BRunic Spellthread
27725~BSatchel of Cenarius
3858~BShadow Hood
36686~BShadowcloth
12082~BShadoweave Boots
12071~BShadoweave Gloves
12086~BShadoweave Mask
12052~BShadoweave Pants
12055~BShadoweave Robe
12076~BShadoweave Shoulders
56008~BShining Spellthread
8762~BSilk Headband
56019~BSilky Iceshard Boots
31431~BSilver Spellthread
12077~BSimple Black Dress
8465~BSimple Dress
12046~BSimple Kilt
12045~BSimple Linen Boots
12044~BSimple Linen Pants
3813~BSmall Silk Pack
3845~BSoft-soled Linen Boots
26085~BSoul Pouch
26779~BSoulcloth Gloves
26781~BSoulcloth Vest
31373~BSpellcloth
26755~BSpellfire Bag
26754~BSpellfire Robe
31455~BSpellstrike Hood
31452~BSpellstrike Pants
56003~BSpellweave
3863~BSpider Belt
3856~BSpider Silk Slippers
3855~BSpidersilk Boots
3864~BStar Belt
12090~BStormcloth Boots
12063~BStormcloth Gloves
12083~BStormcloth Headband
12062~BStormcloth Pants
12087~BStormcloth Shoulders
12068~BStormcloth Vest
7892~BStylish Blue Shirt
7893~BStylish Green Shirt
3866~BStylish Red Shirt
28482~BSylvan Shoulders
8782~BTruefaith Gloves
18456~BTruefaith Vestments
12093~BTuxedo Jacket
12089~BTuxedo Pants
12085~BTuxedo Shirt
31434~BUnyielding Bracers
31442~BUnyielding Girdle
31449~BVengeance Wrap
12059~BWhite Bandit Mask
7624~BWhite Linen Robe
2393~BWhite Linen Shirt
31441~BWhite Remedy Cape
8483~BWhite Swashbuckler's Shirt
12091~BWhite Wedding Dress
8467~BWhite Woolen Dress
31454~BWhitemend Hood
31451~BWhitemend Pants
18421~BWizardweave Leggings
18446~BWizardweave Robe
18450~BWizardweave Turban
3757~BWoolen Bag
2401~BWoolen Boots
2402~BWoolen Cape
55995~BYellow Lumberjack Shirt]]
