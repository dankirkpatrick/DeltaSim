import g4p_controls.*; //<>// //<>// //<>//

DeltaConfig theoretical;
DeltaConfig actual;

DanKirkpatrickDeltaTransform dkTheoreticalTransform;
DanKirkpatrickDeltaTransform dkActualTransform;

DavidCrockerCalibration davidCrockerCalibration;
DavidCrockerDeltaTransform dcTheoreticalTransform;
DavidCrockerDeltaTransform dcActualTransform;

Location testEffectorLocation  = null;
float zMultiplier;

GCode gcode;

int selectedTower = 0;

float xAngle = 0;
float zAngle = 0;

float xBedAngle = 0;
float yBedAngle = 0;

ArrayList<Location> testPoints;          // The (X, Y, Z) effector location for test points
ArrayList<Location> motorTestHeights;    // The (A, B, C) motor locations for test points
ArrayList<Location> effectorErrors;      // The (X, Y, Z) errors for each of the test points
ArrayList<Location> heightErrors;        // The (X, Y) effector location, and (Z) height error

double errorHeightAvg;
double errorHeightVariance;
double errorHeightStdDev;
double errorXAvg;
double errorXVariance;
double errorXStdDev;
double errorYAvg;
double errorYVariance;
double errorYStdDev;
double errorZAvg;
double errorZVariance;
double errorZStdDev;

double sq(double value) {
  return value * value;
}

void createCalibrationPoints(double deltaRadius) {
  testPoints = new ArrayList<Location>();
  motorTestHeights = new ArrayList<Location>();
  effectorErrors = new ArrayList<Location>();
  heightErrors = new ArrayList<Location>();

  testPoints.add(new Location(0, 0, 0));
  motorTestHeights.add(new Location());
  effectorErrors.add(new Location());
  heightErrors.add(new Location());

  for (int angle = 0; angle < 360; angle += 60) {
    testPoints.add(new Location(deltaRadius*0.9*Math.cos(radians(angle)), deltaRadius*Math.sin(radians(angle)), 0));
    motorTestHeights.add(new Location());
    effectorErrors.add(new Location());
    heightErrors.add(new Location());

    testPoints.add(new Location(deltaRadius*0.9*Math.cos(radians(angle))/2.0, deltaRadius*Math.sin(radians(angle))/2.0, 0));
    motorTestHeights.add(new Location());
    effectorErrors.add(new Location());
    heightErrors.add(new Location());
  }

  for (int angle = 30; angle < 360; angle += 60) {
    testPoints.add(new Location(deltaRadius*0.9*Math.cos(radians(angle))/Math.sqrt(2), deltaRadius*Math.sin(radians(angle))/Math.sqrt(2), 0));
    motorTestHeights.add(new Location());
    effectorErrors.add(new Location());
    heightErrors.add(new Location());
  }
}

void createTestPoints() {
  testPoints = new ArrayList<Location>();
  motorTestHeights = new ArrayList<Location>();
  effectorErrors = new ArrayList<Location>();
  heightErrors = new ArrayList<Location>();
  int angle = 360;
  for (int radius = 0; radius < (theoretical.deltaRadius); radius+= 5) {
    for (angle = angle - 360; angle < 360; angle += (radius > 0? (theoretical.deltaRadius + 5 - radius)/3 : 360)) {
      Location l = new Location(radius*Math.sin(radians(angle)), radius*Math.cos(radians(angle)), 0);
      testPoints.add(l);
      motorTestHeights.add(new Location());
      effectorErrors.add(new Location());
      heightErrors.add(new Location());
    }
  }
}

void setup() {
  size(600, 600, P3D);

  //paramsWindow = GWindow.getWindow(this, "Parameters", 620, 20, 400, 600, P2D);
  //paramsWindow.addDrawHandler(this, "paramsDraw");
  createGUI();

  theoretical = new DeltaConfig();
  actual = new DeltaConfig();

  printLocation("Motors: ", theoretical.motorsLocation);
  printLocation("Effector: ", theoretical.effectorLocation);

  actual.effectorLocation.x = theoretical.effectorLocation.x = 0;
  actual.effectorLocation.y = theoretical.effectorLocation.y = 0;
  actual.effectorLocation.z = theoretical.effectorLocation.z = 0;
  zMultiplier = 50;

  theoretical.CalculateMotorHeights(theoretical.effectorLocation, theoretical.motorsLocation);
  theoretical.motorsLocation.x -= theoretical.aEndstopOffset;
  theoretical.motorsLocation.y -= theoretical.bEndstopOffset;
  theoretical.motorsLocation.z -= theoretical.cEndstopOffset;
  actual.motorsLocation.x = theoretical.motorsLocation.x + actual.aEndstopOffset;
  actual.motorsLocation.y = theoretical.motorsLocation.y + actual.bEndstopOffset;
  actual.motorsLocation.z = theoretical.motorsLocation.z + actual.cEndstopOffset;
  actual.CalculateEffectorLocation(actual.motorsLocation, actual.effectorLocation);

  //createCalibrationPoints(theoretical.deltaRadius);
  createTestPoints();
  calculateErrors();
  
  davidCrockerCalibration = new DavidCrockerCalibration();
  
  gcode = new GCode(actual);
  gcode.readFile("/Users/dan/Downloads/lowpolyskulllisa.gcode");
}

void calculateErrors() {
  double x = actual.effectorLocation.x;
  double y = actual.effectorLocation.y;
  double z = actual.effectorLocation.z;

  double sumXErrorX = 0;
  double sumYErrorX = 0;
  double sumZErrorX = 0;
  double sumHeightErrorX = 0;
  double sumXErrorX2 = 0;
  double sumYErrorX2 = 0;
  double sumZErrorX2 = 0;
  double sumHeightErrorX2 = 0;
  for (int i = 0; i < testPoints.size(); i++) {
    Location l = testPoints.get(i);
    Location m = motorTestHeights.get(i);
    theoretical.effectorLocation.x = l.x;
    theoretical.effectorLocation.y = l.y;
    theoretical.effectorLocation.z = 0;

    theoretical.CalculateMotorHeights(theoretical.effectorLocation, theoretical.motorsLocation);
    m.x = theoretical.motorsLocation.x -= theoretical.aEndstopOffset;
    m.y = theoretical.motorsLocation.y -= theoretical.bEndstopOffset;
    m.z = theoretical.motorsLocation.z -= theoretical.cEndstopOffset;

    actual.motorsLocation.x = theoretical.motorsLocation.x + actual.aEndstopOffset;
    actual.motorsLocation.y = theoretical.motorsLocation.y + actual.bEndstopOffset;
    actual.motorsLocation.z = theoretical.motorsLocation.z + actual.cEndstopOffset;
    actual.CalculateEffectorLocation(actual.motorsLocation, actual.effectorLocation);

    Location e = effectorErrors.get(i);
    e.x = theoretical.effectorLocation.x - actual.effectorLocation.x;
    e.y = theoretical.effectorLocation.y - actual.effectorLocation.y;
    e.z = theoretical.effectorLocation.z - actual.effectorLocation.z;

    Location h = heightErrors.get(i);
    h.x = theoretical.effectorLocation.x;
    h.y = theoretical.effectorLocation.y;
    h.z = actual.calculateActualBedHeight(theoretical.effectorLocation.x, theoretical.effectorLocation.y) - actual.effectorLocation.z;
    
    sumXErrorX += (e.x);
    sumYErrorX += (e.y);
    sumZErrorX += (e.z);
    sumHeightErrorX += (h.z);
    sumXErrorX2 += sq(e.x);
    sumYErrorX2 += sq(e.y);
    sumZErrorX2 += sq(e.z);
    sumHeightErrorX2 += sq(h.z);
  }

  errorHeightAvg = sumHeightErrorX / testPoints.size();
  errorHeightVariance = sumHeightErrorX2 / (testPoints.size() - 1);
  errorHeightStdDev = Math.sqrt(errorHeightVariance);
  errorXAvg = sumXErrorX / testPoints.size();
  errorXVariance = sumXErrorX2 / (testPoints.size() - 1);
  errorXStdDev = Math.sqrt(errorXVariance);
  errorYAvg = sumYErrorX / testPoints.size();
  errorYVariance = sumYErrorX2 / (testPoints.size() - 1);
  errorYStdDev = Math.sqrt(errorYVariance);
  errorZAvg = sumZErrorX / testPoints.size();
  errorZVariance = sumZErrorX2 / (testPoints.size() - 1);
  errorZStdDev = Math.sqrt(errorZVariance);
  println("Mean: " + errorHeightAvg);
  println("Variance: " + errorHeightVariance);
  println("StdDev: " + errorHeightStdDev);

  theoretical.effectorLocation.x = actual.effectorLocation.x = x;
  theoretical.effectorLocation.y = actual.effectorLocation.y = y;
  theoretical.effectorLocation.z = actual.effectorLocation.z = z;
  theoretical.CalculateMotorHeights(theoretical.effectorLocation, theoretical.motorsLocation);
  theoretical.motorsLocation.x -= theoretical.aEndstopOffset;
  theoretical.motorsLocation.y -= theoretical.bEndstopOffset;
  theoretical.motorsLocation.z -= theoretical.cEndstopOffset;
  actual.CalculateMotorHeights(actual.effectorLocation, actual.motorsLocation);
  actual.motorsLocation.x -= actual.aEndstopOffset;
  actual.motorsLocation.y -= actual.bEndstopOffset;
  actual.motorsLocation.z -= actual.cEndstopOffset;
}

