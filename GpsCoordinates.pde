class GpsCoordinates extends Layout {

    Text[] _coordinates;
    final String[] _labels = {"X: ", "Y: ", "Z: "};
    String[] _keys = {
            "xCoordinate",
            "yCoordinate",
            "zCoordinate",
        };

    GpsCoordinates(PApplet context){
        super(context, 256, 106, 4);
        setOrientation(VERTICAL);
        setAlign(LEFT);
        setSpacing(8);

        Text title = new Text(context, "Координаты");
        title.setFont(Roboto_med);
        title.setColor(color(0));
        add(title);
        
        _coordinates = new Text[3];

        for(int i = 0; i < 3; i++){
            _coordinates[i] = new Text(context, "");
            _coordinates[i].setFont(RobotoMono_reg);
            _coordinates[i].setTextSize(18);
            _coordinates[i].setColor(color(0, 128));
            add(_coordinates[i]);
        }
    }

    public void draw(){
        Table data = serialPort.getData();
        TableRow row = data.getRow(data.getRowCount() - 1);

        for(int i = 0 ; i < 3; i++){
            String coordinate = nf(row.getFloat(_keys[i]), 0, 10);
            _coordinates[i].setText(_labels[i] + coordinate); 
        }

        super.draw();
    }

}
