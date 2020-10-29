/*	***********************************************************************************
	*** aaa_constants by Ceremorph for the Sigil: City of Doors persistant world.	***
	*** This script lists all constants used in the racial PrC system.				***
	*** Include this script in all associated system scripts.						***
	***********************************************************************************	*/
/*
rapsam2003 06/20/2018: Add new spellcasting placeholder feats as constants.
*/

//Background Feats

const int FEAT_OUTSIDER_BLOODLINE_FIENDISH = 81; 
const int FEAT_OUTSIDER_BLOODLINE_CELESTIAL = 86;




// List of all PrC-ready subraces
const int RACIAL_SUBTYPE_NIGHT_HAG				= 53;
const int RACIAL_SUBTYPE_TROGLODYTE				= 59;
const int RACIAL_SUBTYPE_LIZARDFOLK_NEW			= 60;
const int RACIAL_SUBTYPE_KHAASTA_NEW			= 61;
const int RACIAL_SUBTYPE_HEZROU_NEW				= 69;
const int RACIAL_SUBTYPE_AVARIEL				= 70;
const int RACIAL_SUBTYPE_ICEGENASI				= 71;
const int RACIAL_SUBTYPE_DRIDER_MALE			= 72;
const int RACIAL_SUBTYPE_DRIDER_FEMALE			= 73;
const int RACIAL_SUBTYPE_HOUND_ARCHON			= 163;
const int RACIAL_SUBTYPE_SLAAD					= 168;
const int RACIAL_SUBTYPE_ARCHON					= 176;
const int RACIAL_SUBTYPE_ELADRIN				= 193;
const int RACIAL_SUBTYPE_TANARRI				= 194;
const int RACIAL_SUBTYPE_BAATEZU				= 195;
const int RACIAL_SUBTYPE_HALFOGRE				= 196;
const int RACIAL_SUBTYPE_OGRE					= 197;
const int RACIAL_SUBTYPE_TROLL					= 198;
const int RACIAL_SUBTYPE_ONI					= 199;
const int RACIAL_SUBTYPE_HILL_GIANT				= 200;
const int RACIAL_SUBTYPE_FROST_GIANT			= 201;
const int RACIAL_SUBTYPE_FIRE_GIANT				= 202;
const int RACIAL_SUBTYPE_AASIMON				= 203;
const int RACIAL_SUBTYPE_FROST_GIANT_NEW		= 205;
const int RACIAL_SUBTYPE_FIRE_GIANT_NEW			= 206;
const int RACIAL_SUBTYPE_QUASIT					= 220;
const int RACIAL_SUBTYPE_IMP					= 221;
const int RACIAL_SUBTYPE_DRAGBRONZE				= 222;
const int RACIAL_SUBTYPE_DRAGRED				= 223;
const int RACIAL_SUBTYPE_DRAGBLUE				= 224;
const int RACIAL_SUBTYPE_DRAGSHADOW				= 225;
const int RACIAL_SUBTYPE_DRAGBLACK				= 226;
const int RACIAL_SUBTYPE_DRAGCOPPER				= 227;
const int RACIAL_SUBTYPE_DRAGIRON 				= 228;

// List of Races not in existing lists
const int RACIAL_TYPE_PLANETOUCHED				= 21;
const int RACIAL_TYPE_PLANT						= 22;
const int RACIAL_TYPE_HUMANOID_OTHER			= 26;
const int RACIAL_TYPE_OUTSIDER_NATIVE			= 33;


// List of PC-compliant wing types
const int WING_TYPE_NONE						= 0;		
const int WING_TYPE_ANGEL_M						= 25;
const int WING_TYPE_ANGEL_F						= 26;
const int WING_TYPE_HEZEBEL_M					= 60;
const int WING_TYPE_HEZEBEL_F					= 21;
const int WING_TYPE_DWARF_BAT_M					= 43;
const int WING_TYPE_DWARF_BAT_F					= 44;
const int WING_TYPE_ORC_BAT_M					= 47;
const int WING_TYPE_ORC_BAT_F					= 48;
const int WING_TYPE_ERINYES_M					= 59;
const int WING_TYPE_ERINYES_F					= 14;
const int WING_TYPE_BAT_M						= 55;
const int WING_TYPE_BAT_F						= 56;
const int WING_TYPE_HAWK_M						= 63;
const int WING_TYPE_HAWK_F						= 64;
const int WING_TYPE_RAVEN_M						= 65;
const int WING_TYPE_RAVEN_F						= 66;
const int WING_TYPE_LILITU_M					= 67;
const int WING_TYPE_LILITU_F					= 68;
const int WING_TYPE_WORDARCHON_F				= 72;
const int WING_TYPE_WORDARCHON_M				= 73;


