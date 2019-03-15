module Getto.Command.Transition exposing
  ( Transition
  , Prop
  , none
  , exec
  , batch
  , prop
  , update
  , map
  , compose
  , compose2
  , compose3
  , compose4
  , compose5
  , compose6
  , compose7
  , compose8
  )

type alias Transition model msg = model -> Cmd msg

type Prop big small = Prop (Get big small) (Set big small)
type alias Get big small = big -> small
type alias Set big small = small -> big -> big

none : Transition model msg
none = always Cmd.none

exec : Transition model msg -> model -> ( model, Cmd msg )
exec f model = ( model, model |> f )

batch : List (Transition model msg) -> Transition model msg
batch list model =
  list
  |> List.map (\f -> model |> f)
  |> Cmd.batch

prop : Get big small -> Set big small -> Prop big small
prop = Prop

update : Prop big small -> (small -> ( small, msg )) -> big -> ( big, msg )
update (Prop get set) updateSmall model =
  model |> get |> updateSmall
  |> Tuple.mapFirst (\small -> model |> set small)

map : (msg -> super) -> ( model, Transition m msg ) -> ( model, Transition m super )
map super = Tuple.mapSecond (\f -> f >> Cmd.map super)

compose : (a -> model) -> ( a, Transition m msg ) -> ( model, Transition m msg )
compose model (a,msgA) = ( model a, msgA )

compose2 : (a -> b -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( model, Transition m msg )
compose2 model (a,msgA) (b,msgB) = ( model a b, [msgA,msgB] |> batch )

compose3 : (a -> b -> c -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( model, Transition m msg )
compose3 model (a,msgA) (b,msgB) (c,msgC) = ( model a b c, [msgA,msgB,msgC] |> batch )

compose4 : (a -> b -> c -> d -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( model, Transition m msg )
compose4 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) = ( model a b c d, [msgA,msgB,msgC,msgD] |> batch )

compose5 : (a -> b -> c -> d -> e -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( model, Transition m msg )
compose5 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) = ( model a b c d e, [msgA,msgB,msgC,msgD,msgE] |> batch )

compose6 : (a -> b -> c -> d -> e -> f -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( model, Transition m msg )
compose6 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) = ( model a b c d e f, [msgA,msgB,msgC,msgD,msgE,msgF] |> batch )

compose7 : (a -> b -> c -> d -> e -> f -> g -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( g, Transition m msg ) -> ( model, Transition m msg )
compose7 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) (g,msgG) = ( model a b c d e f g, [msgA,msgB,msgC,msgD,msgE,msgF,msgG] |> batch )

compose8 : (a -> b -> c -> d -> e -> f -> g -> h -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( g, Transition m msg ) -> ( h, Transition m msg ) -> ( model, Transition m msg )
compose8 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) (g,msgG) (h,msgH) = ( model a b c d e f g h, [msgA,msgB,msgC,msgD,msgE,msgF,msgG,msgH] |> batch )
