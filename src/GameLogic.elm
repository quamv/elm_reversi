{-
Manages the Rerversi board and capture logic
-}
module GameLogic exposing (
    userSelectsSquare,
    getScore)


{-
system imports
-}
import Array exposing (..)

{-
local imports
-}
import Model exposing (..)
import Helpers exposing (..)


{-
types
-}
type alias CompareAndIncFuncs = ((Int -> Bool), (Int -> Int))


{-
the maximum index on the board
-}
boardMax = (rows*cols) - 1


nextGameState : GameBoard -> GameState
nextGameState board =
    let
        freeCells =
            Array.length <| Array.filter (\n -> n == Nothing) board
    in
        if freeCells == 0 then
            GameOver
        else
            Normal


{-
process a user selection
-}
userSelectsSquare : Model -> Int -> Model
userSelectsSquare model idx =
    -- first check if the cell is already occupied
    case isValidMove idx model.gameBoard of

        True ->
            -- not occupied. selection is valid
            let
                boardbeforecaptures =
                    -- change state of selected square
                    setSquareState idx (Just model.currentPlayer) model.gameBoard

                opponent =
                    -- capturable state
                    togglePlayer model.currentPlayer

                newcaptures =
                    -- get a list of indexes to capture
                    captureCells model.gameBoard idx opponent

                boardwithcaptures =
                    -- update the board with the newly captured cells
                    setMany boardbeforecaptures newcaptures model.currentPlayer
            in
                {model |
                    currentPlayer = togglePlayer model.currentPlayer
                    ,captures = model.captures ++ [newcaptures]
                    ,gameState = nextGameState boardwithcaptures
                    ,gameBoard = boardwithcaptures}

        False ->
            -- already occupied. selection not valid
            {model |
                currentPlayer = togglePlayer model.currentPlayer}


{-
True if the cell is available
False if the cell is already taken
-}
isValidMove : Int -> GameBoard -> Bool
isValidMove idx board =
    case getValByIdx idx board of
        Nothing -> True
        _ -> False


{-
scan for captures up,down,left,right,upleft,upright,downleft,downright
-}
captureCells : GameBoard -> Int -> SquareState -> List Int
captureCells board idx expectedstate =
    let
        (rowFirstIdx, rowLastIdx) =
            getRowFirstLastByIdx idx

        captureCore =
            -- have to curry last parameters... or something like that.
            captureCellsCore board idx expectedstate []

        captures =
            -- gather up the lists of all captured cells
            (captureCore <| leftHelpers rowFirstIdx)
            ++ (captureCore <| rightHelpers rowLastIdx)
            ++ captureCore upHelpers
            ++ captureCore downHelpers
            ++ (captureCore <| upleftHelpers idx)
            ++ (captureCore <| uprightHelpers idx)
            ++ (captureCore <| downleftHelpers idx)
            ++ (captureCore <| downrightHelpers idx)
    in
        captures


{-
capture the cells using the provided boundary check function and nextidx function
-}
captureCellsCore : GameBoard -> Int -> SquareState -> List Int -> CompareAndIncFuncs -> List Int
captureCellsCore board idx1 opponent idxs helperfuns =
    let
        (oobCheck,nextidx) =
            helperfuns

        -- original idx is the currently selected cell
        -- nextidx gets an appropriate next cell to check for capture
        idx =
            nextidx idx1
    in
        if oobCheck idx then
            -- outside the boundaries. this state indicates failed search.
            -- for horizontal checks, this is the row boundaries
            -- for vertical and diagonal checks, 0 and boardMax
            -- capture nothing
            []
        else
            -- not out of bounds, check if it's a capturable cell (ie. our opponent's)
            case getValByIdx idx board of

                Just playerside ->
                    -- cell is owned by someone. make sure it's our opponent's
                    if playerside == opponent then
                        -- cell is potentially capturable. store in our list and keep searching
                        captureCellsCore board idx opponent (idxs ++ [idx]) helperfuns
                    else
                        -- this is another cell owned by us so the current search is over.
                        -- return the list of cells captured to this point, which could be []
                        -- for adjacent cells owned by us
                        idxs

                Nothing ->
                    -- we had no bounding cell. capture nothing.
                    []


getPlayerScore : GameBoard -> PlayerSide -> Int
getPlayerScore board player =
    Array.length <|
        Array.filter (\cell -> cell == Just player) board

{-
calculate the scores
-}
getScore : GameBoard -> (Int, Int)
getScore board =
    (
        getPlayerScore board PlayerSide1
        ,getPlayerScore board PlayerSide2
    )



{-
helper functions that facilitate the search for captures.
first element is the boundary check to end a search
second element calculates the next idx to inspect
some situations require an index parameter for the boundary check
others use either 0 or the boardMax constant for boundaries
so they don't require parameters
-}
leftHelpers idx =   ((\n -> n < idx),      (\n -> n - 1))
rightHelpers idx =  ((\n -> n > idx),      (\n -> n + 1))
upHelpers =         ((\n -> n < 0),        (\n -> n - cols))
downHelpers =       ((\n -> n > boardMax), (\n -> n + cols))

{-
diagonal helpers have to account for the real arrangement of the grid
to prevent for incorrect diagonal matches that wrap around
-}
downrightHelpers idx =
    let
        (row,col) =
            toRowCol idx

        rowsFromBottom =
            rows - row

        colsFromRight =
            cols - col

        multiplier =
            min rowsFromBottom colsFromRight

        maxidx =
            idx + (multiplier * (cols + 1))
    in
        ((\n -> n > maxidx), (\n -> n + cols + 1))

downleftHelpers idx =
    let
        (row,col) =
            toRowCol idx

        rowsFromBottom =
            rows - row

        multiplier =
            min rowsFromBottom col

        maxidx =
            idx + (multiplier * (cols - 1))
    in
        ((\n -> n > maxidx), (\n -> n + cols - 1))

upleftHelpers idx =
    let
        (row,col) =
            toRowCol idx

        multiplier =
            min col row

        minidx =
            idx - (multiplier * (cols + 1))
    in
        ((\n -> n < minidx), (\n -> n - cols - 1))

uprightHelpers idx =
    let
        (row,col) =
            toRowCol idx

        colsFromRight =
            cols - col

        multiplier =
            min colsFromRight rows

        minidx =
            idx - (multiplier * (cols - 1))
    in
        ((\n -> n < minidx), (\n -> n - cols + 1))

