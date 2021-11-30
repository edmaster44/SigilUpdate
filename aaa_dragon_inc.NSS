#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "x0_i0_position"
#include "ginc_math"

/*	This is the include file for all dragon features.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_dragon, which acts as the universal spell with a case-based system.
	
	1. Shield Armor
	2. Dragon Immunities (Paralysis, Sleep, Element)
	3. Breaths
	4. Race Abilities (and Dragon Age/Size)
	5. Class Abilities
		
*/

//---------------------------------------------------------------------------------------------------------------------------
// Applies Shield AC based on characterlevel
//---------------------------------------------------------------------------------------------------------------------------

void PS_ShieldArmor_Dragon(object oPC, int nSpell)
{	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
    if (!X2PreSpellCastCode())
    {	return;	}

	int iHD = GetTotalLevels(oPC, TRUE);
	int iShield;
	//Remove existing properties of these types
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}
	if (GetHasFeat(260, oPC))
		{	
			iShield = 0;  // +0 bonus if monk class is taken 						  
		}
	else
		{					
		if (iHD >= 20) 			//+0 bonus at 20th level
			{	iShield = 0;		} 
		else if (iHD >= 10)		//+0 bonus at 10th level
			{	iShield = 0;		} 
		else 					//+0 bonus below 10th level
			{	iShield = 0;		}									
		}
	if (GetLocalInt(oItem, "TempChange") == 1)
		{	
			
			SendMessageToPC(oPC, "<c=red>Bonus Shield for Dragons does not work in Humanoid Form .");
			return;
		}
	else 		

	{	effect eAC = EffectACIncrease(iShield, AC_SHIELD_ENCHANTMENT_BONUS);
			eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);		
	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Electricity Immunity to Bronze and Blue Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Electricity(object oPC)
{ 
	int iImmElec = 9999;
	int iSpellId = 2624; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eElec    = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iImmElec);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eBronze 	= EffectLinkEffects(eElec, eImmu);
		eBronze = ExtraordinaryEffect(eBronze);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBronze, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to electricity, sleep and paralysis applied.");	}
}


