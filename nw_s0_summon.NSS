/* Stripped all Bioware/Obsidan comments and reworked a lot of the script
hopefully to make thing a little clearier and make modification simpler - Agony_Aunt */

#include "x2_inc_spellhook" 
#include "ps_inc_functions"

// predefine the templates here as constants so easier to find and modify the templates.

// Special Note: Some of these constants were definied for MadPorthos' new alignment based summons
// Not included in this version, so commented out

// Bard Summons
// note, the tag on the level 1 bard summon is same for all, the different ones are for resrefs
const string SCOD_SUMMON_BARD_1_TAG = "ps_summon_bard_i";
const string SCOD_SUMMON_BARD_1_GOOD_MALE = "ps_summon_bard_i_gm";
const string SCOD_SUMMON_BARD_1_GOOD_FEMALE = "ps_summon_bard_i_gf";
const string SCOD_SUMMON_BARD_1_NEUTRAL_MALE = "ps_summon_bard_i_nm";
const string SCOD_SUMMON_BARD_1_NEUTRAL_FEMALE = "ps_summon_bard_i_nf";
const string SCOD_SUMMON_BARD_1_EVIL_MALE = "ps_summon_bard_i_em";
const string SCOD_SUMMON_BARD_1_EVIL_FEMALE = "ps_summon_bard_i_ef";
const string SCOD_SUMMON_BARD_2 = "ps_summon_bard_ii";
const string SCOD_SUMMON_BARD_3_GOOD = "ps_summon_bard_iii_good";
const string SCOD_SUMMON_BARD_3_NEUTRAL = "ps_summon_bard_iii_neutral";
const string SCOD_SUMMON_BARD_3_EVIL = "ps_summon_bard_iii_evil";
const string SCOD_SUMMON_BARD_4 = "ps_summon_bard_iv";
const string SCOD_SUMMON_BARD_5 = "ps_summon_bard_v";
const string SCOD_SUMMON_BARD_6 = "ps_summon_bard_vi";
 
// Spirit Shaman Summons
const string SCOD_SUMMON_SS_1 = "ps_summon_ss_i"; // Spirit Warrior - Undead 1
const string SCOD_SUMMON_SS_2 = "ps_summon_ss_ii"; // Sprit Crossbower - Undead 3
const string SCOD_SUMMON_SS_3 = "ps_summon_ss_iii"; // Spirit Fighter - Undead 5
const string SCOD_SUMMON_SS_4 = "ps_summon_ss_iv"; // Spirit Fencer - Undead 7
const string SCOD_SUMMON_SS_5 = "ps_summon_ss_v"; // Spirit Lurker - Undead 9
const string SCOD_SUMMON_SS_6 = "ps_summon_ss_vi"; // Spirit Barbarian - Undead 1/Barbarian 10
const string SCOD_SUMMON_SS_7 = "ps_summon_ss_vii"; // Spirit Archer - Undead 3/Arcane Archer 10
const string SCOD_SUMMON_SS_8 = "ps_summon_ss_viii"; // Spirit Sneaker - Undead 5/Shadowdancer 10
const string SCOD_SUMMON_SS_9 = "ps_summon_ss_ix"; // Spirit Magician - Undead 1/Wizard 19

