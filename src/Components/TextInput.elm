module Components.TextInput exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Types


type alias Model =
    { name : String
    , type_ : String
    , value : String
    , changed : Bool
    }


view : Model -> (String -> msg) -> Html msg
view model updateMsg =
    div []
        [ label
            [ for model.name
            , class "block text-sm font-medium text-gray-700"
            ]
            [ text model.name ]
        , div
            [ class "mt-1"
            ]
            [ input
                [ type_ model.type_
                , name model.name
                , id model.name
                , class "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                , onInput updateMsg
                ]
                []
            ]
        ]


updateValue : Model -> String -> Model
updateValue model newValue =
    { model | value = newValue, changed = True }


toInput : Model -> Types.Input
toInput model =
    Types.Input model.name model.value
