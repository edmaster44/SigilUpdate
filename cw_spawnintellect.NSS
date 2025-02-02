#include "ff_safevar"

#include "nw_i0_generic"
/*
9-24-10
Intellect Devourer

This is a secondary script. Set this as a custom string on a creature to spawn an intellect devourer when it dies.
Useful for scary(!) scenes and other sorts of crazy stuff.

Set string "DeathScript" to "cw_spawnintellect" for this to work.
*/
void main()
{
 PS_SetLocalString(OBJECT_SELF, "DeathScript", PS_GetLocalString(OBJECT_SELF, "CW_DeathScript"));
 //PS_DeleteLocalString(OBJECT_SELF, "DeathScript");
 PS_SetLocalInt(OBJECT_SELF, "CW_NODEVOUR", 1);
 PS_DeleteLocalInt(OBJECT_SELF, "CW_INTCORPSE");
 SetIsDestroyable(TRUE, FALSE, FALSE);
 //SendMessageToPC(GetFirstPC(), "RUNNING_D");
 object o=CreateObject(OBJECT_TYPE_CREATURE, "cw_intellectdevourer", CalcSafeLocation(OBJECT_SELF, GetLocation(OBJECT_SELF), 5.0f, FALSE, FALSE));
 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L"), GetLocation(o));
 AssignCommand(o, ClearAllActions(TRUE));
 
 object enemy=GetLastKiller();
 
 if(!GetIsObjectValid(enemy))
  enemy=GetNearestEnemy();
 
 AssignCommand(o, DetermineCombatRound(enemy));
}