#include "ff_safevar"

// bdoorw_odamage
/*
	Description: This calls from the On Damaged section of a door, it is
	meant to take a total of the damage assigned below and then effectively
	unlock the door, open it, and give a visual to it of 'exploding' open.
	It also returns percentage values to the player of how far along they
	have actually damaged that door toward opening. While this is not very
	RP in nature, it does provide a relative integer that all players can
	understand. This in turn lets the players 'imagine' how far along they've
	cracked open the door...other values could be returned with each bit,
	such as 'the door has splintered open', etc. This however, leaves it to
	the players to come up with their own visuals to how far the door
	is coming along and give their own IC explaination of that.
	
*/
// Sean Claypool aka Publilius_Syrus 10/06/09


void fResetDoor()
    {
    object oDoor = OBJECT_SELF;
    ActionCloseDoor(oDoor);
    SetLocked(oDoor, TRUE);
    PS_SetLocalInt(oDoor, "hit_damage", 0);
    SetPlotFlag(oDoor, FALSE);
	SetImmortal(oDoor, TRUE);

    }


void main()
{
object oPC = GetLastDamager();
object oDoor = OBJECT_SELF;
//The will saving throw works best, since doors have no will...
//Most don't anyhow...you can get creative with this on a variation.
int iMaxHP = GetWillSavingThrow(oDoor);
if (iMaxHP==0)
    {iMaxHP=10;}

//Double the doors up.
iMaxHP = iMaxHP*2;


if (GetIsOpen(oDoor))
    {
    return;
    }

if (GetLocked(oDoor)==FALSE)
    {
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
    AssignCommand(GetLastDamager(), ClearAllActions(TRUE));
    return;
    }

if (PS_GetLocalInt(OBJECT_SELF, "SHOUT_ONCE")==0)
    {
    PS_SetLocalInt(OBJECT_SELF, "SHOUT_ONCE", 1);
    DelayCommand(10.0, PS_DeleteLocalInt(OBJECT_SELF, "SHOUT_ONCE"));
    SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    }

PS_SetLocalInt(oDoor, "hit_damage", PS_GetLocalInt(oDoor, "hit_damage")+GetTotalDamageDealt());
//SpeakString("Total Damage Dealt: " + IntToString(GetTotalDamageDealt()));
int iDamage=PS_GetLocalInt(oDoor, "hit_damage");

if (iDamage>=iMaxHP || GetLocked(oDoor)==0)
    {
    if (GetPlotFlag(oDoor) && !GetIsOpen(oDoor))
        {
        AssignCommand(GetLastDamager(), ClearAllActions(TRUE));
        SetLocked(oDoor, FALSE);
        ActionOpenDoor(oDoor);

        }
    else
        {
        AssignCommand(GetLastDamager(), ClearAllActions(TRUE));
        SetPlotFlag(oDoor, TRUE);
        SetLocked(oDoor, FALSE);
        PlaySound("c_stonegolembatt_01");
		effect eDoorExplode = EffectNWN2SpecialEffectFile( "fx_rockslide");
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDoorExplode, OBJECT_SELF);
        ActionOpenDoor(oDoor);
        DelayCommand(60.0, fResetDoor());
        }
    }
//Assigns the values to the below formula.
float fPercent = (IntToFloat(iDamage)/IntToFloat(iMaxHP));
int iPercent = FloatToInt(fPercent*100);
if (iPercent>=100)
    {
    iPercent = 100;
    }

//Takes the # of damage from the door and assigns a percentage in the speak string.
int iText = PS_GetLocalInt(oDoor, "damage_meter");
if (iText!=(iPercent/5))
    {
    PS_SetLocalInt(oDoor, "damage_meter",iPercent/5);
    SpeakString(IntToString(iPercent) + "% damage");
    }


}
  