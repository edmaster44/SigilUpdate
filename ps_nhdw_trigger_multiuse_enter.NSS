

//Script by Dedic8ed
//This script is designed to be used by a placed trigger.
//Place in the triggers's OnEnter; this can be used in conjunction with ps_nhdw_trigger_multiuse_exit

void main()
{

	object oPC1 = GetEnteringObject();;
	
	if (!GetIsPC(oPC1)) return;

//the "open1" variable will open a door with this tag 
	string sOpen1 		= GetLocalString(OBJECT_SELF,"open1");
//the "close1" variable will close a door with this tag
	string sClose1 		= GetLocalString(OBJECT_SELF,"close1");
//the "vfx1" variable will apply this visual effect to the person setting off the trigger; the full filename (xxxx.sef) must be used
	string sVFX1 		= GetLocalString(OBJECT_SELF,"vfx1");
//the "floaty1" variable will be generated as floaty text over the head of the character pulling the lever
	string sFloaty1 	= GetLocalString(OBJECT_SELF,"floaty1");
// objects 1-4 to apply object vfx to
	string sObj1 		= GetLocalString(OBJECT_SELF, "obj1");
	string sObj2 		= GetLocalString(OBJECT_SELF, "obj2");
	string sObj3 		= GetLocalString(OBJECT_SELF, "obj3");
	string sObj4 		= GetLocalString(OBJECT_SELF, "obj4");
// vfx on objects 1-4; the full filename (xxxx.sef) must be used
	string sVFXo1 		= GetLocalString(OBJECT_SELF, "vfxo1");
	string sVFXo2 		= GetLocalString(OBJECT_SELF, "vfxo2");
	string sVFXo3 		= GetLocalString(OBJECT_SELF, "vfxo3");
	string sVFXo4 		= GetLocalString(OBJECT_SELF, "vfxo4");
	
//Definition
	object oDoorOpen1	= GetObjectByTag(sOpen1);
	object oDoorClose1	= GetObjectByTag(sClose1);
	object oObj1		= GetObjectByTag(sObj1);
	object oObj2		= GetObjectByTag(sObj2);
	object oObj3		= GetObjectByTag(sObj3);
	object oObj4		= GetObjectByTag(sObj4);
	
//Door unlock & open section
	SetLocked(oDoorOpen1, FALSE);
	AssignCommand(oDoorOpen1, ActionOpenDoor(oDoorOpen1));
//Door lock & close section	
	AssignCommand(oDoorClose1, ActionCloseDoor(oDoorClose1));
	SetLocked(oDoorClose1, TRUE);
//Visual effect section
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sVFX1), oPC1);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFXo1), oObj1, 60.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFXo2), oObj2, 60.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFXo3), oObj3, 60.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFXo4), oObj4, 60.0f);
	
//Floaty Text section
	FloatingTextStringOnCreature(sFloaty1,oPC1);

}