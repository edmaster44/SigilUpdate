//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The initial eruption of flame causes  2d6 fire damage +1
   point per caster level(maximum +10)
   with no saving throw.

   Further, the creature must make
   a Reflex save or catch fire taking a further 1d6 points
   of damage. This will continue until the Reflex save is
   made.

   There is an undocumented artificial limit of
   10 + casterlevel rounds on this spell to prevent
   it from running indefinitly when used against
   fire resistant creatures with bad saving throws

*/
//:://////////////////////////////////////////////
// Created: 2003/09/05 Georg Zoeller
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
// Modified: 8/16/06 - BDF-OEI: updated the target validity check 
//:://////////////////////////////////////////////
//:Mymothersmeatloaf: 6/20/2020 - Uncapped the +1 damage and set dice to 5d6 instead of 2d6

#include "x2_I0_SPELLS"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic);

void main()
{

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;

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
    // Calculate the save DC
    //--------------------------------------------------------------------------
    int nDC = GetSpellSaveDC();
    int nLevel = GetCasterLevel(OBJECT_SELF);
	//Casting modifier
	int CasterModifier = 0;
	//Determine Caster modifier
	if (GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF) > GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF)) {
		CasterModifier = GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF);
	}
	else {
		CasterModifier = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
	}

    //--------------------------------------------------------------------------
    // Calculate the damage, 2d6 + casterlevel, capped at +10
    //--------------------------------------------------------------------------
    int nDamage = GetCasterLevel(OBJECT_SELF);
	//uncap +1 damage
   /* if (nDamage > 10)
    {
        nDamage = 10;
    }*/
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage += 30+CasterModifier;//Damage is at max
    }
    else
    {
		//Changed dice to 5d6
        nDamage  += d6(5)+CasterModifier;
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
        }
    }

	
    //--------------------------------------------------------------------------
    // Calculate the duration (we need a duration or bad things would happen
    // if someone is immune to fire but fails his safe all the time)
    //--------------------------------------------------------------------------
    int nDuration = 10 + GetCasterLevel(OBJECT_SELF);
    if (nDuration < 1)
    {
        nDuration = 10;
    }
	 if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //--------------------------------------------------------------------------
    // Setup Effects
    //--------------------------------------------------------------------------
    
	
    //if(!GetIsReactionTypeFriendly(oTarget))	// BDF: obsolete conditional
	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

       //-----------------------------------------------------------------------
       // Check SR
       //-----------------------------------------------------------------------
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
		
            //------------------------------------------------------------------
            // This spell no longer stacks. If there is one of that type,
            // that's enough
            //------------------------------------------------------------------
            if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
            {
                FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
                return;
            }
			
			// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_FIRE);
			
			effect eDam      = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
			effect eVis2	= EffectVisualEffect(VFX_DUR_FIRE);
			effect eHit = EffectLinkEffects(eDam, eVis);

           //-------------------------------------------------------------------
           // Apply VFX
           //-------------------------------------------------------------------
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, RoundsToSeconds(nDuration));
            TLVFXPillar(VFX_HIT_SPELL_EVOCATION, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);



            //------------------------------------------------------------------
            // Save the spell save DC as a variable for later retrieval
            //------------------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST), nDC);

            //------------------------------------------------------------------
            // Tick damage after 6 seconds again
            //------------------------------------------------------------------
            DelayCommand(6.0, RunCombustImpact(oTarget,oCaster,nLevel, nMetaMagic));
        }
    }
}

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic)
{
     //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {

        int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));

        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            //------------------------------------------------------------------
            // Calculate the damage, 1d6 + casterlevel, capped at +10
			// Changed cap to caster level
            //------------------------------------------------------------------
            int nDamage = nLevel;
          /*  if (nDamage > 10)
            {
                nDamage = 10;
            }*/
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage += 6;
            }
            else
            {
                nDamage  += d6();
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2);
                }
            }

            effect eDmg = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
            effect eVFX = EffectVisualEffect(VFX_HIT_SPELL_FIRE);

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

            //------------------------------------------------------------------
            // After six seconds (1 round), check damage again
            //------------------------------------------------------------------
            DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, nLevel,nMetaMagic));
        }
        else
        {
            DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
            GZRemoveSpellEffects(SPELL_COMBUST, oTarget);
        }

   }

}