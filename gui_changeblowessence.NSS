#include "ff_safevar"

#include "aaa_constants"

const int SPELL_I_HINDERING_BLAST=1130;
//const int SPELL_I_BINDING_BLAST=1131;
const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;

void main(int nMetaMagic)
{
	object oPC = OBJECT_SELF;

	if (GetHasSpell(SPELL_I_HIDEOUS_BLOW, oPC) || GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) 
	{
		
		if (GetHasSpell(SPELL_I_BRIMSTONE_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_BRIMSTONE_BLAST)
			return;

		if (GetHasSpell(SPELL_I_BEWITCHING_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_BEWITCHING_BLAST)
			return;

		if (GetHasSpell(SPELL_I_BESHADOWED_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_BESHADOWED_BLAST)
			return;

		if (GetHasSpell(SPELL_I_DRAINING_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_DRAINING_BLAST)
			return;
	
		if (GetHasSpell(SPELL_I_FRIGHTFUL_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_FRIGHTFUL_BLAST)
			return;

		if (GetHasSpell(SPELL_I_HELLRIME_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_HELLRIME_BLAST )
			return;

		if (GetHasSpell(SPELL_I_NOXIOUS_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_NOXIOUS_BLAST)
			return;

		if (GetHasSpell(SPELL_I_UTTERDARK_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_UTTERDARK_BLAST)
			return;

		if (GetHasSpell(SPELL_I_VITRIOLIC_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_VITRIOLIC_BLAST)
			return;

		if (GetHasSpell(SPELL_I_BINDING_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_BINDING_BLAST )
			return;

		if (GetHasSpell(SPELL_I_HINDERING_BLAST, oPC)==0 && nMetaMagic==METAMAGIC_INVOC_HINDERING_BLAST)
			return;

		PS_SetLocalInt(oPC,"HideousMeta",nMetaMagic);
		//SendMessageToPC(oPC, "Setting hideous blow to: "+IntToString(nMetaMagic));
		
		ExecuteScript("nw_s0_ihideousb1",oPC);
	}
}