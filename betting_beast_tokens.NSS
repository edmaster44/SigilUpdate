void main () {

	string sFighter1 = GetLocalString(OBJECT_SELF, "MONSTER1");
	string sFighter2 = GetLocalString(OBJECT_SELF, "MONSTER2");
	string sWinner = GetLocalString(OBJECT_SELF, "POTENTIAL_WINNER");
	
	SetCustomToken(33331, sFighter1);
	SetCustomToken(33332, sFighter2);
	SetCustomToken(33333, sWinner);

}