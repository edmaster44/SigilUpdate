#include "aaa_constants"
#include "x2_inc_spellhook"
#include "ps_class_warchanter_inc"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();
	

	
		switch (nSpell)
	{
		
	case SPELLABILITY_WC_SINGING_SHOUT :		//Sining Shout	
			DelayCommand(0.0f, WarChanter_SingingShout(oPC, nSpell));
		break;

			case SPELLABILITY_WC_INSPIRE_RECKLESSNESS:		//Inspire reckless
			DelayCommand(0.0f, WarChanter_InspireRecklessness(oPC, nSpell));
		break;
		case SPELLABILITY_WC_INSPIRE_TOUGHNESS:		//Earth Resilience
			DelayCommand(0.0f, WarChanter_Inspire_Toughness(oPC, nSpell));
		break;
		
			case SPELLABILITY_WC_SNOWSONG:		//Snow Song
			DelayCommand(0.0f, WarChanter_SnowSong(oPC, nSpell));
		break;
				case SPELLABILITY_WC_COMBINE_SONG:		//Assign Combine Song
			DelayCommand(0.0f, SPELLABILITY_WarChanter_COMBINE_SONG(oPC, nSpell));
		break;
		
			case SPELLABILITY_WC_PLAY_COMBINE_SONG:		//Play Combine Song
			DelayCommand(0.0f, SPELLABILITY_WC_PLAY_COMBINE_SONG(oPC, nSpell));
		break;
		
		}
		}
	
	