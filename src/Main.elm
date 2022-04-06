{-
Reversi in Elm
-}
module Main exposing (main)

import Html exposing (..)
import Browser

-- import Keyboard exposing (KeyCode,downs)
--import Char exposing (fromCode)
{- local imports -}
import Model exposing (..)
import View exposing (view)
import GameLogic exposing (userSelectsSquare)
import Helpers exposing (newBoard)


main : Program () Model Msg
main =
    Browser.sandbox { 
        init = initmodel,
        view = view,
        update = update 
    }


initmodel : Model
initmodel =
    {
        gameState = Normal
        , currentPlayer = PlayerSide1
        , gameBoard = newBoard rows cols
        , selections = []
        , winner = Nothing
        , captures = []
        , lastClicked = 0
        , lastClickedCellState = Nothing
        , lastClickWasValid = True
    }


update : Msg -> Model -> Model
update msg model = case msg of
        UserSelectsSquare idx ->
            userSelectsSquare model idx


