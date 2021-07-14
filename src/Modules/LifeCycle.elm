module Modules.LifeCycle exposing (..)

import Array exposing (Array)
import Utils.SharedTypes exposing (Cell)


getNeighborIndexes : Int -> Int -> Array Int
getNeighborIndexes cellsWide cellIndex =
    [ -- left
      cellIndex - 1
    , -- right
      cellIndex + 1

    -- top left
    , cellIndex - cellsWide + 1 -- todo replace with number based on cell width

    -- top
    , cellIndex - cellsWide

    -- top right
    , cellIndex - cellsWide - 1

    -- bottom left
    , cellIndex + cellsWide - 1

    -- bottom
    , cellIndex + cellsWide

    -- bottom right
    , cellIndex + cellsWide + 1
    ]
        |> List.filter
            (\n -> n >= 0)
        |> Array.fromList


resolveNeighborStatus : Array Cell -> Int -> Bool
resolveNeighborStatus allCells neighborIndex =
    case allCells |> Array.get neighborIndex of
        Nothing ->
            False

        Just cell ->
            cell.alive



-- Any live cell with two or three live neighbours survives.
-- Any dead cell with three live neighbours becomes a live cell.
-- All other live cells die in the next generation. Similarly, all other dead cells stay dead.


cellLiveOrDieScenarios : Bool -> Array Bool -> Bool
cellLiveOrDieScenarios currentCellState neighborStates =
    let
        liveNeighbors =
            Array.foldl
                (\c agg ->
                    -- iterated value and aggregator are reversed of JS
                    if c then
                        agg + 1

                    else
                        agg
                )
                0
                neighborStates
    in
    if (liveNeighbors == 2 || liveNeighbors == 3) && currentCellState == True then
        True

    else if currentCellState == False && liveNeighbors == 3 then
        True

    else
        False


cellShouldLive : Cell -> Array Cell -> Array Int -> Bool
cellShouldLive cell allCells cellNeighbors =
    cellNeighbors
        |> Array.map (\n -> resolveNeighborStatus allCells n)
        |> cellLiveOrDieScenarios cell.alive


resolveNewCell : Cell -> Bool -> Cell
resolveNewCell cell alive =
    { alive = alive, id = cell.id }


newCellState : Int -> Cell -> Int -> Array Cell -> Cell
newCellState index cell cellsWide cellsList =
    index
        |> getNeighborIndexes cellsWide
        |> cellShouldLive cell cellsList
        |> resolveNewCell cell


lifeCycleCells : Array Cell -> Int -> Array Cell
lifeCycleCells cells cellsWide =
    cells |> Array.map (\c -> newCellState c.id c cellsWide cells)
