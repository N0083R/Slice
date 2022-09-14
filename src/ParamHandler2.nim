from strutils import parseInt, count, split, join, strip
from strformat import fmt
import Colors as colors
from Mutate import mutateStr
from Checker import checkValues
from SliceHelp import helpProc

proc paramHandler2*(params: seq[string]) {.noReturn.} =
  var str: string
  var list: seq[string]

  if params.len == 0:
    quit(0)

  elif params.len == 1:
    stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}not enough arguments for stdin pipe{colors.reset}\n".fmt)
    stderr.flushFile
    quit(1)

  elif params.len == 2:
    if params[0] == "-d":
      if checkValues(params[0], params[1]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      else:
        str = readAll(stdin)
        discard str.mutateStr(true)
        stdout.write(str.split(params[1]).join("").strip())
        stdout.flushFile
        quit(0)

    else:
      helpProc()

  elif params.len == 3:
    if params[0] == "-d":
      if checkValues(params[0], params[1]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or too many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      elif params[2] == "-f":
        try:
          str = readAll(stdin)
          discard str.mutateStr(true)
          stdout.write(str.split(params[1])[0].strip())
          stdout.flushFile
          quit(0)
        except IndexDefect:
          stdout.write(readALl(stdin))
          stdout.flushFile
          quit(0)

      elif params[2] == "-l":
        try:
          str = readAll(stdin)
          discard str.mutateStr(true)
          stdout.write(str.split(params[1])[^1].strip())
          stdout.flushFile
          quit(0)
        except IndexDefect:
          stdout.write(readAll(stdin))
          stdout.flushFile
          quit(0)

      else:
        helpProc()

    else:
      helpProc()

  elif params.len == 4:
    if params[0] == "-d":
      if checkValues(params[0], params[1]) == false:
        stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}delimiter has too little or too many characters{colors.reset}\n".fmt)
        stderr.flushFile
        quit(1)

      elif params[2] == "-g":
        if checkValues(params[2], params[3]) == false:
          stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}argument must be a positive integer{colors.reset}\n".fmt)
          stderr.flushFile
          quit(1)

        else:
          try:
            str = readAll(stdin)
            discard str.mutateStr(true)
            list = str.split(params[1])

            if parseInt(params[3]) < 0:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice position must be a positive number{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            elif parseInt(params[3]) > list.len:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice psotion doesn't exist{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            else:
              stdout.write(list[parseInt(params[3])].strip())
              stdout.flushFile
              quit(0)
          except IndexDefect:
            stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}'-g' value is too large{colors.reset}\n".fmt)
            stderr.flushFile
            quit(1)

      elif params[2] == "-r":
        if checkValues(params[2], params[3]) == false:
          stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}argument must be in the form 'INT,INT'{colors.reset}\n".fmt)
          stderr.flushFile
          quit(1)

        else:
          try:
            str = readAll(stdin)
            list = str.mutateStr(true).split(params[1])

            if parseInt(params[3].split(",")[0]) < 0 or parseInt(params[3].split(",")[1]) < 0:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice range must be positive numbers{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            elif parseInt(params[3].split(",")[0]) > list.len or parseInt(params[3].split(",")[1]) > list.len:
              stderr.write("\n{colors.red}Error{colors.reset}: {colors.white}slice range doesn't exist{colors.reset}\n".fmt)
              stderr.flushFile
              quit(1)

            else:
              str = list[parseInt(params[3].split(",")[0])..<parseInt(params[3].split(",")[1])].join(" ").strip()
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
