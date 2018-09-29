#include "aaa_nature_inc" 

void main()
{
int nSpell = GetSpellId(); 
object oSelf = OBJECT_SELF;
//SendMessageToPC(oSelf, "Using SpellID: "+IntToString(nSpell));
switch (nSpell)
{ 
	case SPELL_FEAT_BLINK: //Blink
	{		
		Blink();
		break;
	}	
	case SPELL_FEAT_DIMENSION_DOOR: //Dimension Door
	{
		DimensionDoor(oSelf);
		break;
	}
	case SPELL_FEAT_FERAL_MARK: //Feral Mark
	{
		StripSpellEffect(SPELL_FEAT_FERAL_MARK);
		FeralHeart();
		break;
	}
	case SPELL_FEAT_BATTLE_HOWL: //Battle Howl
	{
		DoBattleHowl();
		break;
	}
	case SPELL_FEAT_WW_COLDTYPE1: //Winter Wolf cold res 1
	{
		int nHasColdImmunity2 = GetHasFeat(FEAT_WW_COLDTYPE2);
		if (nHasColdImmunity2 == 1) return;
		StripSpellEffect(SPELL_FEAT_WW_COLDTYPE1);
		WinterWolfColdImmunity(50, 50);
		break;
	}
	case SPELL_FEAT_WW_COLDTYPE2: //Winter Wolf cold res 2
	{
		StripSpellEffect(SPELL_FEAT_WW_COLDTYPE1, SPELL_FEAT_WW_COLDTYPE2);
		WinterWolfColdImmunity(100, 0);
		break;
	}
	case SPELL_FEAT_WG_ImpKnockdown: //Worg Improved Knockdown
	{
		ReplaceFeat(FEAT_WG_ImpKnockdown, FEAT_IMPROVED_KNOCKDOWN);
		break;
	}
	case SPELL_FEAT_BD_Mobility: //Blink Dog Mobility
	{
		ReplaceFeat(FEAT_BD_Mobility, FEAT_MOBILITY);
		break;
	}
	case SPELL_FEAT_WW_FREEZING_BR: //Winter Wolf Freezing Breath
	{
		CastConeCold();
		break;
	}
	case SPELL_FEAT_HUNTING_LOPE1: //Hunting Lope 1
	{
		int nHasHuntingLope2 = GetHasFeat(FEAT_HUNTING_LOPE2);
		if (nHasHuntingLope2 == 1) return;
		HuntingLope(oSelf, 20, nSpell);
		break;
	}
	case SPELL_FEAT_HUNTING_LOPE2: //Hunting Lope 2
	{
		HuntingLope(oSelf, 40, nSpell);
		break;
	}
	case SPELL_FEAT_ETERNAL_LEADER: //EternalLeader
	{
		ApplyRegeneration();
		break;
	}
	case SPELL_FEAT_TEARING_BITE: //tearing bite
	{
		TearingBite();
		break;
	}
	case SPELL_FEAT_GENESIS:
	{
		StripSpellEffect(SPELL_FEAT_GENESIS);
		Genesis();
		break;
	}
	case SPELL_FEAT_ARMOR_OF_NATURE:
	{
		StripSpellEffect(SPELL_FEAT_ARMOR_OF_NATURE);
		ArmorOfNature();
		break;
	}
	case SPELL_FEAT_OVERGROWTH:
	{
		StripSpellEffect(SPELL_FEAT_OVERGROWTH);
		Overgrowth();
		break;
	}
	case SPELL_FEAT_TOUGH_ROOTS:
	{
		StripSpellEffect(SPELL_FEAT_TOUGH_ROOTS);
		ToughRoots();
		break;
	}
	case SPELL_FEAT_ANIMATE_TREES:
	{
		AnimateTrees();
		break;
	}
	case SPELL_FEAT_TREANT_RESISTANCE:
	{
		StripSpellEffect(SPELL_FEAT_TREANT_RESISTANCE);
		TreantResist();
		break;
	}
}

}