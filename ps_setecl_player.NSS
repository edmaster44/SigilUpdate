//version 1.00

void main(int nECL)
{
//SendMessageToPC(GetFirstPC(), "setecl_player start");
   object oPC = OBJECT_SELF;
	
   object oItem = GetItemPossessedBy(oPC,"setecltool");
   
   if(GetIsObjectValid(oItem))
   {
//SendMessageToPC(GetFirstPC(), "has valid tool, setting ECL"+IntToString(nECL));
		SetLocalString(oItem,"ECL",IntToString(nECL));
		return;
	}

}