//List of All new PRCs
const int CLASS_TYPE_ELEMENTAL_WARRIOR			= 68;
const int CLASS_DERVISH							= 72;
const int CLASS_STALWART_DEFENDER 				= 180;
// List of all racial prestige classes
const int CLASS_TYPE_SCALED_HUNTER_PRC			= 48;
const int CLASS_TYPE_HALFDRAGON_PRC				= 49;
const int CLASS_TYPE_HALFOUTSIDER_PRC			= 62;
const int CLASS_TYPE_MISSCAULDRON				= 64;
const int CLASS_TYPE_HOUNDARCH_HERO_PRC			= 73;
const int CLASS_TYPE_TRUMPET_ARCHON_PRC			= 74;
const int CLASS_TYPE_WORD_ARCHON_PRC			= 75;
const int CLASS_TYPE_VAMPIRE_LUP_PRC			= 78;
const int CLASS_TYPE_DEATH_KNIGHT_PRC			= 79;
const int CLASS_TYPE_HILL_GIANT_PRC				= 84;
const int CLASS_TYPE_FIRE_GIANT_PRC 			= 85;
const int CLASS_TYPE_FROST_GIANT_PRC			= 86;
const int CLASS_TYPE_ASTRAL_DEVA_PRC			= 87;
const int CLASS_TYPE_MONADIC_DEVA_PRC			= 88;
const int CLASS_TYPE_MOVANIC_DEVA_PRC 			= 89;
const int CLASS_TYPE_LICH_W_PRC					= 91;
const int CLASS_TYPE_LICH_D_PRC					= 92;
const int CLASS_TYPE_LICH_PRC					= 93;
const int CLASS_TYPE_SAVAGE_MARAUDER_PRC		= 94;
const int CLASS_TYPE_OGRE_MAGE_PRC				= 95;
const int CLASS_TYPE_ERINYES					= 96;
const int CLASS_TYPE_BRACHINA					= 97;
const int CLASS_TYPE_SUCCUBUS_INCUBUS			= 98;
const int CLASS_TYPE_MARQUIS_CAMBION			= 99;
const int CLASS_TYPE_ILLITHID_MENTALIST_PRC		= 100;
const int CLASS_TYPE_BRALANI_PRC				= 101;
const int CLASS_TYPE_FIRRE_PRC					= 102;
const int CLASS_TYPE_GHAELE_PRC					= 103;
const int CLASS_TYPE_LYCAN_PRC					= 104;
const int CLASS_TYPE_VAMPIRE_DRA_PRC			= 105;
const int CLASS_TYPE_VAMPIRE_MAL_PRC			= 106;
const int CLASS_TYPE_CHAMPION_OF_CHAOS			= 107;
const int CLASS_TYPE_GRAY_SLAAD					= 108;
const int CLASS_TYPE_HEZROU						= 126;
const int CLASS_TYPE_DRAGON_PRC					= 127;
const int CLASS_TYPE_DRAGON_PSION				= 128;
const int CLASS_TYPE_PACK_LEADER 				= 210;
const int CLASS_TYPE_PLANTPC 					= 211;
const int CLASS_TYPE_AUSTERE_ONE				= 214;

// List of specific feats
const int FEAT_GIANT_ROCK_THROW					= 2371;
const int FEAT_DRIDER_SKILL_AFFINITY			= 2459;
const int FEAT_DRIDER_CLAIRVOYANCE				= 2460;
const int FEAT_DRIDER_DISPEL_MAGIC				= 2461;
const int FEAT_DRIDER_SUMMON_SWARM				= 2462;
const int FEAT_GIANT_ARMOR						= 2657;
const int FEAT_TROGLODYTE_SKILL_AFFINITY_HIDE	= 2658;
const int FEAT_GIANT_IMMUNITY					= 2659;
const int FEAT_GIANT_STRIDE						= 2660;
const int FEAT_TROGLODYTE_STENCH				= 2662;
const int FEAT_EPITHET_FIRE_GIANT				= 2680;
const int FEAT_EPITHET_FROST_GIANT				= 2681;
const int FEAT_EPITHET_HILL_GIANT				= 2682;
const int FEAT_EPITHET_HALFOGRE					= 2768;
const int FEAT_EPITHET_OGRE						= 2769;
const int FEAT_EPITHET_TROLL					= 2770;
const int FEAT_EPITHET_ONI						= 2771;
const int FEAT_TROLL_REGENERATION				= 2772;
const int FEAT_DARKNESS_OGRE_MAGE				= 2773;
const int FEAT_HISS_OF_SLEEP_OGRE_MAGE			= 2774;
const int FEAT_CONE_OF_COLD_OGRE_MAGE			= 2775;

const int FEAT_DEVA_ARMOR						= 2661;
const int FEAT_DEVA_AURA						= 2663;
const int FEAT_DEVA_IMMUNITY					= 2664;
const int FEAT_DEVA_WEAPON						= 2665;
const int FEAT_DELIVERANCE_FROM_DEATH_MONADIC	= 2667;
const int FEAT_HEAVENLY_DEFLECTION_MOVANIC		= 2668;
const int FEAT_PRAYER_MOVANIC					= 2669;
const int FEAT_CURE_CRITICAL_MOVANIC			= 2670;
const int FEAT_ETHEREAL_JAUNT_MOVANIC			= 2671;
const int FEAT_RAISE_DEAD_MOVANIC				= 2672;
const int FEAT_EPITHET_AASIMON					= 2679;