void draw() {
  background(255);
  actual.drawDelta(heightErrors);
}

void mouseWheel(MouseEvent e) {
  theoretical.effectorLocation.z += e.getCount();
  theoretical.CalculateMotorHeights(theoretical.effectorLocation, theoretical.motorsLocation);
  theoretical.motorsLocation.x -= theoretical.aEndstopOffset;
  theoretical.motorsLocation.y -= theoretical.bEndstopOffset;
  theoretical.motorsLocation.z -= theoretical.cEndstopOffset;
  actual.motorsLocation.x = theoretical.motorsLocation.x + actual.aEndstopOffset;
  actual.motorsLocation.y = theoretical.motorsLocation.y + actual.bEndstopOffset;
  actual.motorsLocation.z = theoretical.motorsLocation.z + actual.cEndstopOffset;
  actual.CalculateEffectorLocation(actual.motorsLocation, actual.effectorLocation);
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    zAngle += (pmouseX - mouseX) / 150.0;
    xAngle += (pmouseY - mouseY) / 150.0;
  }

  if (mouseButton == RIGHT) {
    theoretical.effectorLocation.x += (mouseX - pmouseX);
    theoretical.effectorLocation.y += (mouseY - pmouseY);
    theoretical.CalculateMotorHeights(theoretical.effectorLocation, theoretical.motorsLocation);
    theoretical.motorsLocation.x -= theoretical.aEndstopOffset;
    theoretical.motorsLocation.y -= theoretical.bEndstopOffset;
    theoretical.motorsLocation.z -= theoretical.cEndstopOffset;

    actual.motorsLocation.x = theoretical.motorsLocation.x + actual.aEndstopOffset;
    actual.motorsLocation.y = theoretical.motorsLocation.y + actual.bEndstopOffset;
    actual.motorsLocation.z = theoretical.motorsLocation.z + actual.cEndstopOffset;
    actual.CalculateEffectorLocation(actual.motorsLocation, actual.effectorLocation);
  }
}

void keyPressed() {
  if (key == '1') {
    selectedTower = 0;
  } else if (key == '2') {
    selectedTower = 1;
  } else if (key == '3') {
    selectedTower = 2;
  } else if (key == '0') {
    selectedTower = -1;
  } else if (key == 'i') {
    xBedAngle += radians(0.1);
    actual.CalculateBedNormal();
    calculateErrors();
  } else if (key == 'j') {
    yBedAngle -= radians(0.1);
    actual.CalculateBedNormal();
    calculateErrors();
  } else if (key == 'k') {
    xBedAngle -= radians(0.1);
    actual.CalculateBedNormal();
    calculateErrors();
  } else if (key == 'l') {
    yBedAngle += radians(0.1);
    actual.CalculateBedNormal();
    calculateErrors();
  } else if (key == 's') {
    switch (selectedTower) {
    case 0:
      actual.aEndstopOffset += 0.01;
      break;
    case 1:
      actual.bEndstopOffset += 0.01;
      break;
    case 2:
      actual.cEndstopOffset += 0.01;
      break;
    }
    calculateErrors();
  } else if (key == 'x') {
    switch (selectedTower) {
    case 0:
      actual.aEndstopOffset -= 0.01;
      break;
    case 1:
      actual.bEndstopOffset -= 0.01;
      break;
    case 2:
      actual.cEndstopOffset -= 0.01;
      break;
    }
    calculateErrors();
  } else if (key == 'd') {
    switch (selectedTower) {
    case 0:
      actual.aTowerAngle += Math.toRadians(0.2);
      break;
    case 1:
      actual.bTowerAngle += Math.toRadians(0.2);
      break;
    case 2:
      actual.cTowerAngle += Math.toRadians(0.2);
      break;
    }
    actual.CalculateFromAngles();
    calculateErrors();
  } else if (key == 'c') {
    switch (selectedTower) {
    case 0:
      actual.aTowerAngle -= Math.toRadians(0.2);
      break;
    case 1:
      actual.bTowerAngle -= Math.toRadians(0.2);
      break;
    case 2:
      actual.cTowerAngle -= Math.toRadians(0.2);
      break;
    }
    actual.CalculateFromAngles();
    calculateErrors();
  } else if (key == 'a') {
    actual.bedNormal.d += 0.025;
    calculateErrors();
  } else if (key == 'z') {
    actual.bedNormal.d -= 0.025;
    calculateErrors();
  } else if (key == 'p') {
    // Do z-probe calibration
    davidCrockerCalibration.doDeltaCalibration(theoretical, 6, testPoints); //<>//
    calculateErrors();
  } else if (key == CODED) {
    Location loc;
    boolean handled = false;
    switch (selectedTower) {
    case 0: 
      loc = actual.aTowerLocation;
      break;
    case 1:
      loc = actual.bTowerLocation;
      break;
    case 2:
      loc = actual.cTowerLocation;
      break;
    default:
      loc = null;
      break;
    }
    if (keyCode == UP) {
      handled = true;
      if (loc != null) {
        loc.y += 0.1;
      } else {
        actual.rodLength += 0.025;
      }
    } else if (keyCode == DOWN) {
      handled = true;
      if (loc != null) {
        loc.y -= 0.1;
      } else {
        actual.rodLength -= 0.025;
      }
    } else if (keyCode == LEFT) {
      handled = true;
      if (loc != null) {
        loc.x -= 0.1;
      } else {
        actual.deltaRadius -= 0.1;
        actual.CalculateFromAngles();
      }
    } else if (keyCode == RIGHT) {
      handled = true;
      if (loc != null) {
        loc.x += 0.1;
      } else {
        actual.deltaRadius += 0.1;
        actual.CalculateFromAngles();
      }
    }
    if (handled) {
      actual.CalculateCenter();
      calculateErrors();
    }
  }
}

class Location {
  double x;
  double y;
  double z;

  Location() {
    this(0, 0, 0);
  }

  Location(double x, double y) {
    this(x, y, 0);
  }

  Location(double x, double y, double z) {
    set(x, y, z);
  }

  void set(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Vector {
  double a;
  double b;
  double c;
  double d;

  Vector() {
    this(0, 0, 0, 0);
  }

  Vector(double a, double b, double c) {
    this(a, b, c, 0);
  }

  Vector(double a, double b, double c, double d) {
    set(a, b, c, d);
  }

  void set(double a, double b, double c) {
    set(a, b, c, 0);
  }

  void set(double a, double b, double c, double d) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
  }
}

class ExtrudePath {
  ArrayList<Location> points;
  boolean isExtruding;
  boolean isRetracting;

  ExtrudePath() {
    this.points = new ArrayList<Location>();
  }

  void addPoint(Location point) {
    this.points.add(point);
  }
}

class GCodeLayer {
  ArrayList<ExtrudePath> extrudePaths;
  ArrayList<PShape> shapes;
  PShape layerShape;
  int currentPath;
  int currentPoint;

  GCodeLayer() {
    this.extrudePaths = new ArrayList<ExtrudePath>();
    this.shapes = new ArrayList<PShape>();
    reset();
  }

  void reset() {
    this.currentPath = 0;
    this.currentPoint = 0;
  }

  void addPath(ExtrudePath path) {
    this.extrudePaths.add(path);
  }

