module Main exposing (main)

import Html exposing (Html, Attribute, br, div, option, select, text)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput)


type alias Model =
    { day : Day
    , direction : Direction
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


type Msg
    = NewDay Day
    | NewDirection Direction


emptyModel : Model
emptyModel =
    { day = Friday
    , direction = North
    }


update : Msg -> Model -> Model
update msg model =
    (case msg of
        NewDay day' ->
            { model | day = day' }

        NewDirection direction' ->
            { model | direction = direction' }
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


view : Model -> Html Msg
view model =
    let
        directions =
            [ North, South, East, West ]

        days =
            [ Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday ]

        optionize dir =
            option [ (value << toString) dir ]
                [ (text << toString) dir ]
    in
        div [ style [ ( "padding", "5rem" ) ] ]
            [ text <| "The direction is: " ++ toString model.direction
            , br [] []
            , select [ onInput (NewDirection << makeFromString' directions) ]
                (List.map optionize directions)
            , br [] []
            , text <| "The day of the week is: " ++ toString model.day
            , br [] []
            , select [ onInput (NewDay << makeFromString' days) ]
                (List.map optionize days)
            ]


main : Program Never
main =
    beginnerProgram
        { model = Debug.log "emptyModel" emptyModel
        , update = update
        , view = view
        }
