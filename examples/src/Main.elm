module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import Popper


tooltipClass : String
tooltipClass =
    "tooltip"


basicExample : Html msg
basicExample =
    let
        tooltipId =
            "basic-example-tooltip"
    in
    Html.div
        []
        [ Html.div
            [ Attributes.id tooltipId
            , Attributes.class tooltipClass
            ]
            [ Html.text "I am a tooltip that describes the button!"
            ]
        , Popper.config tooltipId
            |> Popper.withStrategy Popper.Fixed
            |> Popper.withPlacement Popper.Top
            |> Popper.withOffset ( 0, 8 )
            |> Popper.withTooltip
                (Html.button
                    [ Attributes.id "my-button"
                    ]
                    [ Html.text "I have a tooltip!" ]
                )
        ]


main : Html msg
main =
    List.map (List.singleton >> Html.div [ Attributes.class "example" ])
        [ basicExample
        ]
        |> Html.div []
