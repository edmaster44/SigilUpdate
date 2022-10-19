// Created by Agony_Aunt/Loki.
// in creature spawn script chance to call the main function here to make a unique random item for drop similar to 
// the gambler (using same code), but with addition of interesting names and descriptions.



#include "ps_randomlootgenerator"

const string RANDOM_DROP_COLOUR = "<C=SteelBlue>";

void SetRandomItemIcon(object oItem)
{
	int iIcon;
	
	switch (GetBaseItemType(oItem))
	{
		case BASE_ITEM_ARMOR:
		{
			switch (GetArmorRulesType(oItem))
			{
				case 0: /*Cloth*/ iIcon = 2032; break;
				case 1: /*Padded*/ iIcon = 500; break;
				case 2: /*Leather*/ iIcon = 527; break;
				case 3: /*Studdded*/ iIcon = 511; break;
				case 4: /*Chain Shirt*/ iIcon = 538; break;
				case 5: /*Scale*/ iIcon = 576; break;
				case 6: /*Banded*/ iIcon = 611; break;
				case 7: /*Half-Plate*/ iIcon = 605; break;
				case 8: /*Full-Plate*/ iIcon = 621; break;
				case 12: /*Hide*/ iIcon = 565; break;
				case 13: /*Chainmail*/ iIcon = 554; break;
				case 14: /*Breastplate*/ iIcon = 586; break;
			}
		}
		break;
		
		case BASE_ITEM_SMALLSHIELD: iIcon = 637; break;
		case BASE_ITEM_LARGESHIELD: iIcon = 1920; break;
		case BASE_ITEM_TOWERSHIELD: iIcon = 640; break;
		case BASE_ITEM_DAGGER: iIcon = 825; break;
		case BASE_ITEM_SICKLE: iIcon = 903; break;
		case BASE_ITEM_HANDAXE: iIcon = 1163; break;
		case BASE_ITEM_KUKRI: iIcon = 927; break;
		case BASE_ITEM_SHORTSWORD: iIcon = 811; break;
		case BASE_ITEM_KAMA: iIcon = 915; break;
		case BASE_ITEM_BATTLEAXE: iIcon = 688; break;
		case BASE_ITEM_LONGSWORD: iIcon = 839; break;
		case BASE_ITEM_RAPIER: iIcon = 898; break;
		case BASE_ITEM_SCIMITAR: iIcon = 886; break;
		case BASE_ITEM_BASTARDSWORD: iIcon = 862; break;
		case BASE_ITEM_DWARVENWARAXE: iIcon = 622; break;
		case BASE_ITEM_KATANA: iIcon = 865; break;
		case BASE_ITEM_FALCHION: iIcon = 2000; break;
		case BASE_ITEM_GREATAXE: iIcon = 709; break;
		case BASE_ITEM_GREATSWORD: iIcon = 852; break;
		case BASE_ITEM_MACE: iIcon = 756; break;
		case BASE_ITEM_LIGHTHAMMER: iIcon = 738; break;
		case BASE_ITEM_CLUB: iIcon = 766; break;
		case BASE_ITEM_MORNINGSTAR: iIcon = 792; break;
		case BASE_ITEM_WARHAMMER: iIcon = 729; break;
		case BASE_ITEM_FLAIL: iIcon = 792; break;
		case BASE_ITEM_WARMACE: iIcon = 1771; break;
		case BASE_ITEM_HALBERD: iIcon = 966; break;
		case BASE_ITEM_SCYTHE: iIcon = 952; break;
		case BASE_ITEM_QUARTERSTAFF: iIcon = 938; break;
		case BASE_ITEM_SPEAR: iIcon = 985; break;
		case BASE_ITEM_LONGBOW: iIcon = 1060; break;
		case BASE_ITEM_SHORTBOW: iIcon = 1049; break;
		case BASE_ITEM_HEAVYCROSSBOW: iIcon = 1014; break;
		case BASE_ITEM_LIGHTCROSSBOW: iIcon = 1026; break;
		case BASE_ITEM_SLING: iIcon = 988; break;
		case BASE_ITEM_BOOTS: iIcon = 421; break;
		case BASE_ITEM_CLOAK: iIcon = 374; break;
		case BASE_ITEM_GLOVES: iIcon = 463; break;
		case BASE_ITEM_BELT: iIcon = 392; break;
		case BASE_ITEM_HELMET: iIcon = 354; break;
		case BASE_ITEM_RING: iIcon = 250; break;
		case BASE_ITEM_AMULET: iIcon = 1175; break;
		case BASE_ITEM_BRACER: iIcon = 432; break;
	}
	
	if (iIcon != 0) SetItemIcon(oItem, iIcon); // actually from nwn2_icons.2da, not itemicons.2da like suggested
}

