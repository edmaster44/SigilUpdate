//::///////////////////////////////////////////////
//:: x1_s2_deatharrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Seeker Arrow
     - creates an arrow that automatically hits target.
     - At level 4 the arrow does +2 magic damage
     - at level 5 the arrow does +3 magic damage

     - normal arrow damage, based on base item type

     - Must have shortbow or longbow in hand.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_itemprop"
#include "ps_inc_onhit"

void main()
{
    int nBonus = 1;

    object oTarget = GetSpellTargetObject();
	location lSource = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType != BASE_ITEM_LONGBOW &&
		 nLauncherBaseItemType != BASE_ITEM_SHORTBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	}
	else if ( nLauncherBaseItemType != BASE_ITEM_HEAVYCROSSBOW &&
		 nLauncherBaseItemType != BASE_ITEM_LIGHTCROSSBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_LIGHTCROSSBOW;
	}

    if (GetIsObjectValid(oTarget) == TRUE)
    {
        location lTarget = GetLocation( oTarget );
        float fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );

        // * Roll Touch Attack
        int nTouch = TouchAttackRanged(oTarget, TRUE);
        if (nTouch > 0)
        {
            int bCrit = (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT));
            int nDamage = ArcaneArcherDamageDone(bCrit);

            if (nDamage > 0)
            {
                effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
                DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget) );
				DelayCommand( fTravelTime, DoElementalDamage(OBJECT_SELF, oTarget, bCrit));
				DelayCommand( fTravelTime, 	DoAlignedDamage(OBJECT_SELF, oTarget));

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                // * if target fails a save DC20 they die
				int nDC = 20+GetAbilityModifier(5, OBJECT_SELF);
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, nDC) == 0)
                {
                    effect eDeath = EffectDeath();
                    DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget) );
                }
            }
        }
        SpawnItemProjectile( OBJECT_SELF, oTarget, lSource, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0 );
    }
}