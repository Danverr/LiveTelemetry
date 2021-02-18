/*

JSON Init Message Structure

{
    type: "init",
    data: {
        stages: [
            String,
            String,
            ... ,
            String
        ]
    }
}



JSON Data Message Structure

{
    type: "data",
    data: {
        flightStage:    String
        height:         float
        velocity:       float
        acceleration:   float
        deviationAngle: float
        rollAngle:      float
        xCoordinate:    float
        yCoordinate:    float
        zCoordinate:    float
    }
}



JSON Command Message Structure

{
    type: "command",
    command: "launch"
}

*/

import processing.serial.*;

final String TEST_SERIAL_PORT = "Тест";

void serialEvent(Serial serial) {
    serialPort.serialEvent(serial);
}

class SerialPort {

    private PApplet _context;
    
    private Serial _serial;
    private String _serialPortName;

    private String[] _stages;
    private JSONObject _data;

    boolean _isInitCompleted = false;

    SerialPort(PApplet context, String serialPortName) {
        _context = context;
        _serialPortName = serialPortName;

        if(serialPortName != TEST_SERIAL_PORT){
            _serial = new Serial(_context, serialPortName, 9600);
        }
    }

    public void serialEvent(Serial serial) {
        JSONObject raw = parseJSONObject(serial.readString());
        String type = raw.getString("type");

        if(_isInitCompleted == false && type == "init"){
            JSONArray stagesJson = raw.getJSONObject("data").getJSONArray("stages");
            _stages = new String[stagesJson.size()];

            for(int i = 0; i < stagesJson.size(); i++){
                _stages[i] = stagesJson.getString(i);
            }

            _isInitCompleted = true;
        }else if(type == "data"){
            _data = raw.getJSONObject("data");
        }
    }

    public JSONObject getData(){
        if(_serialPortName == TEST_SERIAL_PORT) {
            JSONObject temp = new JSONObject();
            temp.setInt("flightStage", -1);
            temp.setFloat("height", random(100));
            temp.setFloat("velocity", random(100));
            temp.setFloat("acceleration", random(100));
            temp.setFloat("deviationAngle", random(60));
            temp.setFloat("rollAngle", random(360));
            
            JSONArray coordinates = new JSONArray();
            coordinates.setFloat(0, random(180));
            coordinates.setFloat(1, random(180));
            coordinates.setFloat(2, random(180));
            temp.setJSONArray("coordinates", coordinates);

            return temp;
        }

        return _data;
    }

    public String[] getStages(){
        if(_serialPortName == TEST_SERIAL_PORT) {                            
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

    public boolean isInitCompleted(){
        if(_serialPortName == TEST_SERIAL_PORT) {                            
            return true;
        }

        return _isInitCompleted;
    }

}
