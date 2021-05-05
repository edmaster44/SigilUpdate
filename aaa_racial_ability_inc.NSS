			
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "x2_inc_itemprop"
#include "nwn2_inc_spells"
#include "ps_inc_advscript"
#include "ginc_item"
#include "ps_inc_wingtail"

void PS_ApplyAstralDevaWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyMonadicWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyMovanicWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyHoundWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyExaltedWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyEladrinWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);
void PS_ApplyEvilWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration);

void PS_Ability_GiantStride(object oPC, int iLevel, int iClass, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
	int iSpeed;
	//Determine movement rate bonus granted based on PRC class level
	if (iClass = 1)
	{	if (iLevel >= 7)
		{	iSpeed = 30;	}
		else if (iLevel >= 5)
		{	iSpeed = 20;	}
		else if (iLevel >= 3)
		{	iSpeed = 10;	}
		else
		{	iSpeed = 0;		}
	}
	else if (iClass = 2)
	{	if (iLevel >= 5)
		{	iSpeed = 25;	}
		else if (iLevel >= 2)
		{	iSpeed = 10;	}
		else
		{	iSpeed = 0;		}
	}
    //Calculate and apply movement rate bonus
	if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eSpeed = EffectMovementSpeedIncrease(iSpeed);
			eSpeed = ExtraordinaryEffect(eSpeed);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oPC);
		SendMessageToPC(oPC, "Speed increased by " + IntToString(iSpeed) + "%.");	}
}

void PS_Ability_DevaAura(object oPC, int nSpell)
{
	float fDur		= RoundsToSeconds(GetTotalLevels(OBJECT_SELF, FALSE) + 20);
	if (!X2PreSpellCastCode())
    {	return;	}
	if (!GetHasSpellEffect(nSpell, OBJECT_SELF))
	{	effect eAOE 	= EffectAreaOfEffect(AOE_MOB_PROTECTION);
		effect eSpell 	= EffectSpellLevelAbsorption(3, 0);
		effect eLink 	= EffectLinkEffects(eAOE, eSpell);
		SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, 1446, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);	}
}

void PS_Ability_AstralDevaWeapon(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);
	if (GetHasSpellEffect(nSpell,oPC))	
	{
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	
	}
	
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyAstralDevaWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyAstralDevaWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_MonadicDevaWeapon(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);
	if (GetHasSpellEffect(nSpell,oPC))	
	{	
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	
	}
		
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyMonadicWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyMonadicWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_MovanicDevaWeapon(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);
	if (GetHasSpellEffect(nSpell,oPC))	
	{	
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	
	}
		
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyMovanicWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyMovanicWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}
				
void PS_Ability_DeliveranceFromDeath(object oPC)
{
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	effect eDeath 	= EffectImmunity(IMMUNITY_TYPE_DEATH);
		effect eAbil 	= EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
		effect eLink	= EffectLinkEffects(eDeath,eAbil);
			eLink = SupernaturalEffect(eLink);		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);	}	}
		
void PS_Ability_HeavenlyDeflection(object oPC)
{
    effect eShield =  EffectConcealment(30, MISS_CHANCE_TYPE_VS_RANGED);
		eShield = SupernaturalEffect(eShield);		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShield, oPC);		}
	
void PS_Ability_TroglodyteHide(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eHide = EffectSkillIncrease(SKILL_HIDE, 8);
		effect eSelf = EffectSpellImmunity(1662);
			eHide = EffectLinkEffects(eHide, eSelf);
			eHide = ExtraordinaryEffect(eHide);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHide, oPC);	}
}
	
void PS_Ability_TroglodyteStench(object oPC, int nSpell)
{
	int iLevel 		= GetTotalLevels(oPC, FALSE);
    effect eAttack	= EffectAttackDecrease(2, ATTACK_BONUS_MISC);
    effect eSave	= EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eSkill	= EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur		= EffectVisualEffect(VFX_DUR_SICKENED);
	effect eCloud	= EffectNWN2SpecialEffectFile("fx_ghast_stench");
	effect eLink	= EffectLinkEffects(eAttack, eSave);
		eLink		= EffectLinkEffects(eLink, eSkill);
		eLink		= EffectLinkEffects(eLink, eDur);
    float fDelay;
	int nDC 		= 12 + (iLevel / 3);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloud, oPC, 10.0f);
    while(GetIsObjectValid(oTarget))
    {  	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    	{	fDelay = GetDistanceToObject(oTarget)/10;
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_GHAST_STENCH));
 			if(!MyResistSpell(oPC, oTarget, fDelay))
            {	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON) && GetSubRace(oTarget) != RACIAL_SUBTYPE_TROGLODYTE)
				{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));	}
	}	}	
	//Get next target in spell area
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));	}
}	

