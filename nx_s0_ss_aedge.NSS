// Anti-Magic Edge Script for NX1 Silver Sword of Gith
// Adds M's Disjunction.
// CGaw OEI 6/19/07

void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLoop, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLoop, fSpeed);
}

void ApplyEdge()
{
	object oItem = GetSpellCastItem();
	object oPossessor = GetItemPossessor(oItem);
	
	itemproperty ipDisjunction = ItemPropertyOnHitProps(IP_CONST_ONHIT_MORDSDISJUNCTION, IP_CONST_ONHIT_SAVEDC_30);
	
	AddItemProperty(DURATION_TYPE_TEMPORARY, ipDisjunction, oItem, 60.0);
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