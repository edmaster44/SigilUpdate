#include "nwn2_inc_spells"
#include "x2_inc_spellhook" 
#include "aaa_constants"
#include "ps_inc_functions"

//Constants specific to these spells...
//################################################

const int SPELL_FEAT_BLINK = 4000;
const int SPELL_FEAT_DIMENSION_DOOR = 4001;
const int SPELL_FEAT_FERAL_MARK = 4002;
const int SPELL_FEAT_BATTLE_HOWL = 4003;
const int SPELL_FEAT_WW_COLDTYPE1 = 4004;
const int SPELL_FEAT_WW_COLDTYPE2 = 4005;
const int SPELL_FEAT_WG_ImpKnockdown = 4006;
const int SPELL_FEAT_BD_Mobility = 4007;
const int SPELL_FEAT_WW_FREEZING_BR = 4008;
const int SPELL_FEAT_HUNTING_LOPE1 = 4009;
const int SPELL_FEAT_HUNTING_LOPE2 = 4010;
const int SPELL_FEAT_ETERNAL_LEADER = 4011;
const int SPELL_FEAT_TEARING_BITE = 4012;
const int SPELL_FEAT_GENESIS = 4013;
const int SPELL_FEAT_ARMOR_OF_NATURE = 4014;
const int SPELL_FEAT_OVERGROWTH = 4015;
const int SPELL_FEAT_TOUGH_ROOTS = 4016;
const int SPELL_FEAT_ANIMATE_TREES = 4017;
const int SPELL_FEAT_TREANT_RESISTANCE = 4018;

const int VFX_DUR_SPELL_BLINK = 1100;
const int VFX_TELEPORT_1 = 1101;
const int VFX_DUR_SPELL_BATTLE_HOWL = 1102;
const int VFX_HIT_AOE_BATTLE_HOWL = 1103;

//################################################
object oSelf = OBJECT_SELF;

void WinterWolfColdImmunity(int nColdRes, int nFireVul)
{
	effect eColdImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nColdRes);	
	effect eFireVulnerability;
	if (nFireVul>0) eFireVulnerability = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, nFireVul);
	effect eLink = EffectLinkEffects(eColdImmunity, eFireVulnerability);
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, GetSpellId());
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSelf));	
}

void StripSpellEffect(int SpellID1 = -1, int SpellID2 = -1)
{
	effect eEffect = GetFirstEffect(oSelf);
	while(GetIsEffectValid(eEffect))
	{
		if (GetEffectSpellId(eEffect) == SpellID1 | GetEffectSpellId(eEffect) == SpellID2)
		{
			RemoveEffect(oSelf, eEffect);
		}
		eEffect = GetNextEffect(oSelf);
	}
}

void DoBattleHowl()
{
    //Declare major variables
	object oPC = OBJECT_SELF;
    object oTarget;
	int iPackLevel = GetLevelByClass(CLASS_TYPE_PACK_LEADER, oPC);
	int iAttack;
	if (iPackLevel >= 5) iAttack = 3;
	else if (iPackLevel >= 3) iAttack = 2;
	else iAttack = 1;
	effect eAttack = EffectAttackIncrease(iAttack);
    effect eSavingThrows = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    effect eFear = EffectFrightened();
    effect eLOS = EffectVisualEffect(VFX_HIT_AOE_BATTLE_HOWL);
	effect eBuf = EffectVisualEffect ( VFX_DUR_SPELL_BATTLE_HOWL );
	effect eVisFear = EffectVisualEffect (VFX_DUR_SPELL_CAUSE_FEAR);
    effect eLink = EffectLinkEffects(eAttack, eSavingThrows);
	eLink = EffectLinkEffects(eLink, eBuf);
	eFear = EffectLinkEffects (eFear, eVisFear);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, oPC);
	int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nSpellSaveDC = 10 + GetHitDice(oPC) + nCHA;
	if (nCHA < 1) nCHA = 1; //Let's set a minimum duration to make sure it does something no matter how low CHA is.
	
    //Determine enemies in the radius around the bard
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
        {
           if(MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR) == FALSE)
            {
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(nCHA +3)));
            }
        }
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
		{
			RemoveSpellEffects(GetSpellId(), oPC, oTarget); ///remove effect before apply new one
			DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCHA +3)));
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
    }
}