void PS_Ability_TrollRegeneration(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int iLevel		= GetTotalLevels(oPC, FALSE);
		int iBonus		= iLevel / 9;
			iBonus		= iBonus + 2;
		effect eRegen	= EffectRegenerate(iBonus, 6.0f);
			eRegen		= ExtraordinaryEffect(eRegen);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	}
}

void PS_Ability_BaatezuBlindsight(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	if (!GetHasSpellEffect(nSpell, oPC))
	{	object oTarget = oPC;
    	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLINDSIGHT );
    	effect eSightInvis = EffectSeeInvisible();
    	effect eSightDark = EffectUltravision();
    	effect eLink = EffectLinkEffects(eVis, eSightInvis);
    		eLink = EffectLinkEffects(eLink, eSightDark);
			eLink = ExtraordinaryEffect(eLink);
    	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_BLINDSIGHT, FALSE));
    	float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
		//RemovePermanencySpells(oTarget);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, fDuration);	}
}

void PS_Ability_AvarielMindOverBody(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int iModif = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
		int iMetam = 0;
		if (GetHasFeat(FEAT_EXTEND_SPELL, oPC))
		{	iMetam = iMetam++;	}
		if (GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
		{	iMetam = iMetam++;	}
		if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
		{	iMetam = iMetam++;	}
		if (GetHasFeat(1679, oPC)) //Persistent Spell
		{	iMetam = iMetam++;	}
		if (GetHasFeat(FEAT_QUICKEN_SPELL, oPC))
		{	iMetam = iMetam++;	}
		if (GetHasFeat(FEAT_SILENCE_SPELL, oPC))
		{	iMetam = iMetam++;	}
		if (GetHasFeat(FEAT_STILL_SPELL, oPC))
		{	iMetam = iMetam++;	}
		int iBonus = iModif + iMetam;
		effect eHP = EffectBonusHitpoints(iBonus);
			eHP = ExtraordinaryEffect(eHP);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oPC);		}
}

void PS_Ability_ChangeSelf(object oPC, int nSpell) //still tweaking w/Astral
{
	if (!X2PreSpellCastCode())
    {	return;	}
	AssignCommand(oPC, ActionStartConversation(oPC, "aaa_conv_changeself", TRUE, FALSE));
}

void PS_Ability_DarkFlight(object oPC)
{
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	int iCheck		= GetLocalInt(oItem, "DarkFlight");
	int iTemp		= GetLocalInt(oItem, "TempChange");
	if (iTemp == 1)
	{	return;	}
	int iWing;
	int iWingRace;
	{	if (GetLevelByClass(CLASS_TYPE_BRACHINA, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_RAVEN_F;		}
			else
			{	iWing = WING_TYPE_RAVEN_M;		}	}
		else if (GetLevelByClass(CLASS_TYPE_ERINYES, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_ERINYES_F;	}
			else
			{	iWing = WING_TYPE_ERINYES_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_BAT_F;	}
			else
			{	iWing = WING_TYPE_BAT_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	iWing = WING_TYPE_HEZEBEL_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	iWing = WING_TYPE_HEZEBEL_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) != 0)
		{	iWingRace = PS_Get_WingRace(oPC);
			if (GetHasFeat(2537))
			{	iWing = PS_GetWing_Fiend(oPC);	}
			if (GetHasFeat(2538))
			{	iWing = PS_GetWing_Celestial(oPC);	}
		}
		
		else //You have no class!
		{	return;		}
		PS_RestoreOriginalAppearance(oPC);
	
		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
			app.WingVariation = iWing;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
		SetLocalInt(oItem, "DarkFlight", 1);
		DelayCommand(0.1f, PS_TintFixer(oPC));
		DelayCommand(0.2f, PS_RefreshAppearance(oPC));
		DelayCommand(0.3f, PS_SaveOriginalAppearance(oPC));	}
}

