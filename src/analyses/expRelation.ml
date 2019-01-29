(** An analysis specification to answer questions about how two expressions relate to each other. *)
(** Currently this works purely statically on the expressions, but at a later stage, this analysis *)
(** can be improved to perform more involved things *)
open Prelude.Ana
open Analyses

module Spec : Analyses.Spec =
struct
  include Analyses.DefaultSpec
  module D = Lattice.Unit
  module G = Lattice.Unit
  module C = Lattice.Unit

  let name = "expRelation"


  let query ctx (q:Queries.t) : Queries.Result.t =
  match q with
  | Queries.MustBeEqual (e1, e2) ->
      begin
        Printf.printf "---------------------->   comparing %s and %s \n" (ExpDomain.short 20 (`Lifted e1)) (ExpDomain.short 20 (`Lifted e2));
        `Bool (Expcompare.compareExp e1 e2)
      end
  | _ -> Queries.Result.top ()


  (* below here is all the usual stuff an analysis requires, we don't do anything here *)
  (* transfer functions *)
  let assign ctx (lval:lval) (rval:exp) : D.t =
    ctx.local

  let branch ctx (exp:exp) (tv:bool) : D.t =
    ctx.local

  let body ctx (f:fundec) : D.t =
    ctx.local

  let return ctx (exp:exp option) (f:fundec) : D.t =
    ctx.local

  let enter ctx (lval: lval option) (f:varinfo) (args:exp list) : (D.t * D.t) list =
    [ctx.local, ctx.local]

  let combine ctx (lval:lval option) fexp (f:varinfo) (args:exp list) (au:D.t) : D.t =
    au

  let special ctx (lval: lval option) (f:varinfo) (arglist:exp list) : D.t =
    ctx.local

  let startstate v = D.bot ()
  let otherstate v = D.top ()
  let exitstate  v = D.top ()
end

let _ =
  MCP.register_analysis (module Spec : Spec)