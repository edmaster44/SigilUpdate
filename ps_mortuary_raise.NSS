// Agony_Aunt: Replaces old speak trigger with a script handling the respawn event.
// handles the speech event.  Depending on whether respawned from a different area
// checks "PC_DEATH_AREA" to see if different gives different message

// use FloatingTextStringOnCreature so looks same as before

void main()
{
	object oPC = GetEnteringObject();

	FloatingTextStringOnCreature("<i>*You wake up on an operating table, still feeling the pain of the injury that caused you to fall unconcious.*</i>", oPC, FALSE, 5.0);
	DelayCommand(5.0, FloatingTextStringOnCreature("<i>*A nearby Dustman speaks*: We found your broken body and brought you here, your time for the True Death is not yet at hand.</i>", oPC, FALSE, 5.0)); 
}