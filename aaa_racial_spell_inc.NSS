#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"
#include "ginc_debug"

/*	This is the include file for all spell-like abilities given as part of a Race or Racial PrC.
	Every individual racial spell in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_racial_spell, which acts as the universal spell with a case-based system.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Spells Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/

// Cure Critical Wounds: 4d8 + iLevel healing	
void PS_Cast_CureCritical(object oTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;   }

	int iHeal		= d8(4) + iLevel;
	effect eVisual	= EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eHeal 	= EffectHeal(iHeal);
	effect eLink 	= EffectLinkEffects(eVisual, eHeal);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}

// Prayer: (iLevel + 10) rounds duration
void PS_Cast_Prayer(int iLevel)
{
	if (!X2PreSpellCastCode())
    {	return;	}
    object oTarget;
    	effect ePosVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER);
    	effect eNegVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER_VIC);
    	effect eImpact = EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);
    int nBonus = 1;
    	effect eBonAttack = EffectAttackIncrease(nBonus);
    	effect eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    	effect eBonDam = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
    	effect eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
	effect ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
    	ePosLink = EffectLinkEffects(ePosLink, eBonDam);
    	ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
		ePosLink = EffectLinkEffects(ePosLink, ePosVis);
    effect eNegAttack = EffectAttackDecrease(nBonus);
    	effect eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nBonus);
    	effect eNegDam = EffectDamageDecrease(nBonus, DAMAGE_TYPE_SLASHING);
    	effect eNegSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nBonus);
		effect eNegLink = EffectLinkEffects(eNegAttack, eNegSave);
    		eNegLink = EffectLinkEffects(eNegLink, eNegDam);
    		eNegLink = EffectLinkEffects(eNegLink, eNegSkill);
			eNegLink = EffectLinkEffects(eNegLink, eNegVis);
    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF ))
    	{   //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER, FALSE));
            //Apply VFX impact and bonus effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePosLink, oTarget, RoundsToSeconds(iLevel + 10));	}
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {   //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER));
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {   //Apply VFX impact and bonus effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegLink, oTarget, RoundsToSeconds(iLevel + 10));	}	}
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));	}
}

// Ethereal Jaunt: (iLevel + 10) rounds duration
void PS_Cast_EtherealJaunt(object oTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );	// NWN2 VFX
    effect eSanc = EffectEthereal();
    effect eLink = EffectLinkEffects(eVis, eSanc);
    int nDuration = iLevel;
 
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply the VFX impact and effects
    if(!GetHasSpellEffect(GetSpellId(), OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iLevel + 10));
    }

}

// Raise Dead: works just like the spell!
void PS_Cast_RaiseDead(object oTarget)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    effect eRaise = EffectResurrection();
    effect eVis = EffectVisualEffect( VFX_IMP_RAISE_DEAD );
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
    if(GetIsDead(oTarget))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
    }
}

// Darkness: duration of 2/3 character level
void PS_Cast_OM_Darkness(location lTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    int nDuration = (iLevel / 3) * 2;
    if (nDuration < 1)
    {	nDuration = 1;	}
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

// Hiss of Sleep: duration of 2/3 character level
void PS_Cast_OM_HissOfSleep(location lTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	//Declare major variables
 	object 		oCaster 	=	OBJECT_SELF;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    int 		iDur		=	(iLevel / 3) * 2;
	effect 		eDur 		= 	EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(iDur);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
			{	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	}	}
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);	}
}

void PS_Cast_OM_ConeOfCold(location lTarget, int iLevel)//FIXME!!!!!
{
    //Declare major variables
    int nDamage		= d6(10);
    int nDC 		= (iLevel / 3) * 2;
    float fDelay;
	float fMaxDelay = 1.5;
    object oTarget;
    effect eCone 	= EffectVisualEffect(VFX_DUR_WINTER_WOLF_BREATH);
	effect eDam;
    effect eVis 	= EffectVisualEffect(VFX_IMP_FROST_S);

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
        {   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_CONE_COLD));
            fDelay = 1.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			if (fDelay > fMaxDelay)
				fMaxDelay = fDelay;
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_COLD);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            if (nDamage > 0)
            {	eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));	}	}
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE);	}
    fMaxDelay += 0.5;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

void PS_Cast_EY_UnholyBlight(object oPC, location lTarget, int nSpell, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    int nDamage;
	int nCasterLvl = (iLevel * 2);
	int nChaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC = 20;
    float fDelay;
    effect eDam;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{	if (nSpell == 1885)
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	    {	if ((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) && (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER))
					{	nDamage = d6(nCasterLvl);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
					{	nDamage = d6(iLevel);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	nDamage = d6(iLevel) / 2;
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_EVIL))
						{	nDamage = nDamage / 2;	}	}
					else
					{	nDamage = 0;	}
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
    				effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
					effect eLink = EffectLinkEffects(eDam, eVis);
					effect eSick = EffectSickened();
					effect eEvil = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
				
					if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEvil, oTarget));	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));	}
                    else
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
						{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSick, oTarget));	}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
}	}

void PS_Cast_EY_SummonBaatezu(object oPC)
{
    int nLevel = GetTotalLevels(oPC, FALSE);
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if (nLevel >= 23)
    {	sCritter = "ps_summbaat_ey3";	}
	else if (nLevel >= 15)
	{	sCritter = "ps_summbaat_ey2";	}
	else
	{	sCritter = "ps_summbaat_ey1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your summons. Use the Unsummon Baatezu feat to return it to the Hells.");
}

void PS_Cast_BR_SummonBaatezu(object oPC)
{
    int nLevel = GetTotalLevels(oPC, FALSE);
	int nBrLevel = GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if ((nLevel >= 24) && (nBrLevel == 10))
    {	sCritter = "ps_summbaat_br4";	}
	else if (nLevel >= 18) 
	{	sCritter = "ps_summbaat_br3";	}
	else if (nLevel >= 12)
	{	sCritter = "ps_summbaat_br2";	}
	else
	{	sCritter = "ps_summbaat_br1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your summons. Use the Unsummon Baatezu feat to return it to the Hells.");
}

void PS_Cast_BR_VampiricTouch(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}  
    int nDDice = GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
	int nTouch      = TouchAttackMelee(oTarget, GetSpellCastItem() == OBJECT_INVALID);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDDice = nDDice * 2;	}
    int nDamage = d6(nDDice);
    int nMax = GetCurrentHitPoints(oTarget) + 10;
    if(nMax < nDamage)
    {	nDamage = nMax;	}
    effect eHeal = EffectTemporaryHitpoints(nDamage);
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && 
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))	
        {	SignalEvent(oPC, EventSpellCastAt(oPC, 1890, FALSE));
            SignalEvent(oTarget, EventSpellCastAt(oPC, 1890, TRUE));
            if (nTouch>0)
            {	if (MyResistSpell(oPC, oTarget) == 0)
        		{	nDamage += PS_AddSneakDmgToSpell(oPC, oTarget, DAMAGE_TYPE_NEGATIVE);
    				effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    				effect eVisHeal = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
				 
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oPC);
					RemoveTempHitPoints();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, oPC, HoursToSeconds(nDDice));
}	}	}	}	}

void PS_Cast_BR_Beguile(object oPC, object oTarget, int nSpell, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    effect eDom 		= EffectDominated();
    	eDom = GetScaledEffect(eDom, oTarget);
    effect eVis 		= EffectVisualEffect(VFX_DUR_SPELL_DOM_PERSON);
	effect eLink 		= EffectLinkEffects(eDom, eVis);
    int nCasterLevel 	= GetLevelByClass(CLASS_TYPE_BRACHINA, oPC) * 2;
    int nDuration 		= nCasterLevel;
	int iChaBonus		= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC 			= 10 + (iLevel / 2) + iChaBonus;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	if (!MyResistSpell(OBJECT_SELF, oTarget))
    	{	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
			{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));	}
}	}	}

// Ice Para-genasi innate ability.
//PS_Cast_IG_HoarfrostArmor(object oPC, int nSpell, int iLevel)
void PS_Cast_IG_HoarfrostArmor(object oPC, int nSpell, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	// desc states 5 rounds +1 per lvl above 5, but this math is wrong. At lvl 1 This
	// is 1 round. 5 + (1 - 5) = 5 + -4 = 1;
    //int nDuration = 5 + (iLevel - 5); 
	int nDuration = 5;
	if (iLevel > 5) nDuration += iLevel - 5;
	int nDamage = (iLevel / 6) * 2;
 	effect eShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1d4, DAMAGE_TYPE_COLD);
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_CREEPING_COLD);
	effect eLink = EffectLinkEffects(eShield, eDur);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell,oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
}

void PS_Cast_SU_SummonTanarri(object oPC)
{
    int nLevel = GetTotalLevels(oPC, FALSE);
	int nBrLevel = GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC);
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if ((nLevel >= 24) && (nBrLevel == 10))
    {	sCritter = "ps_summtana_su3";	}
	else if (nLevel >= 17) 
	{	sCritter = "ps_summtana_su2";	}
	else
	{	sCritter = "ps_summtana_su1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your summons. Use the Unsummon Tanar'ri feat to return it to the Abyss.");
}

void PS_Cast_MQ_MirrorImage(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
	{	return;		}
	if ( GetHasSpellEffect(nSpell) )
	{	effect eEffect = GetFirstEffect( OBJECT_SELF );
		while ( GetIsEffectValid(eEffect) )
		{	if ( GetEffectSpellId(eEffect) == nSpell )
			{	RemoveEffect( OBJECT_SELF, eEffect );	}
			eEffect = GetNextEffect( OBJECT_SELF );		}	}

	int iDurBase = iLevel * 5;
	float fDuration = RoundsToSeconds(iDurBase);	
	int nCasterLvl = PS_GetLevel(oPC);
		nCasterLvl = nCasterLvl / 2;
	
	int nACBonus = (2 + ( nCasterLvl / 3 ));
    int nImages = d4( 1 ) + ( nCasterLvl / 3 );
	if( nImages > 8 )  
	{	nImages = 8; 	}
    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
 
	float fSpin = ( 1.5 / nImages );
	float fDelay = ( 0.0 );
	string sImg = ("sp_mirror_image_1.sef");
    int i;
    for ( i = 0; i < nImages; i++ )
    {	effect eAbsorb = EffectAbsorbDamage(nACBonus);
        effect eDur = EffectVisualEffect(876);
		effect eImg = EffectNWN2SpecialEffectFile( sImg, OBJECT_SELF );
        effect eLink = EffectLinkEffects(eAbsorb, eDur);
		eLink = EffectLinkEffects(eLink, eImg);
        effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oPC, 1827));
        eLink = EffectLinkEffects(eLink, eOnDispell);

        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration) );
		fDelay += fSpin;	}
}

void PS_Cast_SU_LilitusGift(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	if (oTarget == oPC)
	{	SendMessageToPC(oPC, "You may not confer this gift upon yourself.");
		return;	}
	if (GetLocalInt(oPC, "GiftGiven") == 1)
	{	SendMessageToPC(oPC, "This ability requires five minutes to pass between uses.");
		return;	}
    int nBonus 		= 2;
	effect eChar	= EffectAbilityIncrease(ABILITY_CHARISMA, nBonus);
	effect eSave	= EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
	effect eDR		= EffectDamageReduction(15, ALIGNMENT_LAWFUL, 200, DR_TYPE_ALIGNMENT);
	effect eLink	= EffectLinkEffects(eChar, eSave);
		eLink = EffectLinkEffects(eLink, eDR);
		eLink = ExtraordinaryEffect(eLink);
	object oRight	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object oLeft	= GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	float fDuration	= HoursToSeconds(24);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	if(GetIsObjectValid(oRight))
    {	SignalEvent(GetItemPossessor(oRight), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  		itemproperty ipChaosR = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1);
		IPSafeAddItemProperty(oRight, ipChaosR, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);	}
	if(GetIsObjectValid(oLeft))
    {	SignalEvent(GetItemPossessor(oLeft), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  		itemproperty ipChaosL = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1);
		IPSafeAddItemProperty(oLeft, ipChaosL, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);	}
	SetLocalInt(oPC, "GiftGiven", 1);
	DelayCommand(RoundsToSeconds(30), DeleteLocalInt(oPC, "GiftGiven"));
}

void PS_Cast_DR_Clairvoyance(object oTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    effect eSpot = EffectSkillIncrease(SKILL_SPOT, 10);
    effect eListen = EffectSkillIncrease(SKILL_LISTEN, 10);
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_CLAIRAUD );	// NWN2 VFX
    effect eLink = EffectLinkEffects(eSpot, eListen);
    	eLink = EffectLinkEffects(eLink, eVis);
    float fDuration = RoundsToSeconds(iLevel / 2);
    
    if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oTarget))
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	}
}

void PS_Cast_DR_DispelMagic(location lTarget, object oTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	 }
    effect eVis			= EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	effect eImpact;
    object oTarget		= GetSpellTargetObject();
    int nCasterLevel 	= iLevel / 2;

    if (GetIsObjectValid(oTarget))
    {	spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);	}
    else
    {   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {	if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {	spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);	}
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));	}
            else
            {	spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);	}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
}	}	}

void PS_Cast_DR_SummonSwarm(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    int iLevel = PS_GetLevel(oPC);
	int nDuration = iLevel / 2;
	if (nDuration < 2)
	{	nDuration == 2;	}
    effect eSummon = EffectSummonCreature("rh_swarm_drider_les");
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
	
	SetLocalInt(oPC, "swarm_summoner", 1);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}

void PS_Cast_HE_SummonTanarri(object oPC)
{
    int nLevel = GetTotalLevels(oPC, FALSE);
	int nBrLevel = GetLevelByClass(CLASS_TYPE_HEZROU, oPC);
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if ((nLevel >= 24) && (nBrLevel == 10))
    {	sCritter = "ps_summtana_he3";	}
	else if (nLevel >= 17) 
	{	sCritter = "ps_summtana_he2";	}
	else
	{	sCritter = "ps_summtana_he1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your summons. Use the Unsummon Tanar'ri feat to return it to the Abyss.");

}

void PS_Cast_HE_Blasphemy(object oPC)
{

        //Declare major variables
        object oTarget;
        int nCasterLevel = GetLevelByClass(CLASS_TYPE_HEZROU, oPC) * 2;
		
        effect eBlind = EffectNewBlindness();
        effect eStun = EffectStunned();
        effect eConfuse = EffectConfused();
        effect eDeath = EffectDeath();
        effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
		effect eVis2= EffectNWN2SpecialEffectFile ("sp_blasphemy_aoe.sef", OBJECT_SELF);
        effect eKill;
        effect eLink;
        int nHD;
        float fDelay;
        int nDuration = nCasterLevel / 2;
		
        //Get the first target in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
		
        {	
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, OBJECT_SELF);
            //Make a faction check
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL))
            {
                fDelay = GetRandomDelay(0.5, 2.0);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WORD_OF_FAITH));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //----------------------------------------------------------
                    //Check if the target is an outsider
                    //GZ: And do nothing anymore. This was not supposed to happen
                    //----------------------------------------------------------
                    /*if (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }*/

                    ///----------------------------------------------------------
                    // And this is the part where the divine power smashes the
                    // unholy summoned creature and makes it return to its homeplane
                    //----------------------------------------------------------
					// AFW-OEI 11/07/2006: Combine summoned creature check; if target has a master and was NOT summoned,
					//	the spell would do nothing, as it would fall through a gap in the logic.
                    if ( (GetIsObjectValid(GetMaster(oTarget))) &&
					     (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED) )
                    {
                        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                        else
                        {
                            eKill  = EffectDamage(GetCurrentHitPoints(oTarget)+10);
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                        }
                    }
                    else
                    {
                        //Check the HD of the creature
                        nHD = GetHitDice(oTarget);
                        //Apply the appropriate effects based on HD
                        if (nHD >= 12 && !GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS))
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration)));
                        }
                        else if (nHD >= 8 && nHD < 12)
                        {
							if (!GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS))
								eLink = EffectLinkEffects(eStun, eBlind);
							else eLink = eStun;

                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                        }
                        else if (nHD > 4 && nHD < 8)
                        {
                            eLink = EffectLinkEffects(eStun, eConfuse);
                            eLink = EffectLinkEffects(eLink, eBlind);

                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                        }
                        else
                        {
                           if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                           {
                                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                           }
                           DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
                }
            }
            //Get the next target in the spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
        }
}

