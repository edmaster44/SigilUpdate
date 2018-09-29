//::///////////////////////////////////////////////
//:: qn_inc_beholder
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Q-Necron, Edited by Alersia
//:://////////////////////////////////////////////
#include "x0_i0_spells"

//------------------------------------------------------------------------------
// Beholder's Eye Rays: Shape & Size
//------------------------------------------------------------------------------
int BEHOLDER_TARGET_SHAPE = SHAPE_SPHERE;
float BEHOLDER_TARGET_SIZE = RADIUS_SIZE_LARGE;

//------------------------------------------------------------------------------
// Eye Rays: Charm, Fear & Sleep
//------------------------------------------------------------------------------
effect eBeam_Mind = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_MONSTER_0);
//------------------------------------------------------------------------------
// Eye Rays: Disintigrate & Finger of Death
//------------------------------------------------------------------------------
effect eBeam_Disintegrate = EffectBeam(447, OBJECT_SELF, BODY_NODE_MONSTER_1);
effect eBeam_Death = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_MONSTER_1);
//------------------------------------------------------------------------------
// Eye Rays: Flesh to Stone & Inflict Moderate Wounds
//------------------------------------------------------------------------------
effect eBeam_Stone = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_MONSTER_3);
effect eBeam_Inflict = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_MONSTER_3);
//------------------------------------------------------------------------------
// Eye Rays: Slow & Telekensis
//------------------------------------------------------------------------------
effect eBeam_Slow = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_MONSTER_4);
effect eBeam_Telekensis = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_MONSTER_4);

//------------------------------------------------------------------------------
// Count the number of creatures near the targeted object.
//------------------------------------------------------------------------------
int UnitCount(object oTarget)
{
    int nUnitCount = 0;
    location lTarget = GetLocation(oTarget);

    //Get the first PC.
    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetIsDead(oTarget) == FALSE &&
        GetHasEffect(EFFECT_TYPE_SLEEP, oTarget) == FALSE)
        {
            //+1 to UnitCount.
            nUnitCount++;
        }
        //Get next PC.
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    //Return how many players there are.
    return nUnitCount;
    //SendMessageToPC(OBJECT_SELF, "Number of targets: "+IntToString(nUnitCount)+".");
}

//------------------------------------------------------------------------------
// Charm Person/Animal, Fear & Sleep
//------------------------------------------------------------------------------
void Ray_Mind(object oTarget, int nDC, int nPlayer, effect eEye, int Dur_VFX, int Vis_VFX, float fDuration)
{
    int nCount;
    effect eDur = EffectVisualEffect(Dur_VFX);
    effect eVis = EffectVisualEffect(Vis_VFX);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                if(TouchAttackRanged(oTarget) > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) == 0)
                    {
                        //Link effects.
                        eLink = EffectLinkEffects(eEye, eDur);
                        eLink = EffectLinkEffects(eVis, eLink);

                        //Apply effects.
                        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                    }
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Mind, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//------------------------------------------------------------------------------
// Disintigrate
//------------------------------------------------------------------------------
void Ray_Disintegrate(object oTarget, int nDC, int nPlayer)
{
    int nCount;
	int nHD = GetHitDice(OBJECT_SELF);
    int nDamage = d6(nHD);
    int nTouch;
    effect eDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                nTouch = TouchAttackRanged(oTarget);
                if(nTouch > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_ALL) == 1)
                    {
                        nDamage = d6(5);
                    }

                    //Critical
                    if(nTouch == 2){nDamage *= 2;}

                    //Set damage.
                    eDamage = EffectDamage(nDamage);

                    //Link effects.
                    eLink = EffectLinkEffects(eDamage, eVis);

                    //Apply effects.
                    DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));

                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Disintegrate, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//------------------------------------------------------------------------------
