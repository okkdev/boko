module Msg exposing (Msg(..))

import Browser
import Types exposing (..)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GetInputList
    | InputListReceived (List Input)
    | ObsConnectionReceived Bool
    | UpdateP1 String
    | UpdateScoreP1 String
    | UpdateObs (List Input)
    | Diff
    | CreateObsInputs (List String)
