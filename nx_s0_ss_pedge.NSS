#include "ff_safevar"

// Penetrating Edge Script for NX1 Silver Sword of Gith
// Simulates bypassing DR for physical attacks.
// CGaw OEI 6/19/07

#include "ginc_math"

void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLoop, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLoop, fSpeed);
}


void ApplyEdge()
{
	object oItem  = GetSpellCastItem();    // The item casting that triggered this spellscript
	effect eMaxDamage = EffectMaxDamage();
	object oCaster = OBJECT_SELF;
	int nRandomInt = RandomIntBetween(100000, 999999);
	
	PS_SetLocalInt(oItem, "Effect_ID", nRandomInt);
	effect eID = SetEffectSpellId(eMaxDamage, nRandomInt);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eID, oCaster, 60.0f);
}

void main()
{
	object oCaster = OBJECT_SELF;
	
	effect eVis = EffectNWN2SpecialEffectFile("sp_magic_cast.sef");
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, 2.0f);
	
	PlayCustomAnimationWrapper(oCaster, "liftswordup", 0, 0.75f);
	DelayCommand(1.0f, PlayCustomAnimationWrapper(oCaster, "liftswordloop", 0, 1.0f));
	DelayCommand(2.0f, PlayCustomAnimationWrapper(oCaster, "%", 0, 1.0f));
	
	DelayCommand(1.5f, ApplyEdge());
}