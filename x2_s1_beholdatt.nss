//:://////////////////////////////////////////////
//:: Created By: Q-Necron, edited by Alersia
//:://////////////////////////////////////////////
#include "qn_inc_beholder"

void main()
{
    //Declare Major Varibles
    object oTarget = GetSpellTargetObject();
    int bDamage = FALSE;
    int nCharisma = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int nHD = GetHitDice(OBJECT_SELF);
    int nCount;
    int nDamage;
    int Dis_Damage1 = d6(2 * nHD);
	
	if (nHD >= 20)
			{Dis_Damage1 = d6(40);	}
	
    int Dis_Damage2 = d6(5);
    int nDC;
    int nLevel;
    int nRandom = d2(1);
    int nSave;
    int nSpell = d3(1);
    int nTouch;
    int nType;
    int nUnitCount = UnitCount(oTarget);
    effect eBeam;
    effect eEye;
    effect eDur;
    effect eVis;
    effect eLink;
    float fDuration;
    float f2nd = GetRandomDelay(0.3f, 0.9f);
    float f3rd = GetRandomDelay(0.7f, 1.3f);
    float f4th = GetRandomDelay(1.1f, 1.7f);

    //Mages & Undead
    if(GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) > 5 ||
    GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) > 5 ||
    GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        //Determine random eye ray (Disintegrate).
        switch(nSpell)
        {
            case 1:
            case 2:
            case 3:
            bDamage = TRUE;
            nDamage = Dis_Damage1;
            nLevel = 6;
            nSave = SAVING_THROW_FORT;
            nType = SAVING_THROW_TYPE_ALL;
            eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            break;
        }
    }
    else
    {
        //Determine random eye ray (Charm, Fear or Sleep).
        switch(nSpell)
        {
            case 1:
            nLevel = 1;
            nSave = SAVING_THROW_WILL;
            nType = SAVING_THROW_TYPE_MIND_SPELLS;
            eEye = EffectConfused();
            eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
            eVis = EffectVisualEffect(VFX_IMP_CHARM);
            fDuration = TurnsToSeconds(13);
            break;

            case 2:
            nLevel = 4;
            nSave = SAVING_THROW_WILL;
            nType = SAVING_THROW_TYPE_MIND_SPELLS;
            eEye = EffectFrightened();
            eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
            fDuration = RoundsToSeconds(13);
            break;

            case 3:
            nLevel = 1;
            nSave = SAVING_THROW_WILL;
            nType = SAVING_THROW_TYPE_MIND_SPELLS;
            eEye = EffectSleep();
            eDur = EffectVisualEffect(VFX_IMP_SLEEP);
            fDuration = RoundsToSeconds(13);
            break;
        }
    }

    //Determine DC.
    nDC = 10 + nLevel + (nHD / 2) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    //Eye ray.
    nTouch = TouchAttackRanged(oTarget);
    if(nTouch > 0)
    {
        if(bDamage == TRUE)
        {
            //Make Save
            if(MySavingThrow(nSave, oTarget, nDC, nType) == 1)
            {
                nDamage = Dis_Damage2;
            }

            //Critical
            if(nTouch == 2){nDamage *= 2;}

            //Set damage.
            eEye = EffectDamage(nDamage);

            //Link effects.
            eLink = EffectLinkEffects(eEye, eDur);
            eLink = EffectLinkEffects(eVis, eLink);

            //Apply effects.
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

            //Beam
            eBeam = eBeam_Disintegrate;
        }
        else
        {
            //Link effects.
            eLink = EffectLinkEffects(eEye, eDur);
            eLink = EffectLinkEffects(eVis, eLink);

            //Make Save
            if(MySavingThrow(nSave, oTarget, nDC, nType) == 0)
            {
                //Apply effects.
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }

            //Beam
            eBeam = eBeam_Mind;
        }
    }
    //Apply effects.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7f);

    //Additonal eye rays.

	    if(bDamage == TRUE)
    {
        if(nUnitCount == 0)
        {
            //Fall back...
            DelayCommand(f2nd, Ray_Mind(oTarget, (11 + (nHD / 2) + nCharisma), 1, EffectConfused(), VFX_DUR_MIND_AFFECTING_NEGATIVE, VFX_IMP_CONFUSION_S, RoundsToSeconds(13)));
            DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), 1));
            DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), 1));
			DelayCommand(2.0, SendMessageToPC(oTarget, "You have been hit by Charm, Inflict and Slow Eye Rays."));
        }
        if(nUnitCount == 1)
        {
            //1 Target
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (11 + (nHD / 2) + nCharisma), 1, EffectFrightened(), VFX_DUR_MIND_AFFECTING_NEGATIVE, VFX_IMP_CONFUSION_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), 1));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Inflict and Slow Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (14 + (nHD / 2) + nCharisma), 1, EffectConfused(), VFX_DUR_MIND_AFFECTING_FEAR, VFX_IMP_FEAR_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), 1));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Petrification and Telekinesis Eye Rays."));
            }
        }
        if(nUnitCount == 2)
        {
            //2 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (14 + (nHD / 2) + nCharisma), d2(1), EffectSleep(), VFX_DUR_MIND_AFFECTING_FEAR, VFX_IMP_FEAR_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d2(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Petrification and Telekinesis Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (11 + (nHD / 2) + nCharisma), d2(1), EffectConfused(), VFX_DUR_MIND_AFFECTING_NEGATIVE, VFX_IMP_CONFUSION_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d2(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Inflict and Slow Eye Rays."));
            }
        }
        if(nUnitCount == 3)
        {
            //3 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (13 + (nHD / 2) + nCharisma), d3(1), EffectFrightened(), VFX_DUR_MIND_AFFECTING_DISABLED, VFX_IMP_SLEEP, TurnsToSeconds(13)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d3(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Inflict and Slow Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (14 + (nHD / 2) + nCharisma), d3(1), EffectConfused(), VFX_DUR_MIND_AFFECTING_FEAR, VFX_IMP_FEAR_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d3(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Petrification and Telekinesis Eye Rays."));
            }
        }
        if(nUnitCount >= 4)
        {
            //4 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (11 + (nHD / 2) + nCharisma), d4(1), EffectSleep(), VFX_DUR_MIND_AFFECTING_NEGATIVE, VFX_IMP_CONFUSION_S, RoundsToSeconds(13)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d4(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Petrification and Telekinesis Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Mind(oTarget, (13 + (nHD / 2) + nCharisma), d4(1), EffectConfused(), VFX_DUR_MIND_AFFECTING_DISABLED, VFX_IMP_SLEEP, TurnsToSeconds(13)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d4(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Charm, Inflict and Slow Eye Rays."));
            }
        }
    }
    else
    {
        if(nUnitCount == 0)
        {
            //Fall back...
            DelayCommand(f2nd, Ray_Disintegrate(oTarget, (16 + (nHD / 2) + nCharisma), 1));
            DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), 1));
            DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), 1));
			DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Disintegrate, Inflict and Slow Eye Rays."));
        }
        if(nUnitCount == 1)
        {
            //1 Target
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Disintegrate(oTarget, (16 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), 1));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Disintegrate, Inflict and Slow Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Death(oTarget, (17 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), 1));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), 1));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Death, Petrification and Telekinesis Eye Rays."));
            }
        }
        if(nUnitCount == 2)
        {
            //2 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Death(oTarget, (17 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d2(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Death, Petrification and Telekinesis Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Disintegrate(oTarget, (16 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d2(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d2(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Disintegrate, Inflict and Slow Eye Rays."));
            }
        }
        if(nUnitCount == 3)
        {
            //3 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Disintegrate(oTarget, (16 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d3(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Disintegrate, Inflict and Slow Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Death(oTarget, (17 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d3(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d3(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Death, Petrification and Telekinesis Eye Rays."));
            }
        }
        if(nUnitCount >= 4)
        {
            //4 Targets
            if(d2(1) == 1)
            {
                DelayCommand(f2nd, Ray_Death(oTarget, (17 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f3rd, Ray_Stone(oTarget, (16 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f4th, Ray_Telekensis(oTarget, (15 + (nHD / 2) + nCharisma), d4(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Death, Petrification and Telekinesis Eye Rays."));
            }
            else
            {
                DelayCommand(f2nd, Ray_Disintegrate(oTarget, (16 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f3rd, Ray_Inflict(oTarget, (12 + (nHD / 2) + nCharisma), d4(1)));
                DelayCommand(f4th, Ray_Slow(oTarget, (13 + (nHD / 2) + nCharisma), d4(1)));
				DelayCommand(2.0, SendMessageToPC(oTarget,"You have been hit by Disintegrate, Inflict and Slow Eye Rays."));
            }
        }
    }
}