#include "aaa_doppelganger_inc"

void main()
{
int nSpell = GetSpellId(); 
object oSelf = OBJECT_SELF;
//SendMessageToPC(oSelf, "Using SpellID: "+IntToString(nSpell));
switch (nSpell)
{ 
	case SPELL_FEAT_DP_ALTERNATE_FORM:
	{		
		AlternateForm();
		break;
	}
	case SPELL_FEAT_DP_CHANGE_SELF:
	{		
		ChangeSelf();
		break;
	}
	case SPELL_FEAT_DP_MENTAL_ACUITY:
	{
		int nHasMentalAcuity2 = GetHasFeat(FEAT_DP_MENTAL_ACUITY_IMP);
		if (nHasMentalAcuity2 == 1) return;
		StripSpellEffect(SPELL_FEAT_DP_MENTAL_ACUITY);
		MentalAcuity();
		break;
	}
	case SPELL_FEAT_DP_MENTAL_ACUITY_IMP:
	{
		StripSpellEffect(SPELL_FEAT_DP_MENTAL_ACUITY, SPELL_FEAT_DP_MENTAL_ACUITY_IMP);
		MentalAcuityImp();
		break;
	}
	case SPELL_FEAT_DP_BLUFF:
	{
		StripSpellEffect(SPELL_FEAT_DP_BLUFF);
		DPBluff();
		break;
	}
		case SPELL_FEAT_INFILTRATOR_ARMOR:
	{
		StripSpellEffect(SPELL_FEAT_INFILTRATOR_ARMOR);
		InfiltratorArmor();
		break;
	}
}
}