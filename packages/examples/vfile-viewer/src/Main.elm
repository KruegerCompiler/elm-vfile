module Main exposing (main)

import Browser
import Html exposing (Html, pre, text)
import Http
import Json.Decode exposing (Value, decodeValue)
import VFile exposing (VFile)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure String
    | Loading
    | ShowingStringContent String
    | ShowingVFileContent VFile


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "vfile/hello.md/contents"
        , expect = Http.expectJson GotVFile VFile.decoder
        }
    )



-- UPDATE


type Msg
    = GotText (Result Http.Error String)
    | GotVFile (Result Http.Error VFile)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( ShowingStringContent fullText, Cmd.none )

                Err _ ->
                    ( Failure "I was unable to load the text.", Cmd.none )

        GotVFile result ->
            case result of
                Ok vfile ->
                    ( ShowingVFileContent vfile, Cmd.none )

                Err err ->
                    ( Failure (err |> Debug.toString), Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure message ->
            text message

        Loading ->
            text "Loading..."

        ShowingStringContent fullText ->
            pre [] [ text fullText ]

        ShowingVFileContent vfile ->
            let
                cwd =
                    VFile.cwd vfile
            in
            pre [] [ text cwd ]
