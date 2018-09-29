
// script_name: hss_fishing_inc
	
// Name_Date: Heed, Dec. 9th, 2006

/*
	Description:
*/

/*  >>>>>>>>>>>>>>>>>>>>>>>>>>    FISHING    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Freshwater:                   TAG          VALUE               ROLL     CHANCE       BITWISE

Mud Sunfish           -- HSS_FISH_MSF    -- 600gp  *            100        1             1
River Eel             -- HSS_FISH_EEL    -- 300gp   **           98-99      2             2
Salmon                -- HSS_FISH_SAL    -- 200gp   ***          95-97      3             4
Catfish               -- HSS_FISH_CAT    -- 150gp   ****         90-94      5             8
Green Sunfish         -- HSS_FISH_GSF    -- 125gp   *****        84-89      6             16
Large mouth bass      -- HSS_FISH_LMBS   -- 100gp   ******       76-83      8             32
Rainbow Trout         -- HSS_FISH_RTR    -- 75gp   *******      66-75      10            64
Golden Trout          -- HSS_FISH_GTR    -- 50gp   ********     51-65      15            128
Brown Trout           -- HSS_FISH_BTR    -- 50gp   **********   26-50      25            256
Silver Perch          -- HSS_FISH_SPR    -- 50gp   **********   26-50      25            512
Crayfish              -- HSS_FISH_CFH    -- 25gp   ***********  1-25       25            1024
River carp            -- HSS_FISH_RCP    -- 25gp   ***********  1-25       25            2048



Saltwater:

Red Breast Grunt      -- HSS_FISH_RBGR   -- 600gp  *            100        1             1    
Tiger Shrimp          -- HSS_FISH_TSH    -- 400gp   **           98-99      2             2    
Small octopus         -- HSS_FISH_SOC    -- 300gp   ***          95-97      3             4    
Rock Crab             -- HSS_FISH_RCB    -- 200gp   ****         90-94      5             8    
Red Snapper           -- HSS_FISH_RSNP   -- 150gp   *****        84-89      6             16   
Stingray              -- HSS_FISH_SRAY   -- 100gp   ******       76-83      8             32   
Red Grouper           -- HSS_FISH_RGRP   -- 75gp   *******      66-75      10            64   
Emerald Grunt         -- HSS_FISH_EGR    -- 50gp   ********     51-65      15            128  
Rock Sea Bass         -- HSS_FISH_RSB    -- 50gp   **********   26-50      25            256  
Mottled grouper       -- HSS_FISH_MGRP   -- 25gp   **********   26-50      25            512  
Flounder              -- HSS_FISH_FLO    -- 25gp   ***********  1-25       25            1024 
White Grunt           -- HSS_FISH_WHG    -- 25gp   ***********  1-25       25            2048 

Bait:

HSS_BAIT_01

Fishing Rods:

HSS_FISH_ROD

Waypoint:

Fresh: HSS_FISH_F_G   last character can be G, A or P (good, average or poor)
Salt:  HSS_FISH_S_G


   >>>>>>>>>>>>>>>>>>>>>>>>>>> Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< 

Variables on the waypoint (its variable panel in the toolset):

HSS_MINCAST:  int, minimum cast distance from the PC

HSS_RANDCAST: int, max value for a random distance to be added to HSS_MINCAST

HSS_FISH_POPULATION: int, bitwise value used to exclude certain fish from
being caught at this waypoint spot.  Bitwise values for catches are listed
above in the last table column.  To exclude multiple fish types add their
bitwise values together and set that value on the waypoint.  Note that catches
will be bumped to valid fish types.  The search begins from that catch type
and works upward -- if no valid catch can be found the search will start
from the beginning (1gp fish) and work its way up through the list. This
means, depending on what you exclude, average catch values can be bumped
up or down too.  XP will still be awarded for "superior fishing skill" if
it's enabled -- it will just be based on the value of the fish that's been
bumped to. The actual catch chance is unaffected by exclusions as well as
the chance to receive XP for fishing skill.

  >>>>>>>>>>>>>>>>>>>>>>>>>> End Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< 

*/
	
#include "x0_i0_position"
#include "x2_inc_itemprop"

//void main(){}


/* >>>>>>>>>>>>>>>>>>>>>>>>>>> Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< */


//percentage chance that each cast will result in lost bait
//Default: 50
const int HSS_BAIT_LOSS_CHANCE = 25;

