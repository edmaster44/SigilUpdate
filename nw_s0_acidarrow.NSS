//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An acidic arrow springs from the caster's hands
    and does 3d6 acid damage to the target.  For
    every 3 levels the caster has the target takes an
    additional 1d6 per round.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, Oct 29, 2003
//:: Now uses VFX to track its own duration, cutting
//:: down the impact on the CPU to 1/6th
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Require ranged touch attack to hit.
//:: AFW-OEI 04/05/2007: No spell resistance.
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nw_i0_spells"
#include "ps_inc_functions"

void RunImpact(object oTarget, object oCaster, int nMetamagic);

void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = (PS_GetCasterLevel(OBJECT_SELF)/6);
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
	if (nCL > 13)
    {
        nCL = 13;
    }


    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }


    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    effect eDur      = EffectVisualEffect(VFX_DUR_SPELL_MELFS_ACID_ARROW);
    //effect eArrow = EffectVisualEffect(245);


    //--------------------------------------------------------------------------
    // Set the VFX to be non dispelable, because the acid is not magic
    //--------------------------------------------------------------------------
    eDur = ExtraordinaryEffect(eDur);
     // * Dec 2003- added the reaction check back in
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);
		int nTouch      = TouchAttackRanged(oTarget, TRUE);

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{
	        //if(MyResistSpell(OBJECT_SELF, oTarget) == FALSE)
	        {
	            //----------------------------------------------------------------------
	            // Do the initial 3d6 points of damage
	            //----------------------------------------------------------------------
	            int nDamage = d6(nCL) + d2(PML/6) ;
				//Resolve metamagic
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
				nDamage = nDamage + ((3*nDamage)/4);;
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
				nDamage = nDamage + nDamage / 2;
				}
				
				//PKM-OEI: 05.28.07: Do critical hit damage
				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
				{
					 nDamage = MaximizeOrEmpower(6,(nCL*2),nMetaMagic);
				}
				
				// If applicable adds any sneak damage to total to be inflicted and reports the damage.
				nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_ACID);
				
	            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);

				//DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            //DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

	            //--------------------------------------------------------------------------
	            // This spell no longer stacks. If there is one of that type, thats ok
	            //--------------------------------------------------------------------------
	            if (GetHasSpellEffect(GetSpellId(),oTarget))
	            {
	                //RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)+0.1);
	                return;
	            }
	
	            //----------------------------------------------------------------------
	            // Apply the VFX that is used to track the spells duration
	            //----------------------------------------------------------------------
	            //DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)+0.1);
	            object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
	            DelayCommand(6.0f,RunImpact(oTarget, oSelf,nMetaMagic));
	        }
			/*
	        else
	        {
	            //----------------------------------------------------------------------
	            // Indicate Failure
	            //----------------------------------------------------------------------
	            effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
	            DelayCommand(fDelay+0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
	        }
			*/
		}
    }
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic)
{
	
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int PML = GetPureMageLevels(OBJECT_SELF);
		int nDamage = d6(2) + d2(PML/6);
		//Resolve metamagic
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
		nDamage = nDamage + ((3*nDamage)/4);
		}
		else if (nMetaMagic == METAMAGIC_EMPOWER)
		{
		nDamage = nDamage + nDamage / 2;
		}
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic));
    }
}