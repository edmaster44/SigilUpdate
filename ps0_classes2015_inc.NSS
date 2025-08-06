#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "ps_adjust_knight"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"
#include "ps_inc_golem"

/*	This is the include file for the classes Demonologist, Slayer of Domiel, Celestial Envoy, Gatecrasher, 
	Golem Master, and adjusted features from Blackguard and Shadowdancer.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/
	
const int CLASS_TYPE_SLAYER_OF_DOMIEL	= 41;
const int CLASS_TYPE_DEMONOLOGIST		= 69;
const int CLASS_TYPE_GOLEM_MASTER		= 77;
const int CLASS_TYPE_CELESTIAL_ENVOY 	= 42;


void PS_Feat_SHD_ShadowDaze(object oPC, object oTarget, int nSpell)
{
    effect eMind 	= EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eDaze 	= EffectDazed(); 
    effect eLink 	= EffectLinkEffects(eMind, eDaze);
    int nMetaMagic 	= GetMetaMagicFeat();
    int nDuration 	= 5;
    int nRacial 	= GetRacialType(oTarget);

    SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
	{	if (!MyResistSpell(oPC, oTarget))
		{	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()+10, SAVING_THROW_TYPE_MIND_SPELLS))
            {	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));		}
        }
    }
}

void PS_Feat_SHD_SummonShadow(object oPC, int nSpell)
{
	int nLevel 			= GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);
    int nCharLevel 		= GetTotalLevels(oPC,0);
	object oItem		= GetItemPossessedBy(oPC,"ps_essence");
	string sLA 			= GetLocalString(oItem, "ECL");
	int nLA 			= StringToInt(sLA);
	int nEffLevel 		= (nCharLevel + nLA);

/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman.*/
	object oOldHench	= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster 	= GetLocation(oPC);	
	
    if (nLevel <= 5)
    {	sCritter = "ps_summon_sd1";		}
    else if (nLevel <= 8)
    {	sCritter = "ps_summon_sd2";		}
	else
	{	if (nEffLevel >= 25)
		{	sCritter = "ps_summon_sd4";	}
		else
		{	sCritter = "ps_summon_sd3";	}
	}
    object oHench 		= CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName 		= GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"Your beshadowed arts have bound a " + sName + " to your service. To release from service, use the Release Binding feat.");
}

void PS_Feat_SHD_ShadowEvade(object oPC, int nSpell)
{
    if (GetHasSpellEffect(nSpell,oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);		}
	
    int nLevel 		= GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
    int nConceal, nDRAmount, nAC, nMatType, nDRType;
    int nDuration 	= 3 * nLevel;

    if (nLevel <10) 
    {	switch (nLevel)
        {	case 4:
            case 5: nConceal = 30; nDRAmount = 5; nDRType = DR_TYPE_MAGICBONUS; nMatType = DAMAGE_POWER_PLUS_ONE; nAC = 1; break;
            case 6:
            case 7: nConceal = 35; nDRAmount = 5; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ALCHEMICAL_SILVER; nAC = 2; break;
            case 8:
            case 9:  nConceal = 40; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ALCHEMICAL_SILVER; nAC = 3; break;
            case 10: nConceal = 50; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ADAMANTINE; nAC = 4; break;
        }
      }
      else
	{	nConceal = 50; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ADAMANTINE; nAC = 4;	}

    effect eConceal = EffectConcealment(nConceal);
	int nLimit 		= 0;
    effect eDR 		= EffectDamageReduction(nDRAmount, nMatType, 0, nDRType);
    effect eAC 		= EffectACIncrease(nAC);
    effect eVis2 	= EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eLink 	= EffectLinkEffects(eConceal, eDR);
	    eLink 		= EffectLinkEffects(eLink, eAC);
	    eLink 		= EffectLinkEffects(eLink, eVis2);

    effect eVis 	= EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
}