void PS_Ability_RopeOfEntanglement(object oPC, object oTarget, int nSpell)
{

int iAttackerStr = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int iAttackerDex = GetAbilityModifier(ABILITY_DEXTERITY,OBJECT_SELF);
int iDefenderStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
int iDefenderDex = GetAbilityModifier(ABILITY_DEXTERITY,oTarget);

int iAttackerCheck = iAttackerStr > iAttackerDex ? iAttackerStr : iAttackerDex;
int iDefenderCheck = iDefenderStr > iDefenderDex ? iDefenderStr : iDefenderDex;

 int SizeCheck = 0;
    
    if (GetCreatureSize(oTarget) == CREATURE_SIZE_LARGE)
    {    SizeCheck = SizeCheck + 4;    }
    if (GetCreatureSize(oTarget) == CREATURE_SIZE_HUGE)
    {    SizeCheck = SizeCheck + 8;    }

   				int iATotal = d10(1) + iAttackerCheck;
                int iDTotal = d10(1) + iDefenderCheck + SizeCheck;
                int nDur    = 4;
                SendMessageToPC(GetFirstPC(), "iATotal: " + IntToString(iATotal) + ", iDTotal: " + IntToString(iDTotal)); // HERE YOU LOG BOTH ROLLS
                if (iATotal > iDTotal)
                { 
                    SendMessageToPC(GetFirstPC(), "SUCCESS!"); // here you log success
                    effect eRoped    = EffectEntangle();
                    effect eVis        = EffectVisualEffect(VFX_DUR_PARALYZED);
                    effect eHidePen = EffectSkillDecrease(5, 100);
                    effect eMovePen = EffectSkillDecrease(8, 100);
                    effect eLink    = EffectLinkEffects(eRoped, eVis);
                     eLink    = EffectLinkEffects(eLink, eHidePen);
                     eLink    = EffectLinkEffects(eLink, eMovePen);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
                    SpeakString(GetFirstName(oPC) + " flings their rope at " + GetFirstName(oTarget) + " and entangles them!");    }    
                    
                else 
                {   effect eFail = EffectMovementSpeedDecrease (50);
                    SendMessageToPC(GetFirstPC(), "FAILURE!"); // here you log failure
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFail, oTarget, RoundsToSeconds(2));
                    SpeakString(GetFirstName(oTarget) + " broke free of the attempted ensnarement!"); }
        
    effect eRay = EffectBeam(VFX_BEAM_ABJURATION, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}  



void PS_Ability_ErinyesDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iLevel 		= GetLevelByClass(CLASS_TYPE_ERINYES, oPC);
	int iDR 		= 5;
	effect eDR		= EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
		eDR		= ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good applied.");
}

void PS_Ability_BrachinaRegeneration(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int iLevel		= GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
		int iBonus;
		if (iLevel >= 10)
		{	iBonus = 3;	}
		else if (iLevel >= 5)
		{	iBonus = 2;	}
		else
		{	iBonus = 1;	}
		effect eRegen	= EffectRegenerate(iBonus, 6.0f);
			eRegen		= ExtraordinaryEffect(eRegen);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	}

}

void PS_Ability_BrachinaDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iLevel 		= GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
	int iDR 		= 10;
	effect eSilver	= EffectDamageReduction(iDR, DR_TYPE_GMATERIAL, 0, GMATERIAL_METAL_ALCHEMICAL_SILVER); 
	effect eGood	= EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
		eGood		= EffectLinkEffects(eGood, eSilver);

	if (iLevel >= 10)		
	{	eGood = ExtraordinaryEffect(eGood);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oPC);
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good and " + IntToString(iDR) + "/silver applied.");	}
	else
	{	eSilver = ExtraordinaryEffect(eSilver);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSilver, oPC);
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/silver applied.");	}
}

void PS_Ability_SuccubusDrainingKiss(object oPC, object oTarget, int nSpell)
{
	int iLevel 		= GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC);
	int iLevels		= GetTotalLevels(oPC, FALSE);
	int iTouch		= TouchAttackMelee(oTarget, TRUE);
	int iDrain		= 1;
	
	if (GetHasFeat(2832))
	{	iDrain = 2;	}
	
	int iChaMod		= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int iSave		= 10 + (iLevels / 2) + iChaMod;
	int iDur		= iLevel * 2;
	float fDur		= RoundsToSeconds(iDur);
	effect eDrain 	= EffectNegativeLevel(iDrain);
	effect eDom 	= EffectDominated();
	effect eVis1	= EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eVis2	= EffectVisualEffect(VFX_IMP_DOMINATE_S);
		eDrain = EffectLinkEffects(eDrain, eVis1);
		eDom = EffectLinkEffects(eDom, eVis2);
		
    if (iTouch > 0)
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);	
		if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iSave, SAVING_THROW_TYPE_MIND_SPELLS) && AmIAHumanoid(oTarget) == TRUE)
		{	DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oTarget, fDur));	}
}	}

void PS_Ability_SuccubusDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iDR 		= 10;
	effect eDR		= EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
		eDR		= ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good applied.");
}

void PS_Ability_UnholyApothesis(object oPC)
{
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	int iWing;
	if (GetGender(oPC) == GENDER_FEMALE)
	{	iWing = WING_TYPE_LILITU_F;		}
	else
	{	iWing = WING_TYPE_LILITU_M;		}
	PS_RestoreOriginalAppearance(oPC);
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = iWing;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "UnholyApothesis", 1);
	DeleteLocalInt(oItem, "DarkFlight");
	PS_RefreshAppearance(oPC);
	FeatAdd(oPC, FEAT_LILITUS_GIFT, FALSE, TRUE, FALSE);
	FeatRemove(oPC, FEAT_DARK_FLIGHT);
	DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));
}


void PS_Ability_MarqCambAlternateForm(object oPC, int nSpell) //also to be tweaked
{
	if (!X2PreSpellCastCode())
    {	return;	}
	AssignCommand(oPC, ActionStartConversation(oPC, "aaa_conv_mq_altform", TRUE, FALSE));
}

