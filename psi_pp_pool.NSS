//::///////////////////////////////////////////////
//:: Power Point Pool
//:: psi_pp_pool
//:://////////////////////////////////////////////
/*
    A psion’s ability to manifest powers is limited by the power points he has available. 
	This script determines how many power points a psion starts the day with (after resting)
	while taking into account bonuses granted via feats and Intelligence score.
	
	Future additions will likely include items which grant bonuses to power point pool, as 
	well as possible small racial bonuses for Githyanki, Githzerai, Duergar, and Illithid.
	
	This script is for the 'psion' class only. If Psychic Warrior is implemented, it will 
	have its own script.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: February 20, 2015
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
	
	
	if (PS_GetLocalInt(OBJECT_SELF, "PSI_PP") == 0 || PS_GetLocalInt(OBJECT_SELF, "PSI_PP") != 0 && GetLastPCRested() == OBJECT_SELF)
	//This keeps the power point total from replenishing automatically on leveling. Done to prevent leveling during battle
	//as an exploit to regain lost power points.
	    if (!GetHasSpellEffect(GetSpellId(), oTarget) && !GetIsInCombat(OBJECT_SELF))
		{
			int nPP = PS_GetLocalInt(OBJECT_SELF, "PSI_PP");
			int i = 1;
			object oPC = OBJECT_SELF;
			//Defines the local variable that will represent power points.
			int nPsion = GetLevelByClass(90, OBJECT_SELF);
			int nMentalist = GetLevelByClass(100, OBJECT_SELF);
			int nPsychicKnight = GetLevelByClass(109,OBJECT_SELF);
			int nCerebremancer = GetLevelByClass(152, OBJECT_SELF);
			int nPhyTheruge = GetLevelByClass(115,OBJECT_SELF);
			int nGem = GetLevelByClass(128, OBJECT_SELF);
			nPsion = nPsion + nMentalist + nCerebremancer + nGem + nPsychicKnight+ nPhyTheruge ;
			//Determines level in psion class.
			int nPPvalue;
			int nIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
			int nPPBonus = nIntBonus * (nPsion/2);
			//Calculates bonus power points based on Intelligence score. This is per
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
					nPPvalue = 6 + nPPBonus;
					break;
				}
				case 2:
				{
					nPPvalue = 14 + nPPBonus;
					
					break;
				}
				case 3:
				{
					nPPvalue = 23 + nPPBonus;
					break;
				}
				case 4:
				{
					nPPvalue = 33 + nPPBonus;			
					break;
				}
				case 5:
				{
					nPPvalue = 44 + nPPBonus;
					break;
				}
				case 6:
				{
					nPPvalue = 56 + nPPBonus;
					break;
				}
				case 7:
				{
					nPPvalue = 69 + nPPBonus;
					break;
				}
				case 8:
				{
					nPPvalue = 83 + nPPBonus;
					break;
				}
				case 9:
				{
					nPPvalue = 98 + nPPBonus;
					break;
				}
				case 10:
				{
					nPPvalue = 114 + nPPBonus;
					break;
				}
				case 11:
				{
					nPPvalue = 131 + nPPBonus;
					break;
				}
				case 12:
				{
					nPPvalue = 149 + nPPBonus;
					break;
				}
				case 13:
				{
					nPPvalue = 168 + nPPBonus;
					break;
				}
				case 14:
				{
					nPPvalue = 188 + nPPBonus;
					break;
				}
				case 15:
				{
					nPPvalue = 209 + nPPBonus;
					break;
				}
				case 16:
				{
					nPPvalue = 231 + nPPBonus;
					break;
				}
				case 17:
				{
					nPPvalue = 254 + nPPBonus;
					break;
				}
				case 18:
				{
					nPPvalue = 278 + nPPBonus;
					break;
				}
				case 19:
				{
					nPPvalue = 303 + nPPBonus;
					break;
				}
				case 20:
				{
					nPPvalue = 329 + nPPBonus;
					break;
				}
				case 21:
				{
					nPPvalue = 356 + nPPBonus;
					break;
				}
				case 22:
				{
					nPPvalue = 384 + nPPBonus;
					break;
				}
				case 23:
				{
					nPPvalue = 413 + nPPBonus;
					break;
				}
				case 24:
				{
					nPPvalue = 443 + nPPBonus;
					break;
				}
				case 25:
				{
					nPPvalue = 474 + nPPBonus;
					break;
				}
				case 26:
				{
					nPPvalue = 506 + nPPBonus;
					break;
				}
				case 27:
				{
					nPPvalue = 539 + nPPBonus;
					break;
				}
				case 28:
				{
					nPPvalue = 573 + nPPBonus;
					break;
				}
				case 29:
				{
					nPPvalue = 608 + nPPBonus;
					break;
				}
				case 30:
				{
					nPPvalue = 644 + nPPBonus;
					break;
				}
				//Power point totals based on psion level.
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
			int nPsion2 = GetLevelByClass(90, OBJECT_SELF);
			if (nMentalist > 1)
			{	nPsion2 = nPsion2 + (nMentalist - 1);	}
			if (nCerebremancer >= 1)
			{	nPsion2 = nPsion2 + nCerebremancer;	}
			if (nGem > 1)
			{	nPsion2 = nPsion2 + (nGem/2);	}
			
			
			if (!GetHasFeat(21425, oPC) && nPsion2 > 0)
			{
				int nProgI = FeatAdd(OBJECT_SELF, 21425, TRUE, TRUE, FALSE);
				nProgI == TRUE;
			}
			if (!GetHasFeat(21426, oPC) && nPsion2 > 2)
			{
				int nProgII = FeatAdd(OBJECT_SELF, 21426, TRUE, TRUE, FALSE);
				nProgII == TRUE;
			}
			if (!GetHasFeat(21427, oPC) && nPsion2 > 4)
			{
				int nProgIII = FeatAdd(OBJECT_SELF, 21427, TRUE, TRUE, FALSE);
				nProgIII == TRUE;
			}
			if (!GetHasFeat(21428, oPC) && nPsion2 > 6)
			{
				int nProgIV = FeatAdd(OBJECT_SELF, 21428, TRUE, TRUE, FALSE);
				nProgIV == TRUE;
			}
			if (!GetHasFeat(21429, oPC) && nPsion2 > 8)
			{
				int nProgV = FeatAdd(OBJECT_SELF, 21429, TRUE, TRUE, FALSE);
				nProgV == TRUE;
			}
			if (!GetHasFeat(21430, oPC) && nPsion2 > 10)
			{
				int nProgVI = FeatAdd(OBJECT_SELF, 21430, TRUE, TRUE, FALSE);
				nProgVI == TRUE;
			}
			if (!GetHasFeat(21431, oPC) && nPsion2 > 12)
			{
				int nProgVII = FeatAdd(OBJECT_SELF, 21431, TRUE, TRUE, FALSE);
				nProgVII == TRUE;
			}
			if (!GetHasFeat(21432, oPC) && nPsion2 > 14)
			{
				int nProgVIII = FeatAdd(OBJECT_SELF, 21432, TRUE, TRUE, FALSE);
				nProgVIII == TRUE;
			}
			if (!GetHasFeat(21433, oPC) && nPsion2 > 16)
			{
				int nProgIX = FeatAdd(OBJECT_SELF, 21433, TRUE, TRUE, FALSE);
				nProgIX == TRUE;
			}
			
			
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