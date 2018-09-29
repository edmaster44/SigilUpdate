// if a wounded scout makes it to this trigger, they will call for allies from within the ruins
// and then go inside (actually destroyed)

void main()
{
	object oCreature = GetEnteringObject();
	string sTag = GetTag(oCreature);
	location lSpawn = GetLocation(GetObjectByTag("wp_astral_gith_ruins_spawn",0));
	if (sTag == "c_astral_githyanki_scout")
	{
		// if scout escapes 3 tough fighters appear
		CreateObject(OBJECT_TYPE_CREATURE, "ps_astral_fighter3", lSpawn, FALSE);
		CreateObject(OBJECT_TYPE_CREATURE, "ps_astral_fighter3", lSpawn, FALSE);
		CreateObject(OBJECT_TYPE_CREATURE, "ps_astral_fighter3", lSpawn, FALSE);
		DestroyObject(oCreature);
	}
}