class GpsCoordinates extends Layout {

    Text[] _coordinates;
    final String[] labels = {"X: ", "Y: ", "Z: "};

    GpsCoordinates(PApplet context){
        super(context, 4);
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
            _coordinates[i].setColor(color(0, 128));
            add(_coordinates[i]);
        }
    }

    public void draw(){
        Table data = serialPort.getData();
        TableRow row = data.getRow(data.getRowCount() - 1);
        
        String[] keys = {
            "xCoordinate",
            "yCoordinate",
            "zCoordinate",
        };

        for(int i = 0 ; i < 3; i++){
            String coordinate = nf(row.getFloat(keys[i]), 3, 10);
            _coordinates[i].setText(labels[i] + coordinate);
        }

        super.draw();
    }

}
