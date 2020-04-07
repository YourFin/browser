module ContentType.Video exposing (..)

import Array exposing (Array)
import ContentType.Video.MediaTime as MediaTime exposing (MediaTime)
import Html exposing (Html)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Routing exposing (ContentId)



-- MODEL


type alias Model =
    { currentTime : MediaTime
    , volume : Float
    , duration : Maybe MediaTime
    , ephemerals : Ephemerals
    }


empty : Model
empty =
    { currentTime = MediaTime.fromFloat 0
    , volume = 1
    , duration = Nothing
    , ephemerals = {}
    }


type alias Ephemerals =
    {}



-- UPDATE


type Message
    = TimeUpdate MediaTime
    | GotLength MediaTime
    | VolumeChanged Float


update : Message -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        TimeUpdate time ->
            ( { model | currentTime = time }, Cmd.none )

        VolumeChanged vol ->
            ( { model | volume = vol }, Cmd.none )

        GotLength length ->
            ( { model | duration = Just length }, Cmd.none )



-- VIEW


view : Routing.Roots -> ContentId -> Model -> Html msg
view roots contentId model =
    Html.node "elm-video"
        -- see: src/components/elm-video.js
        [ Attr.attribute "src" <| Routing.rawUrl roots contentId
        , Attr.attribute "volume" <| String.fromFloat model.volume
        , Attr.attribute "current-time" <| MediaTime.attrString model.currentTime
        , Attr.id "video-player"
        ]
        [ Html.text "Could not load video"
        ]