const int FEAT_DEATHKNIGHT_ABYSSAL_BLAST		= 2391;
const int FEAT_DEATHKNIGHT_IMMUNITY				= 2392;
const int FEAT_DEATHKNIGHT_NEGATIVE_WEAPON		= 2393;
const int FEAT_DEATHKNIGHT_DR					= 2394;
const int FEAT_DEATHKNIGHT_SYMBOL_OF_PAIN		= 2395;
const int FEAT_DEATHKNIGHT_FEAR_AURA			= 2396;
const int FEAT_VAMPIRE_NATURAL_ARMOR			= 2463;
const int FEAT_VAMPIRE_SLAM						= 2464;
const int FEAT_VAMPIRE_DRAIN_BLOOD				= 2465;
const int FEAT_VAMPIRE_ALTERNATE_FORM_BAT		= 2466;
const int FEAT_VAMPIRE_ALTERNATE_FORM_WOLF		= 2467;
const int FEAT_VAMPIRE_ALTERNATE_FORM_GASEOUS	= 2468;
const int FEAT_VAMPIRE_ALTERNATE_FORM_DIREWOLF	= 2469;
const int FEAT_VAMPIRE_FAST_HEALING				= 2470;
const int FEAT_VAMPIRE_RESISTANCE				= 2471;
const int FEAT_VAMPIRE_DR						= 2472;
const int FEAT_VAMPIRE_DOMINATING_GAZE			= 2473;
const int FEAT_VAMPIRE_DOMINATING_GAZE_2		= 2474;
const int FEAT_TOUCH_OF_EVIL					= 2689;
const int FEAT_UNDEAD_RACIAL_TYPE				= 2690;
const int FEAT_UNDEAD_PROPERTIES				= 2691;
const int FEAT_LICH_ROTTING_VISAGE				= 2692;
const int FEAT_LICH_PARALYZING_TOUCH			= 2694;
const int FEAT_LICH_IMMUNITY					= 2695;
const int FEAT_LICH_DR							= 2696;
const int FEAT_TURN_RESISTANCE					= 2697;
const int FEAT_LICH_FEAR_AURA					= 2698;
const int FEAT_LICH_ARMOR						= 2699;

const int FEAT_BAATEZU_BLINDSIGHT				= 2778;
const int FEAT_BAATEZU_IMMUNITY					= 2779;
const int FEAT_EPITHET_BAATEZU					= 2780;
const int FEAT_DARK_FLIGHT						= 2781;
const int FEAT_ERINYES_ARMOR					= 2782;
const int FEAT_ERINYES_ROPE_OF_ENTANGLEMENT		= 2783;
const int FEAT_ERINYES_UNHOLY_BLIGHT			= 2784;
const int FEAT_ERINYES_DR						= 2785;
const int FEAT_ERINYES_SUMMON_BAATEZU			= 2786;
const int FEAT_BRACHINA_ARMOR					= 2790;
const int FEAT_BRACHINA_REGENERATION			= 2791;
const int FEAT_BRACHINA_VAMPIRIC_TOUCH			= 2792;
const int FEAT_BRACHINA_SUMMON_BAATEZU			= 2793;
const int FEAT_BRACHINA_DR						= 2794;
const int FEAT_BRACHINA_BEGUILE					= 2795;
const int FEAT_UNSUMMON_BAATEZU					= 2796;
const int FEAT_CHANGE_SELF						= 2797;

const int FEAT_TANARRI_IMMUNITY					= 2798;
const int FEAT_EPITHET_TANARRI					= 2800;
const int FEAT_SUCCUBUS_ARMOR					= 2822;
const int FEAT_SUCCUBUS_DRAINING_KISS			= 2823;
const int FEAT_SUCCUBUS_DR						= 2824;
const int FEAT_SUCCUBUS_SUMMMON_TANARRI			= 2825;
const int FEAT_UNSUMMON_TANARRI					= 2826;
const int FEAT_MARQCAMB_MIRROR_IMAGE			= 2827;
const int FEAT_MARQCAMB_ALTERNATE_FORM			= 2828;
const int FEAT_MARQCAMB_ALIGNED_STRIKE			= 2829;
const int FEAT_MARQCAMB_ARMOR					= 2830;
const int FEAT_MARQCAMB_SILENT_METAL			= 2831;
const int FEAT_SUCCUBUS_DRAINING_KISS_2			= 2832;
const int FEAT_UNHOLY_APOTHESIS					= 2833;
const int FEAT_LILITUS_GIFT						= 2834;
const int FEAT_HEZROU_BLASPHEMY					= 3601;
const int FEAT_HEZROU_ARMOR						= 3602;
const int FEAT_HEZROU_STENCH					= 3603;
const int FEAT_HEZROU_SUMMMON_TANARRI			= 3604;
const int FEAT_HEZROU_IMMUNITY					= 3605;
const int FEAT_HEZROU_ALIGNED_STRIKE			= 3606;

const int FEAT_ELADRIN_ALTERNATE_FORM			= 2256;
const int FEAT_ELADRIN_PRC_ARMOR				= 2475;
const int FEAT_BRALANI_WHIRLWIND_BLAST			= 2476;
const int FEAT_ELADRIN_PRC_DR					= 2477;
const int FEAT_BRALANI_BLUR						= 2478;
const int FEAT_BRALANI_LIGHTNING_BOLT			= 2479;
const int FEAT_ELADRIN_PRC_TRANSCENDENT_STRIKE	= 2480;
const int FEAT_FIRRE_FLAMING_SLAM				= 2482;
const int FEAT_FIRRE_MAGIC_CIRCLE_VS_EVIL		= 2483;
const int FEAT_GHAELE_LIGHT_RAY					= 2488;
const int FEAT_GHAELE_BONUS_DOMAIN				= 2489;
const int FEAT_GHAELE_PROTECTIVE_AURA			= 2490;
const int FEAT_GHAELE_GLOW						= 2491;
const int FEAT_EPITHET_ELADRIN					= 2492;
const int FEAT_ELADRIN_ARBOREAL_IMMUNITY		= 2693;

const int FEAT_ICEGENASI_HOARFROST_ARMOR		= 2799;

