

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
   
   AssignCommand(oPC, TakeGoldFromCreature(cGPpen, oPC, TRUE)); 
   AssignCommand(oPC, ActionJumpToLocation(lDeathloc));
   
}