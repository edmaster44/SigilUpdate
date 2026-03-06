
#include "ps_inc_financial"
// v1.00

void main()
{
   object oPC = GetPCSpeaker();
   
   location lDeathloc = GetLocalLocation(oPC, "DEATH_LOCATION");
   
   if(GetAreaFromLocation(lDeathloc) == OBJECT_INVALID)
   {
      return;
   }

   int cGPpen = GetHitDice(oPC)*25;
   
   AssignCommand(oPC, PS_TakeGoldFromCreature(cGPpen, oPC, TRUE)); 
   AssignCommand(oPC, ActionJumpToLocation(lDeathloc));
   
}