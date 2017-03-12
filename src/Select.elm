module Select exposing (from, from_)

{-| This module provides the `from` (and more flexible `from_`) helpers to make
working with `select` elements in Elm easier.

[See full examples in github](https://github.com/lgastako/elm-select/blob/master/src/Main.elm)

# Helpers
@docs from, from_

-}

import Html exposing (Html, option, select, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


{-| Convert a list of values and stringifying function for values of that type
into a `select` element which contains as it's values the list of values.

    from [North, South, East, West] Direction

would produce a select element with box option values and labels being the
string versions of four cardinal directions and which would send messages like
`Direction North` or `Direction East` when the user selects new directions from
the drop down.

-}
from : List a -> (a -> msg) -> Html msg
from xs msg =
    from_ xs msg toString toString


{-| Convert a list of values and stringifying function for values of that type
into a `select` element which contains as it's values the list of values.

    from_ [North, South, East, West] Direction toId toLabel

like the `from` example above, this would produce a select element with box
option values and labels being derived from the four cardinal directions and
which would send messages like `Direction North` or `Direction East` when the
user selects new directions from the drop down only the ids and labels would be
derived using the `toId` and `toLabel` functions provided instead of defaulting
to `toString` like `from`.

-}
from_ : List a -> (a -> msg) -> (a -> String) -> (a -> String) -> Html msg
from_ xs msg toId toLabel =
    let
        optionize x =
            option [ (value << toId) x ]
                [ (text << toLabel) x ]
    in
        select [ onInput (msg << makeFromString_ xs) ]
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


makeFromString_ : List a -> (String -> a)
makeFromString_ xs =
    let
        fromString =
            makeFromString xs

        fromString_ s =
            case fromString s of
                Nothing ->
                    Debug.crash "fromString returned Nothing in fromString_"

                Just s ->
                    s
    in
        fromString_