const int FEAT_FAMILIAR_REGENERATION			= 3608;
const int FEAT_FAMILIAR_DR						= 3609;
const int FEAT_FAMILIAR_ALTERNATE_FORM_BAT		= 3610;
const int FEAT_FAMILIAR_ALTERNATE_FORM_CAT		= 3611;
const int FEAT_FAMILIAR_ALTERNATE_FORM_RAT		= 3612;
const int FEAT_FAMILIAR_ALTERNATE_FORM_SPIDER	= 3613;
const int FEAT_FAMILIAR_ALTERNATE_FORM_WEASEL	= 3614;

const int FEAT_DRACONIC_SCALES					= 3623;
const int FEAT_DRACONIC_IMMUNITY_BRONZE			= 3624;
const int FEAT_EPITHET_DRAGON_SIZE				= 3625;
const int FEAT_DRAGON_BREATH_BRONZE				= 3626;
const int FEAT_DRAGON_BREATH_BRONZE_GAS			= 3627;
const int FEAT_DRACONIC_IMMUNITY_BLACK			= 3628;
const int FEAT_DRACONIC_IMMUNITY_RED			= 3629;
const int FEAT_DRACONIC_IMMUNITY_SHADOW			= 3630;
const int FEAT_DRAGON_BREATH_BLACK				= 3631;
const int FEAT_DRAGON_BREATH_RED				= 3632;
const int FEAT_DRAGON_BREATH_SHADOW				= 3633;
const int FEAT_DRAGON_BREATH_BLUE				= 3634;
const int FEAT_DRAGON_BLACK_DARKNESS 			= 3635;
const int FEAT_DRAGON_SHADOW_BLEND  			= 3636;
const int FEAT_DRAGON_BLUE_SOUND	  			= 3637;
const int FEAT_HARDENING_SCALES 	  			= 3642;
const int FEAT_DRAGON_SENSES		  			= 3644;
const int FEAT_DRAGON_ROAR		  				= 3645;
const int FEAT_DRAGON_PATH_SORCERER 			= 3646;
const int FEAT_DRAGON_PRESENCE		  			= 3647;
const int FEAT_DRAGON_SWIPE			  			= 3648;
const int FEAT_DRAGON_PATH_MELEE			  	= 3649;

const int FEAT_WARCHON_WORD_OF_NURTURING		= 205;
const int FEAT_WARCHON_WORD_OF_SHOCKWAVE		= 210;
const int FEAT_WARCHON_WORD_OF_PEACE			= 218;
const int FEAT_ARCHON_EXALTED_WEAPON			= 376;
const int FEAT_ARCHON_AURA_OF_MENACE			= 480;
const int FEAT_EPITHET_ARCHON					= 484;
const int FEAT_ARCHON_ARMOR						= 485;
const int FEAT_TARCHON_TRUMPET					= 486;
const int FEAT_TARCHON_TRUMPET_BLADE			= 487;
const int FEAT_TARCHON_TRUMPET_BLAST			= 488;
const int FEAT_TARCHON_TRUMPET_REVEILLE			= 489;
const int FEAT_ARCHON_IMMUNITY					= 2437;
const int FEAT_CANINE_FORM						= 2438;
const int FEAT_HA_ARCHONIC_ARMOR				= 2449;
const int FEAT_HA_CANINE_FORM_2					= 2450;
const int FEAT_HA_DAMAGE_REDUCTION				= 2451;
const int FEAT_HA_SPELLABILITY_AID				= 2452;
const int FEAT_HA_SANCTIFIED_WEAPON				= 2453;
const int FEAT_HA_AURA_OF_MENACE				= 2454;

const int FEAT_NHAG_IMMUNITIES					= 2559;
const int FEAT_NHAG_SLEEP_SPELLLIKE				= 2560;
const int FEAT_NHAG_RAY_OF_ENFEEBLEMENT_SL		= 2561;
const int FEAT_NHAG_DECEITFUL					= 2562;
const int FEAT_NHAG_INEFFABLY_EVIL				= 2563;
const int FEAT_MOTC_ELEMENTAL_IMMUNITY			= 2564;
const int FEAT_MOTC_MAGIC_MISSILE_SPELLLIKE		= 2565;
const int FEAT_MOTC_CRAFT_HEARTSTONE			= 2566;

const int FEAT_LYCAN_AFFLICTION					= 2585;
const int FEAT_LYCAN_ANIMAL_FORM				= 2586;
const int FEAT_LYCAN_DAMAGE_REDUCTION			= 2587;
const int FEAT_LYCAN_HYBRID_FORM				= 2588;
const int FEAT_LYCAN_BP_WEREWOLF				= 2589;
const int FEAT_LYCAN_BP_WEREBOAR				= 2590;
const int FEAT_LYCAN_BP_WERETIGER				= 2591;
const int LYCAN_AFFLICTION_WEREWOLF				= 2592;
const int LYCAN_AFFLICTION_WERERAT				= 2593;
const int LYCAN_AFFLICTION_WEREBOAR				= 2610;
const int LYCAN_AFFLICTION_WERETIGER			= 2656;

