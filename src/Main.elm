{-
Reversi in Elm
-}
module Main exposing (
    main
    )

{- system imports -}
import Html exposing (beginnerProgram)
import Keyboard exposing (KeyCode,downs)
import Char exposing (fromCode)
{- local imports -}
import Model exposing (..)
import View exposing (view)
import GameLogic exposing (userSelectsSquare)
import Helpers exposing (togglePlayer,newBoard,setSquareState)


main =
    Html.beginnerProgram {
        model = initmodel,
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
    }


update : Msg -> Model -> Model
update msg model = case msg of
        UserSelectsSquare idx ->
            userSelectsSquare model idx


