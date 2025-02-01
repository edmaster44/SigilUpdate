#include "ff_safevar"

#include "x0_i0_transport"
void bridgeSpawn()
{
	object oWP1 = GetWaypointByTag("wp_rockbridge_1");
	object oWP2 = GetWaypointByTag("wp_rockbridge_2");
	object oWP3 = GetWaypointByTag("wp_rockbridge_3");
	object oWP4 = GetWaypointByTag("wp_rockbridge_block1");
	object oWP5 = GetWaypointByTag("wp_rockbridge_block2");
	object oBridge1 = GetNearestObjectByTag("pl_rockbridge_1");
	object oBridge2 = GetNearestObjectByTag("pl_rockbridge_2");
	object oBridge3 = GetNearestObjectByTag("pl_rockbridge_3");
	object oBridge4 = GetNearestObjectByTag("pl_rockbridge_block1");
	object oBridge5 = GetNearestObjectByTag("pl_rockbridge_block2");
	effect eDust = EffectNWN2SpecialEffectFile("fx_rockslide");
	effect eQuake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE); //VFX_FNF_SCREEN_SHAKE

	if (GetIsObjectValid(oBridge1))
	{
		ApplyEffectAtLocation(0, eDust, GetLocation(oWP2));
		ApplyEffectAtLocation(1, eQuake, GetLocation(oWP2), 1.0f);
		DestroyObject(oBridge1);
		DestroyObject(oBridge2);
		DestroyObject(oBridge3);
		CreateObject(64, "pl_rockbridge_block", GetLocation(oWP4), FALSE, "pl_rockbridge_block1");
		CreateObject(64, "pl_rockbridge_block", GetLocation(oWP5), FALSE, "pl_rockbridge_block2");
		int nCount = 1;
		object oPC = GetNearestCreature(4, 1, oWP2, nCount);
		while (GetIsObjectValid(oPC))
		{
			if (GetIsDM(oPC))
				return;
			if (PS_GetLocalInt(oPC, "onbridge") == 1)
			{
				if (GetIsDM(oPC))
					continue;
				else
				{
					AssignCommand(oPC, ActionSpeakString("<i>The rocks collapse under "+GetName(oPC)+"'s feet and they plunge into the darkness!</i>", 0));
					TransportToWaypoint(oPC, GetWaypointByTag("wp_limbo_stormwhirlwind"));
					PS_SetLocalInt(oPC, "onbridge", 0);
				}
			}
				
			nCount++;
			oPC = GetNearestCreature(4, 1, oWP2, nCount);
				
			if (nCount > 20)
				return;
			
		}
	}
	else
	{
		CreateObject(64, "pl_rockbridge_1", GetLocation(oWP1), FALSE, "pl_rockbridge_1");
		CreateObject(64, "pl_rockbridge_1", GetLocation(oWP2), FALSE, "pl_rockbridge_2");
		CreateObject(64, "pl_rockbridge_3", GetLocation(oWP3), FALSE, "pl_rockbridge_3");
		ApplyEffectAtLocation(0, eDust, GetLocation(oWP2));
		ApplyEffectAtLocation(1, eQuake, GetLocation(oWP2), 1.0f);
		DestroyObject(oBridge4);
		DestroyObject(oBridge5);
	}
}

int creatureReflex(object oWP)
{
	object oTarget = GetFirstObjectInShape(4, 5.0f, GetLocation(oWP), FALSE, OBJECT_TYPE_CREATURE);
	int sanityCheck;
	while (GetIsObjectValid(oTarget))
	{
		/*string sBase;
		if (d100() <= 50)
			sBase = GetTag(oWP)+"j1";
		else
			sBase = GetTag(oWP)+"j2";	
		object oWP = GetWaypointByTag(sBase);
		//SpeakString("object near: "+GetName(oTarget), TALKVOLUME_SHOUT);
		
		AssignCommand(oTarget, ActionJumpToObject(oWP, FALSE));
		PlayCustomAnimation(oTarget, "laydownB", TRUE, 1.0f);
		if (ReflexSave(oTarget, 20, 14) == 0)
			ApplyEffectToObject(0, EffectDamage(d6(12), 1, 0, TRUE), oTarget);
		
		if (sanityCheck > 20) return;
		sanityCheck++;*/
		
		return TRUE;
		
		oTarget = GetNextObjectInShape(4, 5.0f, GetLocation(oWP), FALSE, OBJECT_TYPE_CREATURE);
	}
	return FALSE;
}

void blowAway(object oWP)
{
	object oTarget = GetFirstObjectInShape(4, 10.0f, GetLocation(oWP), FALSE, OBJECT_TYPE_CREATURE);
	int sanityCheck;
	//SpeakString("Whirlwind: "+GetTag(oWP), TALKVOLUME_SHOUT);
	while (GetIsObjectValid(oTarget))
	{	
		AssignCommand(oWP, ActionSpeakString("<i>The wind whips up with increased fury, threatening to knock bystanders off their feet!</i>", 0));
		//SpeakString("object near: "+GetName(oTarget), TALKVOLUME_SHOUT);
		
		if (ReflexSave(oTarget, 20, 14) == 0)
		{
			AssignCommand(oTarget, ActionSpeakString("<i>"+GetName(oTarget)+" is swept off their feet and falls into the chasm!</i>", 0));
			TransportToWaypoint(oTarget, GetWaypointByTag("wp_limbo_stormwhirlwind"));
		}
		
		if (sanityCheck > 20) return;
		sanityCheck++;
		
		oTarget = GetNextObjectInShape(4, 10.0f, GetLocation(oWP), FALSE, OBJECT_TYPE_CREATURE);
	}
}

