/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void paramsDraw(PApplet appc, GWinData data) { //_CODE_:paramsWindow:242215:
  appc.background(230);
  if (actual != null) {
    //actual.drawTable(appc);
    towerAAngleTF.setText(nf(degrees((float)(actual.aTowerAngle)), 1, 5));
    towerBAngleTF.setText(nf(degrees((float)(actual.bTowerAngle)), 1, 5));
    towerCAngleTF.setText(nf(degrees((float)(actual.cTowerAngle)), 1, 5));
    towerAXLocTF.setText(nf((float)actual.aTowerLocation.x, 1, 5));
    towerBXLocTF.setText(nf((float)actual.bTowerLocation.x, 1, 5));
    towerCXLocTF.setText(nf((float)actual.cTowerLocation.x, 1, 5));
    towerAYLocTF.setText(nf((float)actual.aTowerLocation.y, 1, 5));
    towerBYLocTF.setText(nf((float)actual.bTowerLocation.y, 1, 5));
    towerCYLocTF.setText(nf((float)actual.cTowerLocation.y, 1, 5));
    endstopAOffsetTF.setText(nf((float)actual.aEndstopOffset, 1, 5));
    endstopBOffsetTF.setText(nf((float)actual.bEndstopOffset, 1, 5));
    endstopCOffsetTF.setText(nf((float)actual.cEndstopOffset, 1, 5));
    deltaRadiusTF.setText(nf((float)actual.deltaRadius, 1, 5));
    rodLengthTF.setText(nf((float)actual.rodLength, 1, 5));
    zMultiplierTF.setText(nf((float)zMultiplier, 1, 5));
    effectorXLocTF.setText(nf((float)actual.effectorLocation.x, 1, 5));
    effectorYLocTF.setText(nf((float)actual.effectorLocation.y, 1, 5));
    effectorZLocTF.setText(nf((float)actual.effectorLocation.z, 1, 5));
    motorALocTF.setText(nf((float)actual.motorsLocation.x, 1, 5));
    motorBLocTF.setText(nf((float)actual.motorsLocation.y, 1, 5));
    motorCLocTF.setText(nf((float)actual.motorsLocation.z, 1, 5));
    bedNormalATF.setText(nf((float)actual.bedNormal.a, 1, 5));
    bedNormalBTF.setText(nf((float)actual.bedNormal.b, 1, 5));
    bedNormalCTF.setText(nf((float)actual.bedNormal.c, 1, 5));
    bedNormalDTF.setText(nf((float)actual.bedNormal.d, 1, 5));
    errorXAvgValue.setText(nf((float)errorXAvg, 1, 5));
    errorXStdDevValue.setText(nf((float)errorXStdDev, 1, 5));
    errorYAvgValue.setText(nf((float)errorYAvg, 1, 5));
    errorYStdDevValue.setText(nf((float)errorYStdDev, 1, 5));
    errorZAvgValue.setText(nf((float)errorZAvg, 1, 5));
    errorZStdDevValue.setText(nf((float)errorZStdDev, 1, 5));
    errorHeightAvgValue.setText(nf((float)errorHeightAvg, 1, 5));
    errorHeightStdDevValue.setText(nf((float)errorHeightStdDev, 1, 5));
  }
} //_CODE_:paramsWindow:242215:

