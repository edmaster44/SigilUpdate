#include "psi_inc_metapsi"
#include "nwn2_inc_spells"
#include "aaa_constants"
#include "psi_inc_psifunc"


int PS_PsionicClasses(object oPC)
{
	int iPsion = GetLevelByClass(CLASS_TYPE_PSION, oPC);
	int iPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR,oPC);
	int iTotal = iPsion + iPsywar;
	return iTotal;


}
int nPsion(object oPC)
{
int nPsion = GetLevelByClass(CLASS_TYPE_PSION,oPC);
int nDragon = GetLevelByClass(CLASS_TYPE_DRAGON_PSION,oPC);
int nMentalist = GetLevelByClass(CLASS_TYPE_ILLITHID_MENTALIST_PRC,oPC);
int nCere	   = GetLevelByClass(CLASS_TYPE_CEREBREMANCER,oPC);
int nPsyKnight = GetLevelByClass(CLASS_PSYCHIC_KNIGHT,oPC);
int iTotal = nPsion + nDragon + nMentalist + nCere + nPsyKnight;
return iTotal;

}

int nPsywar(object oPC)
{
int nPsywar= GetLevelByClass(CLASS_PSYCHIC_WARRIOR,oPC);
int nWarmind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
int nDragon = GetLevelByClass(CLASS_TYPE_DRAGON_PSION,oPC);
int iTotal = nPsywar +nWarmind;
return iTotal;



}
 
//*************************************************
struct manifestation EvaluateManifestationNew(object oManifester, object oTarget, int spellID, int nMetaPsiFlags)
{



    // Manifester-related stuff
    int nManifesterLevel = PS_PsionicClasses(oManifester);
	
	if(GetLevelByClass(100, oManifester) > 0)
    {
        nManifesterLevel = nManifesterLevel + GetLevelByClass(100, oManifester);
    }
		if(GetLevelByClass(109, oManifester) > 0)
	{
        nManifesterLevel = nManifesterLevel + GetLevelByClass(109, oManifester);
    }
	
	if (GetLevelByClass(CLASS_TYPE_WARMIND,oManifester) > 0 )
	{
		nManifesterLevel = nManifesterLevel + GetLevelByClass(CLASS_TYPE_WARMIND,oManifester);

	}

	if(GetLevelByClass(152, oManifester) > 0)
	{
        nManifesterLevel = nManifesterLevel + GetLevelByClass(152, oManifester);
    }
	if(GetLevelByClass(128, oManifester) > 0)
	{
        nManifesterLevel = nManifesterLevel + GetLevelByClass(128, oManifester);
    }
    int nClass 			= GetManifestingClass(oManifester);

    int nPowerLevel      = GetSpellLevel(spellID);
    int nManifesterPP    = GetLocalInt(oManifester, "PSI_PP");
	if (GetLocalInt(oManifester, "PSI_SPAWN"))
	{
		nManifesterLevel = GetHitDice(oManifester);
	}
	int nCatapsiDC = GetLocalInt(oManifester, "PRC_Catapsi_DC");
    // Target-specific stuff

    /* Initialise the manifestation structure */
    struct manifestation manif;
    manif.oManifester       = oManifester;
    manif.bCanManifest      = TRUE;                         // Assume successfull manifestation by default
    manif.nPPCost           = nPowerLevel * 2 - 1;          // Initialise the cost to the base cost of the power
	
	if(GetLocalInt(oTarget, "PRC_IsInCatapsi") == TRUE)
	{
		if(!MySavingThrow(SAVING_THROW_WILL, oManifester, nCatapsiDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			manif.nPPCost = manif.nPPCost + 4;
		}
	}
	
    manif.nPsiFocUsesRemain = 0;							// Determine how many times psionic focus could be used
    manif.nManifesterLevel  = nManifesterLevel;
    manif.nSpellID          = spellID;
	int nCastMod;
    // Run an ability score check to see if the manifester can manifest the power at all
	if (nPsion(oManifester) > 0) 
	{ nCastMod = ABILITY_INTELLIGENCE;}
	if (nPsywar(oManifester) > 0)
	{ nCastMod = ABILITY_WISDOM; }
	
    if(GetAbilityScore(oManifester, nCastMod, FALSE) - 10 < nPowerLevel)
    {
        SendMessageToPC(oManifester, "You do not have a high enough ability score to manifest this power."); 
        manif.bCanManifest = FALSE;
    }
	
    // Account for Metapsionics and Augmentation
    manif = EvaluateMetapsionicsNew(manif, nMetaPsiFlags);

    // Skip paying anything if something has prevented successfull manifestation already by this point
    if(manif.bCanManifest)
    {
		//No PP cost if Metamind's Font of Power is active
		if(GetLocalInt(OBJECT_SELF, "METAMIND_FONT_ACTIVE") == 1)
		{
			return manif;
		}
		
		//dmg_disswpn does not drain PP per strike
		if (GetHasSpell(2893,OBJECT_SELF))
		{
			return manif;
		} 
		
        //If the manifester does not have enough points before hostile modifiers, cancel power
        else if(manif.nPPCost > nManifesterPP)
        {
            SendMessageToPC(oManifester, "You do not have enough Power Points to manifest this power");
			manif.bCanManifest = FALSE;
			
        }
		else if(manif.nPPCost > nManifesterLevel)
		{
			SendMessageToPC(oManifester, "You cannot manifest a power whose power point cost exceeds your manifester level.");
			manif.bCanManifest = FALSE;
		}
        else
        {
			SetLocalInt(oManifester, "PSI_PP", nManifesterPP-manif.nPPCost);
			int nPPFinal = nManifesterPP-manif.nPPCost;
			nManifesterPP    = GetLocalInt(oManifester, "PSI_PP");
			//Debug message
			if (!GetHasSpell(2893,OBJECT_SELF))
			 
			SendMessageToPC(oManifester, "Power cast successfully; Current Power Points: "+IntToString(nManifesterPP));
		
		
			
        }
    }
	
	SetGUIObjectText(OBJECT_SELF, "SCREEN_SPIRITBAR_PSION", "PPRatioTXT", -1, IntToString(nManifesterPP));
    return manif;
}
//*******************************************************************