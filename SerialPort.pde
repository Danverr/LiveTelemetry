import processing.serial.*;

final String TEST_SERIAL_PORT = "Тест";

final byte startMarker = 0x7E;
final int VAR_SIZE = 2;
final int VAR_COUNT = 14;
final int PRECISION = 10;
final int BAUD_RATE = 115200;
final int PACKAGE_SIZE = VAR_SIZE * VAR_COUNT;

int currentByte = PACKAGE_SIZE;
byte[] buffer = new byte[PACKAGE_SIZE];

void serialEvent(Serial serial) {
    byte b = byte(serial.readChar());
    //print(b);

    if(currentByte != PACKAGE_SIZE){  
        buffer[currentByte++] = b;
        
        if(currentByte == PACKAGE_SIZE){
            serialPort.serialEvent();
        }
    }else if(b == startMarker){
        currentByte = 0;
    }
}



class SerialPort {
    
    private PApplet _context;
    
    private Serial _serial;
    private String _serialPortName;

    private int _requestId = 0;
    private final int _requestIdMod = 30001;
    private final int _responseTimeout = 5000;
    private int _requestSendingTime = 0;
    private int _lastResponseId = -1;
    private boolean _isWaitingForResponse = false;
    private byte[] _currentRequest;
    
    Table _data;
    private String[] _columnNames = {        
        "responseId",    //  1: Идентификатор запроса
        "request",       //  2: Команда, на которую пришел ответ
        "response",      //  3: Сам ответ
        "stage",         //  4: Стадия полета
        "height",        //  5: Высота
        "xVelocity",     //  6: Скорость по Ox
        "yVelocity",     //  7: Скорость по Oy
        "zVelocity",     //  8: Скорость по Oz
        "xAcceleration", //  9: Ускорение по Ox
        "yAcceleration", // 10: Ускорение по Oy
        "zAcceleration", // 11: Ускорение по Oz
        "xCoordinate",   // 12: Координата GPS по Ox
        "yCoordinate",   // 13: Координата GPS по Oy
        "zCoordinate",   // 14: Координата GPS по Oz
        "millis",        // 15: millis по внутреннему времени
        "timestamp",     // 16: UNIX Timestamp в мс в виде строки
    };
    private String[] _columnTypes = {
        "int",           
        "int",           
        "int", 
        "int",           
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "float",         
        "int",    
        "String",
    };

    
    
    SerialPort(PApplet context, String serialPortName) {
        _context = context;
        _serialPortName = serialPortName;
        
        _data = new Table();        
        
        for (String name : _columnNames) {
            _data.addColumn(name);
        }
        
        if (serialPortName != TEST_SERIAL_PORT) {
            _serial = new Serial(_context, serialPortName, BAUD_RATE);
        }        
    }
    
    
    
    public void serialEvent() {
        TableRow newRow = getNewRow(); 

        for(int i = 0, j = 0; j < PACKAGE_SIZE; i++, j += VAR_SIZE){
            if(_columnTypes[i] == "int"){
                int val = bytesToInt(buffer, j);
                newRow.setInt(_columnNames[i], val);
            }else{
                float val = bytesToFloat(buffer, j);
                newRow.setFloat(_columnNames[i], val);
            }
        } 
        
        if(flightStages != null){
            flightStages.setStage(newRow.getInt("stage"));
        }

        int responseId = newRow.getInt("responseId");
        int request = newRow.getInt("request");
        int response = newRow.getInt("response");

        if(_lastResponseId == -1){
            _lastResponseId = responseId;
        }

        if(_isWaitingForResponse && responseId != _lastResponseId){
            print("Response #" + responseId + " recieved! Result: ");
            _lastResponseId = responseId;

            if(response == 1){
                snackbar.show("Команда успешно выполнена!", SUCCESS_COLOR);                
                println("success");
            }else if(response == 0){
                snackbar.show("Ошибка! Команда не выполнена.", ERROR_SNACKBAR);
                println("error");
            }

            _isWaitingForResponse = false;
        }
    }


    private void repeatRequest(){
        if(_serial == null){ 
            return; 
        }

        _serial.write(startMarker);
        _serial.write(_requestId);
        _serial.write(_currentRequest);
    }

    public void sendRequest(byte[] arr) {        
        _requestId = (_requestId + 1) % _requestIdMod;

        println("Request #" + _requestId + " has been sent!");        

        _currentRequest = arr;
        _requestSendingTime = millis();
        _isWaitingForResponse = true;

        repeatRequest();
    }
    
    

    private TableRow getNewRow(){
        TableRow newRow = _data.addRow();
        
        for (int i = 0; i < _columnNames.length; i++) {
            String name = _columnNames[i];
                
            if(_columnTypes[i] == "int"){
                newRow.setInt(name, 0);
            } else if(_columnTypes[i] == "float") {
                newRow.setFloat(name, 0);
            }
        }

        newRow.setInt("millis", millis());
        newRow.setString("timestamp", String.valueOf(System.currentTimeMillis()));
        newRow.setInt("stage", -1);    
        return newRow; 
    }



    private void addRandomRow(){        
        if(_data.getRowCount() == 0){
            getNewRow();
        }

        TableRow lastRow = _data.getRow(_data.getRowCount() - 1);
        TableRow newRow = getNewRow();
        
        for (int i = 0; i < VAR_COUNT; i++) {
            String name = _columnNames[i];
                      
            if(_columnTypes[i] == "int"){
                newRow.setInt(name, 0);
            } else {
                float val = lastRow.getFloat(name);
                val += random(-1, 1);
                val = min(val, 100);
                val = max(val, 0);
                newRow.setFloat(name, val);
            }
        }

        newRow.setInt("stage", (millis() / 1000) % stages.length);

        if(flightStages != null){
            flightStages.setStage(newRow.getInt("stage"));
        }
    }

    
    
    public void update(){        
        if(_isWaitingForResponse){
            if(millis() - _requestSendingTime < _responseTimeout){
                repeatRequest();
            } else{
                println("Request #" + _requestId + " exceeded time limit"); 
                snackbar.show("Превышено время ожидания", ERROR_SNACKBAR);
                _isWaitingForResponse = false; 
            }            
        }
    }



    public void saveData(){
        String path = "./telemetry/" + getLocalTimeForFile() + ".csv";
        saveTable(_data, path);
        println("Telemetry has been successfully saved at " + path);
        snackbar.show("Данные сохранены в \"" + path + "\"", SUCCESS_SNACKBAR);
    }

  

    public Table getData() {
        if (_serialPortName == TEST_SERIAL_PORT) {
            addRandomRow();            
        }
        
        return _data;
    }

    public Serial getSerial(){
        return _serial;
    }
    
}
