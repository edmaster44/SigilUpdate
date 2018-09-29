// gc_is_legal v1.02

int iCheckitem(object oItem, object oUser)
{
int oImmun = 0;

   if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT))
   {
   	SendMessageToPC( oUser, "freedom: " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
   {
   	SendMessageToPC( oUser, "permahaste " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE))
   {
   	SendMessageToPC( oUser, "immunity damage " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS))
   {
   	SendMessageToPC( oUser, "immunity misc " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL))
   {
   	SendMessageToPC( oUser, "immunity spell " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL))
   {
   	SendMessageToPC( oUser, "immunity spells by level " + GetTag(oItem) );
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION))
   {
   	SendMessageToPC( oUser, "item with improved evasion " + GetTag(oItem) );
    oImmun = 1;
   }

return oImmun;
}

int oScan1(object oPC, object oUser)
{
int problem = 0;

   object oItem = GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem))
   {
 if(iCheckitem(oItem,oUser)==1)
 {
  problem += 1;
 }
    oItem = GetNextItemInInventory(oPC);
   }

   int nSlot = 0;
   for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
   {
	   oItem=GetItemInSlot(nSlot, oPC);
	
	   if (GetIsObjectValid(oItem))
	   {
		 if(iCheckitem(oItem,oUser)==1)
		 {
		  problem += 1;
		 }
	   }
   }

   
return problem;
}

int CheckELC(object oPC, object oUser)
{

ForceRest(oPC);

int wow =0;

   if(GetImmortal(oPC))
   {
    SendMessageToPC( oUser, "Immortal" );
    wow = 1;
   }
   
   if(GetMaxHitPoints(oPC) > 1000)
   {
    SendMessageToPC( oUser, "HP > 1000" );
    wow = 1;
   }
   if(GetAC(oPC) > 79)
   {
    SendMessageToPC( oUser, "AC > 79" );
    wow = 1;
   }
   if(GetAbilityScore(oPC,ABILITY_STRENGTH) > 45 ||
   GetAbilityScore(oPC,ABILITY_DEXTERITY) > 40 ||
   GetAbilityScore(oPC,ABILITY_CONSTITUTION) > 40 ||
   GetAbilityScore(oPC,ABILITY_WISDOM) > 42 ||
   GetAbilityScore(oPC,ABILITY_INTELLIGENCE) > 40 ||
   GetAbilityScore(oPC,ABILITY_CHARISMA) > 40)
   {
   	SendMessageToPC( oUser, "Ability score too high" );
    wow = 1;
   }
   if(GetFortitudeSavingThrow(oPC) > 75 ||
   GetWillSavingThrow(oPC) > 75 ||
   GetReflexSavingThrow(oPC) > 75)
   {
    SendMessageToPC( oUser, "Too high saves" );
    wow = 1;
   }
   string oNa = GetName(oPC);
   if(GetStringLength(oNa) < 2)
   {
    SendMessageToPC( oUser, "Char name too short" );
    wow = 1;
   }
if(oScan1(oPC,oUser)>0)
{
 wow = 1;
}

return wow;
}

void main()
{
	object oUser      = GetItemActivator();
	if(!GetIsDM(oUser))
	{
		return;
	}

	object oPC = GetItemActivatedTarget();
	
	SendMessageToPC( oUser, "Performing diagnostic..." );

	int iEssence = 0;
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	string sLegal = GetLocalString(oItem,"LEGAL");
		if(sLegal == "TRUE")
		{
			SendMessageToPC( oUser, "Is set to LEGAL." );
		}
		iEssence += 1;
    }

	if ( iEssence != 1 ) // 1 essence exactly needed otherwise bugged
	{
		SendMessageToPC( oUser, "No essence or too many essences." );
		return;
	}
	
    if ( CheckELC(oPC,oUser) == 0 ) return;

    return;

}