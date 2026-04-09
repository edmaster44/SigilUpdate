

#include "enft_heat_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"

void main()
{
    int heatDamage;         // Subdual damage from freezing
    int newHeatDamage;      // New subdual damage from freezing
    int pastThrows;         // Number of throws already attempted
    int beforeHP, afterHP;
    effect eff;
	
	SpeakString("heat script running", TALKVOLUME_SHOUT);
	int lastRun = GetLocalInt(OBJECT_SELF, "heat_timestamp");
	float diff = IntToFloat(abs(TimeStampT()-lastRun));
	if (diff < heatTime)
		return;
	SetLocalInt(OBJECT_SELF, "heat_timestamp", TimeStampT());
	SpeakString("heat script accepted", TALKVOLUME_SHOUT);
	
    // Check to make sure still in hot region
    if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 2)
    {
        SetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE", 0);
        SetLocalInt(OBJECT_SELF, "HEAT_THROWS", 0);
        SetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS", 0);
        SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");

        // Remove unconscious effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);

        return;
    }

    // Check to make sure not in a warm place
    if(heatRelief(OBJECT_SELF))
    {
        // Throws are set back to 0 because body temperature has returned to normal.
        if(GetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE") > 0)
        {
            SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(0));
        }
        SetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE", 0);
        SetLocalInt(OBJECT_SELF, "HEAT_THROWS", 0);
        SetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS", 0);

        // Remove unconscious effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);

        // Check for heat damage in an hour.
        DelayCommand(heatTime, ExecuteScript("enft_heat_ftg", OBJECT_SELF));
        return;
    }

    // Collect heat effects variables on character
    heatDamage = GetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE");
    pastThrows = GetLocalInt(OBJECT_SELF, "HEAT_THROWS");

    // Check to see if character is already unconscious
    if(GetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS") != 0)
    {
        // Check if conscious again
        if(heatDamage <= GetCurrentHitPoints( ))
        {
            // Signify that character is no longer unconscious
            SetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS", 0);
            RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);
        }
        // Attempt heat damage if still unconscious
        else if(FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_FIRE) == 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4( ), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL), OBJECT_SELF);

        // If dead now, remove unconscious effects incase resurected later.
        // The number of throws, however, is not reduced.  Body has not gotten cooler yet.
        if(GetIsDead(OBJECT_SELF))
            {
                SetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE", 0);
                SetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS", 0);
                RemoveSpecificEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, OBJECT_SELF);
            }
    }
    // Check if character burns even more if not already unconscious or dead
    else if(!GetIsDead(OBJECT_SELF) && (FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_FIRE) == 0))
    {
        // Determine new heat damage and apply it to character
        newHeatDamage = d4( );
        eff = EffectTemporaryHitpoints(newHeatDamage);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, OBJECT_SELF);
        beforeHP = GetCurrentHitPoints( );
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(newHeatDamage, DAMAGE_TYPE_FIRE), OBJECT_SELF);
        afterHP = GetCurrentHitPoints( );
        newHeatDamage = beforeHP - afterHP;
        RemoveEffect(OBJECT_SELF, eff);
        SetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE", heatDamage + newHeatDamage);

        // Sent message to PC
        if(newHeatDamage > 0)
        {
            SendMessageToPC(OBJECT_SELF, "Your exposure further weakens you.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(heatDamage + newHeatDamage));
        }

        // Make character unconcious if necessary
        if((heatDamage + newHeatDamage) > GetCurrentHitPoints( ))
        {
            // Signify that character is unconscious
            SetLocalInt(OBJECT_SELF, "HEAT_UNCONSCIOUS", 1);

            // Sent message to PC
            SendMessageToPC(OBJECT_SELF, "You can take no more of this exposure and are now unconscious.");

            // Apply unconscious effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown( ), OBJECT_SELF, 3.0f);
            DelayCommand(3.1f, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 0.1f, 10.0f)));
            DelayCommand(5.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze( ), OBJECT_SELF));
        }
    }

    // Apply fatigue to character
    if(GetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE") > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH, 2), OBJECT_SELF, heatTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_DEXTERITY, 2), OBJECT_SELF, heatTime);
    }

    // If the character is just barely conscious apply dazing effects for an hour
    if(GetLocalInt(OBJECT_SELF, "HEAT_SUBDUAL_DAMAGE") == GetCurrentHitPoints( ))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed( ), OBJECT_SELF, heatTime);

    // Increase the number of throws done
    SetLocalInt(OBJECT_SELF, "HEAT_THROWS", pastThrows + 1);

    // Check for heat damage in an hour.
    DelayCommand(heatTime, ExecuteScript("enft_heat_ftg", OBJECT_SELF));
}