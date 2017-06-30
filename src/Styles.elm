module Styles exposing (..)

cellStyle =
    [
        ("border","4px ridge black")
        ,("height","75px")
    ]
boardRowStyle =
    [
        ("width","100%")
    ]
fullWidthStyle =
    [
        ("width","100%")
    ]
boardTableStyle =
    fullWidthStyle ++
    [
        ("table-layout","fixed")
        ,("width","100%")
    ]
centeredStyle =
    [
        ("margin","0 auto")
    ]
mainContainerStyle =
    centeredStyle
    ++ [
        ("min-width","600px")
        ,("background","grey")
        ,("overflow","hidden")
        ,("padding","10px")
        ,("text-align","center")
        ,("padding-bottom","50px")
    ]
gamePieceStyle =
    [
        ("border-radius","100%")
        ,("width","90%")
        ,("height","90%")
    ]
    ++ centeredStyle
scoreStyle =
    [
        ("margin","10px")
        ,("font-size","xx-large")
    ]