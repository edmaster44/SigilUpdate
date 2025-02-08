/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"

#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	effect eDur     = EffectNWN2SpecialEffectFile("psi_metapsi_maximize.sef");
	
	
	if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 0)
	{
		PS_SetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE", 1);
		SendMessageToPC(OBJECT_SELF, "Metapsionics Activated: Maximize Power");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, OBJECT_SELF);
	}
	else
	{
		PS_SetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE", 0);
		SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Maximize Power");
		RemoveEffectsFromSpell(oTarget, GetSpellId());
	}
	    
		
}