module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { query : String
    , results : List SearchResult
    }


type alias SearchResult =
    { id : Int
    , name : String
    , stars : Int
    }


type Msg
    = SetQuery String
    | DeleteById Int


initialModel : Model
initialModel =
    { query = "tutorial"
    , results =
        [ { id = 1
          , name = "TheSeamau5/elm-checkerboardgrid-tutorial"
          , stars = 66
          }
        , { id = 2
          , name = "grzegorzbalcerek/elm-by-example"
          , stars = 41
          }
        , { id = 3
          , name = "sporto/elm-tutorial-app"
          , stars = 35
          }
        , { id = 4
          , name = "jvoigtlaender/Elm-Tutorium"
          , stars = 10
          }
        , { id = 5
          , name = "sporto/elm-tutorial-assets"
          , stars = 7
          }
        ]
    }


elmHubHeader : Html Msg
elmHubHeader =
    header []
        [ h1 [] [ text "ElmHub" ]
        , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ header []
            [ h1 [] [ text "ElmHub" ]
            , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
            ]
        , input
            [ class "search-query"
            , onInput SetQuery

            -- TODO onInput, set the query in the model
            , defaultValue model.query
            ]
            []
        , button [ class "search-button" ] [ text "Search" ]
        , ul [ class "results" ] (List.map viewSearchResult (List.filter (\result -> String.contains model.query result.name) model.results))

        -- gave wrong error message:
        -- , ul [ class "results" ] (List.map viewSearchResult (List.filter (\result -> result == model.query) model.results))
        -- , ul [ class "results" ] [ li [] [ List.map viewSearchResult model.results ] ]
        ]


viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
    li []
        [ span [ class "star-count" ] [ text (toString result.stars) ]
        , a [ href ("https://github.com/" ++ result.name), target "_blank" ]
            [ text result.name ]
        , button
            -- TODO add an onClick handler that sends a DeleteById msg
            [ class "hide-result"
            , onClick (DeleteById result.id)
            ]
            [ text "X" ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        DeleteById id ->
            { model | results = List.filter (\result -> result.id /= id) model.results }

        SetQuery query ->
            { model | query = query }



-- TODO if we get a SetQuery msg, use it to set the model's query field,
-- and if we get a DeleteById msg, delete the appropriate result


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
