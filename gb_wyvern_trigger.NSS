// Trigger the wyvern spell to fire the
// flying wyvern projectile from a random
// point at the edge of the area

#include "x0_i0_position"
#include "ps_inc_functions"

location RandomSource(object oTrigger);

void main()
{
	int iSpellID = 1919;// Row number in spells.2DA
	
	object oTrigger = GetEnteringObject();
	object oPC = GetFirstPC();
	if (!GetFactionEqual(oTrigger, oPC) && oTrigger != oPC )
		return;// Abort if not a party member
		
	PS_SetLocalObject(OBJECT_SELF, "TriggeredBy", oPC);
		
	int nTime = PS_GetLocalInt(OBJECT_SELF, "last_spawned");
	if (!GetIsObjectValid(GetNearestObjectByTag("c_colothys_vulture", OBJECT_SELF)) && GetTime()-nTime > 120) {
		
		PS_SetLocalInt(OBJECT_SELF, "last_spawned", GetTime());
		location lTarget = GetRandomLocation(GetArea(oTrigger), oTrigger, 5.0);
		lTarget = CalcSafeLocation(oTrigger, lTarget, 5.0, TRUE, FALSE);
		vector vPosition = GetPositionFromLocation(lTarget);
		location lSource = RandomSource(oTrigger);
		
		object oSource = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ",lSource);
		TurnToFaceObject(oTrigger, oSource);
		float fDirection = GetFacing(oSource);
		lTarget = Location(GetArea(oTrigger), vPosition, fDirection);
		
		AssignCommand(oSource, ActionCastSpellAtLocation(iSpellID, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
		DestroyObject(oSource, 10.0);
		
	}
	
}

location RandomSource(object oTrigger) {

	object oArea = GetArea(oTrigger);
	vector vPosition = GetPosition(oTrigger);
	float fZ = vPosition.z + 20.0 + IntToFloat(Random(10));
	float fX;
	float fY;
	int nHeight = GetAreaSize(AREA_HEIGHT, oArea);
	int nWidth = GetAreaSize(AREA_WIDTH, oArea);
	
	float fXMax = IntToFloat(nWidth * 10);
	float fYMax = IntToFloat(nHeight * 10);
	
	if (d2(1) == 1)// X axis
		{
		fY = 1.0;
		if(d2(1) == 2) fY = fYMax - 1.0;	
		fX = IntToFloat(Random(FloatToInt(fXMax)));
	
		}
	else// Y axis
		{
		fX = 1.0;
		if(d2(1) == 2) fX = fXMax - 1.0;
		fY = IntToFloat(Random(FloatToInt(fYMax)));
		}
	
	vector vSource = Vector(fX, fY, fZ);
	location lSource = Location(oArea, vSource, 0.0);
	
	return lSource;
}