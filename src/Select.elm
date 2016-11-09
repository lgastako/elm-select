module Select exposing (from, from')

{-| This module provides the `Select.from` helper make working with `select`
elements from Elm easier.

# Helpers
@docs from, from'

-}

import Html exposing (Html, option, select, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


{-| Convert a list of values and stringifying function for values of that type
into a `select` element which contains as it's values the list of values.

    from [North, South, East, West] Direction

would produce a select element with box option values and labels being the
string versions of four cardinal directions which would send messages
like (Direction North) or (Direction East) when the user selects new directions
from the drop down.

-}
from : List a -> (a -> msg) -> Html msg
from xs msg =
    from' xs msg toString toString


{-| Convert a list of values and stringifying function for values of that type
into a `select` element which contains as it's values the list of values.

    from' [North, South, East, West] Direction toId toLabel

would produce a select element with box option values and labels being decided
by the `toId` and `toLabel` functions, which would send messages
like (Direction North) or (Direction East) when the user selects new directions
from the drop down.

-}
from' : List a -> (a -> msg) -> (a -> String) -> (a -> String) -> Html msg
from' xs msg toId toLabel =
    let
        optionize x =
            option [ (value << toId) x ]
                [ (text << toLabel) x ]
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
