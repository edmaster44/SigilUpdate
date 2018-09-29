void main(string sINPUT, string sOUTPUT = "", int nINPUT = 1, int nOUTPUT = 1)
{
	object oPC = GetPCSpeaker();
	object oINPUT = GetItemPossessedBy(oPC, sINPUT);
	if (oINPUT == OBJECT_INVALID) return;
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