  double getLayerHeight() {
    if (this.extrudePaths.size() == 0) {
      return 0;
    } else {
      return this.extrudePaths.get(this.extrudePaths.size()-1).points.get(0).z;
    }
  }

  boolean nextPoint() {
    this.currentPoint++;
    if (this.extrudePaths.get(this.currentPath).points.size() <= this.currentPoint) {
      this.currentPoint = 0;
      this.currentPath++;
    }
    return !(this.currentPath < this.extrudePaths.size());
  }

  // Builds all the shapes for this layer
  void buildShapes() {
    Location lastPoint = new Location();
    this.shapes.clear();
    for (ExtrudePath p : this.extrudePaths) {
      if (p.isExtruding) {
        PShape shape = createShape();
        shape.beginShape();
        shape.fill(60);
        shape.stroke(60);
        shape.vertex((float)lastPoint.x, (float)lastPoint.y, (float)lastPoint.z);
        for (Location l : p.points) {
          shape.vertex((float)l.x, (float)l.y, (float)l.z);
          lastPoint = l;
        }
        shape.endShape();
        this.shapes.add(shape);
      } else {
        lastPoint = p.points.get(p.points.size()-1);
      }
    }

    this.layerShape = createShape(GROUP);
    for (PShape s : this.shapes) {
      this.layerShape.addChild(s);
    }
  }

  // Draws the current path, up to the current point.
  // Returns the current point in the path.
  Location drawPath(Location lastPoint) {
    ExtrudePath path = this.extrudePaths.get(this.currentPath);
    if (path.isExtruding) {
      stroke(255);
    } else if (path.isRetracting) {
      stroke(50, 200, 50);
    } else { 
      // moving: return immediately with current point without drawing  
      return path.points.get(this.currentPoint);
    }
    beginShape();
    vertex((float)lastPoint.x, (float)lastPoint.y, (float)lastPoint.z);
    for (int i = 0; i < this.currentPoint; i++) {
      Location l = path.points.get(i);
      vertex((float)l.x, (float)l.y, (float)l.z);
    }
    endShape();
    return path.points.get(this.currentPoint);
  }

  // Draws this layer up to the current point in the current path.
  // Returns the last point drawn.
  Location drawLayer(Location lastPoint) {
    if (this.currentPath == 0) {
      lastPoint = drawPath(lastPoint);
    } else {
      int shapeId = 0;
      for (int i = 0; i < this.currentPath; i++) {
        if (this.extrudePaths.get(i).isExtruding) {
          PShape s = this.shapes.get(shapeId++);
          shape(s);
        }
      }
      ExtrudePath path = this.extrudePaths.get(this.currentPath - 1);
      lastPoint = path.points.get(path.points.size() - 1);
      lastPoint = drawPath(lastPoint);
    }
    return lastPoint;
  }

  // Draws all shapes in this layer
  Location drawLayer() {
    shape(this.layerShape);
    /*
    for (PShape s : shapes) {
     shape(s);
     }
     */
    ExtrudePath path = extrudePaths.get(extrudePaths.size()-1);
    return path.points.get(path.points.size()-1);
  }
}

class GCode {
  String filename;
  ArrayList<GCodeLayer> layers;
  DeltaConfig deltaConfig;
  int currentLayer;

  GCode(DeltaConfig deltaConfig) {
    this.filename = null;
    this.layers = new ArrayList<GCodeLayer>();
    this.deltaConfig = deltaConfig;
    reset();
  }

  void reset() { 
    this.currentLayer = 0;
  }

  void drawGCode() {
    //this.currentLayer = this.layers.size();
    colorMode(RGB, 256);
    GCodeLayer cLayer = null;
    if (this.currentLayer < this.layers.size()) {
      cLayer = this.layers.get(this.currentLayer);
      // Tell layer to get next point; returns true if done
      if (cLayer.nextPoint()) {
        this.currentLayer++;
        if (this.currentLayer < this.layers.size()) {
          cLayer = this.layers.get(this.currentLayer);
        } else {
          cLayer = null;
        }
      }
    }
    double currentHeight;
    if (cLayer == null) {
      currentHeight = this.layers.get(this.layers.size()-1).getLayerHeight();
    } else {
      currentHeight = cLayer.getLayerHeight();
    }

    Location lastPoint = deltaConfig.effectorLocation;
    for (int i = 0; i < this.currentLayer; i++) {
      GCodeLayer layer = this.layers.get(i);
      double layerHeight = layer.getLayerHeight();

      stroke((int)(100 * (currentHeight - layerHeight) / currentHeight) + 50);
      fill((int)(100 * (currentHeight - layerHeight) / currentHeight) + 50);
      lastPoint = layer.drawLayer();
      println("drawing layer: " + layer.getLayerHeight());
    }

    if (cLayer != null) {
      stroke(200);
      lastPoint = cLayer.drawLayer(lastPoint);
    }

    deltaConfig.effectorLocation.x = lastPoint.x;
    deltaConfig.effectorLocation.y = lastPoint.y;
    deltaConfig.effectorLocation.z = lastPoint.z;
    deltaConfig.CalculateMotorHeights(deltaConfig.effectorLocation, deltaConfig.motorsLocation);
    fill(256);
    stroke(0);
  }

  void readFile(String filename) {
    this.filename = filename;
    Location lastLocation = new Location();
    this.layers.clear();
    println("Adding layers: 0");
    GCodeLayer currentLayer = new GCodeLayer();
    this.layers.add(currentLayer);

    ExtrudePath currentPath = new ExtrudePath();
    BufferedReader reader = createReader(this.filename);
    String line;
    int extruder = 0;

    do {
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        line = null;
      }

      if (line != null && line.length() > 0 && line.charAt(0) != ';') {
        String[] tokens = line.split(" ");
        if (tokens.length > 1) {
          String token = tokens[0].trim();
          if (token.equals("G28")) {
            Location motor = new Location(this.deltaConfig.aTowerHeight, this.deltaConfig.bTowerHeight, this.deltaConfig.cTowerHeight);
            Location effector = this.deltaConfig.CalculateEffectorLocation(motor, null);

            if (currentPath.isExtruding || currentPath.isRetracting) {
              if (currentPath.points.size() == 0) {
                println("Warning: adding empty path: a");
              }
              currentLayer.addPath(currentPath);
              currentPath = new ExtrudePath();
              if (effector.z != currentLayer.getLayerHeight()) {
                println("adding layer: a");
                currentLayer = new GCodeLayer();
                this.layers.add(currentLayer);
              }
            }

            if (currentPath.points.size() > 0 && currentPath.points.get(currentPath.points.size()-1).z != effector.z) {
              if (currentPath.points.size() == 0) {
                println("Warning: adding empty path: b");
              }
              currentLayer.addPath(currentPath);
              println("adding layer: b");
              currentLayer = new GCodeLayer();
              this.layers.add(currentLayer);
              currentPath = new ExtrudePath();
            }

            currentPath.addPoint(effector);
            lastLocation = effector;
          } else if (token.equals("G1") || token.equals("G0")) {
            Location nextLocation = new Location();
            nextLocation.x = lastLocation.x;
            nextLocation.y = lastLocation.y;
            nextLocation.z = lastLocation.z;
            extruder = 0;
            for (int i = 1; i < (tokens.length); i++) {
              token = tokens[i];
              if (token.length() > 0) {
                switch (token.charAt(0)) {
                case ';':
                  i = tokens.length;
                  break;
                case 'X':
                  nextLocation.x = Double.parseDouble(token.substring(1));
                  break;
                case 'Y':
                  nextLocation.y = Double.parseDouble(token.substring(1));
                  break;
                case 'Z':
                  nextLocation.z = Double.parseDouble(token.substring(1));
                  break;
                case 'F':
                  // speed...ignore for now
                  break;
                case 'E':
                  if (token.charAt(1) == '-') {
                    extruder = -1;
                  } else {
                    extruder = 1;
                  }
                  break;
                }
              }
            }

            if (extruder == 0 && (currentPath.isExtruding || currentPath.isRetracting)) {
              if (lastLocation.z != nextLocation.z) {
                currentLayer = new GCodeLayer();
                this.layers.add(currentLayer);
              }
              currentLayer.addPath(currentPath);
              currentPath = new ExtrudePath();
            } else if (extruder == 1 && (!currentPath.isExtruding || currentPath.isRetracting)) {
              if (lastLocation.z != nextLocation.z) {
                currentLayer = new GCodeLayer();
                this.layers.add(currentLayer);
              }
              currentLayer.addPath(currentPath);
              currentPath = new ExtrudePath();
              currentPath.isExtruding = true;
            } else if (extruder == -1 && (currentPath.isExtruding || !currentPath.isRetracting)) {
              if (lastLocation.z != nextLocation.z) {
                currentLayer = new GCodeLayer();
                this.layers.add(currentLayer);
              }
              currentLayer.addPath(currentPath);
              currentPath = new ExtrudePath();
              currentPath.isRetracting = true;
            } else if (nextLocation.z != lastLocation.z && currentPath.points.size() != 0) {
              currentLayer.addPath(currentPath);
              println("adding layer: " + lastLocation.z + ": " + nextLocation.z);
              currentLayer = new GCodeLayer();
              this.layers.add(currentLayer);
              currentPath = new ExtrudePath();
            }
            currentPath.addPoint(nextLocation);
            lastLocation = nextLocation;
          } else {
            // This is not a G1/G2 command
            // ignore for now
          }
        }
      }
    } while (line != null);
    if (currentPath.points.size() == 0) {
      println("Warning: adding empty path: g");
    }
    currentLayer.addPath(currentPath);
    for (GCodeLayer layer : this.layers) {
      layer.buildShapes();
    }
  }
}