//---------------------------------------------------------------------------------------------------------------------------
// Applies Acid Immunity to Black and Copper Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Acid(object oPC)
{ 
	int iImmAcid = 9999;
	int iSpellId = 2628; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eAcid    = EffectDamageResistance(DAMAGE_TYPE_ACID, iImmAcid);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eBlack 	= EffectLinkEffects(eAcid, eImmu);
		eBlack = ExtraordinaryEffect(eBlack);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlack, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to acid, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Sonic Immunity to Emerald Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Sonic(object oPC)
{ 
	int iImmSonic = 9999;
	int iSpellId = 2658; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eSonic    = EffectDamageResistance(DAMAGE_TYPE_SONIC, iImmSonic);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eEmerald 	= EffectLinkEffects(eSonic, eImmu);
		eEmerald = ExtraordinaryEffect(eEmerald);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEmerald, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to sonic, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Cold Immunity to Topaz Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Cold(object oPC)
{ 
	int iImmCold = 9999;
	int iSpellId = 2659; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eCold    = EffectDamageResistance(DAMAGE_TYPE_COLD, iImmCold);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eTopaz 	= EffectLinkEffects(eCold, eImmu);
		eTopaz = ExtraordinaryEffect(eTopaz);

		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTopaz, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to cold, sleep and paralysis applied.");	}
}


//---------------------------------------------------------------------------------------------------------------------------
// Applies Fire Immunity to Red and Brass Dragons. Also Vulnerability to cold
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Fire(object oPC)
{ 
	int iImmFire = 9999;
	int iVulCold = 50;
	int iSpellId = 2629; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eFire    = EffectDamageResistance(DAMAGE_TYPE_FIRE, iImmFire);
	effect eCold    = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, iVulCold);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu2	= EffectLinkEffects(eSlep, ePara);
	effect eImmu    = EffectLinkEffects(eImmu2, eCold);		
	effect eRed 	= EffectLinkEffects(eFire, eImmu);
		eRed = ExtraordinaryEffect(eRed);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRed, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to fire, sleep and paralysis applied. Cold Vulnerability applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Cold Immunity to White and Silver Dragons. Also Vulnerability to cold
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Cold_White(object oPC)
{ 
	int iImmFire = 100;
	int iVulCold = 50;
	int iSpellId = 2663; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eFire    = EffectDamageResistance(DAMAGE_TYPE_COLD, iImmFire);
	effect eCold    = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, iVulCold);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu2	= EffectLinkEffects(eSlep, ePara);
	effect eImmu    = EffectLinkEffects(eImmu2, eCold);		
	effect eRed 	= EffectLinkEffects(eFire, eImmu);
		eRed = ExtraordinaryEffect(eRed);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRed, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to cold, sleep and paralysis applied. Fire Vulnerability applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Negative Energy Immunity to Shadow Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Negative(object oPC)
{ 
	int iImmNeg = 9999;
	int iSpellId = 2630; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eNeg     = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, iImmNeg);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eShadow 	= EffectLinkEffects(eNeg, eImmu);
		eShadow = ExtraordinaryEffect(eShadow);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShadow, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to negative energy, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Light Magic Immunity to Radiant Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Radiant(object oPC)
{ 
	
	int nSpell = GetSpellId(); 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}

	//Apply Spell Immunities
	effect eSunbeam     = EffectSpellImmunity(183);
	effect eSunburst     = EffectSpellImmunity(427);
	effect eSunburstArrow     = EffectSpellImmunity(1789);
	effect eSearingLight     = EffectSpellImmunity(906);
	effect eLightBreath     = EffectSpellImmunity(2667);
	effect ePrismaticSpray     = EffectSpellImmunity(135);
	effect eSun	= EffectLinkEffects(eSunbeam, eSunburst);		
	effect eSearing	= EffectLinkEffects(eSunburstArrow, eSearingLight);
	effect eBreath	= EffectLinkEffects(eLightBreath, ePrismaticSpray);
	effect eLight2 = EffectLinkEffects(eSun, eSearing);
	effect eLight = EffectLinkEffects(eLight2, eBreath);
	
	//Apply Immunity
	effect eBlind	= EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eImmu	= EffectLinkEffects(eSlep, ePara);		
	effect eRadiant	= EffectLinkEffects(eBlind, eImmu);

		eRadiant = ExtraordinaryEffect(eRadiant);
		eLight = ExtraordinaryEffect(eLight);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRadiant, oPC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to light magic, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Acid and Poison Immunity to Copper Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Acid_Poison(object oPC)
{ 
	int iImmAcid = 9999;
	int iSpellId = 2628; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	effect eAcid    = EffectDamageResistance(DAMAGE_TYPE_ACID, iImmAcid);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect ePois    = EffectImmunity(IMMUNITY_TYPE_POISON);	
	effect eImmu	= EffectLinkEffects(eSlep, ePara);
	effect eImmu2	= EffectLinkEffects(ePois, eAcid);		
	effect eBlack 	= EffectLinkEffects(eImmu, eImmu2);
		eBlack = ExtraordinaryEffect(eBlack);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlack, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to acid, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Applies Force Immunity to Amethyst Dragons
//---------------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Force(object oPC)
{ 
	
	int iSpellId =2657; 
	//Remove existing immunity of these types
	if (GetHasSpellEffect(iSpellId,oPC))	
	{	RemoveSpellEffects(iSpellId, oPC, oPC);	}

	//Apply Immunity
	
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect ePois    = EffectImmunity(IMMUNITY_TYPE_POISON);	
	effect eImmu	= EffectLinkEffects(eSlep, ePara);
			
	effect eBlack 	= EffectLinkEffects(eImmu, ePois);
		eBlack = ExtraordinaryEffect(eBlack);
		
    if (!GetHasSpellEffect(GetSpellId(), oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlack, oPC);
		SendMessageToPC(oPC, "Draconic - Immunity to poison, sleep and paralysis applied.");	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Electricity, Line (Bronze)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Bronze(object oPC)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ELECTRICAL;
	nVfx        = VFX_HIT_SPELL_LIGHTNING;
	nSave       = SAVING_THROW_TYPE_ELECTRICITY;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
	}
	else 
	{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_lightningdragonbreath");	
 /*		 	effect eBreath = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST); */
						
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f); 
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
		    nSpell 			= GetSpellId();
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
	}
}


//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Concussive Force, Line (Amethyst)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Amethyst(object oPC)

{
    int nType;
    int nDamageType;
	int nDamageType2;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_MAGICAL;
	nDamageType2 = DAMAGE_TYPE_BLUDGEONING;
	nVfx        = VFX_HIT_SPELL_MAGIC;
	nSave       = SAVING_THROW_TYPE_SPELL;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
	}
	else 
	{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_amethystdragonbreath");	
 /*		 	effect eBreath = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST); */
						
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f); 
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			effect eDamage2;
		    nSpell 			= GetSpellId();
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d4(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
						eDamage2 = EffectDamage(nDamStrike, nDamageType2);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
	}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, repulsive Gas, Cone (Bronze)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Bronze_Gas(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	/*
	// Damage Breath Variables ---------------------------------------------------
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageType;
    int nDamageDie;
	// ---------------------------------------------------------------------------
 	*/
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_MIND_SPELLS;	
	int  nType	   = SAVING_THROW_WILL;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonrepulsebreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eDaze = EffectDazed();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_DAZE);

    effect eLink = EffectLinkEffects(eDaze, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Daze Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
			// ---------------------------------------------------------------------------
			
			/*	 
			
			// Damage Breath -------------------------------------------------------------
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			nDamage = d10(nDice);
			nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
			if (nDamStrike > 0)
			{
			    eDamage = EffectDamage(nDamStrike, nDamageType);
		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 	}
			// ---------------------------------------------------------------------------
			
			*/
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Acid, Line (Black)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Black(object oPC)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ACID;
	nVfx        = VFX_HIT_SPELL_ACID;
	nSave       = SAVING_THROW_TYPE_ACID;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonacidbreath");	
	/*		effect eBreath = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_CHEST); */

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
		    nSpell 			= GetSpellId();
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Fire, Cone (Red)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Red(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageDie;
	int nBonus;
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_FIRE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_FIRE;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_red_dragon_breath.sef");
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d10(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sonic, Cone (Emerald)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Emerald(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SONIC;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_SONIC;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_emeralddragonbreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nType, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, RoundsToSeconds(nDuration)));
      		            
       		         }
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Cold (Dehydrating), Cone (Topaz)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Topaz(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
	effect eDrain;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	int nDrainDice;
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_COLD;	
	int  nType	   = SAVING_THROW_REFLEX;
	int  nType2	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_COLD;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonicebreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					if(!GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT && !GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && !GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)
					{
						if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nType, OBJECT_SELF, fDelay))
	       			     {
						 	nDrainDice = d6(1) + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
							if(GetRacialType(oTarget) == RACIAL_TYPE_OOZE || GetRacialType(oTarget) == RACIAL_SUBTYPE_PLANT)
							{
								nDrainDice = nDrainDice * 2;
							}
	                		eDrain = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDrainDice);
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(nDuration)));
	      		            
	       		         }
					}
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}
//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Cold, Cone (White)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_White(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
	effect eDrain;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	int nDrainDice;
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_COLD;	
	int  nType	   = SAVING_THROW_REFLEX;
	int  nType2	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_COLD;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonicebreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}