void PS_Ability_MarqCambAlignedStrike(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);	
	if (GetHasSpellEffect(nSpell,oPC))	
	{	
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	
	}
	
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyEvilWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyEvilWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}


void PS_Ability_DriderAffinities(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eHide = EffectSkillIncrease(SKILL_HIDE, 4);
		effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
		effect eAff = EffectLinkEffects(eHide, eMove);
			eAff = ExtraordinaryEffect(eAff);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAff, oPC);	}
}

void PS_Ability_HezrouStench(object oPC, int nSpell)       
{	
	//Declare and apply the Hezrou AOE. Its number is 72 and modified by ps_srr_stenchent
	float fDur = RoundsToSeconds(GetTotalLevels(OBJECT_SELF, TRUE));
	
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect( 72 ));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDur );	
}

void PS_Ability_HezrouAlignedStrike(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);	
	if (GetHasSpellEffect(nSpell,oPC))	
	{	
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	
	}
	
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyEvilWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyEvilWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_FamiliarRegeneration(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int iLevel		= GetTotalLevels(oPC, FALSE);
		int iBonus		= iLevel / 15;
			iBonus		= iBonus + 1;
		effect eRegen	= EffectRegenerate(iBonus, 6.0f);
			eRegen		= ExtraordinaryEffect(eRegen);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	}		
}

void PS_Ability_FamiliarDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iDR 		= 5;
	effect eDR		= EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
		eDR		= ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good applied.");
}

void PS_FamiliarForm_Bat(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(171);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = ExtraordinaryEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_BAT);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);

	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
		if (nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 1880);
		SetLocalInt(oItem, "TempChange", 0);
	}	
		
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_FamiliarForm_Cat(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_CAT);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = ExtraordinaryEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_CAT);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	

	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
		if (nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 1880);
		SetLocalInt(oItem, "TempChange", 0);
	}	
		
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_FamiliarForm_Rat(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_RAT);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = ExtraordinaryEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_RAT);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	

	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
		if (nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 1880);
		SetLocalInt(oItem, "TempChange", 0);
	}	
		
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_FamiliarForm_Spider(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_SMALL_SPIDER);
	effect eScale =	EffectSetScale (0.15f, 0.15f, 0.15f);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = EffectLinkEffects (ePoly, eScale);
		ePoly = ExtraordinaryEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_SMALL_SPIDER);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	

	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
		if (nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 1880);
		SetLocalInt(oItem, "TempChange", 0);
	}	
		
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_FamiliarForm_Weasel(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_WEASEL);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = ExtraordinaryEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_WEASEL);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	

	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nTemp		= GetLocalInt(oItem, "TempChange");
		
		if (nTemp == 1) 	
	{	PS_RestoreOriginalAppearance(oPC);
		PS_RefreshAppearance(oPC);
		RemoveEffectsFromSpell(oPC, 1880);
		SetLocalInt(oItem, "TempChange", 0);
	}	
		
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_Ability_CanineForm(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	effect eVis 	= EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect eDog	= EffectPolymorph(50, FALSE, TRUE);
		eDog 		= ExtraordinaryEffect(eDog);
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDog, oPC, HoursToSeconds(24));
}

void PS_Ability_CanineForm2(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	effect eVis 	= EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect eDog	= EffectPolymorph(52, FALSE, TRUE);
		eDog 		= ExtraordinaryEffect(eDog);
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDog, oPC, HoursToSeconds(24));
}

void PS_Ability_HoundDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iDR;
	if (GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC) != 0)
	{	int iLevel 		= GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC);
		iDR = 5;
		if (iLevel >= 5)
		{	iDR = 10;	}	}
	if (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC) != 0)
	{	int iLevel		= GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC);
		if (iLevel >= 10)
		{	iDR = 10;	}
		else if (iLevel >= 4)
		{	iDR = 5;	}	}
	if (GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC) != 0)
	{	int iLevel		= GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
		if (iLevel >= 8)
		{	iDR = 10;	}
		else if (iLevel >= 4)
		{	iDR = 5;	}	}

	effect eDR		= EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_EVIL);
		eDR		= ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/evil applied.");
}

void PS_Ability_HoundWeapon(object oPC, int nSpell)
{	
	float fDuration = RoundsToSeconds(50);
	if (GetHasSpellEffect(nSpell,oPC))	
	{
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;
	}
		
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyHoundWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyHoundWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_ArchonAura(object oPC, int nSpell)
{
	float fDur		= RoundsToSeconds(GetTotalLevels(OBJECT_SELF, FALSE) + 20);
	if (!X2PreSpellCastCode())
    {	return;	}
	if (!GetHasSpellEffect(nSpell, OBJECT_SELF))
	{	effect eAOE 	= EffectAreaOfEffect(VFX_MOB_ARCHON_MENACE);
		effect eHoly	= EffectVisualEffect(VFX_HIT_AOE_HOLY);
		SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, 582, FALSE));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oPC);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDur);	}
}