class FixedVector {
  double[] data;

  FixedVector(int size) {
    this.data = new double[size];
  }

  void debug(String title) {
    print(title + ":");
    for (int i = 0; i < this.data.length; i++) {
      if (i != 0) {
        print(",");
      }
      print(this.data[i]);
    }
    println();
  }
}

class FixedMatrix {
  double[][] data;

  FixedMatrix(int rows, int columns) {
    this.data = new double[rows][columns];
  }

  void swapRows(int i, int j) {
    double[] rowI = this.data[i];
    this.data[i] = data[j];
    this.data[j] = rowI;
  }

  void gaussJordan(FixedVector solution, int numRows) {
    for (int i = 0; i < numRows; ++i) {
      println("Gauss-Jordan: Finding max diagonal for row " + i);
      double vmax = Math.abs(this.data[i][i]);
      for (int j = i+1; j < this.data.length; ++j) {
        double rmax = Math.abs(this.data[j][i]);
        if (rmax > vmax) {
          swapRows(i, j);
          vmax = rmax;
        }
      }

      println("Normalizing other matrix rows");
      double v = this.data[i][i];
      for (int j = 0; j < i; j++) {
        double factor = this.data[j][i] / v;
        this.data[j][i] = 0;
        for (int k = i+1; k <= numRows; ++k) {
          this.data[j][k] -= this.data[i][k] * factor;
        }
      }

      for (int j = i+1; j < numRows; ++j) {
        double factor = this.data[j][i] / v;
        this.data[j][i] = 0;
        for (int k = i+1; k <= numRows; ++k) {
          this.data[j][k] -= this.data[i][k] * factor;
        }
      }
    }

    for (int i = 0; i < numRows; ++i) {
      solution.data[i] = this.data[i][numRows] / this.data[i][i];
    }
  }

  void debug(String title) {
    println(title);
    for (int i = 0; i < this.data.length; i++) {
      for (int j = 0; j < this.data[i].length; j++) {
        if (j != 0) {
          print(",");
        }
        print(this.data[i][j]);
      }
      println();
    }
  }
}

// Xe = effector X location
// Ye = effector Y location
// Ze = effector Z location
// Xa,Xb,Xc = tower A,B,C X location
// Ya,Yb,Yc = tower A,B,C Y location
// Za,Zb,Zc = motor A,B,C Z location

// Starting with equations for circles:
// (0a): (Xe-Xa)^2 + (Ye-Ya)^2 + (Ze-Za)^2 = RL^2
// (0b): (Xe-Xb)^2 + (Ye-Yb)^2 + (Ze-Zb)^2 = RL^2
// (0c): (Xe-Xc)^2 + (Ye-Yc)^2 + (Ze-Zc)^2 = RL^2
// Intersection of towers A & B:
// (1): Xe = ((Xb^2+Yb^2+Zb^2-Xa^2-Ya^2-Za^2)/(2*(Xb-Xa)) - Ye((Yb-Ya)/(Xb-Xa)) - Ze*((Zb-Za)/(Xb-Xa))
// (2): Xe = K1 - K2*Ye - K3*Ze
// Intersection of towers B & C:
// (3): Xe = ((Xc^2+Yc^2+Zc^2-Xb^2-Yb^2-Zb^2)/(2*(Xc-Xb)) - Ye((Yc-Yb)/(Xc-Xb)) - Ze*((Zc-Zb)/(Xc-Xb))
// (4): Xe = L1 - L2*Ye - L3*Ze
// Intersection of both intersections
// (5): Ye = Ze*(K3-L3)/(L2-K2) + (L1-K1)/(L2-K2)
// (6): Ye = A1*Ze + B1
// Substituting (5) for Ye in (2):
// (7): Xe = Ze*(-K2*A1-K3) + (K1-K2*B1)
// (8): Xe = A2*Ze + B2
// Substituting (8) and (6) into (0a):
// (9): (A1^2+A2^2+1)*Ze^2 + (2*A1*(B1-Yb)+2*A2*(B2-Xb)-2*Zb)*Ze + ((B2-Xb)^2+(B1-Yb)^2)+Zb^2-RL^2) = 0
// (10): A3*Ze^2 + B3*Ze + C3 = 0
// (11): Ze = (-B3 +- sqrt(B3^2 - 4*A3*C3)) / (2*A3)
class DanKirkpatrickDeltaTransform implements DeltaTransform {
  DeltaConfig config;

  void recalc(DeltaConfig config) {
    this.config = config;
  }

  Location transform(Location effector, Location motors) {
    if (motors == null) {
      motors = new Location();
    }
    motors.x = effector.z + Math.sqrt(sq(config.rodLength) - 
      (config.aTowerLocation.x - effector.x)*(config.aTowerLocation.x - effector.x) - 
      (config.aTowerLocation.y - effector.y)*(config.aTowerLocation.y - effector.y));
    motors.y = effector.z + Math.sqrt(sq(config.rodLength) - 
      (config.bTowerLocation.x - effector.x)*(config.bTowerLocation.x - effector.x) - 
      (config.bTowerLocation.y - effector.y)*(config.bTowerLocation.y - effector.y));
    motors.z = effector.z + Math.sqrt(sq(config.rodLength) - 
      (config.cTowerLocation.x - effector.x)*(config.cTowerLocation.x - effector.x) - 
      (config.cTowerLocation.y - effector.y)*(config.cTowerLocation.y - effector.y));
    return motors;
  }

  Location inverseTransform(Location motors, Location effector) {
    if (effector == null) {
      effector = new Location();
    }
    double k1 = (sq(config.bTowerLocation.x)+sq(config.bTowerLocation.y)+sq(motors.y)
      -sq(config.aTowerLocation.x)-sq(config.aTowerLocation.y)-sq(motors.x)) 
      / (2*(config.bTowerLocation.x-config.aTowerLocation.x));
    double k2 = (config.bTowerLocation.y-config.aTowerLocation.y)/(config.bTowerLocation.x-config.aTowerLocation.x);                 
    double k3 = (motors.y-motors.x)/(config.bTowerLocation.x-config.aTowerLocation.x);
    double l1 = (sq(config.cTowerLocation.x)+sq(config.cTowerLocation.y)+sq(motors.z)
      -sq(config.bTowerLocation.x)-sq(config.bTowerLocation.y)-sq(motors.y)) 
      / (2*(config.cTowerLocation.x-config.bTowerLocation.x));
    double l2 = (config.cTowerLocation.y-config.bTowerLocation.y)/(config.cTowerLocation.x-config.bTowerLocation.x);                 
    double l3 = (motors.z-motors.y)/(config.cTowerLocation.x-config.bTowerLocation.x);
    double a1 = (k3 - l3) / (l2 - k2); 
    double b1 = (l1 - k1) / (l2 - k2);
    double a2 = (-k2 * a1 - k3);
    double b2 = (k1 - k2 * b1);
    double a3 = sq(a1) + sq(a2) + 1;
    double b3 = 2*a1*(b1-config.bTowerLocation.y)+2*a2*(b2-config.bTowerLocation.x)-2*motors.y;
    double c3 = sq(b2-config.bTowerLocation.x) + sq(b1-config.bTowerLocation.y) + sq(motors.y) - sq(config.rodLength);
    double z1 = (-b3 + Math.sqrt(sq(b3) - 4*a3*c3)) / (2*a3);
    double x1 = a2 * z1 + b2;
    double y1 = a1 * z1 + b1;
    double z2 = (-b3 - Math.sqrt(sq(b3) - 4*a3*c3)) / (2*a3);
    double x2 = a2 * z2 + b2;
    double y2 = a1 * z2 + b1;

    if (z1 > z2) {
      effector.x = x2;
      effector.y = y2;
      effector.z = z2;
    } else {
      effector.x = x1;
      effector.y = y1;
      effector.z = z1;
    }
    return effector;
  }
}

