// v1.01

/*******************************
Script: Respawn At Start Location
Created By: Jaden Wagener
Created On: 08/30/02
*******************************/
//Respawns a player back at the start location.
//Script should be placed in the module's OnRespawn slot.
//NOTE: due to the current bug issue with the GetStartLocation function,
//a waypoint must be created at the starting location and its tag inserted
//in place of NW_WAYPOINT001.
#include "nw_i0_plot"
#include "ps_inc_functions"
#include "ps_class_inc"
#include "ps_inc_ecl"
#include "ps_inc_achievements"
 
//Uses some in game default scripts

//Tags of special condition locations
// Funny, tags remove "-" from strings, so take care.
const string LOC_ARENA = "ps_area_s_cw_gymnasium_arena";
const string LOC_OOC = "spawnroom";
const string LOC_MORTUARY = "ps_area_s_hw_mortuary";
const string LOC_APPERANCE_CHANGER = "appearance_changer_room";
const string LOC_FESTHALL = "ps_area_s_cw_festhallchanging";

//Checking for other participants in the arena for the achievement
void CheckArenaFight(object oPC) {

	object oArea = GetArea(oPC);
	
	//We aren't in the arena, skip this
	if (GetTag(oArea) != LOC_ARENA)
		return;

	float fRadius = 15.0f;
	int nCount = 0;
	object oViewer = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));
	while (GetIsObjectValid(oViewer)) {
	
		//Sanity check
		if (nCount > 20)
			return;
			
		if (!GetIsPC(oViewer))
			continue;
			
		if (GetLocalInt(oPC, "IN_ARENA") == 0)
			continue;
			
		IncrementAchievement(oViewer, 45);
	
		nCount++;
		oViewer = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));
	}
}

void ApplyRespawnPenalties(object oPC)
{
	//xp loss   
   	int nXP = GetXP(oPC);
   	int cXPpen = FloatToInt(IntToFloat(nXP)*0.007);
   	int iHD = GetHitDice(oPC);
	int cGPpen;
   	if (iHD > 3)
   	{	cGPpen = (iHD-3)*50;	}
		
	int nXPforLevel = PS_GetXPForLevel(iHD);
	if ( nXP - cXPpen < nXPforLevel )
   	{	SetXP(oPC, nXPforLevel);	}
    else
	{	SetXP(oPC, nXP-cXPpen);		}

   //gold loss
   AssignCommand(oPC, TakeGoldFromCreature(cGPpen, oPC, TRUE)); 
}

void respawn(object xPC)
{	
   //Set variables
   int cXPpen = 0;
   int cGPpen = 0;
      
   //object xPC;
   int xHP;
   int nXP;
   location xStart;
   effect xRez, xHeal, xVisual, xBad;
   //Populate variables
   //xPC = GetLocalObject(OBJECT_SELF, "LAST_RESPAWN_BUTTON_PRESSER");                     //Player respawning
   
   SetLocalLocation(xPC, "DEATH_LOCATION", GetLocation(xPC));
   object oEssence =  GetItemPossessedBy(xPC, "ps_essence");

   xHP = GetMaxHitPoints(xPC);                               //Player's Max HP
   xStart = GetLocation(GetWaypointByTag("ps_death_respawn_wp")); //Start location
   xRez = EffectResurrection();                              //Resurrect effect
   xHeal = EffectHeal(xHP);                                  //Heal effect

   string sCurrentArea = GetTag(GetArea(xPC));
   string sDeathArea = GetLocalString(oEssence, "PC_DEATH_AREA");
   int iAreaChange;
   
   // as discussed, AF to arena will now trigger proper penalty
   // AF to mortuary will now be around the cost of a coin of life (around 700 lets say), no XP cost.
   
   	if (sDeathArea == sCurrentArea)
	{	iAreaChange = 1;	}
	
	if (sCurrentArea == LOC_ARENA && iAreaChange == 1)
	{	xStart = GetLocation(GetWaypointByTag("wp_arena_respawn"));	}
	
	else if (sCurrentArea == LOC_FESTHALL && iAreaChange == 1)
	{	xStart = GetLocation(xPC);	}
	
	else if (sCurrentArea == LOC_OOC || sCurrentArea == LOC_APPERANCE_CHANGER)
	{	xStart = GetLocation(xPC);	}
	
	else if (sCurrentArea == LOC_MORTUARY) // we dont care if they AF'd here, they raise in same place with same cost
	{	int iHD = GetHitDice(xPC);
   		if (iHD > 3)
   		{	cGPpen = (iHD-3)*50;	}
		else
		{	cGPpen = iHD*15;	}
		
		if (cGPpen > 700)
		{	cGPpen = 700;	}
	
		xStart = GetLocation(xPC);
		AssignCommand(xPC, TakeGoldFromCreature(cGPpen, xPC, TRUE, TRUE));
		FloatingTextStringOnCreature("A dustman approaches and rummages in your pockets removing some gold from your pouch.", xPC, FALSE, 5.0);
		DelayCommand(5.0,FloatingTextStringOnCreature("He then places a Coin of Life in your mouth and as the magic takes effect you are revived.", xPC, FALSE, 5.0));
	}
	else 
	// basically regardless of AF or location cost is standard
	// and this will kick in even if you are in the arena assuming you AF'd there.
	{	ApplyRespawnPenalties(xPC);  }
  
   //Resurrect at start location
   ApplyEffectToObject(DURATION_TYPE_INSTANT,xRez,xPC,0.0f);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,xHeal,xPC,0.0f);
   RemoveEffects(xPC); //Removes Negative effects. Is defined in nw_i0_plot.
   
   // fixes for respawning with effects from Samurai or shield
   	if (GetLevelByClass(CLASS_TYPE_SAMURAI, xPC) > 1) // because they get at level 2.
	{	Samurai_Two_Swords_As_One(xPC); 	}
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, xPC);
	if (GetIsObjectValid(oShield))
	{	int iBaseItemType = GetBaseItemType(oShield);
		if (iBaseItemType == BASE_ITEM_TOWERSHIELD || iBaseItemType == BASE_ITEM_LARGESHIELD || iBaseItemType == BASE_ITEM_SMALLSHIELD)
		{	DoShieldBonus(xPC, iBaseItemType);		}
	}
   
   	AssignCommand(xPC,ActionJumpToLocation(xStart));
	PS_CalculateECL(xPC);
}

void main() {
	object oPC = GetLastRespawnButtonPresser();
	
	// THIS LINE IS TO HANDLE A BUG IN v1.0, v1.01, v1.02
	// WHERE THE OnPlayerRespawn EVENT WAS ONLY FIRING THE SCRIPT "gui_death_respawn_self"
	if (oPC == OBJECT_INVALID)
	{	oPC = GetLocalObject(GetModule(), "LAST_RESPAWN_BUTTON_PRESSER");	}
		
	// IF THE oPC OBJECT IS STILL INVALID, THEN  gui_death_respawn_self  IS NOT BEING CALLED FOR SOME REASON
	if (oPC == OBJECT_INVALID)
	{	return;		}
	
	//Mark that you have died
	//And record how many HD you had
	string sID = PS_GetCharID(oPC);
	if (GetPermanentInt(sID, "FirstDeath") == 0) {
		int nHD = GetHitDice(oPC);
		SetPermanentInt(sID, "FirstDeath", nHD);
		SetLocalInt(oPC, "FirstDeath", 1);
		AddAchievement(oPC, 9);
	}
	
	CheckArenaFight(oPC);
		
	respawn(oPC);
}