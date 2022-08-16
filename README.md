# Elm Popper

A simple wrapper around [popper.js](https://popper.js.org/) to make including tooltips in your Elm application quick and easy.

# Installation

Include the **popper-container.min.js** at the root of this repository
on your application's page to register the necessary `popper-container` custom element.

# Basic Usage

```
import Html 
import Html.Attributes as Attributes
import Popper

basicExample : Html msg
basicExample =
    Html.div
        []
        [ Html.div
            [ Attributes.id "basic-example-tooltip"
            , Attributes.class "tooltip"
            ]
            [ Html.text "I am a tooltip that describes the button!"
            ]
        , Popper.config tooltipId
            |> Popper.withTooltip
                (Html.button [] [ Html.text "I have a tooltip!" ])
        ]
```

Tooltips need additional styling to toggle visibility. Give your tooltip a class and
add some simple styles to handle this.

```
.tooltip {
    visibility: hidden;
}

.tooltip[data-show="true"] {
    visibility: visible;
}
```

For accessibility purposes consider clipping the tooltip instead of toggling visibility.

## Additional Features

Any descendent element of your tooltip that has the `data-tooltip-close` attribute may be clicked to close the tooltip.