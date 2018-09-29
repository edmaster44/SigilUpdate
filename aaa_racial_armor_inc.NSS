#include "x2_inc_spellhook"
#include "aaa_constants"

/*	This is the include file for all armor bonuses given as part of a Racial PrC.
	Every individual racial spell in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_racial_armor, which acts as the universal spell with a case-based system.
*/



void PS_NatArmor_Giant(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	if 		(GetLevelByClass(CLASS_TYPE_FIRE_GIANT_PRC, oPC) != 0)
	{	iPRCLvl	= GetLevelByClass(CLASS_TYPE_FIRE_GIANT_PRC, oPC);		}
	else if (GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC, oPC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC, oPC);		}
	else if (GetLevelByClass(CLASS_TYPE_HILL_GIANT_PRC, oPC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_HILL_GIANT_PRC, oPC);		}
	else if (GetLevelByClass(CLASS_TYPE_SAVAGE_MARAUDER_PRC, oPC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_SAVAGE_MARAUDER_PRC, oPC);	}
	else 	{iPRCLvl = 0;}
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 5) 		//+5 bonus at 5th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 4)	//+4 bonus at 4th level
	{	iBonus = 4;		} 
	else if (iPRCLvl >= 3) 	//+3 bonus at 3rd level
	{	iBonus = 3;		} 
	else if (iPRCLvl >= 2) 	//+2 bonus at 2nd level
	{	iBonus = 2;		} 
	else					//+1 bonus at 1st level
	{	iBonus = 1;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);		
	}
}

void PS_NatArmor_Deva(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	if (GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC, oPC) != 0)
	{	iPRCLvl	= GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC, oPC);	}
	else if (GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC);}
	else if (GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC);}
	else {iPRCLvl = 0;}
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 10) 		//+6 bonus at 10th level
	{	iBonus = 7;		} 
	else if (iPRCLvl >= 7)	//+4 bonus at 7th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 4) 	//+2 bonus at 4rd level
	{	iBonus = 3;		} 
	else					//no bonus at 1st level
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Erinyes(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_ERINYES, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 6) 		//+5 bonus at 6th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 5)	//+4 bonus at 5th level
	{	iBonus = 4;		} 
	else if (iPRCLvl >= 4) 	//+3 bonus at 4th level
	{	iBonus = 3;		}
	else if (iPRCLvl >= 3) 	//+2 bonus at 3rd level
	{	iBonus = 2;		}
	else if (iPRCLvl >= 2) 	//+1 bonus at 2nd level
	{	iBonus = 1;		}
	else					//no bonus at 1st level
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Brachina(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 10) 		//+5 bonus at 10th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 8)	//+4 bonus at 8th level
	{	iBonus = 4;		} 
	else if (iPRCLvl >= 6) 	//+3 bonus at 6th level
	{	iBonus = 3;		}
	else if (iPRCLvl >= 4) 	//+2 bonus at 4th level
	{	iBonus = 2;		}
	else if (iPRCLvl >= 2) 	//+1 bonus at 2nd level
	{	iBonus = 1;		}
	else					//no bonus at 1st level
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Succubus(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 10) 		//+9 bonus at 10th level
	{	iBonus = 9;		} 
	else if (iPRCLvl >= 8)	//+7 bonus at 8th level
	{	iBonus = 7;		} 
	else if (iPRCLvl >= 6) 	//+5 bonus at 6th level
	{	iBonus = 5;		}
	else if (iPRCLvl >= 4) 	//+3 bonus at 4th level
	{	iBonus = 3;		}
	else if (iPRCLvl >= 1) 	//+1 bonus at 1st level
	{	iBonus = 1;		}
	else					//no bonus
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_MarqCamb(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 6) 		//+6 bonus at 6th level
	{	iBonus = 6;		} 
	else if (iPRCLvl >= 5)	//+5 bonus at 5th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 4) 	//+4 bonus at 4th level
	{	iBonus = 4;		}
	else if (iPRCLvl >= 3) 	//+3 bonus at 3rd level
	{	iBonus = 3;		}
	else if (iPRCLvl >= 2) 	//+2 bonus at 2nd level
	{	iBonus = 2;		}
	else if (iPRCLvl >= 1)	//+1 bonus at 1st level
	{	iBonus = 1;		}
	else					//no bonus
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Hezrou(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_HEZROU, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 9) 		//+10 bonus at 9th level
	{	iBonus = 10;		} 
	else if (iPRCLvl >= 7)	//+8 bonus at 7th level
	{	iBonus = 8;		} 
	else if (iPRCLvl >= 5) 	//+6 bonus at 5th level
	{	iBonus = 6;		}
	else if (iPRCLvl >= 3) 	//+4 bonus at 3th level
	{	iBonus = 4;		}
	else if (iPRCLvl >= 1) 	//+2 bonus at 1st level
	{	iBonus = 2;		}
	else					//no bonus
	{	iBonus = 0;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Archon(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iPRCLvl	= GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC);
//Determine AC bonus granted based on PRC class level
	if (iPRCLvl >= 6) 		//+7 bonus at 6th level
	{	iBonus = 7;		} 
	else if (iPRCLvl >= 5)	//+5 bonus at 5th level
	{	iBonus = 5;		} 
	else if (iPRCLvl >= 4) 	//+4 bonus at 4th level
	{	iBonus = 4;		}
	else if (iPRCLvl >= 3) 	//+3 bonus at 3rd level
	{	iBonus = 3;		}
	else if (iPRCLvl >= 2) 	//+2 bonus at 2nd level
	{	iBonus = 2;		}
	else					//+1 bonus at 1st level
	{	iBonus = 1;		}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_ArchonPRC(object oPC)
{
	int iTALevel;
	int iWALevel;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	iTALevel	= GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC);
	iWALevel	= GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
//Determine AC bonus granted based on PRC class level
	if (iTALevel >= 2) 		//+1 bonus per level starting at 2
	{	iBonus = (iTALevel - 1);	} 
	if (iWALevel >= 2)		//+1 bonus per level starting at 2
	{	iBonus = (iWALevel - 1);	}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}

void PS_NatArmor_Eladrin(object oPC)
{
	int iPRCLvl;
	int iBonus;
//Determine class level of prestige classes which use this feat	
	if (GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC) != 0)
	{	iPRCLvl	= GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC);	}
	else if (GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC);}
	else if (GetLevelByClass(CLASS_TYPE_GHAELE_PRC) != 0)
	{	iPRCLvl = GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC);}
	else {iPRCLvl = 0;}
//Determine AC bonus granted based on PRC class level
	iBonus = iPRCLvl - 1;
	if	(iBonus < 0)
	{	iBonus = 0;	}
	
	if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	//Calculate and apply AC bonus
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
	}
}