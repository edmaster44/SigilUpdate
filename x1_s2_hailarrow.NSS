//::///////////////////////////////////////////////
//:: x1_s2_hailarrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    One arrow per arcane archer level at all targets

    GZ SEPTEMBER 2003
        Added damage penetration

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "ps_inc_onhit"

// GZ: 2003-07-23 fixed criticals not being honored
void DoAttack(object oTarget)
{
    int nBonus = 1;
    int nDamage;
    // * Roll Touch Attack
    int nTouch = TouchAttackRanged(oTarget, TRUE);
    if (nTouch > 0)
    {
        int bCrit = (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT));
        nDamage = ArcaneArcherDamageDone(bCrit);
        if (nDamage > 0)
        {
            // * GZ: Added correct damage power
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
			DoElementalDamage(OBJECT_SELF, oTarget, bCrit);
			DoAlignedDamage(OBJECT_SELF, oTarget);
        }
    }
}

void main()
{

    object oTarget;

    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType == BASE_ITEM_LONGBOW)
		nLauncherBaseItemType = BASE_ITEM_LONGBOW;
	else if ( nLauncherBaseItemType == BASE_ITEM_SHORTBOW)
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	else if ( nLauncherBaseItemType == BASE_ITEM_LIGHTCROSSBOW)
		nLauncherBaseItemType = BASE_ITEM_LIGHTCROSSBOW;
	else if ( nLauncherBaseItemType == BASE_ITEM_HEAVYCROSSBOW)
		nLauncherBaseItemType = BASE_ITEM_HEAVYCROSSBOW;
	else if ( nLauncherBaseItemType == BASE_ITEM_SLING)
		nLauncherBaseItemType = BASE_ITEM_SLING;
	else {
		SendMessageToPC(OBJECT_SELF, "You need to have a ranged weapon equipped to use this ability");
		return;
	}
	
    int i = 0;
    float fDist = 0.0;
    float fDelay = 0.0;
	float fTravelTime;
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	location lCaster = GetLocation( OBJECT_SELF );
	location lTarget;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 80.0f, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	int num = 0;
    while(GetIsObjectValid(oTarget))
    {
		if (num > GetHitDice(OBJECT_SELF)) //don't target more people than we have levels, for sanity.
			break;
		if (!spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
			continue;
			
        lTarget = GetLocation( oTarget );
		if ( i == 1 )
		{
			if ( GetDistanceBetween(OBJECT_SELF, oTarget) > 20.0f )
			{
				nPathType = PROJECTILE_PATH_TYPE_BALLISTIC;
			}
			fDelay = 0.0f;
		}
		else
		{
			fDelay += 0.1f;
		}
		
		fTravelTime = GetProjectileTravelTime( lCaster, lTarget, nPathType );

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		DelayCommand( fDelay, SpawnItemProjectile(OBJECT_SELF, oTarget, lCaster, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0) );
        DelayCommand( fDelay + fTravelTime, DoAttack(oTarget) );
		num++;
        
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 80.0f, lCaster, TRUE, OBJECT_TYPE_CREATURE);
    }
}