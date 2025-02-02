#include "ff_safevar"

//Death Script - fires on death
//used by scod_s_balefulgeas
#include "nw_i0_invocatns"
void main() {
    
	int nDamage = PS_GetLocalInt(OBJECT_SELF, "EldritchBlast_Damage");
	int nDC = PS_GetLocalInt(OBJECT_SELF, "EldritchBlast_DC");
	object oCaster = PS_GetLocalObject(OBJECT_SELF, "EldritchBlast_Caster");
	
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oObj)) {
	
		if (GetIsEnemy(oObj, oCaster)) {
			int thisDamage = GetReflexAdjustedDamage(nDamage, oObj, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
			effect eDam = EffectDamage(thisDamage, DAMAGE_TYPE_MAGICAL);
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj));
		}
	
		oObj = GetNextObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(OBJECT_SELF));
	}
	

}