void GenerateItemDescription(object oItem)
{
	string sTitle = GetLocalString(oItem, "RANDOM_TITLE");
	string sName = GetLocalString(oItem, "RANDOM_NAME");
	string sNick = GetLocalString(oItem, "RANDOM_NICK");
	string sDesc;
	
	// intro
	sDesc = "This item belonged to " + sName;
	
	switch (Random(7))
	{
		case 0: sDesc += " often called the "; break;
		case 1: sDesc += " frequently called the "; break;
		case 2: sDesc += " sometimes known as the "; break;
		case 3: sDesc += " occasionally referred to as the "; break;
		case 4: sDesc += " who was called by his friends the "; break;
		case 5: sDesc += " who was called by his enemies the "; break;
		case 6: sDesc += " who called himself the "; break;
	}
	
	sDesc += sNick + ". " + sName + " was ";
	
	if (sTitle == "")
	{
		switch (Random(8))
		{
			case 0: sDesc += "nobody important"; break;
			case 1: sDesc += "a hero"; break;
			case 2: sDesc += "a victim of fate"; break;
			case 3: sDesc += "initially a backwater villager"; break;
			case 4: sDesc += "a person of little repute"; break;
			case 5: sDesc += "an outspoken politician"; break;
			case 6: sDesc += "a lazy servant"; break;
			case 7: sDesc += "the champion of a nation"; break;
		}
	}
	else
	{
		sDesc += "a ruler";
	}
	
	sDesc += " from ";
	
	switch (Random(20))
	{
		case 0: sDesc+= "Athas."; break;
		case 1: sDesc+= "the backwater prime known as Toril."; break;
		case 2: sDesc+= "some unknown prime."; break;
		case 3: sDesc+= "the wondrous prime of Oerth."; break;
		case 4: sDesc+= "the evil demi-plane of Ravenloft."; break;
		case 5: sDesc+= "the little known world of Mystara."; break;
		case 6: sDesc+= "the prime of Eberron."; break;
		case 7: sDesc+= "the irrelevant prime of Krynn."; break;
		case 8: sDesc+= "Blackmoor."; break;
		case 9: sDesc+= "the strange prime known as Aebrynis."; break;
		case 10: sDesc+= "the thousand blessed lands of Zakhara on Toril, may a hundred songbirds praise its name for eternity!"; break;
		case 11: sDesc+= "Kara-tur, a honourable land on the plane known as Toril."; break;
		case 12: sDesc+= "the Outlands."; break;
		case 13: sDesc+= "a place best not mentioned."; break;
		case 14: sDesc+= "Sigil."; break;
		case 15: sDesc+= "one of the Elemental planes."; break;
		case 16: sDesc+= "a distant corner of the multiverse."; break;
		case 17: sDesc+= "the lower planes."; break;
		case 18: sDesc+= "the higher planes."; break;
		case 19: sDesc+= "somewhere in the outer planes, although historians are unclear about the origin."; break;		
	}
	
	sDesc += " They died ";
	
	switch (Random(4))
	{
		case 0: sDesc += "a long time ago,"; break;
		case 1: sDesc += "some years ago,"; break;
		case 2: sDesc += "just last year,"; break;
		case 3: sDesc += IntToString(Random(10000) + 100) + " years before Hashkar's Reign,"; break;
	}
	
	switch (Random(17))
	{
		case 0: sDesc += " due to an arrow in the knee."; break;
		case 1: sDesc += " at a ripe old age of " + IntToString(Random(50) + 50) + " in their bed"; break;
		case 2: sDesc += " of a heart attack while visiting Broken Reach."; break;
		case 3: sDesc += " in the middle of a speech about defying the gods. No remains were ever found."; break;
		case 4: sDesc += " while battling a dragon."; break;
		case 5: sDesc += " while commanding his army to attack against superior forces."; break;
		case 6: sDesc += " in their sleep."; break;
		case 7: sDesc += " due to a terrible misunderstanding involving a philosopher, a turtle, and an arrow."; break;
		case 8: sDesc += " at the hands of an assassin."; break;
		case 9: sDesc += " because even a magically enhanced hero can't do much against a Tarrasque."; break;
		case 10: sDesc += " when they slipped on a patch of ice, breaking their neck."; break;
		case 11: sDesc += " in glorious battle."; break;
		case 12: sDesc += " by an arrow in the back while running from superior forces."; break;
		case 13: sDesc += " while astrally projecting."; break;
		case 14: sDesc += " while eating a meal and choking to death on a fish bone."; break;
		case 15: sDesc += " when they were flayed by the Lady of Pain."; break;
		case 16: sDesc += " when they mysteriously disappeared, all that was left was a pair of smoking boots."; break;
	}
	
	SetDescription(oItem, sDesc);
}

