/*
	rh_giant_boulder_throw

Risen Hero Giant Boulder Throw Script

Written by Shaughn

Thanks to Tony K from the bioware foums for his help

also used x2_s1_hurlrock bioware script as an outline

Little Baron's Cowtapult! LB's Ballista projectile demonstration
was used to create the rock projectile.
http://nwvault.ign.com/View.php?view=NWN2HakpaksOriginal.Detail&id=297

Uses spell.2da line 9300 custom spell for rock throwing used for visual effects

When called for in giant's user define scripts will cause a giant to hurl a boulder a
at anemy doing 2 d6 damage. Addition bonus for different giants.

*/
//---------------------------------------------------------------------------

void RockThrow(location lLocation);
float TravelTime(location lLocation);
void DamageAnimation(object oTarget);
void WeaponVis(object oSelf);

//-----------------------------------------------------------------------------
   
void BoulderThrow (location lImpact)
{
	

	//location lImpact = GetSpellTargetLocation();
	effect eImpact	 = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big");
	float fTime 	 = TravelTime(lImpact);
	effect eRock	 = EffectNWN2SpecialEffectFile("box_toss_a");
	
	SetWeaponVisibility(OBJECT_SELF,0,0);
	
	//Animation and sounds for attack
	//PlayCustomAnimation(OBJECT_SELF,"taunt",0,1.0);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRock,OBJECT_SELF,1.5);
	DelayCommand(0.5,PlaySound("c_giantfire_atk2"));
	AssignCommand(OBJECT_SELF,ActionCastFakeSpellAtLocation(9300,lImpact,PROJECTILE_PATH_TYPE_DEFAULT));
	
	RockThrow(lImpact);
	
	DelayCommand(1.5+fTime,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eImpact,lImpact));
	DelayCommand(1.5+fTime,PlaySound("c_stonegolembatt_03"));
	
	DelayCommand(1.5+fTime,WeaponVis(OBJECT_SELF));
}

//-----------------------------------------------------------------------------

float TravelTime(location lImpact)
//Calculates time for boulder to travel
{
	location lSourceLoc = GetLocation(OBJECT_SELF);
	float fTravelTime 	= GetProjectileTravelTime(lSourceLoc, lImpact, PROJECTILE_PATH_TYPE_BALLISTIC_THROWN);
	return (fTravelTime);
}

//----------------------------------------------------------------------------

void RockThrow (location lLocation)
//damages
{
	
	object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLocation, TRUE, OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE);

	int iAttackMod 		= GetAbilityModifier(ABILITY_STRENGTH);
	int iDamageAmount	= d6(12)+iAttackMod; //Base Damage for boulders
	int iDamageBonus	= FALSE; //Bonus damage based on giant type
	int iGiant			= GetSubRace(OBJECT_SELF);
	int iAppearance		= GetAppearanceType(OBJECT_SELF);
	effect eBonusDamage;
	effect eDamage		= EffectDamage(iDamageAmount,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL);
	float fTravelT		= TravelTime(lLocation);	

//-----------------------------------------------------------------------------------
//Giant Types and bonuses applied
//Fire giants do fire damage

	if (iAppearance == APPEARANCE_TYPE_GIANT_FIRE)
	{
	
		iDamageBonus = TRUE;
		eBonusDamage = EffectDamage(d6(2),DAMAGE_TYPE_FIRE,DAMAGE_POWER_NORMAL,FALSE);
	}
//----------------------------------------------------------------------------
//Attack

	while (GetIsObjectValid(oTarget))
	{
		int iTarget = GetObjectType(oTarget);
		
		
		if (iTarget == OBJECT_TYPE_PLACEABLE || iTarget == OBJECT_TYPE_DOOR) 
		{
			DelayCommand(1.5+fTravelT,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
			if (iDamageBonus == TRUE)
			{
				DelayCommand(1.5+fTravelT,ApplyEffectToObject(DURATION_TYPE_INSTANT,eBonusDamage,oTarget));
			}	
		}
		
		else //All creatures
		{
			int iAttack	= TouchAttackRanged(oTarget,TRUE,iAttackMod);//see if hit
			
		
			if (iAttack != TOUCH_ATTACK_RESULT_MISS)
			{
				if (iAttack == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					iDamageAmount *= 2;
				}
				
				int iDamage = GetReflexAdjustedDamage(iDamageAmount,oTarget,18,SAVING_THROW_TYPE_NONE,OBJECT_SELF);
				eDamage = EffectDamage(iDamage,DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_NORMAL);
				
				DelayCommand(1.5+fTravelT,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
				if (iDamageBonus == TRUE)
				{
					DelayCommand(1.5+fTravelT,ApplyEffectToObject(DURATION_TYPE_INSTANT,eBonusDamage,oTarget));
				}
				DelayCommand(1.5+fTravelT,DamageAnimation(oTarget));
			}
			
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLocation, TRUE, OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE);				
		}	
	}
}
//----------------------------------------------------------------------------

void DamageAnimation(object oTarget)
//animation and sound when hurt
{
	PlayCustomAnimation(oTarget,"*damage01",0,1.0);
	PlayVoiceChat(VOICE_CHAT_PAIN1,oTarget);
}

//----------------------------------------------------------------------------------

void WeaponVis(object oSelf)
//makes weapon visible
{
	SetWeaponVisibility(oSelf,1,0);
}