//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Negative, Cone (Shadow)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Shadow(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	/*
	// Damage Breath Variables ---------------------------------------------------
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageType;
    int nDamageDie;
	// ---------------------------------------------------------------------------
 	*/
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_NEGATIVE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = 2 + (GetTotalLevels(oPC, TRUE)/5);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_shadowdragonbreath");
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eNeg = EffectNegativeLevel(nDice);
	effect eNeg2 = EffectNegativeLevel(nDice/2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eNeg, eDur);
	effect eLink2 = EffectLinkEffects(eNeg2, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	EffectVisualEffect (VFX_DUR_CONE_EVIL
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f)); 
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Level Drain Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
					 else 
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, HoursToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));      		 
					 }
			// ---------------------------------------------------------------------------
			
			/*	 
			
			// Damage Breath -------------------------------------------------------------
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			nDamage = d10(nDice);
			nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
			if (nDamStrike > 0)
			{
			    eDamage = EffectDamage(nDamStrike, nDamageType);
		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 	}
			// ---------------------------------------------------------------------------
			
			*/
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Electricity, Line (Blue)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Blue(object oPC)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ELECTRICAL;
	nVfx        = VFX_HIT_SPELL_LIGHTNING;
	nSave       = SAVING_THROW_TYPE_ELECTRICITY;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_lightningdragonbreath");	
 	/*	 	effect eBreath = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST); */

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
		    nSpell 			= GetSpellId();
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Acid, Line (Copper)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Copper(object oPC)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ACID;
	nVfx        = VFX_HIT_SPELL_ACID;
	nSave       = SAVING_THROW_TYPE_ACID;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonacidbreath");	
	/*		effect eBreath = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_CHEST); */

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
		    nSpell 			= GetSpellId();
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Slow Gas, Cone (Copper)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Copper_Gas(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	/*
	// Damage Breath Variables ---------------------------------------------------
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageType;
    int nDamageDie;
	// ---------------------------------------------------------------------------
 	*/
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d4(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectSlow();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_SLOW);

    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Daze Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
			// ---------------------------------------------------------------------------
			
			/*	 
			
			// Damage Breath -------------------------------------------------------------
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			nDamage = d10(nDice);
			nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
			if (nDamStrike > 0)
			{
			    eDamage = EffectDamage(nDamStrike, nDamageType);
		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 	}
			// ---------------------------------------------------------------------------
			
			*/
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Blinding Light, Cone (Radiant)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Radiant_Light(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	/*
	// Damage Breath Variables ---------------------------------------------------
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageType;
    int nDamageDie;
	// ---------------------------------------------------------------------------
 	*/
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d4(1) + 5;
	int  nBonus;
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_radiantdragonbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eSlow = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_BLIND);

    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Blind Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
       		         }
					 //Divine Damage ---------------------------------------------------------------
					 int	 nDamage = d6(1);
					 int	 nDamageUndead = d6(nDice);
					 effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE, FALSE);
					 effect eDamageUndead = EffectDamage(nDamageUndead, DAMAGE_TYPE_DIVINE, FALSE);
	
					 if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageUndead, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					 }
					 if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					 }
			// ---------------------------------------------------------------------------
			
			/*	 
			
			// Damage Breath -------------------------------------------------------------
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			nDamage = d10(nDice);
			nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
			if (nDamStrike > 0)
			{
			    eDamage = EffectDamage(nDamStrike, nDamageType);
		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 	}
			// ---------------------------------------------------------------------------
			
			*/
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sparks, Cone (Iron)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Iron(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
	int nDamage2;
    int nDamStrike;
	int nDamStrike2;
	effect eDamage;
	effect eDamage2;
    int nDamageDie;
	int nBonus;
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_FIRE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_FIRE;
	int  nDamageType2 = DAMAGE_TYPE_ELECTRICAL;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_irondragonbreath");
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamage2 = d4(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					nDamStrike2 =  GetReflexAdjustedDamage(nDamage2, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
			 	   		eDamage2 = EffectDamage(nDamStrike, nDamageType2);
						effect eDam = EffectLinkEffects(eDamage, eDamage2);				
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sleep Gas, Cone (Iron)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Iron_Gas(object oPC)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	/*
	// Damage Breath Variables ---------------------------------------------------
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageType;
    int nDamageDie;
	// ---------------------------------------------------------------------------
 	*/
	
	int nSpell 	   = GetSpellId();
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eSleep = EffectSleep();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    				   			 
					 // Sleep Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
			// ---------------------------------------------------------------------------
			
			/*	 
			
			// Damage Breath -------------------------------------------------------------
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			nDamage = d10(nDice);
			nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
			if (nDamStrike > 0)
			{
			    eDamage = EffectDamage(nDamStrike, nDamageType);
		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 	}
			// ---------------------------------------------------------------------------
			
			*/
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// Shadow Blend
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Shadow_Blend(object oPC, int nSpell)
{
   if (!X2PreSpellCastCode())
    {
        return;
    }
	
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectNWN2SpecialEffectFile("sp_darkness_hit");
    effect eLink = EffectLinkEffects(eDur,eVis);

    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oPC, SPELLABILITY_AS_GREATER_INVISIBLITY));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eInvis = EffectLinkEffects(eInvis, eOnDispell);

    SignalEvent(oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));
    int nDuration = 6;
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Darkness
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Black_Darkness(object oPC, int nSpell)
{
    effect eAOE 	 = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nDuration    = GetTotalLevels(oPC, TRUE);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Sound Imitation
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Blue_Sound_Imitation(object oPC, int nSpell)
{

    location lLoc = GetSpellTargetLocation();
    int nDice = GetTotalLevels(oPC, TRUE);
	int nDC = 10 + nDice/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDamage;
    effect eStun = EffectStunned();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eMind = EffectVisualEffect(VFX_DUR_STUN);
    effect eLink = EffectLinkEffects(eStun, eMind);
    effect eDam;
	
	effect eBurst = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBurst, lLoc, 0.2); 
	
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE, lLoc);
    while (GetIsObjectValid(oTarget))
    {	 				
	    if (oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_SOUND_BURST));
			nDamage = d8();
			
                //Make a Fort roll to avoid being stunned
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
                }
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                //Apply the VFX impact and damage effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,oTarget);
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            
        }
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc);
    }
}

