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
        mainContainerStyle
        [
            h1 [] [text "Reversi"]
            ,scoreboard model
            ,boardTable model
        ]


scoreboard : Model -> Html Msg
scoreboard model =
    let
        lastclickedstate = 
            case model.lastClickedCellState of
                Just PlayerSide1 -> "Player1"
                Just PlayerSide2 -> "Player2"
                Nothing -> "Empty"

        lastclickwasvalid = if model.lastClickWasValid then "Yes" else "No"

        (sc1,sc2) =
            getScore model.gameBoard
    in
        case model.gameState  of
            Normal ->
                div [] [
                    span scoreStyle [text <| "Player1: " ++ (String.fromInt sc1)]
                    ,span scoreStyle [text <| "Player2: " ++ (String.fromInt sc2)]
                    ,span scoreStyle [text <| "Last Clicked: " ++ (String.fromInt model.lastClicked)]
                    ,span scoreStyle [text <| "LastClickedState: " ++ lastclickedstate ]
                    ,span scoreStyle [text <| "LastClickWasValid: " ++ lastclickwasvalid ]
                ] 

            GameOver ->
                div [] [
                    h3 [] [text <| (gamestatestring model.gameState)]
                    ,span scoreStyle [text <| "Player1: " ++ (String.fromInt sc1)]
                    ,span scoreStyle [text <| "Player2: " ++ (String.fromInt sc2)]
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
            boardTableStyle
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
            [ style "background" background ]

        bothStyle =
            gamePieceStyle ++ fillStyle
    in
        div
            bothStyle
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
            (cellStyle ++ [ onClick (UserSelectsSquare idx) ])
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
            boardRowStyle
            rowCells

