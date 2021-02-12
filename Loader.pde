PImage logo;
PImage spinner;

void initLoader(){
    logo = loadImage("logo.png");
    spinner = loadImage("spinner.png");
}

void drawLoader(){
    background(0);
    imageMode(CENTER);
    
    // Логотип
    image(logo, width / 2, height / 2);

    // Спиннер
    translate(width / 2, height / 2);
    rotate(frameCount * TWO_PI / FPS);
    image(spinner, 0, 0);
}