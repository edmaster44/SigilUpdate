#include "ff_safevar"

void Respawn(string sTag, location lLoc) {
	CreateObject(OBJECT_TYPE_PLACEABLE, sTag,lLoc);
}

void main () {

	object oPC = GetLastUsedBy();
	
	if (PS_GetLocalInt(OBJECT_SELF, "used") > 0)
		return;
	PS_SetLocalInt(OBJECT_SELF, "used", 1);
	
	CreateItemOnObject("ps_questobject_corpse", oPC, 1 );
	
	DelayCommand(60.0f, Respawn(GetTag(OBJECT_SELF), GetLocation(OBJECT_SELF)));
	
	SetPlotFlag(OBJECT_SELF, FALSE);
	DestroyObject(OBJECT_SELF, 0.1f);
}