public void towerAAngleChange(GTextField source, GEvent event) { //_CODE_:towerAAngleTF:786243:
  println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerAAngleTF:786243:

public void towerBAngleChange(GTextField source, GEvent event) { //_CODE_:towerBAngleTF:690083:
  println("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerBAngleTF:690083:

public void towerCAngleChange(GTextField source, GEvent event) { //_CODE_:towerCAngleTF:359870:
  println("towerCAngleTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerCAngleTF:359870:

public void towerAXChange(GTextField source, GEvent event) { //_CODE_:towerAXLocTF:382969:
  println("towerAXLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerAXLocTF:382969:

public void towerBXChange(GTextField source, GEvent event) { //_CODE_:towerBXLocTF:405380:
  println("towerBXLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerBXLocTF:405380:

public void towerCXChange(GTextField source, GEvent event) { //_CODE_:towerCXLocTF:437487:
  println("towerCXLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerCXLocTF:437487:

public void towerAYChange(GTextField source, GEvent event) { //_CODE_:towerAYLocTF:826314:
  println("towerAYLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerAYLocTF:826314:

public void endstopAOffsetChange(GTextField source, GEvent event) { //_CODE_:endstopAOffsetTF:961895:
  println("endstopAOffsetTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:endstopAOffsetTF:961895:

public void towerBYChange(GTextField source, GEvent event) { //_CODE_:towerBYLocTF:393053:
  println("towerBYLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerBYLocTF:393053:

public void towerCYChange(GTextField source, GEvent event) { //_CODE_:towerCYLocTF:795440:
  println("towerCYLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:towerCYLocTF:795440:

public void endstopBOffsetChange(GTextField source, GEvent event) { //_CODE_:endstopBOffsetTF:850744:
  println("endstopBOffsetTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:endstopBOffsetTF:850744:

public void endstopCOffsetChange(GTextField source, GEvent event) { //_CODE_:endstopCOffsetTF:747498:
  println("endstopCOffsetTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:endstopCOffsetTF:747498:

public void deltaRadiusChange(GTextField source, GEvent event) { //_CODE_:deltaRadiusTF:826666:
  println("deltaRadiusTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:deltaRadiusTF:826666:

public void rodLengthChange(GTextField source, GEvent event) { //_CODE_:rodLengthTF:224830:
  println("rodLengthTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:rodLengthTF:224830:

public void effectorXLocChange(GTextField source, GEvent event) { //_CODE_:effectorXLocTF:270032:
  println("effectorXLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:effectorXLocTF:270032:

public void effectorYLocChange(GTextField source, GEvent event) { //_CODE_:effectorYLocTF:753476:
  println("effectorYLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:effectorYLocTF:753476:

public void effectorZLocChange(GTextField source, GEvent event) { //_CODE_:effectorZLocTF:213537:
  println("effectorZLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:effectorZLocTF:213537:

public void motorALocChange(GTextField source, GEvent event) { //_CODE_:motorALocTF:670097:
  println("motorALocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:motorALocTF:670097:

public void motorBLocChange(GTextField source, GEvent event) { //_CODE_:motorBLocTF:552842:
  println("motorBLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:motorBLocTF:552842:

public void motorCLocChange(GTextField source, GEvent event) { //_CODE_:motorCLocTF:835764:
  println("motorCLocTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:motorCLocTF:835764:

public void bedNormalAChange(GTextField source, GEvent event) { //_CODE_:bedNormalATF:662813:
  println("bedNormalATF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:bedNormalATF:662813:

public void bedNormalBChange(GTextField source, GEvent event) { //_CODE_:bedNormalBTF:994634:
  println("bedNormalBTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:bedNormalBTF:994634:

public void bedNormalCChange(GTextField source, GEvent event) { //_CODE_:bedNormalCTF:292917:
  println("bedNormalCTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:bedNormalCTF:292917:

public void bedNormalDChange(GTextField source, GEvent event) { //_CODE_:bedNormalDTF:274861:
  println("bedNormalDTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:bedNormalDTF:274861:

public void zMultiplierChange(GTextField source, GEvent event) { //_CODE_:zMultiplierTF:580213:
  println("zMultiplierTF - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:zMultiplierTF:580213:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Delta Simulation");
  paramsWindow = GWindow.getWindow(this, "Parameters", 620, 20, 600, 460, P2D);
  paramsWindow.addDrawHandler(this, "paramsDraw");
  towerALabel = new GLabel(paramsWindow, 20, 45, 80, 20);
  towerALabel.setText("Tower A:");
  towerALabel.setTextBold();
  towerALabel.setOpaque(false);
  towerBLabel = new GLabel(paramsWindow, 20, 75, 80, 20);
  towerBLabel.setText("Tower B:");
  towerBLabel.setTextBold();
  towerBLabel.setOpaque(false);
  towerCLabel = new GLabel(paramsWindow, 20, 105, 80, 20);
  towerCLabel.setText("Tower C:");
  towerCLabel.setTextBold();
  towerCLabel.setOpaque(false);
  towerAngleLabel = new GLabel(paramsWindow, 100, 20, 120, 20);
  towerAngleLabel.setText("Angle (degrees)");
  towerAngleLabel.setTextBold();
  towerAngleLabel.setOpaque(false);
  towerAAngleTF = new GTextField(paramsWindow, 100, 40, 120, 30, G4P.SCROLLBARS_NONE);
  towerAAngleTF.setOpaque(true);
  towerAAngleTF.addEventHandler(this, "towerAAngleChange");
  towerBAngleTF = new GTextField(paramsWindow, 100, 70, 120, 30, G4P.SCROLLBARS_NONE);
  towerBAngleTF.setOpaque(true);
  towerBAngleTF.addEventHandler(this, "towerBAngleChange");
  towerCAngleTF = new GTextField(paramsWindow, 100, 100, 120, 30, G4P.SCROLLBARS_NONE);
  towerCAngleTF.setOpaque(true);
  towerCAngleTF.addEventHandler(this, "towerCAngleChange");
  towerXLabel = new GLabel(paramsWindow, 220, 20, 120, 20);
  towerXLabel.setText("X (mm)");
  towerXLabel.setTextBold();
  towerXLabel.setOpaque(false);
  towerYLabel = new GLabel(paramsWindow, 360, 20, 80, 20);
  towerYLabel.setText("Y (mm)");
  towerYLabel.setTextBold();
  towerYLabel.setOpaque(false);
  towerAXLocTF = new GTextField(paramsWindow, 220, 40, 120, 30, G4P.SCROLLBARS_NONE);
  towerAXLocTF.setOpaque(true);
  towerAXLocTF.addEventHandler(this, "towerAXChange");
  towerBXLocTF = new GTextField(paramsWindow, 220, 70, 120, 30, G4P.SCROLLBARS_NONE);
  towerBXLocTF.setOpaque(true);
  towerBXLocTF.addEventHandler(this, "towerBXChange");
  towerCXLocTF = new GTextField(paramsWindow, 220, 100, 120, 30, G4P.SCROLLBARS_NONE);
  towerCXLocTF.setOpaque(true);
  towerCXLocTF.addEventHandler(this, "towerCXChange");
  EndstopOffsetLabel = new GLabel(paramsWindow, 450, 19, 140, 20);
  EndstopOffsetLabel.setText("Endstop Offset (mm)");
  EndstopOffsetLabel.setTextBold();
  EndstopOffsetLabel.setOpaque(false);
  towerAYLocTF = new GTextField(paramsWindow, 340, 40, 120, 30, G4P.SCROLLBARS_NONE);
  towerAYLocTF.setOpaque(true);
  towerAYLocTF.addEventHandler(this, "towerAYChange");
  endstopAOffsetTF = new GTextField(paramsWindow, 460, 40, 120, 30, G4P.SCROLLBARS_NONE);
  endstopAOffsetTF.setOpaque(true);
  endstopAOffsetTF.addEventHandler(this, "endstopAOffsetChange");
  towerBYLocTF = new GTextField(paramsWindow, 340, 70, 120, 30, G4P.SCROLLBARS_NONE);
  towerBYLocTF.setOpaque(true);
  towerBYLocTF.addEventHandler(this, "towerBYChange");
  towerCYLocTF = new GTextField(paramsWindow, 340, 100, 120, 30, G4P.SCROLLBARS_NONE);
  towerCYLocTF.setOpaque(true);
  towerCYLocTF.addEventHandler(this, "towerCYChange");
  endstopBOffsetTF = new GTextField(paramsWindow, 460, 70, 120, 30, G4P.SCROLLBARS_NONE);
  endstopBOffsetTF.setOpaque(true);
  endstopBOffsetTF.addEventHandler(this, "endstopBOffsetChange");
  endstopCOffsetTF = new GTextField(paramsWindow, 460, 100, 120, 30, G4P.SCROLLBARS_NONE);
  endstopCOffsetTF.setOpaque(true);
  endstopCOffsetTF.addEventHandler(this, "endstopCOffsetChange");
  deltaRadiusLabel = new GLabel(paramsWindow, 10, 145, 90, 20);
  deltaRadiusLabel.setText("Delta Radius:");
  deltaRadiusLabel.setTextBold();
  deltaRadiusLabel.setOpaque(false);
  deltaRadiusTF = new GTextField(paramsWindow, 100, 140, 120, 30, G4P.SCROLLBARS_NONE);
  deltaRadiusTF.setOpaque(true);
  deltaRadiusTF.addEventHandler(this, "deltaRadiusChange");
  rodLengthLabel = new GLabel(paramsWindow, 20, 175, 80, 20);
  rodLengthLabel.setText("Rod Length:");
  rodLengthLabel.setTextBold();
  rodLengthLabel.setOpaque(false);
  rodLengthTF = new GTextField(paramsWindow, 100, 170, 120, 30, G4P.SCROLLBARS_NONE);
  rodLengthTF.setOpaque(true);
  rodLengthTF.addEventHandler(this, "rodLengthChange");
  locationXLabel = new GLabel(paramsWindow, 100, 210, 120, 20);
  locationXLabel.setText("X (mm)");
  locationXLabel.setTextBold();
  locationXLabel.setOpaque(false);
  locationYLabel = new GLabel(paramsWindow, 220, 210, 120, 20);
  locationYLabel.setText("Y (mm)");
  locationYLabel.setTextBold();
  locationYLabel.setOpaque(false);
  locationZLabel = new GLabel(paramsWindow, 340, 210, 120, 20);
  locationZLabel.setText("Z (mm)");
  locationZLabel.setTextBold();
  locationZLabel.setOpaque(false);
  locationLabel = new GLabel(paramsWindow, 20, 210, 80, 20);
  locationLabel.setText("Location");
  locationLabel.setTextBold();
  locationLabel.setOpaque(false);
  effectorLocationLabel = new GLabel(paramsWindow, 20, 235, 80, 20);
  effectorLocationLabel.setText("Effector:");
  effectorLocationLabel.setTextBold();
  effectorLocationLabel.setOpaque(false);
  effectorXLocTF = new GTextField(paramsWindow, 100, 230, 120, 30, G4P.SCROLLBARS_NONE);
  effectorXLocTF.setOpaque(true);
  effectorXLocTF.addEventHandler(this, "effectorXLocChange");
  effectorYLocTF = new GTextField(paramsWindow, 220, 230, 120, 30, G4P.SCROLLBARS_NONE);
  effectorYLocTF.setOpaque(true);
  effectorYLocTF.addEventHandler(this, "effectorYLocChange");
  effectorZLocTF = new GTextField(paramsWindow, 340, 230, 120, 30, G4P.SCROLLBARS_NONE);
  effectorZLocTF.setOpaque(true);
  effectorZLocTF.addEventHandler(this, "effectorZLocChange");
  motorLocationLabel = new GLabel(paramsWindow, 20, 265, 80, 20);
  motorLocationLabel.setText("Motors:");
  motorLocationLabel.setTextBold();
  motorLocationLabel.setOpaque(false);
  motorALocTF = new GTextField(paramsWindow, 100, 260, 120, 30, G4P.SCROLLBARS_NONE);
  motorALocTF.setOpaque(true);
  motorALocTF.addEventHandler(this, "motorALocChange");
  motorBLocTF = new GTextField(paramsWindow, 220, 260, 120, 30, G4P.SCROLLBARS_NONE);
  motorBLocTF.setOpaque(true);
  motorBLocTF.addEventHandler(this, "motorBLocChange");
  motorCLocTF = new GTextField(paramsWindow, 340, 260, 120, 30, G4P.SCROLLBARS_NONE);
  motorCLocTF.setOpaque(true);
  motorCLocTF.addEventHandler(this, "motorCLocChange");
  bedNormalLabel = new GLabel(paramsWindow, 20, 325, 80, 20);
  bedNormalLabel.setText("Bed Normal");
  bedNormalLabel.setTextBold();
  bedNormalLabel.setOpaque(false);
  aValueLabel = new GLabel(paramsWindow, 100, 300, 120, 20);
  aValueLabel.setText("A");
  aValueLabel.setTextBold();
  aValueLabel.setOpaque(false);
  bValueLabel = new GLabel(paramsWindow, 220, 300, 120, 20);
  bValueLabel.setText("B");
  bValueLabel.setTextBold();
  bValueLabel.setOpaque(false);
  cValueLabel = new GLabel(paramsWindow, 340, 300, 120, 20);
  cValueLabel.setText("C");
  cValueLabel.setTextBold();
  cValueLabel.setOpaque(false);
  dValueLabel = new GLabel(paramsWindow, 460, 300, 120, 20);
  dValueLabel.setText("D");
  dValueLabel.setTextBold();
  dValueLabel.setOpaque(false);
  bedNormalATF = new GTextField(paramsWindow, 100, 320, 120, 30, G4P.SCROLLBARS_NONE);
  bedNormalATF.setOpaque(true);
  bedNormalATF.addEventHandler(this, "bedNormalAChange");
  bedNormalBTF = new GTextField(paramsWindow, 220, 320, 120, 30, G4P.SCROLLBARS_NONE);
  bedNormalBTF.setOpaque(true);
  bedNormalBTF.addEventHandler(this, "bedNormalBChange");
  bedNormalCTF = new GTextField(paramsWindow, 340, 320, 120, 30, G4P.SCROLLBARS_NONE);
  bedNormalCTF.setOpaque(true);
  bedNormalCTF.addEventHandler(this, "bedNormalCChange");
  bedNormalDTF = new GTextField(paramsWindow, 460, 320, 120, 30, G4P.SCROLLBARS_NONE);
  bedNormalDTF.setOpaque(true);
  bedNormalDTF.addEventHandler(this, "bedNormalDChange");
  zMultLabel = new GLabel(paramsWindow, 260, 145, 80, 20);
  zMultLabel.setText("Z Multiplier:");
  zMultLabel.setTextBold();
  zMultLabel.setOpaque(false);
  zMultiplierTF = new GTextField(paramsWindow, 340, 140, 120, 30, G4P.SCROLLBARS_NONE);
  zMultiplierTF.setOpaque(true);
  zMultiplierTF.addEventHandler(this, "zMultiplierChange");
  errorAvgLabel = new GLabel(paramsWindow, 40, 390, 80, 20);
  errorAvgLabel.setText("Average:");
  errorAvgLabel.setTextBold();
  errorAvgLabel.setOpaque(false);
  errorsLabel = new GLabel(paramsWindow, 40, 370, 80, 20);
  errorsLabel.setText("Errors");
  errorsLabel.setTextBold();
  errorsLabel.setOpaque(false);
  errorStdDevLabel = new GLabel(paramsWindow, 20, 410, 100, 20);
  errorStdDevLabel.setText("Standard Dev:");
  errorStdDevLabel.setTextBold();
  errorStdDevLabel.setOpaque(false);
  errorHeightAvgValue = new GLabel(paramsWindow, 360, 390, 80, 20);
  errorHeightAvgValue.setText("0.0");
  errorHeightAvgValue.setOpaque(false);
  errorXLabel = new GLabel(paramsWindow, 120, 370, 80, 20);
  errorXLabel.setText("X");
  errorXLabel.setTextBold();
  errorXLabel.setOpaque(false);
  errorYLabel = new GLabel(paramsWindow, 200, 370, 80, 20);
  errorYLabel.setText("Y");
  errorYLabel.setTextBold();
  errorYLabel.setOpaque(false);
  errorZLabel = new GLabel(paramsWindow, 280, 370, 80, 20);
  errorZLabel.setText("Z");
  errorZLabel.setTextBold();
  errorZLabel.setOpaque(false);
  errorHeightLabel = new GLabel(paramsWindow, 360, 370, 80, 20);
  errorHeightLabel.setText("Height");
  errorHeightLabel.setTextBold();
  errorHeightLabel.setOpaque(false);
  errorYAvgValue = new GLabel(paramsWindow, 200, 390, 80, 20);
  errorYAvgValue.setText("0.0");
  errorYAvgValue.setOpaque(false);
  errorXAvgValue = new GLabel(paramsWindow, 120, 390, 80, 20);
  errorXAvgValue.setText("0.0");
  errorXAvgValue.setOpaque(false);
  errorZAvgValue = new GLabel(paramsWindow, 280, 390, 80, 20);
  errorZAvgValue.setText("0.0");
  errorZAvgValue.setOpaque(false);
  errorXStdDevValue = new GLabel(paramsWindow, 120, 410, 80, 20);
  errorXStdDevValue.setText("0.0");
  errorXStdDevValue.setOpaque(false);
  errorYStdDevValue = new GLabel(paramsWindow, 200, 410, 80, 20);
  errorYStdDevValue.setText("0.0");
  errorYStdDevValue.setOpaque(false);
  errorZStdDevValue = new GLabel(paramsWindow, 280, 410, 80, 20);
  errorZStdDevValue.setText("0.0");
  errorZStdDevValue.setOpaque(false);
  errorHeightStdDevValue = new GLabel(paramsWindow, 360, 410, 80, 20);
  errorHeightStdDevValue.setText("0.0");
  errorHeightStdDevValue.setOpaque(false);
}

// Variable declarations 
// autogenerated do not edit
GWindow paramsWindow;
GLabel towerALabel; 
GLabel towerBLabel; 
GLabel towerCLabel; 
GLabel towerAngleLabel; 
GTextField towerAAngleTF; 
GTextField towerBAngleTF; 
GTextField towerCAngleTF; 
GLabel towerXLabel; 
GLabel towerYLabel; 
GTextField towerAXLocTF; 
GTextField towerBXLocTF; 
GTextField towerCXLocTF; 
GLabel EndstopOffsetLabel; 
GTextField towerAYLocTF; 
GTextField endstopAOffsetTF; 
GTextField towerBYLocTF; 
GTextField towerCYLocTF; 
GTextField endstopBOffsetTF; 
GTextField endstopCOffsetTF; 
GLabel deltaRadiusLabel; 
GTextField deltaRadiusTF; 
GLabel rodLengthLabel; 
GTextField rodLengthTF; 
GLabel locationXLabel; 
GLabel locationYLabel; 
GLabel locationZLabel; 
GLabel locationLabel; 
GLabel effectorLocationLabel; 
GTextField effectorXLocTF; 
GTextField effectorYLocTF; 
GTextField effectorZLocTF; 
GLabel motorLocationLabel; 
GTextField motorALocTF; 
GTextField motorBLocTF; 
GTextField motorCLocTF; 
GLabel bedNormalLabel; 
GLabel aValueLabel; 
GLabel bValueLabel; 
GLabel cValueLabel; 
GLabel dValueLabel; 
GTextField bedNormalATF; 
GTextField bedNormalBTF; 
GTextField bedNormalCTF; 
GTextField bedNormalDTF; 
GLabel zMultLabel; 
GTextField zMultiplierTF; 
GLabel errorAvgLabel; 
GLabel errorsLabel; 
GLabel errorStdDevLabel; 
GLabel errorHeightAvgValue; 
GLabel errorXLabel; 
GLabel errorYLabel; 
GLabel errorZLabel; 
GLabel errorHeightLabel; 
GLabel errorYAvgValue; 
GLabel errorXAvgValue; 
GLabel errorZAvgValue; 
GLabel errorXStdDevValue; 
GLabel errorYStdDevValue; 
GLabel errorZStdDevValue; 
GLabel errorHeightStdDevValue; 