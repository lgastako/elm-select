module Main exposing (main)

import Html exposing (Html, br, div, text)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (style)
import Select


type alias Model =
    { day : Day
    , direction : Direction
    , shape : Shape
    }


type Direction
    = North
    | South
    | East
    | West


type Day
    = Sunday
    | Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday


type Shape
    = Rectangle Length Width
    | Circle Radius
    | Prism Length Width Height


type alias Length =
    Float


type alias Width =
    Float


type alias Height =
    Float


type alias Radius =
    Float


type Msg
    = NewDay Day
    | NewDirection Direction
    | NewShape Shape


emptyModel : Model
emptyModel =
    { day = Friday
    , direction = North
    , shape = Circle 0.0
    }


update : Msg -> Model -> Model
update msg model =
    (case msg of
        NewDay day' ->
            { model | day = day' }

        NewDirection direction' ->
            { model | direction = direction' }

        NewShape shape' ->
            { model | shape = shape' }
    )
        |> Debug.log "update.result"


view : Model -> Html Msg
view model =
    let
        directions =
            [ North, South, East, West ]

        days =
            [ Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday ]

        shapes =
            [ Rectangle 2.0 4.0
            , Rectangle 3.0 3.0
            , Rectangle 4.0 2.0
            , Circle 1.0
            , Circle 2.0
            , Prism 1.0 2.0 3.0
            , Prism 2.0 3.0 1.0
            ]
    in
        div [ style [ ( "padding", "5rem" ) ] ]
            [ text <| "Selected direction is: " ++ toString model.direction
            , br [] []
            , Select.from directions NewDirection
            , br [] []
            , text <| "Selected day of the week is: " ++ toString model.day
            , br [] []
            , Select.from days NewDay
            , br [] []
            , text <| "Selected shape is: " ++ toString model.shape
            , br [] []
            , Select.from shapes NewShape
            ]


main : Program Never
main =
    beginnerProgram
        { model = emptyModel
        , update = update
        , view = view
        }
