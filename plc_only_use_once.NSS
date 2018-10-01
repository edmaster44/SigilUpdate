//::///////////////////////////////////////////////
//:: OnUse: activates the placeable, and sets a flag to prevent further uses
//:: plc_only_use_once
//:: Copyright (c) 2014 4760.
//:://////////////////////////////////////////////
/*

    Simple script to run the Activate animation of a placeable that supports it.

    Placeables that are running this script will remain in their activated state after execution.

*/
//:://////////////////////////////////////////////
//:: Created By: Thierry Petitjean
//:: Created On: 29/04/2014
//:://////////////////////////////////////////////


void ActionCreateObject(string sCreateWeaponPLC, string sCreateWeaponIT, location lWhere)
{
	object oWeapon;
   	object oSELF = OBJECT_SELF; 
	// CreateObject returns an object, but DelayCommand only works with void functions, so we wrap CreateObject within ActionCreateObject
	oWeapon = CreateObject(OBJECT_TYPE_PLACEABLE, sCreateWeaponPLC, lWhere);
	// au cas où l'objet n'aurait pas été créé (non utilisation du hak "Item placeables" de Kivinen)
	if (GetObjectByTag(sCreateWeaponPLC) == OBJECT_INVALID)
	{
		oWeapon = CreateObject(OBJECT_TYPE_ITEM, sCreateWeaponIT, lWhere);
	}
	// mais de toute façon, même si le placeable existe, il doit maintenant faire référence à l'objet choisi et pas la version par défaut
	else
	{
		SetLocalString(oWeapon, "item_resref", sCreateWeaponIT);
		// mise à l'échelle
		float fEchelle = GetLocalFloat(oSELF, "fScale");
		if (fEchelle == 0.0f) fEchelle = 1.0f;
		SetScale(oWeapon, GetScale(oSELF, SCALE_X)*fEchelle, GetScale(oSELF, SCALE_Y)*fEchelle, GetScale(oSELF, SCALE_Z)*fEchelle);
	}
}

void main()
{
   // note that nActive == 1 does  not necessarily mean the placeable is active, that depends on the initial state of the object
   	object oSELF = OBJECT_SELF; 
	int bDontRun = GetLocalInt(oSELF, "IS_ACTIVATED_BY_OTHER_PLC");
	if (bDontRun != 0)
	{
		string sMessage = (GetGlobalInt("nLangue")==0?"Nothing happens. There must be another way...":"Rien ne se passe. Il doit y avoir une autre méthode");
		SendMessageToPC(GetFirstPC(FALSE), sMessage);
		return;
	}
   	int nActive = GetLocalInt(oSELF, "IS_PLC_ACTIVATED");
	float fDuration = GetLocalFloat(oSELF, "fDuration");
	string sCreateWeaponPLC = GetLocalString(oSELF, "sCreateWeaponPLC");
	string sCreateWeaponIT = GetLocalString(oSELF, "sCreateWeaponIT");
	float fDistance =  GetLocalFloat(oSELF, "fDistance"); // distance entre le pivot de la statue et celui de la hache à créer
	float fAngle =  GetLocalFloat(oSELF, "fAngle"); // angle (en degrés) entre les deux pivots par rapport au Nord
	float fHeading =  GetLocalFloat(oSELF, "fHeading"); // angle (en degrés) entre la position par défaut de l'arme à créer (placeable à plat) et celle recherchée
	location lWhere = GetLocation(oSELF);
   // * Play Appropriate Animation
    if (!nActive)
    {
		ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE, fDuration);
		if (GetStringLength(sCreateWeaponPLC) > 0)
		{
			// calcul de la position où créer l'objet libéré par l'activation
			vector vCoordinates = GetPositionFromLocation(lWhere); // position de la statue
			vector vOffset; // position RELATIVE de l'objet à créer par rapport à la statue
			float fFacing = GetFacing(oSELF) - fHeading; // alignons l'objet avec la statue
			 // restons dans l'intervalle [0 ; 360[
			if (fFacing < 0.0) fFacing += 360.0;
			if (fFacing > 360.0) fFacing -= 360.0;
			vOffset.x = fDistance * cos(fFacing + fAngle) * GetScale(oSELF, SCALE_X);
			vOffset.y = fDistance * sin(fFacing + fAngle) * GetScale(oSELF, SCALE_Y);
			vOffset.z = 0.0;
			lWhere = Location(GetArea(oSELF), vCoordinates + vOffset, fFacing);
			// l'animation dure quelques secondes : attendons le temps suffisant avant de créer l'objet
			DelayCommand(fDuration-0.1, ActionCreateObject(sCreateWeaponPLC, sCreateWeaponIT, lWhere));
			// y a-t-il un deuxième objet à créer ?
			sCreateWeaponPLC = GetLocalString(oSELF, "sCreateShieldPLC");
			sCreateWeaponIT = GetLocalString(oSELF, "sCreateShieldIT");
			fAngle =  GetLocalFloat(oSELF, "fAngle2"); // angle (en degrés) entre les deux pivots par rapport au Nord
			if (GetStringLength(sCreateWeaponPLC) > 0)
			{
				// calcul de la position où créer l'objet libéré par l'activation
				vOffset.x = fDistance * cos(fFacing + fAngle) * GetScale(oSELF, SCALE_X);
				vOffset.y = fDistance * sin(fFacing + fAngle) * GetScale(oSELF, SCALE_Y);
				vOffset.z = GetLocalFloat(oSELF, "fZ");
				lWhere = Location(GetArea(oSELF), vCoordinates + vOffset, fFacing);
				// l'animation dure quelques secondes : attendons le temps suffisant avant de créer l'objet
				DelayCommand(fDuration+0.5, ActionCreateObject(sCreateWeaponPLC, sCreateWeaponIT, lWhere));
			}
		}
		SetLocalInt(oSELF, "IS_PLC_ACTIVATED", 1);
	}
	else
    {
		int bReversible = GetLocalInt(oSELF, "bReversible");
		if (bReversible != 0)
		{
			ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE);
			SetLocalInt(oSELF, "IS_PLC_ACTIVATED", 0);
		}
	}
}