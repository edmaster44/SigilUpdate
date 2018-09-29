void main (string sMessage, string sOk, string sCancel) {

	object oPC = GetPCSpeaker();
	object oSlave = OBJECT_SELF;
	
	int nMessageStrRef 		= 181743;
	string sOkCB			= sOk;
	string sCancelCB		= sCancel;
	int bShowCancel			= FALSE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "Ok";
	int nCancelStrRef		= 181745;
	string sCancelString	= "Cancel";
	string sDefaultString 	= "";
	string sVariableString	= "";
	
	object oObj = GetOwnedCharacter(oPC);
	SetLocalObject(oObj, "SLAVE", oSlave);

	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}