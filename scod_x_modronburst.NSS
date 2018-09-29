// gb_balor_de
//
// a balor explodes on death.

// JSH-OEI 5/10/07
// EPF 7/13/07 - moving to global

#include "NW_I0_SPELLS"    
void main()
{
    //Declare major variables
	object oPC = GetFirstPC();
    object oCaster = OBJECT_SELF;
	location lSpore = GetLocation(oCaster);
	int nDuration = GetTotalLevels(OBJECT_SELF, FALSE);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_HIT_AOE_MAGIC, FALSE);
    
	
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(OBJECT_SELF);
    //Limit Caster level for the purposes of damage
    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplode, lTarget, 5.0);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    
    //Cycle through the targets within the spell shape until an invalid object is captured.
    
	
	ExecuteScript("nw_c2_default7", OBJECT_SELF);
	object oSpawn1 = CreateObject(1, "ps_c_minidrone", lSpore, FALSE, "");
	object oSpawn2 = CreateObject(1, "ps_c_minidrone", lSpore, FALSE, "");
}