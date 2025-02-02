#include "ff_safevar"

//Description: Underwater functions
//Author: Epoxid, Wisdoom

//Returns a Boolean value
int GetCanBreathUnderwater(object oPC);
//Does the Drown Check underwater
void DrownCheck(object oPC);
//Heartbeat for Underwater Areas
void UnderWaterCheck(object oPC);

int GetCanBreathUnderwater(object oPC)
{
    if(GetTag(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)) == "thesk_nodrown" || //helm of underwater breathing
    GetTag(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == "thesk_nodrown" || //armor of underwater breathing
	GetSubRace(oPC) == RACIAL_SUBTYPE_AIR_GENASI || //air genasis are breathless
	GetSubRace(oPC) == RACIAL_SUBTYPE_WATER_GENASI) //water genasis are waterbreathing
        return TRUE;
    return FALSE;
}

void DrownCheck(object oPC)
{
    int iRoundsWithoutAir = PS_GetLocalInt(oPC, "wdDrowningRounds");
    int iMaxRounds = GetAbilityScore(oPC, ABILITY_CONSTITUTION) * 2;
    if(iRoundsWithoutAir < iMaxRounds) //Can hold breath
    {
        int iRemaining = iMaxRounds - iRoundsWithoutAir;
        SendMessageToPC(oPC, "You are holding your breath! You have "+IntToString(iRemaining)+" rounds left to find air!");
        PS_SetLocalInt(oPC, "wdDrowningRounds", ++iRoundsWithoutAir);
    }
    else
    {
        if(GetCurrentHitPoints(oPC) == 0)
        {
            SendMessageToPC(oPC, "You are drowning and loosing consciousness.");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oPC);
        }
        else if(GetCurrentHitPoints(oPC) <= -1)
        {
            SendMessageToPC(oPC, "You drown!");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
        else
        {
            int iDrownDCMod = PS_GetLocalInt(oPC, "wdCurrentDrownDC");
            int iRoll = d20(1);
            int iConMod = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
            int iDC = 10 + iDrownDCMod;
            if(iRoll + iConMod >= iDC)
            {
                string sSave = "<color=#1E90FF>"+GetName(oPC)+" : Constitution Save vs. Drowning : *success* : ("+IntToString(iRoll)+" + "+IntToString(iConMod)+" = "+IntToString(iRoll + iConMod)+" vs. DC: "+IntToString(iDC)+")</color>";
                SendMessageToPC(oPC, sSave);
                iDrownDCMod++;
                PS_SetLocalInt(oPC, "wdCurrentDrownDC", iDrownDCMod);
            }
            else
            {
                string sSave = "<color=#1E90FF>"+GetName(oPC)+" : Constitution Save vs. Drowning : *failure* : ("+IntToString(iRoll)+" + "+IntToString(iConMod)+" = "+IntToString(iRoll + iConMod)+" vs. DC: "+IntToString(iDC)+")</color>";
                SendMessageToPC(oPC, sSave);
                int iHPs = GetCurrentHitPoints(oPC);
                effect eDam = EffectDamage(iHPs);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
            }
        }
    }
}

void DoUnderwaterCheck(object oPC)
{
    if(!GetIsDM(oPC) && GetTag(GetArea(oPC)) == "watery_abyss")
    {
        effect eSlow = SupernaturalEffect(EffectSlow());
        effect eBubbles = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSlow()), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR)), oPC);

        /*if(!GetCanBreathUnderwater(oPC))
        {
            DrownCheck(oPC);
        }*/

        //pseudo heartbeat
        if(GetIsPC(oPC) && !GetIsDMPossessed(oPC) && !GetIsDM(oPC))
        {
            DelayCommand(6.0, DoUnderwaterCheck(oPC));
        }
    }
    else
    {
        effect eLoop=GetFirstEffect(oPC);

        while(GetIsEffectValid(eLoop))
        {
            if(GetEffectType(eLoop) == EFFECT_TYPE_SLOW ||
            GetEffectType(eLoop) == EFFECT_TYPE_VISUALEFFECT)
                RemoveEffect(oPC, eLoop);
            eLoop = GetNextEffect(oPC);
        }
        return;
    }
}