interface DeltaTransform {
  void recalc(DeltaConfig config);
  Location transform(Location effector, Location motors);
  Location inverseTransform(Location motors, Location effector);
}

class DavidCrockerDeltaTransform implements DeltaTransform {
  DeltaConfig config;
  double xAB;
  double xBC;
  double xCA;
  double yAB;
  double yBC;
  double yCA;
  double coreFa;
  double coreFb;
  double coreFc;
  double q;
  double q2;
  double d2;

  void recalc(DeltaConfig config) {
    this.config = config;

    xAB = config.bTowerLocation.x - config.aTowerLocation.x;
    xBC = config.cTowerLocation.x - config.bTowerLocation.x;
    xCA = config.aTowerLocation.x - config.cTowerLocation.x;
    yAB = config.bTowerLocation.y - config.aTowerLocation.y;
    yBC = config.cTowerLocation.y - config.bTowerLocation.y;
    yCA = config.aTowerLocation.y - config.cTowerLocation.y;
    coreFa = sq(config.aTowerLocation.x) + sq(config.aTowerLocation.y);
    coreFb = sq(config.bTowerLocation.x) + sq(config.bTowerLocation.y);
    coreFc = sq(config.cTowerLocation.x) + sq(config.cTowerLocation.y);
    q = 2 * (xCA * yAB - xAB * yCA);
    q2 = sq(q);
    d2 = sq(config.rodLength);
  }

  // Tranform an effector positon to a motor position
  Location transform(Location effector, Location motors) {
    if (motors == null) {
      motors = new Location();
    }

    motors.x = effector.z + Math.sqrt(this.d2 - sq(effector.x - config.aTowerLocation.x) - sq(effector.y - config.aTowerLocation.y));
    motors.y = effector.z + Math.sqrt(this.d2 - sq(effector.x - config.bTowerLocation.x) - sq(effector.y - config.bTowerLocation.y));
    motors.z = effector.z + Math.sqrt(this.d2 - sq(effector.x - config.cTowerLocation.x) - sq(effector.y - config.cTowerLocation.y));

    return effector;
  }

  // Tranform a motor position to an effecto position
  Location inverseTransform(Location motors, Location effector) {
    if (effector == null) {
      effector = new Location();
    }

    double fA = coreFa + sq(motors.x);
    double fB = coreFb + sq(motors.y);
    double fC = coreFc + sq(motors.z);
    double p = (xBC * fA) + (xCA * fB) + (xAB * fC);
    double s = (yBC * fA) + (yCA * fB) + (yAB * fC);
    double r = 2 * ((xBC * motors.x) + (xCA * motors.y) + (xAB * motors.z));
    double u = 2 * ((yBC * motors.x) + (yCA * motors.y) + (yAB * motors.z));
    double r2 = sq(r);
    double u2 = sq(u);
    double a = u2 + r2 + q2;
    double minusHalfB = s*u + p*r + motors.x*q2 + config.aTowerLocation.x*u*q - config.aTowerLocation.y*r*q;
    double c = sq(s+config.aTowerLocation.x*q) + sq(p-config.aTowerLocation.y*q) + (sq(motors.x) - d2)*q2;

    effector.z = (minusHalfB - Math.sqrt(sq(minusHalfB) - a*c)) / a;
    effector.x = (u*effector.z - s) / q;
    effector.y = (p - r*effector.z) / q;

    return effector;
  }

  /**
   * param: 0: Tower A endstop correction
   *        1: Tower B endstop correction
   *        2: Tower C endstop correction
   *        3: Delta radius correction
   *        4: Tower A angle correction
   *        5: Tower B angle correction
   *        6: Rod Length correction
   * motors: The Z location of the motors
   */
  double computeDerivative(int param, Location motors) {
    double perturb = 0.2;
    double zLo = 0;
    double zHi = 0;
    double original;
    Location effector = new Location();
    switch (param) {
    case 0:
      original = motors.x;
      motors.x = original + perturb;
      inverseTransform(motors, effector);
      zHi = effector.z;
      motors.x = original - perturb;
      inverseTransform(motors, effector);
      zLo = effector.z;
      motors.x = original;
      break;
    case 1:
      original = motors.y;
      motors.y = original + perturb;
      inverseTransform(motors, effector);
      zHi = effector.z;
      motors.y = original - perturb;
      inverseTransform(motors, effector);
      zLo = effector.z;
      motors.y = original;
      break;
    case 2:
      original = motors.z;
      motors.z = original + perturb;
      inverseTransform(motors, effector);
      zHi = effector.z;
      motors.z = original - perturb;
      inverseTransform(motors, effector);
      zLo = effector.z;
      motors.z = original;
      break;
    case 3:
      original = config.deltaRadius;
      config.deltaRadius = original + perturb;
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zHi = effector.z;
      config.deltaRadius = original - perturb;
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zLo = effector.z;
      config.deltaRadius = original;
      config.CalculateFromAngles();
      recalc(config);
      break;
    case 4:
      original = config.aTowerAngle;
      config.aTowerAngle = original + Math.toRadians(perturb);
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zHi = effector.z;
      config.aTowerAngle = original - Math.toRadians(perturb);
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zLo = effector.z;
      config.aTowerAngle = original;
      config.CalculateFromAngles();
      recalc(config);
      break;
    case 5:
      original = config.bTowerAngle;
      config.bTowerAngle = original + Math.toRadians(perturb);
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zHi = effector.z;
      config.bTowerAngle = original - Math.toRadians(perturb);
      config.CalculateFromAngles();
      recalc(config);
      inverseTransform(motors, effector);
      zLo = effector.z;
      config.bTowerAngle = original;
      config.CalculateFromAngles();
      recalc(config);
      break;
    case 6:
      original = config.rodLength;
      config.rodLength = original + perturb;
      //config.CalculateCenter();
      recalc(config);
      inverseTransform(motors, effector);
      zHi = effector.z;
      config.rodLength = original - perturb;
      //config.CalculateCenter();
      recalc(config);
      inverseTransform(motors, effector);
      zLo = effector.z;
      config.rodLength = original;
      //config.CalculateCenter();
      recalc(config);
      break;
    }
    return (zHi - zLo) / (2 * perturb);
  }
}

class DavidCrockerCalibration {
  DeltaConfig config;

