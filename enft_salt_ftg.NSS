#include "ff_safevar"

#include "enft_salt_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"

void main()
{
    int saltDamage;         // Subdual damage from freezing
    int newsaltDamage;      // New subdual damage from freezing
    int pastThrows;         // Number of throws already attempted
    int beforeHP, afterHP;
    effect eff;
	
	

	
    // Check to make sure still in hot region
    if(PS_GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 3)
    {
        PS_SetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE", 0);
        PS_SetLocalInt(OBJECT_SELF, "SALT_THROWS", 0);
        PS_SetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS", 0);
        SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");

        // Remove unconscious effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF);

        return;
    }

    // Check to make sure not in a warm place
    if(saltRelief(OBJECT_SELF))
    {
        // Throws are set back to 0 because body temperature has returned to normal.
        if(PS_GetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE") > 0)
        {
            SendMessageToPC(OBJECT_SELF, "You feel relief at long last.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(0));
        }
        PS_SetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE", 0);
        PS_SetLocalInt(OBJECT_SELF, "SALT_THROWS", 0);
        PS_SetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS", 0);

        // Remove unconscious effect if applied
        RemoveSpecificEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF);

        // Check for heat damage in an hour.
        DelayCommand(saltTime, ExecuteScript("enft_salt_ftg", OBJECT_SELF));
        return;
    }

    // Collect heat effects variables on character
    saltDamage = PS_GetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE");
    pastThrows = PS_GetLocalInt(OBJECT_SELF, "SALT_THROWS");

    // Check to see if character is already unconscious
    if(PS_GetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS") != 0)
    {
        // Check if conscious again
        if(saltDamage <= GetCurrentHitPoints( ))
        {
            // Signify that character is no longer unconscious
            PS_SetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS", 0);
            RemoveSpecificEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF);
        }
        // Attempt heat damage if still unconscious
        else if(FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_NEGATIVE) == 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(2), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL), OBJECT_SELF);

        // If dead now, remove unconscious effects incase resurected later.
        // The number of throws, however, is not reduced.  Body has not gotten cooler yet.
        if(GetIsDead(OBJECT_SELF))
            {
                PS_SetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE", 0);
                PS_SetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS", 0);
                RemoveSpecificEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF);
            }
    }
    // Check if character burns even more if not already unconscious or dead
    else if(!GetIsDead(OBJECT_SELF) && (FortitudeSave(OBJECT_SELF, 15 + pastThrows, SAVING_THROW_TYPE_NEGATIVE) == 0))
    {
        // Determine new heat damage and apply it to character
        
			if(GetSubRace(OBJECT_SELF) == RACIAL_SUBTYPE_WATER_GENASI || GetSubRace(OBJECT_SELF) == RACIAL_SUBTYPE_PLANT || GetSubRace(OBJECT_SELF) == 185)
			{
				newsaltDamage = d8(3);
			}
			else if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_OUTSIDER || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_CONSTRUCT || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELEMENTAL)
			{
				newsaltDamage = 0;
				SendMessageToPC(OBJECT_SELF, "The plane's desiccating atmosphere does not effect you.");
			}
			else if(GetLevelByClass(63, OBJECT_SELF) > 2)
			{
				newsaltDamage = 0;
				SendMessageToPC(OBJECT_SELF, "The plane's desiccating atmosphere does not effect you.");
			}
			else if(GetHasSpellEffect(398, OBJECT_SELF))
			{
				newsaltDamage = GetCurrentHitPoints() + 1;
				SendMessageToPC(OBJECT_SELF, "The plane's desiccating atmosphere has a particularly devestating effect on water elementals");
			}
			else
			{
				newsaltDamage = d8(2);
			}
        eff = EffectTemporaryHitpoints(newsaltDamage);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, OBJECT_SELF);
        beforeHP = GetCurrentHitPoints( );
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(newsaltDamage, DAMAGE_TYPE_MAGICAL), OBJECT_SELF);
        afterHP = GetCurrentHitPoints( );
        newsaltDamage = beforeHP - afterHP;
        RemoveEffect(OBJECT_SELF, eff);
        PS_SetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE", saltDamage + newsaltDamage);

        // Sent message to PC
        if(newsaltDamage > 0)
        {
            SendMessageToPC(OBJECT_SELF, "The plane's desiccating atmosphere saps the moisture from your body, while the salt crystals flying in your face cause you temporary blindness.");
            SendMessageToPC(OBJECT_SELF, "Subdual damage:  " + IntToString(saltDamage + newsaltDamage));
        }

        // Make character unconcious if necessary
        if((saltDamage + newsaltDamage) > GetCurrentHitPoints( ))
        {
            // Signify that character is unconscious
            PS_SetLocalInt(OBJECT_SELF, "SALT_UNCONSCIOUS", 1);

            // Sent message to PC
            SendMessageToPC(OBJECT_SELF, "You can take no more of this exposure and are now unconscious, dying of thirst.");

            // Apply unconscious effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown( ), OBJECT_SELF, 10.0f);
            
            DelayCommand(5.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPetrify(), OBJECT_SELF));
        }
    }

    // Apply fatigue to character
    if(PS_GetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE") > 0)
    {
		int nBlindDur = 3;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH, 2), OBJECT_SELF, saltTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_DEXTERITY, 2), OBJECT_SELF, saltTime);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), OBJECT_SELF, RoundsToSeconds(nBlindDur));
    }

    // If the character is just barely conscious apply dazing effects for an hour
    if(PS_GetLocalInt(OBJECT_SELF, "SALT_SUBDUAL_DAMAGE") == GetCurrentHitPoints( ))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed( ), OBJECT_SELF, saltTime);

    // Increase the number of throws done
    PS_SetLocalInt(OBJECT_SELF, "SALT_THROWS", pastThrows + 1);

    // Check for heat damage in an hour.
    DelayCommand(saltTime, ExecuteScript("enft_salt_ftg", OBJECT_SELF));
}