void PS_Ability_EladrinForm(object oPC)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	int iForm;
	if (GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC) != 0)
	{	iForm	 	= 86;	}
	else if (GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC) != 0)
	{	iForm		= 87;	}
	else if (GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC) != 0)
	{	iForm		= 88;	}
	else
	{	iForm		= 85;	}
	effect eVis 	= EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly	= EffectPolymorph(iForm, FALSE, TRUE);
		ePoly 		= ExtraordinaryEffect(ePoly);
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
}

void PS_Ability_BralaniWhirlBlast(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
	
	if (!GetHasSpellEffect(1246, OBJECT_SELF))
	{	return;	}
		
    int nLevel = GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC);
	int nDice = 1;
	int nDamage = 0;
	if (nLevel >= 6)
		nDice = 4;
	else if (nLevel >= 4)
		nDice = 3;
	else if (nLevel >= 2)
		nDice = 2;
		
	if (TouchAttackRanged(oTarget) == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDice = nDice*2;	}
	
	nDamage = d6(nDice);	
	if (TouchAttackRanged(oTarget) != FALSE)
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			{	// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_BLUDGEONING);
			
			int nSaveDC = 15 + nLevel + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
			int nSave = ReflexSave( oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oPC );
			
			if ( nSave != 0 ) // Saving Throw success
            {	nDamage = nDamage / 2; }
				
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
			effect eVis = EffectNWN2SpecialEffectFile("fx_air_elemental_atk1", oTarget);
		    effect eLink = EffectLinkEffects(eDam, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);		}
		}
	}
}

void PS_Ability_EladrinDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iLevel;
	int iClass;
	if (GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC) != 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC);
		iClass = CLASS_TYPE_BRALANI_PRC;	}
	if (GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC) != 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC);
		iClass = CLASS_TYPE_FIRRE_PRC;	}
	if (GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC) != 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC);
		iClass = CLASS_TYPE_GHAELE_PRC;	}
	
	int iDR;

	if (iClass = CLASS_TYPE_BRALANI_PRC && iLevel >= 6)
	{	iDR = 10;	}
	else if (iClass = CLASS_TYPE_FIRRE_PRC && iLevel >= 8)
	{	iDR = 10;	}
	else if (iClass = CLASS_TYPE_GHAELE_PRC && iLevel >= 9)
	{	iDR = 10;	}
	else if (iClass = CLASS_TYPE_BRALANI_PRC && iLevel >= 2)
	{	iDR = 5;	}
	else if (iClass = CLASS_TYPE_FIRRE_PRC && iLevel >= 3)
	{	iDR = 5;	}
	else if (iClass = CLASS_TYPE_GHAELE_PRC && iLevel >= 4)
	{	iDR = 5;	}
	else 
	{	iDR = 0;	}
	
	effect eDRevil	= 	EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_EVIL);
	effect eDRiron	= 	EffectDamageReduction(iDR, DR_TYPE_GMATERIAL, 0, GMATERIAL_METAL_COLD_IRON);
	effect eDR	= 	EffectLinkEffects(eDRevil, eDRiron);
		eDR		= ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
	SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/evil or cold iron applied.");
}

void PS_Ability_EladrinTransStrike(object oPC, int nSpell)
{
	float fDuration = RoundsToSeconds(50);	
	if (GetHasSpellEffect(nSpell,oPC))	
	{
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;
	}
		
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyEladrinWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyEladrinWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_FirreFlamingSlam(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
		
    if (!GetHasSpellEffect(1246, OBJECT_SELF))
	{	return;	}
		
 	int nLevel = GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC);
	int nFire = 1;
	int nBlud = 0;
	int nDamageF = 0;
	int nDamageB = 0;
	//Calculate dice of fire damage
	if (nLevel >= 7)
		nFire = 4;
	else if (nLevel >= 5)
		nFire = 3;
	else if (nLevel >= 3)
		nFire = 2;
	//Calculate dice of bludgeoning damage
	if (nLevel >= 8)
		nBlud = 4;
	else if (nLevel >= 6)
		nBlud = 3;
	else if (nLevel >= 4)
		nBlud = 2;
	else if (nLevel >= 2)
		nBlud = 1;
		
	if (TouchAttackMelee(oTarget) == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nFire = nFire * 2;
		nBlud = nBlud * 2;	}
	
	nDamageF = d4(nFire);
	nDamageB = d4(nBlud);
	if (TouchAttackMelee(oTarget) != FALSE)
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			{	// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamageB += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_BLUDGEONING);
			
			int nSaveDC = 15 + nLevel + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
			int nSave = ReflexSave(oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE, oPC);
			
			if ( nSave == 2 ) // Immunity
			{	return;	}
			if ( nSave != 0 ) // Saving Throw success
            {	nDamageF = nDamageF / 2; }
							
			effect eFire = EffectDamage(nDamageF, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
			effect eBlud = EffectDamage(nDamageB, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
			effect eDur = EffectVisualEffect(VFX_DUR_FIRE);
		    effect eLink = EffectLinkEffects(eFire, eBlud);
				eLink = EffectLinkEffects(eLink, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0);		}
}	}	}