//---------------------------------------------------------------------------------------------------------------------------
// Stone to Mud
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Copper_Stone_Mud(object oPC, int nSpell)
{

    int nDice = GetTotalLevels(oPC, TRUE);
	int nDuration = nDice;
	
    effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE);
    location lTarget = GetSpellTargetLocation();
	
	
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Allows to change Dragon Size
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Size(object oPC, int nSpell)
{

	object oItem	= GetItemPossessedBy(oPC, "ps_essence");

	if (!X2PreSpellCastCode())
    {	return;	}
	
		// Disallows conversation if in humanoid form.	
		if (GetLocalInt(oItem, "TempChange") == 0)
		{
			AssignCommand(oPC, ActionStartConversation(oPC, "dragon_conv", TRUE, FALSE, TRUE, FALSE));
		}
		else 
		{
			SendMessageToPC(oPC, "<c=red>You cannot change size in humanoid form.");
		}
}

//---------------------------------------------------------------------------------------------------------------------------
// PRC: Hardening Scales (Applies Natural Armor)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Hardening_Scales(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iDragon1 = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC);
	int iDragon2 = GetLevelByClass(128, oPC);
	int iLevel = iDragon1 + iDragon2;
	int iNatural;
	int iDR;
	int iPower;

	if (GetHasFeat(3649, oPC))
	{			
		if (iLevel >= 10) 			//+10 bonus at level 10
			{	iNatural = 10;
				iDR = 10;
				iPower = DAMAGE_POWER_PLUS_THREE;	} 
		else if (iLevel >= 8)		//+8 bonus at level 8
			{	iNatural = 8;
				iDR = 5;
				iPower = DAMAGE_POWER_PLUS_ONE;		} 
		else if (iLevel >= 6)		//+6 bonus at level 6
			{	iNatural = 6;
				iDR = 5;
				iPower = DAMAGE_POWER_PLUS_ONE;		} 
		else if (iLevel >= 4)		//+4 bonus at level 4
			{	iNatural = 4;
				iDR = 5;
				iPower = DAMAGE_POWER_PLUS_ONE;		} 
		else if (iLevel >= 2)		//+2 bonus at level 2
			{	iNatural = 2;	
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		} 
		else 						//+0 at level 1
			{	iNatural = 0;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		}
	}
	else
	{		
		if (iLevel >= 10) 			//+8 bonus at level 10
			{	iNatural = 8;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		} 
		else if (iLevel >= 6)		//+6 bonus at level 6
			{	iNatural = 6;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		} 
		else if (iLevel >= 4)		//+4 bonus at level 4
			{	iNatural = 4;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		} 
		else if (iLevel >= 2)		//+2 bonus at level 2
			{	iNatural = 2;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		} 
		else 						//+0 at level 1
			{	iNatural = 0;
				iDR = 0;
				iPower = DAMAGE_POWER_NORMAL;		}			
	}	
			
	if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eAC		= EffectACIncrease(iNatural, AC_NATURAL_BONUS);
		effect eMagic	= EffectDamageReduction(iDR, iPower, 0, DR_TYPE_MAGICBONUS);
		effect ePierc	= EffectDamageReduction(iDR, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
		effect eDR		= EffectLinkEffects(eMagic, ePierc);
				eDR		= ExtraordinaryEffect(eDR);
				eAC 	= ExtraordinaryEffect(eAC);
	
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);	
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);	
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/piercing and +" + IntToString(iPower) + " applied.");
		SendMessageToPC(oPC, "Natural Armor of " + IntToString(iNatural) + " is applied.");		
	}				
}