//percentage chance that no catch will be made (i.e. this value subtracted
//from 100 will yield the catch chance).  The difference between this value
//and HSS_BAIT_LOSS_CHANCE is the percentage chance of not catching
//something but KEEPING the bait to use again in another cast.
//Default: 80
const int HSS_NO_CATCH_CHANCE = 80;

//percentage chance that the fishing line will break if the PC rolls a
//1 on his catch roll. (i.e. PC rolls a 1 on a catch and then rolls again
//to see if the line has snapped -- a value of 1 would mean the PC needs
//to roll a 1 one a die 100 twice in a row)
//recommend this setting is a low value -- it just becomes annoying if it
//happens more often than rarely.
//Default: 20 
const int HSS_LINE_SNAP_CHANCE = 20;

//minimum length of time a cast will last in seconds
//Default: 30
const int HSS_MIN_CAST_TIME = 30;

//maximum random value amount in seconds added to the minimum cast time
//i.e. default of 60 means 1-60 will be added to HSS_MIN_CAST_TIME
//Default: 60
const int HSS_RANDOM_CAST_TIME = 60;

//the bonus to the catch roll from fishing at a good fishing spot
//spot quality is derived from the waypoint tag -- see above
//Default:  5
const int HSS_SPOT_BONUS_GOOD = 5;

//the penalty to the catch roll from fishing at a poor fishing spot
//spot quality is derived from the waypoint tag -- see above
//Default:  -10
const int HSS_SPOT_PENALTY_POOR = -10;

//the bonus given to catch type if it's raining
//Default:  5
const int HSS_RAIN_BONUS = 10;

//the bonus given to catch type if it's dusk or dawn
//Default:  5
const int HSS_DUSK_DAWN_BONUS = 5;

//the divisor used when calculating the bonus given for ranks in the
//survival skill. The skill rank is divided by this value to determine
//the bonus given.  Another way to say it is that for every
//HSS_SURVIVAL_BONUS_DIVISOR ranks the PC has will add a +1 bonus. So, the
//default value of 5 means for every 5 ranks in survival a +1 bonus is given.
//Default: 5
const int HSS_SURVIVAL_BONUS_DIVISOR = 3;

//can either be a 1 or a 0.  1 means XP is granted for catching a rare fish
//and 0 means no XP is given.
//Default: 1
const int HSS_DO_XP_FOR_RARE_FISH = 1;

//can either be 1 or 0.  If 1 it enables the chance that a prized specimen
//can be caught.
const int HSS_ALLOW_PRIZED_SPECIMENS = 1;

//the "one chance in..." for a prized specimen catch.  (i.e. a value of
//1000 means there is 1 chance in 1000 that the catch will be a prized
//specimen. Recommend a high setting here -- should be very unique.
//Default: 1000
const int HSS_PRIZED_SPECIMEN_CHANCE = 500;

//the XP reward multiplier for catching a prized specimen. Do XP for rare
//fish must be on as well as allow prized specimens.
//Default: 5
const int HSS_PRIZED_SPECIMEN_MULTIPLIER = 5;

//the colour that feedback text is given in
const string HSS_FEEDBACK_COLOUR = "<color=LightSeaGreen>";

//debug constant enabling sure catches and stuff
//Default: 0
const int HSS_FISH_DEBUG = 0;

/* ___________________________ Catch Resrefs _____________________________ */

const string HSS_FISH_FRESH_2048 = "hss_fish_rcp";
const string HSS_FISH_FRESH_1024 = "hss_fish_cfh";
const string HSS_FISH_FRESH_512  = "hss_fish_spr";
const string HSS_FISH_FRESH_256  = "hss_fish_btr";
const string HSS_FISH_FRESH_128  = "hss_fish_gtr";
const string HSS_FISH_FRESH_64   = "hss_fish_rtr";
const string HSS_FISH_FRESH_32   = "hss_fish_lmbs";
const string HSS_FISH_FRESH_16   = "hss_fish_gsf";
const string HSS_FISH_FRESH_8    = "hss_fish_cat";
const string HSS_FISH_FRESH_4    = "hss_fish_sal";
const string HSS_FISH_FRESH_2    = "hss_fish_eel";
const string HSS_FISH_FRESH_1    = "hss_fish_msf";

