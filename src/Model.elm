module Model exposing (..)

import Array exposing (Array)
import Keyboard exposing (KeyCode)

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
    }

rows = 8
cols = 8

