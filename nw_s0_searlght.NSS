//::///////////////////////////////////////////////
//:: Searing Light
//:: s_SearLght.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Focusing holy power like a ray of the sun, you project
//:: a blast of light from your open palm. You must succeed
//:: at a ranged touch attack to strike your target. A creature
//:: struck by this ray of light suffers 1d8 points of damage
//:: per two caster levels (maximum 5d8). Undead creatures suffer
//:: 1d6 points of damage per caster level (maximum 10d6), and
//:: undead creatures particularly vulnerable to sunlight, such
//:: as vampires, suffer 1d8 points of damage per caster level
//:: (maximum 10d8). Constructs and inanimate objects suffer only
//:: 1d6 points of damage per two caster levels (maximum 5d6).
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: 02/05/2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 06/06/2006:
//::	Rays hit with ranged touch attacks
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage
//::					- Modernized metamagic behaviors


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"
#include "ps_inc_functions"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
	int nTouch      = TouchAttackRanged(oTarget);
	int nMetaMagic = GetMetaMagicFeat();
//    if (nCasterLevel > 13)	 // Limit caster level
//        nCasterLevel = 13;
	 if (nCasterLevel <= 0)
		nCasterLevel = 1;
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEARING_LIGHT));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
	    {    //Make an SR Check
	        if (!MyResistSpell(oCaster, oTarget))
	        {
			    int nDamage;
			    int nMax;
	            //Check for racial type undead
	            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
	            {
					nDamage = d3(nCasterLevel);
					if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
					nDamage = d3(20);
					} 
	                //nMax = 8;
					//Resolve metamagic
					if (nMetaMagic == METAMAGIC_MAXIMIZE)
					{
					nDamage = nDamage + ((3*nDamage)/4);;
					}
					else if (nMetaMagic == METAMAGIC_EMPOWER)
					{
					nDamage = nDamage + nDamage / 2;
					}
					
				
					/*if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
					{ 
						nDamage = d6(nCasterLevel * 2);
						nDamage = ApplyMetamagicVariableMods(nDamage, (nCasterLevel*2)*6);
					}*/
	            }
	            //Check for racial type construct
	            else if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
	            {
	                
	                nDamage = (nCasterLevel);
					if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
					nDamage = d3(20);
					} 
	                //nMax = 6;
					//Resolve metamagic
					if (nMetaMagic == METAMAGIC_MAXIMIZE)
					{
					nDamage = nDamage + ((3*nDamage)/4);;
					}
					else if (nMetaMagic == METAMAGIC_EMPOWER)
					{
					nDamage = nDamage + nDamage / 2;
					}
					
					/*if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
					{ 
						nDamage = d6(nCasterLevel * 2);
						nDamage = ApplyMetamagicVariableMods(nDamage, (nCasterLevel*2)*6);
					}*/
					
	            }
	            else
	            {
	                
	                nDamage = d2(nCasterLevel);
					if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
					nDamage = d3(20);
					} 
	                //nMax = 8;
					//Resolve metamagic
					if (nMetaMagic == METAMAGIC_MAXIMIZE)
					{
					nDamage = nDamage + ((3*nDamage)/4);
					}
					else if (nMetaMagic == METAMAGIC_EMPOWER)
					{
					nDamage = nDamage + nDamage / 2;
					}
					
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{ 
						nDamage = d2(nCasterLevel * 2);
						nDamage = ApplyMetamagicVariableMods(nDamage, (nCasterLevel*2)*2);
					}					
					
	            }
	
	            //Make metamagic checks
	    		/*int nMetaMagic = GetMetaMagicFeat();
	            if (nMetaMagic == METAMAGIC_MAXIMIZE)
	            {
	                nDamage = nMax * nCasterLevel;
	            }
	            if (nMetaMagic == METAMAGIC_EMPOWER)
	            {
	                nDamage = nDamage + (nDamage/2);
	            }
				*/
				

				
	
	            //Set the damage effect
	            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
    			effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SEARING_LIGHT );

	            //Apply the damage effect and VFX impact
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
		}
    }
    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}