// Druid and Ranger Summons
	//Summon I - Basic Melee - Magical Beast 1
	const string SCOD_SUMMON_DRUID_EVIL_1 = "ps_summon_i_druid_e"; 		// Blighttouched Stag
	const string SCOD_SUMMON_DRUID_GOOD_1 = "ps_summon_i_druid_g"; 		// Feytouched Stag
	//Summon II - Magical Beast 2/Rogue 1
	const string SCOD_SUMMON_DRUID_EVIL_2 = "ps_summon_ii_druid_e"; 	// Blighttouched Leopard
	const string SCOD_SUMMON_DRUID_GOOD_2 = "ps_summon_ii_druid_g"; 	// Feytouched Leopard
	//Summon III - Tank - Magical Beast 4/Stalwart Defender 2
	const string SCOD_SUMMON_DRUID_EVIL_3 = "ps_summon_iii_druid_e"; 	// Blighttouched Axebeak
	const string SCOD_SUMMON_DRUID_GOOD_3 = "ps_summon_iii_druid_g"; 	// Feytouched Axebeak
	//Summon IV - Melee DPS - Magical Beast 8
	const string SCOD_SUMMON_DRUID_EVIL_4 = "ps_summon_iv_druid_e"; 	// Blighttouched Raptor
	const string SCOD_SUMMON_DRUID_GOOD_4 = "ps_summon_iv_druid_g"; 	// Feytouched Raptor
	//Summon V - Stealth/HiPS - Magical Beast 2/Assassin 8
	const string SCOD_SUMMON_DRUID_EVIL_5 = "ps_summon_v_druid_e"; 		// Blighttouched Tiger
	const string SCOD_SUMMON_DRUID_GOOD_5 = "ps_summon_v_druid_g"; 		// Feytouched Tiger
	//Summon VI - Melee/Ranged - Fey 1/Ranger 11
	const string SCOD_SUMMON_DRUID_EVIL_6 = "ps_summon_vi_druid_e"; 	// Unseelie Archer
	const string SCOD_SUMMON_DRUID_GOOD_6 = "ps_summon_vi_druid_g"; 	// Seelie Archer
	const string SCOD_SUMMON_DRUID_NEUTRAL_6 = "ps_summon_vi_druid_n"; 	// Woodling Archer
	//Summon VII - Caster - Sorcerer 9/Eldritch Knight 9
	const string SCOD_SUMMON_DRUID_EVIL_7 = "ps_summon_vii_druid_e"; 	// Unseelie Battlemage
	const string SCOD_SUMMON_DRUID_GOOD_7 = "ps_summon_vii_druid_g"; 	// Seelie Battlemage
	const string SCOD_SUMMON_DRUID_NEUTRAL_7 = "ps_summon_vii_druid_n"; // Woodling Battlemage
	//Summon VIII - Advanced Melee - Fey 3/Fighter 4/Divine Champion 10
	const string SCOD_SUMMON_DRUID_EVIL_8 = "ps_summon_viii_druid_e"; 	// Unseelie Reaver
	const string SCOD_SUMMON_DRUID_GOOD_8 = "ps_summon_viii_druid_g"; 	// Seelie Knight
	const string SCOD_SUMMON_DRUID_NEUTRAL_8 = "ps_summon_viii_druid_n";// Woodling Forester
	//Summon IX - Paragon Form - Plant or Magical Beast 3/Divine Champion 7/Frenzied Berserker 10
	const string SCOD_SUMMON_DRUID_EVIL_9 = "ps_summon_ix_druid_e"; 	// Awakened Deathclaw
	const string SCOD_SUMMON_DRUID_GOOD_9 = "ps_summon_ix_druid_g"; 	// Awakened Tyrannosaur
	const string SCOD_SUMMON_DRUID_NEUTRAL_9 = "ps_summon_ix_druid_n";	// Woodling Behemoth

// General/default (ie cleric/arcane) summons - alignment based.
//Summon I - Basic Melee - Magical Beast 1
const string SCOD_SUMMON_1_GOOD 		= "ps_summon_i_good"; 		//Celestial Badger
const string SCOD_SUMMON_1_NEUTRAL 		= "ps_summon_i_neutral"; 	//Stonetouched Weasel
const string SCOD_SUMMON_1_EVIL 		= "ps_summon_i_evil"; 		//Fiendish Dire Rat

//Summon II - Agile/Stealth - Magical Beast 2/Rogue 1
const string SCOD_SUMMON_2_GOOD 		= "ps_summon_ii_good"; 		//Celestial Wolf
const string SCOD_SUMMON_2_NEUTRAL 		= "ps_summon_ii_neutral"; 	//Flametouched Panther
const string SCOD_SUMMON_2_EVIL 		= "ps_summon_ii_evil"; 		// Fiendish Worg

