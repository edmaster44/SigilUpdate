#include "ff_safevar"

//*********************************************
//BOSS EVENT
// Mimi Fearthegn
// 6/21/19
//*********************************************
//The boss event system runs off the onDamage script
//nw_cs_default6. At 90%, 70%, 50%, 30%, and 10% of the 
//monsters HP events can be called. They are assigned as
//variables on the monster blueprint - 
//BossEvent_1 - fires at 90% HP
//BossEvent_2 - fires at 70% HP
//BossEvent_3 - fires at 50% HP
//BossEvent_4 - fires at 30% HP
//BossEvent_5 - fires at 10% HP
//Not all events need be assigned. Any ps_bossevent_* script will work.
//Individual ps_bossevent_* scripts will have their own required variables
//*********************************************
//ps_bossevent_damageburst variables
//DamageBurst_Anim = The animation name to play - Defaults to mjr_cast
//DamageBurst_DC = Reflex DC for half damage - REQUIRED
//DamageBurst_Dice = the number of d6's to roll for damage - REQUIRED
//DamageBurst_DamageType = damage type index, see DAMAGE_TYPE_* constants - REQUIRED
//DamageBurst_DamageRadius = the radius of the damage burst - REQUIRED
//DamageBurst_VFX = The vfx to play for the damage burst - Optional
//DamageBurst_Message = The optional message to broadcast about the attack - Optional
//*********************************************
//Effect: Boss plays whirlwind animation, and does melee touch attack on
//hostiles within 5 units radius. Those hit take damage, and, if they fail
//their fort save, are knocked down.
void main () {

	float fRadius = PS_GetLocalFloat(OBJECT_SELF, "DamageBurst_DamageRadius");
	string sAnim = PS_GetLocalString(OBJECT_SELF, "DamageBurst_Anim");
	if (sAnim == "")
		sAnim = "mjr_cast";
		
	int nDC = PS_GetLocalInt(OBJECT_SELF, "DamageBurst_DC");
	int nDice = PS_GetLocalInt(OBJECT_SELF, "DamageBurst_Dice");
	int nDamType = PS_GetLocalInt(OBJECT_SELF, "DamageBurst_DamageType");
	string sVFX = PS_GetLocalString(OBJECT_SELF, "DamageBurst_VFX");
	string sMessage = PS_GetLocalString(OBJECT_SELF, "DamageBurst_Message");
	
	ClearAllActions();
	
	if (sMessage != "") {
		SpeakString(sMessage);
	}
	
	PlayCustomAnimation(OBJECT_SELF, sAnim, FALSE, 1.0f);
	
	if (sVFX != "") {
		effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
		DelayCommand(0.3f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(OBJECT_SELF)));
	}
	
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oObj)) {
	
		if (GetIsEnemy(oObj, OBJECT_SELF)) {
			int nDamage = d6(nDice);
			if (ReflexSave(oObj, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF)) {
				effect eDam = EffectDamage(nDamage/2, nDamType);
				DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj));
				AssignCommand(oObj, ActionSpeakString("You succeed on your reflex save against "+GetName(OBJECT_SELF)+"'s attack, taking half damage."));
				SendMessageToPC(oObj, "You succeed on your reflex save against "+GetName(OBJECT_SELF)+"'s attack, taking half damage.");
			} else {
				effect eDam = EffectDamage(nDamage, nDamType);
				DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj));
				AssignCommand(oObj, ActionSpeakString("You fail your reflex save against "+GetName(OBJECT_SELF)+"'s attack, taking full damage."));
				SendMessageToPC(oObj, "You fail your reflex save against "+GetName(OBJECT_SELF)+"'s attack, taking full damage.");
			}
		}
	
		oObj = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	}

}