


#include "aaa_constants"



void PS_KnightLevels(object oPC);
int KnightLevels(object oPC);

void PS_KnightLevels(object oPC)
{


	int iPally = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);//Paladin, aka, Knight
	int iErinyes = GetLevelByClass(CLASS_TYPE_ERINYES,oPC);//Erinyes.
	int iWarPriest = GetLevelByClass(CLASS_TYPE_WARPRIEST,oPC);//Warpriest	
	int iHalfCelestial = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Celestial
	int	iDivine = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oPC);//Divine Champion
	int iEnvoy = GetLevelByClass(42,oPC); //Celestial Envoy	
	int iDoomg  = GetLevelByClass(CLASS_TYPE_DOOMGUIDE,oPC);//Doomguide
	int iHound = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC,oPC); // Hound Archon
	int iAstral = GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC,oPC);//Astral Deva PRC
	int iMovanic = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC,oPC);//Movanic Deva
	int iMarquis = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION,oPC);//Marquis Cambion
	int iDeath = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC,oPC);//Death Knight
	int iHalfFiend = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Outsider
	int iHalfFiend_M = GetLevelByClass(CLASS_TYPE_HALFOUTSIDERMAGE_PRC,oPC);//Half-Outsider_Mage path
	int iHalfCelestial_M = GetLevelByClass(CLASS_TYPE_HALFOUTSIDERMAGE_PRC,oPC);//Half-Outsider_Mage Path
	int iWarden = GetLevelByClass(CLASS_NWNINE_WARDER,oPC);
	  
	  
	  int iTotal = iPally + iWarPriest;
	  if(GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal +iDeath + iMarquis + iErinyes;
	  if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC) && GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal + iHalfFiend ;
	  if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC) && GetHasFeat(FEAT_BLACKGUARD,oPC) && GetHasFeat(3036,oPC))iTotal = iTotal + iHalfFiend_M ;
	  if (GetHasFeat(FEAT_PALADIN,oPC)&& GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)) iTotal = iTotal + iHalfCelestial;
	  if (GetHasFeat(FEAT_PALADIN,oPC)&& GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)&& GetHasFeat(3036,oPC)) iTotal = iTotal + iHalfCelestial_M;
	  if (GetHasFeat(FEAT_KNIGHT,oPC)) iTotal = iTotal + iDivine + iWarPriest + iWarden + iDoomg;
	  if (GetHasFeat(FEAT_PALADIN,oPC) && GetHasFeat(2455)) iTotal = iTotal + iHound;
	  if (GetHasFeat(FEAT_KNIGHT,oPC) && GetHasFeat(2673)) iTotal = iTotal + iAstral;
	  if (GetHasFeat(FEAT_KNIGHT,oPC) && GetHasFeat(2635)) iTotal = iTotal + iEnvoy;
	  if (GetHasFeat(FEAT_PALADIN,oPC)) iTotal = iTotal + iMovanic;
	  if (iPally <1 ) return;
	  
	  else
	  
	  
	  
	  

		if (iTotal >= 1  && GetHasFeat(FEAT_BLACKGUARD,oPC))
			{FeatAdd(oPC,FEAT_USE_POISON,FALSE,FALSE,FALSE);//Use Poison, BG Path
			FeatAdd(oPC,FEAT_BLACKGUARD_SMITE,FALSE,FALSE,FALSE);//Smite Good, BG Path
			}
		 if (iTotal >= 1 && GetHasFeat(FEAT_BLACKGUARD,oPC))
				{FeatAdd(oPC,FEAT_BULLS_STRENGTH,FALSE,FALSE,FALSE);//Bull's Strength Feat
			
		}	  
		 if (iTotal >= 2 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_PRESTIGE_DARK_BLESSING,FALSE,FALSE,FALSE);//Dark Blessing, BG Path
		FeatAdd(oPC,1832,FALSE,FALSE,FALSE);//Aura of Despair, BG Path
	  }
	  
	  	 if (iTotal >= 4 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);//Turn Undead, BG Path
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//Sneak Attack, BG Path
	  }
	    
	  	 if (iTotal >= 5 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_LIGHT_WOUNDS,FALSE,FALSE,FALSE);//Turn Undead, BG Path

	  }
	  
	  	 if (iTotal >= 7 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_CONTAGION,FALSE,FALSE,FALSE);//Contagion, BG Path
		FeatAdd(oPC,FEAT_FEINT,FALSE,FALSE,FALSE);//Feint
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//sneak attack2, BG Path

	  }
	  	  	 if (iTotal >= 7 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_CRITICAL_WOUNDS,FALSE,FALSE,FALSE);//Inflict Critical Wounds, BG Path
	

	  }
	  	   if (iTotal >= 9 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,475,FALSE,FALSE,FALSE);//Summon Fiend , BG Path
		FeatAdd(oPC,2654,FALSE,FALSE,FALSE);//Unsummon Fiend, BG Path

	  }
	  
	    	   if (iTotal >= 9 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,462,FALSE,FALSE,FALSE);//sneak attack 3


	  }
	  
	  

	   	   if (iTotal >= 14 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_KNOCKDOWN,FALSE,FALSE,FALSE);//KnockDown , BG Path


	  }
	  	   	   if (iTotal >= 21 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,1970,FALSE,FALSE,FALSE);//Expose Weakness , BG Path


	  }
	   if (iTotal >= 1 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_SMITE_EVIL,FALSE,FALSE,FALSE);//Smite Evil , Paladin Path
	  
	  }
	     if (iTotal >= 1 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_DIVINE_GRACE,FALSE,FALSE,FALSE);//Divine Grace , Paladin Path
			FeatAdd(oPC,FEAT_LAY_ON_HANDS,FALSE,FALSE,FALSE);//Lay on Hands , Paladin Path
	  
	  }
	  	   if (iTotal >= 3 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_DIVINE_HEALTH,FALSE,FALSE,FALSE);//Divine Health , Paladin Path
			FeatAdd(oPC,FEAT_AURA_OF_COURAGE,FALSE,FALSE,FALSE);//Aura of Courage , Paladin Path
	   
	  }
	  	  	   if (iTotal >= 4 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Paladin Path

	   
	  }
	  
	 		 if (iTotal >= 6 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_REMOVE_DISEASE,FALSE,FALSE,FALSE);// Remove Disease, Paladin Path
	  
	  }
	  	 if (iTotal >= 7 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2836,FALSE,FALSE,FALSE);// Armor Optimizaiton, Paladin Path
	  
	  }
	  
	  	 if (iTotal >= 14 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2837,FALSE,FALSE,FALSE);// Greater Armor Optimization, Paladin Path
	  
	  }
	  	 if (iTotal >= 21 && GetHasFeat(FEAT_PALADIN,oPC))
	  
	  {
	  		FeatAdd(oPC,2838,FALSE,FALSE,FALSE);// Epic Armor Optimization, Paladin Path
	  
	  }

	     if (iTotal >= 1 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  		//FeatAdd(oPC,FEAT_DIVINE_GRACE,FALSE,FALSE,FALSE);//Divine Grace , Knight Path
			FeatAdd(oPC,FEAT_LAY_ON_HANDS,FALSE,FALSE,FALSE);//Lay on Hands , Knight Path
	  
	  }
	  
	   if (iTotal >= 3 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  		FeatAdd(oPC,FEAT_DIVINE_RETRIBUTION,FALSE,FALSE,FALSE);//Divine Retribution , Knight Path
		
	  
	  }
	  if (iTotal >= 3 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  			FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Knight Path
		
	  
	  }
	  
	    if (iTotal >= 6 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  			FeatAdd(oPC,FEAT_KNIGHTS_AURA,FALSE,FALSE,FALSE);// Knight's Aura, Knight Path
		FeatAdd(oPC,FEAT_PRACTICED_SPELLCASTER_PALADIN,FALSE,FALSE,FALSE);// Practiced Spell Caster, Knight Path
	  
	  }
		if (iTotal > 13 && GetHasFeat(FEAT_KNIGHT,oPC))
		
		{ FeatAdd(oPC,FEAT_KNIGHTSMITE,FALSE,FALSE,FALSE);//New Smite , Knight Path
		
		}
	  if (iTotal > 20 && GetHasFeat(FEAT_KNIGHT,oPC))
		
		{ FeatAdd(oPC,1990,FALSE,FALSE,FALSE);//Rescue Feat , Knight Path
		
		}
	  }
	  
