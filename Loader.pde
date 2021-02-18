class Loader {

    private PApplet _context;

    private PImage _logoGalaktika;
    private PImage _logoRocket;
    private PImage _spinner;    

    Loader(PApplet context){        
        _context = context;
        _logoGalaktika = loadImage("galaktikaShadow.png");
        _logoRocket = loadImage("logo.png");
        _spinner = loadImage("spinner.png");
    }

    public void drawStatic(){
        background(0);
        imageMode(CENTER);
        int width = _context.width;
        int height = _context.height;
        
        // Логотип GALAKTIKA
        image(_logoGalaktika, width / 2, height / 2);
    }

    public void draw(){
        background(0);
        imageMode(CENTER);
        int width = _context.width;
        int height = _context.height;
        
        // Логотип ракета
        image(_logoRocket, width / 2, height / 2);

        // Спиннер
        translate(width / 2, height / 2);
        rotate(frameCount * TWO_PI / FPS);
        image(_spinner, 0, 0);
    }

}