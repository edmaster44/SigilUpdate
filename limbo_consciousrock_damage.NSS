void main () {

	float hpPercen = IntToFloat(GetCurrentHitPoints(OBJECT_SELF))/IntToFloat(GetMaxHitPoints(OBJECT_SELF));
	SpeakString("Damaged: "+IntToString(FloatToInt(hpPercen*100.0f))+"%");
}