// Gets first property on the item and returns a string based on that as the value.
// eg: If AC then the return value may be Defense, if Cold Damage then Cold, if vs Race then <race slaying>
void GenerateItemPropertyName(object oItem)
{
	itemproperty ipFirst = GetFirstItemProperty(oItem);
	int iTotalProps = 0;
	while (GetIsItemPropertyValid(ipFirst))
	{
		iTotalProps++;
		ipFirst = GetNextItemProperty(oItem);
	}
	
	int iSelectedProperty = Random(iTotalProps) + 1;
	
	ipFirst = GetFirstItemProperty(oItem);
	int iCount = 1;
	while (iCount != iSelectedProperty)
	{
		iCount++;
		ipFirst = GetNextItemProperty(oItem);
	}
	
	int iPropertyType = GetItemPropertyType(ipFirst);
	int iPropertySubType = GetItemPropertySubType(ipFirst);
	//int iPropertyParam1 = GetItemPropertyParam1(ipFirst);
	//int iPropertyParam1Value = GetItemPropertyParam1Value(ipFirst);
	int iBaseItemType = GetBaseItemType(oItem);
	//int iPropertyCostTable = GetItemPropertyCostTable(ipFirst);
	//int iPropertyCostTableValue = GetItemPropertyCostTableValue(ipFirst);
	string sPropertyPrefix;
	string sPropertySuffix;
	
	// DebugSection
	/*object oPC = GetFirstPC();
	SendMessageToPC(oPC, "Property Type = " + IntToString(iPropertyType));
	SendMessageToPC(oPC, "Property Sub Type = " + IntToString(iPropertySubType));
	SendMessageToPC(oPC, "Property Param = " + IntToString(iPropertyParam1));
	SendMessageToPC(oPC, "Property Param Value = " + IntToString(iPropertyParam1Value));
	SendMessageToPC(oPC, "Property Table = " + IntToString(iPropertyCostTable));
	SendMessageToPC(oPC, "Property Table Value = " + IntToString(iPropertyCostTableValue));*/
		
	if (GetIsItemPropertyValid(ipFirst))
	{
		switch (iPropertyType)
		{
			case ITEM_PROPERTY_ABILITY_BONUS:
			{
				switch (iPropertySubType)
				{
					case 0: sPropertySuffix = "of Might"; break;
					case 1: sPropertySuffix = "of Nimbleness"; break;
					case 2: sPropertySuffix = "of Fortification"; break;
					case 3: sPropertySuffix = "of Knowledge"; break;
					case 4: sPropertySuffix = "of Wisdom"; break;
					case 5: sPropertySuffix = "of Charm"; break;
					default: sPropertySuffix = "of Ability";  break;
				}
			}
			break;
			case ITEM_PROPERTY_AC_BONUS:
			{
				switch (iBaseItemType)
				{
					case BASE_ITEM_BOOTS: sPropertyPrefix = "Dodging"; break;
					case BASE_ITEM_SMALLSHIELD:
					case BASE_ITEM_TOWERSHIELD:
					case BASE_ITEM_LARGESHIELD:
					case BASE_ITEM_ARMOR:
						sPropertyPrefix = "Reinforced"; break;
					case BASE_ITEM_AMULET:
					case BASE_ITEM_BRACER:
					case BASE_ITEM_CLOAK:
					case BASE_ITEM_GLOVES:
					case BASE_ITEM_RING:
						sPropertySuffix = "of Protection"; break;
					// otherwise going to be a weapon
					default: sPropertySuffix = "Defender"; break;
				}
			}
			break;
			case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
			case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
			case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
			case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
			{
				switch (iPropertySubType)
				{
					case ALIGNMENT_NEUTRAL: sPropertyPrefix = "Dogmatic"; break;
					case ALIGNMENT_LAWFUL: sPropertyPrefix = "Anarchic"; break;
					case ALIGNMENT_CHAOTIC: sPropertyPrefix = "Axiomatic"; break;
					case ALIGNMENT_GOOD: sPropertyPrefix = "Unholy"; break;
					case ALIGNMENT_EVIL: sPropertyPrefix = "Holy"; break;
					default: break;
				}
			}
			break;
			case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_RACIALTYPE_DWARF: sPropertyPrefix = "Protective"; sPropertySuffix = "against Dwarves"; break;
					case IP_CONST_RACIALTYPE_ELF: sPropertyPrefix = "Protective"; sPropertySuffix = "against Elves"; break;
					case IP_CONST_RACIALTYPE_GNOME: sPropertyPrefix = "Protective"; sPropertySuffix = "against Gnomes"; break;
					case IP_CONST_RACIALTYPE_HALFLING: sPropertyPrefix = "Protective"; sPropertySuffix = "against Halflings"; break;
					case IP_CONST_RACIALTYPE_HALFELF: sPropertyPrefix = "Protective"; sPropertySuffix = "against Half-Elves"; break;
					case IP_CONST_RACIALTYPE_HALFORC: sPropertyPrefix = "Protective"; sPropertySuffix = "against Half-Orcs"; break;
					case IP_CONST_RACIALTYPE_HUMAN: sPropertyPrefix = "Protective"; sPropertySuffix = "against Humans"; break;
					case IP_CONST_RACIALTYPE_ABERRATION: sPropertyPrefix = "Protective"; sPropertySuffix = "against Aberrations"; break;
					case IP_CONST_RACIALTYPE_ANIMAL: sPropertyPrefix = "Protective"; sPropertySuffix = "against Rabid Animals"; break;
					case IP_CONST_RACIALTYPE_BEAST: sPropertyPrefix = "Protective"; sPropertySuffix = "against Beasts"; break;
					case IP_CONST_RACIALTYPE_CONSTRUCT: sPropertyPrefix = "Protective"; sPropertySuffix = "against Constructs"; break;
					case IP_CONST_RACIALTYPE_DRAGON: sPropertyPrefix = "Protective"; sPropertySuffix = "against Dragons"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID: sPropertyPrefix = "Protective"; sPropertySuffix = "against Goblins"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS: sPropertyPrefix = "Protective"; sPropertySuffix = "against Monstrous Nasties"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_ORC: sPropertyPrefix = "Protective"; sPropertySuffix = "against Orcs"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN: sPropertyPrefix = "Protective"; sPropertySuffix = "against Reptilians"; break;
					case IP_CONST_RACIALTYPE_ELEMENTAL: sPropertyPrefix = "Protective"; sPropertySuffix = "against Elementals"; break;
					case IP_CONST_RACIALTYPE_FEY: sPropertyPrefix = "Protective"; sPropertySuffix = "against Fey"; break;
					case IP_CONST_RACIALTYPE_GIANT: sPropertyPrefix = "Protective"; sPropertySuffix = "against Giants"; break;
					case IP_CONST_RACIALTYPE_MAGICAL_BEAST: sPropertyPrefix = "Protective"; sPropertySuffix = "against Magical Beasts"; break;
					case IP_CONST_RACIALTYPE_OUTSIDER: sPropertyPrefix = "Protective"; sPropertySuffix = "against Outsiders"; break;
					case 21: /*Planetouched*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Planetouched"; break;
					case 22: /*Plant*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Plants"; break;
					case IP_CONST_RACIALTYPE_SHAPECHANGER: sPropertyPrefix = "Protective"; sPropertySuffix = "against Shapechangers"; break;
					case IP_CONST_RACIALTYPE_UNDEAD: sPropertyPrefix = "Protective"; sPropertySuffix = "against Undead"; break;
					case IP_CONST_RACIALTYPE_VERMIN: sPropertyPrefix = "Protective"; sPropertySuffix = "against Vermin"; break;
					case 29: /*Ooze*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Oozes"; break;
					case 30: /*Incorporeal*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Incorporeal"; break;
					case 31: /*Yuan-ti*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Yuan-ti"; break;
					case 32: /*Orc???*/ sPropertyPrefix = "Protective"; sPropertySuffix = "against Orcs"; break;
				}
			}
			break;
			case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
			case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
			case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_RACIALTYPE_DWARF: sPropertySuffix = "of Dwarf Slaying"; break;
					case IP_CONST_RACIALTYPE_ELF: sPropertySuffix = "of Elf Slaying"; break;
					case IP_CONST_RACIALTYPE_GNOME: sPropertySuffix = "of Gnome Slaying"; break;
					case IP_CONST_RACIALTYPE_HALFLING: sPropertySuffix = "of Halfling Slaying"; break;
					case IP_CONST_RACIALTYPE_HALFELF: sPropertySuffix = "of Half-Elf Slaying"; break;
					case IP_CONST_RACIALTYPE_HALFORC: sPropertySuffix = "of Half-Orc Slaying"; break;
					case IP_CONST_RACIALTYPE_HUMAN: sPropertySuffix = "of Human Slaying"; break;
					case IP_CONST_RACIALTYPE_ABERRATION: sPropertySuffix = "of Aberration Slaying"; break;
					case IP_CONST_RACIALTYPE_ANIMAL: sPropertySuffix = "of Animal Cruelty"; break;
					case IP_CONST_RACIALTYPE_BEAST: sPropertySuffix = "of Beast Slaying"; break;
					case IP_CONST_RACIALTYPE_CONSTRUCT: sPropertySuffix = "of Construct Slaying"; break;
					case IP_CONST_RACIALTYPE_DRAGON: sPropertySuffix = "of Dragon Slaying"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID: sPropertySuffix = "of Goblin Slaying"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS: sPropertySuffix = "of Monstrous Creature Slaying"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_ORC: sPropertySuffix = "of Orc Slaying"; break;
					case IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN: sPropertySuffix = "of Reptilian Slaying"; break;
					case IP_CONST_RACIALTYPE_ELEMENTAL: sPropertySuffix = "of Elemental Slaying"; break;
					case IP_CONST_RACIALTYPE_FEY: sPropertySuffix = "of Fey Slaying"; break;
					case IP_CONST_RACIALTYPE_GIANT: sPropertySuffix = "of Giant Slaying"; break;
					case IP_CONST_RACIALTYPE_MAGICAL_BEAST: sPropertySuffix = "of Magical Beast Slaying"; break;
					case IP_CONST_RACIALTYPE_OUTSIDER: sPropertySuffix = "of Outsider Slaying"; break;
					case 21: /*Planetouched*/ sPropertySuffix = "of Planetouched Slaying"; break;
					case 22: /*Plant*/ sPropertySuffix = "of Plant Uprooting"; break;
					case IP_CONST_RACIALTYPE_SHAPECHANGER: sPropertySuffix = "of Shapechanger Slaying"; break;
					case IP_CONST_RACIALTYPE_UNDEAD: sPropertySuffix = "of Undead Slaying"; break;
					case IP_CONST_RACIALTYPE_VERMIN: sPropertySuffix = "of Vermin Slaying"; break;
					case 29: /*Ooze*/ sPropertySuffix = "of Ooze Slaying"; break;
					case 30: /*Incorporeal*/ sPropertySuffix = "of Incorporeal Slaying"; break;
					case 31: /*Yuan-ti*/ sPropertySuffix = "of Yuan-ti Slaying"; break;
					case 32: /*Orc???*/ sPropertySuffix = "of Orc Slaying"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_ATTACK_BONUS: sPropertyPrefix = "Accurate"; break;
			case ITEM_PROPERTY_ENHANCEMENT_BONUS: sPropertyPrefix = "Enhanced"; break;
			
			case ITEM_PROPERTY_DAMAGE_BONUS: 
			{
				switch (iPropertySubType)
				{
					case IP_CONST_DAMAGETYPE_ACID: sPropertyPrefix = "Acidic"; break;
					case IP_CONST_DAMAGETYPE_COLD: sPropertyPrefix = "Freezing"; break;
					case IP_CONST_DAMAGETYPE_FIRE: sPropertyPrefix = "Flaming"; break;
					case IP_CONST_DAMAGETYPE_ELECTRICAL: sPropertyPrefix = "Lightning"; break;
					case IP_CONST_DAMAGETYPE_SONIC: sPropertyPrefix = "Sonic"; break;
					default: sPropertyPrefix = "Damaging"; break;
				}	
			}
			break;
			
			case ITEM_PROPERTY_BONUS_FEAT:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_FEAT_ALERTNESS: sPropertySuffix = "of Alertness"; break;
					case IP_CONST_FEAT_CLEAVE: sPropertySuffix = "of Cleaving"; break;
					case IP_CONST_FEAT_COMBAT_CASTING: sPropertySuffix = "of the Battle Mage"; break;
					case IP_CONST_FEAT_DEFLECT_ARROWS: sPropertySuffix = "of the Swift Hand"; break;
					case IP_CONST_FEAT_DODGE: sPropertySuffix = "of Avoidance"; break;
					case IP_CONST_FEAT_EXTENDED_RAGE: sPropertyPrefix = "Screaming"; break;
					case IP_CONST_FEAT_EXTRA_MUSIC: sPropertySuffix = "of Unending Music"; break;
					case IP_CONST_FEAT_EXTRA_RAGE: sPropertyPrefix = "Raging"; break;
					case IP_CONST_FEAT_EXTRA_SMITING: sPropertySuffix = "of Smiting"; break;	
					case IP_CONST_FEAT_EXTRA_STUNNING_ATTACK: sPropertySuffix = "of Stunning"; break;
					case IP_CONST_FEAT_EXTRA_TURNING: sPropertySuffix = "of Turning"; break;
					case IP_CONST_FEAT_EXTRA_WILD_SHAPE: sPropertyPrefix = "Wild"; break;
					// case IP_CONST_FEAT_KNOCKDOWN: sPropertySuffix = "of Extra Momentum"; break;
					case IP_CONST_FEAT_POINTBLANK: sPropertySuffix = "of Close Range"; break;
					case IP_CONST_FEAT_POWERATTACK: sPropertySuffix = "of Wild Blows"; break;
					case IP_CONST_FEAT_SPELLFOCUSABJ: sPropertyPrefix = "Abjuring"; break;
					case IP_CONST_FEAT_SPELLFOCUSCON: sPropertyPrefix = "Conjuring"; break;
					case IP_CONST_FEAT_SPELLFOCUSDIV: sPropertyPrefix = "Divining"; break;
					case IP_CONST_FEAT_SPELLFOCUSENC: sPropertyPrefix = "Enchanting"; break;
					case IP_CONST_FEAT_SPELLFOCUSEVO: sPropertyPrefix = "Evoking"; break;
					case IP_CONST_FEAT_SPELLFOCUSILL: sPropertyPrefix = "Illusioning"; break;
					case IP_CONST_FEAT_SPELLFOCUSNEC: sPropertyPrefix = "Necromancing"; break;
					case IP_CONST_FEAT_SPELLPENETRATION: sPropertySuffix = "of Penetrating Magiks"; break;
					case IP_CONST_FEAT_TWO_WEAPON_FIGHTING: sPropertySuffix = "of Dual Wielding"; break;
					case IP_CONST_FEAT_WEAPON_PROF_EXOTIC: sPropertySuffix = "of Exotic Weapon Handling"; break;
					case IP_CONST_FEAT_WEAPON_PROF_MARTIAL: sPropertySuffix = "of Martial Weapon Handling"; break;
					case IP_CONST_FEAT_WEAPON_PROF_SIMPLE: sPropertySuffix = "of Simple Weapon Handling"; break;
					default: sPropertySuffix = "of Feat"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_BONUS_HITPOINTS: sPropertySuffix = "of Health"; break;
			
			case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: sPropertySuffix = "of Increased Spells"; break;
			
			case ITEM_PROPERTY_CAST_SPELL: sPropertyPrefix = "Spellbound"; break;
			
			case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL: sPropertySuffix = "of Single Spell Immunity"; break;
			
			case ITEM_PROPERTY_KEEN:
			{
				switch (GetWeaponType(oItem))
				{
					case WEAPON_TYPE_BLUDGEONING: sPropertyPrefix = "Crushing"; break;
					case WEAPON_TYPE_PIERCING: sPropertyPrefix = "Piercing"; break;
					case WEAPON_TYPE_SLASHING: sPropertyPrefix = "Slashing"; break;
					default: sPropertyPrefix = "Sharpened"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_LIGHT: sPropertyPrefix = "Shining"; break;
			case ITEM_PROPERTY_MASSIVE_CRITICALS: sPropertyPrefix = "Punishing"; break;
			
			case ITEM_PROPERTY_ON_HIT_PROPERTIES:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_ONHIT_ABILITYDRAIN: sPropertyPrefix = "Draining"; break;
					case IP_CONST_ONHIT_BLINDNESS: sPropertyPrefix = "Blinding"; break;
					case IP_CONST_ONHIT_CONFUSION: sPropertyPrefix = "Confusing"; break;
					case IP_CONST_ONHIT_DAZE: sPropertyPrefix = "Bewildering"; break;
					case IP_CONST_ONHIT_DEAFNESS: sPropertyPrefix = "Deafening"; break;
					case IP_CONST_ONHIT_DOOM: sPropertySuffix = "of DOOM!!!"; break;
					case IP_CONST_ONHIT_FEAR: sPropertyPrefix = "Scary"; break;
					case IP_CONST_ONHIT_HOLD: sPropertyPrefix = "Paralyzing"; break;
					case IP_CONST_ONHIT_SILENCE: sPropertyPrefix = "Silencing"; break;
					case IP_CONST_ONHIT_SLEEP: sPropertySuffix = "of Sandman Dust"; break;
					case IP_CONST_ONHIT_SLOW: sPropertySuffix = "of the Snail"; break;
					case IP_CONST_ONHIT_STUN: sPropertyPrefix = "Stunning"; break;
					case IP_CONST_ONHIT_DISEASE: sPropertyPrefix = "Diseased"; break;
					case IP_CONST_ONHIT_ITEMPOISON: sPropertyPrefix = "Poisoned"; break;
					default: sPropertySuffix = "of After Effects"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_REGENERATION: sPropertyPrefix = "Regnerative"; break;
			case ITEM_PROPERTY_REGENERATION_VAMPIRIC: sPropertyPrefix = "Vampiric"; break;
			
			case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_SAVEBASETYPE_FORTITUDE: sPropertySuffix = "of Fortitude"; break;
					case IP_CONST_SAVEBASETYPE_REFLEX: sPropertySuffix = "of Reflexes"; break;
					case IP_CONST_SAVEBASETYPE_WILL: sPropertySuffix = "of Willpower"; break;
					case IP_CONST_SAVEBASETYPE_ALL: sPropertySuffix = "of Luck"; break;
					default: sPropertySuffix = "of Strange Luck"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_SAVING_THROW_BONUS:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_SAVEVS_ACID: sPropertySuffix = "of Acid Avoidance"; break;
					case IP_CONST_SAVEVS_COLD: sPropertySuffix = "of Warmth"; break;
					case IP_CONST_SAVEVS_DEATH: sPropertySuffix = "of Life"; break;
					case IP_CONST_SAVEVS_DISEASE: sPropertySuffix = "of Good Health"; break;
					case IP_CONST_SAVEVS_DIVINE: sPropertyPrefix = "Atheistic"; break;
					case IP_CONST_SAVEVS_ELECTRICAL: sPropertyPrefix = "Insulated"; break;
					case IP_CONST_SAVEVS_FEAR: sPropertySuffix = "of Courage"; break;
					case IP_CONST_SAVEVS_FIRE: sPropertySuffix = "of Coolness"; break;
					case IP_CONST_SAVEVS_MINDAFFECTING: sPropertySuffix = "of the Strong Mind"; break;
					case IP_CONST_SAVEVS_NEGATIVE: sPropertyPrefix = "Positive Infused"; break;
					case IP_CONST_SAVEVS_POISON: sPropertySuffix = "of Antidote"; break;
					case IP_CONST_SAVEVS_POSITIVE: sPropertyPrefix = "Negative Infused"; break;
					case IP_CONST_SAVEVS_SONIC: sPropertyPrefix = "Waxed"; break;
					case IP_CONST_SAVEVS_UNIVERSAL: sPropertySuffix = "of Good Luck"; break;
					default: sPropertySuffix = "of Uncanny Luck"; break;
				}
			}
			break;		
			
			case ITEM_PROPERTY_MIGHTY: sPropertyPrefix = "Mighty"; break;
			
			case ITEM_PROPERTY_SPELL_RESISTANCE: sPropertySuffix = "of Spell Resistance"; break;
			
			case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
			{
				int iBaseItemType = GetBaseItemType(oItem);
				string sAmmoName;
				
				if (iBaseItemType == BASE_ITEM_LONGBOW || iBaseItemType == BASE_ITEM_SHORTBOW) sAmmoName = "Arrows";
				else if (iBaseItemType == BASE_ITEM_HEAVYCROSSBOW || iBaseItemType == BASE_ITEM_LIGHTCROSSBOW) sAmmoName = "Bolts";
				else sAmmoName = "Bullets";
				
				switch (iPropertySubType)
				{
					case IP_CONST_UNLIMITEDAMMO_BASIC: sPropertySuffix = ""; break;
					case IP_CONST_UNLIMITEDAMMO_PLUS1: 
					case IP_CONST_UNLIMITEDAMMO_PLUS2:
					case IP_CONST_UNLIMITEDAMMO_PLUS3:
					case IP_CONST_UNLIMITEDAMMO_PLUS4:
					case IP_CONST_UNLIMITEDAMMO_PLUS5: sPropertySuffix = "Magical"; break;
					case IP_CONST_UNLIMITEDAMMO_1D6COLD: sPropertySuffix = "Freezing"; break;
					case IP_CONST_UNLIMITEDAMMO_1D6FIRE: sPropertySuffix = "Flaming"; break;
					case IP_CONST_UNLIMITEDAMMO_1D6LIGHT: sPropertySuffix = "Electrical"; break;
					case IP_CONST_UNLIMITEDAMMO_NATURES_RAGE: sPropertySuffix = "Nature's Rage"; break;
					default:  sPropertySuffix = ""; break;
				}
				if (sPropertySuffix == "") sPropertySuffix = "of Infinite " + sAmmoName;
				else sPropertySuffix = "of Infinite " + sPropertySuffix + " " + sAmmoName;
			}
			break;
			
			case ITEM_PROPERTY_DAMAGE_RESISTANCE:
			{
				switch (iPropertySubType)
				{
					case IP_CONST_DAMAGETYPE_ACID: sPropertySuffix = "of Acid Resistance"; break;
					case IP_CONST_DAMAGETYPE_COLD: sPropertySuffix = "of Cold Resistance"; break;
					case IP_CONST_DAMAGETYPE_FIRE: sPropertySuffix = "of Fire Resistance"; break;
					case IP_CONST_DAMAGETYPE_ELECTRICAL: sPropertySuffix = "of Electrical Resistance"; break;
					case IP_CONST_DAMAGETYPE_SONIC: sPropertySuffix = "of Sonic Resistance"; break;
					default:  sPropertySuffix = "of Resistance"; break;
				}
			}
			break;
			
			case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION: sPropertyPrefix = "Lightweight"; break;
			
			default:
			{
				sPropertyPrefix = "Mysterious";
				sPropertySuffix = "of Mystery";
			}
			break;
		}
	}
	else
	{
		sPropertyPrefix = "Wondrous"; // default if no property detected or something gone wrong.
		sPropertySuffix = "Wonder"; 
	}
	
	SetLocalString(oItem, "PROPERTY_SUFFIX", sPropertySuffix);
	SetLocalString(oItem, "PROPERTY_PREFIX", sPropertyPrefix);
}

