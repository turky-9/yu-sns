module Main exposing (main)


import Browser
import Browser.Navigation as Navigation
import Url
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Url.Parser as UrlParser
import Bootstrap.Navbar as Navbar

--
-- モデル
--
-- You need to keep track of the view state for the navbar in your model
type alias Model =
    { key: Navigation.Key
    , page: Page
    , pageData: PageData
    , url: Url.Url
    , bsNavState: Navbar.State
    }

type Page
    = Login
    | Home
    | NotFound

type PageData = PageDataLogin DataLogin

type alias DataLogin =
    { userid: String
    , password: String
    }

--
-- メッセージ
--
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NavMsg Navbar.State
    | InputUserId String
    | InputPassword String
    | SubmitLogin

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
            = Navbar.initialState NavMsg
        ( model, urlCmd ) =
            urlUpdate url
                { key = key
                , url = url
                , bsNavState = navbarState
                , page = Login
                , pageData = PageDataLogin
                    { userid = ""
                    , password = ""
                    }
                }
    in
        ( model, Cmd.batch [ urlCmd, navbarCmd] )


--
-- subscriptions
--
subscriptions: Model -> Sub Msg
subscriptions _ =
    Sub.none

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

        -- bootstrapのnavbarの何か
        NavMsg state ->
            ( { model | bsNavState = state }
            , Cmd.none
            )

        InputUserId uid ->
            case model.pageData of
                PageDataLogin dlog ->
                    ( { model | pageData = PageDataLogin ( DataLogin uid dlog.password ) }
                    , Cmd.none
                    )
        InputPassword pass ->
            case model.pageData of
                PageDataLogin dlog ->
                    ( { model | pageData = PageDataLogin ( DataLogin dlog.userid pass ) }
                    , Cmd.none
                    )
        _ -> ( model, Cmd.none )

--
-- view
--
view: Model -> Browser.Document Msg
view model =
    { title = "Elm first spa"
    , body =
        [ 
         Html.text "current url is: "
        , Html.b [] [ Html.text ( Url.toString model.url ) ]
        , render model
        ]
    }
{-
        , Html.ul []
            [ Html.li [] [ Html.a [ Attributes.href "#" ] [ Html.text "home" ] ]
            , Html.li [] [ Html.a [ Attributes.href "#profile" ] [ Html.text "profile" ] ]
            , Html.li [] [ Html.a [ Attributes.href "#post/haru" ] [ Html.text "post/haru" ] ]
            ]
-}

--
-- Renderer
--
render: Model -> Html.Html Msg
render model =
    Html.div []
        (case model.page of
            Login ->
                renderLogin model
            Home ->
                renderHome model
            NotFound ->
                renderNotFound model)

renderLogin: Model -> List ( Html.Html Msg )
renderLogin model =
    case model.pageData of
        PageDataLogin dlog ->
            [ Html.input [ Attributes.type_ "text", Attributes.value dlog.userid, Events.onInput InputUserId ] []
            , Html.text dlog.userid
            , Html.br [] []
            , Html.input [ Attributes.type_ "password" , Attributes.value dlog.password, Events.onInput InputPassword] []
            , Html.text dlog.password
            , Html.br [] []
            , Html.button [] [ Html.text "login" ]
            ]
--        _ ->
--            [ Html.text "WTG" ]

renderHome: Model -> List ( Html.Html Msg )
renderHome model =
    [ Html.div [] [ Html.text "WebCome!!" ]
    ]

renderNotFound: Model -> List ( Html.Html Msg )
renderNotFound model =
    [ Html.div [] [ Html.text "Not Found..." ]
    ]

--
-- Others
--
urlUpdate : Url.Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )

decode : Url.Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    |> UrlParser.parse routeParser

routeParser : UrlParser.Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Login UrlParser.top
        , UrlParser.map Home (UrlParser.s "home")
        ]
