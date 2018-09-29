void main() 
{

	object oPC = GetPCSpeaker();
	int nOfferings = GetLocalInt(OBJECT_SELF, "offerings");
	
	GiveGoldToCreature(oPC, nOfferings);
	SetLocalInt(OBJECT_SELF, "offerings", 0);
	
}