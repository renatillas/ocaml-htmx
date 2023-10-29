open Base

type t =
  { id : int option
  ; first : string
  ; last : string
  ; phone : string
  ; email : string
  }

include Comparable.S with type t := t