string GenerateNPCName(object oItem, int iGender)
{
	string sName;
	int iRandom;
	string sTitle;
	// Generate Title - 20% chance of a title.
	
	if (Random(5) == 1)
	{
		iRandom = Random(8) + 1;
		
		switch (iRandom)
		{
			case 1: sTitle = iGender == GENDER_MALE?"King":"Queen"; break;
			case 2: sTitle = iGender == GENDER_MALE?"Lord":"Lady"; break;
			case 3: sTitle = iGender == GENDER_MALE?"Prince":"Princess"; break;
			case 4: sTitle = "Captain"; break;
			case 5: sTitle = "General"; break;
			case 6: sTitle = iGender == GENDER_MALE?"Mother Priestess":"Father Priest"; break;
			case 7: sTitle = iGender == GENDER_MALE?"Duke":"Duchess"; break;
			case 8: sTitle = iGender == GENDER_MALE?"Emperor":"Empress"; break;
		}
	}
	
	SetLocalString(oItem, "RANDOM_TITLE", sTitle);
	
	// Generate first name
	if (iGender == GENDER_MALE)
	{
		iRandom = Random(50) + 1;
		
		switch (iRandom)
		{
			case 1: sName = "Urlik"; break; case 2: sName = "Osdenray"; break; case 3: sName = "Belngar"; break; case 4: sName = "Roth'cer"; break; case 5: sName = "Lleinaild"; break; 
			case 6: sName = "Drethat"; break; case 7: sName = "Samunt"; break; case 8: sName = "Angdim"; break; case 9: sName = "Iseto"; break; case 10: sName = "Samashaw"; break; 
			case 11: sName = "Tew"; break; case 12: sName = "Lermor"; break; case 13: sName = "Undrod"; break; case 14: sName = "Mormos"; break; case 15: sName = "Banranos"; break; 
			case 16: sName = "Clading"; break; case 17: sName = "Faqueer"; break; case 18: sName = "Crerothad"; break; case 19: sName = "Danwartherserray"; break; case 20: sName = "Shyoughenth"; break; 
			case 21: sName = "Pitny"; break; case 22: sName = "Drorr"; break; case 23: sName = "Vec"; break; case 24: sName = "Jyhem"; break; case 25: sName = "Sadut"; break; 
			case 26: sName = "Zydymiso"; break; case 27: sName = "Ine'war"; break; case 28: sName = "Dar'ilde"; break; case 29: sName = "Aw'gha'uw"; break; case 30: sName = "Tur'rak"; break; 
			case 31: sName = "Honale-gar"; break; case 32: sName = "Tin-oldat"; break; case 33: sName = "Sul-kim"; break; case 34: sName = "Chuinat-che"; break; case 35: sName = "Nysith-den"; break; 
			case 36: sName = "Motozaki"; break; case 37: sName = "Osuzu"; break; case 38: sName = "Yamagawa"; break; case 39: sName = "Oo"; break; case 40: sName = "Senchi"; break; 
			case 41: sName = "Dutios"; break; case 42: sName = "Lycios"; break; case 43: sName = "Radauth"; break; case 44: sName = "B'orm"; break; case 45: sName = "T'hol"; break; 
			case 46: sName = "Doofartle"; break; case 47: sName = "Faron"; break; case 48: sName = "Ealunmol"; break; case 49: sName = "Quariel"; break; case 50: sName = "Ayal"; break; 
			default: sName = "Unknown"; break;
		}
	}
	else
	{
		iRandom = Random(50) + 1;
				
		switch (iRandom)
		{
			case 1: sName = "Ythery"; break; case 2: sName = "Tiar"; break; case 3: sName = "Atnal"; break; case 4: sName = "Per'ash"; break; case 5: sName = "Phoumess"; break; 
			case 6: sName = "Sul'alea"; break; case 7: sName = "Quenys"; break; case 8: sName = "Liris"; break; case 9: sName = "Letys"; break; case 10: sName = "Ald'ran'een"; break; 
			case 11: sName = "Tonbanirdra"; break; case 12: sName = "Yersulosunda"; break; case 13: sName = "Asootu"; break; case 14: sName = "Silycila"; break; case 15: sName = "Jilere"; break; 
			case 16: sName = "Hilari"; break; case 17: sName = "Hezora"; break; case 18: sName = "Alire"; break; case 19: sName = "Umorunda"; break; case 20: sName = "Rudipada"; break; 
			case 21: sName = "Honeyface"; break; case 22: sName = "Danitia"; break; case 23: sName = "Omoutia"; break; case 24: sName = "U'rayale"; break; case 25: sName = "Lor'tina"; break; 
			case 26: sName = "Que'urn'yw"; break; case 27: sName = "Urn-raness"; break; case 28: sName = "Emia-ver"; break; case 29: sName = "Ing-che"; break; case 30: sName = "Lyeav-lye"; break; 
			case 31: sName = "Kei"; break; case 32: sName = "Iwawa"; break; case 33: sName = "Ifuku"; break; case 34: sName = "Kitake"; break; case 35: sName = "Furukei"; break; 
			case 36: sName = "Padyt"; break; case 37: sName = "Soess"; break; case 38: sName = "Elmtia"; break; case 39: sName = "Uskvia"; break; case 40: sName = "Jizam"; break; 
			case 41: sName = "Atha"; break; case 42: sName = "Shy'say"; break; case 43: sName = "Ristaness"; break; case 44: sName = "Ooma"; break; case 45: sName = "Ess'eno"; break; 
			case 46: sName = "Che'dyne"; break; case 47: sName = "Polina"; break; case 48: sName = "Cafeda"; break; case 49: sName = "Ine'awe"; break; case 50: sName = "Ceresul"; break; 
			default: sName = "Unknown"; break;
		}
	}
	
	SetLocalString(oItem, "RANDOM_NAME", sName);
	if (sTitle == "")
		sName = sName + " the ";
	else
		sName = sTitle + " " + sName + " the ";
	
	// Generate nickname
	iRandom = Random(50) + 1;
	string sNick;
	
	switch (iRandom)
	{
		case 1: sNick = "Magnificent"; break; case 2: sNick = "Brave"; break; case 3: sNick = "Unready"; break; case 4: sNick = "Unwilling"; break; case 5: sNick = "Merciless"; break; 
		case 6: sNick = "Mighty"; break; case 7: sNick = "Cowardly"; break; case 8: sNick = "Dragonslayer"; break; case 9: sNick = "Unbeliever"; break; case 10: sNick = "Cruel"; break; 
		case 11: sNick = "Willing"; break; case 12: sNick = "Foul"; break; case 13: sNick = "Six-fingered"; break; case 14: sNick = "Kinslayer"; break; case 15: sNick = "Mystic"; break; 
		case 16: sNick = "Destroyer"; break; case 17: sNick = "Fiendslayer"; break; case 18: sNick = "Godslayer"; break; case 19: sNick = "Celibate"; break; case 20: sNick = "Polite"; break; 
		case 21: sNick = "Heroic"; break; case 22: sNick = "Glutton"; break; case 23: sNick = "Worrier"; break; case 24: sNick = "Bold"; break; case 25: sNick = "Bald"; break; 
		case 26: sNick = "Clueless"; break; case 27: sNick = "Necromancer"; break; case 28: sNick = "Swift"; break; case 29: sNick = "Flamboyant"; break; case 30: sNick = "Wise"; break; 
		case 31: sNick = "Grey"; break; case 32: sNick = "Red"; break; case 33: sNick = "Blue"; break; case 34: sNick = "White"; break; case 35: sNick = "Green"; break; 
		case 36: sNick = "Yellow"; break; case 37: sNick = "Black"; break; case 38: sNick = "Cold-hearted"; break; case 39: sNick = "Prankster"; break; case 40: sNick = "Unclean"; break; 
		case 41: sNick = "Rotten"; break; case 42: sNick = "Virtuous"; break; case 43: sNick = "Noble"; break; case 44: sNick = "Effete"; break; case 45: sNick = "Insane"; break; 
		case 46: sNick = "Unknown"; break; case 47: sNick = "Strange"; break; case 48: sNick = "Unquestionable"; break; case 49: sNick = "Terrible"; break; case 50: sNick = "Orthodox"; break; 
		default: sNick = "Lost"; break;
	}
	
	SetLocalString(oItem, "RANDOM_NICK", sNick);
	sName = sName + " " + sNick;
	
	return sName;
}