void OpenDoor(string sBase, int nCount)
{
	effect eDust = EffectNWN2SpecialEffectFile("fx_rockslide");
	effect eQuake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE); //VFX_FNF_SCREEN_SHAKE
	string sWP = "wp"+sBase+IntToString(nCount);
	string sDoor = "dr"+sBase+IntToString(nCount);
	
	object oWP1 = GetWaypointByTag(sWP);
	if (GetNearestObjectByTag(sDoor) == OBJECT_INVALID)
	{
		if (!creatureReflex(oWP1))
		{
			CreateObject(64, "door_limboearth", GetLocation(oWP1), FALSE, sDoor);
			ApplyEffectAtLocation(0, eDust, GetLocation(oWP1));
			ApplyEffectAtLocation(1, eQuake, GetLocation(oWP1), 1.0f);
			//SpeakString("created: "+sDoor, TALKVOLUME_SHOUT);
		}
	}
	
	//adjust count down
	int rand = d6();
	nCount = (nCount-rand);
	if (nCount < 1)
		nCount = 13-(rand-1);
		
	sWP = "wp"+sBase+IntToString(nCount);
	sDoor = "dr"+sBase+IntToString(nCount);
	object oDoor2 = GetNearestObjectByTag(sDoor);
	object oWP2 = GetWaypointByTag(sWP);
	if (GetNearestObjectByTag(sDoor) != OBJECT_INVALID)
	{
		DestroyObject(oDoor2);
		ApplyEffectAtLocation(0, eDust, GetLocation(oWP2));
		ApplyEffectAtLocation(1, eQuake, GetLocation(oWP2), 1.0f);
		//SpeakString("destroyed: "+sDoor, TALKVOLUME_SHOUT);
	}
}

int figureCount(int count, int max)
{
	if (d100() <= 50)
		count = (count+1);
	else if (d100() <= 25)
		count = (count+d6());
	else
		count = d12();
	
	if (count > max)
		count = (max-(count-max));
	return count;
}

void lightAppear(object self)
{
	int lightCount = PS_GetLocalInt(OBJECT_SELF, "lightCount");
	//SpeakString("spawning light #"+IntToString(lightCount), TALKVOLUME_SHOUT);

	object oLightWP = GetWaypointByTag("wp_limbolight_"+IntToString(lightCount));
	effect eDust = EffectNWN2SpecialEffectFile("fx_global_earth_elemental_arise");
	ApplyEffectAtLocation(1, eDust, GetLocation(oLightWP), 2.0f);
	CreateObject(64, "pl_limbolight", GetLocation(oLightWP), FALSE, "pl_limbolight_"+IntToString(lightCount));
	object oLight = GetNearestObjectByTag("lt_limbolight_"+IntToString(lightCount));
	SetLightActive(oLight, TRUE);
			
	object oLightEffect = GetNearestObjectByTag("pl_limbolight_"+IntToString(lightCount-1));
	oLightWP = GetWaypointByTag("wp_limbolight_"+IntToString(lightCount-1));
	oLight = GetNearestObjectByTag("lt_limbolight_"+IntToString(lightCount-1));
	ApplyEffectAtLocation(1, eDust, GetLocation(oLightWP), 2.0f);
	SetLightActive(oLight, FALSE);
	DestroyObject(oLightEffect);
			
	PS_SetLocalInt(OBJECT_SELF, "lightCount", figureCount(lightCount, 9));	
}

void SpawnCrystals() {

	int CrystalNum = 8;
	int chance = Random(8)+1;
	object oWP = GetWaypointByTag("limbo_rockspawn_"+IntToString(chance));
	//SpeakString("spawning rock! "+GetTag(oWP), TALKVOLUME_SHOUT);
	if (!GetIsObjectValid(GetObjectByTag("limbo_rock_"+IntToString(chance))))
		CreateObject(OBJECT_TYPE_PLACEABLE, "limbo_consciousrock", GetLocation(oWP), FALSE, "limbo_rock_"+IntToString(chance));
}

void DestroyCrystals() {
	int CrystalNum = 8;
	int count = 1;
	while (count <= CrystalNum)
	{
		object oRock = GetObjectByTag("limbo_rock_"+IntToString(count));
		if (GetIsObjectValid(oRock))
			DestroyObject(oRock);
		count++;
	}
}

void main ()
{
	//Should this even been running?
	object oNearestPC = GetNearestCreature(1, 1);
	if (GetIsObjectValid(oNearestPC) == FALSE || GetArea(oNearestPC) != GetArea(OBJECT_SELF))
	{
		DestroyCrystals();
		DestroyObject(OBJECT_SELF);
		return;
	}
		
	//variable setup
	int count = PS_GetLocalInt(OBJECT_SELF, "count");
	if (count <= 0)
		PS_SetLocalInt(OBJECT_SELF, "count", 1);
	count = PS_GetLocalInt(OBJECT_SELF, "count");
	int nChance = d100();
	
	if (nChance < 50)
		SpawnCrystals();
	
	if (nChance <= 40)
	{
		OpenDoor("_limboearth_", count);
		if (count > 6)
			OpenDoor("_limboearth_", (count-6));
		else
			OpenDoor("_limboearth_", (count+6));
		PS_SetLocalInt(OBJECT_SELF, "count", figureCount(count, 13));
		count = PS_GetLocalInt(OBJECT_SELF, "count");
		if (nChance <= 20)
			OpenDoor("_limboearth_", count);
	}
	else if (nChance <= 70)
	{
		bridgeSpawn();
		lightAppear(OBJECT_SELF);
	}
	else if (nChance <= 80)
		blowAway(GetNearestObjectByTag("pl_whirlwind_1"));
	else if (nChance <= 90)
		blowAway(GetNearestObjectByTag("pl_whirlwind_2"));	
	
}