const int FEAT_SLAAD_STUNNING_CROAK				= 4001;
const int FEAT_SLAAD_INNATE_IMMUNITY			= 4002;
const int FEAT_SLAAD_COMPLETELY_CHAOTIC			= 4003;
const int FEAT_GREYSLAAD_REGENERATION			= 4004;
const int FEAT_SLAAD_CLAWS_OF_CHAOS				= 4005;
const int FEAT_SLAAD_DR							= 4006;
const int FEAT_SLAAD_CHAOS_HAMMER				= 4007;
const int FEAT_SLAAD_SUMMON_SLAAD				= 4008;
const int FEAT_SLAAD_GRAY_APPEARANCE			= 4012;
const int FEAT_SLAAD_CHAOTIC_CRAFTING			= 4013;
const int FEAT_EPITHET_DEATH_SLAAD				= 4014;
const int FEAT_IMPROVED_STUNNING_CROAK			= 4015;
const int FEAT_DS_CIRCLE_OF_DEATH				= 4016;
const int FEAT_DS_CLOAK_OF_CHAOS				= 4017;
const int FEAT_DS_POWER_WORD_BLIND				= 4018;
const int FEAT_COC_REGENERATION					= 4019;

const int FEAT_BLINK 							= 5000;
const int FEAT_DIMENSION_DOOR 					= 5001;
const int FEAT_CANINE_TYPE_BDOG 				= 5002;
const int FEAT_CANINE_TYPE_WWOLF 				= 5003;
const int FEAT_CANINE_TYPE_WORG					= 5004;
const int FEAT_FERAL_MARK 						= 5005;
const int FEAT_BATTLE_HOWL						= 5006;
const int FEAT_HUNTING_LOPE1 					= 5007;
const int FEAT_HUNTING_LOPE2 					= 5008;
const int FEAT_WW_COLDTYPE1 					= 5009;
const int FEAT_WW_COLDTYPE2 					= 5010;
const int FEAT_WG_ImpKnockdown 					= 5011;
const int FEAT_BD_Mobility 						= 5012;
const int FEAT_WW_FREEZING_BR 					= 5013;
const int FEAT_ETERNAL_LEADER 					= 5014;
const int FEAT_TEARING_BITE 					= 5015;
const int FEAT_GENESIS 							= 5016;
const int FEAT_ARMOR_OF_NATURE 					= 5017;
const int FEAT_OVERGROWTH 						= 5018;
const int FEAT_TOUGH_ROOTS 						= 5019;
const int FEAT_ANIMATE_TREES 					= 5020;

// These feats are automatically granted in ps_givespellfeat,
// at the appropriate spellcaster levels.
const int FEAT_SPELL_WIZARD_I					= 21440;
const int FEAT_SPELL_WIZARD_II					= 21441;
const int FEAT_SPELL_WIZARD_III					= 21442;
const int FEAT_SPELL_WIZARD_IV					= 21443;
const int FEAT_SPELL_CLERDRU_I					= 21444;
const int FEAT_SPELL_CLERDRU_II					= 21445;
const int FEAT_SPELL_CLERDRU_III				= 21446;
const int FEAT_SPELL_CLERDRU_IV					= 21447;
const int FEAT_SPELL_BARD_I						= 21448;
const int FEAT_SPELL_BARD_II					= 21449;
const int FEAT_SPELL_BARD_III					= 21450;
const int FEAT_SPELL_BARD_IV					= 21451;
const int FEAT_SPELL_PALRANG_I					= 21452;
const int FEAT_SPELL_PALRANG_II					= 21453;
const int FEAT_SPELL_PALRANG_III				= 21454;
const int FEAT_SPELL_PALRANG_IV					= 21455;
const int FEAT_SPELL_SORCFAVSHAMAN_I			= 21456;
const int FEAT_SPELL_SORCFAVSHAMAN_II			= 21457;
const int FEAT_SPELL_SORCFAVSHAMAN_III			= 21458;
const int FEAT_SPELL_SORCFAVSHAMAN_IV			= 21459;
const int FEAT_INVOCATIONS_WARLOCK_I			= 21460;
const int FEAT_INVOCATIONS_WARLOCK_II			= 21461;

// Polymorph Forms
const int POLYMORPH_TYPE_HA_HOUND				= 50;
const int POLYMORPH_TYPE_HA_HOUNDF				= 51;
const int POLYMORPH_TYPE_HA_HOUND2				= 52;
const int POLYMORPH_TYPE_HA_HOUND2F				= 53;
const int POLYMORPH_TYPE_ELADRIN_LIGHT			= 85;
const int POLYMORPH_TYPE_ELADRIN_BRALANI		= 86;
const int POLYMORPH_TYPE_ELADRIN_FIRRE			= 87;
const int POLYMORPH_TYPE_ELADRIN_GHAELE			= 88;
const int POLYMORPH_VAMPIRE_BAT					= 404;
const int POLYMORPH_VAMPIRE_WOLF				= 405;
const int POLYMORPH_VAMPIRE_GASEOUS				= 406;
const int POLYMORPH_VAMPIRE_DIREWOLF			= 407;
const int POLYMORPH_VAMPIRE_WYVERN				= 415;
const int POLYMORPH_VAMPIRE_TWOLF				= 416;
const int POLYMORPH_BAT  						= 171;
const int POLYMORPH_WEASEL						= 177;
const int POLYMORPH_RAT							= 412;
const int POLYMORPH_SMALL_SPIDER				= 413;
const int POLYMORPH_CAT  						= 414;
const int VAMPIRE_WYVERN_FORM					= 415;
const int VAMPIRE_TWOLF_FORM					= 416;
const int POLYMORPH_WEREWOLF_ANIMFORM			= 417;
const int POLYMORPH_WEREBOAR_ANIMFORM			= 418;
const int POLYMORPH_WERETIGER_ANIMFORM			= 419;
const int POLYMORPH_WERERAT_ANIMFORM			= 420;

