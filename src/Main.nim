from os import commandLineParams
from terminal import isatty
from ParamHandler1 import paramHandler1
from ParamHandler2 import paramHandler2

proc Ctrl_C_Handler {.noconv.} =
  quit(0)

proc Main {.noReturn.} =
  if isatty(stdin) and (isatty(stdout) xor not isatty(stdout)):
    paramHandler1(commandLineParams())

  elif not isatty(stdin) and (isatty(stdout) xor not isatty(stdout)):
    paramHandler2(commandLineParams())

  else:
    quit(255)

setControlCHook(Ctrl_C_handler)
Main()
