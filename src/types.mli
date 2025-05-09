@@ portable

open Base

module Fd : sig
  type t = Unix.file_descr [@@deriving sexp_of]

  type info =
    | Win32_handle of int64
    | Win32_socket of int64
    | Unix_fd of int
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

  val of_unix_open_flag : Unix.open_flag -> t
  val to_unix_open_flag_exn : t -> Unix.open_flag
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

module File_perm : sig
  type t = Unix.file_perm [@@deriving sexp_of]
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
