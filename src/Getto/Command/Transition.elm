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

{-| utility fo `model -> Cmd msg`

# Definition
@docs Transition, Prop

# Construction
@docs none, prop

# Apply
@docs exec, update

# Helpers
@docs batch, map, compose, compose2, compose3, compose4, compose5, compose6, compose7, compose8
 -}


{-| function of generate `Cmd msg` from model
 -}
type alias Transition model msg = model -> Cmd msg


{-| set of getter (big -> small) and setter (small -> big -> big)
 -}
type Prop big small = Prop (Get big small) (Set big small)
type alias Get big small = big -> small
type alias Set big small = small -> big -> big


{-| create 'Do nothing' Transition
 -}
none : Transition model msg
none = always Cmd.none


{-| execute Transition

    model |> Transition.exec Transition.none
    -- ( model, Cmd.none )
 -}
exec : Transition model msg -> model -> ( model, Cmd msg )
exec f model = ( model, model |> f )


{-| batch Transition

    [ Transition.none
    , Transition.none
    ] |> Transition.batch
 -}
batch : List (Transition model msg) -> Transition model msg
batch list model =
  list
  |> List.map (\f -> model |> f)
  |> Cmd.batch


{-| construct Prop from getter and setter

    type alias Model =
      { name : String
      }

    name_ = Transition.prop .name (\v m -> { m | name = v })
 -}
prop : Get big small -> Set big small -> Prop big small
prop = Prop


{-| update small that described by Prop

    type alias Model =
      { sub : String
      }

    sub_ = Transition.prop .sub (\v m -> { m | sub = v })

    updateSub model = ( model ++ ", world", Transition.none )

    { sub = "hello" } |> Transition.update sub_ updateSub
    -- ( { sub = "hello, world" }, Transition msg )
 -}
update : Prop big small -> (small -> ( small, msg )) -> big -> ( big, msg )
update (Prop get set) updateSmall model =
  model |> get |> updateSmall
  |> Tuple.mapFirst (\small -> model |> set small)


{-| map ( model, Transition ) tuple

    type Msg
      = Sub SubMsg

    updateSub : model -> ( model, Transition model SubMsg )

    model |> updateSub |> Transition.map Sub
    -- ( model, Transition model Msg )
 -}
map : (msg -> super) -> ( model, Transition m msg ) -> ( model, Transition m super )
map super = Tuple.mapSecond (\f -> f >> Cmd.map super)


{-| compose ( model, Transition ) tuples

    type alias Model =
      { sub : SubModel
      }

    Transition.compose
      Model
        ( subModel, Transition.none )
 -}
compose : (a -> model) -> ( a, Transition m msg ) -> ( model, Transition m msg )
compose model (a,msgA) = ( model a, msgA )


{-| compose ( model, Transition ) tuples

    type alias Model =
      { sub   : SubModel
      , other : OtherModel
      }

    Transition.compose
      Model
        ( subModel,   Transition.none )
        ( otherModel, Transition.none )
 -}
compose2 : (a -> b -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( model, Transition m msg )
compose2 model (a,msgA) (b,msgB) = ( model a b, [msgA,msgB] |> batch )


{-| compose with 3 args -}
compose3 : (a -> b -> c -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( model, Transition m msg )
compose3 model (a,msgA) (b,msgB) (c,msgC) = ( model a b c, [msgA,msgB,msgC] |> batch )


{-| compose with 4 args -}
compose4 : (a -> b -> c -> d -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( model, Transition m msg )
compose4 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) = ( model a b c d, [msgA,msgB,msgC,msgD] |> batch )


{-| compose with 5 args -}
compose5 : (a -> b -> c -> d -> e -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( model, Transition m msg )
compose5 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) = ( model a b c d e, [msgA,msgB,msgC,msgD,msgE] |> batch )


{-| compose with 6 args -}
compose6 : (a -> b -> c -> d -> e -> f -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( model, Transition m msg )
compose6 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) = ( model a b c d e f, [msgA,msgB,msgC,msgD,msgE,msgF] |> batch )


{-| compose with 7 args -}
compose7 : (a -> b -> c -> d -> e -> f -> g -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( g, Transition m msg ) -> ( model, Transition m msg )
compose7 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) (g,msgG) = ( model a b c d e f g, [msgA,msgB,msgC,msgD,msgE,msgF,msgG] |> batch )


{-| compose with 8 args -}
compose8 : (a -> b -> c -> d -> e -> f -> g -> h -> model) -> ( a, Transition m msg ) -> ( b, Transition m msg ) -> ( c, Transition m msg ) -> ( d, Transition m msg ) -> ( e, Transition m msg ) -> ( f, Transition m msg ) -> ( g, Transition m msg ) -> ( h, Transition m msg ) -> ( model, Transition m msg )
compose8 model (a,msgA) (b,msgB) (c,msgC) (d,msgD) (e,msgE) (f,msgF) (g,msgG) (h,msgH) = ( model a b c d e f g h, [msgA,msgB,msgC,msgD,msgE,msgF,msgG,msgH] |> batch )
