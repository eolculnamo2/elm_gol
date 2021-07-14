module Pages.Home_ exposing (view)

import Html exposing (..)
import Html.Attributes exposing (href)
import View exposing (View)


view : View msg
view =
    { title = "Homepage"
    , body =
        [ h1 [] [ text "Elm GOL" ]
        , h3 [] [ text "What is the game of life?" ]
        , p [] [ text "The game of life is a cellular automation. Given simple rules, cells live and die through each iteration" ]
        , p [] [ text "Whenever I learn a new UI language/framework, I like to build the Game of Life with it." ]
        , div []
            [ a [ href "/gol" ] [ text "Click here " ]
            , span [] [ text "to see the Conways Game of Life" ]
            ]
        ]
    }