// Aid (Hound Archon): (iLevel turns duration)
void PS_Cast_HA_Aid(int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    float fDuration = TurnsToSeconds(iLevel);
    int nBonus = d8(1) + iLevel;
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eHP = EffectTemporaryHitpoints(nBonus);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
    object oTarget = GetSpellTargetObject();
    if (GetHasSpellEffect(1052, oTarget))
    {	return;	}
    effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);
    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_AID));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eHP = EffectLinkEffects(eHP, eOnDispell);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}

void PS_Cast_BR_Blur(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	    }

    effect eBlur = EffectConcealment(20);
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DISPLACEMENT );
    effect eLink = EffectLinkEffects(eBlur, eVis);
    effect eStart = EffectVisualEffect(VFX_HIT_SPELL_DISPLACEMENT);

    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, SPELL_DISPLACEMENT, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eStart, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(iLevel*5));
}

void PS_Cast_BR_LightningBolt(object oPC, location lTarget, object oTarget, int iLevel)
{
    if (!X2PreSpellCastCode())
    {	return;    }

    int nDamage;
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDamage;
    object oTarget = GetSpellTargetObject();
    location lTargetO = GetLocation(oTarget);
	location lTarget = GetSpellTargetLocation();
	
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget);
	SetScriptHidden(oPoint, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {	//Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
         while (GetIsObjectValid(oTarget))
        {	//Exclude the caster from the damage effects
        	if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
        	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {	nDamage =  d6(iLevel);
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                        if(nDamage > 0)
                        {	fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));	
                        }
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);	}	}
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));	}
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
}	}

