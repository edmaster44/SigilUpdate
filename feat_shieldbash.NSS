#include "x2_inc_spellhook"
#include "aaa_constants"
#include "feat_shieldbash_inc"




void main()
{

	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();

	switch (nSpell){

	case SPELLFEAT_SHIELDBASH :		//Shield Bash
	Shield_Bash(oPC, oTarget,nSpell);
		break;
		
	case SPELLFEAT_SHIELDTHROW: //Throw Shield	
	Shield_Throw(oPC, oTarget, nSpell);
	break;	
	
	case SPELLFEAT_AGILE_SHIELDSTRIKE: //Agile Shield Strike
	Agile_Strike(oPC, oTarget, nSpell);
	break;
	
	
	case SPELLFEAT_ARCANEBASH: //Arcane Shield Bash
	Arcane_Bash(oPC, nSpell);
	break;
}			
		
}
		
			