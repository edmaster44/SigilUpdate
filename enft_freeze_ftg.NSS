#include "ff_safevar"

#include "enft_freeze_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"
 
void main()
{
    int freezeDamage;       // Subdual damage from freezing
    int newFreezeDamage;    // New subdual damage from freezing
    int pastThrows;         // Number of throws already attempted
    int beforeHP, afterHP;
	effect eIceSlow = EffectSlow();
	eIceSlow = SupernaturalEffect(eIceSlow);
    effect eff;


    // Check to make sure still in freeze region
    if(PS_GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 1)
    {
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE", 0);
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_THROWS", 0);
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS", 0);
        SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");

        // Remove frozen effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);

        return;
    }

    // Check to make sure not in a warm place
    if(freezeRelief(OBJECT_SELF))
    {
        // Throws are set back to 0 because body temperature has returned to normal.
        if(PS_GetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE") > 0)
        {
            SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(0));
        }
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE", 0);
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_THROWS", 0);
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS", 0);

        // Remove frozen effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);

        // Check for freezing damage in an hour.
        DelayCommand(freezeTime, ExecuteScript("enft_freeze_ftg", OBJECT_SELF));
        return;
    }

    // Collect freeze effects variables on character
    freezeDamage = PS_GetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE");
    pastThrows = PS_GetLocalInt(OBJECT_SELF, "FREEZE_THROWS");

    // Check to see if character is already unconscious
    if(PS_GetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS") != 0)
    {
        // Check if conscious again
        if(freezeDamage <= GetCurrentHitPoints( ))
        {
            // Signify that character is no longer unconscious
            PS_SetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS", 0);
            RemoveEffect(OBJECT_SELF, eIceSlow);
        }
        // Attempt freeze damage if still unconscious
        else if(FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_COLD) == 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6( ), DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL), OBJECT_SELF);

        // If dead now, remove freezing effects incase resurected later.
        // The number of throws, however, is not reduced.  Body has not gotten warmer yet.
        if(GetIsDead(OBJECT_SELF))
            {
                PS_SetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE", 0);
                PS_SetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS", 0);
                RemoveEffect(OBJECT_SELF, eIceSlow);
            }
    }
    // Check if character freezes even more if not already unconscious or dead
    else if(!GetIsDead(OBJECT_SELF) && (FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_COLD) == 0))
    {
        // Determine new freeze damage and apply it to character
        newFreezeDamage = d6( );
        eff = EffectTemporaryHitpoints(newFreezeDamage);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, OBJECT_SELF);
        beforeHP = GetCurrentHitPoints( );
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(newFreezeDamage, DAMAGE_TYPE_COLD), OBJECT_SELF);
        afterHP = GetCurrentHitPoints( );
        newFreezeDamage = beforeHP - afterHP;
        RemoveEffect(OBJECT_SELF, eff);
        PS_SetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE", freezeDamage + newFreezeDamage);

        // Sent message to PC
        if(newFreezeDamage > 0)
        {
            SendMessageToPC(OBJECT_SELF, "Your exposure further weakens you.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(freezeDamage + newFreezeDamage));
        }

        // Make character unconcious if necessary
        if((freezeDamage + newFreezeDamage) > GetCurrentHitPoints( ))
        {
            // Signify that character is unconscious
            PS_SetLocalInt(OBJECT_SELF, "FREEZE_UNCONSCIOUS", 1);

            // Sent message to PC
            SendMessageToPC(OBJECT_SELF, "You can take no more of this exposure and are now beginning to freeze to death.");

            // Apply unconscious effects
			
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIceSlow, OBJECT_SELF);
			
        }
    }

    // Apply fatigue to character
    if(PS_GetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE") > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH, 2), OBJECT_SELF, freezeTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_DEXTERITY, 2), OBJECT_SELF, freezeTime);
    }

    // Apply frozen special affect if frozen
    if(PS_GetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE") > GetCurrentHitPoints( ))
        DelayCommand(5.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ICESKIN), OBJECT_SELF, freezeTime));

    // If the character is just barely conscious apply dazing effects for an hour
    if(PS_GetLocalInt(OBJECT_SELF, "FREEZE_SUBDUAL_DAMAGE") == GetCurrentHitPoints( ))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed( ), OBJECT_SELF, freezeTime);

    // Increase the number of throws done
    PS_SetLocalInt(OBJECT_SELF, "FREEZE_THROWS", pastThrows + 1);

    // Check for freezing damage in an hour.
    DelayCommand(freezeTime, ExecuteScript("enft_freeze_ftg", OBJECT_SELF));
}