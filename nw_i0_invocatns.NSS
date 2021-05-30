//::///////////////////////////////////////////////
//:: Warlock Invocations Include
//:: NW_I0_INVOCATIONS
//:://////////////////////////////////////////////
/*
    Warlock Eldritch Essence & Blast Shape Invocations
    can be combined together (one of each) to modify
    the basic Eldritch Blast (Feat) behavior.
    Eldritch Essence Invocations apply extra effects to
    the target(s), whereas Blast Shape Invocations
    modify the # of targets affected.

    Internally, these combined invocations prioritize
    on the Blast Shape Invocations as the primary Spell.
    What this means is that the Blast Shape will always
    be the stored "Spell" in the UI, with the Essences
    being "Metamagics" that are applied to it.  This is
    because Blast Shapes control Ranges/AoE, and also so
    that only the Blast Shape Scripts need to worry about
    whether they have combined effects...
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 19, 2005
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF - OEI)
//:: Modified On: 6/29/06
//:: Modified the "Shape" functions to check for essences and create corresponding EffectVisualEffect
//:: Also modified the parameters of DoEldritchBlast, DoEldritchCombinedEffects, and DoEssenceXXX to recognize if they were called by "shapes"
//:://////////////////////////////////////////////
//:: AFW-OEI 02/20/2007: Added effects of Eldritch Master: +2 to the touch attack rolls and 50% extra damage.
//:: AFW-OEI 02/21/2007: Added the Epic Eldritch Blast chain: +1d6 to eldritch blast damage per Epic Eldritch Blast feat.
//:: AFW-OEI 05/08/2007: Added Hindering and Binding Blast Eldritch Essences.
//::PKM-OEI: 05.30.07: Touch attacks now do critical hit damage

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nwn2_inc_spells"
#include "ginc_debug"
#include "srcalc"
#include "ps_inc_functions"

//#include "ps_inc_onhit"
const string abilityCaster = "abilityCaster";

const int STRREF_HELLFIRE_BONUS    		= 220796;  // Bonus Damage (Hellfire): ( in use )
const int STRREF_HELLFIRE_SHIELD_NAME   = 220779;  // Hellfire Shield ( in use )
const int STRREF_HELLFIRE_BLAST_NAME    = 220783;  // Hellfire Blast ( in use )
//const int STRREF_HELLFIRE_SHIELD_1 		= 220804;  //  drains  									REMOVED!!!
const int STRREF_HELLFIRE_FEEDBACK   = 220805;  // 's Constitution by 						CHANGED
const int STRREF_HELLFIRE_SHIELD_NO_CON = 233608; //Constitution isn't high enough to use Hellfire Shied.
//const int STRREF_HELLFIRE_SHIELD_START  = 220802;  //  is surrounded by an aura of hellfire.    REMOVED!!!
//const int STRREF_HELLFIRE_SHIELD_STOP   = 220803;  //  is no longer protected by hellfire.      REMOVED!!!
//const int STRREF_HELLFIRE_SHIELD_NO_CONST = 220806; // 's Constitution isn't high enough to use REMOVED!!!

// JWR-OEI: 09/24/2008 - Global Variable to track CON damage output
int nHellfireConDmg = 0;

// Electohydra Global variables to track bonus damage for the whole script
int BonusDamageDice = 0;
int BonusDamageAdded = FALSE;

// JWR - OEI 06/18/2008 -- Hellfire Warlock Damage Bonus functions
void HellfireShieldFeedbackMsg(int x, int strref, object oCaster);
int IsHellfireBlastActive(object oCaster=OBJECT_SELF);
int GetHellfireBlastDiceBonus(object oCaster=OBJECT_SELF);
void PrintHellfireBonusMsg(int nDice);

// JLR - OEI 07/20/05 -- Warlock Funcs
// Returns the highest level of Eldritch Blast available
int GetEldritchBlastLevel(object oCaster);

// Returns the base damage from the Eldritch Blast
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave=FALSE, int nIgnoreResists=FALSE, int nHalfDmg=FALSE, int nTouch=1);

// Does the actual Eldritch Blast...returns TRUE if it succeeded (so can do secondary effects)
int DoEldritchBlast(object oCaster, 
					object oTarget, 
					int bCalledFromShape = FALSE,
					int bDoTouchTest = TRUE, 
					int nDmgType = DAMAGE_TYPE_MAGICAL, 
					int nAllowReflexSave = FALSE, 
					int nIgnoreResists = FALSE, 
					int nHalfDmg = FALSE, 
					int nVFX = VFX_BEAM_ELDRITCH
					);

// Does the Metamagic Combined Effects
int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

// These do the Eldritch Essence Effects:
int DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft);
int DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft);
int DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

// These do the Blast Shape Effects:
int DoShapeEldritchSpear();
int DoShapeHideousBlow();
int DoShapeEldritchChain();
int DoShapeEldritchCone();
int DoShapeEldritchDoom();


//::///////////////////////////////////////////////
//:: Functions
//::///////////////////////////////////////////////
// -------------------------------------------------------------------
// Printes Hellfire message JWR-OEI
// -------------------------------------------------------------------
void HellfireShieldFeedbackMsg(int x, int strref, object oCaster)
{
	string sLocalizedTextMsg = GetStringByStrRef( STRREF_HELLFIRE_FEEDBACK );
	string sLocalizedTextName = GetStringByStrRef( strref ); // is it hellfire blast or shield?
	string sName = GetName( oCaster );
	string sHellfireFeedbackMsg = "<c=tomato>" + sName + ": " + sLocalizedTextName + sLocalizedTextMsg + IntToString(x)+ ". </c>";
	//	SendMessageToPC( oCaster, sHellfireFeedbackMsg );
	FloatingTextStringOnCreature(sHellfireFeedbackMsg, oCaster);
}

// -------------------------------------------------------------------
// Prints the Hellfire Bonus if you have the HellfireEffect active JWR-OEI
// -------------------------------------------------------------------
void PrintHellfireBonusMsg(int nDice)
{
	string sLocalizedText = GetStringByStrRef( STRREF_HELLFIRE_BONUS );
	string sDiceBonus = " ("+IntToString(nDice)+"d6)";
	string sHellfireFeedbackMsg = "<c=tomato>" + sLocalizedText + " </c>"+sDiceBonus;
	SendMessageToPC( OBJECT_SELF, sHellfireFeedbackMsg );
}
// -------------------------------------------------------------------
// Returns the damage bonus provided by Hellfire Blast JWR-OEI
// -------------------------------------------------------------------
int GetHellfireBlastDiceBonus(object oCaster)
{
	return 2*GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oCaster);
}

// -------------------------------------------------------------------
// Determines if Hellfire Blast is active JWR-OEI
// -------------------------------------------------------------------
int IsHellfireBlastActive(object oCaster=OBJECT_SELF)
{

	// check CON
	int nCurrCon = GetAbilityScore( oCaster, ABILITY_CONSTITUTION );
	int x = GetActionMode(oCaster, ACTION_MODE_HELLFIRE_BLAST);
	//	PrettyDebug("Testing Hellfire Blast Mode: "+IntToString(x));
	if ( x )
	{
		if ( nCurrCon < 1 )
		{
			SetActionMode(oCaster, ACTION_MODE_HELLFIRE_BLAST, 0);
			return FALSE;
		}
		//	PrettyDebug("Hellfire Mode Active!");
		
		//_________________________________________________
		// pelhikano fix - REMOVED AS CON DAMAGE IS NO LONGER INFLICTED
		// check if any kind of death ward is active and remove it if yes
/*	if (GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oCaster))
	{
		RemoveSpellEffectsFromCaster(SPELL_FREEDOM_OF_MOVEMENT, oCaster, OBJECT_INVALID);
	}
	if (GetHasSpellEffect(SPELL_DEATH_WARD, oCaster))
	{
		RemoveSpellEffectsFromCaster(SPELL_DEATH_WARD, oCaster, OBJECT_INVALID);
	}
	if (GetHasSpellEffect(SPELL_MASS_DEATH_WARD, oCaster))
	{
		RemoveSpellEffectsFromCaster(SPELL_MASS_DEATH_WARD, oCaster, OBJECT_INVALID);
	}
	if (GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oCaster))
	{
		RemoveSpellEffectsFromCaster(SPELL_UNDEATHS_ETERNAL_FOE, oCaster, OBJECT_INVALID);
	}
*/
		
		//_________________________________________________
		
		return TRUE;
	}
	else
	{
		//	PrettyDebug("Hellfire Mode InActive!");
		return FALSE;	
	}
	return FALSE;
}
// Inflicts Hellfire damage on the caster. Pulled out of the
// code for the basic blast and put here for ease of calling -Electrohydra
void DoHellfireDamage()
{
	if (IsHellfireBlastActive())
	{
		//effect eConst = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
		//eConst = SetEffectSpellId(eConst, -1); // set to invalid spell ID for stacking
		
		//_________________________________________________________________
		// pelhikano fix: apply a little later for death ward removal to work
		//DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConst, oCaster));
		//_________________________________________________________________
		
		// replacement damage effect instead of CON damage
		int iDmg = GetHitDice(OBJECT_SELF) / 2; // 0.5HP / level is equal to 1 point of CON damage.
		effect eDmg = EffectDamage(iDmg, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE); // hopefully this will bypass resistances.
		DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, OBJECT_SELF));
	}	
}