//Summon III - Tank - Magical Beast 4/Stalwart Defender 2
const string SCOD_SUMMON_3_GOOD 		= "ps_summon_iii_good"; 	//Celestial Bear
const string SCOD_SUMMON_3_NEUTRAL 		= "ps_summon_iii_neutral"; 	//Frosttouched Wolverine
const string SCOD_SUMMON_3_EVIL 		= "ps_summon_iii_evil"; 	//Fiendish Dire Boar

//Summon IV = Melee DPS - Outsider 8
const string SCOD_SUMMON_4_LAWFUL_GOOD 	= "ps_summon_iv_lg"; 		//Hammer Archon
const string SCOD_SUMMON_4_CHAOTIC_GOOD = "ps_summon_iv_cg"; 		//Ysgardian Dwarf
const string SCOD_SUMMON_4_NEUTRAL 		= "ps_summon_iv_n"; 		//Janni Dervish
const string SCOD_SUMMON_4_CHAOTIC_EVIL = "ps_summon_iv_ce"; 		//Carnage Demon
const string SCOD_SUMMON_4_LAWFUL_EVIL 	= "ps_summon_iv_le"; 		//Kyton

//Summon V - Stealth/HiPS - Outsider 2/Assassin 8
const string SCOD_SUMMON_5_LAWFUL_GOOD 	= "ps_summon_v_lg";			//Mercurial Slayer
const string SCOD_SUMMON_5_CHAOTIC_GOOD = "ps_summon_v_cg";			//Arboreal Stalker
const string SCOD_SUMMON_5_NEUTRAL 		= "ps_summon_v_n";			//Jann Assassin
const string SCOD_SUMMON_5_CHAOTIC_EVIL = "ps_summon_v_ce";			//Kelvezu
const string SCOD_SUMMON_5_LAWFUL_EVIL 	= "ps_summon_v_le";			//Dogai

//Summon VI - Melee/Ranged - Outsider 1/Ranger 11
const string SCOD_SUMMON_6_LAWFUL_GOOD	= "ps_summon_vi_lg";		//Agathinion Archer
const string SCOD_SUMMON_6_CHAOTIC_GOOD = "ps_summon_vi_cg";		//Bralani
const string SCOD_SUMMON_6_NEUTRAL 		= "ps_summon_vi_n";			//Jann Sniper
const string SCOD_SUMMON_6_CHAOTIC_EVIL = "ps_summon_vi_ce";		//Ranger of Yeenoghu
const string SCOD_SUMMON_6_LAWFUL_EVIL 	= "ps_summon_vi_le";		//Abrymoch Erinyes

//Summon VII - Caster - Sorcerer 9/Eldritch Knight 9
const string SCOD_SUMMON_7_LAWFUL_GOOD 	= "ps_summon_vii_lg";		//Exalted Arcanist
const string SCOD_SUMMON_7_CHAOTIC_GOOD = "ps_summon_vii_cg";		//Ghaele Magus
const string SCOD_SUMMON_7_NEUTRAL 		= "ps_summon_vii_n";		//Djinn Battlemage
const string SCOD_SUMMON_7_CHAOTIC_EVIL = "ps_summon_vii_ce";		//Alu-Fiend Sorcerer
const string SCOD_SUMMON_7_LAWFUL_EVIL 	= "ps_summon_vii_le";		//Amnizu Spellbinder

//Summon VIII - Advanced Melee - Outsider 3/Fighter 4/{Holy Warrior} 10
const string SCOD_SUMMON_8_LAWFUL_GOOD  = "ps_summon_viii_lg";		//Justice Archon Inquisitor
const string SCOD_SUMMON_8_CHAOTIC_GOOD = "ps_summon_viii_cg";		//Monadic Deva
const string SCOD_SUMMON_8_NEUTRAL 		= "ps_summon_viii_n";		//Efreeti Warblaze
const string SCOD_SUMMON_8_CHAOTIC_EVIL = "ps_summon_viii_ce";		//Death Knight
const string SCOD_SUMMON_8_LAWFUL_EVIL 	= "ps_summon_viii_le";		//Excruciarch

