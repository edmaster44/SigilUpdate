// include file for new classes

#include "nwn2_inc_spells"
#include "ps_inc_functions"

// Class Consts
const int CLASS_TYPE_SAMURAI = 65;
const int CLASS_TYPE_KENSAI = 66; 
const int CLASS_TYPE_RONIN = 67;

// following 2 are not implemented yet, although I may do them at some point. Scripts for Tattooed Monk are done (need testing) and some work was done on Drunkenmaster scripts. - AA.
const int CLASS_TYPE_TATOOMONK = 998;
const int CLASS_TYPE_DRUNKMASTER = 999;

// Feat consts
const int FEAT_TSAO = 2402; // two swords as one, these need setting correctly
const int FEAT_ITSAO = 2403;
const int FEAT_GTSAO = 2404;
const int FEAT_STSAO = 2405;
const int FEAT_PTSAO = 2406;
const int FEAT_DTSAO = 2407;
const int FEAT_IAJUTSUMASTER = 2414;
const int FEAT_FRIGHTFUL_PRESENCE = 2419;
const int FEAT_STAREDOWN =2415;
const int FEAT_MASS_STAREDOWN =2416;
const int FEAT_IMP_STAREDOWN =2417;
const int FEAT_IMP_MASS_STAREDOWN =2418;
const int SPELL_ID_TSAO = 1401;
const int FEAT_BANZAI_CHARGE = 2427;
const int FEAT_IMP_BANZAI_CHARGE = 2428;
const int SPELL_ID_SHIELD_DEFLECT = 1421; // not for new classes, just used by onequip and unequip to set ID of deflect bonus when wielding a shield.
const int SPELL_ID_DISGRACED = 1413;

/**************************************************************************
* All Tattoo and Drunken Master feat values have been increased by 10,000 *
* in order to avoid possible conflict with new addtions. If implemented   *
* these values need setting properly.                                     *
**************************************************************************/

// always active tattoos
// combine into single activate feat
const int FEAT_TATTOO_PHOENIX = 12431; // raise from dead
const int FEAT_TATTOO_BULL = 12432; // bonus to STR - amount?
const int FEAT_TATTOO_CAT = 12433; // bonus to DEX
const int FEAT_TATTOO_BEAR = 12434; // bonus to CON
const int FEAT_TATTOO_FOX = 12435; // bonus to INT
const int FEAT_TATTOO_OWL = 12436; // bonus to WIS
const int FEAT_TATTOO_EAGLE = 12437; // bonus to CHA
const int FEAT_TATTOO_SKULL = 12438; // +10 save vs death
const int FEAT_TATTOO_DRAGON_GOLD = 12439; // Damage res vs Fire 30
const int FEAT_TATTOO_DRAGON_WHITE = 12440; // Damage res vs Cold 30
const int FEAT_TATTOO_DRAGON_BLACK = 12441; // Damage res vs Acid 30
const int FEAT_TATTOO_DRAGON_BRONZE = 12442; // Damage res vs Electricity 30
const int FEAT_TATTOO_LOTUS = 12443; // immunity to mind affecting
const int FEAT_TATTOO_ANGEL = 12444; // ac vs evil
const int FEAT_TATTOO_FIEND = 12445; // ac vs good
const int FEAT_TATTOO_SPIDER = 12446; // freedom of movement, immunity to spell web, immunity to poisons
const int FEAT_TATTOO_TREE = 12447; // immunity to knockdown
const int FEAT_TATTOO_LIZARD = 12448; // regen
const int FEAT_TATTOO_TORTOISE = 12449; // Shield AC bonus
const int FEAT_TATTOO_BUTTERFLY = 12450; // Dodge AC bonus
const int FEAT_TATTOO_EYES = 12451; // see invisibile

// activated tattoos
const int FEAT_TATTOO_BLINKDOG = 12452; // effectdisappearappear - random location, unlimited use, on short cooldown

// damage tattoos? // effects are cancelled if a weapon is equipped, do bonus damage when unarmed or wielding a creature weapon (new creature weapons)
// need to check on-equip script and cancel these effects if a weapon is equipped.
const int FEAT_TATTOO_FLAMEHAND = 12453;
const int FEAT_TATTOO_FROZENHAND = 12454;
const int FEAT_TATTOO_ELECTRICHAND = 12455;
const int FEAT_TATTOO_CORRODINGHAND = 12456;
const int SPELL_TATTOO_FLAMEHAND = 11453;
const int SPELL_TATTOO_FROZENHAND = 11454;
const int SPELL_TATTOO_ELECTRICHAND = 11455;
const int SPELL_TATTOO_CORRODINGHAND = 11456;

const int FEAT_TATTOO_GHOST = 12457; // invis
const int FEAT_TATTOO_CHAMELEON = 12458; // 50% conceal for short duration

const int FEAT_TATTOO_DOVE = 12459; // effectsanctuary
const int FEAT_TATTOO_ALOEVERA = 12460; // Cure wounds

