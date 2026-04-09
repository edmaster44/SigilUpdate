//::///////////////////////////////////////////////
//:: x1_s2_seeker
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Seeker Arrow
     - creates an arrow that automatically hits target.
     - normal arrow damage, based on base item type

     - Must have shortbow or longbow in hand.


     APRIL 2003
     - gave it double damage to balance for the fact
       that since its a spell you are losing
       all your other attack actions

     SEPTEMBER 2003 (GZ)
        Added damage penetration
        Added correct enchantment bonus


*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "ps_inc_onhit"

void main()
{
    int nBonus = 0;
    nBonus = 1;
	
    object oTarget = GetSpellTargetObject();
	object oCaster = OBJECT_SELF;
	location lSource = GetLocation( oCaster );
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType == BASE_ITEM_LONGBOW ||
		 nLauncherBaseItemType == BASE_ITEM_SHORTBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	} else if ( nLauncherBaseItemType == BASE_ITEM_HEAVYCROSSBOW ||
		 nLauncherBaseItemType == BASE_ITEM_LIGHTCROSSBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_LIGHTCROSSBOW;
	} else if (nLauncherBaseItemType == BASE_ITEM_SLING) {
		nLauncherBaseItemType = BASE_ITEM_SLING;
	} else {
		SendMessageToPC(oCaster, "You need to have a ranged weapon equipped to use this ability");
		return;
	}
	
    if (GetIsObjectValid(oTarget) == TRUE)
    {
		location lTarget = GetLocation( oTarget );
		float fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );
		
        int nDamage = ArcaneArcherDamageDoneByBow() *2;
        if (nDamage > 0)
        {
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
            //effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);

          	//Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));

			SpawnItemProjectile( OBJECT_SELF, oTarget, lSource, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0 );
            DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget) );
			DelayCommand( fTravelTime, DoElementalDamage(OBJECT_SELF, oTarget, TRUE));
			DelayCommand( fTravelTime, 	DoAlignedDamage(OBJECT_SELF, oTarget));
        }
    }
}