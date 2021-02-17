import processing.video.*;

Capture cam;

void captureEvent(Capture video){
    video.read();    
}

void initCamera(){
    showLoader = true;

    while(true){
        try{
            cam = new Capture(this, 1920, 1080, cameraName);
            cam.start();

            cameraReady = true;
            showLoader = false;
            return;            
        } catch(Exception e) {
            delay(500);
        }
    }
}

void drawCamera(){
    imageMode(CORNER);
    image(cam, 0, 0, width, height);
}