// spell absorbtion?
const int FEAT_TATTOO_MAGICCIRCLE = 12461; // protects against X number of spell levels. Gain HP from spells (defaultb script) 1HP/level of spell/level of Tat Monk? Uses per day (not cooldown!)
//const int SPELL_TATTOO_MAGICCIRCLE = 0;

// base feat
const int FEAT_TATTOO_HEART = 12462;

// Drunken Master
const int FEAT_DRINK_LIKE_DEMON = 12463;
const int FEAT_DRUNKEN_FLURRY_OF_BLOWS = 12464;
const int FEAT_IMPROVISED_WEAPONS = 12465;
const int FEAT_IMPROVED_IMPROVISED_WEAPONS = 12466;
const int FEAT_GREATER_IMPROVISED_WEAPONS = 12467;
const int FEAT_SUPERIOR_IMPROVISED_WEAPONS = 12468;
const int FEAT_FOR_MEDICINAL_PURPOSES = 12469;
const int FEAT_STAGGER = 12470;
const int FEAT_SWAYING_WAIST = 12471;
const int FEAT_DRUNKEN_BLAGGER = 12472; // bonus to bluff based of level of DM - goes with feint (not much use if not a sneaker, but removing dex bouns still worth it)
const int FEAT_IMPROVED_SWAYING_WAIST = 12473;
const int FEAT_CORKSCREW_RUSH = 12474;
const int FEAT_BREATH_OF_FLAME = 12475;
const int SPELL_EFFECT_IMP_WEAPONS = 12476; // change.
// Functions

void DoDrunkMasterImprovised(object oPC)
{
	object oWpnRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWpnLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int iTypeRight = GetBaseItemType(oWpnRight);
	int iTypeLeft = GetBaseItemType(oWpnLeft);
	int iHasEffect = GetHasSpellEffect(SPELL_EFFECT_IMP_WEAPONS, oPC);
	int iLevels = GetLevelByClass(CLASS_TYPE_DRUNKMASTER, oPC) + GetLevelByClass(CLASS_TYPE_MONK, oPC);
	int iApply = FALSE;
	effect eEffect;
	int iDBonus;
	int iABonus;
	int iSBonus;
	
	if (!GetIsObjectValid(oWpnRight) || iTypeRight == BASE_ITEM_CLUB || iTypeRight == 152) // 152 is giant club, also unarmed can be allowed
	{
		if (!GetIsObjectValid(oWpnLeft) || iTypeLeft == BASE_ITEM_TORCH || iTypeLeft == BASE_ITEM_CLUB || iTypeLeft == 152)  // torches as well can be held.
		{
			iApply = TRUE;
		}
	}
	
	if (iApply == TRUE && iHasEffect == FALSE)
	{
		if (iLevels < 11) // As Greater Flurry of Blows is gained at Monk 11, we want 2 extra attacks with imp weapons at combined level of 11 or else 1 extra
			eEffect = EffectModifyAttacks(1);
		else
			eEffect = EffectModifyAttacks(2);
			
		if (GetHasFeat(FEAT_SUPERIOR_IMPROVISED_WEAPONS, oPC, TRUE)) 
		{
			iDBonus = DAMAGE_BONUS_2d12;
			iABonus = 4;
			iSBonus = 7;
		}	
		else if (GetHasFeat(FEAT_GREATER_IMPROVISED_WEAPONS, oPC, TRUE))
		{
			iDBonus = DAMAGE_BONUS_2d8;
			iABonus = 3;
			iSBonus = 5;
		}
		else if (GetHasFeat(FEAT_IMPROVED_IMPROVISED_WEAPONS, oPC, TRUE))
		{
			iDBonus = DAMAGE_BONUS_1d12;
			iABonus = 2;
			iSBonus = 3;
		}
		else if (GetHasFeat(FEAT_IMPROVISED_WEAPONS, oPC, TRUE))
		{
			iDBonus = DAMAGE_BONUS_1d8;
			iABonus = 1;
			iSBonus = 1;
		}
		
		eEffect = EffectLinkEffects(eEffect, EffectAttackIncrease(iABonus));
		eEffect = EffectLinkEffects(eEffect, EffectDamageIncrease(iDBonus));
		eEffect = EffectLinkEffects(eEffect, EffectACIncrease(iSBonus, AC_DEFLECTION_BONUS));
		eEffect = SupernaturalEffect(eEffect);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
	}
	else if (iApply == FALSE && iHasEffect == TRUE)
	{
		RemoveAnySpellEffects(SPELL_EFFECT_IMP_WEAPONS, oPC);
	}
}

void DoShieldBonus(object oPC, int iBaseItemType)
{
	{
		int iMissChance;
		
		if (iBaseItemType == BASE_ITEM_TOWERSHIELD) iMissChance = 60;
		else if (iBaseItemType == BASE_ITEM_LARGESHIELD) iMissChance = 30;
		else iMissChance = 10;
		
		effect eDeflect =  EffectConcealment(iMissChance, MISS_CHANCE_TYPE_VS_RANGED);
		eDeflect = SupernaturalEffect(eDeflect);
		eDeflect = SetEffectSpellId(eDeflect, SPELL_ID_SHIELD_DEFLECT);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDeflect, oPC);
	}
}