const string HSS_FISH_SALT_2048  = "hss_fish_whg";
const string HSS_FISH_SALT_1024  = "hss_fish_flo";
const string HSS_FISH_SALT_512   = "hss_fish_mgrp";
const string HSS_FISH_SALT_256   = "hss_fish_rsb";
const string HSS_FISH_SALT_128   = "hss_fish_egr";
const string HSS_FISH_SALT_64    = "hss_fish_rgrp";
const string HSS_FISH_SALT_32    = "hss_fish_sray";
const string HSS_FISH_SALT_16    = "hss_fish_rsnp";
const string HSS_FISH_SALT_8     = "hss_fish_rcb";
const string HSS_FISH_SALT_4     = "hss_fish_soc";
const string HSS_FISH_SALT_2     = "hss_fish_tsh";
const string HSS_FISH_SALT_1     = "hss_fish_rbgr";

/* ___________________________ Catch Resrefs _____________________________ */


/* >>>>>>>>>>>>>>>>>>>>>>>> End Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< */



/* >>>>>>>>>>>>>>>>>>>>>>> Function Prototypes <<<<<<<<<<<<<<<<<<<<<<<<<<<< */


//function for the on_activate of the fishing rod
void HSS_DoCast(object oPC, object oRod);

//function that determines if something is caught
void HSS_DoCatch(object oPC, object oBait, object oRod, object oWay);

//function that determines the actual catch 
string HSS_DetermineCatch(int nRoll, string sWater, object oWay, int nCatchLevel = -1, int nRuns = 1);

//determine the feedback and then call the IfFishing functions.
void HSS_DoFishingFeedback(object oPC, int nCastTime, location lCast, effect eSplash, int nMinCast, string sSender, int nCastID);

//Get the distance between two object that ignores the z axis differences
float HSS_GetDistanceBetweenNoZ(object oObjectA, object oObjectB);

//do fishing feedback effect if PC is still fishing
void HSS_DoFishingEffectIfFishing(object oPC, effect eSplash, location lAnim, string sSender, int nCastID);

//do fishing feedback text if PC is still fishing
void HSS_DoFishingFeedbackIfFishing(object oPC, string sMsg, string sSender, int nCastID);

//returns true if nFlag has been set -- otherwise returns false.
int HSS_GetBitwiseFlag(int nFlag, object oTarget, string sVar);

//adds the unique power use to a fishing rod that doesn't have that power
void HSS_DoFishingLineUse(object oUser, object oTarget);


/* >>>>>>>>>>>>>>>>>>>>> Function Implementation <<<<<<<<<<<<<<<<<<<<<<<<<<<< */


