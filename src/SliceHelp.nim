from strformat import fmt
import Colors as color

let
  magenta: string = color.magenta
  blue: string = color.blue
  green: string = color.green
  cyan: string = color.cyan
  white: string = color.white
  reset: string = color.reset

proc helpProc* {.noReturn.} =
  stdout.writeLine("{magenta}slice{reset}: {blue}v1.0{reset}".fmt)
  stdout.flushFile

  stdout.writeLine("\n{green}Description{reset}: {white}slices a string at each SEPARATOR if a SEPARATOR is given.{reset}".fmt)
  stdout.flushFile

  stdout.writeLine("\n{green}Usage{reset}: {magenta}slice{reset} {yellow}STRING{reset} {cyan}-d{reset} {white}SEPARATOR{reset} [{cyan}-f{reset} | {cyan}-l{reset} | {cyan}-g{reset} {white}NUMBER{reset} | {cyan}-r{reset} {white}NUMBER,NUMBER{reset}]\n".fmt)
  stdout.flushFile

  stdout.writeLine("\n{yellow}NOTE{reset}: {white}slice positions start at 0.{reset}".fmt)
  stdout.flushFile

  stdout.writeLine("\n{blue}OPTIONS{reset}\t\t\t\t{blue}DESCRIPTION{reset}\n-------\t\t\t\t-----------".fmt)
  stdout.flushFile

  stdout.writeLine("\n {cyan}-d{reset} {white}SEPARATOR{reset}\t\t\t where to slice the string".fmt)
  stdout.flushFile

  stdout.writeLine("\n {cyan}-f{reset}\t\t\t\t grab the first slice".fmt)
  stdout.flushFile

  stdout.writeLine("\n {cyan}-g{reset} {white}NUMBER{reset}\t\t\t grab a slice".fmt)
  stdout.flushFile

  stdout.writeLine("\n {cyan}-l{reset}\t\t\t\t grab the last slice".fmt)
  stdout.flushFile

  stdout.writeLine("\n {cyan}-r{reset} {white}START,END{reset}\t\t\t grab slices from START to END\n".fmt)
  stdout.flushFile
  quit(0)
