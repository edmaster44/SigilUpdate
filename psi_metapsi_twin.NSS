/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	
	
	if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_TWIN") == 0)
	{
		PS_SetLocalInt(OBJECT_SELF, "METAPSI_TWIN", 1);
		SendMessageToPC(OBJECT_SELF, "Metapsionics Activated: Twin Power");
	}
	else
	{
		PS_SetLocalInt(OBJECT_SELF, "METAPSI_TWIN", 0);
		SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Twin Power");
	}
	    
		
}