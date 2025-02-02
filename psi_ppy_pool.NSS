//::///////////////////////////////////////////////
//:: Power Point Pool
//:: psi_pp_pool
//:://////////////////////////////////////////////
/*
    A Psychic Warrior ability to manifest powers is limited by the power points he has available. 
	This script determines how many power points a psion starts the day with (after resting)
	while taking into account bonuses granted via feats and Wisdom score.
	
	Future additions will likely include items which grant bonuses to power point pool, as 
	well as possible small racial bonuses for Githyanki, Githzerai, Duergar, and Illithid.
	
*/
//:://////////////////////////////////////////////
//:: Created By: edmaster44
//:: Created On: March 18, 2021
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "psi_inc_psifunc"
#include "aaa_constants"

void main()
{
	
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	
	
	if (PS_GetLocalInt(OBJECT_SELF, "PSI_PP") == 0 || PS_GetLocalInt(OBJECT_SELF, "PSI_PP") != 0 && GetLastPCRested() == OBJECT_SELF)
	//This keeps the power point total from replenishing automatically on leveling. Done to prevent leveling during battle
	//as an exploit to regain lost power points.
	    if (!GetHasSpellEffect(GetSpellId(), oTarget) && !GetIsInCombat(OBJECT_SELF))
		{
			int nPP = PS_GetLocalInt(OBJECT_SELF, "PSI_PP");
			int i = 1;
			object oPC = OBJECT_SELF;
			//Defines the local variable that will represent power points.
			int nPsion = GetLevelByClass(CLASS_PSYCHIC_WARRIOR,OBJECT_SELF);
			int nWarmind = GetLevelByClass(CLASS_TYPE_WARMIND,OBJECT_SELF);
			int nGem =	GetLevelByClass(CLASS_TYPE_DRAGON_PSION,OBJECT_SELF);
			nPsion = nPsion + nWarmind + nGem;
			//Determines level in psion class.
			int nPPvalue;
			int nWisdomBonus = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
			int nPPBonus = nWisdomBonus * (nPsion)/2;
			
			//Calculates bonus power points based on Wisdom score. This is per
			//3.5 sourcebooks.
			if (GetHasFeat(2862, OBJECT_SELF))
			{
				nPPBonus = nPPBonus + 4;
				//Psionic Heritage gateway feat grants a bonus of 4 power points.
			}
			//Checking for items that provide bonus power points when equipped.
			for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
		    {
		        object oEquipedItem = GetItemInSlot(i, oPC);
		       
		        if(GetResRef(oEquipedItem) == "ps_staff_mindsilver1")
				{
					nPPBonus = nPPBonus +10;
				}
				if(GetResRef(oEquipedItem) == "ps_staff_mindsilver2")
				{
					nPPBonus = nPPBonus +20;
				}
				if(GetResRef(oEquipedItem) == "ps_staff_mindsilver3")
				{
					nPPBonus = nPPBonus +30;
				}
				if(GetResRef(oEquipedItem) == "ps_staff_mindsilver4")
				{
					nPPBonus = nPPBonus +40;
				}
				if(GetResRef(oEquipedItem) == "ps_staff_mindsilver5")
				{
					nPPBonus = nPPBonus +50;
				}
		    }
			
			switch (nPsion)
			{
				case 1: 
				{
					nPPvalue = 1 + nPPBonus;
					break;
				}
				case 2:
				{
					nPPvalue = 2 + nPPBonus;
					
					break;
				}
				case 3:
				{
					nPPvalue = 4 + nPPBonus;
					break;
				}
				case 4:
				{
					nPPvalue = 6 + nPPBonus;			
					break;
				}
				case 5:
				{
					nPPvalue = 8 + nPPBonus;
					break;
				}
				case 6:
				{
					nPPvalue = 12 + nPPBonus;
					break;
				}
				case 7:
				{
					nPPvalue = 16 + nPPBonus;
					break;
				}
				case 8:
				{
					nPPvalue = 20 + nPPBonus;
					break;
				}
				case 9:
				{
					nPPvalue = 24 + nPPBonus;
					break;
				}
				case 10:
				{
					nPPvalue = 28 + nPPBonus;
					break;
				}
				case 11:
				{
					nPPvalue = 36 + nPPBonus;
					break;
				}
				case 12:
				{
					nPPvalue = 44 + nPPBonus;
					break;
				}
				case 13:
				{
					nPPvalue = 52 + nPPBonus;
					break;
				}
				case 14:
				{
					nPPvalue = 60 + nPPBonus;
					break;
				}
				case 15:
				{
					nPPvalue = 68 + nPPBonus;
					break;
				}
				case 16:
				{
					nPPvalue = 80 + nPPBonus;
					break;
				}
				case 17:
				{
					nPPvalue = 92 + nPPBonus;
					break;
				}
				case 18:
				{
					nPPvalue = 104 + nPPBonus;
					break;
				}
				case 19:
				{
					nPPvalue = 116 + nPPBonus;
					break;
				}
				case 20:
				{
					nPPvalue = 128 + nPPBonus;
					break;
				}
				case 21:
				{
					nPPvalue = 140 + nPPBonus;
					break;
				}
				case 22:
				{
					nPPvalue = 152 + nPPBonus;
					break;
				}
				case 23:
				{
					nPPvalue = 164 + nPPBonus;
					break;
				}
				case 24:
				{
					nPPvalue = 176 + nPPBonus;
					break;
				}
				case 25:
				{
					nPPvalue = 188 + nPPBonus;
					break;
				}
				case 26:
				{
					nPPvalue = 200 + nPPBonus;
					break;
				}
				case 27:
				{
					nPPvalue = 212 + nPPBonus;
					break;
				}
				case 28:
				{
					nPPvalue = 224 + nPPBonus;
					break;
				}
				case 29:
				{
					nPPvalue = 236 + nPPBonus;
					break;
				}
				case 30:
				{
					nPPvalue = 248 + nPPBonus;
					break;
				}
				//Power point totals based on psion level. Power point total plateaus at level 20.
			}
	 if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >0 )
	{
		   nPPBonus= nPPBonus +2 ;
	}

		       if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >1)
		    {
		    	nPPBonus= nPPBonus + 5;
		    }
   			if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >2)
		    {
		    	nPPBonus= nPPBonus +9 ;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >3)
		    {
		    	nPPBonus= nPPBonus +14;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >4)
		    {
		    	nPPBonus= nPPBonus +20 ;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >5)
		    {
		    	nPPBonus= nPPBonus +28;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >6)
		    {
		    	nPPBonus= nPPBonus +37 ;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >7 )
		    {
		    	nPPBonus= nPPBonus +47;
		    }
   if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) >8 )
	{
		    	nPPBonus= nPPBonus +58;
	   }

		if (GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF) > 9 )
		    {
		    	nPPBonus= nPPBonus +70;
		    }			
			if (GetHasFeat(21417, OBJECT_SELF))
			{
				int nPPExpand = nPPvalue/10;
				if(GetHasFeat(21418, OBJECT_SELF))
				{
					nPPExpand = nPPExpand * 2;
				}
				nPPvalue = nPPvalue + nPPExpand;
				//Checks for 'Expanded Power Point Pool I and II' feats. EPPP I grants a 10% bonus to
				//power point pool, while EPPP II increases this bonus to 20%.
			}
			if (GetHasFeat(21413, oPC))
   			{	
				int nPowerPen = FeatAdd(oPC, 36, FALSE, TRUE, FALSE);
     			FeatRemove(oPC, 21413);
     			nPowerPen = TRUE;
			}
			if (GetHasFeat(21414, oPC))
   			{	
				int nPowerGrPen = FeatAdd(oPC, 401, FALSE, TRUE, FALSE);
     			FeatRemove(oPC, 21414);
     			nPowerGrPen = TRUE;
			}
			if (GetHasFeat(21415, oPC))
   			{	
				int nPowerEpPen = FeatAdd(oPC, 618, FALSE, TRUE, FALSE);
     			FeatRemove(oPC, 21415);
     			nPowerEpPen = TRUE;
			}
			//Manifester Tier
			//int nPsion2 = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, OBJECT_SELF);
			
			
			/*
			if (!GetHasFeat(21464, oPC) && nPsion2 > 0)
			{
				int nProgI = FeatAdd(OBJECT_SELF, 21464, TRUE, TRUE, FALSE);
				nProgI == TRUE;
			}
			if (!GetHasFeat(21465, oPC) && nPsion2 > 2)
			{
				int nProgII = FeatAdd(OBJECT_SELF, 21465, TRUE, TRUE, FALSE);
				nProgII == TRUE;
			}
			if (!GetHasFeat(21466, oPC) && nPsion2 > 6)
			{
				int nProgIII = FeatAdd(OBJECT_SELF, 21466, TRUE, TRUE, FALSE);
				nProgIII == TRUE;
			}
			if (!GetHasFeat(21467, oPC) && nPsion2 > 9)
			{
				int nProgIV = FeatAdd(OBJECT_SELF, 21467, TRUE, TRUE, FALSE);
				nProgIV == TRUE;
			}
			if (!GetHasFeat(21468, oPC) && nPsion2 > 12)
			{
				int nProgV = FeatAdd(OBJECT_SELF, 21468, TRUE, TRUE, FALSE);
				nProgV == TRUE;
			}
			if (!GetHasFeat(21469, oPC) && nPsion2 > 16)
			{
				int nProgVI = FeatAdd(OBJECT_SELF, 21469, TRUE, TRUE, FALSE);
				nProgVI == TRUE;
			}
			*/
			
			
			//

			
			PS_SetLocalInt(OBJECT_SELF, "PSI_PP", nPPvalue);
			PS_SetLocalInt(OBJECT_SELF, "PSI_PP_MAX", nPPvalue);
			SendMessageToPC(OBJECT_SELF, "Power Point Pool:  " + IntToString(nPPvalue));
			
			//The following populates the player's screen with a GUI (full credit for development to MimiFearthegn)
			//to keep track of running power point total:
			
			//Put the below command wherever you need the screen to pop up:
			DisplayGuiScreen(OBJECT_SELF, "SCREEN_SPIRITBAR_PSION", FALSE, "powerpointscreen.xml");
			
			//Use the below command to update your powerpoints
			nPP = PS_GetLocalInt(OBJECT_SELF, "PSI_PP");
			SetGUIObjectText(OBJECT_SELF, "SCREEN_SPIRITBAR_PSION", "PPRatioTXT", -1, IntToString(nPPvalue));
			
			
		}
		
		
		
}