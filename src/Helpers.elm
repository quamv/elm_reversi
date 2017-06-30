module Helpers exposing (..)

{- system imports -}
import Array exposing (..)
import Char exposing (toCode, fromCode)
import Model exposing (..)


{-
set the state of a square at the given raw index
-}
setSquareState : Int -> Maybe SquareState -> GameBoard -> GameBoard
setSquareState idx squarestate board =
    Array.set idx squarestate board


{-
TODO: do this however is the right way
sets multiple elements of an array
-}
setMany : GameBoard -> List Int -> SquareState -> GameBoard
setMany board idxs newstate =
    Array.indexedMap
        (\idx val ->
            if List.member idx idxs then
                -- this index is in our list of indexes. update the value
                Just newstate
            else
                -- idx not in our list of indexes. use the existing value
                val)
        board


{-
square state retrieval function. we have a case of overloaded semantic
meaning here. a 'Nothing' can mean either that the value stored at the
idx defined by row,col is Nothing, OR it can mean that row,col is
outside the range of the array. this helper just cleans that up a bit for
callers. it still has the semantic lack of clarity, just makes
this process a bit less verbose.
-}
getSquareState : Int -> Int -> GameBoard -> Maybe SquareState
getSquareState row col board =
    case Array.get (row * cols + col) board of
        Nothing ->
            Nothing

        Just mbval ->
            case mbval of
                Nothing -> Nothing
                Just val -> Just val


{-
helper to get the value stored at a given index rather than row,col
-}
getValByIdx : Int -> GameBoard -> Maybe SquareState
getValByIdx idx board =
    let
        (row,col) =
            toRowCol idx
    in
        getSquareState row col board


{-
create a board (an array) with the given number of rows and columns
-}
newBoard : Int -> Int -> GameBoard
newBoard boardrows boardcols  =
    Array.repeat (rows * cols) Nothing


{-
swap PlayerSide1->PlayerSide2 and vice versa
-}
togglePlayer : PlayerSide -> PlayerSide
togglePlayer player =
    case player of
        PlayerSide1 -> PlayerSide2
        PlayerSide2 -> PlayerSide1


{-
extract the row and column indexes from a raw index
-}
toRowCol : Int -> (Int, Int)
toRowCol idx =
    (idx // cols, rem idx cols)


{-
get the first and last indexes of the row at idx
-}
getRowFirstLastByIdx : Int -> (Int, Int)
getRowFirstLastByIdx idx =
    getRowFirstLast (idx // cols)


{-
get the first and last indexes of the row
-}
getRowFirstLast : Int -> (Int, Int)
getRowFirstLast row =
    (
        row * cols,
        ((row+1) * cols) - 1
    )