void PS_Ability_GhaeleLightRay(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
		
    if (!GetHasSpellEffect(1246, OBJECT_SELF))
	{	return;	}
		
 	int nLevel = GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC);
	int nDice = 1;
	int nDamage = 0;
	effect eBeam    = EffectBeam( VFX_BEAM_DIVINATION, oPC, BODY_NODE_CHEST );

	if (nLevel >= 10)
		nDice = 5;
	else if (nLevel >= 7)
		nDice = 4;
	else if (nLevel >= 5)
		nDice = 3;
	else if (nLevel >= 3)
		nDice = 2;
		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDice = nDice  *2;	}
	
	nDamage = d6(nDice);	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_PIERCING);
				
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
		    effect eLink = EffectLinkEffects(eDam, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);		}
	}
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.9 );
}

void PS_Ability_GhaeleBonusDomain(object oPC)
{
	if(GetHasFeat(1834) || GetHasFeat(1835) || GetHasFeat(2094) || GetHasFeat(1841) || GetHasFeat(1845) )
	{	return;		}
	
	AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_ghaele_bd", TRUE, FALSE, TRUE, TRUE));
}

void PS_Ability_GhaeleAura(object oPC, int nSpell)
{
	float fDur		= RoundsToSeconds(GetTotalLevels(OBJECT_SELF, FALSE) + 20);
	if (!X2PreSpellCastCode())
    {	return;	}
	if (!GetHasSpellEffect(nSpell, OBJECT_SELF))
	{	effect eAOE 	= EffectAreaOfEffect(AOE_MOB_PROTECTION);
		effect eSpell 	= EffectSpellLevelAbsorption(3, 0);
		effect eLink 	= EffectLinkEffects(eAOE, eSpell);
		SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, 1446, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);	}
}

void PS_Ability_GhaeleGlow(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
	if (!GetHasSpellEffect(nSpell, OBJECT_SELF))
	{	effect eGlow	= EffectVisualEffect(VFX_DUR_LIGHT_WHITE_5);
			eGlow = ExtraordinaryEffect(eGlow);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGlow, oPC);	}
}

void PS_Ability_TArchonTrumpet(object oPC)
{
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	int iCheck		= GetLocalInt(oItem, "HasTrumpet");
	
	if (!X2PreSpellCastCode())
	{	return;	}
	if (iCheck != 1)
	{	CreateItemOnObject("ps_rprc_archtrump", oPC);
		DelayCommand(0.2, SetLocalInt(oItem, "HasTrumpet", 1));
	}
}

void PS_Ability_TArchonBlade(object oPC)
{
	object oTrump	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oSword	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	int nLevel = GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC);
	string sBlade;
	if (nLevel >= 9)
	{	sBlade = "ps_rprc_arcblade5";	}
	else if (nLevel >= 7)
	{	sBlade = "ps_rprc_arcblade4";	}
	else if (nLevel >= 5)
	{	sBlade = "ps_rprc_arcblade3";	}
	else if (nLevel >= 3)
	{	sBlade = "ps_rprc_arcblade2";	}
	else
	{	sBlade = "ps_rprc_arcblade1";	}
	
	string sTrump	= GetTag(oTrump);
	string sSword	= GetTag(oSword);
	
	if (sTrump == "ps_rprc_archtrump")
	{	DestroyItemInSlot(oPC, INVENTORY_SLOT_RIGHTHAND);
		EquipNewItem(oPC, sBlade, INVENTORY_SLOT_RIGHTHAND, TRUE);
		DelayCommand(0.1f, ActionEquipItem(GetItemPossessedBy(oPC, sBlade), INVENTORY_SLOT_RIGHTHAND));
		SendMessageToPC(oPC, "Your trumpet has transformed into a magical greatsword.");	}
	else if (GetStringLeft(sSword, 16) == "ps_rprc_arcblade")
	{	DestroyItemInSlot(oPC, INVENTORY_SLOT_RIGHTHAND);
		EquipNewItem(oPC, "ps_rprc_archtrump", INVENTORY_SLOT_RIGHTHAND, TRUE);
		SendMessageToPC(oPC, "Your blade has transformed back into its original trumpet form.");	}
	else
	{	SendMessageToPC(oPC, "You must equip either your trumpet or your trumpet blade for this power to take effect.");	}
	
}