//Summon IX - Paragon Form - Outsider 3/Weapon Master 7/{Holy Warrior} 10
const string SCOD_SUMMON_9_LAWFUL_GOOD 	= "ps_summon_ix_lg";		//Stellar Deva
const string SCOD_SUMMON_9_CHAOTIC_GOOD = "ps_summon_ix_cg";		//Shiradri
const string SCOD_SUMMON_9_NEUTRAL		= "ps_summon_ix_n";			//Noble Marid
const string SCOD_SUMMON_9_CHAOTIC_EVIL = "ps_summon_ix_ce";		//Hezrou Eviscerator
const string SCOD_SUMMON_9_LAWFUL_EVIL 	= "ps_summon_ix_le";		//Brachina Hellknight

// Ad-hoc spell and feat templates
// Fiendish Legacy
const string SCOD_SUMMON_FIENDISH_LEGACY_LAWFUL = "ps_summon_fiendleg_l";
const string SCOD_SUMMON_FIENDISH_LEGACY_NEUTRAL = "ps_summon_fiendleg_n";
const string SCOD_SUMMON_FIENDISH_LEGACY_CHAOTIC = "ps_summon_fiendleg_e";

// Summon Undead Feat and Spells
const string SCOD_SUMMON_1_UNDEAD	= "ps_sum_undead_1";		//Bat, Bone
const string SCOD_SUMMON_2_UNDEAD	= "ps_sum_undead_2";		//Horse, Rotting
const string SCOD_SUMMON_3_UNDEAD	= "ps_sum_undead_3";		//Bear, Zombie
const string SCOD_SUMMON_4_UNDEAD 	= "ps_sum_undead_4";		//Ghast
const string SCOD_SUMMON_5_UNDEAD 	= "ps_sum_undead_5";		//Wraith
const string SCOD_SUMMON_6_UNDEAD 	= "ps_sum_undead_6";		//Skeleton
const string SCOD_SUMMON_7_UNDEAD 	= "ps_sum_undead_7";		//Wight
const string SCOD_SUMMON_8_UNDEAD 	= "ps_sum_undead_8";		//Devourer
const string SCOD_SUMMON_9_UNDEAD 	= "ps_sum_undead_9";		//Entropic Reaper

const string SCOD_SUMMON_1_UNDEAD2	= "ps_sum_undead_2";		//Horse, Rotting
const string SCOD_SUMMON_2_UNDEAD2	= "ps_sum_undead_3";		//Bear, Zombie
const string SCOD_SUMMON_3_UNDEAD2	= "ps_sum_undead_4";		//Ghast
const string SCOD_SUMMON_4_UNDEAD2 	= "ps_sum_undead_5";		//Wraith
const string SCOD_SUMMON_5_UNDEAD2 	= "ps_sum_undead_6";		//Skeleton
const string SCOD_SUMMON_6_UNDEAD2 	= "ps_sum_undead_7";		//Wight
const string SCOD_SUMMON_7_UNDEAD2 	= "ps_sum_undead_8";		//Devourer
const string SCOD_SUMMON_8_UNDEAD2 	= "ps_sum_undead_9";		//Entropic Reaper
const string SCOD_SUMMON_9_UNDEAD2 	= "ps_sum_undead_91";		//Death Tyrant


// Shades on Ground
const string SCOD_SUMMON_SHADES_GROUND = "ps_shades_summon";


int SetSummonDuration(int nSpellID, object oPC)
{
	int nDuration = PS_GetCasterLevel(oPC) + 3;
		
	switch ( nSpellID )
	{
	case (SPELL_SUMMON_CREATURE_I):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_II):
		{
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_III):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_IV):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_V):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_VI):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_VII):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_VIII):
	
        {	
			{nDuration = nDuration * 10;}				    	
        }		
  	case (SPELL_SHADES_TARGET_GROUND):
        {
            nDuration = nDuration * 10;
        }
	break;
	case (SPELL_SUMMON_CREATURE_IX):
        {
            nDuration = nDuration * 10;
        }
	break;
	}
	
	return nDuration;
}