// -------------------------------------------------------------------
// Returns the highest level of Eldritch Blast available
// AFW-OEI 02/21/2007: Removed hard damage cap.
int GetEldritchBlastLevel(object oCaster)
{
    int nBlstLvl = 0;

    if ( GetHasFeat(FEAT_ELDRITCH_BLAST_14, oCaster ) )         { nBlstLvl = 14; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_13, oCaster ) )    { nBlstLvl = 13; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_12, oCaster ) )    { nBlstLvl = 12; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_11, oCaster ) )    { nBlstLvl = 11; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_10, oCaster ) )    { nBlstLvl = 10; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_9, oCaster ) )     { nBlstLvl = 9; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_8, oCaster ) )     { nBlstLvl = 8; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_7, oCaster ) )     { nBlstLvl = 7; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_6, oCaster ) )     { nBlstLvl = 6; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_5, oCaster ) )     { nBlstLvl = 5; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_4, oCaster ) )     { nBlstLvl = 4; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_3, oCaster ) )     { nBlstLvl = 3; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_2, oCaster ) )     { nBlstLvl = 2; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_1, oCaster ) )     { nBlstLvl = 1; }
    
    // AFW-OEI 02/21/2007: Epic Eldritch Blasts
    if      (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_10, oCaster))      { nBlstLvl += 10; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_9, oCaster) )      { nBlstLvl +=  9; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_8, oCaster) )      { nBlstLvl +=  8; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_7, oCaster) )      { nBlstLvl +=  7; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_6, oCaster) )      { nBlstLvl +=  6; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_5, oCaster) )      { nBlstLvl +=  5; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_4, oCaster) )      { nBlstLvl +=  4; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_3, oCaster) )      { nBlstLvl +=  3; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_2, oCaster) )      { nBlstLvl +=  2; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_1, oCaster) )      { nBlstLvl +=  1; }
 