void PS_Ability_ExaltedWeapon(object oPC, int nSpell)
{
	float fDuration = RoundsToSeconds(30);
	if (GetHasSpellEffect(nSpell,oPC))	
	{	
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;
	}
		
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	// Apply the weapon properties to both weapons.
	if (GetIsObjectValid(oWeaponRight))
		PS_ApplyExaltedWeaponProperties(oWeaponRight, oPC, nSpell, fDuration);
	if (GetIsObjectValid(oWeaponLeft) && 
		!GetIsShield(oWeaponLeft))
		PS_ApplyExaltedWeaponProperties(oWeaponLeft, oPC, nSpell, fDuration);
}

void PS_Ability_YTHBChameleonPower(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
	{	return;		}

	if (GetHasSpellEffect(nSpell, oPC))
	{	return; 	}
	
	float fDur			= 60.0f;
	effect eVis			= EffectNWN2SpecialEffectFile("XXXXX", oPC);
	effect eHide		= EffectSkillIncrease(SKILL_HIDE, 10);
	effect eLink		= EffectLinkEffects(eVis, eHide);
		eLink			= ExtraordinaryEffect(eLink);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
}

void PS_Ability_YTHBSnakeBloodBonus(object oPC, int nSpell)
{
	effect eReflex, ePoison;

	if (GetHasSpellEffect(nSpell, oPC))
	{	return;		}
	
	if (GetHasFeat(FEAT_SNAKEBLOOD, oPC))
	{		eReflex			= EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1, SAVING_THROW_TYPE_ALL);
			ePoison			= EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_POISON);
		effect eSave		= EffectLinkEffects(eReflex, ePoison);
			eSave			= ExtraordinaryEffect(eSave);
		
		SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);	}
}

void PS_Ability_XephInnateResistance(object oPC, int nSpell)
{
	effect eBonus			= EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_SPELL);
		eBonus				= ExtraordinaryEffect(eBonus);
		
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC);
}

void PS_Ability_NHDeceitful(object oPC, int nSpell)
{
	int nBluff;
	if (GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= 10)
	{	nBluff = 4;	}
	else
	{	nBluff = 2;	}
	
	effect eBluff			= EffectSkillIncrease(SKILL_BLUFF, nBluff);
		eBluff				= ExtraordinaryEffect(eBluff);
	
	if (!GetHasSpellEffect(nSpell, oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBluff, oPC);	}
}

void PS_Ability_NHIneffablyEvil(object oPC, int nSpell)
{
	if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
	{	AdjustAlignment(oPC, ALIGNMENT_EVIL, 100);	}
	if (GetGender(oPC) != GENDER_FEMALE)
	{	SetGender(oPC, GENDER_MALE);	}
}

void PS_Ability_MOTCCraftHeartstone(object oPC, object oTarget)
{
    string sCrafter = (GetFirstName(oPC) + " " + GetLastName(oPC));
    object oTarget = GetItemPossessedBy(oPC,"ps_misc_coinage-gsoulprism");
	string sAmulet = "ps_misc_coinage-gsoulprism";

  	if (GetItemStackSize(oTarget) > 1)
    	{    SendMessageToPC(oPC, "You may only use an indivudal greater soul prism to create your heartstone.");
        	return;    }
		
	if (oTarget != OBJECT_INVALID)
	 
	 	{
 		DestroyObject(oTarget, 0.0f, TRUE);
   		object oHeartstone = CreateItemOnObject("ps_motc_heartstone", oPC);
    	SetLocalString(oHeartstone, "Creator", sCrafter);
		}

}

void PS_Ability_Austerities(object oPC)
{
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	int nWis = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
		if(GetHasFeat(3205, oPC))
		{
			effect eRes = EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nWis, SAVING_THROW_TYPE_ALL, FALSE);
			eRes = SupernaturalEffect(eRes);
			eSave = SupernaturalEffect(eSave);
			
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
		}
		if(GetHasFeat(3206, oPC))
		{
			effect eRes = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 0);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, nWis, SAVING_THROW_TYPE_ALL, FALSE);
			eRes = SupernaturalEffect(eRes);
			eSave = SupernaturalEffect(eSave);
			
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
		}
		if(GetHasFeat(3207, oPC))
		{
			effect eRes = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0);
			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nWis, SAVING_THROW_TYPE_ALL, FALSE);
			eRes = SupernaturalEffect(eRes);
			eSave = SupernaturalEffect(eSave);
			
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
		}
	}
}
		
void PS_Ability_Austerity_Truth(object oPC)
{
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{
		effect eTruth			= EffectSeeInvisible();
			eTruth				= SupernaturalEffect(eTruth);
			
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTruth, oPC);
	}
}

