import processing.serial.*;

final String TEST_SERIAL_PORT = "Тест";

void serialEvent(Serial serial) {
    serialPort.serialEvent(serial);
}



class SerialPort {
    
    private PApplet _context;
    
    private Serial _serial;
    private String _serialPortName;
    
    Table _data;
    private String[] columnNames = {
        "millis",
        "stage",
        "height",
        "xVelocity",
        "yVelocity",
        "zVelocity",
        "xAcceleration",
        "yAcceleration",
        "zAcceleration",
        "xCoordinate",
        "yCoordinate",
        "zCoordinate",
    };
    
    private boolean _isInitCompleted = false;
    private String[] _stages;
    
    
    
    SerialPort(PApplet context, String serialPortName) {
        _context = context;
        _serialPortName = serialPortName;
        
        if (serialPortName != TEST_SERIAL_PORT) {
            _serial = new Serial(_context, serialPortName, 9600);
        }
        
        _data = new Table();
        
        for (String name : columnNames) {
            _data.addColumn(name);
        }
    }
    
    
    
    public void serialEvent(Serial serial) {
        JSONObject raw = parseJSONObject(serial.readString());
        String type = raw.getString("type");        
        
        if (_isInitCompleted == false && type == "init") {
            JSONArray stagesJson = raw.getJSONObject("data").getJSONArray("stages");
            _stages = new String[stagesJson.size()];            
            
            for (int i = 0; i < stagesJson.size(); i++) {
                _stages[i] = stagesJson.getString(i);
            }

            initTable();
            
            _isInitCompleted = true;
        } else if (type == "data") {
            addRow(raw.getJSONObject("data"));
        }
    }
    
    

    private void initTable(){
        int millis = millis();

        for (int j = 5000; j >= 0; j--) {
            TableRow newRow = _data.addRow();
            
            for (int i = 0; i < columnNames.length; i++) {
                String name = columnNames[i];
                
                if (name == "millis") {
                    newRow.setInt(name, millis - j);
                } else if (name == "stage") {
                    newRow.setInt(name, -1);
                } else {
                    newRow.setFloat(name, 0);
                }
            }
        }        
    }



    private void addRandomRow(){
        JSONObject jsonData = new JSONObject();
        TableRow lastRow = _data.getRow(_data.getRowCount() - 1);
        
        for (int i = 0; i < columnNames.length; i++) {
            String name = columnNames[i];
            
            if (name == "millis") {
                jsonData.setInt(name, millis());
            } else if (name == "stage") {
                jsonData.setInt(name, -1);
            } else {
                float val = lastRow.getFloat(name);
                val += random(-1, 1);
                val = min(val, 100);
                val = max(val, 0);
                jsonData.setFloat(name, val);
            }
        }

        addRow(jsonData);       
    }


    
    private void addRow(JSONObject jsonData) {
        TableRow newRow = _data.addRow();
        flightStages.setStage(jsonData.getInt("stage"));
        
        for (int i = 0; i < columnNames.length; i++) {
            String name = columnNames[i];
            
            if (name == "millis") {
                newRow.setInt(name, millis());
            } else if (name == "stage") {
                newRow.setInt(name, jsonData.getInt(name));
            } else {
                newRow.setFloat(name, jsonData.getFloat(name));
            }
        }
    }
    
    
    
    public Table getData() {
        if (_serialPortName == TEST_SERIAL_PORT) {
            if(_isInitCompleted == false){
                initTable();
                _isInitCompleted = true;
            }

            addRandomRow();            
        }
        
        return _data;
    }
    
    
    
    public String[] getStages() {
        if (_serialPortName == TEST_SERIAL_PORT) {                            
            String[] temp = {
                "Обратный отсчет",
                "Активный полет",
                "Выгорание двигателя",
                "Апогей",
                "Раскрытие парашюта",
                "Приземление"
            };            
            return temp;
        }
        
        return _stages;
    }
    
    
    
    public boolean isInitCompleted() {
        if (_serialPortName == TEST_SERIAL_PORT) {                            
            return true;
        }
        
        return _isInitCompleted;
    }
    
}