// NOTE: Need to Add in Prestige "+1 Spellcasting" Bonuses here...
    return nBlstLvl;
}


// Returns the base damage from the Eldritch Blast
int nIsCritcalAttack = 0; //Remembering if attack was critical for HellfireBlast damage bonus
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int nTouch/*=1*/)
{
    int nDmg = 0;

    // Note: Caster Lvl is /2 for purposes of Spell Resistance (done internally in code)
    //Make SR Check
    if ( nIgnoreResists || (!DoWarlockMyResistSpell(oCaster, oTarget)) )
    {
        int nDmgDice = GetEldritchBlastLevel(oCaster);
		
		if (!BonusDamageAdded)
		{
			BonusDamageAdded = TRUE;
			int BlastBonus2 = GetLocalInt(oCaster, "BlastBonus_2");
			if (BlastBonus2 > 0)
			{
				SetLocalInt(oCaster, "BlastBonus_2", BlastBonus2 -1);
				BonusDamageDice = BonusDamageDice + 2;
			}			
		}
		
		int nBonusDice = 0; // default
        nDmg = d6(nDmgDice + BonusDamageDice);
		
		//Critical hit
		if (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
		{
			nDmgDice += nBonusDice;
			nDmg = d6(nDmgDice * 2);
			nIsCritcalAttack = 1; //for Hellfire
		}
        
        // AFW-OEI 02/20/2007: Eldritch Master increases damage by 50%
        if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
        {
            nDmg = nDmg + nDmg/2;
        }
        
        if ( nHalfDmg )
        {
            nDmg = nDmg / 2;
            if ( nDmg == 0 )
            {
                nDmg = 1;
            }
        }
        
        // Some Invocations allow chance to halve the damage
        if ( nAllowReflexSave ) {
		
			int nMetaMagic = GetMetaMagicFeat();
			if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST ) {
				SendMessageToPC(oCaster, "Hellrime turned reflex save to fortitude");
				if (FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster)) {
					nDmg = nDmg/2;
				}
			} else {
            	nDmg = GetReflexAdjustedDamage(nDmg, oTarget, GetSpellSaveDC());
			}
        }
    }

    return nDmg;
}

int GetHellfireBlastDmg(object oCaster)
{
int nDmg = 0;
	int nCasterLevel = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, OBJECT_SELF);
	nDmg = d6(2*nCasterLevel);
	if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER))
		nDmg = FloatToInt(nDmg*1.5);		
		
	if (nIsCritcalAttack == 1) nDmg = nDmg*2;
		
	return nDmg;
}

//int METAMAGIC_ELDRITCH_SHAPES = (METAMAGIC_INVOC_ELDRITCH_SPEAR | METAMAGIC_INVOC_HIDEOUS_BLOW | METAMAGIC_INVOC_ELDRITCH_CHAIN | METAMAGIC_INVOC_ELDRITCH_CONE | METAMAGIC_INVOC_ELDRITCH_DOOM);


int DoEldritchBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nDmgType, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int nVFX)
{
    // Default Blast w/no mods
    int nMetaMagic = GetMetaMagicFeat();
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default is Edlritch
	int nTouch;
    //if ( nMetaMagic != METAMAGIC_NONE )
    //if ( !(nMetaMagic & METAMAGIC_ELDRITCH_SHAPES) )
	
	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nHitVFX = VFX_INVOCATION_DRAINING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nHitVFX = VFX_INVOCATION_BESHADOWED_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nHitVFX = VFX_INVOCATION_HELLRIME_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nHitVFX = VFX_INVOCATION_BEWITCHING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nHitVFX = VFX_INVOCATION_NOXIOUS_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nHitVFX = VFX_INVOCATION_UTTERDARK_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nHitVFX = VFX_INVOCATION_HINDERING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nHitVFX = VFX_INVOCATION_BINDING_HIT; }

    effect eBeam = EffectBeam(nVFX, oCaster, BODY_NODE_HAND);
		
	if (!bCalledFromShape) // Only the unmodified blast will deal hellfire damage here, because the shapes will each call the damage on their own.
	{
		DoHellfireDamage();
	}
		
    if(bDoTouchTest)
    {
        // AFW-OEI 02/20/2007: Eldritch Master adds +2 to the attack roll.
        int nBonus = 0;
        if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
        {
            nBonus = 2;
        }
    
		nTouch      = TouchAttackRanged(oTarget, TRUE, nBonus);
		if (GetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT")) //collect only when requested
		{
		    SetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT", nTouch);
		}
		
        //if ( TouchAttackRanged( oTarget, TRUE, nBonus ) == TOUCH_ATTACK_RESULT_MISS )
		if (nTouch == TOUCH_ATTACK_RESULT_MISS)
        {
            // We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
            if ( !bCalledFromShape )
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
            }
            // Failed
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
            return FALSE;
        }
    }
	
    // Spell Effects not allowed to stack...
    // FIX: moved to essence code, to prevent losing effects if target saves from new attack
    //RemoveEffectsFromSpell(oTarget, GetSpellId());

	//Allows utterdark to heal undead, but only for half damage
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) == TRUE ||
	(nDmgType == DAMAGE_TYPE_NEGATIVE && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));

        int nDmg = GetEldritchBlastDmg(oCaster, oTarget, nAllowReflexSave, nIgnoreResists, nHalfDmg, nTouch);

        if ( nDmg > 0 )  // Make sure wasn't resisted
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));

            //Set damage effect
            float fDelay = 0.0;
			
			// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDmg += PS_AddSneakDmgToSpell(oCaster, oTarget, nDmgType);
				
            effect eDam = EffectDamage(nDmg, nDmgType);
            effect eVis = EffectVisualEffect( nHitVFX );
            effect eDamageHellfire;
			if (nDmgType == DAMAGE_TYPE_NEGATIVE && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				eDam = EffectHeal(nDmg/2);
				
			} else if (nDmgType == DAMAGE_TYPE_FIRE) { //Making Brimstone half fire/half magic
				eDam = EffectDamage(nDmg/2, nDmgType);
				eDam = EffectLinkEffects(eDam, EffectDamage(nDmg/2, DAMAGE_TYPE_MAGICAL));
				
				//If we do over 1/5th of max hit points in damage, then fear effect! (will save allowed)
				//This is similiar to the already existing burn damage system, but should take place sliiightly faster
				//And includes the magic damage total in the calculation
				if (nDmg > (GetMaxHitPoints(oTarget)/5)) {
					if (!WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR, oCaster)) {
						effect eFear = EffectFrightened();
						int nDur = (GetWarlockCasterLevel(oCaster)/5);
						if (nDur <= 0) nDur = 1;
						float fDur = RoundsToSeconds(nDur);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget);
					}
				}
			}
			
			if (IsHellfireBlastActive())
			{
				//SpeakString("IsHellfireBlastActive! Test2!");
				eDamageHellfire = EffectDamage(GetHellfireBlastDmg(OBJECT_SELF), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE);
				eVis = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_HIT );
				eBeam = EffectBeam(VFX_INVOCATION_BRIMSTONE_RAY, oCaster, BODY_NODE_HAND);			
			}
			
			effect eLinkDam = EffectLinkEffects(eDam, eDamageHellfire);
			
            //Apply the damage effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
            DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkDam, oTarget) );

			// We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
			if ( !bCalledFromShape )
			{
            	DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0) );
			}
			
            return TRUE;
        }
		
		if (nDmg <= 0 && IsHellfireBlastActive()) //If target resisted our blast but hellfire is active
		{
			//Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));

            //Set damage effect
            float fDelay = 0.0;
			effect eDamageHellfire = EffectDamage(GetHellfireBlastDmg(OBJECT_SELF), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE);
            effect eVis = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_HIT );
			eBeam = EffectBeam(VFX_INVOCATION_BRIMSTONE_RAY, oCaster, BODY_NODE_HAND);
			
			//Apply the damage effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
            DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageHellfire, oTarget) );
				
			// We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
			if ( !bCalledFromShape )
			{
            	DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0) );
			}
			
			return TRUE;		
		}
		
        if ( !bCalledFromShape )
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
        }
    }
    return FALSE;
}