void PS_Ability_Rakshasa_SR(object oPC)
{
		int nHD = GetHitDice(oPC);
		int nSR = 11 + nHD;
		
		if(GetLevelByClass(213, oPC)> 7)
			nSR = 20 + nHD;
		if(GetLevelByClass(214, oPC)> 7)
			nSR = 20 + nHD;
			
		effect eSR = EffectSpellResistanceIncrease(nSR, -1);
		eSR = SupernaturalEffect(eSR);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oPC);
}

void PS_Ability_Reincarnate(object oPC)
{
 	object oItem  = GetItemPossessedBy(oPC,"ps_essence");
 	int nContingency	= GetLocalInt(oPC, "Contingency");
 	if(nContingency == 0)
   		SetLocalInt(oPC, "Contingency", 1);
}
void PS_Ability_Austere_AC(object oPC, int nSpell)
{
	if (GetHasSpellEffect(nSpell,oPC))
		RemoveSpellEffects(nSpell, oPC, oPC);

	int nAC;
	if(GetLevelByClass(214, oPC) > 3)
	{
		nAC = 1;			
		if(GetLevelByClass(214, oPC) > 8)
		{
			nAC = 2;
		}			
	}
	
	effect eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
	eAC = ExtraordinaryEffect(eAC);			 
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
}

// Elan Resilience created by SyntheticRose
void PS_Ability_ElanResilience(object oPC, int nSpell) 
{
	effect eResilience = EffectDamageReduction(2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE); //Should be DR2/-
		eResilience = ExtraordinaryEffect(eResilience);
	
	//Loop to remove pre-existing copies of Resilience's effect.
	//DR doesn't stack, but I don't want to bloat character bics with millions of copies of DR2/-.
	effect eCurrentEffect = GetFirstEffect(oPC);		//Start the loop on the first effect
	while (GetIsEffectValid(eCurrentEffect))			//Keep iterating until an invalid effect (past end of array) is reached.
	{
		if (GetEffectSpellId(eCurrentEffect) == nSpell)	//If the effect is eResilience...
		{
			RemoveEffect(oPC, eCurrentEffect);			//Remove it, then...
			eCurrentEffect = GetFirstEffect(oPC);		//Check for multiple copies of eResilience.
		}
		else eCurrentEffect = GetNextEffect(oPC);		//Otherwise, advance to next effect
    }
	
	//After all copies of eResilience have been removed, reapply it.
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResilience, oPC);
}

// Helper method to apply the Weapon Properties for
// Marquis Cambion and Hezrou's Aligned Strike.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyEvilWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
		
	itemproperty ipEff1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
	itemproperty ipClas = ItemPropertyLimitUseByClass(99);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for
// Eladrin's Transcendent Strike.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyEladrinWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectNWN2SpecialEffectFile("fx_feat_rescue_hit01", oPC);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);
		
	itemproperty ipEff1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
	itemproperty ipClasB = ItemPropertyLimitUseByClass(CLASS_TYPE_BRALANI_PRC);
	itemproperty ipClasF = ItemPropertyLimitUseByClass(CLASS_TYPE_FIRRE_PRC);
	itemproperty ipClasG = ItemPropertyLimitUseByClass(CLASS_TYPE_GHAELE_PRC);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClasB, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClasF, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClasG, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for
// Word Archon's Exalted Weapon.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyExaltedWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectNWN2SpecialEffectFile("sp_divination_hit", oPC);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
	
	itemproperty ipEff1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipGlow = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_LOW, IP_CONST_LIGHTCOLOR_WHITE);
	itemproperty ipClasT = ItemPropertyLimitUseByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC);
	itemproperty ipClasW = ItemPropertyLimitUseByClass(CLASS_TYPE_WORD_ARCHON_PRC);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClasT, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClasW, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for 
// Hound Archon's Sanctified Weapon.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyHoundWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);
	
	itemproperty ipEff1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, 
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff3 = ItemPropertyKeen();
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
	itemproperty ipClas = ItemPropertyLimitUseByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff3, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for 
// Movanic Deva's Flaming Weapon.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyMovanicWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
	
	itemproperty ipEff1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
	itemproperty ipClas = ItemPropertyLimitUseByClass(89);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for 
// Monadic Deva's Weapon of Smiting.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyMonadicWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
	
	itemproperty ipEff1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyKeen();
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
	itemproperty ipClas = ItemPropertyLimitUseByClass(88);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

// Helper method to apply the Weapon Properties for 
// Astral Deva's Angelic Weapon.
// This is called for both the left and right hands.
// Created by rapsam2003 on 7/26/2018.
void PS_ApplyAstralDevaWeaponProperties(object oWeapon, object oPC, int nSpell, float fDuration)
{
	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
	effect eCast = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
	
	itemproperty ipEff1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL,
		IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipEff2 = ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN, IP_CONST_ONHIT_SAVEDC_26, 
		IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS);
	itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
	itemproperty ipClas = ItemPropertyLimitUseByClass(87);
	
	IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}
				
	