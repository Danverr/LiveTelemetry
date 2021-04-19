class GraphWrapper extends GuiObject {
    
    private String _title;
    private String _unit;
    private Graph _graph;
    
    private String[] _dataKeys;
    
    private int _timeout = 5000;
    private int _pointsCount = 1000;

    private float[] _xData;
    private float[][] _yData;
    TableRow row = null;

    private color[] _axisColors = {
        color(192, 96, 96, 128), // X = R
        color(96, 192, 96, 128), // Y = G
        color(96, 96, 192, 128)  // Z = B
    };

    private float _yMin =  10000000;
    private float _yMax = -10000000;
    private float _xMin =  10000000;
    private float _xMax = -10000000;
    
    

    GraphWrapper(PApplet context, float width, float height, String title, String unit, String[] dataKeys) {
        _context = context;
        _width = width;
        _height = height;
        _dataKeys = dataKeys;        
        _title = title;
        _unit = unit;

        _graph = new Graph((int)width,(int)height);
        _graph.xLabel = "";
        _graph.yLabel = "";
        _graph.Title = _title;
        _graph.xDiv = _timeout / 1000;
    }
    
    
    
    void updateData() {
        Table data = serialPort.getData();
        int time = millis();
        int minTime = time - _timeout + 1;
        int rowCount = data.getRowCount();
        int rowIndex = rowCount - 1;

        float[] xData = new float[_pointsCount];
        float[][] yData = new float[_dataKeys.length][xData.length];

        // Находим строку с минимальным временем в пределах таймаута
        while(rowIndex >= 0 && data.getRow(rowIndex).getInt("millis") >= minTime){
            rowIndex--;
        }

        if(rowIndex + 1 < rowCount){
            row = data.getRow(++rowIndex);
        }
        
        // Вносим данные из строк в график
        for (int j = 0; j < _pointsCount; j++) {
            float currentTime = map(j, 0, _pointsCount - 1, minTime, time);
            while(rowIndex + 1 < rowCount && row != null && row.getInt("millis") <= currentTime){
                row = data.getRow(++rowIndex);
            }

            xData[j] = currentTime;            
            
            for (int i = 0; i < _dataKeys.length; i++) {
                yData[i][j] = row != null ? row.getFloat(_dataKeys[i]) : 0;
                _yMin = min(_yMin, yData[i][j]);
                _yMax = max(_yMax, yData[i][j]);
            }
        }        
        
        _xData = xData;
        _yData = yData;
    }



    void updateTitle(){
        if(_xData.length == 0){
            return;
        }

        float val = 0;

        if(_dataKeys.length == 1){
            val = _yData[0][_xData.length - 1];            
        }else{
            for(int i = 0; i < _yData.length; i++){
                val += sq(_yData[i][_xData.length - 1]);
            }
            
            val = sqrt(val);
        }

        _graph.Title = _title + ": " + nf(val, 0, 2) + " " + _unit;
    }
    
    
    
    void draw() {
        super.draw();
        updateData();
        updateTitle();

        float padding = max(1, (_yMax - _yMin) * 0.1);
        _graph.yMin = _yMin - padding;
        _graph.yMax = _yMax + padding;
        _graph.drawAxis();
        
        for (int i = 0; i < _yData.length; i++) {         
            if(_yData.length > 1){
                _graph.GraphColor = _axisColors[i];
            }

            _graph.lineGraph(_xData, _yData[i]);
        }
    }
    


    void moveTo(float x, float y) {
        super.moveTo(x, y);
        _graph.xPos = (int)x + PLOT_PADDING;
        _graph.yPos = (int)y;
    }

    float getHeight(){
        return _height + 18 + 16;
    }
    
    
    
    public void setGraphColor(color graphColor) {
        _graph.GraphColor = graphColor;
    }
    
    public void setBackgroundColor(color backgroundColor) {
        _graph.BackgroundColor = backgroundColor;
    }
    
    public void setStrokeColor(color strokeColor) {
        _graph.StrokeColor = strokeColor;
    }
    
}