void HSS_DoCatch(object oPC, object oBait, object oRod, object oWay)
{
   string sWay = GetTag(oWay);
   string sSpotType = GetStringRight(sWay, 1);
   int nSurvival = GetSkillRank(SKILL_SURVIVAL, oPC);
   int nBonus;
 
   //remove the cast ID
   DeleteLocalInt(oPC, "HSS_CAST_ID");

   //bonus/penalty for spot quality   
   if (sSpotType == "G")
      {
      nBonus = HSS_SPOT_BONUS_GOOD;
      }
   else if (sSpotType == "P")
      {
      nBonus = HSS_SPOT_PENALTY_POOR;
      }

   //every HSS_SURVIVAL_BONUS_DIVISOR ranks in survival gives a +1
   //bonus to the catch chance	    
   if (nSurvival > 0)
      {
	  nBonus = nBonus + (nSurvival / HSS_SURVIVAL_BONUS_DIVISOR);
	  }
	  
   int nPercent = d100();	  
   int nRoll = nPercent + nBonus;
   object oCatch;
   object oTempCatch;
   int nBaitSS = GetItemStackSize(oBait);
   string sWater = GetSubString(sWay, 9, 1);
   string sCatch;   
   
	  //debug
	  if (HSS_FISH_DEBUG)
	     {
		 nRoll = 100;
		 }    

   if (nRoll <= HSS_BAIT_LOSS_CHANCE)
      {
      //stack code -- stackable bait now
	  if (nBaitSS > 1)
	     {
		 SetItemStackSize(oBait, nBaitSS - 1);
		 }
		 else
		 {
		 DestroyObject(oBait);
		 }
		 
	  //line snap -- need to roll a 1 on the catch and then roll again
	  //against HSS_LINE_SNAP_CHANCE									
	  if (nPercent == 1 && HSS_LINE_SNAP_CHANCE > 0)
	     {
		 if (d100() <= HSS_LINE_SNAP_CHANCE)
		    {
			IPRemoveMatchingItemProperties(oRod, ITEM_PROPERTY_CAST_SPELL,
			                              DURATION_TYPE_PERMANENT);					  
			SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + 
			"Your fishing line has snapped.");
			AssignCommand(oPC, PlaySound("cb_sw_whip2"));
			return;
			}
		 }		 
		 	  
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You lost your bait to a " +
	  "fish or it was snagged on something.");
      AssignCommand(oPC, PlaySound("fs_water_hard2"));
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
	                1.0, 6.0));
	 				
      return;
      }

   if (nRoll > HSS_BAIT_LOSS_CHANCE && nRoll <= HSS_NO_CATCH_CHANCE)
      {
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You didn't catch anything.");
      AssignCommand(oPC, PlaySound("fs_water_hard2"));
      return;
      }

   //if we roll over HSS_NO_CATCH_CHANCE then we caught something
   // -- roll again to see what

   //reset the bonus as we now have a different set of bonus conditions   
   nBonus = 0;
   int nWeather = GetWeather(GetArea(oPC),WEATHER_TYPE_RAIN);
      
   //dawn/dusk or rain ups the chance the rare fish will be out
   if (GetIsDawn() || GetIsDusk())
      {
      nBonus = HSS_DUSK_DAWN_BONUS;
      } 

   if (nWeather > WEATHER_POWER_OFF)
      {
      nBonus = nBonus + HSS_RAIN_BONUS;
      }
	  	  	     
   nPercent = d100();	  
   nRoll = nPercent + nBonus;

   //debug -- set specific catches here
   //if (HSS_FISH_DEBUG)
      //{
	  //nRoll = 95;
	  //}   

   sCatch = HSS_DetermineCatch(nRoll, sWater, oWay);
	  	  
	 //stack code -- bait is now stackable
	  if (nBaitSS > 1)
	     {
		 SetItemStackSize(oBait, nBaitSS - 1);
		 }
		 else
		 {
		 DestroyObject(oBait);
		 }

	  if (Random(HSS_PRIZED_SPECIMEN_CHANCE) == 0 && 
	     HSS_ALLOW_PRIZED_SPECIMENS == 1)
	     {
		 //need to work in a temp container first to avoid stacking weirdness
		 oTempCatch = CreateItemOnObject(sCatch, IPGetIPWorkContainer(oPC));
		 itemproperty ipPrized = ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_5_LBS);
		 AddItemProperty(DURATION_TYPE_PERMANENT, ipPrized, oTempCatch);
 
		 		 
		 SetFirstName(oTempCatch, "Prized " + GetFirstName(oTempCatch));
		 //broken function here (1.03 beta) -- does nothing...bah
		 SetDescription(oTempCatch, GetDescription(oTempCatch) + "  This is" +
		 " a particularly large and healthy specimen.");
		 
		 oCatch = CopyItem(oTempCatch, oPC, TRUE);
		 DestroyObject(oTempCatch);
		 }
		 else
		 {		 
	     oCatch = CreateItemOnObject(sCatch, oPC);
		 }

	  		 
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR +
	  "You caught a(n) " + GetName(oCatch) + ".");
      AssignCommand(oPC, PlaySound("fs_water_hard2"));
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
	                1.0, 6.0));


      //do some xp for the rarer types
      int nGold = GetGoldPieceValue(oCatch);
      int nStack = GetItemStackSize(oCatch);
      int nValue = nGold / nStack;
	  
	  if (Random(HSS_PRIZED_SPECIMEN_CHANCE) == 0 && 
	     HSS_ALLOW_PRIZED_SPECIMENS == 1 && HSS_DO_XP_FOR_RARE_FISH)	 
		 {
		 	 int nCurrent = GetLocalInt(oPC,"FISH_XP");
		 	nValue = nValue * HSS_PRIZED_SPECIMEN_MULTIPLIER;
			if(nCurrent < 1251){
	         	GiveXPToCreature(oPC, nValue);
				SetLocalInt(oPC,"FISH_XP", nCurrent+nValue);
			}
			else{
				SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You have hit the XP cap per reset.  No xp granted");
			}
    	     SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + 
			 "You displayed extraordinary fishing skills landing this fine specimen, what a lunker!");
		 	return;		 
		 }	  

      if (nRoll > 1 && HSS_DO_XP_FOR_RARE_FISH)
         {
		 	int nCurrent = GetLocalInt(oPC,"FISH_XP");
			if(nCurrent < 1251){
	         	GiveXPToCreature(oPC, nValue);
				SetLocalInt(oPC,"FISH_XP", nCurrent+nValue);
			}
			else{
				SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You have hit the XP cap per reset.  No xp granted");
			}
         	SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + 
		 	"You displayed superior fishing skills, what a catch!.");
         }
}


