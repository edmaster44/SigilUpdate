

void main(){

	object oPC =  GetItemActivator();
	GiveXPToCreature(oPC, 10000);
	GiveGoldToCreature(oPC, 10000);
	
	object oMod = GetModule();
	
	if (!GetLocalInt(oMod, "SIGIL_DEV_MODE"))
		SetLocalInt(oMod, "SIGIL_DEV_MODE", TRUE);






}