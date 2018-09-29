//	g100_b_dancer_hb
/*
	Heartbeat script for generic dancers. Makes 'em dance.
*/
//	JSH-OEI 6/10/08

void main()
{
	object oPC		= GetFactionLeader(GetFirstPC());
	int nDance 		= Random(2);
	
	if (GetArea(OBJECT_SELF) != GetArea(oPC))
		return;
			
	if (!IsInConversation(OBJECT_SELF))
	
		if (nDance==0)
		{
			PlayCustomAnimation(OBJECT_SELF, "dance02", FALSE);
		}
		else
		{
			PlayCustomAnimation(OBJECT_SELF, "dance01", FALSE);
		}
		
	ExecuteScript("nw_c2_default1", OBJECT_SELF);
}