void FeralHeart()
{
    effect eFearImmunity = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eSavingThrows = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
	effect eLink = EffectLinkEffects(eSavingThrows, eFearImmunity);
	eLink = SupernaturalEffect(eLink);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSelf));			
}

void Blink()
{
	object oSelf = OBJECT_SELF;
	int nCharacterLevel = GetTotalLevels(oSelf, 1);
	if (nCharacterLevel>25) nCharacterLevel = 25;
	effect eDisplace = EffectConcealment(nCharacterLevel*2);
		eDisplace = SupernaturalEffect(eDisplace);
	
	// New "Blinking" movement added by Ceremorph
//	float fOrient = GetFacing(oSelf);
//	float fx = IntToFloat(Random(15));
//	float fy = IntToFloat(Random(15));
//	float fz = IntToFloat(Random(15));
	location lStart = GetLocation(oSelf);
//	location lDestination = Location(GetAreaFromLocation(lStart), Vector(fx, fy, fz), fOrient);
//	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLINK);
//	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lDestination, TRUE, OBJECT_TYPE_CREATURE);
//	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSelf);
//	DelayCommand(0.1f, ActionJumpToLocation(lDestination));
	DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisplace, oSelf, RoundsToSeconds(2)));
//	while (GetIsObjectValid(oTarget))
//	{	if (GetIsEnemy(oTarget, oSelf))
//		{	DelayCommand(0.3f, ActionAttack(oTarget));	}
//		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lDestination, TRUE, OBJECT_TYPE_CREATURE);
//	}
}

void DimensionDoor(object oSelf)
{	
	object oCaster = oSelf;
	object oTarget = oSelf;
	AssignCommand(oSelf, ClearAllActions());
	location lTarget = GetSpellTargetLocation();
	location lCaster = GetLocation (oSelf);
	effect eVis = EffectVisualEffect(VFX_TELEPORT_1);

	if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
	if (GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
	{
		SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
		return;	
	}
	SendMessageToPC(oTarget, "Arcane energies whisk you away to your targeted location.");
	AssignCommand(oTarget, ActionJumpToLocation(lTarget));
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
}

void ReplaceFeat(int nFeatIDToReplace, int nFeatID)
{
	FeatAdd(oSelf, nFeatID, 0);
	FeatRemove(oSelf, nFeatIDToReplace);
//	SendMessageToPC(oSelf, "Added FeatID: "+IntToString(nFeatID));
//	SendMessageToPC(oSelf, "Trying Remove FeatID: "+IntToString(nFeatIDToReplace));
}

void RemoveFeat(int nFeatID)
{
	FeatRemove(oSelf, nFeatID);
//	SendMessageToPC(oSelf, "Removed FeatID: "+IntToString(nFeatID));
}

void AdjustMovementSpeed(float fRate)
{
	float fRateGet = fRate;
	int nHasDash = GetHasFeat(FEAT_DASH, oSelf, TRUE);
	if (nHasDash == TRUE)
	{
		SetMovementRateFactor(oSelf, fRateGet+0.2);
		return;
	}
	SetMovementRateFactor(oSelf, fRateGet);
}

void CastConeCold()
{
	object oPC = OBJECT_SELF;
    int nCasterLevel = GetHitDice(oPC);
	int nDC = 10 + nCasterLevel / 2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
	float fMaxDelay = 0.0f; // Used to determine duration of cold cone
    object oTarget;
	effect eCold;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    { 
					//If The Targets are Friendly, it will not do nothing
		if (GetIsReactionTypeFriendly(oTarget,GetAreaOfEffectCreator(OBJECT_SELF)))
			{
				return;
				}
	
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    	{
                // SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
				// Winter Wolf breath bypasses evasion and spell resistance.
                fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
				if (fDelay > fMaxDelay)	fMaxDelay = fDelay;
                nDamage = d8(nCasterLevel);
				if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_COLD, oPC, fDelay) && (oTarget != oPC))
				{
					nDamage = d4(nCasterLevel);
				}
                eCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                //Apply delayed effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
        }
		
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 1.5f;
	effect eCone = EffectVisualEffect(VFX_DUR_WINTER_WOLF_BREATH);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oPC, fMaxDelay);
}

void ApplyRegeneration() //Eternal Leader
{
	effect eRegen = EffectRegenerate(2, 6.0);
	eRegen = SupernaturalEffect(eRegen);
	effect eEffect = GetFirstEffect(oSelf);
	//check for effect
	while(GetIsEffectValid(eEffect))
	{
		if (GetEffectSpellId(eEffect) == SPELL_FEAT_ETERNAL_LEADER)
		{
			return;
		}
		eEffect = GetNextEffect(oSelf);
	}
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oSelf);
}

