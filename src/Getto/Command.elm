module Getto.Command exposing
  ( none
  , map
  , andThen
  )

none : model -> ( model, Cmd msg )
none model = ( model, Cmd.none )

map : (msg -> super) -> ( model, Cmd msg ) -> ( model, Cmd super )
map = Cmd.map >> Tuple.mapSecond

andThen : (model -> ( model, Cmd msg )) -> ( model, Cmd msg ) -> ( model, Cmd msg )
andThen f (model,cmd) =
  model |> f |> Tuple.mapSecond (\newCmd -> [cmd,newCmd] |> Cmd.batch)
