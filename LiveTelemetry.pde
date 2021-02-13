//==========   БИБЛИОТЕКИ   ==========//



//==========   ШРИФТЫ   ==========//

PFont RobotoMono_med;
PFont RobotoMono_reg;
PFont Roboto_med;
PFont Roboto_reg;



//==========   КОНСТАНТЫ   ==========//

final int FPS = 30;

final color TRANSPARENT = color(0, 1);
final color DANGER_COLOR = #F36C21;

final float STATUS_BAR_HEIGHT = 24;
final float SIDEBAR_WIDTH = 384;



//==========   ПЕРЕМЕННЫЕ   ==========//

Loader loader;
StatusBar statusBar;
LeftSidebar leftSidebar; 

boolean showLoader = true;



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

    thread("initCamera");
    loader = new Loader(this);
    statusBar = new StatusBar(this);
    leftSidebar = new LeftSidebar(this);
}

void draw(){    
    background(0);
    
    if(showLoader){
        loader.draw();
        return;
    }

    drawCamera();
    statusBar.draw();
    leftSidebar.draw();
}