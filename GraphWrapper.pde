class GraphWrapper extends GuiObject {
    
    private String _title;
    private String _unit;
    private Graph _graph;
    
    private String[] _dataKeys;
    
    private float[] _xData;
    private float[][] _yData;

    private color[] _axisColors = {
        color(192, 96, 96, 128), // X - R
        color(96, 192, 96, 128), // Y - G
        color(96, 96, 192, 128)  // Z - B
    };

    private float _yMin =  10000000;
    private float _yMax = -10000000;
    
    

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
        _graph.xMin = -5;
        _graph.xMax = 0;
        _graph.xDiv = 5;
    }
    
    
    
    void updateData() {
        Table data = serialPort.getData();
        int minTime = millis() - 5000;
        int rowCount = data.getRowCount();
        int count = 0;
        int firstIndex = rowCount - 1;

        for (int i = rowCount - 1; i >= 0; i--) {
            if (data.getRow(i).getInt("millis") < minTime) {
                break;
            }
            
            firstIndex = i;
            count++;
        }
        
        float[] xData = new float[count];
        float[][] yData = new float[_dataKeys.length][xData.length];
        
        for (int j = 0; j < count; j++) {
            TableRow row = data.getRow(firstIndex + j);            
            xData[j] = row.getInt("millis");
            
            for (int i = 0; i < _dataKeys.length; i++) {
                yData[i][j] = row.getFloat(_dataKeys[i]);
                _yMin = min(_yMin, yData[i][j]);
                _yMax = max(_yMax, yData[i][j]);
            }
        }
        
        _xData = xData;
        _yData = yData;
    }



    void updateTitle(){
        float val = 0;

        if(_dataKeys.length == 1){
            val = _yData[0][_xData.length - 1];            
        }else{
            for(int i = 0; i < _yData.length; i++){
                val += sq(_yData[i][_xData.length - 1]);
            }
            
            val = sqrt(val);
        }

        _graph.Title = _title + ": " + nf(val, 4, 2) + " " + _unit;
    }
    
    
    
    void draw() {
        super.draw();
        updateData();
        updateTitle();

        _graph.yMin = _yMin;
        _graph.yMax = _yMax;
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
        _graph.xPos = (int)x;
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
