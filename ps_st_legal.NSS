

//version 1.00

void main(int nLegal)
{
//SendMessageToPC(GetFirstPC(), "specracetemplate legal startX");
   object oPC = OBJECT_SELF;
	
   object oItem = GetItemPossessedBy(oPC,"ps_specracetemplate");
   string Legal = "";
   
   if(GetIsObjectValid(oItem))
   {
//SendMessageToPC(GetFirstPC(), IntToString(nLegal));
   		if(nLegal == 1)
			Legal = "TRUE";
			
		SetLocalString(oItem,"LEGAL",Legal);
		return;
	}

}