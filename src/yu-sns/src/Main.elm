module Main exposing (main)


import Browser
import Browser.Navigation as Navigation
import Url
import Html
import Html.Attributes as Attributes

import Bootstrap.Navbar as Navbar

--
-- モデル
--
-- You need to keep track of the view state for the navbar in your model
type alias Model =
    { key: Navigation.Key
    , url: Url.Url
    , bsNavState: Navbar.State
    }

--
-- メッセージ
--
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

--
-- フラグ
--
type alias Flags =
    {}






main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


--
-- init
--
-- The navbar needs to know the initial window size,
-- so the inital state for a navbar requires a command
-- to be run by the Elm runtime
init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( navbarState, navbarCmd )
            = Navbar.initialState NavbarMsg
    in
        ( Model key url navbarState, navBarCmd )


--
-- update
--
update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- 画面遷移のリクエスト
        LinkClicked urlReq ->
            case urlReq of
                -- 内部リンク
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )
                -- 外部リンク
                Browser.External href ->
                    ( model, Navigation.load href )

        -- urlが変更された時
        UrlChanged url ->
            ( { model | url = url }
            -- 本当はココで画面表示用のデータをサーバから取得する
            , Cmd.none
            )

--
-- subscriptions
--
subscriptions: Model -> Sub Msg
subscriptions _ =
    Sub.none

--
-- view
--
view: Model -> Browser.Document Msg
view model =
    { title = "Elm first spa"
    , body =
        [ Html.text "current url is: "
        , Html.b [] [ Html.text ( Url.toString model.url ) ]
        , Html.ul []
            [ Html.li [] [ Html.a [ Attributes.href "#" ] [ Html.text "home" ] ]
            , Html.li [] [ Html.a [ Attributes.href "#profile" ] [ Html.text "profile" ] ]
            , Html.li [] [ Html.a [ Attributes.href "#post/haru" ] [ Html.text "post/haru" ] ]
            ]
        ]
    }
