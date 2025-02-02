#include "ff_safevar"

// script to view a TGA in a GUI when a placeable is clicked on.
// Image can only be a max of 1024x768 and will not be scaled.

const string XML_PIC_PREFIX = "igpic_";
const string XML_PIC_SUFFIX = ".xml";
const string XML_SCREEN_IMAGE = "PICTURE";
const string PLACEABLE_VAR_IMAGE = "PIC_IMAGE";
const string PLACEABLE_VAR_SIZE = "PIC_SIZE";

/* possible sizes for screens, store on local var
sl = small landscape = 200x100
sp = small portrait = 100x200
ss = small square = 150x150
ml = med landscape = 400x200
mp = med portrait = 200x400
ms = med square = 300x300
ll = large landscape = 800x400
lp = large portrait = 400x800
ls = large square = 600x600
fs = "full screen" = 1024x768
*/

void main()
{
	object oPlaceable = OBJECT_SELF;
	object oPC = GetPlaceableLastClickedBy();
	
	string sImage = PS_GetLocalString(oPlaceable, PLACEABLE_VAR_IMAGE);
	string sSize = PS_GetLocalString(oPlaceable, PLACEABLE_VAR_SIZE);
	
	DisplayGuiScreen(oPC, "SCREEN_IMAGE", FALSE, XML_PIC_PREFIX + sSize + XML_PIC_SUFFIX);
	SetGUITexture(oPC, "SCREEN_IMAGE", XML_SCREEN_IMAGE, sImage);
}