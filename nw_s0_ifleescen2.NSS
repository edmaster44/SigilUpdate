#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"



void FleeRefresh(object oPC)
{
	if (!GetLocalInt(oPC,"FleeTheScene")) return;
	
	if (!GetIsInCombat(oPC))
		AssignCommand(oPC, ActionCastSpellAtObject(SPELL_I_WALK_UNSEEN, oPC, METAMAGIC_ANY, FALSE, 0,PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
		
	DelayCommand(6.0, FleeRefresh(oPC));
}
	
void main()
{
	object oPC = OBJECT_SELF;	
	FleeRefresh(oPC);
}
/* original
void DoHasteEffects( object oCaster, object oTarget )
{
    //int nCasterLvl  = GetWarlockCasterLevel(oCaster);
    float fDuration   = RoundsToSeconds(5); // Rounds
    effect eHaste   = EffectHaste();
	eHaste = SetEffectSpellId(eHaste, SPELL_I_FLEE_THE_SCENE);
	
    //RemoveEffectsFromSpell(oTarget, SPELL_I_FLEE_THE_SCENE);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oTarget, fDuration);
    
}

void FleeTheScene(object oCaster)
{
    object oTarget = GetFirstFactionMember(oCaster, FALSE); 

	
	while (GetIsObjectValid(oTarget))  {
	
		if (GetArea(oTarget) == GetArea(oCaster)) {
 		   if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE) {
 		       RemoveSpellEffects(SPELL_HASTE, oCaster, oTarget);
 		   }
		   if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE) {
 		       RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, oCaster, oTarget);
		   }
		   
 		   SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_I_FLEE_THE_SCENE, FALSE));

   			DoHasteEffects( oCaster, oTarget );
		}

		oTarget = GetNextFactionMember(oCaster, FALSE);
	}

}

void FleeRefresh(object oPC)
{
	if (GetLocalInt(oPC,"FleeTheScene")==FALSE) return;
	
	FleeTheScene(oPC);
	DelayCommand(30.1, FleeRefresh(oPC));
}
	
void main()
{
	object oPC = OBJECT_SELF;
	
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
		
	FleeRefresh(oPC);
}
*/