//---------------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Senses (Applies Skill Boni)
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Senses(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}

	
	int iDragon1 = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC);
	int iDragon2 = GetLevelByClass(128, oPC);
	int iLevel = iDragon1 + iDragon2;
	int nSubRace = GetSubRace(oPC);
	int iSkillboni;
	int iSkill1 = SKILL_SPOT;
	int iSkill2 = SKILL_LISTEN;
	int iSkill3;
	int iSkill4;
	
	switch (nSubRace)
	{	case 0: //Debug
		SendMessageToPC(oPC, "Something is wrong.");	
		break;
		case 222: //Bronze
			iSkill3 = SKILL_BLUFF;
			iSkill4 = SKILL_SURVIVAL;
		break;
		case 223: //Red
			iSkill3 = SKILL_INTIMIDATE;
			iSkill4 = SKILL_APPRAISE;
		break;
		case 224: //Blue
			iSkill3 = SKILL_BLUFF;
			iSkill4 = SKILL_HIDE;
		break;
		case 225: //Shadow
			iSkill3 = SKILL_HIDE;
			iSkill4 = SKILL_MOVE_SILENTLY;
		break;
		case 226: //Black
			iSkill3 = SKILL_HIDE;
			iSkill4 = SKILL_MOVE_SILENTLY;
		break;
		case 227: //Copper
			iSkill3 = SKILL_BLUFF;
			iSkill4 = SKILL_SLEIGHT_OF_HAND;
		break;
		case 228: //Iron
			iSkill3 = SKILL_DIPLOMACY;
			iSkill4 = SKILL_INTIMIDATE;
		break;
		case 237: //Amethyst
			iSkill3 = SKILL_BLUFF;
			iSkill4 = SKILL_DIPLOMACY;
		break;
		case 238: //Emerald
			iSkill3 = SKILL_LORE;
			iSkill4 = SKILL_SEARCH;
		break;
		case 239: //Topaz
			iSkill3 = SKILL_TUMBLE;
			iSkill4 = SKILL_SURVIVAL;
		break;	
		case 240: //White
			iSkill3 = SKILL_SEARCH;
			iSkill4 = SKILL_SURVIVAL;
		break; 
		case 244: //Radiant
			iSkill3 = SKILL_HEAL;
			iSkill4 = SKILL_DIPLOMACY;
		break; 
	}
	
	if (iLevel >= 10)			//+6 bonus
	{	iSkillboni = 6;
		SendMessageToPC(oPC, "Draconic - Greater Skill Bonuses are applied.");	
			} 
	
	else if (iLevel >= 4)		//+3 bonus
	{	iSkillboni = 3;
		SendMessageToPC(oPC, "Draconic - Skill Bonuses are applied.");	
			} 

	else 						//+0 bonus
	{	iSkillboni = 0;
			}
		
	effect eSk1		=	EffectSkillIncrease(iSkill1, iSkillboni);
	effect eSk2 	=	EffectSkillIncrease(iSkill2, iSkillboni);
	effect eSk3 	=	EffectSkillIncrease(iSkill3, iSkillboni);
	effect eSk4 	=	EffectSkillIncrease(iSkill4, iSkillboni);
	effect eLink1	=	EffectLinkEffects(eSk1,eSk2);
	effect eLink2	=	EffectLinkEffects(eSk3,eSk4);
	effect eSense	=	EffectLinkEffects(eLink1,eLink2);
			eSense	=	ExtraordinaryEffect(eSense);
		
	if (!GetHasSpellEffect(nSpell, oPC))
	{			
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSense, oPC);			
	}
}



