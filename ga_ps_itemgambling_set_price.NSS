


void main(int nType) {
	object oPC = ((GetPCSpeaker() == OBJECT_INVALID) ? OBJECT_SELF : GetPCSpeaker());
	SetLocalInt(oPC, "SRLG_PRICE", nType);
}