void HSS_DoCast(object oPC, object oRod)
{
   //clear out the queue, so no casting spam.
   AssignCommand(oPC, ClearAllActions());  

   object oBait = GetItemPossessedBy(oPC, "HSS_BAIT_01");

   if (!GetIsObjectValid(oBait))
      {
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need bait to fish.");
      return;
      }

   object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC);
   float fDist = HSS_GetDistanceBetweenNoZ(oPC, oWay);
   string sWay = GetTag(oWay);   
   string sFishWay = GetStringLeft(sWay, 8);
   object oFisher = GetLocalObject(oWay, "HSS_FISHERMAN");
   int nMinCast = GetLocalInt(oWay, "HSS_MINCAST");
   int nRandCast = GetLocalInt(oWay, "HSS_RANDCAST");
    
   if ((sFishWay != "HSS_FISH") || fDist > 12.0)
      {
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "There doesn't appear " +
	  "to be a good spot to fish nearby.");
      return;
      }

   if (GetIsObjectValid(oFisher) && oFisher != oPC)
      {
      if (HSS_GetDistanceBetweenNoZ(oFisher, oWay) > 1.25)
         {
         DeleteLocalObject(oWay, "HSS_FISHERMAN");
         }
         else
         {
         SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + 
		 "This spot seems occupied already.");
         return;
         }
      }

   if (!GetIsObjectValid(oFisher))
      {
      SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + 
	  "You spy a good fishing spot.");
      }


   AssignCommand(oPC, ActionMoveToObject(oWay, FALSE, 0.0));
   AssignCommand(oPC, ActionDoCommand(SetFacing(GetFacing(oWay))));

   AssignCommand(oPC, ActionDoCommand(SetLocalObject(oWay, "HSS_FISHERMAN", oPC)));   
  
   int nCastTime = HSS_MIN_CAST_TIME + (Random(HSS_RANDOM_CAST_TIME) + 1);

   effect eSplash = EffectNWN2SpecialEffectFile("fx_hss_fishing");
   //object oFisher =OBJECT_SELF;
   //PlayCustomAnimation(oFisher, "FISHINGCAST", 0);
   float fDir = GetNormalizedDirection(GetFacing(oWay));
   float fRanAngle = IntToFloat(Random(30) - Random(30));
   float fRanDist = IntToFloat(nMinCast + Random(nRandCast));
   location lCast = GenerateNewLocation(oWay, fRanDist, fDir + fRanAngle, 0.0);
   string sSender = ObjectToString(oWay);
   int nCastID = Random(65535) + Random(65535);
   
   AssignCommand(oPC, ActionDoCommand(SetLocalInt(oPC,
                "HSS_CAST_ID", nCastID)));   
   
   //cool new NWN2 projectile functions 
   AssignCommand(oPC, ActionDoCommand(SpawnItemProjectile
   (oPC, OBJECT_INVALID, GetLocation(oPC), lCast, BASE_ITEM_SHURIKEN,
   PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_MISS, DAMAGE_TYPE_SONIC)));  

   //cool new NWN2 projectile functions
   AssignCommand(oPC, ActionWait(GetProjectileTravelTime(GetLocation(oPC),
   lCast, PROJECTILE_PATH_TYPE_DEFAULT, SPELL_TRAP_SHURIKEN)));   
      
   AssignCommand(oPC, ActionDoCommand(ApplyEffectAtLocation
   (DURATION_TYPE_INSTANT, eSplash, lCast)));  

   AssignCommand(oPC, ActionDoCommand(HSS_DoFishingFeedback(oPC, nCastTime,
   lCast, eSplash, nMinCast, sSender, nCastID)));   
 
   AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.0,
   IntToFloat(nCastTime))); 

   AssignCommand(oPC, ActionDoCommand(HSS_DoCatch(oPC, oBait, oRod, oWay)));
}