string GetSummonCreatureTemplate(int nSpellID, int iAlignGE, int iAlignLC, int iClass, object oPC)
{
	string sTemplate = "c_pig"; // if no valid template then default to pig
	int iGender;
	
	if (nSpellID == SPELL_SHADES_TARGET_GROUND)
		{	sTemplate = SCOD_SUMMON_SHADES_GROUND; }

	// now the undead feats.  1) Corpse Crafter & Necromantic Might		
	else if (GetHasFeat(3616) && GetHasFeat(3617))
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				sTemplate = SCOD_SUMMON_1_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				sTemplate = SCOD_SUMMON_2_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				sTemplate = SCOD_SUMMON_3_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				sTemplate = SCOD_SUMMON_4_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				sTemplate = SCOD_SUMMON_5_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				sTemplate = SCOD_SUMMON_6_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_VII): 
				sTemplate = SCOD_SUMMON_7_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_VIII): 
				sTemplate = SCOD_SUMMON_8_UNDEAD2;
				break;
			case (SPELL_SUMMON_CREATURE_IX): 
				sTemplate = SCOD_SUMMON_9_UNDEAD2;
				break;
		}
	}	
	// 2) Corpse Crafter			
	else if (GetHasFeat(3616))
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				sTemplate = SCOD_SUMMON_1_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				sTemplate = SCOD_SUMMON_2_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				sTemplate = SCOD_SUMMON_3_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				sTemplate = SCOD_SUMMON_4_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				sTemplate = SCOD_SUMMON_5_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				sTemplate = SCOD_SUMMON_6_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_VII): 
				sTemplate = SCOD_SUMMON_7_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_VIII): 
				sTemplate = SCOD_SUMMON_8_UNDEAD;
				break;
			case (SPELL_SUMMON_CREATURE_IX): 
				sTemplate = SCOD_SUMMON_9_UNDEAD;
				break;
		}
	}		
	// now specific classes
	else if (iClass == CLASS_TYPE_RANGER)
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_1;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_1;
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_1;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_2;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_2;
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_2;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_3;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_3; 
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_3;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_4;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_4; 
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_4;
				break;
		}
	}
	else if (iClass == CLASS_TYPE_DRUID)
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_1;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_1;
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_1;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_2;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_2;
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_2;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_3;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_3; 
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_3;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_4;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_4; 
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_4;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_5;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_5; 
				else sTemplate = SCOD_SUMMON_DRUID_GOOD_5;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_6;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_6; 
				else sTemplate = SCOD_SUMMON_DRUID_NEUTRAL_6;
				break;
			case (SPELL_SUMMON_CREATURE_VII): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_7;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_7; 
				else sTemplate = SCOD_SUMMON_DRUID_NEUTRAL_7;
				break;
			case (SPELL_SUMMON_CREATURE_VIII): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_8;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_8; 
				else sTemplate = SCOD_SUMMON_DRUID_NEUTRAL_8;
				break;
			case (SPELL_SUMMON_CREATURE_IX): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_DRUID_GOOD_9;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_DRUID_EVIL_9; 
				else sTemplate = SCOD_SUMMON_DRUID_NEUTRAL_9;
				break;
		}
	}
	else if (iClass == CLASS_TYPE_BARD)
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				iGender = GetGender(oPC);
				if (iAlignGE == ALIGNMENT_GOOD)
				{
					if (iGender == GENDER_MALE) sTemplate = SCOD_SUMMON_BARD_1_GOOD_MALE;
					else sTemplate = SCOD_SUMMON_BARD_1_GOOD_FEMALE;
				}
				else if (iAlignGE == ALIGNMENT_EVIL)
				{
					if (iGender == GENDER_MALE) sTemplate = SCOD_SUMMON_BARD_1_EVIL_MALE;
					else sTemplate = SCOD_SUMMON_BARD_1_EVIL_FEMALE;
				} 
				else 
				{
					if (iGender == GENDER_MALE) sTemplate = SCOD_SUMMON_BARD_1_NEUTRAL_MALE;
					else sTemplate = SCOD_SUMMON_BARD_1_NEUTRAL_FEMALE;
				}
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				sTemplate = SCOD_SUMMON_BARD_2;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_BARD_3_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_BARD_3_EVIL;
				else sTemplate = SCOD_SUMMON_BARD_3_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				sTemplate = SCOD_SUMMON_BARD_4;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				sTemplate = SCOD_SUMMON_BARD_5;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				sTemplate = SCOD_SUMMON_BARD_6;
				break;
		}
	}
	else if (iClass == CLASS_TYPE_SPIRIT_SHAMAN)
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				sTemplate = SCOD_SUMMON_SS_1;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				sTemplate = SCOD_SUMMON_SS_2;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				sTemplate = SCOD_SUMMON_SS_3;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				sTemplate = SCOD_SUMMON_SS_4;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				sTemplate = SCOD_SUMMON_SS_5;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				sTemplate = SCOD_SUMMON_SS_6;
				break;
			case (SPELL_SUMMON_CREATURE_VII): 
				sTemplate = SCOD_SUMMON_SS_7;
				break;
			case (SPELL_SUMMON_CREATURE_VIII): 
				sTemplate = SCOD_SUMMON_SS_8;
				break;
			case (SPELL_SUMMON_CREATURE_IX): 
				sTemplate = SCOD_SUMMON_SS_9;
				break;
		}
	}
	// else, its a general summon spell probably from Wiz/Sorc/FS or Cleric
	// or its also fall back for if from magic item
	else
	{
		switch (nSpellID)
		{
			case (SPELL_SUMMON_CREATURE_I): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_1_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_1_EVIL;
				else sTemplate = SCOD_SUMMON_1_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_II): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_2_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_2_EVIL;
				else sTemplate = SCOD_SUMMON_2_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_III): 
				if (iAlignGE == ALIGNMENT_GOOD) sTemplate = SCOD_SUMMON_3_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_3_EVIL; 
				else sTemplate = SCOD_SUMMON_3_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_IV): 
				if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_4_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_4_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_4_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_4_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_4_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_V): 
				// special case for Fiendish Legacy first
				if (iClass == CLASS_TYPE_INVALID && GetHasFeat(FEAT_FIENDISH_LEGACY, oPC))
					{
					if (iAlignLC == ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_FIENDISH_LEGACY_CHAOTIC;
					else if (iAlignLC == ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_FIENDISH_LEGACY_LAWFUL;
					else sTemplate = SCOD_SUMMON_FIENDISH_LEGACY_NEUTRAL;
					}
				else if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_5_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_5_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_5_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_5_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_5_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_VI): 
				if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_6_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_6_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_6_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_6_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_6_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_VII): 
				if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_7_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_7_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_7_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_7_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_7_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_VIII): 
				if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_8_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_8_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_8_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_8_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_8_NEUTRAL;
				break;
			case (SPELL_SUMMON_CREATURE_IX): 
				if (iAlignGE == ALIGNMENT_GOOD && iAlignLC != ALIGNMENT_CHAOTIC) sTemplate = SCOD_SUMMON_9_LAWFUL_GOOD;
				else if (iAlignLC == ALIGNMENT_CHAOTIC && iAlignGE != ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_9_CHAOTIC_GOOD;
				else if (iAlignGE == ALIGNMENT_EVIL && iAlignLC != ALIGNMENT_LAWFUL) sTemplate = SCOD_SUMMON_9_CHAOTIC_EVIL;
				else if (iAlignLC == ALIGNMENT_LAWFUL && iAlignGE == ALIGNMENT_EVIL) sTemplate = SCOD_SUMMON_9_LAWFUL_EVIL;
				else sTemplate = SCOD_SUMMON_9_NEUTRAL;
				break;
		}
	}
	return sTemplate;
}