void CheckDiashoWeapons(object oPC, object oEssence)
{
	if (GetLevelByClass(CLASS_TYPE_SAMURAI, oPC) == 1)
	{
		// check for var to see if already given
		if (GetLocalInt(oEssence, "DAISHO_WEAPONS_GRANTED") != 1)
		{
			SetLocalInt(oEssence, "DAISHO_WEAPONS_GRANTED", 1);
			CreateItemOnObject("class_it_dkatana", oPC); 
			CreateItemOnObject("class_it_dwakazashi", oPC);
			SendMessageToPC(oPC, "<color=gold>You have been granted your Daisho weapons");
		}
	}
}

void ApplyTSAOBonus(object oPC)
{
	if (GetHasSpellEffect(SPELL_ID_TSAO,oPC))
	{
		return;
	}	
	else
	{
		int iBonus;
		int iDmgType;
		
		if (GetHasFeat(FEAT_DTSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_6;
		else if (GetHasFeat(FEAT_PTSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_5;
		else if (GetHasFeat(FEAT_STSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_4;
		else if (GetHasFeat(FEAT_GTSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_3;
		else if (GetHasFeat(FEAT_ITSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_2;
		else if (GetHasFeat(FEAT_TSAO, oPC, TRUE)) iBonus = DAMAGE_BONUS_1;
		else SendMessageToPC(oPC, "You are apparently a Samurai of at least level 2 but without a Two-Swords as One feat. Please report a bug via the forums!");
		
		if (GetHasFeat(FEAT_DTSAO, oPC, TRUE)) iDmgType = DAMAGE_TYPE_DIVINE;
		else iDmgType = DAMAGE_TYPE_BLUDGEONING;
		
		effect eBonus =  EffectAttackIncrease(iBonus);
		eBonus = EffectLinkEffects(eBonus, EffectDamageIncrease(iBonus, iDmgType));
		eBonus = SupernaturalEffect(eBonus);
		eBonus = SetEffectSpellId(eBonus,SPELL_ID_TSAO);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC);
	}
}

void RemoveTSAOBonus(object oPC)
{
	if (GetHasSpellEffect(SPELL_ID_TSAO,oPC))
	{
		RemoveAnySpellEffects(SPELL_ID_TSAO, oPC);
	}
}


void Samurai_Two_Swords_As_One(object oPC)
{		
	object oWpnRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWpnLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int iTypeRight = GetBaseItemType(oWpnRight);
	int iTypeLeft = GetBaseItemType(oWpnLeft);
	int iHasEffect = GetHasSpellEffect(SPELL_ID_TSAO,oPC);
	int iApplyBonus = FALSE;
	
	if (GetIsObjectValid(oWpnRight))
	{
		if (iTypeRight == BASE_ITEM_LONGSWORD || iTypeRight == BASE_ITEM_KATANA)
		{
			// this is funny, because shortsword is base item type zero - therefore we could cheat and not even check for valid because itypeleft would be zero anyway.
			// idiotic design that had 2das starting at zero when failures also return zero.
			if (GetIsObjectValid(oWpnLeft) && iTypeLeft == BASE_ITEM_SHORTSWORD)
			{
				iApplyBonus = TRUE;
			}
		}
	}

	if (iApplyBonus == TRUE && iHasEffect == FALSE)
	{
		ApplyTSAOBonus(oPC);
	}
	else if (iApplyBonus == FALSE && iHasEffect == TRUE)
	{
		RemoveTSAOBonus(oPC);
	}
	// else we don't need to do anything.
}

void ApplyIajutsuMasterEffect(object oPC)
{
	int iCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	effect eBonus =  EffectAttackIncrease(iCHA);
	eBonus = EffectLinkEffects(eBonus, EffectModifyAttacks(1));
	eBonus = SupernaturalEffect(eBonus);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 6.5); // just a little extra to be sure we catch end of round;
}

// When draws weapon - enemies must make a Will save (DC 20 + samurai’s Cha modifier) or become panicked for 4d6 rounds 
// (if they have 4 or fewer Hit Dice) or shaken for 4d6 rounds (if they have from 5 to 19 Hit  Dice). 
// Creatures with 20 or more Hit Dice are not affected 
void ApplyFrightfulPresence(object oPC)
{
	location lPC = GetLocation(oPC);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
	int iCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int iDC = 20 + iCHA;
	int iPCLevel = PS_GetLevel(oPC);
	int iTargetLevel;
	effect eEffect;
	
	while (GetIsObjectValid(oTarget))
	{
		if (GetIsEnemy(oTarget, oPC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC))
		{
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				iTargetLevel = GetHitDice(oTarget);
			
				if (iTargetLevel <5) eEffect = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_STUN));
				else if (iTargetLevel < 20 && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oPC)) 
					eEffect = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_SPELL_FEAR));
				else eEffect = EffectLinkEffects(EffectLinkEffects(EffectACDecrease(2), EffectAttackDecrease(2)), EffectVisualEffect(VFX_DUR_SPELL_DOOM));
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(iCHA));
			}
		}
	
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
	}
	
}