int KnightLevels(object oPC)
{
	int iPally = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);//Paladin, aka, Knight
	int iWarPriest = GetLevelByClass(CLASS_TYPE_WARPRIEST,oPC);//Warpriest	
	int iHalfCelestial = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Celestial
	int	iDivine = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oPC);//Divine Champion
	int iEnvoy = GetLevelByClass(42,oPC); //Celestial Envoy	
	int iHound = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC,oPC); // Hound Archon
	int iAstral = GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC,oPC);//Astral Deva PRC
	int iDoomg  = GetLevelByClass(CLASS_TYPE_DOOMGUIDE,oPC);
	int iMovanic = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC,oPC);//Movanic Deva
	int iMarquis = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION,oPC);//Marquis Cambion
	int iDeath = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC,oPC);//Death Knight
	int iHalfFiend = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Outsider
	int iWarden = GetLevelByClass(CLASS_NWNINE_WARDER,oPC);
	int iTotal = iPally + iWarPriest + iHalfCelestial + iDivine + iEnvoy + iHound + iAstral + 
	  iMovanic + iMarquis + iDeath + iHalfFiend + iWarden;
	   if (iPally <1 )
	   { (iTotal = 0);}
	else
	      if (iTotal >= 1 && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
	{ FeatAdd(oPC,FEAT_BLACKGUARD,FALSE,FALSE,FALSE);}
		else if (iTotal >= 1 && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
		{ FeatAdd(oPC,FEAT_PALADIN,FALSE,FALSE,FALSE);}
			else if (iTotal >= 1 && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL)
		{ FeatAdd(oPC,FEAT_KNIGHT,FALSE,FALSE,FALSE);}
		
	   
	   return iTotal;
	   
	  
	


}