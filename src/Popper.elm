module Popper exposing
    ( config, withTooltip
    , withModifier, withOffset, withPlacement, withStrategy
    , Placement(..), Strategy(..), Modifier
    )

{-| This module contains everything you need to use [Popper.js](https://popper.js.org/) for tooltips in your Elm code. See the README.md
for some additional setup needed.


# Main Utilities

@docs config, withTooltip


# Configuration

@docs withModifier, withOffset, withPlacement, withStrategy


# Configuration Types

@docs Modifier, Placement, Strategy

-}

import Html exposing (Attribute, Html)
import Html.Attributes exposing (attribute)
import Json.Encode as Encode


{-| Configuration for custom modifiers to be added via `withModifier`
-}
type alias Modifier =
    { name : String
    , options : Maybe Encode.Value
    , data : Maybe Encode.Value
    }


modifiersToAttribute : List Modifier -> Attribute msg
modifiersToAttribute =
    Encode.list
        (\modifier ->
            Encode.object
                [ ( "name", Encode.string modifier.name )
                , ( "options", Maybe.withDefault Encode.null modifier.options )
                , ( "data", Maybe.withDefault Encode.null modifier.data )
                ]
        )
        >> Encode.encode 0
        >> attribute "data-modifiers"


{-| The [placement](https://popper.js.org/docs/v2/constructors/#placement) configuration value.
-}
type Placement
    = Auto
    | AutoStart
    | AutoEnd
    | Top
    | TopStart
    | TopEnd
    | Bottom
    | BottomStart
    | BottomEnd
    | Right
    | RightStart
    | RightEnd
    | Left
    | LeftStart
    | LeftEnd


placementToAttribute : Placement -> Attribute msg
placementToAttribute placement =
    attribute "data-placement" <|
        case placement of
            Auto ->
                "auto"

            AutoStart ->
                "auto-start"

            AutoEnd ->
                "auto-end"

            Top ->
                "top"

            TopStart ->
                "top-start"

            TopEnd ->
                "top-end"

            Bottom ->
                "bottom"

            BottomStart ->
                "bottom-start"

            BottomEnd ->
                "bottom-end"

            Right ->
                "right"

            RightStart ->
                "right-start"

            RightEnd ->
                "right-end"

            Left ->
                "left"

            LeftStart ->
                "left-start"

            LeftEnd ->
                "left-end"


{-| The placement strategy to be used by the tooltip. The default is `Absolute`.
An `Absolute` tooltip will more smoothly follow the element it is attached to, but is
more beholden to your page layout. `Fixed` should more predictably follow the element but there
may be some jumpiness as popper manually moves the tooltip.
-}
type Strategy
    = Absolute
    | Fixed


strategyToAttribute : Strategy -> Attribute msg
strategyToAttribute strategy =
    attribute "data-strategy" <|
        case strategy of
            Absolute ->
                "absolute"

            Fixed ->
                "fixed"


type alias Config =
    { tooltipId : String
    , placement : Placement
    , strategy : Strategy
    , modifiers : List Modifier
    }


{-| Create a configuration for your tooltip that may then be added to an html element via `withTooltip`.
The only required argument is the `id` attribute of the tooltip that should be referenced.
-}
config : String -> Config
config tooltipId =
    { tooltipId = tooltipId
    , placement = Auto
    , strategy = Absolute
    , modifiers = []
    }


{-| Configure the [placement](https://popper.js.org/docs/v2/constructors/#placement) of the tooltip. Note that popperjs will
detect when your placement causes it to flow off the screen and alter the placement accordingly.
-}
withPlacement : Placement -> Config -> Config
withPlacement placement cfg =
    { cfg | placement = placement }


{-| Configure the [strategy](https://popper.js.org/docs/v2/constructors/#strategy) of the tooltip. Either fixed or absolute.
-}
withStrategy : Strategy -> Config -> Config
withStrategy strategy cfg =
    { cfg | strategy = strategy }


{-| Add a custom modifier, or any modifier that may not have a helper method associated with it here.
Modifiers that you may add are [documented here](https://popper.js.org/docs/v2/modifiers/).
Modifiers have a name, and usually an `options` and/or `data` field. A good example is the `withOffset` function

    withOffset ( skidding, distance ) =
        withModifier
            { name = "offset"
            , data = Nothing
            , options =
                Just <|
                    Encode.object
                        [ ( "offset", Encode.list Encode.float [ skidding, distance ] )
                        ]
            }

-}
withModifier : Modifier -> Config -> Config
withModifier modifier cfg =
    { cfg
        | modifiers = modifier :: cfg.modifiers
    }


{-| Adds the [offset modifier](https://popper.js.org/docs/v2/modifiers/offset/#offset-1) to the tooltip.
The two floats represent skidding and distance
-}
withOffset : ( Float, Float ) -> Config -> Config
withOffset ( skidding, distance ) =
    withModifier
        { name = "offset"
        , data = Nothing
        , options =
            Just <|
                Encode.object
                    [ ( "offset", Encode.list Encode.float [ skidding, distance ] )
                    ]
        }


{-| Add a tooltip to a piece of html
-}
withTooltip : Html msg -> Config -> Html msg
withTooltip element cfg =
    Html.node
        "popper-container"
        [ attribute "data-tooltip-id" cfg.tooltipId
        , placementToAttribute cfg.placement
        , strategyToAttribute cfg.strategy
        , modifiersToAttribute cfg.modifiers
        ]
        [ element ]
