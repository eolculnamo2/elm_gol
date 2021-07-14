module Utils.SharedTypes exposing (..)

--  mainly to avoid circular depedencies


type alias Cell =
    { alive : Bool
    , id : Int
    }