void PS_Feat_BG_CreateUndead(object oPC, int nSpell)
{
    int nLevel	= GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
	int nKnight	 = KnightLevels(oPC);
	int nDK		= GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);	
    effect eSummon;
    float fDelay = 3.0;
	
	if (KnightLevels(oPC) > 1)
	{
		nLevel += KnightLevels(oPC);
	
	}
	
	if (nDK > 1)
	{
	nLevel += nDK;
	}
	
	
    if (nLevel >= 7 && nDK >= 1)
	{	eSummon = EffectSummonCreature("c_skeleton_dk", VFX_FNF_SUMMON_UNDEAD);	}
	else if (nLevel >= 7)
	{	eSummon = EffectSummonCreature("c_skeleton9",VFX_FNF_SUMMON_UNDEAD);	}
    else
	{	eSummon = EffectSummonCreature("c_skeleton7",VFX_FNF_SUMMON_UNDEAD);	}

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
    
}

void PS_Feat_BG_FiendishServant(object oPC, int nSpell)
{
	int nLevel 			= GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) ||KnightLevels(oPC);
    int nCharLevel 		= GetTotalLevels(oPC,0);
	object oItem		= GetItemPossessedBy(oPC,"ps_essence");
	string sLA 			= GetLocalString(oItem, "ECL");
	int nLA 			= StringToInt(sLA);
	int nEffLevel = (nCharLevel + nLA);
	int iAlignmentLaw = GetAlignmentLawChaos(oPC);

/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman.	*/
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if (nLevel <= 8)
    {	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        	sCritter = "ps_summon_bgfiendl1";
		else
        	sCritter = "ps_summon_bgfiendc1";	}
	else
	{	if (nEffLevel >= 25)
		{	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        		sCritter = "ps_summon_bgfiendl3";
			else
        		sCritter = "ps_summon_bgfiendc3";	}
		else
		{	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        		sCritter = "ps_summon_bgfiendl2";
			else
        		sCritter = "ps_summon_bgfiendc2";	}
	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"Your dark arts have bound a " + sName + " to your service. To release from service, use the Release Fiend feat.");
}

void PS_Feat_SHD_ShadowJump(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {    return;        }

    SendMessageToPC(oPC, "Casting Shadow Jump");
    AssignCommand(oPC, ClearAllActions());
    location lCaster = GetLocation(oPC);
    effect eVis = EffectNWN2SpecialEffectFile("fx_kos_teleport_small.sef");
    effect eVis2 = EffectNWN2SpecialEffectFile("fx_shadowjump.sef");
    effect eConceal = EffectConcealment(80);

    if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
    if (GetLocalInt(oPC, "DIMENSIONAL_ACHORED"))
    {    SendMessageToPC(oPC, "A Dimensional Anchor makes it impossible to teleport.");
        return;        }
    AssignCommand(oPC, ActionJumpToLocation(lTarget));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, RoundsToSeconds(6));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,  eConceal, oPC, 6.0f);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
}


void PS_Feat_GC_DODGE_AC(object oPC, int nSpell){

	int nGC = GetLevelByClass(63, oPC); // gatecrasher
	PS_RemoveEffects(oPC, nSpell);
	
	if (nGC < 3) return; //this feat isn't granted till lvl 3
	
	// Add Dodge AC for each level of gatecrasher beyond the 2nd, 
	// and an additional +1 if base int or wis score >= 13
	int nGatecrasherAC = nGC - 2;
	if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 13 ||
		GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 13)
			nGatecrasherAC += 1;
	if (nGatecrasherAC < 1) return;
	
	// Will not stack with Duelist or Invis Blade (which ofc only work in no armor).
	// if they have duelist or ib and no armor, they get the highest of the 3 ac.
	// If they have Duelist and a shield equipped, that removes duelist ac so they
	// get the Gatecrasher ac. Invis blade ac works with a shield.
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	if (GetArmorRank(oArmor) == ARMOR_RANK_NONE || oArmor == OBJECT_INVALID){
		int nDuelist = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
		int nIB = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oPC);
		if (nDuelist > 0 || nIB > 0){
			if (nDuelist > 0){
				int nOffHand = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
				if (nOffHand == BASE_ITEM_SMALLSHIELD || nOffHand == BASE_ITEM_LARGESHIELD ||
									nOffHand == BASE_ITEM_TOWERSHIELD)
					nDuelist = 0;
			}
			int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
			int nOtherAC = nIB;
			if (nDuelist > nOtherAC) nOtherAC = nDuelist;
			if (nOtherAC > nInt) nOtherAC = nInt;
			if (nOtherAC >= nGatecrasherAC) return; // no GC AC for you!
			else nGatecrasherAC -= nOtherAC;	
		}
	}

	if (nGatecrasherAC > 0){
		effect eAC = EffectACIncrease(nGatecrasherAC);
		eAC = SupernaturalEffect(eAC);
		eAC = SetEffectSpellId(eAC, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
	}
}