//---------------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Roar 
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Roar(object oPC, int nSpell)
{	
	string sSound;
	int nRoar = d6(1);

	switch (nRoar)
	{	case 1: 
			sSound = "dragon_roar1";	
		break;
		case 2:
			sSound = "dragon_roar2";		 
		break;
		case 3:
			sSound = "dragon_roar3";
		break;
		case 4: 
			sSound = "dragon_roar4";
		break;
		case 5:
			sSound = "dragon_roar5";
		break;
		case 6:
			sSound = "dragon_roar4";
		break;	 	 
	}
	
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	// Dragon Roar does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
			SendMessageToPC(oPC, "<c=red>Your lung is not strong enough in humanoid form!");
	}
	else 
	{	
		ClearAllActions();
		PlaySound(sSound, TRUE);
		DelayCommand(0.2f, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0, 3.0)));	
	
    	effect eAttack	= EffectAttackIncrease(2);
   		effect eDmg		= EffectDamageIncrease(2);
   		effect eFear 	= EffectSavingThrowIncrease(SAVING_THROW_TYPE_FEAR, 5, SAVING_THROW_TYPE_FEAR);
   		effect eDur 	= EffectVisualEffect(VFX_DUR_SPELL_HEROISM);		    
    	effect eLink1 	= EffectLinkEffects(eAttack, eDmg);
    	effect eLink2 	= EffectLinkEffects(eDur, eFear);
		effect eAlly 	= EffectLinkEffects(eLink1, eLink2);
	 
		effect eAttackPen	= EffectAttackDecrease(2, ATTACK_BONUS_MISC);
		effect eDur2 		= EffectVisualEffect(VFX_DUR_SPELL_DOOM);
		effect eEnemy	 	= EffectLinkEffects(eAttackPen, eDur2);
	 
		int iHD 	= GetTotalLevels(oPC, TRUE) - 2;
		
    	int nDuration 	= 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC);		
    	location lLoc 	= GetSpellTargetLocation();
    	float fDelay;
    
    	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lLoc);
    	while(GetIsObjectValid(oTarget))
    	{
        	if ((GetRacialType(oTarget) != 11) && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
        	{
           		fDelay = GetRandomDelay(0.8, 2.0);
            	SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));
            	DelayCommand(fDelay-0.01, RemoveEffectsFromSpell(oTarget, nSpell));
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAlly, oTarget, RoundsToSeconds(nDuration)));
       		}
			else if ((GetRacialType(oTarget) != 11) && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)) 
			{						
				if (GetHitDice(oTarget) < iHD)	
		    	{	
					if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
					{		
						fDelay = GetRandomDelay(0.8, 2.0);
          	 			SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));
            			DelayCommand(fDelay-0.01, RemoveEffectsFromSpell(oTarget, nSpell));
	       			 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEnemy, oTarget, RoundsToSeconds(nDuration)));				
					}
				}
			}		
        	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lLoc);
		}
	}	
}	

