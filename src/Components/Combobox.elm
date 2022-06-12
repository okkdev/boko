module Components.Combobox exposing (..)

import Heroicons.Solid
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg.Attributes as SvgAttr


type alias Model =
    { selected : Int
    , options : List String
    , open : Bool
    }


emptyModel : Model
emptyModel =
    Model 0 [] False


view : Model -> Html msg
view model =
    div []
        [ label
            [ for "combobox"
            , class "block text-sm font-medium text-gray-700"
            ]
            [ text "Assigned to" ]
        , div
            [ class "relative mt-1"
            ]
            [ input
                [ id "combobox"
                , type_ "text"
                , class "w-full rounded-md border border-gray-300 bg-white py-2 pl-3 pr-12 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm"
                , attribute "role" "combobox"
                , attribute "aria-controls" "options"
                , attribute "aria-expanded" "false"
                ]
                []
            , button
                [ type_ "button"
                , class "absolute inset-y-0 right-0 flex items-center rounded-r-md px-2 focus:outline-none"
                ]
                [ Heroicons.Solid.selector [ SvgAttr.class "h-5 w-5 text-gray-400" ]
                ]
            , ul
                [ class "absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
                , id "options"
                , attribute "role" "listbox"
                ]
                [ {-
                     Combobox option, manage highlight styles based on mouseenter/mouseleave and keyboard navigation.

                     Active: "text-white bg-indigo-600", Not Active: "text-gray-900"
                  -}
                  li
                    [ class "relative cursor-default select-none py-2 pl-3 pr-9 text-gray-900"
                    , id "option-0"
                    , attribute "role" "option"
                    , tabindex -1
                    ]
                    [ {- Selected: "font-semibold" -}
                      span
                        [ class "block truncate"
                        ]
                        [ text "Leslie Alexander" ]
                    , {-
                         Checkmark, only display for selected option.

                         Active: "text-white", Not Active: "text-indigo-600"
                      -}
                      span
                        [ class "absolute inset-y-0 right-0 flex items-center pr-4 text-indigo-600"
                        ]
                        [ Heroicons.Solid.check [ SvgAttr.class "h-5 w-5" ]
                        ]
                    ]

                {- More items... -}
                ]
            ]
        ]
