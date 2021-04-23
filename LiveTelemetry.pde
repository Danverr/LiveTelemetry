//==========   БИБЛИОТЕКИ   ==========//

import processing.serial.*;



//==========   ШРИФТЫ   ==========//

PFont RobotoMono_med;
PFont RobotoMono_reg;
PFont Roboto_med;
PFont Roboto_reg;



//==========   КОНСТАНТЫ   ==========//

final int FPS = 30;

final color RED = color(192, 0, 0, 200);
final color GREEN = color(0, 192, 0, 200);
final color BLUE = color(0, 0, 192, 200);

final color TRANSPARENT = color(0, 1);
final color DANGER_COLOR = #F36C21;
final color SUCCESS_COLOR = #60c655;
final color WARNING_COLOR = #F7BD44;

final float STATUS_BAR_HEIGHT = 24;

final float SIDEBAR_WIDTH = 384;
final float SIDEBAR_CONTENT_WIDTH = 256;

final float PLOT_WIDTH = 256;
final float PLOT_HEIGHT = 156;
final int PLOT_PADDING = 12;



//==========   ПЕРЕМЕННЫЕ   ==========//

Loader loader;
StatusBar statusBar;
LeftSidebar leftSidebar;
RightSidebar rightSidebar;
DialogWindow selectSerialPort;
DialogWindow selectCamera;
Snackbar snackbar;
SerialPort serialPort;
Timer timer;
FlightStages flightStages;
GpsCoordinates gpsCoordinates;

int showLoader = 0;
boolean cameraReady = false;
String cameraName;
String[] stages = {
        "Обратный отсчет",
        "Активный полет",
        "Выгорание двигателя",
        "Апогей",
        "Раскрытие парашюта",
        "Приземление"
    };



//==========   ОСНОВНОЙ КОД   ==========//

void settings() {
    fullScreen(P3D);
}

void setup() {
    background(0);
    frameRate(FPS);
    ortho();

    prepareExitHandler();
    
    RobotoMono_med = createFont("RobotoMono-Medium.ttf", 24, true);
    RobotoMono_reg = createFont("RobotoMono-Regular.ttf", 24, true);
    Roboto_med = createFont("Roboto-Medium.ttf", 24, true);
    Roboto_reg = createFont("Roboto-Regular.ttf", 24, true);
    
    loader = new Loader(this);
    statusBar = new StatusBar(this);
    rightSidebar = new RightSidebar(this);
    snackbar = new Snackbar(this);
    
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
        leftSidebar = new LeftSidebar(this);
    }
    if (cameraName == null && selectCamera.available()) {
        cameraName = selectCamera.getResult();
    }
    
    if (showLoader != 0) {
        loader.draw();
    } else if (cameraName == null) {
        cameraReady = false;
        selectCamera.draw();
    } else if (serialPort == null) {
        selectSerialPort.draw();
    } else if (!cameraReady) {
        thread("initCamera");
    } else {
        serialPort.update();
        drawCamera();
        
        statusBar.draw();
        leftSidebar.draw();
        snackbar.draw();        
        rightSidebar.draw();
    }
}