void PS_Feat_GC_FindPortal(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLevel 		= GetLevelByClass(63,oPC);
    int nDuration 			= nCasterLevel;
	int nSearch 			= GetSkillRank(SKILL_SEARCH, oPC, FALSE);
	int nInt 				= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC); 
	int nRoll				= (d20() + (nSearch));
	float fDuration 		= IntToFloat((nDuration * 3) + nInt);
	float fDelay 			= fDuration;
	object oPortal;
	object oArea 			= GetArea(oPC);
    
    effect eDestroy = EffectDeath();
	
	//Don't work in the OOC room
	if (GetTag(oArea) == "spawnroom") {
		SendMessageToPC(OBJECT_SELF, "You were not able to locate a portal in this area.");
		return;	
	}
    
    if (nRoll >= 35) {	
		object oPortal = CreateObject(OBJECT_TYPE_CREATURE, "scod_s_unstableportal", GetSpellTargetLocation(), TRUE);
		DelayCommand(fDelay, DestroyObject(oPortal));
		SendMessageToPC(oPC, "You were able to locate and open a dormant, but highly unstable portal for a short time.");	
	} else {	
		SendMessageToPC(OBJECT_SELF, "You were not able to locate a portal in this area.");
		return;	
	}
    
	DelayCommand(fDelay, SetPlotFlag(oPortal, FALSE));
	DelayCommand(fDelay+0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDestroy, oPortal)); 
}
	
void PS_Feat_DMN_BinderOfFiends(object oPC, int nSpell)
{
	int nLevel 				= GetLevelByClass(69, oPC);
    int nCharLevel 			= GetTotalLevels(oPC, 0);
	object oItem			= GetItemPossessedBy(oPC, "ps_essence");
	string sLA 				= GetLocalString(oItem, "ECL");
	int nLA 				= StringToInt(sLA);
	int nEffLevel 			= (nCharLevel + nLA);
	int iAlignmentLaw	 	= GetAlignmentLawChaos(oPC);

/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman.
*/
	object oOldHench		= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster 		= GetLocation(oPC);	
	
    if (nLevel <= 5)
    {	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        	sCritter 		= "ps_summon_dmfiendl1";
		else
        	sCritter 		= "ps_summon_dmfiendc1";	}
    else if (nLevel <= 8)
    {	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        	sCritter 		= "ps_summon_dmfiendl2";
		else
        	sCritter 		= "ps_summon_dmfiendc2";	}
	else
	{	if (nEffLevel >= 25)
		{	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        		sCritter 	= "ps_summon_dmfiendl4";
			else
        		sCritter 	= "ps_summon_dmfiendc4";	}
		else
		{	if (iAlignmentLaw == ALIGNMENT_LAWFUL)
        		sCritter 	= "ps_summon_dmfiendl3";
			else
        		sCritter 	= "ps_summon_dmfiendc3";	}
	}
    object oHench 			= CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName 			= GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"Your dark arts have bound a " + sName + " to your service. To release from service, use the Unbind Fiend feat.");
}

void PS_Feat_DMN_FiendishMantle(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eElec 	= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0);
		effect eFire 	= EffectDamageResistance(DAMAGE_TYPE_FIRE,10,0);
		effect eCold 	= EffectDamageResistance(DAMAGE_TYPE_COLD,10,0);
		effect eAcid 	= EffectDamageResistance(DAMAGE_TYPE_ACID,10,0);
		effect eLink 	= EffectLinkEffects(eElec, eFire);
			eLink 		= EffectLinkEffects(eLink, eCold);
			eLink 		= EffectLinkEffects(eLink, eAcid);
			eLink 		= SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);	}	
}

