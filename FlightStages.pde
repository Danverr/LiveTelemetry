class FlightStages extends Layout {
    
    Timer _timer;
    
    private int _activeStage = - 1;
    private FlightStage[] _flightStages;
    
    FlightStages(PApplet context, Timer timer, String[] stages) {
        super(context, 6);
        setOrientation(VERTICAL);
        setAlign(LEFT);
        setSpacing(16);
        
        _timer = timer;
        _flightStages = new FlightStage[stages.length];
        
        for (int i = 0; i < stages.length; i++) {
            _flightStages[i] = new FlightStage(context, stages[i]);
            add(_flightStages[i]);
        }
    }
    
    public void setStage(int index) {        
        if (index == _activeStage || index >= _flightStages.length) {
            return;
        }
        
        if (_activeStage != - 1) {
            _flightStages[_activeStage].makeInactive();
        }
        
        _activeStage = index;
        _flightStages[_activeStage].setTime(_timer.getMissionTime());
        _flightStages[_activeStage].makeActive();
    }    
    
}
