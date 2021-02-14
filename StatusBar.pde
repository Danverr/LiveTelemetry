void defaultCallback() {
    println("Click!");
};

class StatusBar {

    private PApplet _context;

    private Layout _layout; 
    
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
        _layout = new Layout(_context.width, STATUS_BAR_HEIGHT, 4);
        _layout.setIndents(20);
        _layout.setBackgroundColor(color(255, 128));
        _layout.moveTo(0, 0);

        // Инициализация опасных кнопок
        for (int i = 0; i < dangerNames.length; i++){
            Button btn = new Button(context, dangerNames[i], dangerCallbacks[i], 10, textVertIndent);
            btn.setTextSize(textSize);
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(DANGER_COLOR);
            btn.setTextColor(color(0));
            btn.setTextHoverColor(color(255));
            _layout.add(btn);
        }

        // Инициализация обычных кнопок
        for (int i = 0; i < regularNames.length; i++){
            Button btn = new Button(context, regularNames[i], regularCallbacks[i], 10, textVertIndent);
            btn.setTextSize(textSize);
            btn._buttonColor = TRANSPARENT;
            btn.setButtonHoverColor(color(0, 255 * 0.2));
            btn.setTextColor(color(0));
            btn.setTextHoverColor(color(0));
            _layout.add(btn);
        }    

    }

    public void draw() {
        _layout.draw();
    }

}