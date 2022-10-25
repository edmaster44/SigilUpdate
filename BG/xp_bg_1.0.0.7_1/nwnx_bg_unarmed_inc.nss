// Name of the 2da file that holds the unarmed progression table.
const string sUnarmed2da = "unarmed";


// Helper Functions

// Converts a CREATURE_SIZE_* to its string representation.
string CreatureSizeToString(int nCreatureSize)
{
	switch(nCreatureSize)
	{
		case 1: return "TINY";
		case 2: return "SMALL";
		case 3: return "MEDIUM";
		case 4: return "LARGE";
		case 5: return "HUGE";
	}
	return "INVALID";
}

int GetUnarmed2daRow(object oCreature)
{
	// Calculate the class total of all classes you want to count
	// as progressing unarmed damage here.
	int nClassTotal = GetLevelByClass(CLASS_TYPE_MONK, oCreature) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);

	// Calculate row into the 2da table based on class total.
	int MAX_ROWS = GetNum2DARows(sUnarmed2da);
	int n2daRow = nClassTotal;
	if(n2daRow > 0) n2daRow++;
	if(n2daRow > MAX_ROWS) n2daRow = MAX_ROWS;
	
	return n2daRow;
}