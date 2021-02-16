class FlightStages extends Layout {
             
    private final String[] stages = {
        "Обратный отсчет",
        "Активный полет",
        "Выгорание двигателя",
        "Апогей",
        "Раскрытие парашюта",
        "Приземление"
    };

    private int _activeStage = -1;
    private FlightStage[] _flightStages = new FlightStage[stages.length];

    FlightStages(PApplet context) {
        super(context, 6);
        setOrientation(VERTICAL);
        setAlign(LEFT);
        setSpacing(16);

        for(int i = 0; i < stages.length; i++){
            _flightStages[i] = new FlightStage(context, stages[i]);
            add(_flightStages[i]);
        }
    }

    public void nextStage(String time){
        if(_activeStage + 1 >= _flightStages.length) return;
        _activeStage++;

        if(_activeStage - 1 >= 0){
            _flightStages[_activeStage - 1].makeInactive();
        }
        
        _flightStages[_activeStage].setTime(time);
        _flightStages[_activeStage].makeActive();
    }

}
