class StatusBar {

    Layout _layout;
    Layout _leftButtons;
    
    Button _exitButton;
    
    StatusBar(PApplet context) {
        _layout = new Layout(context, context.width, STATUS_BAR_HEIGHT, 2);

        // Параметры
        int textSize = 14;
        float textVertIndent = (STATUS_BAR_HEIGHT - textSize) / 2;

        final String[] names = {"Запуск", "Калибровка"};
        final color[] hoverColors = {DANGER_COLOR, WARNING_COLOR};
        final Callback[] callbacks = { 
            null, 
            null
        };

        _leftButtons = new Layout(context, names.length);

        // Инициализация контейнеров
        _layout.setPadding(20, 0, 0, 0);
        _layout.setBackgroundColor(color(255, 128));
        _layout.setDistribution(SPACE_BETWEEN);

        // Инициализация кнопок слева
        for (int i = 0; i < names.length; i++){
            Button btn = new Button(context, names[i], "");
            btn.setCallback(callbacks[i]);
            btn.setPadding(10, textVertIndent);
            btn.setTextSize(textSize);
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(hoverColors[i]);
            btn.setContentColor(color(0));
            btn.setContentHoverColor(color(0));
            _leftButtons.add(btn);
        }

        // Инициализация кнопки выхода
        Button _exitButton = new Button(context, 34, STATUS_BAR_HEIGHT, "", "exitIcon.svg");
        _exitButton.setButtonColor(TRANSPARENT);
        _exitButton.setButtonHoverColor(DANGER_COLOR);
        _exitButton.setContentColor(color(0, 128));
        _exitButton.setContentHoverColor(color(255));
        _exitButton.setCallback(new Callback(){
            void execute() { exit(); }
        });
            
        _layout.add(_leftButtons);
        _layout.add(_exitButton);
    }

    public void draw(){
        _layout.draw();
    }

}
