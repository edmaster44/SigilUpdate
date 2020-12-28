//::///////////////////////////////////////////////
//:: Fury Pool
//:: fury_pool
//:://////////////////////////////////////////////
/*
   A Barbarian's ability to rage is limited by the fury they has available. 
	This script determines how much fury a barbarian starts the day with (after resting)
	while taking into account level and constitution score.
*/
//:://////////////////////////////////////////////
//:: Created By: Gwyn Gerlits
//:: Created On: December 27, 2020
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "psi_inc_psifunc"

void main()
{
	
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	//This keeps the fury total from replenishing automatically on leveling. Done to prevent leveling during battle
	//as an exploit to regain lost fury.
    if (GetLocalInt(OBJECT_SELF, "FURY_FP") == 0 || GetLocalInt(OBJECT_SELF, "FURY_FP") != 0 && GetLastPCRested() == OBJECT_SELF)

	    if (!GetHasSpellEffect(GetSpellId(), oTarget) && !GetIsInCombat(OBJECT_SELF))
		{
			//Defines the local variable that will represent fury.
			int nFury = GetLocalInt(OBJECT_SELF, "FURY_FP");
			int i = 1;
			object oPC = OBJECT_SELF;
			
			//Determines level in barbarian class.
			int iBarb = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
			int iBralani = GetLevelByClass(CLASS_TYPE_BRALANI_PRC,oPC);//Bralani
			int iSavage = GetLevelByClass(CLASS_TYPE_SAVAGE_MARAUDER_PRC,oPC);//Savage Marauder
			int iScaly = GetLevelByClass(CLASS_TYPE_SCALED_HUNTER_PRC,oPC);//Scaled Hunter
			int iHilly = GetLevelByClass(CLASS_TYPE_HILL_GIANT_PRC,oPC);//Hill Giant
			int iFrost = GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC,oPC);//Frost Giant PRC
			int iFrenzy = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER,oPC);//Frenized Berserker.
			int iTotal = iBarb + iBralani + iSavage + iFrost + iFrenzy +iScaly + iHilly;
			if (iBarb < 1) return;
			
			//Calculates bonus fury points based on Barbarian Level and Constitution score. 
			int nFvalue;
			int nConBonus = GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);
			int nFBonus = (30 + nConBonus) * ((iBarb/6) > 3)? 4 : ((iBarb/6)+1);

			
			SetLocalInt(OBJECT_SELF, "Fury_FP", nFvalue);
			SetLocalInt(OBJECT_SELF, "Fury_FP_MAX", nFvalue);
			SendMessageToPC(OBJECT_SELF, "Fury Pool:  " + IntToString(nFvalue));
			
			//The following populates the player's screen with a GUI (full credit for development to MimiFearthegn)
			//to keep track of running power point total:
			
			//Put the below command wherever you need the screen to pop up:
			DisplayGuiScreen(OBJECT_SELF, "SCREEN_FURYBAR_BARB", FALSE, "furyscreen.xml");
			
			//Use the below command to update your powerpoints
			nPP = GetLocalInt(OBJECT_SELF, "FURY_FP");
			SetGUIObjectText(OBJECT_SELF, "SCREEN_FURYBAR_BARB", "PPRatioTXT", -1, IntToString(nFvalue));
		}
}