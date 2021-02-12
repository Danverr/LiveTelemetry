final float STATUS_BAR_HEIGHT = 24;
Layout statusBarLayout = new Layout(0, 0, 4);

void defaultCallback() {
    println("Click!");
};

void initStatusBar() { 
    String[] dangerNames = {"Запуск", "Калибровка"};
    String[] dangerCallbacks = {"defaultCallback", "defaultCallback"};

    String[] regularNames = {"Камера", "Цвет"};
    String[] regularCallbacks = {"changeCamera", "defaultCallback"};

    // Инициализация контейнера
    statusBarLayout._indents = 20;

    // Инициализация опасных кнопок
    for (int i = 0; i < dangerNames.length; i++){
        Button btn = new Button(this, dangerNames[i], dangerCallbacks[i], 10, 5);
        btn.setTextSize(14);
        btn._buttonColor = TRANSPARENT;
        btn._buttonHoverColor = DANGER_COLOR;
        btn._textColor = color(0);
        btn._textHoverColor = color(255);
        statusBarLayout.add(btn);
    }

    // Инициализация обычных кнопок
    for (int i = 0; i < regularNames.length; i++){
        Button btn = new Button(this, regularNames[i], regularCallbacks[i], 10, 5);
        btn.setTextSize(14);
        btn._buttonColor = TRANSPARENT;
        btn._buttonHoverColor = color(0, 255 * 0.2);
        btn._textColor = color(0);
        btn._textHoverColor = color(0);
        statusBarLayout.add(btn);
    }    

}

void drawStatusBar(){
    fill(color(255, 128));
    rect(0, 0, width, STATUS_BAR_HEIGHT);
    statusBarLayout.draw();
}