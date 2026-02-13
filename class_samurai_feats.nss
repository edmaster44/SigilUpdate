

// Agile Warrior feat for Samurai, by FlattedFifth Feb 11, 2026

#include "class_samurai_feats_inc"

void main(){
	int nID = GetSpellId();
	object oPC = OBJECT_SELF;
	int nLevel = GetSamKenLevel(oPC);
	
	switch (nID){
		case SAMURAI_AGILE_WARRIOR_SPELL_ID: AgileWarrior(oPC, nLevel); return;
		case SAMURAI_COMMANDING_PRESENCE_SPELL_ID: CommandingPresence(oPC); return;
		case SAMURAI_STRIKETHROUGH_SPELL_ID: Strikethrough(oPC, nLevel); return;
		case SAMURAI_FRENZIED_SPELL_ID: FrenziedBlade(oPC, nLevel); return;
		default: return;
	}
}