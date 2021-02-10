//==========   БИБЛИОТЕКИ   ==========//

import processing.video.*;
import processing.serial.*;



//==========   КОНСТАНТЫ   ==========//

final int WIDTH = 1920;
final int HEIGHT = 1080;
final int FPS = 30;

final int BAR_HEIGHT = HEIGHT / 4;           // Высота панели
final int BAR_MID = HEIGHT - BAR_HEIGHT / 2; // Середина панели (по оси Y)
final int BAR_INDENT = 72;                   // Отступ от краев панели

final String[] GRAPH_NAMES = {"Ускорение", "Скорость", "Высота"};
final int GRAPH_WIDTH = 256;            
final int GRAPH_HEIGHT = BAR_HEIGHT / 2;
final color GRAPH_COLOR = color(255);
final int GRAPH_INDENT = 96; // Отступы между графиками
final int DATA_SECONDS = 5;  // Кол-во последних секунд на графике

final color ACTIVE_STATUS_COLOR = color(255); 
final color INACTIVE_STATUS_COLOR = color(255, 128);
final String[] STATUS_NAMES = {
    "Ожидание полета",
    "Взлет",
    "Падение",
    "Спуск на парашюте",
    "Приземление"
};



//==========   ПЕРЕМЕННЫЕ   ==========//

PImage logo;
PImage spinner;

Capture cam;
boolean cameraReady = false; 

Graph[] graph = new Graph[3];

int currentStatus = 0;



//==========   КАМЕРА   ==========//

void initCamera(){
    while(true){
        try{
            cam = new Capture(this, WIDTH, HEIGHT, FPS);
            cam.start();            
            println("Camera init succeded!");
            cameraReady = true;
            return;            
        } catch(Exception e) {
            println("Camera init failed!");
            delay(500);
        }
    }
}



//==========   ЗАГРУЗКА   ==========//

void drawLoader(){
    imageMode(CENTER);
    
    image(logo, WIDTH / 2, HEIGHT / 2);

    translate(WIDTH / 2, HEIGHT / 2);
    rotate(frameCount * TWO_PI / FPS);
    image(spinner, 0, 0);

    imageMode(CORNER);
}



//==========   ГРАФИКИ   ==========//

void initGraphs(){
    for(int i = 0; i < GRAPH_NAMES.length; i++){
        int xBegin = WIDTH - i * (GRAPH_WIDTH + GRAPH_INDENT) - BAR_INDENT;
        int xEnd = xBegin - GRAPH_WIDTH;
        int xMid = (xBegin + xEnd) / 2;

        graph[i] = new Graph(
            xEnd,
            BAR_MID - GRAPH_HEIGHT / 2,
            GRAPH_WIDTH, 
            GRAPH_HEIGHT,
            GRAPH_COLOR
        );

        graph[i].xLabel = "";
        graph[i].yLabel = "";
        graph[i].Title = "";
        graph[i].xMin = -DATA_SECONDS;
        graph[i].xMax = 0;
        graph[i].xDiv = DATA_SECONDS;
    }
}

void drawGraphs(){
    for(int i = 0; i < GRAPH_NAMES.length; i++){   
        int xBegin = WIDTH - i * (GRAPH_WIDTH + GRAPH_INDENT) - BAR_INDENT;
        int xEnd = xBegin - GRAPH_WIDTH;
        int xMid = (xBegin + xEnd) / 2;

        graph[i].DrawAxis();

        textAlign(CENTER, BOTTOM);
        textSize(24);
        fill(GRAPH_COLOR);
        text(GRAPH_NAMES[i], xMid, BAR_MID - GRAPH_HEIGHT / 2 - 8);
    }
}



//==========   СТАТУС   ==========//

void drawStatus(){
    textAlign(LEFT, BOTTOM);
    textSize(48);

    fill(ACTIVE_STATUS_COLOR);
    text(STATUS_NAMES[currentStatus], BAR_INDENT, BAR_MID + 24);
    fill(INACTIVE_STATUS_COLOR);

    if(currentStatus > 0){
        text(STATUS_NAMES[currentStatus - 1], BAR_INDENT, BAR_MID - 48 - 8 + 24);
    }

    if(currentStatus < STATUS_NAMES.length - 1){
        text(STATUS_NAMES[currentStatus + 1], BAR_INDENT, BAR_MID + 48 + 8 + 24);
    }
}



//==========   УТИЛИТЫ   ==========//

void gradient(int x, int y, float w, float h, color c1, color c2) {  
    for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
    }
}



//==========   СОБЫТИЯ   ==========//

void mousePressed() {
    if(mouseButton == LEFT && currentStatus + 1 < STATUS_NAMES.length){  
        currentStatus++;
    }else if(mouseButton == RIGHT && currentStatus - 1 >= 0){
        currentStatus--;
    }
}

void captureEvent(Capture video){
    video.read();
}



//==========   ОСНОВНОЙ КОД   ==========//

void settings() {
    //size(WIDTH, HEIGHT);
    fullScreen();    
}

void setup(){
    frameRate(FPS);

    background(0);
    logo = loadImage("logo.png");
    spinner = loadImage("spinner.png"); 

    thread("initCamera");
    initGraphs();
}

void draw(){
    background(0);

    if(!cameraReady){
        drawLoader();
        return;
    }
    
    image(cam, 0, 0);

    gradient(0, HEIGHT - BAR_HEIGHT, WIDTH, BAR_HEIGHT, color(0, 1), color(0, 255));
    drawStatus();
    drawGraphs();
}