void DoLoyalFanWelcome(object oPC, string sTemplate)
{
	object oNPC;
	object oOwner;
	location lPC = GetLocation(oPC);
	float fDelay = 1.0;
	
	oNPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lPC, FALSE, OBJECT_TYPE_CREATURE);
	while(oNPC != OBJECT_INVALID)
	{
		if (GetTag(oNPC) == SCOD_SUMMON_BARD_1_TAG)
		{
			oOwner = GetMaster(oNPC);
			if (oOwner == oPC)
			{
				DelayCommand(fDelay, SetCreatureScriptsToSet(oNPC, 0));
				DelayCommand(fDelay + 0.2, AssignCommand(oNPC, ClearAllActions(TRUE)));
				DelayCommand(fDelay + 1.0, AssignCommand(oNPC, ActionSpeakString("Wow! It's " + GetName(oOwner) + "!!! I'm your number one fan!", TALKVOLUME_TALK)));
				DelayCommand(fDelay + 2.0, SetCreatureScriptsToSet(oNPC, 10));
				
			}
			else
			{
				fDelay = fDelay + (IntToFloat(Random(20)) / 10.0) + 1.0;
				DelayCommand(fDelay, SetCreatureScriptsToSet(oNPC, 0));
				DelayCommand(fDelay + 0.2, AssignCommand(oNPC, ClearAllActions(TRUE)));
				DelayCommand(fDelay + 1.0, AssignCommand(oNPC, ActionSpeakString("And i'm your number one fan " + GetName(oOwner) + "!!!", TALKVOLUME_TALK)));
				DelayCommand(fDelay + 2.0, SetCreatureScriptsToSet(oNPC, 10));
			}
		}
   		oNPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lPC, FALSE, OBJECT_TYPE_CREATURE);
	}
	
}

