module Main exposing (main)

import Html exposing (Html, Attribute, br, div, option, select, text)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput)


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


makeFromString : List a -> (String -> Maybe a)
makeFromString xs =
    let
        fromString s =
            let
                matches =
                    List.filter (\x -> toString x == s) xs
            in
                List.head matches
                    |> Maybe.map
                        (\match ->
                            if List.length matches > 1 then
                                Debug.crash "> 1 match in generic fromString"
                            else
                                match
                        )
    in
        fromString


makeFromString' : List a -> (String -> a)
makeFromString' xs =
    let
        fromString =
            makeFromString xs

        fromString' s =
            case fromString s of
                Nothing ->
                    Debug.crash "fromString returned Nothing in fromString'"

                Just s ->
                    s
    in
        fromString'


selectify : (a -> msg) -> List a -> Html msg
selectify msg xs =
    let
        optionize x =
            option [ (value << toString) x ]
                [ (text << toString) x ]
    in
        select [ onInput (msg << makeFromString' xs) ]
            (List.map optionize xs)


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
            , selectify NewDirection directions
            , br [] []
            , text <| "Selected day of the week is: " ++ toString model.day
            , br [] []
            , selectify NewDay days
            , br [] []
            , text <| "Selected shape is: " ++ toString model.shape
            , br [] []
            , selectify NewShape shapes
            ]


main : Program Never
main =
    beginnerProgram
        { model = Debug.log "emptyModel" emptyModel
        , update = update
        , view = view
        }
