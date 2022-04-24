#include "ps_inc_functions"
/*This is a Function and a rewrite of Epic Spell DC calculations*/


int isEpicWizard(object oPC);
int isEpicSorcerer(object oPC);
int isEpicCleric(object oPC);
int isEpicDruid(object oPC);
int isEpicFavoredSoul(object oPC);
int isEpicSpiritShaman(object oPC);
int isEpicWarlock(object oPC);


int PS_GetSpellSaveDC(object oPC)
{
    int nBonus = (PS_GetCasterLevel(oPC)-20)/3; //+1DC every 3 levels after 20
    if (nBonus < 0)
    {
        nBonus = 0;
    }

    int nDC = 20 + GetHasFeat(FEAT_SPELLCASTING_PRODIGY);

    if (isEpicWizard(oPC))
    {
        nDC += GetAbilityModifier(ABILITY_INTELLIGENCE);
    }
    else if (isEpicSorcerer(oPC) ||isEpicWarlock(oPC) || isEpicFavoredSoul(oPC))
    {
        nDC += GetAbilityModifier(ABILITY_CHARISMA);
    }
    else if (isEpicCleric(oPC) || isEpicSpiritShaman(oPC) || isEpicDruid(oPC))
    {
        nDC += GetAbilityModifier(ABILITY_WISDOM);
    }
    else nDC = GetSpellSaveDC(); //failsafe, if no class is found
    

    
    nDC += nBonus;
    return nDC;
}
int isEpicWizard(object oPC)
{
    int nCasterLevel = GetWizardTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicSorcerer(object oPC)
{
    int nCasterLevel = GetSorcererTRUECasterlevel(oPC);

    if (nCasterLevel >= 18)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicCleric(object oPC)
{
    int nCasterLevel = GetClericTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicDruid(object oPC)
{
    int nCasterLevel = GetDruidTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicFavoredSoul(object oPC)
{
    int nCasterLevel = GetFavoredSoulTRUECasterlevel(oPC);

    if (nCasterLevel >= 18)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicSpiritShaman(object oPC)
{
    
    int nCasterLevel = GetSpiritShamanTRUECasterlevel(oPC);

    if (nCasterLevel >= 16)
    {
        return TRUE;
    }
    return FALSE;
}
int isEpicWarlock(object oPC)
{
    int nCasterLevel = GetWarlockCasterLevel(oPC);

    if (nCasterLevel >= 16)
    {
        return TRUE;
    }
    return FALSE;
}