// A semi-sensible name for the item, based off properties that were added, and generate an NPC name for the item description backstory.
void NameAndDescribeRandomItem(object oItem)
{
	/*
	1. Generate an NPC name. Can be something Unglebert the Unready
	2. Scan properties of item for item prefixes and suffixes.  Need to set flags for things like enemies (if item contains vs properties), etc.
	3. Set Item Name
	Item names are of format <Name>'s <optional prefix for things like elemental damage, eg: Flaming, Freezing> <Item Type> 
	<"of" providing there is a suffix> <Suffix, which also can depend on properties>
	4. Set Item Description with backstory.
	5. Chose random icon from those available. Perhaps easiest using stock 1-5 variants for enchantments, but if detecting things like cold, fire, etc, could also work in those.
	*/
	SetLocalString(oItem, "RANDOM_ITEM_TYPE", GetName(oItem));
	int iGender = Random(2); // GENDER_MALE = 0, GENDER_FEMALE = 1.  Used for sentence structure in description.
	string sNPCName = GenerateNPCName(oItem, iGender);
		
	// code now for property part of the name
	GenerateItemPropertyName(oItem);
	
	string sPropertyPrefix = GetLocalString(oItem, "PROPERTY_PREFIX");
	string sPropertySuffix = GetLocalString(oItem, "PROPERTY_SUFFIX");
	string sItemName = RANDOM_DROP_COLOUR + sNPCName + "'s ";
	if (sPropertyPrefix != "") sItemName = sItemName + sPropertyPrefix + " ";
	sItemName = sItemName + GetName(oItem);
	if (sPropertySuffix != "") sItemName = sItemName + " " + sPropertySuffix;
	SetFirstName(oItem, sItemName);

	GenerateItemDescription(oItem);
	
	SetRandomItemIcon(oItem);
}

// Entry function for creation of the random items.
void CreateRandomDropItem(object oSpawn)
{
	int iItemType = Random(56) + 1;
	if (iItemType == 10) // Splint Mail - does not exist
	{
		iItemType = 11; // make it banded mail instead.
	}
	// With the gamber we pass oPC, but in this case its a spawned monster
	object oItem = SRLG_GiveRandomLeveledItem(oSpawn, iItemType);
	SetDroppableFlag(oItem, TRUE);
	NameAndDescribeRandomItem(oItem);
}