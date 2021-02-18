class FlightStage extends Layout {
  
    private Text _time;
    private Text _name;

    private color _nameColor = color(0);
    private color _timeColor = color(0);

    private color _inactiveNameColor = color(0, 128);
    private color _inactiveTimeColor = color(0, 128);

    FlightStage(PApplet context, String name) {
        super(context, 2);
        setOrientation(VERTICAL);
        setSpacing(2);
        setAlign(LEFT);
        
        _time = new Text(context, "Ожидается");
        _time.setFont(RobotoMono_reg);
        _time.setTextSize(14);
        _time.setColor(_inactiveTimeColor);
        add(_time);

        _name = new Text(context, name);
        _name.setFont(Roboto_med);
        _name.setTextSize(24);
        _name.setColor(_inactiveNameColor);
        add(_name);
    }

    public void setTime(String time){
        _time.setText(time);
    }

    public void makeActive(){
        _time.setColor(_timeColor);
        _name.setColor(_nameColor);
    }

    public void makeInactive(){
        _time.setColor(_inactiveTimeColor);
        _name.setColor(_inactiveNameColor);
    }

}
