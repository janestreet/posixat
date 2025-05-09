include Types

external at_fdcwd : unit -> Fd.t @@ portable = "shexp_at_fdcwd"

external fstatat
  :  dir:Fd.t
  -> path:string
  -> flags:At_flag.t list
  -> Stats.t
  @@ portable
  = "shexp_fstatat"

external readlinkat : dir:Fd.t -> path:string -> string @@ portable = "shexp_readlinkat"

include Posixat_generated

external fdopendir : Fd.t -> Unix.dir_handle @@ portable = "shexp_fdopendir"

external openat2
  :  dir:Fd.t
  -> path:string
  -> Open_how.t
  -> Fd.t
  @@ portable
  = "shexp_openat2"
