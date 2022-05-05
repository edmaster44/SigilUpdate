#include "nwn2_inc_spells"
#include "aaa_constants"
void Blaze_Of_Power(object oPC, int nSpell)
{
effect eLink;
int nLevel=GetLevelByClass(CLASS_TYPE_NATUREWARRIOR, oPC);
int nDuration = (nLevel-1)*10;
int nShieldDamage = DAMAGE_BONUS_1d6 * nLevel;
eLink = EffectDamageShield(0,nShieldDamage,DAMAGE_TYPE_FIRE);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oPC, RoundsToSeconds(nDuration));
}

void Robe_Of_Clouds(object oPC , int nSpell)
{


RemoveSpellEffects(nSpell, OBJECT_SELF, OBJECT_SELF);
int nLevel=GetLevelByClass(CLASS_TYPE_NATUREWARRIOR, oPC);
int nDuration = (nLevel-1)*10;
effect eConceal = EffectConcealment(10 * nLevel , MISS_CHANCE_TYPE_NORMAL);
SupernaturalEffect(eConceal);

	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, OBJECT_SELF, RoundsToSeconds(nDuration)));
}



void Serpentine_Coil(object oPC, object oTarget, int nSpell)
{

int iAttackerStr = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
int iAttackerDex = GetAbilityModifier(ABILITY_DEXTERITY,OBJECT_SELF);
int iDefenderStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
int iDefenderDex = GetAbilityModifier(ABILITY_DEXTERITY,oTarget);

int iAttackerCheck = iAttackerStr > iAttackerDex ? iAttackerStr : iAttackerDex;
int iDefenderCheck = iDefenderStr > iDefenderDex ? iDefenderStr : iDefenderDex;

 int SizeCheck = 0;
    
    if (GetCreatureSize(oTarget) == CREATURE_SIZE_LARGE)
    {    SizeCheck = SizeCheck + 4;    }
    if (GetCreatureSize(oTarget) == CREATURE_SIZE_HUGE)
    {    SizeCheck = SizeCheck + 8;    }

   				int iATotal = d10(1) + iAttackerCheck;
                int iDTotal = d10(1) + iDefenderCheck + SizeCheck;
                int nDur    = 4;
                SendMessageToPC(oPC, "iATotal: " + IntToString(iATotal) + ", iDTotal: " + IntToString(iDTotal)); // HERE YOU LOG BOTH ROLLS
                if (iATotal > iDTotal)
                { 
                    SendMessageToPC(oPC,"SUCCESS!"); // here you log success
                    effect eRoped    = EffectEntangle();
                    effect eVis        = EffectVisualEffect(VFX_DUR_PARALYZED);
                    effect eHidePen = EffectSkillDecrease(5, 100);
                    effect eMovePen = EffectSkillDecrease(8, 100);
                    effect eLink    = EffectLinkEffects(eRoped, eVis);
                     eLink    = EffectLinkEffects(eLink, eHidePen);
                     eLink    = EffectLinkEffects(eLink, eMovePen);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
                    SpeakString(GetFirstName(oPC) + " flings their rope at " + GetFirstName(oTarget) + " and entangles them!");    }    
                    
                else 
                {   effect eFail = EffectMovementSpeedDecrease (50);
                    SendMessageToPC(oPC, "Your rope has failed to ensare!"); // here you log failure
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFail, oTarget, RoundsToSeconds(2));
                    SpeakString(GetFirstName(oTarget) + " broke free of the attempted ensnarement!"); }
        
    effect eRay = EffectBeam(VFX_BEAM_GREEN_DRAGON_ACID, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}  