void PS_Cast_EF_CircleVsEvil(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD);

    int nDuration = iLevel + 20;

    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, RoundsToSeconds(nDuration));
}

void PS_Cast_TArchonBlast(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	object oTrump	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (oTrump == OBJECT_INVALID)
	{	SendMessageToPC(oPC, "You must have your trumpet equipped to use this ability.");
		return;	}
	string sTrump	= GetTag(oTrump);
	if (sTrump != "ps_rprc_archtrump")
	{	SendMessageToPC(oPC, "You must have your trumpet equipped to use this ability.");
		return;	}

    object oTarget;
    int nLevel = GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC);
	int nDC = (15 + nLevel);
    effect ePara = EffectParalyze(nDC, SAVING_THROW_FORT, FALSE);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	float fDelay;
	int nDuration = d4(1);
	
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
	AssignCommand(oPC, DelayCommand(1.0f, PlaySound("ps_trumpet1")));
  
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetLocation(oPC));
    while (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {	if (GetSubRace(oTarget) != 163 && GetSubRace(oTarget) != 176)
		    {	fDelay = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget))/20;
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 586));
				if (FortitudeSave(oTarget, nDC) == 0)
                {	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, RoundsToSeconds(nDuration)));
                }
			}
		}
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    }	
}

void PS_Cast_TArchonReveille(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	object oTrump	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (oTrump == OBJECT_INVALID)
	{	SendMessageToPC(oPC, "You must have your trumpet equipped to use this ability.");
		return;	}
	string sTrump	= GetTag(oTrump);
	if (sTrump != "ps_rprc_archtrump")
	{	SendMessageToPC(oPC, "You must have your trumpet equipped to use this ability.");
		return;	}
	
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
	AssignCommand(oPC, DelayCommand(1.0f, PlaySound("as_pl_horngood")));

    object oTarget;
    effect eVis		= EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eAC		= EffectACIncrease(2, AC_DEFLECTION_BONUS);
	    eAC 		= VersusAlignmentEffect(eAC,ALIGNMENT_ALL, ALIGNMENT_EVIL);
    effect eSave 	= EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    	eSave 		= VersusAlignmentEffect(eSave,ALIGNMENT_ALL, ALIGNMENT_EVIL);
    effect eImmune 	= EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    	eImmune 	= VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eAttack 	= EffectAttackIncrease(2, ATTACK_BONUS_MISC);
	effect eDamage 	= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
	effect eSpeed 	= EffectMovementSpeedIncrease(10);
	effect eLink	= EffectLinkEffects(eAC, eSave);
		eLink		= EffectLinkEffects(eLink, eImmune);
		eLink		= EffectLinkEffects(eLink, eAttack);
		eLink		= EffectLinkEffects(eLink, eDamage);
		eLink		= EffectLinkEffects(eLink, eSpeed);
    	oTarget = GetFirstObjectInArea(GetArea(oPC));
    while (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 587));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(30));
		}
		oTarget = GetNextObjectInArea(GetArea(oPC));
	}
		
}