  void doDeltaCalibration(DeltaConfig config, int numFactors, ArrayList<Location> samplePoints) {
    int numDeltaFactors = 7;
    int numPoints = samplePoints.size();

    if (numFactors != 3 && numFactors != 4 && numFactors != 6 && numFactors != 7) {
      println("ERROR!!!  only 3, 4, 6, or 7 factors supported for calibration");
      return;
    }

    double corrections[] = new double[numPoints];
    double initialSumOfSquares = 0;
    for (int i = 0; i < numPoints; ++i) {
      corrections[i] = 0;
      initialSumOfSquares += sq(heightErrors.get(i).z);
    }

    int iteration = 0;
    double expectedRmsError;
    FixedMatrix derivativeMatrix = new FixedMatrix(numPoints, numDeltaFactors);
    FixedMatrix normalMatrix = new FixedMatrix(numDeltaFactors, numDeltaFactors+1);
    FixedVector solution = new FixedVector(numDeltaFactors);
    FixedVector residuals = new FixedVector(numPoints);
    FixedVector expectedResiduals = new FixedVector(numPoints);
    do {
      iteration++;
      println("David Crocker Calibration: iteration " + iteration);
      for (int i = 0; i < numPoints; ++i) {
        for (int j = 0; j < numFactors; ++j) {
          derivativeMatrix.data[i][j] = ((DavidCrockerDeltaTransform)config.transform).computeDerivative(j, motorTestHeights.get(i));
        }
      }
      //derivativeMatrix.debug("Derivative Matrix");

      for (int i = 0; i < numFactors; ++i) {
        for (int j = 0; j < numFactors; ++j) {
          double temp = derivativeMatrix.data[0][i] * derivativeMatrix.data[0][j];
          for (int k = 1; k < numPoints; k++) {
            temp += derivativeMatrix.data[k][i] * derivativeMatrix.data[k][j];
          }
          normalMatrix.data[i][j] = temp;
        }
        double temp = derivativeMatrix.data[0][i] * -(heightErrors.get(i).z + corrections[i]);
        for (int k = 1; k < numPoints; ++k) {
          temp += derivativeMatrix.data[k][i] * -(heightErrors.get(k).z + corrections[k]);
        }
        normalMatrix.data[i][numFactors] = temp;
      }
      normalMatrix.debug("Normal matrix:");
      normalMatrix.gaussJordan(solution, numFactors);
      normalMatrix.debug("Solved matrix:");
      solution.debug("Solution");

      for (int i = 0; i < numPoints; ++i) {
        residuals.data[i] = samplePoints.get(i).z;
        for (int j = 0; j < numFactors; j++) {
          residuals.data[i] += solution.data[j] * derivativeMatrix.data[i][j];
        }
      }
      residuals.debug("Actual Residuals");

      // Apply solution to theoretical delta config
      applySolution(config, solution, numFactors);

      double sumOfSquares = 0;
      Location motors = new Location();
      Location effector = new Location();
      for (int i = 0; i < numPoints; i++) {
        Location te = samplePoints.get(i);
        Location tm = motorTestHeights.get(i);
        motors.x = tm.x + solution.data[0];
        motors.y = tm.y + solution.data[1];
        motors.z = tm.z + solution.data[2];
        theoretical.transform.inverseTransform(motors, effector);
        corrections[i] = effector.z;
        expectedResiduals.data[i] = te.z + effector.z;
        sumOfSquares += sq(expectedResiduals.data[i]);
      }

      expectedRmsError = Math.sqrt(sumOfSquares / numPoints);
      expectedResiduals.debug("Expected probe error");

      // Calculate expected probe errors
    } while (iteration < 2);
    
    config.debug("Current printer parameters");
    println("Calibrated " + numFactors + 
            " factors using " + numPoints + 
            " points, deviation before: " + Math.sqrt(initialSumOfSquares/numPoints) + 
            " after:" + expectedRmsError);
  }

  void applySolution(DeltaConfig config, FixedVector solution, int numFactors) {
    for (int i = 0; i < numFactors; i++) {
      switch (i) {
      case 0:
        config.aEndstopOffset += solution.data[0];
        break;
      case 1:
        config.bEndstopOffset += solution.data[1];
        break;
      case 2:
        config.cEndstopOffset += solution.data[2];
        break;
      case 3:
        config.deltaRadius += solution.data[3];
        break;
      case 4:
        config.aTowerAngle += Math.toRadians(solution.data[4]);
        break;
      case 5:
        config.bTowerAngle += Math.toRadians(solution.data[5]);
        break;
      case 6:
        config.rodLength += Math.toRadians(solution.data[6]);
        break;
      }
    }
  }
}

class DeltaConfig {
  // Measured, not calibrated
  double rodLength;

  // Distance from center of delta circle to towers
  double deltaRadius;

  double towerWidth;
  double towerDepth;

  double motorWidth;
  double motorHeight;

  // The horizontal distance between two rods connected to a single tower
  double rodOffset;
  // The horizontal offset of the effector from the centerpoint of rods
  double effectorOffset;
  // The horizontal offset of the towers from the rods
  double motorOffset;

  // Location of endstops
  double aTowerHeight;
  double bTowerHeight;
  double cTowerHeight;

  double aEndstopOffset;
  double bEndstopOffset;
  double cEndstopOffset;

  // Angles
  double aTowerAngle;
  double bTowerAngle;
  double cTowerAngle;

  // Locations of towers
  Location aTowerLocation;
  Location bTowerLocation;
  Location cTowerLocation;

  // Center of circle that intersects the tower locations
  Location centerLocation;

  Location motorsLocation;
  Location effectorLocation;

  // Normal vector of bed
  Vector bedNormal;

  DeltaTransform transform;

  void debug(String title) {
    println("  DELTA CONFIG: " + title);
    println("--------------");
    println("Tower A: angle: " + Math.toDegrees(this.aTowerAngle));
    println("             x: " + this.aTowerLocation.x);
    println("             y: " + this.aTowerLocation.y);
    println("       endstop: " + this.aEndstopOffset);
    println("Tower B: angle: " + Math.toDegrees(this.bTowerAngle));
    println("             x: " + this.bTowerLocation.x);
    println("             y: " + this.bTowerLocation.y);
    println("       endstop: " + this.bEndstopOffset);
    println("Tower C: angle: " + Math.toDegrees(this.cTowerAngle));
    println("             x: " + this.cTowerLocation.x);
    println("             y: " + this.cTowerLocation.y);
    println("       endstop: " + this.cEndstopOffset);
    println("  Delta radius: " + this.deltaRadius);
    println("    Rod length: " + this.rodLength);
  }

  DeltaConfig() {
    this.rodLength = 220;
    this.deltaRadius = 110;
    this.aTowerHeight = 500;
    this.bTowerHeight = 500;
    this.cTowerHeight = 500;
    this.aEndstopOffset = 0;
    this.bEndstopOffset = 0;
    this.cEndstopOffset = 0;
    this.aTowerAngle = radians(240);
    this.bTowerAngle = radians(120);
    this.cTowerAngle = 0;
    this.bedNormal = new Vector(0, 0, 1);

    this.aTowerLocation = new Location();
    this.bTowerLocation = new Location();
    this.cTowerLocation = new Location();
    this.centerLocation = new Location();

    this.motorsLocation = new Location(this.aTowerHeight, this.bTowerHeight, this.cTowerHeight);
    this.effectorLocation = new Location(0, 0, 0);

    this.towerWidth = 20;                     // width of tower
    this.towerDepth = 40;                     // depth of tower
    this.rodOffset = 25;                      // width between rods
    this.motorWidth = 2*this.rodOffset + 10;  // width of motor plate: 10mm wider than width between rods
    this.motorHeight = 10;                    // height of motor plate
    this.motorOffset = 10;                    // depth of motor plate; offset of towers from front of plate
    this.effectorOffset = 25;                 // distance from effector center to rods

    this.transform = new DavidCrockerDeltaTransform();

    CalculateFromAngles();
    CalculateCenter();
    CalculateMotorHeights(this.effectorLocation, this.motorsLocation);
    this.motorsLocation.x -= this.aEndstopOffset;
    this.motorsLocation.y -= this.bEndstopOffset;
    this.motorsLocation.z -= this.cEndstopOffset;
  }

  void drawBed() {
    noFill();
    ellipse(0, 0, (float)this.deltaRadius*2, (float)this.deltaRadius*2);
  }

  void setColorMapProbeColor(double sample) {
    if (Double.isNaN(sample)) {
      fill(0, 255, 0);
    } else if (sample > 0) {
      if (sample > 0.02) {
        if (sample > 0.04) {
          if (sample > 0.08) {
            if (sample > .16) {
              fill(255, 0, 0);
            } else {
              fill(255, 64, 64);
            }
          } else {
            fill(255, 128, 128);
          }
        } else {
          fill(255, 192, 192);
        }
      } else {
        fill(255, 255, 255);
      }
    } else {
      if (sample < -0.02) {
        if (sample < -0.04) {
          if (sample < -0.08) {
            if (sample < -.16) {
              fill(0, 0, 255);
            } else {
              fill(64, 64, 255);
            }
          } else {
            fill(128, 128, 255);
          }
        } else {
          fill(192, 192, 255);
        }
      } else {
        fill(255, 255, 255);
      }
    }
  }

  double getMaxError(ArrayList<Location> heightErrors) {
    double max = Double.MIN_VALUE;
    for (Location l : heightErrors) {
      if (l.z > max) {
        max = l.z;
      }
    }
    return max;
  }

  double getMinError(ArrayList<Location> heightErrors) {
    double min = Double.MAX_VALUE;
    for (Location l : heightErrors) {
      if (l.z < min) {
        min = l.z;
      }
    }
    return min;
  }

