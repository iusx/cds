type
  AppError* = object of CatchableError
    code*: int

  AppConfig* = object
    pathFile*: string

  DirectoryEntry* = object
    path*: string
    commands*: seq[string]
