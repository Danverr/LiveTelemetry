import processing.video.*;

Capture cam;
int cameraIndex = 0;

void captureEvent(Capture video){
    video.read();    
}

void initCamera(){
    String[] cameras = Capture.list();
    
    cameraIndex %= cameras.length;

    while(true){
        try{
            cam = new Capture(this, 1920, 1080, cameras[cameraIndex]);
            cam.start();            
            println("Selected camera: " + cameras[cameraIndex]);
            showLoader = false;
            return;            
        } catch(Exception e) {
            delay(500);
        }
    }
}

void changeCamera(){
    cam.stop();
    cameraIndex++;
    showLoader = true;
    thread("initCamera");
}

void drawCamera(){
    imageMode(CORNER);
    image(cam, 0, 0, width, height);
}