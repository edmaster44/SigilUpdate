//::///////////////////////////////////////////////
//:: Astral Construct
//:: psi_shp_astralconstruct.nss
//:: 
//:://////////////////////////////////////////////
/*
    Summons a powerful ectoplasmic construct
    on caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: March 7, 2015
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "psi_spellhook" 


void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!PsiPrePowerCastCode())
   	{
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   	}

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
	int nPP = GetLocalInt(OBJECT_SELF, "PSI_PP");
	int nPPCost;
	int nManifesterTier = GetLevelByClass(90, OBJECT_SELF);
    int nCasterLevel = GetLevelByClass(90, OBJECT_SELF);
	if(GetLevelByClass(152, OBJECT_SELF) > 0)
	{
        nManifesterTier = nManifesterTier + GetLevelByClass(152, OBJECT_SELF);
		nCasterLevel = nCasterLevel + GetLevelByClass(152, OBJECT_SELF);
    }
    int nDuration = nCasterLevel;
	int nRoll = d2();
    //nDuration = 24;	// AFW-OEI 06/02/2006: No longer lasts 24 hours.
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Metamagic extension if needed
    
    
		
    switch (nManifesterTier)
	{
		case 3: case 4:
		{
			eSummon = EffectSummonCreature("ps_x_astralconstruct2", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 3;
			break;
		}
		case 5: case 6:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct3", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 5;
			break;}
		case 7: case 8:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct4", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 7;
			break;}
		case 9: case 10:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct5", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 9;
			break;}
		case 11: case 12:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct6", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 11;
			break;}
		case 13: case 14:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct7", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 13;
			break;}
		case 15: case 16:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct8", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 15;
			break;}
		case 1: case 2:
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct1", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 1;
			break;}
	    default: 
		{	eSummon = EffectSummonCreature("ps_x_astralconstruct9", VFX_HIT_SPELL_SUMMON_CREATURE);
			nPPCost = 17;
			break;}
	}
	if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
	{
		nDuration = nDuration * 2;
		nPPCost = nPPCost + 2;
	}
	int nPPFinal = nPP - nPPCost;
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
	if (nPP > nPPCost || nPP == nPPCost)
	{
	    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
		SetLocalInt(OBJECT_SELF, "PSI_PP", nPPFinal);
		SendMessageToPC(OBJECT_SELF, "Power Points Remaining:  " + IntToString(nPPFinal));
		SetGUIObjectText(OBJECT_SELF, "SCREEN_SPIRITBAR_PSION", "PPRatioTXT", -1, IntToString(nPPFinal));	
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "You do not have enough Power Points to manifest this power");
		return;
	}
}