// Finger of Death
//------------------------------------------------------------------------------
void Ray_Death(object oTarget, int nDC, int nPlayer)
{
    int nCount;
    int nDamage = d6(3) + 13;
    int nTouch;
    effect eDamage;
    effect eDeath = EffectDeath(TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                nTouch = TouchAttackRanged(oTarget);
                if(nTouch > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH) == 0)
                    {
                        //Apply effects.
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
						{	DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));	}
                    }
                    else
                    {
                        //Critical
                        if(nTouch == 2){nDamage *= 2;}

                        //Set damage.
                        eDamage = EffectDamage(nDamage);

                        //Link effects.
                        eLink = EffectLinkEffects(eDamage, eVis);

                        //Apply effects.
                        if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
						{	DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));	}
                    }
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Death, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//------------------------------------------------------------------------------
// Flesh to Stone
//------------------------------------------------------------------------------
void Ray_Stone(object oTarget, int nDC, int nPlayer)
{
    int nCount;
    effect eStone = EffectPetrify();
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;
            if(nCount == nPlayer)
            {
                //Touch attack.
				int nIsPC = GetIsPC(oTarget);
                if(TouchAttackRanged(oTarget) > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_ALL) == 0)
                    { 
						if (nIsPC == TRUE || GetPlotFlag(oTarget) == TRUE)
      					  {  //Apply effect to PC
          				     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, TurnsToSeconds(13));
     					  }
    				    else
                             //Apply effect to KI
                       		 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, TurnsToSeconds(13)));
							 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, TRUE, TRUE, TRUE), oTarget));
                    }
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Stone, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}


//------------------------------------------------------------------------------
// Inflict Critical Wounds
//------------------------------------------------------------------------------
void Ray_Inflict(object oTarget, int nDC, int nPlayer)
{
    int nCount;
	int nHD = GetHitDice(OBJECT_SELF);
    int nDamage = d8(4) + nHD;
    int nTouch;
    effect eDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                nTouch = TouchAttackRanged(oTarget);
                if(nTouch > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE) == 1)
                    {
                        nDamage = nDamage / 2;
                    }

                    //Critical
                    if(nTouch == 2){nDamage *= 2;}

                    //Set damage.
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);

                    //Link effects.
                    eLink = EffectLinkEffects(eDamage, eVis);

                    //Apply effects.
                    DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Inflict, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//------------------------------------------------------------------------------
// Slow
//------------------------------------------------------------------------------
void Ray_Slow(object oTarget, int nDC, int nPlayer)
{
    int nCount;
    effect eSlow = EffectSlow();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                if(TouchAttackRanged(oTarget) > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_ALL) == 0)
                    {
                        //Link effects.
                        eLink = EffectLinkEffects(eSlow, eVis);

                        //Apply effects.
                        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(13)));
                    }
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Slow, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//------------------------------------------------------------------------------
// Telekensis
//------------------------------------------------------------------------------
void Ray_Telekensis(object oTarget, int nDC, int nPlayer)
{
    int nCount;
    effect eTelekensis = EffectKnockdown();
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eLink;
    location lTarget = GetLocation(oTarget);

    oTarget = GetFirstObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nPlayer)
    {
        //Can't be self or friendly unit.
        if(oTarget != OBJECT_SELF &&
        //oTarget != GetSpellTargetObject() &&
        GetIsReactionTypeHostile(oTarget, OBJECT_SELF) &&
        GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
        {
            //Stops while.
            nCount++;

            if(nCount == nPlayer)
            {
                //Touch attack.
                if(TouchAttackRanged(oTarget) > 0)
                {
                    //Make Save
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_ALL) == 0)
                    {
                        //Link effects.
                        eLink = EffectLinkEffects(eTelekensis, eVis);

                        //Apply effects.
                        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(6)));
                    }
                }
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam_Telekensis, oTarget, 1.0f);
            }
        }
        oTarget = GetNextObjectInShape(BEHOLDER_TARGET_SHAPE, BEHOLDER_TARGET_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}