// Helper function for PS_Cast_YTHBAnimalTrance
int CompareTranceRace(object oTarget)
{
	int nRace = GetRacialType(oTarget);	
	switch( nRace )
	{
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_MAGICAL_BEAST:
		case RACIAL_TYPE_VERMIN:
			return TRUE;
			break;
		default:
			return FALSE;
	}	
	return FALSE;
}

void PS_Cast_YTHBAnimalTrance(object oPC, int iLevel, location lTarget, int nSpell)
{
	int nTotalHD 		= d6(2); 						// total number of HD we can 'mesmerize'
	int nCurrHD 		= 0;							// how many HD we turned so far
	float fSize 		= 25.0 + (5.0 * (iLevel/2));	// how big of radius we affect
	int nDur 			= 1 * iLevel	;				// # of rounds effect lasts
	float fDuration 	= (RoundsToSeconds(nDur));
	int nInt;
	int nHD;
	effect eMes, eVFX, eLink;

	PrettyDebug("Starting Animal Trance!! Total HD: "+IntToString(nTotalHD));

	object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, fSize, lTarget);
	
	while( oTarget != OBJECT_INVALID )
	{	if ( CompareTranceRace(oTarget) )
		{	nInt 		= GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
			nHD 		= GetHitDice(oTarget);
			if ( nInt < 3 && (nCurrHD + nHD) <= nTotalHD )
			{	if (!MyResistSpell(OBJECT_SELF, oTarget))
				{	PrettyDebug("Animal Trance :: Applying Effect to "+GetName(oTarget));
					eMes 	= EffectMesmerize(MESMERIZE_BREAK_ON_ATTACKED);
					eVFX 	= EffectVisualEffect(VFX_HIT_TURN_UNDEAD);
					eLink 	= EffectLinkEffects(eVFX, eMes); 
				
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	}
				nCurrHD += nHD;	}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lTarget);
	}
}

