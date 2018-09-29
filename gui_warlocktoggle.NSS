//Changed script targets from OBJECT_SELF to GetFirstPC(0) to allow companions to utilize scripts. -Taigen
//Changed script to be more PW friendly - cryptc

void main(string status)
{
	object oPC = OBJECT_SELF;

	DisplayGuiScreen(oPC, "SCREEN_WARLOCK", FALSE, "warlock.xml");
}