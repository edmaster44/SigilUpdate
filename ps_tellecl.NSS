void main()
{
	object oPC = OBJECT_SELF;
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
		string sECL = GetLocalString(oItem,"ECL");
		
		if(sECL != "")
		{
			SendMessageToPC(oPC,"Your ECL is: +" + sECL);
			SendMessageToPC(oPC,"Note that in SCoD, maximum level is 30 minus ECL, so your character will not progress beyond level: " + IntToString(30-StringToInt(sECL)));
			return;
		}
    }
}