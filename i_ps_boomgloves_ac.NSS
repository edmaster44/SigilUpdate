
/*
i_ps_boomgloves_ac

Custom OnActivate power for Mordechai's Explosive Gloves

Written for SCOD - Sigil, City of Doors

Author:					Savageaxe
Date:					26JULY2010
LastModified Date:
LastModfied By:

*/

/*
History of Changes
*/

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    location lTarget = GetItemActivatedTargetLocation();

	
	// Firstly, do they have anything equipped in either hand?
	// these gloves require they be "clasped" together, so if they do, this won't work
	if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) != OBJECT_INVALID 
		|| GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
	{
		SendMessageToPC(oPC, GetName(oItem)+" cannot be used with items equipped in either hand.");
		return;		
	}
			
    int nCasterLvl = GetHitDice(oPC);
	int nDamage;
	float fDelay;
	effect eDam;
	
	location lGroundZero = GetLocation(oPC);
	effect eVis3 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	
	/// Okay, now we apply the VFX's for item activation and explosion to the user

	effect eCasting =  EffectNWN2SpecialEffectFile("fx_kos_slow_cast", oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCasting, oPC, 2.0f);
	
	FloatingTextStringOnCreature("<b><i><COLOR=RED>"+GetName(oPC)+"'s gloves begin to glow!", oPC, TRUE, 2.5f); 

	/// Everything after this is applied on a 5 second timer - VFX, damage, etc	
	//effect eExplosion = EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_DOOM);
	effect eExplosion = EffectNWN2SpecialEffectFile("fx_kos_death", oPC);	
	effect eQuake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);

	/*DelayCommand(3.0f, */ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, GetLocation(oPC))/*)*/;
	DelayCommand(5.0f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eQuake, GetLocation(oPC), 3.0f));
	
	/// Grab objects in a sphere around the activator
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 
		RADIUS_SIZE_HUGE, lGroundZero, TRUE, 
			OBJECT_TYPE_CREATURE  | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );		 
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {		
        //Get the distance between the explosion and the target to calculate delay
		//Remember to add the regular (currently 3 second) delay to it
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 5.0f;
		
		DelayCommand(5.0f, 
			SignalEvent(OBJECT_SELF, EventSpellCastAt(oTarget,SPELL_GREATER_FIREBURST)));
        				
		   	//Roll damage for each target
            nDamage = (nCasterLvl*10) - (d4()<3? -d4(10): d4(10));
			if (nDamage < 50)
				nDamage = 50 - (d4() <3 ? -d4(4): d4(4));		
		  
			// Adjust damage for reflex saves and evasions
          	if (oTarget != oPC)
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), 
					SAVING_THROW_TYPE_POSITIVE);

			//Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
            if(nDamage > 0)
            {
            	// Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
            }

		//Select the next target within the spell shape.
       	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lGroundZero, 
			TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );

	} /// while valid objects


}