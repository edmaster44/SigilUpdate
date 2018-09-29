//Mummydust, Summons a mummy warrior for 24 hours. 
//By Ariella
#include "x2_inc_spellhook"
void main()
{
   //Declare major variables
    float fDuration = HoursToSeconds(24);
	location lSpellTargetLocation = GetSpellTargetLocation();
    effect eSummon = EffectSummonCreature("ps_mumdust");
	effect eDur = EffectVisualEffect(VFX_AOE_CRADLE_OF_RIME);
    effect eVis = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	


    //Apply the VFX impact and summon effect
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDur, lSpellTargetLocation, 5.0);
	DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLocation));
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration));
}