// -------------------------------------------------------------------
//
int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    int nMetaMagic = GetMetaMagicFeat();
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { return DoEssenceDrainingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { return DoEssenceFrightfulBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { return DoEssenceBeshadowedBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { return DoEssenceBrimstoneBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { return DoEssenceHellrimeBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { return DoEssenceBewitchingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { return DoEssenceNoxiousBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { return DoEssenceVitriolicBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { return DoEssenceUtterdarkBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { return DoEssenceHinderingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { return DoEssenceBindingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else
    {
        // No extra effects
		//SpeakString("DoEldritchCombinedEffects(...): No blast invocation.");	// DEBUG!
        return DoEldritchBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg);
    }
}

void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE)
{
    DoEldritchCombinedEffects(oTarget, FALSE, nAllowReflexSave, nHalfDmg);
}


// -------------------------------------------------------------------
// Eldritch Essence Effects:
int DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}

	// First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_DRAINING_RAY) )
    {
        // Additional Effects: (Slow Effect)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(1);

                effect eSlow = EffectSlow();
                effect eDur = EffectVisualEffect( VFX_IMP_SLOW );
                effect eLink = EffectLinkEffects(eSlow, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_DRAINING_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the slow effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}
	
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_FRIGHTFUL_RAY) )
    {
        // Additional Effects: (Cause Fear Effect)
        if ((GetHitDice(oTarget) <= nCasterLevel) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                float fDuration = RoundsToSeconds(10);

                effect eScare = EffectFrightened();
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
                effect eLink = EffectLinkEffects(eMind, eScare);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply linked effects and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}
	
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BESHADOWED_RAY) )
    {
        // Additional Effects: (Darkness)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            //Make Fort save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(1);
				int nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );
				

                //effect eDark = EffectDarkness();
				effect eDark = EffectBlindness();
				effect eAC = EffectACDecrease( 2 );
				effect eLink = EffectLinkEffects( eDark, eAC );
                //effect eDur = EffectVisualEffect(VFX_INVOCATION_BESHADOWED_HIT);	// handled by DoEldritchBlast()
                //effect eLink = EffectLinkEffects(eDark, eDur);	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				
				if (nDex > 10)
				{
					int nDecr = (nDex-10);
					effect eDex = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecr);
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
				}
                return TRUE;
            }
        }
    }
    return FALSE;
}


void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft)
{
	//SpeakString("RunEssenceBrimstoneBlastImpact(...): Entering function.");	// DEBUG!
	
	// AFW-OEI 07/06/2006: Can't "dispel" fire, so no need to check effects
    //if (GZGetDelayedSpellEffectsExpired(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster))
    //{
    //    return;
    //}

	
    if ((GetIsDead(oTarget) == FALSE) && (nRoundsLeft > 0))
    {
        int nDC = GetDelayedSpellInfoSaveDC(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster);

		
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            int nDmg = d6(2);
            effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_FIRE);
            

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, 6.0);	// handled by DoEldritchBlast()

            nRoundsLeft = nRoundsLeft - 1;
            DelayCommand(RoundsToSeconds(1), RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft));	// Delay for one more round
        }
        else
        {
            RemoveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster);
            //GZRemoveSpellEffects(SPELL_I_BRIMSTONE_BLAST, oTarget);
        }
    }
}


int DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("DoEssenceBrimstoneBlast(...): Entering function.");	// DEBUG!
	int nHasSpellEffect = GetHasSpellEffect(GetSpellId(), oTarget);

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_FIRE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BRIMSTONE_RAY) )
    {
        // Additional Effects: (Combust)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
			
            // Doesn't Stack!
            if (nHasSpellEffect == 1)
            {
                //FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
                return FALSE;
            }

            int nCasterLvl = GetWarlockCasterLevel(OBJECT_SELF);
			// Fey Power Heritage Feat adds +1 to your warlocl level MOVED TO ENGINE
		//	if (GetHasFeat(FEAT_FEY_POWER, oCaster) || GetHasFeat(FEAT_FIENDISH_POWER, oCaster))			{ nCasterLvl +=  1; }
            int nRoundsLeft;
            if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
            else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
            else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
            else                          { nRoundsLeft = 1; }

            int nDC = GetSpellSaveDC();
            SaveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster, nDC);
			effect eVFX = ExtraordinaryEffect(EffectVisualEffect(894));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(nRoundsLeft));	
			DelayCommand(RoundsToSeconds(1), RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft));	// First check should be one round after the blast hit
				
	        return TRUE;
        }
    }
    return FALSE;
}


int DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_COLD, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HELLRIME_RAY) )
    {
        // Additional Effects: (Dex Penalty)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                float fDuration = RoundsToSeconds(3);

                effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				//effect eVis = EffectVisualEffect( VFX_INVOCATION_HELLRIME_HIT );	// handled by DoEldritchBlast()
               // effect eLink = EffectLinkEffects(eDex, eDur);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}
	
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BEWITCHING_RAY) )
    {
        // Additional Effects: (Confusion)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                float fDuration = RoundsToSeconds(1);

                //effect eVis = EffectVisualEffect( VFX_INVOCATION_BEWITCHING_HIT );	// handled by DoEldritchBlast()
                effect eConfuse = EffectConfused();
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                //effect eDur = EffectVisualEffect( VFX_INVOCATION_BEWITCHING_HIT );
                //Link duration VFX and confusion effects
                effect eLink = EffectLinkEffects(eMind, eConfuse);
                //eLink = EffectLinkEffects(eLink, eDur);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply linked effect and VFX Impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}
	
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_NOXIOUS_RAY) )
    {
        // Additional Effects: (Daze)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(10);

                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eDaze = EffectDazed();
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eLink = EffectLinkEffects(eMind, eDaze);
                //eLink = EffectLinkEffects(eLink, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_NOXIOUS_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft)
{
// AFW-OEI 07/06/2006: Vitriolic Blast has no save and ignores spell resistance!.

// JLR-OEI 06/30/06: Delayed spell info not desired here...because no associated effect keyed to target
//    if (GZGetDelayedSpellEffectsExpired(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster))
//    {
//        return;
//    }

	//SpeakString("RunEssenceVitriolicBlastImpact(...): Entering function.");	// DEBUG!

    if ((GetIsDead(oTarget) == FALSE) && (nRoundsLeft > 0))
    {
//        int nDC = GetDelayedSpellInfoSaveDC(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster);
//        {
            int nDmg = d6(2);
            effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_ACID);
            //effect eVFX = EffectVisualEffect( VFX_IMP_ACID_S );	// handled by DoEldritchBlast()

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);	// handled by DoEldritchBlast()

            nRoundsLeft = nRoundsLeft - 1;
            DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft));	// Delay for one more round
//        }
    }
    else
    {
//        RemoveDelayedSpellInfo(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster);
//        GZRemoveSpellEffects(SPELL_I_VITRIOLIC_BLAST, oTarget);
    }
}


int DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("DoEssenceVitriolicBlast(...): Entering function.");	// DEBUG!

	int nHasSpellEffect = GetHasSpellEffect(GetSpellId(), oTarget);

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_ACID, nAllowReflexSave, TRUE, nHalfDmg, VFX_INVOCATION_VITRIOLIC_RAY) )
    {
        // Additional Effects: (Acid)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            int nDC = GetSpellSaveDC();
            {
                // Doesn't Stack!
                //if (GetHasSpellEffect(GetSpellId(),oTarget))    // JLR-OEI 06/30/06: This will always return true due to above eldritch blast dmg effect that gets applied
                if (nHasSpellEffect == 1)
				{
                    //FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
                    return FALSE;
                }

                int nCasterLvl = GetWarlockCasterLevel(OBJECT_SELF);
				// Fey Power Heritage Feat adds +1 to your warlocl level MOVED TO ENGINE
				//if (GetHasFeat(FEAT_FEY_POWER, oCaster) || GetHasFeat(FEAT_FIENDISH_POWER, oCaster))						{ nCasterLvl +=  1; }
                int nRoundsLeft;
                if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
                else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
                else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
                else                          { nRoundsLeft = 1; }

				// JLR-OEI 06/30/06: Delayed spell info not desired here...because no associated effect keyed to target
//                SaveDelayedSpellInfo(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster, nDC);

                DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft)); // First check should be one round after the blast hit

                //Apply the effect and VFX impact
//                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                return TRUE;
            }
        }
    }
    return FALSE;
}

void CheckNumberOfShadows(object oPC) {
	
	int nNumberCalled = GetLocalInt(oPC, "WARLOCK_UNDEAD_CALLED");
	int currentNumber = 0;

	int n;
	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(n));
		if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
			currentNumber++;
		}
	}

	SetLocalInt(oPC, "WARLOCK_UNDEAD_CALLED", currentNumber);

	int newCount = 0;
	if (currentNumber != nNumberCalled) {
		for(n = 0; n <= nNumberCalled; n++) {
			object oSummon = GetLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(n));
			if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
				SetLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(newCount), oSummon);
				newCount++;
			} else {
				DeleteLocalObject(oPC, "WARLOCK_UNDEAD_"+IntToString(n));
			}
		}
	}

}

