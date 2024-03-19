classdef Minesweeper < handle
    properties
        rows;
        cols;
        mines;
        board;
        revealed;
        imageBoard;
        imaginiObj;
    end

    methods
        function obj = Minesweeper(rows, cols, mines)
            obj.rows = rows;
            obj.cols = cols;
            obj.mines = mines;
            obj.board = zeros(rows, cols);
            obj.revealed = false(rows, cols);
            obj.imageBoard = zeros(rows, cols); % initialize imageBoard
            obj.imaginiObj = imagini(); % Create an instance of imagini
            obj.generateBoard();
        end

        function generateBoard(obj)
            minePositions = randperm(obj.rows * obj.cols, obj.mines);
            obj.board(:) = 0;  % Initialize all cells to 0
            obj.board(minePositions) = -1;
        
            % initializez matricea revealed
            obj.revealed = false(obj.rows, obj.cols);
            for position = minePositions
                [row, col] = ind2sub([obj.rows, obj.cols], position);
                obj.updateAdjacentCells(row, col);
            end
            validValues = [1, 2, 3, 4, 5, 6, 7, 8, -1];
            obj.board(~ismember(obj.board, validValues)) = 0;
            % generez imageBoard pe baza matricei Board
            obj.imageBoard = obj.generateImageBoard();
        end

        function imageBoard = generateImageBoard(obj)
            imageBoard = zeros(obj.rows, obj.cols);
            for i = 1:obj.rows
                for j = 1:obj.cols
                    if obj.board(i, j) == -1
                        % Mine image
                        imageBoard(i, j) = -1;
                    else
                        % Numbered images
                        imageBoard(i, j) = obj.board(i, j);
                    end
                end
            end
        end

        function updateAdjacentCells(obj, row, col)
            for i = -1:1
                for j = -1:1
                    newRow = row + i;
                    newCol = col + j;
                    if obj.isValidCell(newRow, newCol) && obj.board(newRow, newCol) ~= -1
                        if obj.board(newRow, newCol) >= 0
                            obj.board(newRow, newCol) = obj.board(newRow, newCol) + 1;
                        end
                    end
                end
            end
        end

        function valid = isValidCell(obj, row, col)
            valid = row >= 1 && row <= obj.rows && col >= 1 && col <= obj.cols;
        end

         function revealCell(obj, row, col)
            if obj.isValidCell(row, col) && ~obj.revealed(row, col)
                obj.revealed(row, col) = true;
                if obj.board(row, col) == 0
                    obj.imageBoard(row, col) = 0; % Display 0 for empty cell
                    for i = -1:1
                        for j = -1:1
                            obj.revealCell(row + i, col + j);
                        end
                    end
                elseif obj.board(row, col) > 0
                    % afisez numarul cand celula a fost clickuita
                    obj.imageBoard(row, col) = obj.board(row, col);
                end
            end
        end
    end
end
