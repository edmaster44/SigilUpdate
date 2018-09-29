void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int xp = GetXP(oPC);
	int nextlvl = 1000;
	int totalxp = 1;
	
	while (1) {
	   totalxp = totalxp + nextlvl;
	   if (totalxp >= xp) {
	       xp = totalxp - nextlvl;
		   if (xp < 0) xp = 0; 
		   SetXP(oPC, xp);
		   return;
	   }
	   nextlvl = nextlvl + 1000;
	}
}