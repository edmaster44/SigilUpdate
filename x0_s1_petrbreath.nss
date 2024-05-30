//::///////////////////////////////////////////////////
//:: X0_S1_PETRBREATH
//:: Petrification breath monster ability. 
//:: Fortitude save (DC 17) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

#include "x0_i0_spells"

void DoPetrificationNew(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC);

void main()
{
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetHitDice(OBJECT_SELF);

	effect eVis = EffectNWN2SpecialEffectFile("sp_noxious_cone.sef");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, 2.0);

    location lTargetLocation = GetSpellTargetLocation();

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
        int nSpellID = GetSpellId();
        object oSelf = OBJECT_SELF;
        DelayCommand(fDelay,  DoPetrificationNew(nHitDice, oSelf, oTarget, nSpellID, 10+GetHitDice(OBJECT_SELF)));

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.0, lTargetLocation, TRUE);
    }

}

// *  This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void DoPetrificationNew(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC)
{

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // * exit if creature is immune to petrification
        if (spellsIsImmuneToPetrification(oTarget) == TRUE)
        {
            return;
        }
        float fDifficulty = 0.0;
        int bIsPC = GetFactionEqual(GetFirstPC(TRUE), oTarget);
        int bShowPopup = FALSE;

        // * calculate Duration based on difficulty settings
        int nGameDiff = GetGameDifficulty();
        switch (nGameDiff)
        {
            case GAME_DIFFICULTY_VERY_EASY:
            case GAME_DIFFICULTY_EASY:
            case GAME_DIFFICULTY_NORMAL:
                    fDifficulty = RoundsToSeconds(nPower); // One Round per hit-die or caster level
                break;
            case GAME_DIFFICULTY_CORE_RULES:
            case GAME_DIFFICULTY_DIFFICULT:
                bShowPopup = TRUE;
            break;
        }

        int nSaveDC = nFortSaveDC;
        effect ePetrify = EffectPetrify();

        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FLESH_TO_STONE );

        effect eLink = EffectLinkEffects(eDur, ePetrify);

            // Let target know the negative spell has been cast
            SignalEvent(oTarget,
                        EventSpellCastAt(OBJECT_SELF, nSpellID));
                        //SpeakString(IntToString(nSpellID));

            // Do a fortitude save check
			if (spellsIsImmuneToPetrification(oTarget) == TRUE)
       		{   return;	}
            else if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC))
            {
                // Save failed; apply paralyze effect and VFX impact

                /// * The duration is permanent against NPCs but only temporary against PCs
                if (bIsPC == TRUE)
                {
                    if (bShowPopup == TRUE)
                    {
                        // * under hardcore rules or higher, this is an instant death
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
//					   DisplayGuiScreen( oTarget, "SCREEN_DEATH_DEFAULT", FALSE );
                        // if in hardcore, treat the player as an NPC
                        bIsPC = FALSE;
                        //fDifficulty = TurnsToSeconds(nPower); // One turn per hit-die
                    }
                    else
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty);
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

                    //----------------------------------------------------------
                    // GZ: Fix for henchmen statues haunting you when changing
                    //     areas. Henchmen are now kicked from the party if
                    //     petrified.
                    //----------------------------------------------------------
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
                    {
                        FireHenchman(GetMaster(oTarget),oTarget);
                    }

                }
                // April 2003: Clearing actions to kick them out of conversation when petrified
                AssignCommand(oTarget, ClearAllActions(TRUE));
            }
    }

}