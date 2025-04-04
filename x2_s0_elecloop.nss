//::///////////////////////////////////////////////
//:: Gedlee's Electric Loop
//:: X2_S0_ElecLoop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create a small stroke of lightning that
    cycles through all creatures in the area of effect.
    The spell deals 1d6 points of damage per 2 caster
    levels (maximum 5d6). Those who fail their Reflex
    saves must succeed at a Will save or be stunned
    for 1 round.

    Spell is standard hostile, so if you use it
    in hardcore mode, it will zap yourself!

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 19 2003
//:://////////////////////////////////////////////
//::Mymothersmeatloaf 6/20/2020 - Upped scaling to 10d6

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void main()
{

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


    location lTarget    = GetSpellTargetLocation();
    effect   eStrike    = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    int      nMetaMagic = GetMetaMagicFeat();
    float    fDelay;
    effect   eBeam;
    int      nDamage;
    int      nPotential;
	int 	 PML = GetPureMageLevels(OBJECT_SELF);
    effect   eDam;
    object   oLastValid;
    effect   eStun = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN),EffectStunned());
	

    //--------------------------------------------------------------------------
    // Calculate Damage Dice. 1d per 2 caster levels, max 5d
    //--------------------------------------------------------------------------
    int nNumDice = PS_GetCasterLevel(OBJECT_SELF);
    if (nNumDice<1)
    {
        nNumDice = 1;
    }
    else if (nNumDice >13)
    {
        nNumDice = 13;
    }

    //--------------------------------------------------------------------------
    // Loop through all targets
    //--------------------------------------------------------------------------
	// BCH - OEI 03/17/06, bumped up to MEDIUM size otherwise it only hits one target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //------------------------------------------------------------------
            // Calculate delay until spell hits current target. If we are the
            // first target, the delay is the time until the spell hits us
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                   fDelay += 0.2f;
                   fDelay += GetDistanceBetweenLocations(GetLocation(oLastValid), GetLocation(oTarget))/20;
            }
            else
            {
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            }

            //------------------------------------------------------------------
            // If there was a previous target, draw a lightning beam between us
            // and iterate delay so it appears that the beam is jumping from
            // target to target
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                 eBeam = EffectBeam(VFX_BEAM_LIGHTNING, oLastValid, BODY_NODE_CHEST);
                 DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam,oTarget,1.5f));
            }

            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                nPotential = d6(nNumDice) + d2(PML/6);
				
				//Resolve metamagic
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
				nPotential = (nPotential*2);
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
				nPotential = nPotential + nPotential / 2;
				}
                nDamage    = GetReflexAdjustedDamage(nPotential, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);

                //--------------------------------------------------------------
                // If we failed the reflex save, we save vs will or are stunned
                // for one round
                //--------------------------------------------------------------
                if (nPotential == nDamage || (GetHasFeat(FEAT_IMPROVED_EVASION,oTarget) &&  nDamage == (nPotential/2)))
                {
                    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oTarget, RoundsToSeconds(1)));
                    }

                }


                if (nDamage >0)
                {
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget));
                 }
            }

            //------------------------------------------------------------------
            // Store Target to make it appear that the lightning bolt is jumping
            // from target to target
            //------------------------------------------------------------------
            oLastValid = oTarget;

        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

}