void PS_Feat_DMN_FortificationVsFiends(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eACBonus 	= EffectACIncrease(2,AC_DODGE_BONUS,AC_VS_DAMAGE_TYPE_ALL);
		effect eACvsBonus 	= VersusRacialTypeEffect(eACBonus,RACIAL_TYPE_OUTSIDER);
		
		effect eSvBonus 	= EffectSavingThrowIncrease(2,SAVING_THROW_TYPE_SPELL);
		effect eSvvsBonus 	= VersusRacialTypeEffect(eSvBonus,RACIAL_TYPE_OUTSIDER);

		effect eLink 		= EffectLinkEffects(eACvsBonus,eSvvsBonus);
			eLink 			= SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);	}	
}

void PS_Feat_DMN_ReleaseBinding(object oPC, int nSpell)
{
	object oHench = GetHenchman(oPC);
	string sName = GetName(oHench);
	
	RemoveHenchman(oPC, oHench); //Added 3/5/2016
	DestroyObject(oHench);
	SendMessageToPC(oPC,"The " + sName + " has been released from your service.");

}

void PS_Feat_SOD_DeathTouch(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nMetaMagic 		= GetMetaMagicFeat();
    int nCasterLevel 	= GetLevelByClass(41, oPC);
	int nTouch      	= TouchAttackMelee(oTarget, GetSpellCastItem() == OBJECT_INVALID);
	
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nCasterLevel = nCasterLevel * 2;	}
    int nDamage = d6(nCasterLevel);  // JLR - OEI 07/19/05
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) &&
        	GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, TRUE));
			if (nTouch>0)
            {	if(MyResistSpell(OBJECT_SELF, oTarget) == 0)
        		{	effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
    				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
				 	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);	}
            }
        }
    }
}

// Only for use in PS_Feat_SOD_BlessWeapon
void PS_AddBlessEffectToWeapon(object oTarget, float fDuration)
{
   IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonusVsAlign(ALIGNMENT_EVIL, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
   IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
   return;
}

void PS_Feat_SOD_BlessWeapon(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eVis 		= EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );	// NWN2 VFX
    object oTarget 		= GetSpellTargetObject();
    int nDuration		= GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, oPC);
    
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {	if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {	SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(oPC, nSpell, FALSE));
			IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oTarget), RoundsToSeconds(nDuration));
			return;		}
    }
 
   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
   if(GetIsObjectValid(oMyWeapon) )
   {	SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
        if (nDuration > 0)
        {	PS_AddBlessEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
        }
        return;
    }
        else
    {		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    		return;		}
}

void PS_Feat_SOD_DeathWard(object oPC, object oTarget, int nSpell)
{

    if (!X2PreSpellCastCode())
    {	return;		}

    effect eDeath 		= EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eNeg 		= EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eLevel 		= EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eAbil 		= EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	effect eDur 		= EffectVisualEffect( VFX_DUR_SPELL_DEATH_WARD );	// NWN2 VFX
    effect eLink 		= EffectLinkEffects(eDeath, eDur);
    	eLink 			= EffectLinkEffects(eLink, eNeg);
    	eLink 			= EffectLinkEffects(eLink, eLevel);
   		eLink 			= EffectLinkEffects(eLink, eAbil);
	int nDuration 		= GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL);
    float fDuration 	= HoursToSeconds(nDuration);

    SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}

void PS_Feat_CE_HolyAura(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    if (!GetHasSpellEffect(nSpell, oPC))
	{   effect eAOE 	= EffectAreaOfEffect(AOE_MOB_CIRCGOOD);
    	int nDuration 	= GetCasterLevel(oPC);

    	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
	}
}

void PS_Feat_CE_GreaterHolyAura(object oPC, int nSpell)
{
	float fDur 			= RoundsToSeconds(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY)) *10;
    
	if (!X2PreSpellCastCode())
    {	return;		}
	
    if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eAOE 	= EffectAreaOfEffect(AOE_MOB_PROTECTION);
		SignalEvent(oPC, EventSpellCastAt(oPC, 1627, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDur);
	}
}