void PS_Cast_YTHBEntangle(object oPC, location lTarget, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eAOE 			= EffectAreaOfEffect(AOE_PER_ENTANGLE, "", "", "", "AOE_ENTANGLE_RACIAL");
    int nDuration 			= 3 + (iLevel / 2);
    int nDC 				= GetSpellSaveDC();
    effect eHold 			= EffectEntangle();
    effect eEntangle 		= EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eLink 			= EffectLinkEffects(eHold, eEntangle);
	
    if (nDuration < 1)
    {	nDuration = 1;	}

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	object oTarget 			= GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget);

    while(GetIsObjectValid(oTarget))
    {	if( (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
    	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
                if(!GetHasSpellEffect(nSpell, oTarget))
                {	if(!MyResistSpell(oPC, oTarget))
                    {	if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
                        {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));	}
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 5.0, lTarget );
    }
}

void PS_Cast_YTHBNeutralizePoison(object oPC, object oTarget, int nSpell)
{
    effect eVis 	= EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect ePoison 	= GetFirstEffect(oTarget);

    SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
    while(GetIsEffectValid(ePoison))
    {	
    	if (GetEffectType(ePoison) == EFFECT_TYPE_POISON)
        {	
        	RemoveEffect(oTarget, ePoison);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        ePoison = GetNextEffect(oTarget);	
    }
}

void PS_Cast_XephBurst(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    if (GetHasSpellEffect(SPELL_HASTE, oPC) == TRUE || GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oPC) == TRUE)
    {	return ; /* does nothing if caster already has haste*/	  }
	
	int iMove;
	if (iLevel >= 16)
	{	iMove = 99;	}
	else if (iLevel >= 8)
	{	iMove = 66;	}
	else
	{	iMove = 33;	}
	
    effect eFast	= EffectMovementSpeedIncrease(iMove);
		eFast		= SupernaturalEffect(eFast);
	effect eDur		= EffectNWN2SpecialEffectFile("fx_akachi_scythe01", oPC);
    effect eLink	= EffectLinkEffects(eFast, eDur);

    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(3));
}

