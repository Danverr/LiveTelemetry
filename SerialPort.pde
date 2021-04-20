import processing.serial.*;

final String TEST_SERIAL_PORT = "Тест";

final byte startMarker = 0x7E;
final int VAR_SIZE = 2;
final int VAR_COUNT = 17;
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
    
    PrintWriter _file;
    String _folder = "./telemetry/";
    
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
        "yaw",           // 15: Рыскание в градусах
        "pitch",         // 16: Тангаж в градусах
        "roll",          // 17: Крен в градусах
        "millis",        // 18: millis по внутреннему времени
        "timestamp",     // 19: UNIX Timestamp в мс в виде строки
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
        
        _folder += "Session from " + getLocalTimeForFile() + "/";
        String path = _folder + getLocalTimeForFile() + " Autolog" + ".csv";
        _file = createWriter(path);
        println("Starting to write in a file \"" + path + "\"");
        
        for(int i = 0; i < _columnNames.length; i++){
            _file.print(_columnNames[i] + (i + 1 < _columnNames.length ? "," : "\n"));
        }        
        
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

        saveRow(newRow);
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



    private void generateBuffer(){
        if(_data.getRowCount() == 0){
            getNewRow();
        }

        TableRow lastRow = _data.getRow(_data.getRowCount() - 1);
        
        for (int i = 0; i < VAR_COUNT; i++) {
            String name = _columnNames[i];
                      
            if(_columnTypes[i] == "int") {
                int val = 0;
                for(int j = 0; j < VAR_SIZE; j++) {
                    buffer[2*i + j] = byte(val >> (8 * j));
                }
            }else if(_columnTypes[i] == "float"){
                float val = lastRow.getFloat(name);
                val += random(-1, 1);
                val = min(val, 3000);
                val = max(val,-3000);

                if(name == "yaw" || name == "pitch" || name == "roll"){
                    val = (val + 360) % 360; //<>//
                }
                
                for(int j = 0; j < VAR_SIZE; j++) {
                    buffer[2*i + j] = byte(int(val * PRECISION) >> (8 * j));
                }
            }
        }

        int stage = (millis() / 1000) % stages.length;
        buffer[3*2 + 0] = byte(stage);
        buffer[3*2 + 1] = byte(stage >> 8);
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



    private void saveRow(TableRow lastRow){
        for(int i = 0; i < _columnNames.length; i++){            
            if(_columnTypes[i] == "int"){
                _file.print(lastRow.getInt(_columnNames[i]));
            } else if(_columnTypes[i] == "String"){
                _file.print(lastRow.getString(_columnNames[i]));
            } else {
                _file.print(lastRow.getFloat(_columnNames[i]));
            }

            _file.print(i + 1 < _columnNames.length ? "," : "\n");
        }
    }



    public void closeFile(){
        _file.flush(); // Writes the remaining data to the file
        _file.close(); // Finishes the file
    }



    public void saveData(String name){
        String path = _folder + getLocalTimeForFile() + " " + name + ".csv";
        saveTable(_data, path);
        println("Telemetry has been successfully saved at \"" + path + "\"");
        snackbar.show("Данные сохранены в \"" + path + "\"", SUCCESS_SNACKBAR);
    }

  

    public Table getData() {
        if (_serialPortName == TEST_SERIAL_PORT) {
            generateBuffer();
            serialEvent();
        }
        
        return _data;
    }

    public TableRow getLastRow() {
        Table data = getData();
        return data.getRow(data.getRowCount() - 1);
    }

    public Serial getSerial(){
        return _serial;
    }
    
}
