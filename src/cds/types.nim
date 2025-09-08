type
  AppError* = object of CatchableError
    code*: int

  Command* = enum
    cmdSave = "save"
    cmdList = "list"
    cmdJump = "jump"
    cmdConfigure = "c"

  AppConfig* = object
    pathFile*: string

  DirectoryEntry* = object
    path*: string
    commands*: seq[string]
