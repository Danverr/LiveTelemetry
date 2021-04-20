class StatusBar {

    Layout _layout;
    Layout _leftButtons;
    
    Button _exitButton;
    
    StatusBar(PApplet context) {
        _layout = new Layout(context, context.width, STATUS_BAR_HEIGHT, 2);

        // Параметры
        int textSize = 14;

        final String[] names = {
            "Запуск",
            "Калибровка", 
            "Сохранить данные", 
            "THROW EXCEPTION",
        };

        final color[] hoverColors = {
            color(DANGER_COLOR, 192), 
            color(WARNING_COLOR, 192), 
            color(0, 38),
            color(0, 38),
        };
        
        final Callback[] callbacks = { 
            new Callback(){
                void execute(){ 
                    snackbar.show("Включаем синий светодиод...");
                    timer.start();
                    byte[] arr = {1, 0};
                    serialPort.sendRequest(arr);                    
                }
            }, 
            new Callback(){
                void execute(){
                    snackbar.show("Включаем красный светодиод...");
                    timer.reset();
                    byte[] arr = {1, 1};
                    serialPort.sendRequest(arr);
                }
            },
            new Callback(){
                void execute(){
                    serialPort.saveData("Manual save");
                }
            },
            new Callback(){
                void execute(){
                    throw new RuntimeException("Test runtime exception");
                }
            }
        };

        _leftButtons = new Layout(context, names.length);

        // Инициализация контейнеров
        _layout.setPadding(20, 0, 0, 0);
        _layout.setBackgroundColor(color(255, 128));
        _layout.setDistribution(SPACE_BETWEEN);

        // Инициализация кнопок слева
        for (int i = 0; i < names.length; i++){
            Button btn = new Button(context, AUTO, STATUS_BAR_HEIGHT, names[i]);
            btn.setCallback(callbacks[i]);
            btn.setPadding(10, 0);
            btn.setTextSize(textSize);
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(hoverColors[i]);
            btn.setContentColor(color(0));
            btn.setContentHoverColor(color(0));
            _leftButtons.add(btn);
        }

        // Инициализация кнопки выхода
        Button _exitButton = new Button(context, AUTO, STATUS_BAR_HEIGHT, null, "exitIcon.svg");
        _exitButton.setPadding(10, 0);
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
