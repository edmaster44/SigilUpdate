#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"

void main() {

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//Declare major variables
    location 	lTarget 	= 	GetSpellTargetLocation();
	object 		oCaster 	=	OBJECT_SELF;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    effect 		eDur 		= 	EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
			{
            	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}