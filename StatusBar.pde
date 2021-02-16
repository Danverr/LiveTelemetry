class StatusBar {

    Layout _layout;
    Layout _leftButtons;
    
    Button _exitButton;
    
    StatusBar(PApplet context) {
        _layout = new Layout(context, context.width, STATUS_BAR_HEIGHT, 2);
        _leftButtons = new Layout(context, 4);

        // Параметры
        int textSize = 14;
        float textVertIndent = (STATUS_BAR_HEIGHT - textSize) / 2;

        String[] names = {"Запуск", "Калибровка", "Камера", "Цвет"};
        String[] callbacks = {"", "", "changeCamera", ""};
        color[] hoverColors = {DANGER_COLOR, WARNING_COLOR, color(0, 51), color(0, 51)};

        // Инициализация контейнеров
        _layout.setPadding(20, 0, 0, 0);
        _layout.setBackgroundColor(color(255, 128));
        _layout.setAlignType(SPACE_BETWEEN);

        // Инициализация кнопок слева
        for (int i = 0; i < names.length; i++){
            Button btn = new Button(context, names[i], "");
            btn.setCallback(callbacks[i]);
            btn.setPadding(10, textVertIndent);
            btn.setTextSize(textSize);
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(hoverColors[i]);
            _leftButtons.add(btn);
        }

        // Инициализация кнопки выхода
        Button _exitButton = new Button(context, 34, STATUS_BAR_HEIGHT, "", "exitIcon.svg");
        _exitButton.setCallback("exit");
        _exitButton.setButtonColor(TRANSPARENT);
        _exitButton.setButtonHoverColor(DANGER_COLOR);
        _exitButton.setContentColor(color(128));
        _exitButton.setContentHoverColor(color(255));
            
        _layout.add(_leftButtons);
        _layout.add(_exitButton);
    }

    public void draw(){
        _layout.draw();
    }

}
