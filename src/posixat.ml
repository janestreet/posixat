include Types

external at_fdcwd : unit -> Fd.t @@ portable = "shexp_at_fdcwd"

external fstatat
  :  dir:Fd.t
  -> path:string @ local
  -> flags:At_flag.t list @ local
  -> Stats.t
  @@ portable
  = "shexp_fstatat"

external readlinkat
  :  dir:Fd.t
  -> path:string @ local
  -> string
  @@ portable
  = "shexp_readlinkat"

include Posixat_generated

external fdopendir : Fd.t -> Unix.dir_handle @@ portable = "shexp_fdopendir"

external openat2
  :  dir:Fd.t
  -> path:string @ local
  -> Open_how.t @ local
  -> Fd.t
  @@ portable
  = "shexp_openat2"
