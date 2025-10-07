open Base

module Fd = struct
  type t = Unix.file_descr

  type info =
    | Win32_handle of int64
    | Win32_socket of int64
    | Unix_fd of int

  external info : t -> info @@ portable = "shexp_fd_info"

  let sexp_of_t t =
    match info t with
    | Unix_fd n -> sexp_of_int n
    | Win32_handle h -> List [ Atom "HANDLE"; Atom (Printf.sprintf "0x%Lx" h) ]
    | Win32_socket s -> List [ Atom "SOCKET"; Atom (Printf.sprintf "%Lx" s) ]
  ;;
end

module Open_flag = struct
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

  let of_unix_open_flag (flag : Unix.open_flag) : t =
    match flag with
    | O_RDONLY -> O_RDONLY
    | O_WRONLY -> O_WRONLY
    | O_RDWR -> O_RDWR
    | O_NONBLOCK -> O_NONBLOCK
    | O_APPEND -> O_APPEND
    | O_CREAT -> O_CREAT
    | O_TRUNC -> O_TRUNC
    | O_EXCL -> O_EXCL
    | O_NOCTTY -> O_NOCTTY
    | O_DSYNC -> O_DSYNC
    | O_SYNC -> O_SYNC
    | O_RSYNC -> O_RSYNC
    | O_SHARE_DELETE -> O_SHARE_DELETE
    | O_CLOEXEC -> O_CLOEXEC
    | O_KEEPEXEC -> O_KEEPEXEC
  ;;

  let to_unix_open_flag_exn t : Unix.open_flag =
    match t with
    | O_RDONLY -> O_RDONLY
    | O_WRONLY -> O_WRONLY
    | O_RDWR -> O_RDWR
    | O_NONBLOCK -> O_NONBLOCK
    | O_APPEND -> O_APPEND
    | O_CREAT -> O_CREAT
    | O_TRUNC -> O_TRUNC
    | O_EXCL -> O_EXCL
    | O_NOCTTY -> O_NOCTTY
    | O_DSYNC -> O_DSYNC
    | O_SYNC -> O_SYNC
    | O_RSYNC -> O_RSYNC
    | O_SHARE_DELETE -> O_SHARE_DELETE
    | O_CLOEXEC -> O_CLOEXEC
    | O_KEEPEXEC -> O_KEEPEXEC
    | O_NOFOLLOW -> failwith "[Unix.open_flag] does not support O_NOFOLLOW"
    | O_DIRECTORY -> failwith "[Unix.open_flag] does not support O_DIRECTORY"
    | O_PATH -> failwith "[Unix.open_flag] does not support O_PATH"
  ;;
end

module At_flag = struct
  type t =
    | AT_EACCESS
    | AT_SYMLINK_FOLLOW
    | AT_SYMLINK_NOFOLLOW
    | AT_REMOVEDIR
  [@@deriving sexp_of]
end

module Rename_flag = struct
  type t =
    | RENAME_EXCHANGE
    | RENAME_NOREPLACE
    | RENAME_WHITEOUT
  [@@deriving sexp_of]
end

module Access_permission = struct
  type t = Unix.access_permission =
    | R_OK
    | W_OK
    | X_OK
    | F_OK
  [@@deriving sexp_of]
end

module File_perm = struct
  type t = Unix.file_perm

  let sexp_of_t t = Sexp.Atom (Printf.sprintf "0o%3o" t)
end

module File_kind = struct
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

module Stats = struct
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

module Resolve_flags = struct
  type t =
    | RESOLVE_BENEATH
    | RESOLVE_IN_ROOT
    | RESOLVE_NO_MAGICLINKS
    | RESOLVE_NO_SYMLINKS
    | RESOLVE_NO_XDEV
  [@@deriving sexp_of]
end

module Open_how = struct
  type t =
    { flags : Open_flag.t list
    ; perm : File_perm.t
        (* In the C struct, this is called "mode", but we're calling it [perm] to
           align with the definition of [openat]*)
    ; resolve : Resolve_flags.t list
    }
  [@@deriving sexp_of]
end
