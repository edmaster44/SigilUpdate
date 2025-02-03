/*

    Companion and Monster AI

    This file contains routines used to initialize creatures for combat - setting
    up inventory items, auto cast long duration buffs, etc.

*/

#include "hench_i0_target"


// cast a warlock buff spell on self (bCheat is instant cast)
int TryCastWarlockBuffSpell(int nSpellID, int bCheat);

// cast warlock buff spells on self (bCheat is instant cast)
int TryCastWarlockBuffSpells(int bCheat);

// cast bard inspirations
int TryCastBardBuffSpells();



int gbFoundInfiniteBuffSpell;

int TryCastWarlockBuffSpell(int nSpellID, int bCheat)
{
    if (GetHasSpell(nSpellID))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (!GetHasSpellEffect(nSpellID))
        {
            if (!bCheat)
            {
                ClearAllActions();
            }
//            Jug_Debug(GetName(OBJECT_SELF) + " casting spell on self " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID));
            ActionCastSpellAtObject(nSpellID, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bCheat);
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
            return !bCheat;
        }
    }
    return FALSE;
}


int TryCastWarlockBuffSpells(int bCheat)
{
    // check able to cast - skip if any spell failure
    if (GetHasEffect(EFFECT_TYPE_SPELL_FAILURE) || GetHasEffect(EFFECT_TYPE_SILENCE))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DARK_FORESIGHT, bCheat))
    {
        return TRUE;
    }
    if (bCheat && TryCastWarlockBuffSpell(SPELL_I_FLEE_THE_SCENE, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DARK_ONES_OWN_LUCK, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_WALK_UNSEEN, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_LEAPS_AND_BOUNDS, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_ENTROPIC_WARDING, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DEVILS_SIGHT, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_SEE_THE_UNSEEN, bCheat))
    {
        return TRUE;
    }
    if (!bCheat && GetHasSpell(SPELL_I_FLEE_THE_SCENE))
    {
        // special code to check friends
        InitializeAllyList(FALSE);
        object oFriend = OBJECT_SELF;
        while (GetIsObjectValid(oFriend))
        {
            if (GetFactionEqual(oFriend) && !GetCreatureHasItemProperty(ITEM_PROPERTY_HASTE, oFriend) &&
                !GetHasEffect(EFFECT_TYPE_HASTE, oFriend))
            {
                ClearAllActions();
                ActionCastSpellAtObject(SPELL_I_FLEE_THE_SCENE, OBJECT_SELF, METAMAGIC_NONE);
                SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, sAllyLineOfSight);
        }
    }
    if (TryCastWarlockBuffSpell(SPELL_I_BEGUILING_INFLUENCE, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(1059, bCheat))	// Otherworldly Whispers
    {
        return TRUE;
    }
	//SPELL_I_THE_DEAD_WALK ??
    return FALSE;
}


int TryCastBardBuffSpells()
{
    // check able to cast - skip if any spell failure
    if (GetHasEffect(EFFECT_TYPE_SILENCE))
    {
        return TRUE;
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        InitializeAllyList(FALSE);
        object oFriend = OBJECT_SELF;
        while (GetIsObjectValid(oFriend))
        {
            if (GetDistanceToObject(oFriend) <= RADIUS_SIZE_COLOSSAL &&
                (GetCurrentHitPoints(oFriend) < GetMaxHitPoints(oFriend)) &&
                !GetHasEffect(EFFECT_TYPE_DEAF, oFriend) && 
				(GetRacialType(oFriend) != RACIAL_TYPE_CONSTRUCT) &&
				(GetRacialType(oFriend) != RACIAL_TYPE_UNDEAD))
            {
                if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, oFriend))
                {
                    // leave existing one alone
                    return FALSE;
                }
                ClearAllActions();
                ActionUseFeat(FEAT_BARDSONG_INSPIRE_REGENERATION, OBJECT_SELF);
                SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, sAllyLineOfSight);
        }
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COMPETENCE, OBJECT_SELF))
        {
            // leave existing one alone
            return FALSE;
        }
        ClearAllActions();
        ActionUseFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE, OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
        return TRUE;
    }
    return FALSE;
}