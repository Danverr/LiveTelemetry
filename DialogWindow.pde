class DialogWindow {

    private PApplet _context;

    Layout _windowLayout;

    StringArrayCallback _callback;

    String _titleName;
    String[] _optionNames;

    String _result;
    boolean _available = false;

    private void init(PApplet context, String titleName, String[] optionsNames) {
        _context = context;
        _titleName = titleName;
        _optionNames = optionsNames;

        // Инициализация контейнера заголовка
        Layout titleLayout = new Layout(context, _callback == null ? 1 : 2);
        titleLayout.setSpacing(12);
        titleLayout.setOrientation(VERTICAL);
        titleLayout.setAlign(LEFT);

        // Инициализация кнопки обновления
        if(_callback != null){
            Button updateBtn = new Button(context, "Обновить");
            updateBtn.setTextSize(18);          
            updateBtn.setContentColor(color(255, 128));
            updateBtn.setButtonHoverColor(TRANSPARENT);
            updateBtn.setCallback(new Callback(){
                public void execute(){                    
                    updateOptions();
                }
            });

            titleLayout.add(updateBtn);
        }

        // Инициализация заголовка
        Text title = new Text(context, titleName);
        title.setTextSize(36);
        title.setFont(Roboto_med);
        titleLayout.add(title);

        // Инициализация контейнера кнопок опций
        Layout optionsLayout = new Layout(context, optionsNames.length);
        optionsLayout.setOrientation(VERTICAL);
        optionsLayout.setAlign(LEFT);
        optionsLayout.setSpacing(24);

        // Инициализация самих кнопок опций
        for(int i = 0; i < optionsNames.length; i++) {
            final String name = optionsNames[i];

            Button btn = new Button(context, name);
            btn.setTextSize(24);
            btn.setContentColor(color(255, 192));
            btn.setButtonColor(TRANSPARENT);
            btn.setButtonHoverColor(TRANSPARENT);
            btn.setCallback(new Callback(){
                public void execute(){
                    _result = name;
                    _available = true;
                }
            });

            optionsLayout.add(btn);
        }

        // Добавляем все в контейнер диалогового окна
        Layout dialogLayout = new Layout(context, 2);
        dialogLayout.setOrientation(VERTICAL);
        dialogLayout.setAlign(LEFT);
        dialogLayout.setSpacing(36);
        dialogLayout.add(titleLayout);
        dialogLayout.add(optionsLayout);

        // Инициализация контейнера всего окна
        _windowLayout = new Layout(context, context.width, context.height, 1);
        _windowLayout.setOrientation(VERTICAL);
        _windowLayout.setBackgroundColor(color(0));
        _windowLayout.setDistribution(SPACE_EVENLY);
        _windowLayout.add(dialogLayout);
    }
    
    DialogWindow(PApplet context, String title, String[] options) {
        init(context, title, options);
    }

    DialogWindow(PApplet context, String title, StringArrayCallback callback) {
        _callback = callback;
        init(context, title, _callback.execute());
    }

    public void updateOptions(){
        init(_context, _titleName, _callback.execute());
    }

    public boolean available(){
        return _available;
    }

    public String getResult(){
        _available = false;
        return _result;
    }

    public void draw(){
        _windowLayout.draw();
    }

}