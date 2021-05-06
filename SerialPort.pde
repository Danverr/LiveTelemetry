import processing.serial.*;

final String TEST_SERIAL_PORT = "Тест";

final int VAR_SIZE = 4;
final int VAR_COUNT = 19;
final int BAUD_RATE = 115200;
final int RF_REQUEST_SIZE = VAR_SIZE * VAR_COUNT;
final byte RF_START_MARKER = 0x12;
final byte RF_ESCAPE_MARKER = 0x7D;

boolean isEscaped = false;
int currentByte = RF_REQUEST_SIZE;
byte[] buffer = new byte[RF_REQUEST_SIZE];

void serialEvent(Serial serial) {    
    byte b = byte(serial.readChar());

    if (b == RF_ESCAPE_MARKER && !isEscaped) {
        isEscaped = true; // Если считали маркер экранирования, значит следующий байт не служебный
        return;
    }

    // Если есть место, читаем запрос
    if (currentByte != RF_REQUEST_SIZE) {
        buffer[currentByte++] = b;

        // Прочитали весь запрос
        if (currentByte == RF_REQUEST_SIZE) {
            serialPort.serialEvent();
        }
    } else if (b == RF_START_MARKER && !isEscaped) {
        currentByte = 0; // Если считали маркер начала, начнем записывать байты в буффер
    }

    isEscaped = false;
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
        "response",      //  2: Сам ответ
        "stage",         //  3: Стадия полета
        "height",        //  4: Высота
        "speed",         //  5: Скорость в м/с
        "xAcceleration", //  6: Ускорение по Ox
        "yAcceleration", //  7: Ускорение по Oy
        "zAcceleration", //  8: Ускорение по Oz
        "xCoordinate",   //  9: Координата GPS по Ox
        "yCoordinate",   // 10: Координата GPS по Oy
        "zCoordinate",   // 11: Координата GPS по Oz
        "yaw",           // 12: Рыскание в градусах
        "pitch",         // 13: Тангаж в градусах
        "roll",          // 14: Крен в градусах
        "yawSpeed",      // 15: Скорость рыскания в градусах в секунду
        "pitchSpeed",    // 16: Скорость тангажа в градусах в секунду
        "rollSpeed",     // 17: Скорость крена в градусах в секунду
        "servoX",        // 18: Положение серво TVC по Ox
        "servoY",        // 19: Положение серво TVC по Oy
        "millis",        // 20: millis по внутреннему времени
        "timestamp",     // 21: UNIX Timestamp в мс в виде строки
    };
    private String[] _columnTypes = {
        "int", "int",              // Ответ на запрос
        "int",                     // Стадия полета
        "float",                   // Высота
        "float",                   // Скорость
        "float", "float", "float", // Ускорение
        "float", "float", "float", // GPS
        "float", "float", "float", // Углы Эйлера
        "float", "float", "float", // Угловые скорости
        "int", "int",              // Положение серво
        "int",                     // millis
        "String",                  // Timestamp
    };

    
    
    SerialPort(PApplet context, String serialPortName) {
        _context = context;
        _serialPortName = serialPortName;
        
        // Инициализация таблицы
        _data = new Table();
        
        for (String name : _columnNames) {
            _data.addColumn(name);
        }
        
        getNewRow(); // Добавили дефолтную строчку
        
        // Инициализация записи телеметрии в файл
        _folder += "Session from " + getLocalTimeForFile() + "/";
        String path = _folder + getLocalTimeForFile() + " Autolog" + ".csv";
        _file = createWriter(path);
        println("Starting to write in a file \"" + path + "\"");
        
        for(int i = 0; i < _columnNames.length; i++){
            _file.print(_columnNames[i] + (i + 1 < _columnNames.length ? "," : "\n"));
        }        
        
        // Устанавливаем соединение по Serial порту
        if (serialPortName != TEST_SERIAL_PORT) {
            _serial = new Serial(_context, serialPortName, BAUD_RATE);
        }        
    }
    
    
    
    public void serialEvent() {
        TableRow newRow = getNewRow(); 

        for(int i = 0, j = 0; j < RF_REQUEST_SIZE; i++, j += VAR_SIZE){
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

        _serial.write(RF_START_MARKER);
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
                    val = val % 180;
                }

                for(int j = 0; j < VAR_SIZE; j++) {
                    buffer[2*i + j] = byte(Float.floatToIntBits(val) >> (8 * j));
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