  void setHSVProbeColor(double sample, double hueFactor) {
    if (Double.isNaN(sample)) {
      fill(0, 100, 100);
    } else {
      //println("Sample:" + sample + "  HueFactor:" + hueFactor + "Hue: " + ((sample * hueFactor) + 120));
      fill((int)(sample * hueFactor) + 120, 100, 50);
    }
  }

  void drawHSVProbePoints(ArrayList<Location> heightErrors) {
    colorMode(HSB, 360, 100, 100);
    double maxE = getMaxError(heightErrors);
    double minE = getMinError(heightErrors);
    double hueFactor = 120 / Math.max(Math.max(Math.abs(maxE), Math.abs(minE)), 0.1);
    for (Location l : heightErrors) {
      pushMatrix();
      translate(0, 0, (float)(l.z * zMultiplier));
      setHSVProbeColor(l.z, hueFactor);
      ellipse((float)l.x, (float)l.y, 10, 10);
      popMatrix();
    }
    colorMode(RGB);
    stroke(0);
  }

  void drawColorMapProbePoints(ArrayList<Location> heightErrors) {
    colorMode(RGB);
    for (Location l : heightErrors) {
      pushMatrix();
      translate(0, 0, (float)(l.z * zMultiplier));
      setColorMapProbeColor(l.z);
      ellipse((float)l.x, (float)l.y, 5, 5);
      popMatrix();
    }
    stroke(0);
  }

  void drawTower(Location tower, double towerHeight, double towerAngle, boolean selected) {
    pushMatrix();
    if (selected) {
      fill(256, 0, 0);
    } else {
      fill(100);
    }
    translate((float)tower.x, (float)tower.y, 0);
    rotateZ((float)towerAngle);
    translate((float)(this.towerWidth + this.effectorOffset + this.motorOffset), 0, ((float)towerHeight / 2));
    box((float)towerDepth, (float)towerWidth, (float)towerHeight);
    popMatrix();
  }

  void drawMotor(Location towerLocation, double motorZ, double towerAngle) {
    fill(120);
    pushMatrix();
    translate((float)towerLocation.x, (float)towerLocation.y, (float)motorZ);
    rotateZ((float)towerAngle);
    translate((float)(this.motorOffset/2 + this.effectorOffset), 0, 0); 
    box((float)this.motorOffset, (float)this.motorWidth, (float)this.motorHeight);
    translate((float)-(this.motorOffset/2), 0, 0);
    pushMatrix();
    line(-5, 0, 5, 0);
    rotateY(PI/2);
    line(-5, 0, 5, 0);
    rotateZ(PI/2);
    line(-5, 0, 5, 0);
    popMatrix();
    popMatrix();
  }

  void drawEffector() {
    pushMatrix();
    translate((float)this.effectorLocation.x, (float)this.effectorLocation.y, (float)this.effectorLocation.z);
    line(-5, 0, 5, 0);
    line(0, -5, 0, 5);
    noFill();
    ellipse(0, 0, (float)(this.effectorOffset * 2 + this.rodOffset), (float)(this.effectorOffset * 2 + this.rodOffset));
    popMatrix();
  }

  void drawTowerRods(Location tower, double motorZ, double towerAngle) {
    double angle;
    if (tower.x < this.effectorLocation.x) {
      angle = Math.PI + Math.atan(((tower.y - this.effectorLocation.y) / (tower.x - this.effectorLocation.x)));
    } else {
      angle = Math.atan(((tower.y - this.effectorLocation.y) / (tower.x - this.effectorLocation.x)));
    }

    pushMatrix();
    translate((float)this.effectorLocation.x, (float)this.effectorLocation.y, (float)this.effectorLocation.z);
    translate((float)(this.effectorOffset * Math.cos(towerAngle)), 
      (float)(this.effectorOffset * Math.sin(towerAngle)), 0);
    translate((float)(-this.rodOffset * Math.sin(towerAngle)), (float)(this.rodOffset * Math.cos(towerAngle)), 0);          
    rotateZ((float)angle);
    rotateY((float)-Math.asin((motorZ - this.effectorLocation.z) / this.rodLength));
    line(0, 0, (float)this.rodLength, 0);
    popMatrix();

    pushMatrix();
    translate((float)this.effectorLocation.x, (float)this.effectorLocation.y, (float)this.effectorLocation.z);
    translate((float)(this.effectorOffset * Math.cos(towerAngle)), 
      (float)(this.effectorOffset * Math.sin(towerAngle)), 0);
    translate((float)(this.rodOffset * Math.sin(towerAngle)), -(float)(this.rodOffset * Math.cos(towerAngle)), 0);          
    rotateZ((float)angle);
    rotateY((float)-Math.asin((motorZ - this.effectorLocation.z) / this.rodLength));
    //translate(0, (float)-this.rodOffset, 0);
    line(0, 0, (float)this.rodLength, 0);
    popMatrix();
  }

  void drawTable(PApplet app) {
    app.fill(0);
    app.stroke(0);
    app.textSize(18);
    app.text(String.format("Tower A: [%.5f, %.5f]", this.aTowerLocation.x, this.aTowerLocation.y), 25, 100);
    app.text(String.format("Tower A Angle: %.5f", degrees((float)this.aTowerAngle)), 25, 150);
    app.text(String.format("Tower B: [%.5f, %.5f]", this.bTowerLocation.x, this.bTowerLocation.y), 25, 200);
    app.text(String.format("Tower B Angle: %.5f", degrees((float)this.bTowerAngle)), 25, 250);
    app.text(String.format("Tower C: [%.5f, %.5f]", this.cTowerLocation.x, this.cTowerLocation.y), 25, 300);
    app.text(String.format("Tower C Angle: %.5f", degrees((float)this.cTowerAngle)), 25, 350);
    app.text(String.format("Delta Radius: %.5f", this.deltaRadius), 25, 400);
    app.text(String.format("Rod Length: %.5f", this.rodLength), 25, 450);
    app.text(String.format("Effector: [%.5f, %.5f, %.5f]", this.effectorLocation.x, this.effectorLocation.y, this.effectorLocation.z), 25, 500);
    app.text(String.format("Bed Normal: [%.5f, %.5f, %.5f, %.5f]", this.bedNormal.a, this.bedNormal.b, this.bedNormal.c, this.bedNormal.d), 25, 550);
  }

  void drawDelta(ArrayList<Location> heightErrors) {
    pushMatrix();

    translate(width/2, 2*height/3, -50);
    rotateX(xAngle);
    rotateZ(zAngle);

    scale(1, -1, 1);
    drawBed();
    drawHSVProbePoints(heightErrors);
    drawTower(this.aTowerLocation, this.aTowerHeight, this.aTowerAngle, (selectedTower == 0));
    drawTower(this.bTowerLocation, this.bTowerHeight, this.bTowerAngle, (selectedTower == 1));
    drawTower(this.cTowerLocation, this.cTowerHeight, this.cTowerAngle, (selectedTower == 2));
    //gcode.drawGCode();
    drawMotor(this.aTowerLocation, this.motorsLocation.x, this.aTowerAngle);
    drawMotor(this.bTowerLocation, this.motorsLocation.y, this.bTowerAngle);
    drawMotor(this.cTowerLocation, this.motorsLocation.z, this.cTowerAngle);
    drawEffector();
    drawTowerRods(this.aTowerLocation, this.motorsLocation.x, this.aTowerAngle);
    drawTowerRods(this.bTowerLocation, this.motorsLocation.y, this.bTowerAngle);
    drawTowerRods(this.cTowerLocation, this.motorsLocation.z, this.cTowerAngle);

    popMatrix();
  }

  void CalculateFromAngles() {
    this.aTowerLocation.x = this.deltaRadius * Math.cos(this.aTowerAngle);
    this.aTowerLocation.y = this.deltaRadius * Math.sin(this.aTowerAngle);

    this.bTowerLocation.x = this.deltaRadius * Math.cos(this.bTowerAngle);
    this.bTowerLocation.y = this.deltaRadius * Math.sin(this.bTowerAngle);

    this.cTowerLocation.x = this.deltaRadius * Math.cos(this.cTowerAngle);
    this.cTowerLocation.y = this.deltaRadius * Math.sin(this.cTowerAngle);

    this.centerLocation.x = 0;
    this.centerLocation.y = 0;

    this.transform.recalc(this);
    /*
    println("Calculating tower locations:");
    println("Rod Length: " + this.rodLength);
    println("Delta radius: " + this.deltaRadius);
    println("Tower Angle A: " + degrees((float)this.aTowerAngle));
    println("Tower Angle B: " + degrees((float)this.bTowerAngle)); 
    println("Tower Angle C: " + degrees((float)this.cTowerAngle)); 
    println("Tower A: (" + this.aTowerLocation.x + ", " + this.aTowerLocation.y + ")");
    println("Tower B: (" + this.bTowerLocation.x + ", " + this.bTowerLocation.y + ")");
    println("Tower C: (" + this.cTowerLocation.x + ", " + this.cTowerLocation.y + ")");
    */
  }  

