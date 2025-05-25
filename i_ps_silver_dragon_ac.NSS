

void main(){
object oPC = GetItemActivator();
object oItem = GetItemActivated();
object oTarget = oPC;
int nPoly = GetLocalInt(oItem, "polymorph");
int nDuration = GetLocalInt(oItem, "duration");
string sEffect = GetLocalString(oItem, "Effect");
effect eEffect = EffectNWN2SpecialEffectFile(sEffect, oPC);
effect ePoly = EffectPolymorph(nPoly);
effect eVis = EffectNWN2SpecialEffectFile("sp_enlarge_person_hit");
AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_USEITEM,1.0));
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration)));
DelayCommand(1.0,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds(nDuration))));
DelayCommand(1.0,SendMessageToPC(oPC,"Visual effect *" + sEffect + "* applied. To remove, use the Release Spells button in PC Tools.")); 
AssignCommand(oTarget, ClearAllActions());
}
