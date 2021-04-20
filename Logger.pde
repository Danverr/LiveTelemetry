void logException(Exception e){
    String time = getLocalTime();
    String fileTime = getLocalTimeForFile();
    
    println("Caught exception at " + time + ": ");
    e.printStackTrace();

    String path = "./logs/" + fileTime + ".txt";
    String[] arr = {"ERROR TIME: " + time + "\n", e.getMessage()};
    saveStrings(path, arr);
}

void prepareExitHandler () {
    Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
        public void run () {            
            if(serialPort != null){
                serialPort.closeFile();
                serialPort.saveData("Autosave on exit");
            }
        }
    }));
 }  
