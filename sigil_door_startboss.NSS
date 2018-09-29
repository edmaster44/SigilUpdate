void main()
{
	object oDOOR = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	SendMessageToPC(oPC, "test");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionStartConversation(oPC, "conv_ysgard_boss", TRUE, FALSE));
}