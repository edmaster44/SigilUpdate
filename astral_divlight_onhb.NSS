#include "ff_safevar"

// Created by Agony_Aunt/Loki_666
// used for Astral Plane - Divinty Leech

void main()
{
	object oPC = GetFirstInPersistentObject(OBJECT_SELF);
	int iCurrentHP;
	int iMaxHP;
	int iTempHP;
	effect eHP;
	int iBonus;
	
	while (oPC != OBJECT_INVALID)
	{
		if (GetIsPC(oPC))
		{
			iCurrentHP = GetCurrentHitPoints(oPC);
			iMaxHP = GetMaxHitPoints(oPC);
			iBonus = PS_GetLocalInt(oPC, "ASTRAL_LIGHT") + 1;
			PS_SetLocalInt(oPC, "ASTRAL_LIGHT", iBonus);

			eHP = EffectTemporaryHitpoints(iBonus);
	 		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds(iBonus));
			
			if (iCurrentHP > (iMaxHP+iMaxHP))
			{
				effect eDeath = EffectDeath(TRUE, TRUE, TRUE, TRUE);
				effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
   				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
			}
			else if (iCurrentHP > (iMaxHP+iMaxHP-iBonus))
			{
				object oNPCGhyris = GetObjectByTag("astral_leech_ghyris");
				object oNPCRak1 = GetObjectByTag("astral_leech_rak1");
				object oNPCRak2 = GetObjectByTag("astral_leech_rak2");
				
				AssignCommand(oNPCGhyris, SpeakString("<i>*Shakes his head*", TALKVOLUME_TALK));
				AssignCommand(oNPCRak1, SpeakString("Is it me, or are they turning red?", TALKVOLUME_TALK));
				AssignCommand(oNPCRak2, SpeakString("I think they are about to experience a life altering transformation! <i>*chuckles*", TALKVOLUME_TALK));
			}
		}
		oPC = GetNextInPersistentObject(OBJECT_SELF);
	}
}