// So far, this is only for Loyal fan, but can use this routine to cause summons to take specific actions
// after spawning.
void ApplyPostSummonActions(object oPC, string sTemplate)
{
	if (GetStringLeft(sTemplate, 16) == SCOD_SUMMON_BARD_1_TAG)
		DelayCommand(1.0,DoLoyalFanWelcome(oPC, sTemplate));
}

// Summoning Mastery Feat by Ceremorph 2/4/15
// If character has the feat, the creatue gains two levels of outsider and a +1 unholy bonus to damage
void ApplySummonMastery(object oCaster = OBJECT_SELF)
{
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
	if (!GetIsObjectValid(oSummon))
	{
		return;
	}
	
	effect eSumMast;
	
	// If the character has Summoning Mastery Feat and Corpse Master Feat the summons gain +2 dmg.
	if (GetHasFeat(2614, oCaster, TRUE) && GetHasFeat(3616, oCaster, TRUE))
	{
		eSumMast = ExtraordinaryEffect(EffectDamageIncrease(2, DAMAGE_TYPE_NEGATIVE));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eSumMast, oSummon);
	}
	// Two Levels and 1 damage.
	else if (GetHasFeat(2614, oCaster, TRUE))
	{
		eSumMast = ExtraordinaryEffect(EffectDamageIncrease(1, DAMAGE_TYPE_DIVINE));
		
			LevelUpHenchman(oSummon,CLASS_TYPE_OUTSIDER,0,PACKAGE_OUTSIDER);
			LevelUpHenchman(oSummon,CLASS_TYPE_OUTSIDER,0,PACKAGE_OUTSIDER);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eSumMast, oSummon);
	}
}


void main()
{
    if (!X2PreSpellCastCode()) { return; }

    int nSpellID = GetSpellId();
	object oPC = OBJECT_SELF;
    int nDuration = SetSummonDuration(nSpellID, oPC);
	
	int iAlignmentGE = GetAlignmentGoodEvil(OBJECT_SELF);
	int iAlignmentLC = GetAlignmentLawChaos(OBJECT_SELF);
	int iClass = GetLastSpellCastClass();
	
	string sTemplate = GetSummonCreatureTemplate(nSpellID, iAlignmentGE, iAlignmentLC, iClass, oPC);
	effect eSummon = EffectSummonCreature(sTemplate, VFX_HIT_SPELL_SUMMON_CREATURE);
	
	int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) { nDuration = nDuration *2; }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(),RoundsToSeconds(nDuration));
	
	DelayCommand(1.0, ApplySummonMastery());
	
	ApplyPostSummonActions(oPC, sTemplate);
}