// Areas of Effect
const int AOE_PER_FREEZINGFOG					= 75;
const int AOE_PER_OBSCURINGMIST					= 76;
const int VFX_MOB_CROWN_OF_FLAME				= 79;
const int AOE_MOB_SCINTILLATING_PATTERN			= 80;
const int VFX_MOB_DRAGON_FEAR_PC				= 83;
const int VFX_MOB_ARCHON_MENACE					= 85;

// Wing Variations
const int WING_VARIATION_DWARF					= 1;
const int WING_VARIATION_GNOME					= 2;
const int WING_VARIATION_HUMAN					= 3;
const int WING_VARIATION_ORC					= 4;

// On-Hit Options
const int IP_CONST_ONHIT_CASTSPELL_CHAOSDAM1	= 143;
const int IP_CONST_ONHIT_CASTSPELL_CHAOSDAM2	= 144;
const int IP_CONST_ONHIT_CASTSPELL_CHAOSDAM3	= 145;

// Lycanthrope Items
const string ITEM_LYCAN_WOLF_BITE_L01			= "s3_w_werewolfbite_01";
const string ITEM_LYCAN_WOLF_BITE_L08			= "s3_w_werewolfbite_08";
const string ITEM_LYCAN_WOLF_BITE_L16			= "s3_w_werewolfbite_16";
const string ITEM_LYCAN_WOLF_BITE_L24			= "s3_w_werewolfbite_24";
const string ITEM_LYCAN_WOLF_CLAW_L01			= "s3_w_werewolfclaw_01";
const string ITEM_LYCAN_WOLF_CLAW_L08			= "s3_w_werewolfclaw_08";
const string ITEM_LYCAN_WOLF_CLAW_L16			= "s3_w_werewolfclaw_16";
const string ITEM_LYCAN_WOLF_CLAW_L24			= "s3_w_werewolfclaw_24";
const string ITEM_LYCAN_RAT_BITE_L01			= "s3_w_wereratbite_01";
const string ITEM_LYCAN_RAT_BITE_L08			= "s3_w_wereratbite_08";
const string ITEM_LYCAN_RAT_BITE_L16			= "s3_w_wereratbite_16";
const string ITEM_LYCAN_RAT_BITE_L24			= "s3_w_wereratbite_24";
const string ITEM_LYCAN_RAT_CLAW_L01			= "s3_w_wereratclaw_01";
const string ITEM_LYCAN_RAT_CLAW_L08			= "s3_w_wereratclaw_08";
const string ITEM_LYCAN_RAT_CLAW_L16			= "s3_w_wereratclaw_16";
const string ITEM_LYCAN_RAT_CLAW_L24			= "s3_w_wereratclaw_24";
const string ITEM_LYCAN_BOAR_GORE_L01			= "s3_w_wereboargore_01";
const string ITEM_LYCAN_BOAR_GORE_L08			= "s3_w_wereboargore_08";
const string ITEM_LYCAN_BOAR_GORE_L16			= "s3_w_wereboargore_16";
const string ITEM_LYCAN_BOAR_GORE_L24			= "s3_w_wereboargore_24";
const string ITEM_LYCAN_TIGER_BITE_L01			= "s3_w_weretigerbite_01";
const string ITEM_LYCAN_TIGER_BITE_L08			= "s3_w_weretigerbite_08";
const string ITEM_LYCAN_TIGER_BITE_L16			= "s3_w_weretigerbite_16";
const string ITEM_LYCAN_TIGER_BITE_L24			= "s3_w_weretigerbite_24";
const string ITEM_LYCAN_TIGER_CLAW_L01			= "s3_w_weretigerclaw_01";
const string ITEM_LYCAN_TIGER_CLAW_L08			= "s3_w_weretigerclaw_08";
const string ITEM_LYCAN_TIGER_CLAW_L16			= "s3_w_weretigerclaw_16";
const string ITEM_LYCAN_TIGER_CLAW_L24			= "s3_w_weretigerclaw_24";

// New Spells
const int SPELL_IRRESISTIBLE_DANCE				= 1950;
const int SPELL_MASS_HIDEOUS_LAUGHTER			= 1951;
const int SPELL_RAINBOW_DWEOMER					= 1952;
const int SPELL_ICE_SIMULACRUM					= 1953;
const int SPELL_MISLEAD							= 1954;
const int SPELL_FAERIE_FIRE						= 1955;
const int SPELL_GLAMER							= 1956;
const int SPELL_HALLUCINATORY_TERRAIN			= 1957;
const int VFX_PER_HALLUCINATORY_TERRAIN 		= 95;
const int SPELL_HYPNOTISM						= 1958;
const int SPELL_SLEEP_OF_AGES					= 1499;
const int SPELL_VEIL_OF_SHADOW					= 1500;
const int SPELL_ABYSSAL_MIGHT					= 1501;
const int SPELL_DEMON_FLESH						= 1502;
const int SPELL_DEMONHIDE						= 1503;
const int SPELL_DIVINE_SACRIFICE				= 1504;
const int SPELL_HELLSPOWER						= 1505;
const int SPELL_MASOCHISM						= 1506;
const int SPELL_UNHOLY_STORM					= 1507;
const int SPELL_BLEED							= 1508;
const int SPELL_BLADE_OF_BLOOD					= 1509;
const int SPELL_BLADE_OF_FEAR					= 1510;
const int SPELLABILITY_DIVINE_RETRIBUTION		= 1931;

