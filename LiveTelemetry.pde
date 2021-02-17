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



//==========   ПЕРЕМЕННЫЕ   ==========//

Loader loader;
StatusBar statusBar;
LeftSidebar leftSidebar;
DialogWindow selectSerialPort;
DialogWindow selectCamera;

boolean showLoader = false;
boolean cameraReady = false;
String cameraName;
String serialPortName;



//==========   ОСНОВНОЙ КОД   ==========//

void settings() {
    fullScreen();    
}

void setup(){
    background(0);
    frameRate(FPS);

    RobotoMono_med = createFont("RobotoMono-Medium.ttf", 24, true);
    RobotoMono_reg = createFont("RobotoMono-Regular.ttf", 24, true);
    Roboto_med = createFont("Roboto-Medium.ttf", 24, true);
    Roboto_reg = createFont("Roboto-Regular.ttf", 24, true);

    loader = new Loader(this);
    statusBar = new StatusBar(this);
    leftSidebar = new LeftSidebar(this);
    
    selectCamera = new DialogWindow(this, "Выберите камеру", new StringArrayCallback(){
        public String[] execute(){
            return Capture.list();
        }
    });
    selectSerialPort = new DialogWindow(this, "Выберите COM порт", new StringArrayCallback(){
        public String[] execute(){
            return append(Serial.list(), "Test");
        }
    });
}

void draw(){    
    background(0);

    if(selectSerialPort.available()){
        serialPortName = selectSerialPort.getResult();
    }
    if(selectCamera.available()){
        cameraName = selectCamera.getResult();
    }
    
    if(showLoader){
        loader.draw();
    } else if(cameraName == null){
        cameraReady = false;
        selectCamera.draw();
    } else if(serialPortName == null){
        selectSerialPort.draw();
    } else if(!cameraReady){
        thread("initCamera");
    } else {
        drawCamera();
        statusBar.draw();
        leftSidebar.draw();
    }
}