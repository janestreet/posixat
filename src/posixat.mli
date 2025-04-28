(** Bindings for the *at family of POSIX functions *)

open Base

module Fd : sig
  type t = Unix.file_descr

  val sexp_of_t : t -> Sexp.t
end

module Open_flag : sig
  type t =
    | O_RDONLY
    | O_WRONLY
    | O_RDWR
    | O_NONBLOCK
    | O_APPEND
    | O_CREAT
    | O_TRUNC
    | O_EXCL
    | O_NOCTTY
    | O_DSYNC
    | O_SYNC
    | O_RSYNC
    | O_SHARE_DELETE
    | O_CLOEXEC
    | O_KEEPEXEC [@if ocaml_version >= (4, 05, 0)]
    | O_NOFOLLOW
    | O_DIRECTORY
    | O_PATH
  [@@deriving sexp_of]

  (* Raises when passed O_NOFOLLOW, O_DIRECTORY, or O_PATH, which are not valid
     [open_flag]'s *)
  val to_unix_open_flag_exn : t -> Unix.open_flag
  val of_unix_open_flag : Unix.open_flag -> t
end

module At_flag : sig
  type t =
    | AT_EACCESS
    | AT_SYMLINK_FOLLOW
    | AT_SYMLINK_NOFOLLOW
    | AT_REMOVEDIR
  [@@deriving sexp_of]
end

module Rename_flag : sig
  type t =
    | RENAME_EXCHANGE
    | RENAME_NOREPLACE
    | RENAME_WHITEOUT
  [@@deriving sexp_of]
end

module Access_permission : sig
  type t = Unix.access_permission =
    | R_OK
    | W_OK
    | X_OK
    | F_OK
  [@@deriving sexp_of]
end

module File_kind : sig
  type t = Unix.file_kind =
    | S_REG
    | S_DIR
    | S_CHR
    | S_BLK
    | S_LNK
    | S_FIFO
    | S_SOCK
  [@@deriving sexp_of]
end

module File_perm : sig
  type t = int [@@deriving sexp_of]
end

module Stats : sig
  type t = Unix.LargeFile.stats =
    { st_dev : int
    ; st_ino : int
    ; st_kind : File_kind.t
    ; st_perm : File_perm.t
    ; st_nlink : int
    ; st_uid : int
    ; st_gid : int
    ; st_rdev : int
    ; st_size : int64
    ; st_atime : float
    ; st_mtime : float
    ; st_ctime : float
    }
  [@@deriving sexp_of]
end

module Resolve_flags : sig
  type t =
    | RESOLVE_BENEATH
    | RESOLVE_IN_ROOT
    | RESOLVE_NO_MAGICLINKS
    | RESOLVE_NO_SYMLINKS
    | RESOLVE_NO_XDEV (** No RESOLVE_CACHED in our version of Linux *)
  [@@deriving sexp_of]
end

module Open_how : sig
  type t =
    { flags : Open_flag.t list
    ; perm : File_perm.t
    ; resolve : Resolve_flags.t list
    }
  [@@deriving sexp_of]
end

val at_fdcwd : unit -> Fd.t
val openat : dir:Fd.t -> path:string -> flags:Open_flag.t list -> perm:File_perm.t -> Fd.t

val faccessat
  :  dir:Fd.t
  -> path:string
  -> mode:Access_permission.t list
  -> flags:At_flag.t list
  -> unit

val fchmodat : dir:Fd.t -> path:string -> perm:File_perm.t -> flags:At_flag.t list -> unit

val fchownat
  :  dir:Fd.t
  -> path:string
  -> uid:int
  -> gid:int
  -> flags:At_flag.t list
  -> unit

val mkdirat : dir:Fd.t -> path:string -> perm:File_perm.t -> unit
val unlinkat : dir:Fd.t -> path:string -> flags:At_flag.t list -> unit
val mkfifoat : dir:Fd.t -> path:string -> perm:File_perm.t -> unit

val linkat
  :  olddir:Fd.t
  -> oldpath:string
  -> newdir:Fd.t
  -> newpath:string
  -> flags:At_flag.t list
  -> unit

val renameat : olddir:Fd.t -> oldpath:string -> newdir:Fd.t -> newpath:string -> unit

val renameat2
  :  olddir:Fd.t
  -> oldpath:string
  -> newdir:Fd.t
  -> newpath:string
  -> flags:Rename_flag.t list
  -> unit

val symlinkat : oldpath:string -> newdir:Fd.t -> newpath:string -> unit
val fstatat : dir:Fd.t -> path:string -> flags:At_flag.t list -> Stats.t
val readlinkat : dir:Fd.t -> path:string -> string
val fdopendir : Fd.t -> Unix.dir_handle
val has_mkfifoat : bool
val openat2 : dir:Fd.t -> path:string -> Open_how.t -> Fd.t