void PS_Cast_Hag_Sleep(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    object oTarget;
    object oLowest;
    effect eSleep =  EffectSleep();
	effect eDur = EffectVisualEffect( VFX_DUR_SLEEP );
	effect eLink = EffectLinkEffects( eSleep, eDur);
    int bContinueLoop;
    int nHD = 4 + d4();
    int nMetaMagic = GetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 9;// maximun hd creature affected
    int nLow;
    int nDuration = iLevel;
    nDuration = 3 + GetScaledDuration(nDuration, oTarget);
    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
	
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    if (GetIsObjectValid(oTarget))
    {	bContinueLoop = TRUE;	}
    while ((nHD > 0) && (bContinueLoop))
    {	nLow = nMax;
        bContinueLoop = FALSE;
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
        	{	bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {	nCurrentHD = GetHitDice(oTarget);
                    if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6)
                    {	nLow = nCurrentHD;
                        oLowest = oTarget;
                        bContinueLoop = TRUE;	}
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        }
        if(oLowest != OBJECT_INVALID)
        {	SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP)); //FIX: signal goes to oLowest, not oTarget, which is invalid
            if (!MyResistSpell(OBJECT_SELF, oLowest))
            {	if(!MySavingThrow(SAVING_THROW_WILL, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {	if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oLowest, RoundsToSeconds(nDuration));	}
                    else
                    {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));	}

                }
            }
        }
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }    while ((nHD > 0) && (bContinueLoop))
    {	nLow = nMax;
        bContinueLoop = FALSE;
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
        	{	bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {	nCurrentHD = GetHitDice(oTarget);
                     if (nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6)
                     {	nLow = nCurrentHD;
                        oLowest = oTarget;
                        bContinueLoop = TRUE;	}
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        }
        if (oLowest != OBJECT_INVALID)
        {	SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, nSpell)); //FIX: signal goes to oLowest, not oTarget, which is invalid
            if (!MyResistSpell(OBJECT_SELF, oLowest))
            {	if (!MySavingThrow(SAVING_THROW_WILL, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {	if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oLowest, RoundsToSeconds(nDuration));	}
                    else
                    {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));	}
                }
            }
        }
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}

void PS_Cast_Hag_Enfeeblement(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    object oTarget = GetSpellTargetObject();
    int nDuration = iLevel;
    int nBonus = nDuration / 2;

    if (nBonus > 5)
    {	nBonus = 5;		}
    int nLoss = d6() + nBonus;

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
		if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
		{	if (!MyResistSpell(OBJECT_SELF, oTarget))
        	{	RemoveEffectsFromSpell(oTarget, nSpell);
                effect eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);
  			    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAY_ENFEEBLE );
                effect eLink = EffectLinkEffects(eFeeb, eDur);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
			}
        }
 	    effect eRay = EffectBeam(VFX_BEAM_NECROMANCY, OBJECT_SELF, BODY_NODE_HAND);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
    }
}

