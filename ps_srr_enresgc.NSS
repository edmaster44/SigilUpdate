/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Gatecrasher feats spell that handles racial energy reistance */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
	int iType;
	int iSpell = GetSpellId();
	
	switch (iSpell)
	{
		case 1384 :	iType = DAMAGE_TYPE_COLD; break;
		case 1385 :	iType = DAMAGE_TYPE_ACID; break;
		case 1386 :	iType = DAMAGE_TYPE_FIRE; break;
		case 1387 :	iType = DAMAGE_TYPE_ELECTRICAL;	break;
		case 1388 :	iType = DAMAGE_TYPE_SONIC; break;
	}
		
    if (!GetHasSpellEffect(iSpell, oPC))
	{
		effect eRes = EffectDamageResistance(iType, 10);
		eRes = ExtraordinaryEffect(eRes);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
	}	
}