void TearingBite()
{
	object oTarget = GetSpellTargetObject();
	int nDamage = GetTotalLevels(oSelf, TRUE)/2;
	float fDuration = 6.0*IntToFloat(GetTotalLevels(oSelf, TRUE))/3;
	if (nDamage<1) nDamage = 1;
	if (fDuration<1.0) fDuration = 6.0;
	effect eBleeding = EffectDamageOverTime(nDamage, 6.0, DAMAGE_TYPE_ALL, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBleeding, oTarget, fDuration);
	ActionAttack(oTarget);
//	SendMessageToPC(oSelf, "Duration/Damage: "+FloatToString(fDuration)+"/"+IntToString(nDamage));
}

void Genesis()
{
    effect eMindImmunity = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		eMindImmunity = SupernaturalEffect(eMindImmunity);
	int nSpell = GetSpellId();
	eMindImmunity = SetEffectSpellId(eMindImmunity, nSpell);
	RemoveEffectsFromSpell(oSelf, nSpell);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMindImmunity, oSelf));			
}

void ArmorOfNature()
{
	int nPlantLevel = GetLevelByClass(CLASS_TYPE_PLANTPC);
    effect eDodge = EffectACIncrease(nPlantLevel, AC_DODGE_BONUS);
		eDodge = SupernaturalEffect(eDodge);
//	SendMessageToPC(oSelf, "ExpectedACBonus: "+IntToString(nPlantLevel));
	int nSpell = GetSpellId();
	eDodge = SetEffectSpellId(eDodge, nSpell);
	RemoveEffectsFromSpell(oSelf, nSpell);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDodge, oSelf));			
}

void Overgrowth()
{
    effect eParalysisImmunity = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eStunImmunity = EffectImmunity(IMMUNITY_TYPE_STUN);
	effect ePoisonImmunity = EffectImmunity(IMMUNITY_TYPE_POISON);
	
	effect eLink = EffectLinkEffects(eParalysisImmunity, eStunImmunity);
	effect eLink2 = EffectLinkEffects(eLink, ePoisonImmunity);
		eLink2 = SupernaturalEffect(eLink2);
	int nSpell = GetSpellId();
	eLink2 = SetEffectSpellId(eLink2, nSpell);
	RemoveEffectsFromSpell(oSelf, nSpell);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oSelf));			
}

void ToughRoots()
{
    effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		eCritImmune = SupernaturalEffect(eCritImmune);
	int nSpell = GetSpellId();
	eCritImmune = SetEffectSpellId(eCritImmune, nSpell);
	RemoveEffectsFromSpell(oSelf, nSpell);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCritImmune, oSelf));			
}

void TreantResist()
{
    effect eDamageReduction = EffectDamageReduction(10, DAMAGE_TYPE_SLASHING, 0, DR_TYPE_DMGTYPE);
	effect eFireVuln = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
	
	effect eLink 	= EffectLinkEffects(eDamageReduction, eFireVuln);
		eLink		= SupernaturalEffect(eLink);
		eLink 		= SetEffectSpellId(eLink, GetSpellId());
	int nSpell = GetSpellId();
	eLink = SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oSelf, nSpell);
	
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSelf));
//	SendMessageToPC(oSelf, "Applying Treant Resistance!");
}


void AnimateTrees()
{
    int nDuration = GetTotalLevels(oSelf, 1)*60;
	int nCharacterLevel = GetTotalLevels(oSelf, 1);
    effect eSummon = EffectSummonCreature("nw_s_treant_"+IntToString(nCharacterLevel));
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), IntToFloat(nDuration));
}

void HuntingLope(object oPC, int nIncrease, int nSpell)
{
	effect eSpeed = EffectMovementSpeedIncrease(nIncrease);
	eSpeed = SupernaturalEffect(eSpeed);
	eSpeed = SetEffectSpellId(eSpeed, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oPC);
	if (!GetLocalInt(oPC, "HuntingLope")){
		SendMessageToPC(oPC, "Speed increased by " + IntToString(nIncrease) + "%.");
		SetLocalInt(oPC, "HuntingLope", TRUE);
	}
	
}