module Model exposing (..)

import Array exposing (Array)

type GameState = Normal | GameOver
type Msg = UserSelectsSquare Int
type PlayerSide = PlayerSide1 | PlayerSide2
type alias SquareState = PlayerSide
type alias GameBoard = Array (Maybe SquareState)

type alias Model = {
    gameState: GameState
    , currentPlayer: PlayerSide
    , gameBoard: GameBoard
    , selections: List Int
    , winner: Maybe PlayerSide
    , captures: List (List Int)
    , lastClicked: Int
    , lastClickedCellState: Maybe SquareState
    , lastClickWasValid: Bool
    }

rows : number
rows = 8
cols : number
cols = 8

gamestatestring : GameState -> String
gamestatestring gameState =
    case gameState of
        Normal -> "Normal"
        GameOver -> "Game Over"