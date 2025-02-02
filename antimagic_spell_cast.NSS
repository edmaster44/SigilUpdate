#include "x2_inc_switches"


void msg(string str)
{
SpeakString(str, TALKVOLUME_SHOUT);
}

int checkMageSlayer(object caster);

void main()
{
	object caster = GetLastSpellCaster();
	
	if (caster != OBJECT_INVALID)
	{
		int done = FALSE;
		
		if(GetLocalInt(caster, "ps_anti_magic_zone") != 0)
		{
			SendMessageToPC(caster, "You are in an anti-magic zone where spells do not work!");
			SetModuleOverrideSpellScriptFinished();
			done = TRUE;
		}
		
		if (!done)
		{
			// check if a spell was cast from outside of the zone into a target inside the zone
			object target = GetSpellTargetObject();
			if (target != OBJECT_INVALID)
			{
				if(GetLocalInt(target, "ps_anti_magic_zone") != 0)
				{
					SendMessageToPC(caster, "Your target is in an anti-magic zone where spells do not work!");
					SetModuleOverrideSpellScriptFinished();
				}
			}
		}
	}
}