//New Spell Like Abilities for Dervish
const int SPELLABILITY_DERVISH_AC_BONUS			= 1926;
const int SPELLABILITY_DERVISH_DANCE			= 1927;
const int SPELLABILITY_THOUSAND_CUTS			= 1928;
const int SPELLABILITY_DERVISH_DEFENSIVE_PARRY	= 1929;

//Dervish Feats 
const int FEAT_DERVISH_AC_BONUS					= 2999;
const int FEAT_DERVISH_DERVISH_DANCE			= 3000;
const int FEAT_DERVISH_DANCE_DEATH				= 3001;
const int FEAT_DERVISH_DEFENSIVE_PARRY			= 3002;
const int FEAT_DERVISH_TIRELESS_DANCE			= 3003;
const int FEAT_DERVISH_THOUSAND_CUTS			= 3004;
//New Spell Like Abilities for Elemental Warrior
const int ELEMENTAL_WARRIOR_IMMUNITY			= 1920;
const int SPELLABILITY_ELEMWAR_MANIFESTATION    = 1921;
const int SPELLABILITY_ELEMWAR_STRIKE			= 1922;
//Elemental Warrior Feats
const int FEAT_ELEMWAR_WEAPON					= 2997;
const int FEAT_ELEMWAR_AFFINITY_AIR				= 2992;
const int FEAT_ELEMWAR_AFFINITY_EARTH			= 2993;
const int FEAT_ELEMWAR_AFFINITY_FIRE 			= 2994;
const int FEAT_ELEMWAR_AFFINITY_WATER			= 2995;

//Knight Related Feats
const int FEAT_PALADIN 							= 3017;
const int FEAT_KNIGHT							= 3018;
const int FEAT_BLACKGUARD						= 3019;
const int FEAT_DIVINE_RETRIBUTION				= 3020;

//Barbarian Feats
//const int FEAT_BARBARIAN_ENDURANCE 			= 194; // Barb level 1
//const int FEAT_UNCANNY_DODGE					= 195;//barb level 2
//const int FEAT_TRAP_SENSE_1					= 1387;//barb level 3
const int FEAT_BARBARIAN_RAGE_2					= 326;//Barb Level 3
//const int FEAT_IMPROVED_UNCANNY_DODGE			= 1394;//barb level 5
//const int FEAT_TRAP_SENSE_2					= 1394;//Barb Level 6
//const int FEAT_DAMAGE_REDUCTION				= 196;//Barb level 7
const int FEAT_BARBARIAN_RAGE3					= 327;//Barb Level 8
//const int FEAT_TRAP_SENSE_3					= 1389;//Trap sense 9
const int FEAT_DAMAGE_REDUCTION2				= 332;//Damage Reduction 2 barb level 10
//const int FEAT_GREATER_RAGE					= 1396; Barb 11
const int FEAT_BARBARIAN_RAGE_4					=328;//Barbarian Rage 4 Usage Barb level 12
const int FEAT_DAMAGE_REDUCTION3				=333;//Barbarian level 13
//const int FEAT_INDOMITABLE_WILL				=1398;//Barbrian Level 14
//const int FEAT_TRAP_SENSE_5					=1391;//Barbarian Level 15
const int FEAT_DAMAGE_REDUCTION4				=334;//Barbarian Level 16
const int FEAT_BARBARIAN_RAGE_6					=330;//Barbarian 16
//const int FEAT_TIRELESS_RAGE					=1769; Barbarian 17
//const int FEAT_TRAP_SENSE_6					=1392; Barbarian 18
//const int FEAT_DAMAGE_REDUCTION5				=1386;//Barbarian 20
//const int FEAT_BARBARIAN_RAGE7				=331;//Barbarian Rage 7
//const int FEAT_EPIC_BARBARIAN					=967;//Barbarian 21
//const int FEAT_EPIC_BARBARIAN_RAGE			=869;//Barbarian Epic 21+
//const int FEAT_EPIC_BARBARIAN					=967;//Epic Barbarian damage Reduction
//const int FEAT_DAMAGE_REDUCTION_6				=1861;//Level 22 Barbarian Damage Reduction
const int FEAT_TRAP_SENSE_8						=1865;//Barbarian level 24
const int FEAT_DAMAGE_REDUCTION7				=1862;//Barbarian Level 25, Damage Reduction
const int FEAT_TRAP_SENSE9						=1866;//Trap Sense 9
const int FEAT_DAMAGE_REDUCTION8				=1863;//Damage Reduction 8 Barbarian Level 27+