  void CalculateCenter() {
    double abMidY = (this.aTowerLocation.y + this.bTowerLocation.y) / 2.0;
    double slopeABp = -(this.aTowerLocation.x - this.bTowerLocation.x) / (this.aTowerLocation.y - this.bTowerLocation.y);
    double acMidX = (this.aTowerLocation.x + this.cTowerLocation.x) / 2.0;
    double acMidY = (this.aTowerLocation.y + this.cTowerLocation.y) / 2.0;
    double slopeACp = -(this.aTowerLocation.x - this.cTowerLocation.x) / (this.aTowerLocation.y - this.cTowerLocation.y);

    this.centerLocation.x = (abMidY - acMidY + acMidX * (slopeACp - slopeABp)) / (slopeACp - slopeABp);
    this.centerLocation.y = acMidY - slopeACp * (acMidX - this.centerLocation.x);

    this.deltaRadius = Math.sqrt((this.aTowerLocation.x - this.centerLocation.x) * (this.aTowerLocation.x - this.centerLocation.x) + 
      (this.aTowerLocation.y - this.centerLocation.y) * (this.aTowerLocation.y - this.centerLocation.y));

    if (this.aTowerLocation.x > this.centerLocation.x) {
      this.aTowerAngle = Math.atan((this.aTowerLocation.y - this.centerLocation.y) / (this.aTowerLocation.x - this.centerLocation.x));
    } else {
      this.aTowerAngle = Math.PI + Math.atan((this.aTowerLocation.y - this.centerLocation.y) / (this.aTowerLocation.x - this.centerLocation.x));
    }
    if (this.bTowerLocation.x > this.centerLocation.x) {
      this.bTowerAngle = Math.atan((this.bTowerLocation.y - this.centerLocation.y) / (this.bTowerLocation.x - this.centerLocation.x));
    } else {
      this.bTowerAngle = Math.PI + Math.atan((this.bTowerLocation.y - this.centerLocation.y) / (this.bTowerLocation.x - this.centerLocation.x));
    }
    if (this.cTowerLocation.x > this.centerLocation.x) {
      this.cTowerAngle = Math.atan((this.cTowerLocation.y - this.centerLocation.y) / (this.cTowerLocation.x - this.centerLocation.x));
    } else {
      this.cTowerAngle = Math.PI + Math.atan((this.cTowerLocation.y - this.centerLocation.y) / (this.cTowerLocation.x - this.centerLocation.x));
    }

    transform.recalc(this);
    /*
    println("Calculating center:");
    println("Center: (" + this.centerLocation.x + ", " + this.centerLocation.y + ")");
    println("Radius: " + this.deltaRadius);
    println("aTowerAngle: " + this.aTowerAngle);
    println("bTowerAngle: " + this.bTowerAngle);
    println("cTowerAngle: " + this.cTowerAngle);
    */
  }

  double calculateActualBedHeight(double pX, double pY) {
    return (this.bedNormal.d - this.bedNormal.a * pX - this.bedNormal.b * pY) / this.bedNormal.c;
  }

  void CalculateBedNormal() {
    this.bedNormal.a = sin(yBedAngle);
    this.bedNormal.b = sin(xBedAngle);
    this.bedNormal.c = cos(xBedAngle) + cos(yBedAngle);
  }

  // (1): Create a bunch of locations--sample locations
  // (2): Compute the motor heights for each location in (1) using "ideal" delta config
  // (3): Compute the effector location for the "actual" delta config using motor heights in (2)
  // ERROR == effector(3).z - bed.z 
  // (4): Using (x,y) of effector in (3), calculate actual bed height (aka bed intercept)
  // (5): Using bed intercept, calculate motor heights
  // ERROR == motor(5).x - motor(2).x  --or-- motor(5).y - motor(2).y  --or--  motor(5).z - motor(2).z 


  // Given an effector location, calculate the motor heights
  Location CalculateMotorHeights(Location effector, Location motorHeights) {
    return this.transform.transform(effector, motorHeights);
  }
  /*
    if (motorHeights == null) {
   motorHeights = new Location();
   }
   motorHeights.x = effector.z + Math.sqrt((this.rodLength*this.rodLength) - 
   (this.aTowerLocation.x - effector.x)*(this.aTowerLocation.x - effector.x) - 
   (this.aTowerLocation.y - effector.y)*(this.aTowerLocation.y - effector.y));
   motorHeights.y = effector.z + Math.sqrt((this.rodLength*this.rodLength) - 
   (this.bTowerLocation.x - effector.x)*(this.bTowerLocation.x - effector.x) - 
   (this.bTowerLocation.y - effector.y)*(this.bTowerLocation.y - effector.y));
   motorHeights.z = effector.z + Math.sqrt((this.rodLength*this.rodLength) - 
   (this.cTowerLocation.x - effector.x)*(this.cTowerLocation.x - effector.x) - 
   (this.cTowerLocation.y - effector.y)*(this.cTowerLocation.y - effector.y));
   return motorHeights;
   }
   */


  Location CalculateEffectorLocation(Location motorHeights, Location effector) {
    return this.transform.inverseTransform(motorHeights, effector);
  }
  /*
    
   if (effector == null) {
   effector = new Location();
   }
   double k1 = (sq(this.bTowerLocation.x)+sq(this.bTowerLocation.y)+sq(motorHeights.y)
   -sq(this.aTowerLocation.x)-sq(this.aTowerLocation.y)-sq(motorHeights.x)) 
   / (2*(this.bTowerLocation.x-this.aTowerLocation.x));
   double k2 = (this.bTowerLocation.y-this.aTowerLocation.y)/(this.bTowerLocation.x-this.aTowerLocation.x);                 
   double k3 = (motorHeights.y-motorHeights.x)/(this.bTowerLocation.x-this.aTowerLocation.x);
   double l1 = (sq(this.cTowerLocation.x)+sq(this.cTowerLocation.y)+sq(motorHeights.z)
   -sq(this.bTowerLocation.x)-sq(this.bTowerLocation.y)-sq(motorHeights.y)) 
   / (2*(this.cTowerLocation.x-this.bTowerLocation.x));
   double l2 = (this.cTowerLocation.y-this.bTowerLocation.y)/(this.cTowerLocation.x-this.bTowerLocation.x);                 
   double l3 = (motorHeights.z-motorHeights.y)/(this.cTowerLocation.x-this.bTowerLocation.x);
   double a1 = (k3 - l3) / (l2 - k2); 
   double b1 = (l1 - k1) / (l2 - k2);
   double a2 = (-k2 * a1 - k3);
   double b2 = (k1 - k2 * b1);
   double a3 = sq(a1) + sq(a2) + 1;
   double b3 = 2*a1*(b1-this.bTowerLocation.y)+2*a2*(b2-this.bTowerLocation.x)-2*motorHeights.y;
   double c3 = sq(b2-this.bTowerLocation.x) + sq(b1-this.bTowerLocation.y) + sq(motorHeights.y) - sq(this.rodLength);
   double z1 = (-b3 + Math.sqrt(sq(b3) - 4*a3*c3)) / (2*a3);
   double x1 = a2 * z1 + b2;
   double y1 = a1 * z1 + b1;
   double z2 = (-b3 - Math.sqrt(sq(b3) - 4*a3*c3)) / (2*a3);
   double x2 = a2 * z2 + b2;
   double y2 = a1 * z2 + b1;
   
   if (z1 > z2) {
   effector.x = x2;
   effector.y = y2;
   effector.z = z2;
   } else {
   effector.x = x1;
   effector.y = y1;
   effector.z = z1;
   }
   return effector;
   }
   */
}

class Point {
  double x;
  double y;
  double z;

  Point(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

float[] CalcTowerOffsets(float[] position) {
  return null;
}

float ProbeHeight(float[] towerOffsets) {
  return 0;
}

void printLocation(String title, Location location) {
  println(title + "[" + location.x + ", " + location.y + ", " + location.z + "]");
}