void PS_Cast_MOTC_MagicMissile(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    object oTarget = GetSpellTargetObject();
    int nCasterLvl = 12;
    int nMissiles = 12;
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    float fDelay, fTime, fTime2;
	int nSpell = GetSpellId();
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTarget = GetLocation( oTarget );
    int nCnt;
	float fTravelTime;
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

	effect eMantle = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eMantle) &&
		(GetEffectSpellId(eMantle) != SPELL_LEAST_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_LESSER_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_GREATER_SPELL_MANTLE))
	{	eMantle = GetNextEffect(oTarget);}
	if (GetIsEffectValid(eMantle)) 
	{	MyResistSpell(OBJECT_SELF, oTarget, fDelay);
		for (nCnt = 1; nCnt <= nMissiles; nCnt++)
		{	fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCnt));
			DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
		}
	}
	else
	{	for (nCnt = 1; nCnt <= nMissiles; nCnt++)
		{	fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
			if ( nCnt == 0 )	fDelay = 0.0f;
			else				fDelay = GetRandomDelay( 0.1f, 0.1f ) + (0.1f * IntToFloat(nCnt));

	        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
		  	{	int nDam = d3(1) + 1;
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
			}
			DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
       	}
	}
	}
}

void PS_Cast_MOTC_Etherealness(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	float  fDuration = TurnsToSeconds(20);
 	int nTargets = 0;
	if (GetLocalInt(oPC, "DIMENSIONAL_ACHORED"))
	{	SendMessageToPC(oPC, "A Dimensional Anchor makes it impossible to become ethereal.");
		return;		}
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );	// NWN2 VFX
	effect eSanc = EffectEthereal();
	effect eLink = EffectLinkEffects(eDur, eSanc);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

int PS_GetHasSoul(object oTarget)
{
	int nRace = GetRacialType(oTarget);
	
	switch (nRace)
	{
		case 16 :	//Elemental		
		{	return FALSE;	}	
		case 20:	//Outsider
		{	return FALSE;	}
		case 29 :	//Ooze
		{	return FALSE;	}
	}
	return TRUE;
}

void PS_Cast_MOTC_SoulBind(object oPC, object oTarget, int nSpell)
{
	object oPrism = GetItemPossessedBy(oPC, "ps_misc_coinage-gsoulprism");
	if (!GetIsObjectValid(oPrism))
	{	SendMessageToPC(oPC, "You must have a soul prism in your inventory to use this ability.");
		return;	}
		
	int iTotalHP	= GetMaxHitPoints(oTarget);
	int iCurrentHP	= GetCurrentHitPoints(oTarget);
	string sName	= GetName(oTarget);
	effect eDeath	= EffectDeath(FALSE, TRUE, TRUE, TRUE);
	effect eVFX		= EffectNWN2SpecialEffectFile("fx_b_spirits_transform01");
	
	if (!GetIsObjectValid(oTarget))
	{	SendMessageToPC(oPC, "You cannot bind the soul of this target.");
		return;	}
		
	if (!PS_GetHasSoul(oTarget))
	{	SendMessageToPC(oPC, "This creature has no soul to bind.");
		return;	}
		
	if (!MyResistSpell(OBJECT_SELF, oTarget))
	{	if (iCurrentHP > iTotalHP / 10)
		{	SendMessageToPC(oPC, "Your target is not weak enough to drain the soul from.");	}
		else
		{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, TRUE));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
		SetLocalString(oPrism, "SoulBind", sName);	}
	}
}

void PS_Cast_Rakshasa_Suggestion(object oPC, object oTarget, int nSpell)
{

	if (!X2PreSpellCastCode())
    {	return;		}
	 //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eDom = EffectDominated();
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_DOM_MONSTER);
	int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nBluff = (GetSkillRank(SKILL_BLUFF, oPC, FALSE))/10;
	int nDip = (GetSkillRank(SKILL_DIPLOMACY, oPC, FALSE))/10;
	int nDC = 14 + nCha;
	if (nBluff > 0)
	{
		nDC = nDC + nBluff;
	}
	if (nDip > 0)
	{
		nDC = nDC + nDip;
	}
    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eDur, eDom);

    int nDuration = 3;
    int nRacial = GetRacialType(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    //Make sure the target is a monster
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
          //Make SR Check
          if (!MyResistSpell(OBJECT_SELF, oTarget))
          {
               //Make a Will Save
               if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    	       {
                  
                    //Apply linked effects and VFX Impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
           }
     }
}

void PS_Cast_Rakshasa_Pain_Wave(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetHitDice(oCaster);
    int nDamage;
    float fDelay;
	int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC = 18 + nCha;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_20); //Replace with Negative Pulse
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDam, eHeal;
    int nDuration = d6() + 1;
    effect eBad = EffectFrightened();

    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
       if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oCaster)
       {
            //Roll damage for each target
            nDamage = d8(2) + nCasterLvl;
			
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // * any undead should be healed, not just Friendlies
        	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
                //Set the heal effect
                eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
                
            }
			else
          	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
                if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            	    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
                        //Set the damage effect
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                        // Apply effects to the currently selected target.
					
						if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
				        {
				            nDamage /= 2;
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	                        //This visual effect is applied to the target object not the location as above.  This visual effect
	                        //represents the flame that erupts on the target not on the ground.
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				        }
						else
						{
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	                        //This visual effect is applied to the target object not the location as above.  This visual effect
	                        //represents the flame that erupts on the target not on the ground.
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(nDuration)));
						}
                    }
                }
            }
        }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    }
}

