/*
Like seriously this is pain in ass...
I will be just using StackOverflow's HSL to RGB solution from there (http://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion)
FYI I have no idea about what I am doing ¯\_(ツ)_/¯
This stuff follows some math formulas, but nobody cares. I dont even know why you are reading this...

Best regards,
King Leoric.
*/

int gRed;
int gGreen;
int gBlue;

struct strTint
{
	int iRed;
	int iGreen;
	int iBlue;
	int iAlpha;
};

float XPCraft_QqhToRgb(float q1, float q2, float Hue)//Hue = T
{
	if(Hue > 360.0) 		Hue -= 360.0;
	else if(Hue < 0.0) 		Hue += 360.0;
	
	if(Hue <  60.0) 		return (q1 + ((q2 - q1) * (Hue/60.0)));
	else if(Hue < 180.0) 	return (q2);
	else if(Hue < 240.0)	return (q1 + ((q2 - q1) * ((240-Hue)/60.0)));
	else 					return (q1);
}

struct strTint XPCraft_HLSToTintStruct(int iHue, int iLum, int iSat)
{
	struct strTint strMyTint;
	
	float T = IntToFloat(iHue);
	float L = iLum / 100.0;
	float fS = iSat / 100.0;
	
	float fR;
	float fG;
	float fB;
	float q1;
	float q2;
	
	if(L <= 0.5) q2 = L * (1.0 + fS);
	else 		 q2 = L + fS - (L * fS);
	
	q1 = (2 * L) - q2;
	
	if(fS == 0.0)
	{
		fR = L;
		fG = L;
		fB = L;
	}
	else
	{
		fR = XPCraft_QqhToRgb(q1,q2,T+120.0);
		fG = XPCraft_QqhToRgb(q1,q2,T);
		fB = XPCraft_QqhToRgb(q1,q2,T-120.0);
	}

	strMyTint.iRed = FloatToInt(fR*255.0);
	strMyTint.iGreen = FloatToInt(fG*255.0);
	strMyTint.iBlue = FloatToInt(fB*255.0);
	strMyTint.iAlpha = 255;
	
	gRed = strMyTint.iRed;
	gGreen = strMyTint.iGreen;
	gBlue = strMyTint.iBlue;

	return strMyTint;
}

string RGB2HEX(int r, int g, int b)
{
	string sR = IntToHexString(r);
	string sG = IntToHexString(g);
	string sB = IntToHexString(b);
	
	string sSub1 = GetSubString(sR, 8, 2);
	string sSub2 = GetSubString(sG, 8, 2);
	string sSub3 = GetSubString(sB, 8, 2);
	
	string sHex = "0x"+sSub1+sSub2+sSub3;
	return sHex;
}

void main(int Hue, int Saturation, int Lightness, int nFieldID)
{
	 XPCraft_HLSToTintStruct(Hue, Lightness, Saturation);
	 SendMessageToPC(OBJECT_SELF, "HSL:\n"+IntToString(Hue)+"\n"+IntToString(Saturation)+"\n"+IntToString(Lightness));
	 SendMessageToPC(OBJECT_SELF, "RGB:\n"+IntToString(gRed)+"\n"+IntToString(gGreen)+"\n"+IntToString(gBlue));
	 SendMessageToPC(OBJECT_SELF, RGB2HEX(gRed, gGreen, gBlue));
	 string sHex = RGB2HEX(gRed, gGreen, gBlue);
	 string sTextFieldName;
	 switch (nFieldID)
	 {
	 	case 7:
			sTextFieldName = "HairAccessoryColorTextField";
		break;
		case 8:
			sTextFieldName = "HairColorTextField";
		break;
		case 9:
			sTextFieldName = "HairHighlightColorTextField";
		break;
		case 10:
			sTextFieldName = "SkinColorTextField";
		break;
		case 11:
			sTextFieldName = "EyeColorTextField";
		break;
		case 12:
			sTextFieldName = "EyeBrowColorTextField";
		break;
	 }
	 
	 SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", sTextFieldName, -1, sHex);
}