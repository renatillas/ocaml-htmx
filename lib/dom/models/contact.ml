open Base

module T = struct
  type t =
    { id : int option
    ; first : string
    ; last : string
    ; phone : string
    ; email : string
    }

  let compare c1 c2 =
    match c1.id, c2.id with
    | None, Some _ -> -1
    | Some _, None -> 1
    | None, None -> String.compare c1.email c2.email
    | Some id1, Some id2 -> Int.compare id1 id2
  ;;

  let sexp_of_t t : Sexp.t =
    List
      [ Atom (Int.to_string (Option.value t.id ~default:(-1)))
      ; Atom t.first
      ; Atom t.last
      ; Atom t.phone
      ; Atom t.email
      ]
  ;;
end

include T
include Comparable.Make (T)