string HSS_DetermineCatch(int nRoll, string sWater, object oWay, int nCatchLevel = -1, int nRuns = 1)
{
  string sCatch;
      
  if (nCatchLevel == -1)
     {  
     if (nRoll > 0 && nRoll <= 25)
        {
        if (d2() == 1)
           {
		   nCatchLevel = 2048;
           }
           else
           {
		   nCatchLevel = 1024;
           }
         }
      else
	  if (nRoll > 25 && nRoll <= 50)
         {
         if (d2() == 1)
            {
			nCatchLevel = 512;
            }
            else
            {
			nCatchLevel = 256;
            }
         }
      else
	  if (nRoll > 50 && nRoll <= 65)
         {
		 nCatchLevel = 128;
         }
      else
	  if (nRoll > 65 && nRoll <= 75)
         {
		 nCatchLevel = 64;
         }
      else
	  if (nRoll > 75 && nRoll <= 83)
         {
		 nCatchLevel = 32;
         }
      else
	  if (nRoll > 83 && nRoll <= 89)
         {
		 nCatchLevel = 16;
         }
      else
	  if (nRoll > 89 && nRoll <= 94)
         {
		 nCatchLevel = 8;
         }
      else
	  if (nRoll > 94 && nRoll <= 97)
         {
		 nCatchLevel = 4;
         }
      else
	  if (nRoll > 97 && nRoll <= 99)
         {
		 nCatchLevel = 2;
         }
         else
         {
		 nCatchLevel = 1;
         }
   }
   
   switch (nCatchLevel)
      {
	  //all of these possible fall throughs are deliberate
	  case 2048:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_2048;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_2048;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 2048 to 1024.");
		    }				 
		 nCatchLevel = 1024;
		 }
		 
	  case 1024:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_1024;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_1024;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 1024 to 512.");
		    }		 
		 nCatchLevel = 512;
		 }		 
		 
	  case 512:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_512;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_512;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 512 to 256.");
		    }		 
		 nCatchLevel = 256;
		 }		 
		 
	  case 256:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_256;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_256;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 256 to 128.");
		    }		 
		 nCatchLevel = 128;
		 }		 
		 
	  case 128:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_128;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_128;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 128 to 64.");
		    }		 
		 nCatchLevel = 64;
		 }		 		 		 			 		 
	  
	  case 64:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_64;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_64;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 64 to 32.");
		    }		 
		 nCatchLevel = 32;
		 }		 
		 
	  case 32:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_32;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_32;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 32 to 16.");
		    }		 
		 nCatchLevel = 16;
		 }		 

	  case 16:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_16;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_16;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 16 to 8.");
		    }		 
		 nCatchLevel = 8;
		 }		 

	  case 8:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_8;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_8;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 8 to 4.");
		    }		 
		 nCatchLevel = 4;
		 }	
		 	 
	  case 4:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_4;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_4;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 4 to 2.");
		    }		 
		 nCatchLevel = 2;
		 }		 

	  case 2: 	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_2;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_2;
			}		 
		 break;	
	     }
		 else
		 {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Falling through from " + 
		    "catch level 2 to 1.");
		    }		 
		 nCatchLevel = 1;
		 }		 
		 
	  case 1:	  
	  if (!HSS_GetBitwiseFlag(nCatchLevel, oWay, "HSS_FISH_POPULATION"))
		 {
		 if (sWater == "F")
		    {
			sCatch = HSS_FISH_FRESH_1;
			}
		 else
		 if (sWater == "S")
			{
			sCatch = HSS_FISH_SALT_1;
			}		 
		 break;	
	     }
		 else
		 {
		 break;
		 }	 		 
		 		 		 		 		 		 		 		 		 			 		 		 			 		 
	  }	 

	  //we still have no resref, so we missed it from this starting
	  //position -- call again starting at the very beginning.
	  //only called once more then we return ""  	  
	  if (sCatch == "" && nRuns == 1)
	     {
	     //debug
	     if (HSS_FISH_DEBUG)
	        {
		    SendMessageToAllDMs("HSS_FISHING: Second call to " + 
		    "HSS_DetermineCatch().");
		    }		 
		 sCatch = HSS_DetermineCatch(nRoll, sWater, oWay, 2048, 2);
		 }
		 
	  //log any failed resrefs		 
	  if (sCatch == "")
	     {
		 WriteTimestampedLogEntry("HSS_FISHING: Failed resref " + 
		 "at catch level: " + IntToString(nCatchLevel) + ", Water: " + sWater);
		 SendMessageToAllDMs("HSS_FISHING: Failed resref " + 
		 "at catch level: " + IntToString(nCatchLevel) + ", Water: " + sWater);
		 }		  
	  	  
   return sCatch;	  
}


