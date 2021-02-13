class Loader {

    private PApplet _context;

    private PImage _logo;
    private PImage _spinner;    

    Loader(PApplet context){
        _context = context;
        _logo = loadImage("logo.png");
        _spinner = loadImage("spinner.png");
    }

    public void draw(){
        background(0);
        imageMode(CENTER);
        int width = _context.width;
        int height = _context.height;
        
        // Логотип
        image(_logo, width / 2, height / 2);

        // Спиннер
        translate(width / 2, height / 2);
        rotate(frameCount * TWO_PI / FPS);
        image(_spinner, 0, 0);
    }

}