void PS_Feat_CE_InspiredCalling(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);;
    effect eAttack 		= EffectAttackIncrease(2);
    effect eSave 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
    effect eDur 		= EffectVisualEffect( VFX_DUR_SPELL_BLESS );
    effect eLink 		= EffectLinkEffects(eAttack, eSave);
    	eLink 			= EffectLinkEffects(eLink, eDur);
    effect eOnDispell 	= EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, nSpell));
	    eLink 			= EffectLinkEffects(eLink, eOnDispell);
	float fDuration = RoundsToSeconds(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY, oPC) *10);
	
	while (GetIsObjectValid(oTarget))
	{	if (GetHasSpellEffect(1628, oTarget))
		{	effect eEffect = GetFirstEffect( oTarget );
			while ( GetIsEffectValid(eEffect) )
			{	if ( GetEffectSpellId(eEffect) == 857 )
				{	RemoveEffect( oTarget, eEffect );	}
				eEffect = GetNextEffect( oTarget );		}
	}
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
		{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
			{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Feat_CE_HeroicValor(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);;
	effect eAttack 		= EffectAttackIncrease(4);
    effect eSave 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
	effect eSkill 		= EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
	effect eHP 			= EffectTemporaryHitpoints(25);
	effect eFear 		= EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eDur 		= EffectVisualEffect( VFX_DUR_SPELL_BLESS );
    effect eLink 		= EffectLinkEffects(eAttack, eSave);
    	eLink 			= EffectLinkEffects(eLink, eSkill);
		eLink 			= EffectLinkEffects(eLink, eHP);
		eLink 			= EffectLinkEffects(eLink, eFear);
		eLink 			= EffectLinkEffects(eLink, eDur);
    effect eOnDispell 	= EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, nSpell));
	    eLink 			= EffectLinkEffects(eLink, eOnDispell);
	float fDuration 	= RoundsToSeconds(50);
	
	while (GetIsObjectValid(oTarget))
	{	if (GetHasSpellEffect(1630, oTarget))
		{	effect eEffect = GetFirstEffect( oTarget );
			while ( GetIsEffectValid(eEffect) )
			{	if ( GetEffectSpellId(eEffect) == nSpell )
				{	RemoveEffect( oTarget, eEffect );	}
				eEffect = GetNextEffect( oTarget );		}
		}
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1630, FALSE));
			{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Feat_CE_HallowedWeapon(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {   return;	    }

	float fDuration 		= RoundsToSeconds(14);	// Always lasts 14 rounds.
	object oWeapon 			= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetIsObjectValid(oWeapon))
	{	int nItemType = GetBaseItemType(oWeapon);
		if (! ((nItemType == BASE_ITEM_SHORTSWORD) ||
			   (nItemType == BASE_ITEM_LONGSWORD) ||
			   (nItemType == BASE_ITEM_BASTARDSWORD)) )
		{	oWeapon = OBJECT_INVALID;	}
	} 

    if(GetIsObjectValid(oWeapon) )
    {	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, nSpell, FALSE));
		effect eCast = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);
		if (GetHasFeat(2644, oPC, TRUE))
		{	itemproperty ipHallow = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d4);
			itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
			IPSafeAddItemProperty(oWeapon, ipHallow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
			IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	}
		if (GetHasFeat(2646, oPC, TRUE))
		{	itemproperty ipSanctify = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oWeapon, ipSanctify, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	}
		if (GetHasFeat(2645, oPC, TRUE))
		{	itemproperty ipRadiant = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
			IPSafeAddItemProperty(oWeapon, ipRadiant, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	}
	    return;
    }
    else
    {	FloatingTextStrRefOnCreature(16777813, OBJECT_SELF);
	    return;	}
}

