//::///////////////////////////////////////////////
//:: Dragon Breath Negative Energy
//:: x2_s1_dragneg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Modified: May 29, 2011 (DannJ)
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void NegativeFire(int nDamage, int nDamage2, int nDC);

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDamage;// for level drain
    int nDamage2;// for negative energy
    int nDC;
    float fDelay;
    object oTarget;
    //Determine save DC and ability damage
    if (nAge <= 6) //Wyrmling
    {
        nDamage = 1;
        nDamage2 = 2;
        nDC = 14;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = 1;
        nDamage2 = 4;
        nDC = 16;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = 1;
        nDamage2 = 6;
        nDC = 18;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = 2;
        nDamage2 = 8;
        nDC = 20;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = 2;
        nDamage2 = 10;
        nDC = 22;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage = 3;
        nDamage2 = 12;
        nDC = 24;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage = 4;
        nDamage2 = 14;
        nDC = 26;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = 5;
        nDamage2 = 16;
        nDC = 29;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = 5;
        nDamage2 = 18;
        nDC = 32;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = 6;
        nDamage2 = 20;
        nDC = 34;
    }
    else if (nAge >= 34 && nAge < 37) //Wyrm
    {
        nDamage = 7;
        nDamage2 = 22;
        nDC = 37;
    }
    else if (nAge >= 37) //Great Wyrm
    {
        nDamage = 8;
        nDamage2 = 24;
        nDC = 39;
    }
    PlayDragonBattleCry();
    effect eBreath = EffectNWN2SpecialEffectFile("fx_neg_breath.sef");
    PlayCustomAnimation(OBJECT_SELF, "Una_breathattack01", 0, 0.7f);
    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, OBJECT_SELF, 3.0f));
    DelayCommand(0.7f, NegativeFire(nDamage, nDamage2, nDC));
}

void NegativeFire(int nDamage, int nDamage2, int nDC)
{
	float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_ASTRONOMIC, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Reset the damage to full
            int nDamStrike = d10(nDamage2);
			int nLevelDrain = nDamage;		

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                nDamStrike = nDamStrike/2;
                if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamStrike = 0;
                }
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamStrike = nDamStrike/2;
            }			
			effect eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_NEGATIVE);
            effect eDrain = EffectNegativeLevel(nLevelDrain);
			if (nDamStrike > 0)
            {
                //Determine effect delay
                //fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
                DelayCommand(1.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget));
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_ASTRONOMIC, GetSpellTargetLocation(), TRUE);
    }
}