module Select exposing (from)

import Html exposing (Html, option, select, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


from : List a -> (a -> msg) -> Html msg
from xs msg =
    let
        optionize x =
            option [ (value << toString) x ]
                [ (text << toString) x ]
    in
        select [ onInput (msg << makeFromString' xs) ]
            (List.map optionize xs)


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
