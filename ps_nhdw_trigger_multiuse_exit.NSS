//Script by Dedic8ed
//This script is designed to be used by a placed trigger.
//Place in the triggers's OnEnter; this can be used in conjunction with ps_nhdw_trigger_multiuse_enter
#include "ps_inc_functions"

void main()
{

	object oPC2 = GetExitingObject();
	
	//if (!GetIsPC(oPC2)) return;
	if (!GetIsPC(oPC2) && !GetIsPC(GetMaster(oPC2))) return;
	
	//exit script will not execute if there's still a pc, summon, familiar, hench, etc
	// still in the trigger
	object oObject = GetFirstInPersistentObject(OBJECT_SELF);
    while (GetIsObjectValid(oObject))
    {
        if (GetIsPC(oObject) || GetIsPC(GetMaster(oObject)))
			return;
        oObject = GetNextInPersistentObject(OBJECT_SELF);
    }
	
	// if the entering object is a pc, then send messages to them
	// otherwise send messages to the master of the entering object
	object oPC = oPC2; // the recipient of messages
	if (!GetIsPC(oPC2)) oPC = GetMaster(oPC2);


//the "open2" variable will open a door with this tag 
	string sOpen2 = GetLocalString(OBJECT_SELF,"open2");
//the "close2" variable will close a door with this tag
	string sClose2 = GetLocalString(OBJECT_SELF,"close2");
//the "vfx2" variable will apply this visual effect to the lever's puller; the full filename (xxxx.sef) must be used
	string sVFX2 = GetLocalString(OBJECT_SELF,"vfx2");
//the "floaty2" variable will be generated as floaty text over the head of the character pulling the lever
	string sFloaty2 = GetLocalString(OBJECT_SELF,"floaty2");
// objects 1-4 to apply object vfx to
	string sObj1 		= GetLocalString(OBJECT_SELF, "obj1");
	string sObj2 		= GetLocalString(OBJECT_SELF, "obj2");
	string sObj3 		= GetLocalString(OBJECT_SELF, "obj3");
	string sObj4 		= GetLocalString(OBJECT_SELF, "obj4");
//the "beam#" variable will be generated (use values from VFX_BEAM_*) as a beam between object # and the nearest creature.
	int nBeam1			= GetLocalInt(OBJECT_SELF, "beam1");
	int nBeam2			= GetLocalInt(OBJECT_SELF, "beam2");
	int nBeam3			= GetLocalInt(OBJECT_SELF, "beam3");
	int nBeam4			= GetLocalInt(OBJECT_SELF, "beam4");
	
//Definition
	object oDoorOpen2	= GetObjectByTag(sOpen2);
	object oDoorClose2 	= GetObjectByTag(sClose2);
	object oSource1		= GetObjectByTag(sObj1);
	object oSource2		= GetObjectByTag(sObj2);
	object oSource3		= GetObjectByTag(sObj3);	
	object oSource4		= GetObjectByTag(sObj4);
	effect eRay1		= EffectBeam(nBeam1, oSource1, BODY_NODE_HAND);
	effect eRay2		= EffectBeam(nBeam2, oSource2, BODY_NODE_HAND);
	effect eRay3		= EffectBeam(nBeam3, oSource3, BODY_NODE_HAND);
	effect eRay4		= EffectBeam(nBeam4, oSource4, BODY_NODE_HAND);
	object oTarget1, oTarget2, oTarget3, oTarget4;
	effect eEffect1		= EffectRandomNerf();
	effect eEffect2		= EffectRandomNerf();
	effect eEffect3		= EffectRandomNerf();
	effect eEffect4		= EffectRandomNerf();

//Door unlock & open section
	if (GetIsObjectValid(oDoorOpen2)){
		SetLocked(oDoorOpen2, FALSE);
		AssignCommand(oDoorOpen2, ActionOpenDoor(oDoorOpen2));
		SendMessageToPC(oPC, "You hear a door opening.");
	}
//Door lock & close section	
	if (GetIsObjectValid(oDoorClose2)){
		AssignCommand(oDoorClose2, ActionCloseDoor(oDoorClose2));
		SetLocked(oDoorClose2, TRUE);
		SendMessageToPC(oPC, "You hear a door closing.");
	}
//Visual effect section
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sVFX2), oPC2);
//Floaty Text section
	FloatingTextStringOnCreature(sFloaty2,oPC2);
//Beam section
	if (nBeam1 != 0)
	{	oTarget1 = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSource1);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eRay1, eEffect1), oTarget1) ;	}
	if (nBeam2 != 0)
	{	oTarget2 = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSource2);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eRay2, eEffect2), oTarget2) ;	}
	if (nBeam3 != 0)
	{	oTarget3 = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSource2);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eRay3, eEffect3), oTarget3) ;	}
	if (nBeam4 != 0)
	{	oTarget4 = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSource2);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eRay4, eEffect4), oTarget4) ;	}
}