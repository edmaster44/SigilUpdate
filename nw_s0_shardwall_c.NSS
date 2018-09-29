#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void IntruderCheck();

void main()
{
	IntruderCheck();
	DelayCommand(3.0f, IntruderCheck());
}

void IntruderCheck()
{
    //Declare major variables
    object oTarget;
	object oCreator = GetAreaOfEffectCreator();
    effect eDam;
//    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
	effect eVis = EffectNWN2SpecialEffectFile("sp_magic_hit.sef");
	effect eBlindness = EffectBlindness();	
	effect eDeaf = EffectDeaf();
	effect eSlow = EffectSlow();

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // Add damage to placeables/doors now that the command support bit fields
    //--------------------------------------------------------------------------
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (GetIsDead(oCreator) == TRUE)
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator))
        {
            //Fire spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_BLADE_BARRIER));
            //Make SR Check

            //Roll Damage
            int nDamage = d6(3);
          
            //Set damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
			
			//Apply damage and VFX
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget);
			ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			
			if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, 28) == FALSE)
            {
				ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlindness, oTarget, 3.0f);
				ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDeaf, oTarget, 3.0f);
				ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oTarget, 3.0f);
            }
		}
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }
}