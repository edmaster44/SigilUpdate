#include "ff_safevar"

void SetAnimationOn(object oNPC) {
	
	switch (Random(25)+1) {
		case 1: PS_SetLocalString(oNPC, "ANIMATION", "talkcheer"); break;
		case 2: PS_SetLocalString(oNPC, "ANIMATION", "talkforce"); break;
		case 3: PS_SetLocalString(oNPC, "ANIMATION", "talkforce01"); break;
		case 4: PS_SetLocalString(oNPC, "ANIMATION", "talkforce02"); break;
		case 5: PS_SetLocalString(oNPC, "ANIMATION", "talkforce03"); break;
		case 6: PS_SetLocalString(oNPC, "ANIMATION", "talkinjured"); break;
		case 7: PS_SetLocalString(oNPC, "ANIMATION", "talklaugh"); break;
		case 8: PS_SetLocalString(oNPC, "ANIMATION", "talknervous"); break;
		case 9: PS_SetLocalString(oNPC, "ANIMATION", "talknormal"); break;
		case 10: PS_SetLocalString(oNPC, "ANIMATION", "talknormal02"); break;
		case 11: PS_SetLocalString(oNPC, "ANIMATION", "talkplead"); break;
		case 12: PS_SetLocalString(oNPC, "ANIMATION", "talksad"); break;
		case 13: PS_SetLocalString(oNPC, "ANIMATION", "talkshout"); break;
		case 14: PS_SetLocalString(oNPC, "ANIMATION", "sitgroundidle"); break;
		case 15: PS_SetLocalString(oNPC, "ANIMATION", "bored"); break;
		case 16: PS_SetLocalString(oNPC, "ANIMATION", "clapping"); break;
		case 17: PS_SetLocalString(oNPC, "ANIMATION", "dance01"); break;
		case 18: PS_SetLocalString(oNPC, "ANIMATION", "dance02"); break;
		case 19: PS_SetLocalString(oNPC, "ANIMATION", "meditate"); break;
		case 20: PS_SetLocalString(oNPC, "ANIMATION", "drinkbeeridle"); break;
		case 21: PS_SetLocalString(oNPC, "ANIMATION", "flirt"); break;
		case 22: PS_SetLocalString(oNPC, "ANIMATION", "kneelclutchloop"); break;
		case 23: PS_SetLocalString(oNPC, "ANIMATION", "tired"); break;
		case 24: PS_SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT", 1); break;
		case 25: PS_SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT", 1); break;
		default: PS_SetLocalString(oNPC, "ANIMATION", "talk01"); break;
	}

}


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

//wp_quake_customer 1-16
//wp_Quake_Lavender_1-2
//wp_quake_entertainer_1-2
  
 int iLock = PS_GetGlobalInt("QuakesLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("QuakesLock", 1); // Only allows one clean up at a time.
  int excep1 = Random(14)+1;
  int excep2 = Random(14)+1;
  
  if(GetObjectByTag("quake_lavender") == OBJECT_INVALID)
  {
   	object oWP;
   	if (d100() < 50)
   		oWP = GetWaypointByTag("wp_Quake_Lavender_1");
	else
   		oWP = GetWaypointByTag("wp_Quake_Lavender_2");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "quake_lavender", lSpawnpoint);    
  }
  
  int n;
  for (n = 1; n < 15; n++) {
  	if (GetObjectByTag("quake_customer"+IntToString(n)) == OBJECT_INVALID) {
		object oWP;
		if (n == excep1)
			oWP = GetWaypointByTag("wp_quake_entertainer_1");
		else if (n == excep2)
			oWP = GetWaypointByTag("wp_quake_entertainer_2");
		else
		{
			oWP = GetWaypointByTag("wp_quake_customer"+IntToString(n));
		}
		
   		location lSpawnpoint = GetLocation(oWP);  
   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "quake_customer"+IntToString(n), lSpawnpoint);
		SetAnimationOn(oSpawn);
	}
  }
  
  PS_SetGlobalInt("QuakesLock", 0);
 }
}