void DoWraithExtraction(object oCaster, object oTarget, location lTarget) {
	
	//SendMessageToPC(oCaster, "Trying to extract wraith.");
	//If we just killed them, then we should get a shadow!
	if (GetIsDead(oTarget)) {
			
			//SendMessageToPC(oCaster, "Monster is deeeead.");
			
			CheckNumberOfShadows(oCaster);
		
			int nNumberCalled = GetLocalInt(oCaster, "WARLOCK_UNDEAD_CALLED");
			if (nNumberCalled < 8) {
			
				object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "ps_summon_warlockshadow", lTarget);
				SetLocalObject(oCreature, abilityCaster, oCaster);
				SetLocalObject(oCreature, "FOLLOW_MASTER", oCaster);
				SetLocalInt(oCreature, "IS_SUMMONED", 1);
				
				SetLocalObject(oCaster, "WARLOCK_UNDEAD_"+IntToString(nNumberCalled), oCreature);
				SetLocalInt(oCaster, "WARLOCK_UNDEAD_CALLED", nNumberCalled+1);
				
				DestroyObject(oCreature, 360.0f); //Sanity destroy so you can keep summoning more
				
			} else {
			
				SendMessageToPC(oCaster, "You may not raise any more shadows.");
			
			}
		
		}
}


int DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	location lTarget = GetLocation(oTarget);
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_NEGATIVE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_UTTERDARK_RAY) )
    {
		if (d100() < 15) {
			DelayCommand(0.1f, DoWraithExtraction(oCaster, oTarget, lTarget));
		}
		
	
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_DRAIN );
            effect eDrain = EffectNegativeLevel(2);
            eDrain = SupernaturalEffect(eDrain);
			effect eLink = EffectLinkEffects( eDrain, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(1));
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}

//Now Blackbolt
int DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_ELECTRICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HINDERING_RAY) )
    {
        int nChance = d100();
		if (nChance < 20) { //20% chance of knockdown
			effect eFX = EffectKnockdown();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oTarget, 6.0f);
		}
    }
    return FALSE;
}

int DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("nw_i0_invocatns: DoEssenceBindingBlast");
	int nDC = GetSpellSaveDC();
    if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BINDING_RAY) )
    {
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_STUN );
            effect eStun = EffectStunned();
            eStun = SupernaturalEffect(eStun);
			effect eLink = EffectLinkEffects( eStun, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            return TRUE;
        }
    }
    return FALSE;
}

