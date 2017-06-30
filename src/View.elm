{-
view functions
-}
module View exposing (view)

{- system includes -}
import Array exposing (..)
import List exposing (..)
import Html exposing (Html, div, text, h3, h1, table, thead, tr, td, tbody, span)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Set exposing (toList)

{- local includes -}
import Model exposing (..)
import Helpers exposing (..)
import GameLogic exposing (..)
import Styles exposing (..)


view : Model -> Html Msg
view model =
    div
        [ style mainContainerStyle]
        [
            h1 [] [text "Reversi"]
            ,scoreboard model.gameBoard model.gameState
            ,boardTable model
        ]


scoreboard : GameBoard -> GameState -> Html Msg
scoreboard board gamestate =
    let
        (sc1,sc2) =
            getScore board
    in
        case gamestate of
            Normal ->
                div [] [
                    span [style scoreStyle] [text <| "Player1: " ++ (toString sc1)]
                    ,span [style scoreStyle] [text <| "Player2: " ++ (toString sc2)]
                ]

            GameOver ->
                div [] [
                    h3 [] [text <| (toString gamestate)]
                    ,span [style scoreStyle] [text <| "Player1: " ++ (toString sc1)]
                    ,span [style scoreStyle] [text <| "Player2: " ++ (toString sc2)]
                ]



boardTable : Model -> Html Msg
boardTable model =
    let
        rowNbrs =
            List.range 0 7

        tableRows =
            List.map (\n -> viewBoardRow model n) rowNbrs
    in
        table
            [style boardTableStyle]
            tableRows

getChipColor : PlayerSide -> String
getChipColor side =
    case side of
        PlayerSide1 -> "black"
        PlayerSide2 -> "white"


gamePieceNode : PlayerSide -> Html Msg
gamePieceNode side =
    let
        background =
            getChipColor side

        fillStyle =
            [("background",background)]
    in
        div
            [style <| gamePieceStyle ++ fillStyle]
            []


viewBoardCell : Int -> Model -> Html Msg
viewBoardCell idx model =
    let
        cellContentNodes =
            case getValByIdx idx model.gameBoard of
                Nothing -> []
                Just side -> [gamePieceNode side]
    in
        td
            [
                style cellStyle,
                onClick (UserSelectsSquare idx)
            ]
            cellContentNodes



viewBoardRow : Model -> Int -> Html Msg
viewBoardRow model row =
    let
        (idx1,idx2) =
            getRowFirstLast row

        idxs =
            List.range idx1 idx2

        rowCells =
            List.map (\n -> viewBoardCell n model) idxs
    in
        tr
            [style boardRowStyle]
            rowCells

