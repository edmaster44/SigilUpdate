#include "ff_safevar"

const int FREEZE_SPELL_ID = -2999;
void main() {

	object oPC = GetLastPerceived();
	
	//Only rise if we see a PC
	if (!GetIsPC(oPC))
		return;
		
	//make me a normal npc!
	SetCreatureScriptsToSet(OBJECT_SELF, 9); //get the default npc scripts
	ClearAllActions();
		
	//Removing freeze effect
	effect eEffect = GetFirstEffect( OBJECT_SELF );
	while ( GetIsEffectValid(eEffect) ) {
		if (GetEffectSpellId(eEffect) == FREEZE_SPELL_ID) {
			RemoveEffect( OBJECT_SELF, eEffect );
		}
		eEffect = GetNextEffect( OBJECT_SELF );
	}
	
	//re-applying vfx, just in case
	string sVFX = PS_GetLocalString(OBJECT_SELF, "PERMANENT_VFX");
	if (sVFX != "") {
		effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
		eVFX = SupernaturalEffect(eVFX);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF);
	}
		
	//SendMessageToPC(oPC, "On percieved fired for "+GetName(OBJECT_SELF));
	
	string sAnim = PS_GetLocalString(OBJECT_SELF, "TransitionAnimation");
	float fSpeed = PS_GetLocalFloat(OBJECT_SELF, "TransitionAnimationSpeed");
	
	//SendMessageToPC(oPC, sAnim+", "+FloatToString(fSpeed));
	
	if (sAnim != "") {
		if (fSpeed == 0.0f)
			fSpeed = 1.0f;
		PlayCustomAnimation(OBJECT_SELF, sAnim, FALSE, fSpeed);
	}
	
	PS_DeleteLocalInt(OBJECT_SELF, "ANIMATION");
	PS_DeleteLocalInt(OBJECT_SELF, "STOP_ANIMATION");
	ClearAllActions();
	
	DelayCommand(1.0f, ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE));
	DelayCommand(1.0f, PS_DeleteLocalString(OBJECT_SELF, "PercievedScript"));

}