void PS_Feat_CE_FistOfTheHeavens(object oPC, int nSpell)
{
	int iHasFotH = GetHasSpellEffect(nSpell,oPC);	
	RemoveSpellEffects(nSpell, oPC, oPC);	
	
    float fDuration 	= RoundsToSeconds(14);	// Always lasts 14 rounds.
	int nBonus 			= 6;
	
	if(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY) == 3)
	{	nBonus = 7;	}
	if(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY) == 4)
	{	nBonus = 7;	}
	if(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY) == 5)
	{	nBonus = 12;	}
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if (oWeapon == OBJECT_INVALID)
	{	effect eBonus = EffectDamageIncrease(nBonus, DAMAGE_TYPE_DIVINE);
			eBonus = VersusAlignmentEffect(eBonus, ALIGNMENT_ALL, ALIGNMENT_EVIL);
		effect eHands = EffectVisualEffect(VFX_DUR_SACRED_FLAMES);
		effect eLink = 	EffectLinkEffects(eBonus, eHands);
		eLink = SetEffectSpellId(eLink,nSpell);
		eLink = SupernaturalEffect(eLink);
		
		if (!iHasFotH)	
		DelayCommand(0.1f, SAFE_ApplyEffectToObject(nSpell, DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration));			
	}
	else
	{	if (iHasFotH)
		{	FloatingTextStrRefOnCreature(16777814, OBJECT_SELF);
	    	return;	}
	}		
}

void PS_Feat_CE_ArmorOfTheTome(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	int iArmor = 2;
	if(GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY, oPC) == 5)
	{	iArmor = 4;	}
    effect eArmor = EffectACIncrease(iArmor, AC_SHIELD_ENCHANTMENT_BONUS);
		eArmor = SupernaturalEffect(eArmor);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArmor, oPC);
}

void PS_Feat_CE_SanctifiedSoul(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eReduct = EffectDamageReduction(10, ALIGNMENT_EVIL, 0, DR_TYPE_ALIGNMENT);
		eReduct = SupernaturalEffect(eReduct);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReduct, oPC);
}

void PS_Feat_CE_DivineEndurance(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		 }

	int iBonus 	  = (GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY, oPC) + 
					GetLevelByClass(CLASS_TYPE_CLERIC, oPC) +
					GetLevelByClass(CLASS_TYPE_DRUID, oPC) +
					GetLevelByClass(CLASS_TYPE_PALADIN, oPC) +
					GetLevelByClass(CLASS_TYPE_RANGER, oPC) +
					GetLevelByClass(CLASS_TYPE_HARPER, oPC) +
					GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oPC) +
					GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC) +
					GetLevelByClass(CLASS_TYPE_WARPRIEST, oPC) +
					GetLevelByClass(CLASS_TYPE_STORMLORD, oPC) +
					GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) +
					GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC) +
					GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC, oPC) +
					GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC) +
					GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oPC)) / 2;
	float fDur = RoundsToSeconds(10);
    effect eConst = EffectAbilityIncrease(ABILITY_CONSTITUTION,iBonus);
		eConst = SupernaturalEffect(eConst);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConst, oPC, fDur);
}

void PS_Feat_CE_ArchonicPath(object oPC)
{
	AddScriptParameterString("START");
	AddScriptParameterString("");
	ExecuteScriptEnhanced("gui_extra_choices", oPC);
}

void PS_Feat_GM_Gargoyle(object oPC, location lTarget, int nSpell)
{
	string sGolem = "ps_gmg_guardgoyle";
	int nCraftArmor	= GetSkillRank(SKILL_CRAFT_ARMOR, oPC, TRUE);
	
	//	Determine guardian gargoyle advancement by ranks in Craft Armor
	if (nCraftArmor >= 33) sGolem = sGolem + "_5";
	else if (nCraftArmor >= 28) sGolem = sGolem + "_4";
	else if (nCraftArmor >= 23) sGolem = sGolem + "_3";
	else if (nCraftArmor >= 18) sGolem = sGolem + "_2";
	else if (nCraftArmor >= 13) sGolem = sGolem + "_1";

	// If the PC already has a creature in the henchman slot (golem or not), it will be unsummoned (destroyed). This
	// removes the need for an unsummon widget, as well as clearing out additional henchman before creating the golem.
	if (GetHenchman(oPC) != OBJECT_INVALID)
	{	
		object oHENCH = GetHenchman(oPC);
		RemoveHenchman(oPC, oHENCH);
		DestroyObject(oHENCH, 0.5);
		if (GetResRef(oHENCH) == sGolem) return;
		else if (GetTag(oHENCH) == sGolem) return;
	}

	// Create the new henchman as an object
	object oGolem = CreateObject(OBJECT_TYPE_CREATURE, sGolem, lTarget);
	DelayCommand(0.5, AdjustGolem(oPC, oGolem));
}