//---------------------------------------------------------------------------------------------------------------------------
// PRC: Frightful Presence or Dragon Presence
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Presence(object oPC, int nSpell)
{

	if (!X2PreSpellCastCode())
    {	return;	}

		if (!GetHasSpellEffect(nSpell, OBJECT_SELF))
		{
			effect eAOE 	= EffectAreaOfEffect(VFX_MOB_DRAGON_FEAR_PC);
			SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, 2647, FALSE));	
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, HoursToSeconds(100));
		}

}

//---------------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Tail Slap
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Swipe(object oPC, int nSpell)
{
    int nHD 	= GetHitDice(oPC);
	int nSize	= GetCreatureSize(oPC);
    int nDamage;
	float nArea;
	int nDamageType = DAMAGE_TYPE_BLUDGEONING;
	int nDamStrike;
	int nDC  	= 10 + nHD/2 + GetAbilityModifier(ABILITY_STRENGTH, oPC);

		
    float fDelay;
	float fFacing = GetFacing(OBJECT_SELF);
	float fRandomDuration;	
    object oTarget;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	location lLocation = GetBehindLocation(OBJECT_SELF, 3.0f);
	
    effect eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
	effect eKnockdown = EffectKnockdown();
	effect eDamage;
	
	if (nSize <= 3)
	{
		nArea = RADIUS_SIZE_MEDIUM; 
	}
	else if (nSize >=4)
	{
		nArea = RADIUS_SIZE_LARGE;
	}
		
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
		SendMessageToPC(oPC, "<c=red>You dont have a dragon tail in humanoid form.");
	}
	else 
	{
		AssignCommand(oPC, ClearAllActions());
		PlayCustomAnimation(OBJECT_SELF, "Una_tailslap", 0, 0.4f);	
  		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nArea, lLocation, FALSE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{
        	if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
				if(GetCreatureSize(oTarget) <= GetCreatureSize(oPC))				
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					if (GetHasFeat(3649, oPC))
						{	nDamage = d6(nHD);	}
					else
						{	nDamage = d4(nHD);	}					
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					fRandomDuration = RandomFloatBetween(6.0, 12.0);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
	              		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
 	              		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					}
				}		            	
				else
				{
					SendMessageToPC(oPC, "<c=yellow>Your target is too large to be affected.");
				}														 
			}				
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, nArea, lLocation, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
}	


					