type
  AppError* = object of CatchableError
    code*: int

  Command* = enum
    cmdSave = "save"
    cmdList = "list"
    cmdJump = "jump"

  AppConfig* = object
    pathFile*: string
