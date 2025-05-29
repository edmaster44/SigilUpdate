

#include "nwn2_inc_spells"
#include "psi_inc_psifunc"

int nPsion(object oPC){
	return GetPsionicCasterLevel(oPC, CLASS_TYPE_PSION);
}

int nPsywar(object oPC){
	return GetPsionicCasterLevel(oPC, CLASS_PSYCHIC_WARRIOR);
}

//*************************************************
struct manifestation EvaluateManifestationNew(object oManifester, object oTarget, int spellID, int nMetaPsiFlags){

	int nClass = GetManifestingClass(oManifester);
	int nManifesterLevel = GetManifesterLevel(oManifester, nClass);
	
    int nPowerLevel      = GetSpellLevel(spellID);
	// elfsight is 1 pp for psywar
	if (GetLevelByClass(110, oManifester) > 0 && spellID == 14419) nPowerLevel = 1;
    int nManifesterPP    = GetLocalInt(oManifester, "PSI_PP");
	if (GetLocalInt(oManifester, "PSI_SPAWN")){
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
	
	// Run an ability score check to see if the manifester can manifest the power at all
	int nCastMod = ABILITY_INTELLIGENCE;
	if (nClass == CLASS_PSYCHIC_WARRIOR) nCastMod = ABILITY_WISDOM;
	
    if (GetAbilityScore(oManifester, nCastMod, FALSE) - 10 < nPowerLevel){
        SendMessageToPC(oManifester, "You do not have a high enough ability score to manifest this power."); 
        manif.bCanManifest = FALSE;
    }
	
    // Account for Metapsionics and Augmentation
    manif = EvaluateMetapsionicsNew(manif, nMetaPsiFlags);

    // Skip paying anything if something has prevented successfull manifestation already by this point
    if(manif.bCanManifest){
		//No PP cost if Metamind's Font of Power is active
		if(GetLocalInt(OBJECT_SELF, "METAMIND_FONT_ACTIVE") == 1)
			return manif;
		
        //If the manifester does not have enough points before hostile modifiers, cancel power
        else if(manif.nPPCost > nManifesterPP){
            SendMessageToPC(oManifester, "You do not have enough Power Points to manifest this power");
			manif.bCanManifest = FALSE;
        } else if(manif.nPPCost > nManifesterLevel){
			SendMessageToPC(oManifester, "You cannot manifest a power whose power point cost exceeds your manifester level.");
			manif.bCanManifest = FALSE;
		} else {
			SetLocalInt(oManifester, "PSI_PP", nManifesterPP-manif.nPPCost);
			int nPPFinal = nManifesterPP-manif.nPPCost;
			nManifesterPP    = GetLocalInt(oManifester, "PSI_PP");
        }
    }
	
	SetGUIObjectText(OBJECT_SELF, "SCREEN_SPIRITBAR_PSION", "PPRatioTXT", -1, IntToString(nManifesterPP));
    return manif;
}
//*******************************************************************