// -------------------------------------------------------------------
// Blast Shape Effects:
int DoShapeEldritchSpear()
{
				
    //Declare major variables
    object oTarget = GetSpellTargetObject();

	// DoHellfireDamage(); -Spear doesn't do Hellfire damage here because it's considered not called from a shape -Electrohydra
	
    int nMetaMagic = GetMetaMagicFeat();
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { return DoEssenceDrainingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { return DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { return DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { return DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { return DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { return DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { return DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { return DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { return DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { return DoEssenceHinderingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { return DoEssenceBindingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else
    {
        // No extra effects
		//SpeakString("DoEldritchCombinedEffects(...): No blast invocation.");	// DEBUG!
        return DoEldritchBlast( OBJECT_SELF, oTarget, FALSE, TRUE );
    }




    //return FALSE;
}


int DoShapeHideousBlow()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
	
	DoHellfireDamage();
    // Handle combined Eldritch Essence Effects, if any
    return DoEldritchCombinedEffects(oTarget, FALSE);
}


int DoShapeEldritchChain()
{
	//SpeakString("DoShapeEldritchChain(): Entering function.");	// DEBUG!

    //Declare major variables
    int nCasterLvl = GetWarlockCasterLevel(OBJECT_SELF);
	// Fey Power Heritage Feat adds +1 to your warlocl level MOVED TO ENGINE
	// if (GetHasFeat(FEAT_FEY_POWER, OBJECT_SELF) || GetHasFeat(FEAT_FIENDISH_POWER, OBJECT_SELF) )						{ nCasterLvl +=  1; }
    //Limit caster level
    // June 2/04 - Bugfix: Cap the level BEFORE the damage calculation, not after. Doh.
    if (nCasterLvl > 20) { nCasterLvl = 20; }
    int nNumAffected = 0;
    int nMetaMagic = GetMetaMagicFeat();
	
	int nChain1VFX = VFX_INVOCATION_ELDRITCH_CHAIN;	// default Chain1 is Eldritch
	int nChain2VFX = VFX_INVOCATION_ELDRITCH_CHAIN2;	// default Chain2 is Eldritch
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default nHitVFX is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         
	{ 
		nChain1VFX = VFX_INVOCATION_DRAINING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_DRAINING_CHAIN2;
		nHitVFX = VFX_INVOCATION_DRAINING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN; 
		nChain2VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN2; 
		nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  
	{ 
		nChain1VFX = VFX_INVOCATION_BESHADOWED_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BESHADOWED_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BESHADOWED_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    
	{ 
		nChain1VFX = VFX_INVOCATION_HELLRIME_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HELLRIME_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HELLRIME_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  
	{ 
		nChain1VFX = VFX_INVOCATION_BEWITCHING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BEWITCHING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BEWITCHING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     
	{ 
		nChain1VFX = VFX_INVOCATION_NOXIOUS_CHAIN; 
		nChain2VFX = VFX_INVOCATION_NOXIOUS_CHAIN2; 
		nHitVFX = VFX_INVOCATION_NOXIOUS_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_VITRIOLIC_CHAIN; 
		nChain2VFX = VFX_INVOCATION_VITRIOLIC_CHAIN2; 
		nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_UTTERDARK_CHAIN; 
		nChain2VFX = VFX_INVOCATION_UTTERDARK_CHAIN2; 
		nHitVFX = VFX_INVOCATION_UTTERDARK_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_HINDERING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HINDERING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HINDERING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_BINDING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BINDING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BINDING_HIT;
	}
	
	if (IsHellfireBlastActive())
	{
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
	
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam( nChain1VFX, OBJECT_SELF, BODY_NODE_HAND );
    effect eVis  = EffectVisualEffect( nHitVFX );
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;
    //Hit the initial target

    //if ( TouchAttackRanged( oTarget ) == TOUCH_ATTACK_RESULT_MISS )
    //{
    //    // Failed
    //    return FALSE;
    //}

    //setting this to non-zero will trigger collecting touch attack success info from DoEldritchCombinedEffects
    SetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT", 1);

    //Apply effect to the first target and the VFX impact.
    if(DoEldritchCombinedEffects(oFirstTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(nChain2VFX, oFirstTarget, BODY_NODE_CHEST);


    float fDelay = 0.2;
    int nCnt = 0;
    // Warlock Counts
    int nMaxCnt;
    if ( nCasterLvl >= 20 )      { nMaxCnt = 4; }
    else if ( nCasterLvl >= 15 ) { nMaxCnt = 3; }
    else if ( nCasterLvl >= 10 ) { nMaxCnt = 2; }
    else                         { nMaxCnt = 1; }


    // *
    // * Secondary Targets
    // *


    // AFW-OEI 02/20/2007: Eldritch Master adds +2 to the attack roll.
    int nBonus = 0;
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, OBJECT_SELF))
    {
        nBonus = 2;
    }   
    
    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE );

    int nTouch = GetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    DeleteLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    if ( nTouch == TOUCH_ATTACK_RESULT_MISS )
    {
	    // Failed
		return FALSE;
	}
	
    while (GetIsObjectValid(oTarget) && nCnt < nMaxCnt)
    {
		//SpeakString("DoShapeEldritchChain(): Chain target while loop iteration.");	// DEBUG!

        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
		    nTouch = TouchAttackRanged( oTarget, TRUE, nBonus );
		    if ( nTouch == TOUCH_ATTACK_RESULT_MISS )
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
    			    // Failed
    				return FALSE;
    		}
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
            {
                if ( nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) )
                {
                    DelayCommand(fDelay, DoEldritchCombinedEffectsWrapper(oTarget,FALSE));
                }
                else
                {
                    DelayCommand(fDelay, DoEldritchCombinedEffectsWrapper(oTarget,FALSE,TRUE));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                eLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
	        //Count the number of targets that have been hit.
	        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsDead(oTarget))	// added the GetIsDead check to keep from cheating the player when corpses are hit, which were counting against the max count
	        {
	            nCnt++;
	        }
        }
		
        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    }
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	DoHellfireDamage();	
    return TRUE;
}

//Updating to burst shape
int DoShapeEldritchCone()
{
	//SpawnScriptDebugger();
    //Declare major variables
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    float fMaxDelay = 1.0;
    int nMetaMagic = GetMetaMagicFeat();
	int nConeVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default cone is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nConeVFX = VFX_INVOCATION_DRAINING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nConeVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nConeVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nConeVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nConeVFX = VFX_INVOCATION_HELLRIME_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nConeVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nConeVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nConeVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nConeVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nConeVFX = VFX_INVOCATION_HINDERING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nConeVFX = VFX_INVOCATION_BINDING_DOOM; }

	effect eCone = EffectVisualEffect( nConeVFX );
	if (IsHellfireBlastActive()) eCone = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 7.0, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.0, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	DoHellfireDamage();
    return TRUE;
}


int DoShapeEldritchDoom()
{
    int nMetaMagic = GetMetaMagicFeat();
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default Doom is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nDoomVFX = VFX_INVOCATION_DRAINING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nDoomVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nDoomVFX = VFX_INVOCATION_HINDERING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
 
   //Declare major variables
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    // Visual on the Location itself...
    effect eExplode = EffectVisualEffect( nDoomVFX );
	if (IsHellfireBlastActive()) eExplode = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchCombinedEffects(oTarget, FALSE, TRUE);

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	DoHellfireDamage();
    return TRUE;
}

//void main() {}	// keep this line uncommented before saving/checking in; used only for compiling purposes

// -------------------------------------------------------------------