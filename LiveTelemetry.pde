//==========   БИБЛИОТЕКИ   ==========//



//==========   КОНСТАНТЫ   ==========//

final int FPS = 30;

final color TRANSPARENT = color(0, 1);
final color DANGER_COLOR = #F36C21;



//==========   ПЕРЕМЕННЫЕ   ==========//

boolean showLoader = true;



//==========   ОСНОВНОЙ КОД   ==========//

void settings() {
    fullScreen();    
}

void setup(){
    background(0);
    frameRate(FPS);

    initLoader();
    initStatusBar();
    thread("initCamera"); 
}

void draw(){    
    background(0);
    
    if(showLoader){
        drawLoader();
        return;
    }

    drawCamera();
    drawStatusBar();
}