const int SPELL_I_ELDRICH_SHIELD 				= 811;
const int SPELL_I_BLACKBOLT_BLAST 				= 1130;
const int FEAT_WARLOCK_SPEAR_ELDRTICH 			= 3299;
const int FEAT_WARLOCK_SPEAR_DRAINING 			= 3300;
const int FEAT_WARLOCK_SPEAR_FRIGHTFUL 			= 3301;
const int FEAT_WARLOCK_SPEAR_BSHADOWED 			= 3302;
const int FEAT_WARLOCK_SPEAR_BRIMSTONE 			= 3303;
const int FEAT_WARLOCK_SPEAR_HELLRIME 			= 3304;
const int FEAT_WARLOCK_SPEAR_BWITCHING 			= 3305;
const int FEAT_WARLOCK_SPEAR_NOXIOUS 			= 3306;
const int FEAT_WARLOCK_SPEAR_VITRIOLIC 			= 3307;
const int FEAT_WARLOCK_SPEAR_UTTERDARK 			= 3308;
const int FEAT_WARLOCK_SPEAR_BLACKBOLT 			= 3309;
const int FEAT_WARLOCK_SPEAR_BINDING 			= 3310;
const int FEAT_WARLOCK_BLOW_ELDRTICH 			= 3311;
const int FEAT_WARLOCK_BLOW_DRAINING 			= 3312;
const int FEAT_WARLOCK_BLOW_FRIGHTFUL 			= 3313;
const int FEAT_WARLOCK_BLOW_BSHADOWED 			= 3314;
const int FEAT_WARLOCK_BLOW_BRIMSTONE 			= 3315;
const int FEAT_WARLOCK_BLOW_HELLRIME 			= 3316;
const int FEAT_WARLOCK_BLOW_BWITCHING 			= 3317;
const int FEAT_WARLOCK_BLOW_NOXIOUS 			= 3318;
const int FEAT_WARLOCK_BLOW_VITRIOLIC 			= 3319;
const int FEAT_WARLOCK_BLOW_UTTERDARK 			= 3320;
const int FEAT_WARLOCK_BLOW_BLACKBOLT 			= 3321;
const int FEAT_WARLOCK_BLOW_BINDING 			= 3322;
const int FEAT_WARLOCK_SHIELD_ELDRTICH 			= 3323;
const int FEAT_WARLOCK_SHIELD_DRAINING 			= 3324;
const int FEAT_WARLOCK_SHIELD_FRIGHTFUL 		= 3325;
const int FEAT_WARLOCK_SHIELD_BSHADOWED 		= 3326;
const int FEAT_WARLOCK_SHIELD_BRIMSTONE 		= 3327;
const int FEAT_WARLOCK_SHIELD_HELLRIME 			= 3328;
const int FEAT_WARLOCK_SHIELD_BWITCHING 		= 3329;
const int FEAT_WARLOCK_SHIELD_NOXIOUS 			= 3330;
const int FEAT_WARLOCK_SHIELD_VITRIOLIC 		= 3331;
const int FEAT_WARLOCK_SHIELD_UTTERDARK 		= 3332;
const int FEAT_WARLOCK_SHIELD_BLACKBOLT 		= 3333;
const int FEAT_WARLOCK_SHIELD_BINDING 			= 3334;
const int FEAT_WARLOCK_CHAIN_ELDRITCH 			= 3335;
const int FEAT_WARLOCK_CHAIN_DRAINING 			= 3336;
const int FEAT_WARLOCK_CHAIN_FRIGHTFUL 			= 3337;
const int FEAT_WARLOCK_CHAIN_BSHADOWED 			= 3338;
const int FEAT_WARLOCK_CHAIN_BRIMSTONE 			= 3339;
const int FEAT_WARLOCK_CHAIN_HELLRIME 			= 3340;
const int FEAT_WARLOCK_CHAIN_BWITCHING 			= 3341;
const int FEAT_WARLOCK_CHAIN_NOXIOUS 			= 3342;
const int FEAT_WARLOCK_CHAIN_VITRIOLIC 			= 3343;
const int FEAT_WARLOCK_CHAIN_UTTERDARK 			= 3344;
const int FEAT_WARLOCK_CHAIN_BLACKBOLT 			= 3345;
const int FEAT_WARLOCK_CHAIN_BINDING 			= 3346;
const int FEAT_WARLOCK_BURST_ELDRITCH 			= 3347;
const int FEAT_WARLOCK_BURST_DRAINING 			= 3348;
const int FEAT_WARLOCK_BURST_FRIGHTFUL 			= 3349;
const int FEAT_WARLOCK_BURST_BSHADOWED 			= 3350;
const int FEAT_WARLOCK_BURST_BRIMSTONE 			= 3351;
const int FEAT_WARLOCK_BURST_HELLRIME 			= 3352;
const int FEAT_WARLOCK_BURST_BWITCHING 			= 3353;
const int FEAT_WARLOCK_BURST_NOXIOUS 			= 3354;
const int FEAT_WARLOCK_BURST_VITRIOLIC 			= 3355;
const int FEAT_WARLOCK_BURST_UTTERDARK 			= 3356;
const int FEAT_WARLOCK_BURST_BLACKBOLT 			= 3357;
const int FEAT_WARLOCK_BURST_BINDING 			= 3358;
const int FEAT_WARLOCK_DOOM_ELDRITCH 			= 3359;
const int FEAT_WARLOCK_DOOM_DRAINING 			= 3360;
const int FEAT_WARLOCK_DOOM_FRIGHTFUL 			= 3361;
const int FEAT_WARLOCK_DOOM_BSHADOWED 			= 3362;
const int FEAT_WARLOCK_DOOM_BRIMSTONE 			= 3363;
const int FEAT_WARLOCK_DOOM_HELLRIME 			= 3364;
const int FEAT_WARLOCK_DOOM_BWITCHING 			= 3365;
const int FEAT_WARLOCK_DOOM_NOXIOUS 			= 3366;
const int FEAT_WARLOCK_DOOM_VITRIOLIC 			= 3367;
const int FEAT_WARLOCK_DOOM_UTTERDARK 			= 3368;
const int FEAT_WARLOCK_DOOM_BLACKBOLT 			= 3369;
const int FEAT_WARLOCK_DOOM_BINDING 			= 3370;