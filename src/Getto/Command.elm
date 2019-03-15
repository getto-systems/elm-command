module Getto.Command exposing
  ( none
  , map
  , andThen
  )

{-| utility of Cmd

# Construction
@docs none

# Helper
@docs map

# Chaining
@docs andThen
 -}


{-| create 'Do nothing' command

    model |> Command.none
    -- ( model, Cmd.none )
 -}
none : model -> ( model, Cmd msg )
none model = ( model, Cmd.none )


{-| map `Cmd msg` in command tuple

    type Msg
      = Sub SubMsg

    type SubMsg
      = HelloWorld

    update : Msg -> Model -> ( Model, Cmd Msg )
    update message model =
      case message of
        Sub msg ->
          model |> updateSub msg |> Command.map Sub


    updateSub : SubMsg -> Model -> ( Model, Cmd SubMsg )
    updateSub message model =
      case message of
        HelloWorld -> ( model, Cmd.none )
 -}
map : (msg -> super) -> ( model, Cmd msg ) -> ( model, Cmd super )
map = Cmd.map >> Tuple.mapSecond


{-| merge 'Cmd msg' in command tuple

    type Msg
      = HelloWorld

    init : ( Model, Cmd Msg )
    init =
      ( (), Cmd.none )
      |> Command.andThen updateA
      |> Command.andThen updateB

    updateA : ( Model, Cmd Msg )
    updateA model = ( model, Cmd.none )

    updateB : ( Model, Cmd Msg )
    updateB model = ( model, Cmd.none )
 -}
andThen : (model -> ( model, Cmd msg )) -> ( model, Cmd msg ) -> ( model, Cmd msg )
andThen f (model,cmd) =
  model |> f |> Tuple.mapSecond (\newCmd -> [cmd,newCmd] |> Cmd.batch)
