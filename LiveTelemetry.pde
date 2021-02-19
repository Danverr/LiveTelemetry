//==========   БИБЛИОТЕКИ   ==========//

import processing.serial.*;



//==========   ШРИФТЫ   ==========//

PFont RobotoMono_med;
PFont RobotoMono_reg;
PFont Roboto_med;
PFont Roboto_reg;



//==========   КОНСТАНТЫ   ==========//

final int FPS = 30;

final color TRANSPARENT = color(0, 1);
final color DANGER_COLOR = #F36C21;
final color WARNING_COLOR = #F7BD44;

final float STATUS_BAR_HEIGHT = 24;

final float SIDEBAR_WIDTH = 384;
final float SIDEBAR_CONTENT_WIDTH = 256;



//==========   ПЕРЕМЕННЫЕ   ==========//

Loader loader;
StatusBar statusBar;
LeftSidebar leftSidebar;
RightSidebar rightSidebar;
DialogWindow selectSerialPort;
DialogWindow selectCamera;

SerialPort serialPort;
Timer timer;
FlightStages flightStages;
GpsCoordinates gpsCoordinates;

boolean showLoader = false;
boolean cameraReady = false;
String cameraName;
String[] stages;



//==========   ОСНОВНОЙ КОД   ==========//

void settings() {
    fullScreen();    
}

void setup() {
    background(0);
    frameRate(FPS);
    
    RobotoMono_med = createFont("RobotoMono-Medium.ttf", 24, true);
    RobotoMono_reg = createFont("RobotoMono-Regular.ttf", 24, true);
    Roboto_med = createFont("Roboto-Medium.ttf", 24, true);
    Roboto_reg = createFont("Roboto-Regular.ttf", 24, true);
    
    loader = new Loader(this);
    statusBar = new StatusBar(this);
    rightSidebar = new RightSidebar(this);
    
    selectCamera = new DialogWindow(this, "Выберите камеру", new StringArrayCallback() {
        public String[] execute() {
            return Capture.list();
        }
    } );
    selectSerialPort = new DialogWindow(this, "Выберите COM порт", new StringArrayCallback() {
        public String[] execute() {
            return append(Serial.list(), TEST_SERIAL_PORT);
        }
    } );
}

void draw() {    
    background(0);
    
    if (serialPort == null && selectSerialPort.available()) {
        serialPort = new SerialPort(this, selectSerialPort.getResult());
    }
    if (cameraName == null && selectCamera.available()) {
        cameraName = selectCamera.getResult();
    }
    if (stages == null && serialPort != null && serialPort.isInitCompleted()) {
        stages = serialPort.getStages();
        leftSidebar = new LeftSidebar(this);
    }
    
    if (showLoader) {
        loader.draw();
    } else if (cameraName == null) {
        cameraReady = false;
        selectCamera.draw();
    } else if (serialPort == null) {
        selectSerialPort.draw();
    } else if (!cameraReady) {
        thread("initCamera");
    } else {
        drawCamera();
        statusBar.draw();
        leftSidebar.draw();
        rightSidebar.draw();
    }
}
