module Styles exposing (..)

import Html.Attributes exposing (..)

--cellStyle : List (Attribute msg)
cellStyle =
    [
        style "border" "4px ridge black"
        ,style "height" "75px"
    ]
boardRowStyle =
    [
        style "width" "100%"
    ]
fullWidthStyle =
    [
        style "width" "100%"
    ]
boardTableStyle =
    fullWidthStyle ++
    [
        style "table-layout" "fixed"
        ,style "width" "100%"
    ]
centeredStyle =
    [
        style "margin" "0 auto"
    ]
mainContainerStyle =
    centeredStyle
    ++ [
        style "min-width" "600px"
        ,style "background" "grey"
        ,style "overflow" "hidden"
        ,style "padding" "10px"
        ,style "text-align" "center"
        ,style "padding-bottom" "50px"
    ]
gamePieceStyle =
    [
        style "border-radius" "100%"
        ,style "width" "90%"
        ,style "height" "90%"
    ]
    ++ centeredStyle
scoreStyle =
    [ 
        style "margin" "10px"
        ,style "font-size" "xx-large"
    ]
    -- [
    --     style "margin" "10px",
    --     ,style "font-size" "xx-large",
    -- ]