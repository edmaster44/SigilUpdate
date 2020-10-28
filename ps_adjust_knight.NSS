


#include "aaa_constants"
#include "ps0_classes2015_inc"

void PS_KnightLevels(object oPC)
{


	int iPally = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);//Paladin, aka, Knight
	int iWarPriest = GetLevelByClass(CLASS_TYPE_WARPRIEST,oPC);//Warpriest	
	int iHalfCelestial = GetLevelByCLass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Celestial
	int	iDivine = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,PC);//Divine Champion
	int iEnvoy = GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY,oPC); //Celestial Envoy	
	int iHound = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC,oPC); // Hound Archon
	int iAstral = GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC,oPC);//Astral Deva PRC
	int iMovanic = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC,oPC);//Movanic Deva
	int iMarquis = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION,oPC);//Marquis Cambion
	int iDeath = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC,oPC);//Death Knight
	int iHalfFiend = GetLevelByCLass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Outsider
	  
	  
	  int iTotal = iPally + iWarpriest;
	  if(GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal +iDeath + iMarquis;
	  if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC) && GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal + iHalfFiend ;
	  if (GetHasFeat(FEAT_PALADIN,oPC)&& GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)) iTotal = iTotal + iHalfCelestial;
	  if (GetHasFeat(FEAT_KNIGHT,oPC)) iTotal = iTotal + iDivine;
	  if (GetHasFeat(FEAT_PALADIN,oPC)) iTotal = iTotal + iHound + iAstral + iMovanic + iEnvoy;
	  if (iPally <1 ) return;
	  
	  else 
	 
	  
		if (iTotal >= 1  && GetHasFeat(BLACK_GUARD,oPC))
			{FeatAdd(oPC,FEAT_USE_POISON,FALSE,FALSE,FALSE);//Use Poison, BG Path
			FeatAdd(oPC,FEAT_SMITE_GOOD,FALSE,FALSE,FALSE);//Smite Evil, BG Path
			}
		else if (iTotal >= 2 && GetHasFeat(BLACK_GUARD,oPC))
				{FeatAdd(oPC,FEAT_BULLS_STRENGTH,FALSE,FALSE,FALSE);//Bull's Strength Feat
			
		}	  
		else if (iTotal >= 3 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_PRESTIGE_DARK_BLESSING,FALSE,FALSE,FALSE);//Dark Blessing, BG Path
		FeatAdd(oPC,1832,FALSE,FALSE,FALSE);//Aura of Despair, BG Path
	  }
	  
	  	else if (iTotal >= 4 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);//Turn Undead, BG Path
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//Sneak Attack, BG Path
	  }
	    
	  	else if (iTotal >= 6 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_LIGHT_WOUNDS,FALSE,FALSE,FALSE);//Turn Undead, BG Path

	  }
	  
	  	else if (iTotal >= 7 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_CONTAGION,FALSE,FALSE,FALSE);//Contagion, BG Path
		FeatAdd(oPC,FEAT_FEINT,FALSE,FALSE,FALSE);//Feint
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//sneak attack2, BG Path

	  }
	  	  	else if (iTotal >= 8 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_CRITICAL_WOUNDS,FALSE,FALSE,FALSE);//Inflict Critical Wounds, BG Path
	

	  }
	  	  else if (iTotal >= 9 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,475,FALSE,FALSE,FALSE);//Summon Fiend , BG Path
		FeatAdd(oPC,2654,FALSE,FALSE,FALSE);//Unsummon Fiend, BG Path

	  }
	  
	    	  else if (iTotal >= 10 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,462,FALSE,FALSE,FALSE);//sneak attack 3


	  }
	  
	  
	  
	   	  else if (iTotal >= 14 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,FEAT_KNOCKDOWN,FALSE,FALSE,FALSE);//KnockDown , BG Path


	  }
	  	   	  else if (iTotal >= 21 && GetHasFeat(BLACK_GUARD,oPC))
		{
		FeatAdd(oPC,1970,FALSE,FALSE,FALSE);//Expose Weakness , BG Path


	  }
	  else if (iTotal >= 1 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_SMITE_EVIL,FALSE,FALSE,FALSE);//Smite Evil , Paladin Path
	  
	  }
	    else if (iTotal >= 2 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_DIVINE_GRACE,FALSE,FALSE,FALSE);//Divine Grace , Paladin Path
			FeatAdd(oPC,FEAT_LAY_ON_HANDS,FALSE,FALSE,FALSE);//Lay on Hands , Paladin Path
	  
	  }
	  	  else if (iTotal >= 3 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_DIVINE_HEALTH,FALSE,FALSE,FALSE);//Divine Health , Paladin Path
			FeatAdd(oPC,FEAT_AURA_OF_COURAGE,FALSE,FALSE,FALSE);//Aura of Courage , Paladin Path
	   
	  }
	  	  	  else if (iTotal >= 4 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Paladin Path

	   
	  }
	  
	 		else if (iTotal >= 6 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_REMOVE_DISEASE,FALSE,FALSE,FALSE);// Remove Disease, Paladin Path
	  
	  }
	  	else if (iTotal >= 7 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2836,FALSE,FALSE,FALSE);// Armor Optimizaiton, Paladin Path
	  
	  }
	  
	  	else if (iTotal >= 14 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2837,FALSE,FALSE,FALSE);// Greater Armor Optimization, Paladin Path
	  
	  }
	  	else if (iTotal >= 21 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2838,FALSE,FALSE,FALSE);// Epic Armor Optimization, Paladin Path
	  
	  }
	  }