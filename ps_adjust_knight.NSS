


#include "aaa_constants"
#include "ps0_classes2015_inc"


void PS_KnightLevels(object oPC);

void PS_KnightLevels(object oPC)
{


	int iPally = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);//Paladin, aka, Knight
	int iWarPriest = GetLevelByClass(CLASS_TYPE_WARPRIEST,oPC);//Warpriest	
	int iHalfCelestial = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Celestial
	int	iDivine = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oPC);//Divine Champion
	int iEnvoy = GetLevelByClass(CLASS_TYPE_CELESTIAL_ENVOY,oPC); //Celestial Envoy	
	int iHound = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC,oPC); // Hound Archon
	int iAstral = GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC,oPC);//Astral Deva PRC
	int iMovanic = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC,oPC);//Movanic Deva
	int iMarquis = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION,oPC);//Marquis Cambion
	int iDeath = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC,oPC);//Death Knight
	int iHalfFiend = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC,oPC);//Half-Outsider
	int iWarden = GetLevelByClass(CLASS_NWNINE_WARDER,oPC);
	  
	  
	  int iTotal = iPally + iWarPriest;
/*	  if(GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal +iDeath + iMarquis;
	  if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC) && GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal + iHalfFiend ;
	  if (GetHasFeat(FEAT_PALADIN,oPC)&& GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)) iTotal = iTotal + iHalfCelestial;
	  if (GetHasFeat(FEAT_KNIGHT,oPC)) iTotal = iTotal + iDivine + iWarPriest + iWarden;
	  if (GetHasFeat(FEAT_PALADIN,oPC)) iTotal = iTotal + iHound + iAstral + iMovanic + iEnvoy;*/
	  if (iPally <1 ) return;
	  
	  else 
	 
	    int iTotal = iPally + iWarPriest;
	  if(GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal +iDeath + iMarquis;
	  if (GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH,oPC) && GetHasFeat(FEAT_BLACKGUARD,oPC)) iTotal = iTotal + iHalfFiend ;
	  if (GetHasFeat(FEAT_PALADIN,oPC)&& GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL,oPC)) iTotal = iTotal + iHalfCelestial;
	  if (GetHasFeat(FEAT_KNIGHT,oPC)) iTotal = iTotal + iDivine + iWarPriest + iWarden;
	  if (GetHasFeat(FEAT_PALADIN,oPC)) iTotal = iTotal + iHound + iAstral + iMovanic + iEnvoy;
		if (iTotal >= 1  && GetHasFeat(FEAT_BLACKGUARD,oPC))
			{FeatAdd(oPC,FEAT_USE_POISON,FALSE,FALSE,FALSE);//Use Poison, BG Path
			FeatAdd(oPC,FEAT_SMITE_GOOD,FALSE,FALSE,FALSE);//Smite Evil, BG Path
			}
		 if (iTotal >= 2 && GetHasFeat(FEAT_BLACKGUARD,oPC))
				{FeatAdd(oPC,FEAT_BULLS_STRENGTH,FALSE,FALSE,FALSE);//Bull's Strength Feat
			
		}	  
		 if (iTotal >= 3 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_PRESTIGE_DARK_BLESSING,FALSE,FALSE,FALSE);//Dark Blessing, BG Path
		FeatAdd(oPC,1832,FALSE,FALSE,FALSE);//Aura of Despair, BG Path
	  }
	  
	  	 if (iTotal >= 4 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);//Turn Undead, BG Path
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//Sneak Attack, BG Path
	  }
	    
	  	 if (iTotal >= 6 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_LIGHT_WOUNDS,FALSE,FALSE,FALSE);//Turn Undead, BG Path

	  }
	  
	  	 if (iTotal >= 7 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_CONTAGION,FALSE,FALSE,FALSE);//Contagion, BG Path
		FeatAdd(oPC,FEAT_FEINT,FALSE,FALSE,FALSE);//Feint
		FeatAdd(oPC,460,FALSE,FALSE,FALSE);//sneak attack2, BG Path

	  }
	  	  	 if (iTotal >= 8 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,FEAT_INFLICT_CRITICAL_WOUNDS,FALSE,FALSE,FALSE);//Inflict Critical Wounds, BG Path
	

	  }
	  	   if (iTotal >= 9 && GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		FeatAdd(oPC,475,FALSE,FALSE,FALSE);//Summon Fiend , BG Path
		FeatAdd(oPC,2654,FALSE,FALSE,FALSE);//Unsummon Fiend, BG Path

	  }
	  
	    	   if (iTotal >= 10 && GetHasFeat(FEAT_BLACKGUARD,oPC))
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
	     if (iTotal >= 2 && GetHasFeat(FEAT_PALADIN,oPC))
	  
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
	  if (iTotal >= 4 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  			FeatAdd(oPC,FEAT_TURN_UNDEAD,FALSE,FALSE,FALSE);// Turn Undead, Knight Path
		
	  
	  }
	  
	    if (iTotal >= 7 && GetHasFeat(FEAT_KNIGHT,oPC))
	  
	  {
	  			FeatAdd(oPC,FEAT_KNIGHTS_AURA,FALSE,FALSE,FALSE);// Knight's Aura, Knight Path
		FeatAdd(oPC,FEAT_PRACTICED_SPELLCASTER_PALADIN,FALSE,FALSE,FALSE);// Practiced Spell Caster, Knight Path
	  
	  }
		if (iTotal > 14 && GetHasFeat(FEAT_KNIGHT,oPC))
		
		{ FeatAdd(oPC,1761,FALSE,FALSE,FALSE);//Smite Infidel , Knight Path
		
		}
	  if (iTotal > 21 && GetHasFeat(FEAT_KNIGHT,oPC))
		
		{ FeatAdd(oPC,1990,FALSE,FALSE,FALSE);//Rescue Feat , Knight Path
		
		}
	  }