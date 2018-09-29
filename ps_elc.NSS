int iCheckitem(object oItem)
{
int oImmun = 0;

   if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL))
   {
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION))
   {
    oImmun = 1;
   }

return oImmun;
}

int oScan1(object oPC)
{
int problem = 0;

   object oItem = GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem))
   {
 if(iCheckitem(oItem)==1)
 {
  problem += 1;
 }
    oItem = GetNextItemInInventory(oPC);
   }

return problem;
}

void main()
{
object oPC = GetLastUsedBy();
ForceRest(oPC);

int wow =0;

   if(GetImmortal(oPC))
   {
    wow = 1;
   }
   //else if(GetCreatureSize(oPC) > 3)
   //{
   // wow = 1;
   //}
   else if(GetMaxHitPoints(oPC) > 1000)
   {
    wow = 1;
   }
   else if(GetAC(oPC) > 79)
   {
    wow = 1;
   }
   else if(GetAbilityScore(oPC,ABILITY_STRENGTH) > 50 ||
   GetAbilityScore(oPC,ABILITY_DEXTERITY) > 50 ||
   GetAbilityScore(oPC,ABILITY_CONSTITUTION) > 50 ||
   GetAbilityScore(oPC,ABILITY_WISDOM) > 50 ||
   GetAbilityScore(oPC,ABILITY_INTELLIGENCE) > 50 ||
   GetAbilityScore(oPC,ABILITY_CHARISMA) > 50)
   {
    wow = 1;
   }
   if(GetFortitudeSavingThrow(oPC) > 80 ||
   GetWillSavingThrow(oPC) > 80 ||
   GetReflexSavingThrow(oPC) > 80)
   {
    wow = 1;
   }
   string oNa = GetName(oPC);
   if(GetStringLength(oNa) < 2)
   {
    wow = 1;
   }
if(oScan1(oPC)>0)
{
 wow = 1;
}


if(wow == 1)
   {
 SendMessageToPC(oPC,"Failed...");
   }
else
   {
 SendMessageToPC(oPC,"Succeed...");
   }

}