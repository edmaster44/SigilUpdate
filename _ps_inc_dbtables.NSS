//**********************************************************************
//This is an informational file detailing the db tables currently
//active; otherwise, its a pain to look them up
//Add to it as needed; maybe detail columns later?
//--Mimi Fearthegn 3-8-20
//**********************************************************************
//
//DB Table list
//valid on test server as of 3-8-20
const string TABLE_CHARACTER_DATA = "characterdata"; //stores things like rp / dm exp pools, public cd key, etc.
const string TABLE_FACTION_DATA = "characterfactions";
const string TABLE_CHARACTER_QUESTS = "characterquests"; //stores permanent quest status info by character; see ps_inc_quests for use
const string TABLE_EVENT_PLANNER = "event_planner";
const string TABLE_EVENT_PLANNER_RSVP = "event_planner_rsvp";
const string TABLE_GEMSTONES = "gemstones"; //stores info on our gemstone list; used for loot generation / crafting
const string TABLE_LIBRARY = "library"; //maybe for that book system we don't use?
const string TABLE_LOGGING = "logging";
const string TABLE_MULING_DETAILS = "muling_details_last_7_days";
const string TABLE_MULING_INCIDENTS = "muling_incidents_last_7_days";
const string TABLE_NEWS = "news"; //log in messages table
const string TABLE_PW_DATA = "pwdata"; //??
const string TABLE_RECIPES = "recipes"; //enchantment recipes
const string TABLE_RECIPES_NAMES = "recipes_names"; //for generating random item names that have something to do with enchantments
const string TABLE_SCRYER = "scryer"; //scry system, presumably
const string TABLE_SERVER_VERSION = "server_version"; //just exists to tell the module whether this is the test or production server
const string TABLE_SERVER_QUESTS = "serverquests"; //stores permanent quest status for the whole module; see ps_inc_quests for use
const string TABLE_SIGIS = "sigis";
const string TABLE_SIGIS_READER = "sigis_reader";
const string TABLE_SPELL_IDS = "spellids"; //table for sorting spell ids, part of id fix
const string TABLE_SPELL_IDS_COUNT = "spellids_count"; //table for sorting spell ids, part of id fix
const string TABLE_NPC_EVENTS = "ps_npc_events"; //table for setting up temporary npc (non-hostile) events
const string TABLE_TREASURE_ARMOR = "treasure_armor"; //loot table for armor
const string TABLE_TREASURE_BELTS = "treasure_belts"; //loot table for belts
const string TABLE_TREASURE_BOOTS = "treasure_boots"; //loot table for boots
const string TABLE_TREASURE_CLOAKS = "treasure_cloaks"; //loot table for cloaks
const string TABLE_TREASURE_HELMETS = "treasure_helmets"; //loot table for headgear
const string TABLE_TREASURE_JEWELRY = "treasure_jewelry"; //loot table for rings / amulets
const string TABLE_TREASURE_JUNK = "treasure_junk"; //loot table for junk
const string TABLE_TREASURE_MISCELLANEOUS = "treasure_miscellaneous"; //loot table for misc?
const string TABLE_TREASURE_POTIONS = "treasure_potions"; //loot table for potions
const string TABLE_TREASURE_SHIELDS = "treasure_shields"; //loot table for shields
const string TABLE_TREASURE_WEAPONS = "treasure_weapons"; //loot table for weapons (all types)