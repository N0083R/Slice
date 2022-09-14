from strutils import parseInt, count, split, join, strip
from strformat import fmt
import Colors as colors
from Mutate import mutateStr
from Checker import checkValues
from SliceHelp import helpProc 

proc paramHandler1*(params: seq[string]) {.noReturn.} =
  var str: string
  var list: seq[string]

  if params.len == 0:
    quit(0)

  elif params.len == 1:
    if params[0] == "-h" xor params[0] == "--help":
      helpProc()

    else:
      helpProc()

  elif params.len == 2:
    stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}not enough arguments{colors.reset}\n".fmt)
    stderr.flushFile
    quit(1)

  elif params.len == 3:
    if params[1] == "-d":
      if checkValues(params[1], params[2]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or too many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      else:
        str = params[0]
        discard str.mutateStr(true)
        stdout.write(str.split(params[2]).join("").strip())
        stdout.flushFile
        quit(0)

    else:
      helpProc()

  elif params.len == 4:
    if params[1] == "-d":
      if checkValues(params[1], params[2]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or too many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      elif params[3] == "-f":
        try:
          str = params[0]
          discard str.mutateStr(true)
          stdout.write(str.split(params[2])[0].strip())
          stdout.flushFile
          quit(0)
        except IndexDefect:
          stdout.write(params[0])
          stdout.flushFile
          quit(0)

      elif params[3] == "-l":
        try:
          str = params[0]
          discard str.mutateStr(true)
          stdout.write(str.split(params[2])[^1].strip())
          stdout.flushFile
          quit(0)
        except IndexDefect:
          stdout.write(params[0])
          stdout.flushFile
          quit(0)

      else:
        helpProc()

    else:
      helpProc()

  elif params.len == 5:
    if params[1] == "-d":
      if checkValues(params[1], params[2]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or too many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      elif params[3] == "-g":
        if checkValues(params[3], params[4]) == false:
          stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}argument must be a positive integer{colors.reset}\n".fmt)
          stderr.flushFile
          quit(1)

        else:
          try:
            str = params[0]
            list = str.mutateStr(true).split(params[2])

            if parseInt(params[4]) < 0:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice position must be a positive number{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            elif parseInt(params[4]) > list.len:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice position doesn't exist{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            else:
              stdout.write(list[parseInt(params[4])].strip())
              stdout.flushFile
              quit(0)
          except IndexDefect:
            stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}'-g' value is too large{colors.reset}\n".fmt)
            stderr.flushFile
            quit(1)

      elif params[3] == "-r":
        if checkValues(params[3], params[4]) == false:
          stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}argument must be in the form 'INT,INT'{colors.reset}\n".fmt)
          stderr.flushFile
          quit(1)

        else:
          try:
            str = params[0]
            list = str.mutateStr(true).split(params[2])

            if parseInt(params[4].split(",")[0]) < 0 or parseInt(params[4].split(",")[1]) < 0:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice range must be positive numbers{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            elif parseInt(params[4].split(",")[0]) > list.len or parseInt(params[4].split(",")[1]) > list.len:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice range doesn't exist{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            else:
              str = list[parseInt(params[4].split(",")[0])..<parseInt(params[4].split(",")[1])].join(" ").strip()
              stdout.write(str)
              stdout.flushFile
              quit(0)
          except IndexDefect:
            helpProc()

      else:
        helpProc()

    else:
      helpProc()

  else:
    stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}too many arguments{colors.reset}\n".fmt)
    stderr.flushFile
    quit(1)
