import processing.video.*;

Capture cam;
int cameraIndex = 0;

void captureEvent(Capture video){
    video.read();    
}

void initCamera(){   
    while(true){
        try{
            String[] cameras = Capture.list();            
            if(cameras.length == 0) throw new Exception();
            cameraIndex %= cameras.length;

            cam = new Capture(this, 1920, 1080, cameras[cameraIndex]);
            cam.start();

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