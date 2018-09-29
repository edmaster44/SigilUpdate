#include "ps_inc_functions"
#include "ps_inc_advscript"


//---------------------------------------------------------------------------------------------------------------------------
// Change Size
//---------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------
// Medium
//---------------------------------------------------------------------------------------------------------------------------
	
void PS_Dragon_Medium(object oPC)
{
	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);

		int nSubRace = GetSubRace(oPC);
		int nAppearance;

		switch (nSubRace)
		{
		case 0: //Debug
			SendMessageToPC(oPC, "Something is wrong.");
			nAppearance = 1;
		break;
		case 222: //Bronze
			nAppearance = 3114;
		break;
		case 223: //Red
			nAppearance = 3115;
		break;
		case 224: //Blue
			nAppearance = 3116;
		break;
		case 225: //Shadow
			nAppearance = 3117;
		break;
		case 226: //Black
			nAppearance = 3118;
		break;
		case 227: //Copper
			nAppearance = 3132;
		break;
		case 228: //Iron
			nAppearance = 3133;
		break;
		case 237: //Amethyst
			nAppearance = 3129;
		break;
		case 238: //Emerald
			nAppearance = 3130;
		break;
		case 239: //Topaz
			nAppearance = 3131;
		break;
		case 240: //White
			nAppearance = 3134;
		break;	
		case 244: //Radiant
			nAppearance = 3137;
		break;						 
		}		
/*		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = nAppVar;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
		DelayCommand(0.1f, PS_SaveOriginalAppearance(oPC));	*/
		
		SetCreatureAppearanceType(oPC, nAppearance);	
		PS_RefreshAppearance(oPC);
	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Large
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Large(object oPC)
{
	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);

		int nSubRace = GetSubRace(oPC);
		int nAppearance;

		switch (nSubRace)
		{
		case 0: //Debug
			SendMessageToPC(oPC, "Something is wrong.");
			nAppearance = 1;
		break;
		case 222: //Bronze
			nAppearance = 3104;
		break;
		case 223: //Red
			nAppearance = 3105;
		break;
		case 224: //Blue
			nAppearance = 3106;
		break;
		case 225: //Shadow
			nAppearance = 3107;
		break;
		case 226: //Black
			nAppearance = 3108;
		break;
		case 227: //Copper
			nAppearance = 3122;
		break;
		case 228: //Iron
			nAppearance = 3123;
		break;
		case 237: //Amethyst
			nAppearance = 3119;
		break;
		case 238: //Emerald
			nAppearance = 3120;
		break;
		case 239: //Topaz
			nAppearance = 3121;
		break;
		case 240: //White
			nAppearance = 3135;
		break;
		case 244: //Radiant
			nAppearance = 3138;
		break;			 
		}
/*		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = nAppVar;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
		DelayCommand(0.1f, PS_SaveOriginalAppearance(oPC));	*/
		
		SetCreatureAppearanceType(oPC, nAppearance);	
		PS_RefreshAppearance(oPC);
	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Huge
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Huge(object oPC)
{
	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);

		int nSubRace = GetSubRace(oPC);
		int nAppearance;

		switch (nSubRace)
		{
		case 0: //Debug
			SendMessageToPC(oPC, "Something is wrong.");
			nAppearance = 1;
		break;
		case 222: //Bronze
			nAppearance = 3109;
		break;
		case 223: //Red
			nAppearance = 3110;
		break;
		case 224: //Blue
			nAppearance = 3111;
		break;
		case 225: //Shadow
			nAppearance = 3112;
		break;
		case 226: //Black
			nAppearance = 3113;
		break;
		case 227: //Copper
			nAppearance = 3127;
		break;
		case 228: //Iron
			nAppearance = 3128;
		break;
		case 237: //Amethyst
			nAppearance = 3124;
		break;
		case 238: //Emerald
			nAppearance = 3125;
		break;
		case 239: //Topaz
			nAppearance = 3126;
		break;
		case 240: //White
			nAppearance = 3136;
		break;	
		case 244: //Radiant
			nAppearance = 3139;
		break;			 
		}
/*		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = nAppVar;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
		DelayCommand(0.1f, PS_SaveOriginalAppearance(oPC));	*/
		
		SetCreatureAppearanceType(oPC, nAppearance);	
		PS_RefreshAppearance(oPC);	
	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Old Versions
//---------------------------------------------------------------------------------------------------------------------------

/*	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);
						

			if (GetSubRace(oPC) == 223) //If Red Dragon
				{	SendMessageToPC(oPC, "You have become huge. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3110);	} //...
			else if (GetSubRace(oPC) == 222) //If Bronze Dragon
				{	SendMessageToPC(oPC, "You have become huge. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3109);	} // then set to Huge Bronze Dragon
			else if (GetSubRace(oPC) == 224) //If Blue Dragon
				{	SendMessageToPC(oPC, "You have become huge. Please relog to apply size adjustments.");
				   	SetCreatureAppearanceType(oPC, 3111);	}
			else if (GetSubRace(oPC) == 225) //If Shadow Dragon
				{	SendMessageToPC(oPC, "You have become huge. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3112);	}
			else if (GetSubRace(oPC) == 226) //If Black Dragon
				{	SendMessageToPC(oPC, "You have become huge. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3113);	}	
			PS_RefreshAppearance(oPC);
	}
}
	
void PS_Dragon_Medium(object oPC)
{

	
	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);
						

			if (GetSubRace(oPC) == 223) //If Red Dragon
				{	SendMessageToPC(oPC, "You have become medium. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3115);	} //...		
			else if (GetSubRace(oPC) == 222) //If Bronze Dragon
				{	SendMessageToPC(oPC, "You have become medium. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3114);	} // then set to Medium Bronze Dragon
			else if (GetSubRace(oPC) == 224) //If Blue Dragon
				{	SendMessageToPC(oPC, "You have become medium. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3116);	}
			else if (GetSubRace(oPC) == 225) //If Shadow Dragon
				{	SendMessageToPC(oPC, "You have become medium. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3117);	}
			else if (GetSubRace(oPC) == 226) //If Black Dragon
				{	SendMessageToPC(oPC, "You have become medium. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3118);	}	
			PS_RefreshAppearance(oPC);
	}	
}

void PS_Dragon_Large(object oPC)
{

	
	if(GetRacialType(oPC) == 11)  // Should only work for dragons ;)
	{	
		SendMessageToPC(oPC, "You are a dragon.");
		effect eDragon 	= EffectNWN2SpecialEffectFile("fx_ritual_purification", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);
						
			if (GetSubRace(oPC) == 223) //If Red Dragon
				{	SendMessageToPC(oPC, "You have become large. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3105);	} //...
			else if (GetSubRace(oPC) == 222) //If Bronze Dragon
				{	SendMessageToPC(oPC, "You have become large. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3104);	} // then set to Large Bronze Dragon
			else if (GetSubRace(oPC) == 224) //If Blue Dragon
				{	SendMessageToPC(oPC, "You have become large. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3106);	}
			else if (GetSubRace(oPC) == 225) //If Shadow Dragon
				{	SendMessageToPC(oPC, "You have become large. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3107);	}
			else if (GetSubRace(oPC) == 226) //If Black Dragon
				{	SendMessageToPC(oPC, "You have become large. Please relog to apply size adjustments.");
					SetCreatureAppearanceType(oPC, 3108);	}	
			PS_RefreshAppearance(oPC);
	}	
}
		