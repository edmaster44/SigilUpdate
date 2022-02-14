/*Created by edmaster44- Half-Undead */
#include "aaa_halfundead_inc"
void RunHalfUndeadScript(object oPC, int nSpellID)
{
	SetLocalInt(oPC,"HUCASTING",1); DelayCommand(1.0f,DeleteLocalInt(oPC,"HUCASTING"));
	ExecuteScript(Get2DAString("spells", "ImpactScript", nSpellID),oPC);
}

void main(){
	object oPC = OBJECT_SELF;
switch(GetSpellId()){
	case 1517:RunHalfUndeadScript(oPC,1308); break; //Vampire Slam
	case 1516:RunHalfUndeadScript(oPC,64); break; //Ghul's Bite

}
} 