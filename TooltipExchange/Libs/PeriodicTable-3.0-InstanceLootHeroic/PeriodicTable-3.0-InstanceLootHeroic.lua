-- (c) 2007 Nymbia.  see LGPLv2.1.txt for full details.
--DO NOT MAKE CHANGES TO THIS FILE BEFORE READING THE WIKI PAGE REGARDING CHANGING THESE FILES
if not AceLibrary:HasInstance("PeriodicTable-3.0") then error("PT3 must be loaded before data") end
AceLibrary("PeriodicTable-3.0"):AddData("InstanceLootHeroic", "$Rev: 36866 $", {
	
	["InstanceLootHeroic.Auchindoun"]="m,InstanceLootHeroic.Auchenai Crypts,InstanceLootHeroic.Mana-Tombs,InstanceLootHeroic.Shadow Labyrinth,InstanceLootHeroic.Sethekk Halls",
	["InstanceLootHeroic.Auchenai Crypts.Exarch Maladaar"]="mpm:rs,i6s:rs,m1a:8z,l8j:48,mkp:3n,li5:3m,li7:3b,nln:38,nlm:36,mkc:2x,nlo:2o,li8:2n,li3:2f,li6:1t,mne:1o",
	["InstanceLootHeroic.Auchenai Crypts.Shirrak the Dead Watcher"]="mpm:rs,m1a:bv,lhi:43,li2:43,lhh:41,l7p:3x,li1:2p,lhj:2p",
	["InstanceLootHeroic.Mana-Tombs.Nexus-Prince Shaffar"]="mpm:rs,i6s:rs,m1a:av,lh3:3h,lgz:3f,lg6:3a,lhf:30,lhe:30,nll:2v,lhc:2q,lh9:2q,lh1:2g,mkk:2c,lhg:29,nlj:27,nk7:24,lze:24,mk8:22,lww:1z,nlk:1p,lh0:1n,lh7:1g,mnc:13",
	["InstanceLootHeroic.Mana-Tombs.Pandemonius"]="mpm:rs,m1a:e6,lgp:41,lgq:3i,lgm:3e,lgo:38,lgl:33,lgn:2q",
	["InstanceLootHeroic.Mana-Tombs.Tavarok"]="mpm:rs,m1a:cl,lgu:3s,lgx:3q,lgt:3e,lgw:3e,lgy:2z,lgv:2z",
	["InstanceLootHeroic.Shadow Labyrinth.Ambassador Hellmaw"]="mpm:rs,m1a:c5,lip:4o,lil:4n,lik:3z,lin:3k,lim:38,lio:34",
	["InstanceLootHeroic.Shadow Labyrinth.Blackheart the Inciter"]="mpm:rs,m1a:dc,l70:4d,lis:42,lit:3i,lir:3f,liq:38,lpi:36,juo:7",
	["InstanceLootHeroic.Shadow Labyrinth.Grandmaster Vorpil"]="mpm:rs,m1a:ds,lfj:5g,liy:54,lj0:4u,lix:4i,lj1:3q",
	["InstanceLootHeroic.Shadow Labyrinth.Murmur"]="mpm:rs,i6s:rs,m1a:a4,oh6:7c,lj9:44,lj2:40,lj3:3x,ljc:3n,ls8:3k,ls6:3e,lfm:3b,lj5:37,ljd:37,lja:2y,lj8:2t,lgb:2d,nkw:2b,nkz:28,nkv:26,nk4:24,mkt:22,mk9:20,mnd:q,ir9:7",
	["InstanceLootHeroic.Sethekk Halls.Darkweaver Syth"]="mpm:rs,m1a:b5,jn9:82,ljf:4i,ljg:47,lje:43,ljh:40,lji:3s,ljj:3q,in4:4",
	["InstanceLootHeroic.Sethekk Halls.Talon King Ikiss"]="mpm:rs,i6s:rs,llj:rh,m1a:76,lk0:3d,ljp:37,lfk:2x,lka:2q,lha:2p,ll9:2k,lib:2j,ll8:2g,nkp:2g,mkh:29,lkc:29,lle:20,lld:20,mkr:1z,nkq:1p,nko:1h,mnf:u",

	["InstanceLootHeroic.Caverns of Time"]="m,InstanceLootHeroic.Old Hillsbrad Foothills,InstanceLootHeroic.The Black Morass",
	["InstanceLootHeroic.Old Hillsbrad Foothills.Captain Skarloc"]="mpm:rs,lrx:3t,lrv:3m,lrt:3f,lrw:39,lru:39,lrs:25",
	["InstanceLootHeroic.Old Hillsbrad Foothills.Epoch Hunter"]="mpm:rs,i6s:rs,lj4:3x,nlp:3o,ls0:3o,lry:37,nlr:35,lrz:2s,ljb:2s,lr3:2o,ls3:2f,mke:2b,ls1:2b,lvc:29,ls9:27,mki:1y,nk8:1o,ls2:1j,lwx:1h,nlq:10,mnh:q",
	["InstanceLootHeroic.Old Hillsbrad Foothills.Lieutenant Drake"]="mpm:rs,lrq:3z,lrp:3m,lrr:3i,lro:3e,lrm:37,lrn:2o",
	["InstanceLootHeroic.The Black Morass.Aeonus"]="lr2:50,lr4:4s,l85:4q,lhb:4n,mpm:4g,ll5:4b,lr5:43,lri:41,lr0:3h,lrj:3c,lr6:39,lr1:2z,li9:1o,i6s:1b,nku:16,mkf:11,mng:u,nk3:p,mkl:m,nkr:m,nks:c",
	["InstanceLootHeroic.The Black Morass.Chrono Lord Deja"]="mpm:rs,llo:4v,lln:4b,llg:3w,llm:3w,lll:37,llf:34",
	["InstanceLootHeroic.The Black Morass.Temporus"]="mpm:rs,lqx:4t,lmq:4q,lmp:43,lqw:3g,lqz:30,lqy:2t",

	["InstanceLootHeroic.Coilfang Reservoir"]="m,InstanceLootHeroic.The Slave Pens,InstanceLootHeroic.The Steamvault,InstanceLootHeroic.The Underbog",
	["InstanceLootHeroic.The Slave Pens.Mennu the Betrayer"]="mpm:rs,l95:47,l93:3z,l96:3y,l94:3t,l92:3s,l91:3o",
	["InstanceLootHeroic.The Slave Pens.Quagmirran"]="mpm:rs,i6s:rs,nm4:44,lg8:3f,lcp:3f,lem:3c,lel:3a,lds:37,nm5:33,lek:30,ldt:2z,nka:2x,lg4:2v,ldu:2v,lco:2u,mka:2u,nm3:2o,lv5:2l,lcz:2i,mn9:1l",
	["InstanceLootHeroic.The Slave Pens.Rokmar the Crackler"]="mpm:rs,l97:41,l9a:3y,lp8:3q,l9b:3i,l99:3d,l98:3d",
	["InstanceLootHeroic.The Steamvault.Hydromancer Thespia"]="mpm:rs,l84:4y,lfr:4y,lfv:4r,lfx:4j,lfs:40",
	["InstanceLootHeroic.The Steamvault.Mekgineer Steamrigger"]="mpm:rs,lfy:4x,lfz:4n,lg1:4g,lg2:40,lg0:3z,ifj:3",
	["InstanceLootHeroic.The Steamvault.Warlord Kalithresh"]="mpm:rs,i6s:rs,oh5:5c,lge:3x,l77:3s,lei:3q,lgd:3o,lg3:3i,leh:3h,lg7:3g,l86:36,lrf:31,nkn:30,lia:2x,lg9:2v,nkl:2o,nkm:2k,mkb:2j,nkf:2i,lgc:2g,mqf:20,mnb:1b,ird:6",
	["InstanceLootHeroic.The Underbog.Ghaz'an"]="mpm:rs,ipi:6e,lf2:4b,lf5:43,lf3:3t,lf4:3j,lez:3j,lf1:3j",
	["InstanceLootHeroic.The Underbog.Hungarfen"]="mpm:rs,ler:4e,lep:43,len:43,leq:3o,les:3g,leo:38,ipi:1n",
	["InstanceLootHeroic.The Underbog.Swamplord Musel'ek"]="mpm:rs,lf9:4m,lf7:42,lf8:3l,lfa:3g,lf6:3g,lfb:3e",
	["InstanceLootHeroic.The Underbog.The Black Stalker"]="mpm:rs,i6s:rs,ipi:5e,nm6:46,nm7:3f,liw:3b,lfd:35,lfo:35,nm8:32,lfp:31,lk2:30,nkd:2w,lfh:2u,lfn:2t,lfe:2k,mkx:2k,lfg:2k,lj7:2i,lff:2h,lfc:2h,mna:1f",

	["InstanceLootHeroic.Hellfire Citadel"]="m,InstanceLootHeroic.Hellfire Ramparts,InstanceLootHeroic.Magtheridon's Lair,InstanceLootHeroic.The Blood Furnace,InstanceLootHeroic.The Shattered Halls",
	["InstanceLootHeroic.Hellfire Ramparts.Nazan"]="ifx:1p,l6k:t,nlu:o,l6n:o,nls:k,l6p:k,l6s:k,l6q:g,nlt:c,mk6:c,l6o:c,l6m:c,l6l:8,l6t:8,l6r:8,mn6:4,mkw:4",
	["InstanceLootHeroic.Hellfire Ramparts.Omor the Unscarred"]="mpm:rs,i6s:rs,l6v:3r,l79:3n,l6w:3m,lj6:3h,l7a:3d,l6y:3c,l6u:38,liv:32,l6x:31,l78:2z,l6z:2s,l8z:29",
	["InstanceLootHeroic.Hellfire Ramparts.Vazruden"]="ifo:1h,l6k:k,nls:8,l6t:8,l6p:8,mn6:4,nlt:4,mkw:4,l6n:4,l6q:4,l6s:4",
	["InstanceLootHeroic.Hellfire Ramparts.Watchkeeper Gargolmar"]="mpm:rs,l6g:4v,l6f:4u,l6j:4s,l6h:41,l6i:3t",
	["InstanceLootHeroic.The Blood Furnace.Broggok"]="mpm:rs,l7o:4u,l7n:4k,lhk:45,l7m:3t,l7l:3t",
	["InstanceLootHeroic.The Blood Furnace.Keli'dan the Breaker"]="mpm:rs,i6s:rs,nm1:4a,l7r:42,lp5:3u,l83:3k,nm0:3f,l8a:3f,l7q:38,mk7:31,lfw:30,l88:2v,mkd:2u,l82:2s,l81:2s,l8i:2s,nm2:2g,lt4:2f,l7t:24,mn7:1c",
	["InstanceLootHeroic.The Blood Furnace.The Maker"]="mpm:rs,l7k:5g,l7j:4z,l7h:4o,l7f:4h,l7g:3o",
	["InstanceLootHeroic.The Shattered Halls.Grand Warlock Nethekurse"]="mpm:rs,jna:6x,l8f:53,l8d:51,l8g:4t,l8e:4m,l8h:49,irc:b",
	["InstanceLootHeroic.The Shattered Halls.Warbringer O'mrogg"]="mpm:rs,l8l:4v,l8m:4v,lga:47,li4:3y,l8k:3r",
	["InstanceLootHeroic.The Shattered Halls.Warchief Kargath Bladefist"]="mpm:rs,i6s:rs,l8w:3t,l8u:3j,l90:3g,l8t:3d,l8o:3b,l8n:3a,l8p:37,mkn:34,l8x:2u,nkk:2u,l8y:2t,l76:2s,l8v:2n,l8r:2c,nkj:26,mkv:26,nki:25,mn8:15",
	["InstanceLootHeroic.The Shattered Halls.Blood Guard Porung"]="mpm:rs,np1:5d,nox:4b,noz:45,np0:3s,np2:3e",

	["InstanceLootHeroic.Tempest Keep"]="m,InstanceLootHeroic.The Arcatraz,InstanceLootHeroic.The Mechanar,InstanceLootHeroic.The Botanica",
	["InstanceLootHeroic.The Arcatraz.Dalliah the Doomsayer"]="mpm:rs,lwo:5e,lwj:4w,lwi:4c,lwm:4c,lwn:3q,ir8:4",
	["InstanceLootHeroic.The Arcatraz.Harbinger Skyriss"]="mpm:rs,i6s:rs,lx9:41,lx8:3p,lxf:3g,lx3:3g,lxc:3g,lxb:3b,lx2:35,lrh:30,lxa:2x,ls7:2t,lwz:2o,mkg:2m,nk6:2c,lxe:28,mkm:1r,mnk:1r,nli:1n,nlb:1m,nlh:1g",
	["InstanceLootHeroic.The Arcatraz.Wrath-Scryer Soccothrates"]="mpm:rs,lwu:5c,lwq:4w,lws:4m,lwp:49,lwt:3z",
	["InstanceLootHeroic.The Arcatraz.Zereketh the Unbound"]="mpm:rs,lw6:61,lw4:57,lw7:4x,lwg:4q,lw5:43",
	["InstanceLootHeroic.The Botanica.Commander Sarannis"]="mpm:rs,lu8:7y,lua:5m,lu0:5i,lu5:5b,luf:51",
	["InstanceLootHeroic.The Botanica.High Botanist Freywinn"]="mpm:rs,lul:5u,lup:5m,lum:5m,luj:3x,luk:3i,i81:7",
	["InstanceLootHeroic.The Botanica.Laj"]="mpm:rs,lv6:5d,lv7:56,luw:50,lv8:4w,lej:45",
	["InstanceLootHeroic.The Botanica.Thorngrin the Tender"]="mpm:rs,lus:6x,luv:5c,luq:4y,lur:4k,lut:3s",
	["InstanceLootHeroic.The Botanica.Warp Splinter"]="mpm:rs,i6s:rs,lw3:3q,lva:3o,lvf:3d,ls4:3b,lvz:3b,lvb:3b,lvg:36,lvh:2t,lvi:2t,mkq:2e,lv9:2c,nla:2b,mku:27,nl8:25,ls5:1u,lvd:1s,nzh:1h,nl9:18,mnj:o,irb:6",
	["InstanceLootHeroic.The Mechanar.Mechano-Lord Capacitus"]="mpm:rs,lsu:4t,lst:46,lsv:45,lsw:40,lsx:3o",
	["InstanceLootHeroic.The Mechanar.Nethermancer Sepethrea"]="mpm:rs,lsz:5a,lt0:52,lt2:4o,lt3:4e,lsy:46",
	["InstanceLootHeroic.The Mechanar.Pathaleon the Calculator"]="mpm:rs,i6s:rs,nl1:44,lti:3i,ltf:3h,lt6:3f,lrg:3e,lt9:38,lre:33,ltq:32,lt7:32,lts:31,nk5:2x,ltp:2u,lt5:2t,nl0:2s,liz:2p,nl2:2p,mkj:2k,mnm:v",

})
