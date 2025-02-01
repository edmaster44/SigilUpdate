#include "ff_safevar"

#include "ps_astral_inc"
void main () {

	int lastFired = PS_GetLocalInt(OBJECT_SELF, "timer");
	int now = AstralTimeStamp();
	int max = PS_GetLocalInt(OBJECT_SELF, "speakNum");
	if (abs(now-lastFired) > 6)
	{
		int current = Random(max)+1;
		string sNPC = PS_GetLocalString(OBJECT_SELF, "npc_"+IntToString(current));
		string sSpeak = PS_GetLocalString(OBJECT_SELF, "speak_"+IntToString(current));
		object oNPC = GetNearestObjectByTag(sNPC);
		if (GetIsObjectValid(oNPC))
			AssignCommand(oNPC, ActionSpeakString(sSpeak, TALKVOLUME_TALK));
		PS_SetLocalInt(OBJECT_SELF, "timer", now);
	}
}