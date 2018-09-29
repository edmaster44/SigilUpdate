//This script is *only* used to make the devourer go after a corpse\\
#include "nw_i0_generic"
#include "cw_inc_intellect"

void main()
{
 object o=GetLocalObject(OBJECT_SELF, "CW_CORPSE");

 AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
 AssignCommand(OBJECT_SELF, ActionMoveToLocation(GetLocation(o), TRUE));
 
 if(!GetIsObjectValid(o) || //We don't have a corpse
	   GetLocalInt(o, "CW_NODEVOUR")==1)//Or the corpse has been devoured
	 {
	  DeleteLocalString(OBJECT_SELF, "X2_SPECIAL_COMBAT_AI_SCRIPT");
	  DeleteLocalObject(OBJECT_SELF, "CW_CORPSE");
	  DetermineCombatRound();
	  return;
	 }
 
 if(GetDistanceBetween(OBJECT_SELF, o)<=3.5f && GetLocalInt(o, "CW_NODEVOUR")!=1)
  {
   if(GetIsPC(GetFactionLeader(o)))
    CW_SpawnIntellect(OBJECT_SELF, o, TRUE);
   else
    CW_SpawnIntellect(OBJECT_SELF, o, FALSE);
  }
}