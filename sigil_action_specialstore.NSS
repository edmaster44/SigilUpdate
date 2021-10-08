void main(string sINPUT, string sOUTPUT, int nINPUT, int nOUTPUT)
{

	object oPC = GetPCSpeaker();
	object oINPUT = GetItemPossessedBy(oPC, sINPUT);
	if (oINPUT == OBJECT_INVALID) return;

	if(nINPUT < 0) 	nINPUT = 1;
	if(nOUTPUT < 0) nOUTPUT = 1;

	int nUSED = nINPUT;
	int nSTACK = GetItemStackSize(oINPUT);
	if (nSTACK > nINPUT) SetItemStackSize(oINPUT, nSTACK - nINPUT);
	else
	{
		nUSED = nSTACK;
		DestroyObject(oINPUT);
	}
	if (sOUTPUT == "") GiveGoldToCreature(oPC, nUSED * nOUTPUT);
	else CreateItemOnObject(sOUTPUT, oPC, nOUTPUT);
}