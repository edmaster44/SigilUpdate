/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/

void main()
{
	string sTag		=	GetTag(OBJECT_SELF);
	location lSpawn	=	GetLocation(OBJECT_SELF);
	object oPC		=	GetLastKiller();
	
	if(sTag == "rh_swarm_cranium_grt")
	{
		FloatingTextStringOnCreature("The cranium rat swarm has been weakened!",oPC);
		CreateObject(OBJECT_TYPE_CREATURE,"rh_swarm_cranium_reg",lSpawn);
	}
	
	else if(sTag == "rh_swarm_cranium_reg")
	{
		FloatingTextStringOnCreature("The cranium rat swarm has been weakened!",oPC);
		CreateObject(OBJECT_TYPE_CREATURE,"rh_swarm_cranium_les",lSpawn);
	}
	
	else return;
}