void PS_Cast_Rakshasa_Imperious_Command(object oPC, object oTarget, int nSpell)
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetSpellTargetObject();
	int 		nCasterSub  =   GetSubRace(oCaster);
	int 		nTargetSub  =   GetSubRace(oTarget);
	float		fDuration	=	RoundsToSeconds(GetHitDice(oCaster));
	int			nDurType	=	ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	// AFW-OEI 06/27/2007: Add a hit effect.
	effect		eHit		= 	EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);

	effect		eAC			=	EffectSavingThrowDecrease(SAVING_THROW_WILL, 6, SAVING_THROW_TYPE_MIND_SPELLS);
	effect 		eDur		=	EffectVisualEffect(VFX_IMP_SLEEP);
	effect		eLink		=	EffectLinkEffects(eAC, eDur);

	eLink = EffectLinkEffects(eLink, EffectCurse(0, 0, 0, 0, 0, 0));
	eLink = SupernaturalEffect(eLink);
	
//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//Target discrimination, then apply effects

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			if(!MyResistSpell(OBJECT_SELF, oTarget) && (nTargetSub != nCasterSub))
			{
    			//should not stack with itself or similar spells
    			RemoveEffectsFromSpell(oTarget, GetSpellId());

				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1035));
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			}
		}
	}
}

void PS_Cast_Rakshasa_Mystic_Palm(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	} 
	int nMonk = GetLevelByClass(CLASS_TYPE_MONK, OBJECT_SELF);
	int nAustere = GetLevelByClass(214, OBJECT_SELF);
	nMonk = nMonk + nAustere;
	int nWis = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
	int nDam;
	switch (nMonk)
		{
			case 1: case 2: case 3: 
			{
				nDam = d6(1);
			}
			case 4: case 5: case 6: case 7:
			{
				nDam = d8(1);
			}
			case 8: case 9: case 10: case 11:
			{
				nDam = d10(1);
			}
			case 12: case 13: case 14: case 15: 
			{
				nDam = d6(2);
			}
			case 16: case 17: case 18: case 19:  
			{
				nDam = d8(2);
			}
			case 20: case 21: case 22: case 23:  
			{
				nDam = d10(2);
			}
			case 24: case 25: case 26: case 27:
			{
				nDam = d8(3);
			}
			case 28: case 29: case 30:
			{
				nDam = d10(3);
			}
		} 
    nDam = nDam + nWis;
	int nTouch      = TouchAttackRanged(oTarget, TRUE, 0);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDam = nDam * 2;	}
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 424));
		if (nTouch != 0)
		{ 
	            //Set damage effect
	            effect eVis = EffectNWN2SpecialEffectFile("fx_mystic_palm.sef", oTarget);
				
				// If applicable adds any sneak damage to total to be inflicted and reports the damage.
				
				
	            effect eBad = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
	            //Apply the VFX impact and damage effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
				DecrementRemainingFeatUses(OBJECT_SELF, 39);
				
				int nHD = GetHitDice(OBJECT_SELF);
				
				int nStun = GetHasFeat(39, OBJECT_SELF, FALSE);
				int nDC = 10 + (nHD/2) + nWis;
				if (nStun == TRUE)
				{
					if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
			       	{
						effect eStun = EffectStunned();
						effect eDur = EffectVisualEffect( VFX_DUR_STUN );
						eStun = EffectLinkEffects( eStun, eDur );
			           	DelayCommand( 0.8f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(2)) );
						
			       	}
				}
	        
		}
    }
}

void PS_Cast_Khayal_Shadow_Conjuration(object oPC, int nSpell)
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetHitDice(oPC);
    effect eSummon;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 7)
    {
        eSummon = EffectSummonCreature("c_shadow",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 8) && (nCasterLevel <= 10))
    {
        eSummon = EffectSummonCreature("ps_negavatar_2",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 11) && (nCasterLevel <= 14))
    {
        eSummon = EffectSummonCreature("ps_shadow_conjuration",VFX_FNF_SUMMON_UNDEAD); // change later
    }
    else if ((nCasterLevel >= 15))
    {
        eSummon = EffectSummonCreature("ps_grshadowconj",VFX_FNF_SUMMON_UNDEAD);
    }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nCasterLevel));
}

void PS_Cast_Khayal_Shadow_Armor (object oPC, object oTarget, int nSpell)
{
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(GetHitDice(oPC));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //Check for metamagic extend
 
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


    //Set the armor bonuses
    effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eDur = EffectNWN2SpecialEffectFile("fx_shad_conjarmor.sef", oTarget);
    effect eLink = EffectLinkEffects(eAC, eDur);

    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}