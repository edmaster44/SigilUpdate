void CreateGear(string sGear, location lLoc) {
	object newGear = CreateObject(OBJECT_TYPE_PLACEABLE, sGear, lLoc, FALSE);
}

void RotateGear(string sGear, float fAngle)
{
	object oGear = GetNearestObjectByTag(sGear);
	location lLoc = GetLocation(oGear);
	object oArea = GetAreaFromLocation(lLoc);
	vector vVector = GetPositionFromLocation(lLoc);
		
	DestroyObject(oGear, 0.01);
	
	lLoc = Location(oArea, vVector, fAngle);
	DelayCommand(0.1f, CreateGear(sGear, lLoc));
}

void main () {

	object oGear = GetNearestObjectByTag("pl_mechanus_centralgear");
	float angle = GetFacing(oGear);
	
	PlaySound("as_cv_brickscrp1", TRUE);
	RotateGear("pl_mechanus_centralgear", 5.0f);
	DelayCommand(0.3f, RotateGear("pl_mechanus_centralgear", 10.0f));
	DelayCommand(0.6f, RotateGear("pl_mechanus_centralgear", 15.0f));
	DelayCommand(0.9f, RotateGear("pl_mechanus_centralgear", 20.0f));
	DelayCommand(1.2f, RotateGear("pl_mechanus_centralgear", 25.0f));
	DelayCommand(1.5f, RotateGear("pl_mechanus_centralgear", 30.0f));
	DelayCommand(1.8f, RotateGear("pl_mechanus_centralgear", 35.0f));
	DelayCommand(2.1f, RotateGear("pl_mechanus_centralgear", 40.0f));
	DelayCommand(2.4f, RotateGear("pl_mechanus_centralgear", 45.0f));

}