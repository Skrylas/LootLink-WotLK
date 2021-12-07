# LootLink

This is a Database addon that will create a local filterable database of items you've seen in game.
The database will initially be empty, but will populate as you see items.

The benefit of this is that uncached items can still be filtered by their stats as long as you've seen them once.
If you clear your game cache with some regularity, this will maintain a database allowing you to search for items.

The downside is that the database is initially empty.  Turning on LootLink tooltips in AtlasLoot can help build the database more quickly as you browse AtlasLoot.
LootLink will also store addons with item affixes.  This means Kara beast boss items and others can be stored and filtered by their stats, as opposed to addons like AtlasLoot which do not have affix support.

The entire database can be reset in the options, and Individual items can be removed from the database by holding Ctrl+Shift and right-clicking an item.

There is also a link autocomplete feature that can be turned on in the options menu, which will allow you to link items quickly by typing "[" pressing space, and then tabbing to the item you want,  and ending with "]".

Database is stored within your WTF addon settings, wiping these will wipe your database.
Database may have some unknown limits to how many items can be stored within it.
