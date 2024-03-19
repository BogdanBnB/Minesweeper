function MinesweeperGUIWithImages(rows, cols, mines)
    % Creez jocul Minesweeper
    game = Minesweeper(rows, cols, mines);

    % creez image handler (ma ajuta sa manipulez imaginile)
    imageHandler = imagini();

    % Creez GUI(interfata grafica)
    fig = figure('Name', 'Minesweeper', 'NumberTitle', 'off', 'Position', [100, 100, 400, 400]);

    % Creez variabilele pentru cronometru
    startTime = tic;


    % Creez obiectul de cronometru
    updateTimerObj = timer('TimerFcn', @(~,~) updateTimer(), 'ExecutionMode', 'fixedRate', 'Period', 1, 'StartDelay', 1);
   
    %pornesc cronometrul
    start(updateTimerObj);

    function startTimer()
        startTime = tic;
        start(updateTimerObj);
    end

    function updateTimer(~, ~)
        elapsedTime = toc(startTime);
        % Actualizez titlul figurii pentru a afisa timpul scurs
        set(fig, 'Name', ['Minesweeper - Time: ' num2str(round(elapsedTime))]);
    end

    % Creez butoanele
    for i = 1:rows
        for j = 1:cols
            buttons{i, j} = uicontrol(fig, 'Style', 'pushbutton', 'String', '', ...
                'Units', 'normalized', 'Position', [(j-1)/cols, 1-i/rows, 1/cols, 1/rows], ...
                'Callback', createButtonCallback(i, j));
        end
    end
     % Creez butoanele cu functia de apel pentru click dreapta
    for i = 1:rows
        for j = 1:cols
            buttons{i, j} = uicontrol(fig, 'Style', 'pushbutton', 'String', '', ...
                'Units', 'normalized', 'Position', [(j-1)/cols, 1-i/rows, 1/cols, 1/rows], ...
                'Callback', @(src, event) buttonClick(src, event, i, j), ...
                'ButtonDownFcn', @(src, event) rightClick(src, event, i, j, imageHandler));
        end
    end

     function rightClick(~, ~, row, col, imageHandler)
        % Click dreapta pentru plasare/descoperire steag
        button = buttons{row, col};
        currentCData = get(button, 'CData');
        
        if isempty(currentCData) % Daca celula nu are steag
            img_flag = imageHandler.img_flag; % inlocuiesc imageHandler cu instanta imagehandler
            set(button, 'CData', img_flag, 'Enable', 'off');
        else % daca celula are steag, ii scot steagul
            set(button, 'CData', [], 'Enable', 'on');
        end
     end
 
    function callback = createButtonCallback(row, col)
        callback = @(src, event) buttonClick(src, event, row, col);
    end

    % creez butonul de reset
    resetButton = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Reset', ...
        'Units', 'normalized', 'Position', [0.4, 0.02, 0.2, 0.05], ...
        'Callback', @(src, event) resetGame());

   function buttonClick(src, ~, row, col)
        value = game.imageBoard(row, col);
        button = buttons{row, col};
    
        if strcmp(get(button, 'Enable'), 'on')
            img = getImage(value);
    
            if ~isempty(img)
                set(button, 'CData', img, 'Enable', 'off', 'ForegroundColor', 'blue', 'FontWeight', 'bold');
            end
            % setez culoarea de fundal numai daca nu exista imagine
            if isempty(img)
                setBackgroundColor(button, 'green'); % 
                updateButtonText(button, countAdjacentMines(row, col));
                if countAdjacentMines(row, col) == 0
                    reveal_empty_cells(row, col);
                end
            end
            if value == -1
                setBackgroundColor(button, [1 0.8 0.8]); % Use light red color as an RGB triplet
                game_over();
                stopTimer(); % opresc timpul cand jocul s-a terminat
                msgbox('Game Over', 'Game Over', 'warn');  % afisez mesajul game over
            else
                %verific conditia de castig
                 if all(game.revealed(:) | game.board(:) == -1) && ~any(game.revealed(:) & game.board(:) == -1)
                    stopTimer(); % opresc timpul daca jucatorul a castigat
                    msgbox("You've Won!", 'Congratulations', 'info');  % afisez mesajul "you won"
                end
            end
        end
    end

    function setBackgroundColor(buttonHandle, color)
        set(buttonHandle, 'BackgroundColor', color);
    end

   function reveal_empty_cells(row, col)
    stack = [row, col];
    
    while ~isempty(stack)
        current = stack(1:2);
        stack = stack(3:end);

        row = current(1);
        col = current(2);

        if isValidCell(row, col) && game.imageBoard(row, col) ~= -1 && ~game.revealed(row, col)
            button = buttons{row, col};
            img = getImage(game.imageBoard(row, col));
            if isempty(img) && game.imageBoard(row, col) ~= -1
                setBackgroundColor(button, [0.8, 0.8, 0.8]);
                updateButtonText(button, countAdjacentMines(row, col));
                game.revealed(row, col) = true;
                for i = -1:1
                    for j = -1:1
                        newRow = row + i;
                        newCol = col + j;
                        if isValidCell(newRow, newCol)
                            stack = [stack, newRow, newCol];
                        end
                    end
                end
            else
                set(button, 'CData', img);  %setez imaginea pentru buton
                game.revealed(row, col) = true;
            end
        end
    end
end



    function isValid = isValidCell(row, col)
        isValid = row >= 1 && row <= rows && col >= 1 && col <= cols;
    end

    function count = countAdjacentMines(row, col)
        count = 0;
        for i = -1:1
            for j = -1:1
                newRow = row + i;
                newCol = col + j;
                if isValidCell(newRow, newCol) && game.board(newRow, newCol) == -1
                    count = count + 1;
                end
            end
        end
    end

    function updateButtonText(button, value)
        % updatez  textul butonului cu valoarea minelor adiacente
        if value > 0
            set(button, 'String', num2str(value));
        end
    end

    function game_over()
        for i = 1:rows
            for j = 1:cols
                if game.board(i, j) == -1
                    set(buttons{i, j}, 'CData', imageHandler.img_mina, 'Enable', 'off', 'BackgroundColor', 'red');
                else
                    set(buttons{i, j}, 'Enable', 'off');
                end
            end
        end
    end

  function img = getImage(value)
    img = [];
    validValues = [1, 2, 3, 4, 5, 6, 7, 8, -1];
    if ismember(value, validValues)
        switch value
            case 1
                img = imageHandler.img_1;
            case 2
                img = imageHandler.img_2;
            case 3
                img = imageHandler.img_3;
            case 4
                img = imageHandler.img_4;
            case 5
                img = imageHandler.img_5;
            case 6
                img = imageHandler.img_6;
            case 7
                img = imageHandler.img_7;
            case 8
                img = imageHandler.img_8;
            case -1
                img = imageHandler.img_mina;
        end
    end
  end

    function resetGame()
        stop(updateTimerObj);
        game = Minesweeper(rows, cols, mines);
        updateButtons();
        startTime = tic;
        start(updateTimerObj);
    end

    function stopTimer()
        stop(updateTimerObj);
        elapsedTime = toc(startTime);
    end



    function updateButtons()
        for i = 1:rows
            for j = 1:cols
                set(buttons{i, j}, 'CData', [], 'Enable', 'on', 'BackgroundColor', 'default');
            end
        end
    end
end
