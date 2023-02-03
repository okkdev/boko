port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Components.Combobox as Combobox
import Components.TextInput as TextInput
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as D
import Msg exposing (Msg(..))
import Types exposing (..)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- PORTS


port getInputListMessage : () -> Cmd msg


port setInputsMessage : List Input -> Cmd msg


port inputListReceiver : (List Input -> msg) -> Sub msg


port obsConnectionReceiver : (Bool -> msg) -> Sub msg



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , obsConnected : Bool
    , inputs : List Input
    , comboboxP1 : Combobox.Model
    , textInputP1 : TextInput.Model
    , scoreInputP1 : TextInput.Model
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , url = url
      , obsConnected = False
      , inputs = []
      , comboboxP1 = Combobox.emptyModel
      , textInputP1 = TextInput.Model "NameP1" "text" "" False
      , scoreInputP1 = TextInput.Model "ScoreP1" "number" "" False
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        ObsConnectionReceived status ->
            ( { model | obsConnected = status }
            , Cmd.none
            )

        GetInputList ->
            ( model
            , getInputListMessage ()
            )

        CreateObsInputs inputs ->
            ( model
            , Cmd.none
            )

        InputListReceived inputs ->
            ( { model | inputs = inputs }
            , Cmd.none
            )

        UpdateP1 newValue ->
            ( { model | textInputP1 = TextInput.updateValue model.textInputP1 newValue }
            , Cmd.none
            )

        UpdateScoreP1 newValue ->
            ( { model | scoreInputP1 = TextInput.updateValue model.scoreInputP1 newValue }
            , Cmd.none
            )

        UpdateObs newInputs ->
            if model.obsConnected then
                ( model, setInputsMessage newInputs )

            else
                -- TODO: Print some error message
                ( model, Cmd.none )

        Diff ->
            -- TODO: Diff the inputs and show if bokoinput changed
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ obsConnectionReceiver ObsConnectionReceived
        , inputListReceiver InputListReceived
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.url.path of
        "/" ->
            home model

        "/settings" ->
            settings model

        _ ->
            { title = "Page not found"
            , body = [ text "404" ]
            }


home : Model -> Browser.Document Msg
home model =
    { title = "Boko - Home"
    , body =
        [ div [ class "flex justify-center items-center h-screen" ]
            [ div [] 
                [ button [ onClick GetInputList, class "bg-red-400" ] [ text "get inputs" ],
                a [ href "/settings", class "inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" ] [ text "settings" ]
                , text <| Debug.toString model.inputs
                , div []
                    [ TextInput.view model.scoreInputP1 UpdateScoreP1
                    , TextInput.view model.textInputP1 UpdateP1
                    ]
                , div []
                    [ button
                        [ type_ "button"
                        , onClick <| UpdateObs [ TextInput.toInput model.textInputP1 ]
                        , class "inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        ]
                        [ text "Update OBS" ]
                    ]
                ]
            ]
        ]
    }


settings : Model -> Browser.Document Msg
settings model =
    { title = "Boko - Settings"
    , body =
        [ button
            [ type_ "button"
            , onClick <| CreateObsInputs allInputs
            , class "inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            ]
            [ text "Create OBS Inputs" ]
        ]
    }



-- decodeInputs : D.Decoder (List Input)
-- decodeInputs =
--     D.list decodeInput
-- decodeInput : D.Decoder Input
-- decodeInput =
--     D.map2 Input
--         (D.field "name" D.string)
--         (D.field "text" D.string)


allInputs : List String
allInputs =
    []