void HSS_DoFishingFeedback(object oPC, int nCastTime, location lCast, effect eSplash, int nMinCast, string sSender, int nCastID)
{
   int nMsg = Random(14);
   vector vCast = GetPositionFromLocation(lCast);   
   float fTimer;
   string sMsg1;
   string sMsg2;
   int nAnimEvent;
   location lAnim;
 
   switch (nMsg)
      {
	  case 0:
	  sMsg1 = "You feel a nibble on the line.";
	  sMsg2 = "You feel a tug on the line.";
	  break;
	  
	  case 1:
	  sMsg1 = "You see a fish jump.";
	  nAnimEvent = 1;
	  sMsg2 = "Your line goes taut.";
	  break;
	  	  
	  case 2:
	  sMsg1 = "You have something on the line!  It's fighting hard!";
	  nAnimEvent = 1;
	  
      switch (Random(5))
	     {
		 case 0:
		 sMsg2 = "Your line pulls to the left.";
		 break;
		 		 
		 case 1:
		 sMsg2 = "Your line goes slack.";
		 break;
		 
		 case 2:
		 sMsg2 = "Your line feels as if it may be snagged.";
		 break;

		 case 3:
		 sMsg2 = "Your line jerks violently!.";
		 break;
		 
		 case 4:
		 sMsg2 = "Your line pulls to the right.";
		 break;		 		 		 		 
		 }		 	  
 
	  break;
	  	  
	  case 3:
	  sMsg1 = "You feel a tug on the line.";
	  sMsg2 = "Your line goes taut.";
	  break;
	  	  
	  case 4:
	  sMsg1 = "Your line goes taut.";
	  sMsg2 = "You feel a nibble on the line.";	
	  break;
	  	  
	  case 5:
	  sMsg1 = "Your line goes slack.";
	  sMsg2 = "You see a fish jump.";
	  nAnimEvent = 2;
	  break;
	  	  
	  case 6:
	  sMsg1 = "Your line drifts slowly.";
	  sMsg2 = "You have something on the line!  It's fighting hard!";
	  nAnimEvent = 2;
	  break;
	  	  
	  case 7:
	  sMsg1 = "Your line feels as if it may be snagged.";
	  sMsg2 = "Your line drifts slowly.";
	  break; 
	  
	  case 8:
	  sMsg1 = "Your line pulls to the right.";
	  sMsg2 = "Your line goes slack.";
	  break;
	  
	  case 9:
	  sMsg1 = "Your line pulls to the left.";
	  sMsg2 = "Your line goes slack.";
	  break;
	  
	  case 10:
	  sMsg1 = "Your line jerks violently!";
	  sMsg2 = "Your line pulls to the left.";
	  break;
	  
	  case 11:
	  sMsg1 = "Your line jerks violently!";
	  sMsg2 = "Your line pulls to the right.";
	  break;
	  
	  case 12:
	  sMsg1 = "Your line lies dead in the water.";
	  sMsg2 = "Your line drifts slowly.";
	  break;
	  
	  case 13:
	  sMsg1 = "Your line lies dead in the water.";
	  sMsg2 = "Your line goes taut.";
	  break;	  	  	  	  	  	   	  	  	    	  	  	  
	  }	  
   
   if (nCastTime <= HSS_MIN_CAST_TIME + (HSS_RANDOM_CAST_TIME / 2))
      {
	  fTimer = IntToFloat(nCastTime / 2);
	  
	  if (nAnimEvent == 1)
	     {
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
		          IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer, HSS_DoFishingEffectIfFishing(oPC,
		 eSplash, lAnim, sSender, nCastID));			 
		 }
		 
      DelayCommand(fTimer, HSS_DoFishingFeedbackIfFishing(oPC, sMsg1, sSender, nCastID));	  
	  }
	  else
	  {
	  fTimer = IntToFloat(nCastTime / 3);
	  
	  if (nAnimEvent == 1)
	     {
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
		          IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer, HSS_DoFishingEffectIfFishing(oPC,
		 eSplash, lAnim, sSender, nCastID));			 
		 }
		 
	  if (nAnimEvent == 2)
		 {
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
		          IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer + fTimer, HSS_DoFishingEffectIfFishing(oPC,
		 eSplash, lAnim, sSender, nCastID));		 			
		 }
		 
	  DelayCommand(fTimer, HSS_DoFishingFeedbackIfFishing(oPC, sMsg1, sSender, nCastID));
	  DelayCommand(fTimer + fTimer, HSS_DoFishingFeedbackIfFishing(oPC, sMsg2, sSender, nCastID));	  		 	  
	  }
	  	  
}

