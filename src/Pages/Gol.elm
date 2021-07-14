module Pages.Gol exposing (Model, Msg, page)

import Array exposing (Array)
import Gen.Params.Gol exposing (Params)
import Html exposing (..)
import Html.Attributes exposing (style)
import Modules.LifeCycle exposing (lifeCycleCells)
import Page
import Random
import Request
import Shared
import Task
import Time
import Utils.SharedTypes exposing (Cell)
import View exposing (View)



-- dimensions


cellSize : Int
cellSize =
    13


cellSizePx : String
cellSizePx =
    String.fromInt cellSize ++ "px"


cellsHigh : Int
cellsHigh =
    50


cellsWide : Int
cellsWide =
    50


cellsArea : Int
cellsArea =
    cellsHigh * cellsWide


gridWidth : String
gridWidth =
    String.fromInt (cellSize * cellsWide + cellsWide + 1) ++ "px"



--   let gridWidth = (cellsWide * cellWidth + cellsWide + 1) -> Belt.Int.toString ++ "px"


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { cells : Array Cell }


init : ( Model, Cmd Msg )
init =
    ( { cells = Array.empty }
    , Task.succeed AppInit
        |> Task.perform identity
    )



-- ^^^^^^ may want to rethink the Cmd Msg portion of this at the recommendation of this article:
-- https://medium.com/elm-shorts/how-to-turn-a-msg-into-a-cmd-msg-in-elm-5dd095175d84
-- UPDATE


type Msg
    = AppInit
    | InitializeArray (List Int)
    | LifeCycled Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AppInit ->
            ( model
              -- todo random booleans would be better
            , Random.generate InitializeArray (Random.list cellsArea (Random.int 0 1))
            )

        InitializeArray randomArr ->
            ( { model | cells = randomArr |> Array.fromList |> Array.indexedMap (\i n -> { alive = n == 1, id = i }) }, Cmd.none )

        LifeCycled _ ->
            ( { model | cells = lifeCycleCells model.cells cellsWide }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 100 LifeCycled



-- VIEW


buildCellsArray : Array Cell -> List (Html msg)
buildCellsArray cellsArr =
    cellsArr
        |> Array.map cellView
        |> Array.toList


gridView : Array Cell -> Html msg
gridView cellsArr =
    div [ style "display" "grid", style "gap" "1px", style "background-color" "#333", style "box-sizing" "border-box", style "width" gridWidth, style "grid-template-columns" ("repeat(" ++ String.fromInt cellsWide ++ ",1fr)") ]
        (buildCellsArray cellsArr)


cellColor : Bool -> String
cellColor isAlive =
    if isAlive then
        "green"

    else
        "#999"


cellView : Cell -> Html msg
cellView cell =
    div [ style "background-color" (cellColor cell.alive), style "width" cellSizePx, style "height" cellSizePx ] []


view : Model -> View Msg
view model =
    { title = "Game of Life!"
    , body =
        [ gridView model.cells
        ]
    }
