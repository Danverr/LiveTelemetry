void defaultCallback() {
    println("Click!");
};

class StatusBar {

    private PApplet _context;

    private Layout layout; 
    
    StatusBar(PApplet context) {
        _context = context;

        // Параметры
        int textSize = 14;
        float textVertIndent = (STATUS_BAR_HEIGHT - textSize) / 2;

        String[] dangerNames = {"Запуск", "Калибровка"};
        String[] dangerCallbacks = {"defaultCallback", "defaultCallback"};

        String[] regularNames = {"Камера", "Цвет"};
        String[] regularCallbacks = {"changeCamera", "defaultCallback"};

        // Инициализация контейнера
        layout = new Layout(4);
        layout.setIndents(20);
        layout.moveTo(0, 0);

        // Инициализация опасных кнопок
        for (int i = 0; i < dangerNames.length; i++){
            Button btn = new Button(context, dangerNames[i], dangerCallbacks[i], 10, textVertIndent);
            btn.setTextSize(textSize);
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(DANGER_COLOR);
            btn.setTextColor(color(0));
            btn.setTextHoverColor(color(255));
            layout.add(btn);
        }

        // Инициализация обычных кнопок
        for (int i = 0; i < regularNames.length; i++){
            Button btn = new Button(context, regularNames[i], regularCallbacks[i], 10, textVertIndent);
            btn.setTextSize(textSize);
            btn._buttonColor = TRANSPARENT;
            btn.setButtonHoverColor(color(0, 255 * 0.2));
            btn.setTextColor(color(0));
            btn.setTextHoverColor(color(0));
            layout.add(btn);
        }    

    }

    public void draw() {
        
        // Фон
        noStroke();
        fill(color(255, 128));
        rect(0, 0, width, STATUS_BAR_HEIGHT);

        // Компоненты
        layout.draw();

    }

}