void HSS_DoFishingEffectIfFishing(object oPC, effect eSplash, location lAnim, string sSender, int nCastID)
{
   object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC);
   float fDist = HSS_GetDistanceBetweenNoZ(oPC, oWay);
   object oFisher = GetLocalObject(oWay, "HSS_FISHERMAN");

   if (GetIsObjectValid(oFisher) && oFisher == oPC)
      {
	  if (HSS_GetDistanceBetweenNoZ(oFisher, oWay) < 1.0)
	     {
		 //as sure as we can be the PC should get this feedback		 
		 if (ObjectToString(oWay) == sSender &&
		    GetLocalInt(oPC, "HSS_CAST_ID") == nCastID)
		    {		 
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSplash, lAnim);
			}
					 
		 }

	  }	 	  
}

void HSS_DoFishingFeedbackIfFishing(object oPC, string sMsg, string sSender, int nCastID)
{
   object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC);
   float fDist = HSS_GetDistanceBetweenNoZ(oPC, oWay);
   object oFisher = GetLocalObject(oWay, "HSS_FISHERMAN");
 
   if (GetIsObjectValid(oFisher) && oFisher == oPC)
      {
	  if (HSS_GetDistanceBetweenNoZ(oFisher, oWay) < 1.0)
	     {
		 //as sure as we can be the PC should get this feedback
		 if (ObjectToString(oWay) == sSender &&
		    GetLocalInt(oPC, "HSS_CAST_ID") == nCastID)
		    {
			SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sMsg);
			}
			         		 
		 }
	  }	  
}

float HSS_GetDistanceBetweenNoZ(object oObjectA, object oObjectB)
{
   float fReturn = -1.0000;
   location lA = GetLocation(oObjectA);
   location lB = GetLocation(oObjectB);
   object oAreaA = GetAreaFromLocation(lA);
   object oAreaB = GetAreaFromLocation(lB);   
   
   if (oAreaA != oAreaB ||
      (!GetIsObjectValid(oObjectA) || !GetIsObjectValid(oObjectB)))
      {
	  return fReturn;
	  }
   
   vector vPosA = GetPositionFromLocation(lA);
   vector vPosB = GetPositionFromLocation(lB);
   float fAx = vPosA.x;
   float fAy = vPosA.y;   
   float fBx = vPosB.x;
   float fBy = vPosB.y;
   
   vPosA = Vector(fAx, fAy, 0.0);
   vPosB = Vector(fBx, fBy, 0.0);   
   lA = Location(oAreaA, vPosA, 0.0);
   lB = Location(oAreaB, vPosB, 0.0);
         	  	  
   fReturn = GetDistanceBetweenLocations(lA, lB);
    	  
	  
   return fReturn;   
}


int HSS_GetBitwiseFlag(int nFlag, object oTarget, string sVar)
{
   int nVar = GetLocalInt(oTarget, sVar);
	
   if (nVar & nFlag)
      {
      return TRUE;
      }
	  
   return FALSE;
}

void HSS_DoFishingLineUse(object oUser, object oTarget)
{
   //not a fishing rod or not a valid target
   if (GetTag(oTarget) != "HSS_FISH_ROD" ||
      GetObjectType(oTarget) != OBJECT_TYPE_ITEM
	  || !GetIsObjectValid(oTarget))
      {
	  SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
	                 "You can only attach this fishing line and hook " +
					 "to a fishing rod.");
	  return;				 
	  }

   //we have a fishing rod but it has a line attached	  	  
   if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_CAST_SPELL) &&
      GetTag(oTarget) == "HSS_FISH_ROD")
      {	 
	  SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
	                 "This fishing rod already has a line and hook " +
					 "attached.");
	  return;	  
	  }
	  
   //we have a fishing rod with no line and hook on it
   itemproperty ipRodUse = ItemPropertyCastSpell(
                           IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
						   IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
						   
   IPSafeAddItemProperty(oTarget, ipRodUse);
   SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
	              "You attach the line and hook to your fishing rod. " +
				  "You are now ready to fish.");   
   	   
}