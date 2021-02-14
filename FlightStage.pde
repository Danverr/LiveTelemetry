class FlightStage extends Layout {
  
    private TextLayout _time;
    private TextLayout _name;

    private color _nameColor = color(0);
    private color _timeColor = color(0);

    private color _inactiveNameColor = color(0, 128);
    private color _inactiveTimeColor = color(0, 128);

    FlightStage(PApplet context, String name) {
        super(2);
        setOrientation(VERTICAL);
        setSpacing(2);
        setAlign(LEFT);
        
        _time = new TextLayout(context, "Ожидается");
        _time.setFont(RobotoMono_reg);
        _time.setTextSize(14);
        _time.setTextColor(_inactiveTimeColor);
        add(_time);

        _name = new TextLayout(context, name);
        _name.setFont(Roboto_med);
        _name.setTextSize(24);
        _name.setTextColor(_inactiveNameColor);
        add(_name);
    }

    public void setTime(String time){
        _time.setText(time);
    }

    public void makeActive(){
        _time.setTextColor(_timeColor);
        _name.setTextColor(_nameColor);
    }

    public void makeInactive(){
        _time.setTextColor(_inactiveTimeColor);
        _name.setTextColor(_inactiveNameColor);
    }

}
