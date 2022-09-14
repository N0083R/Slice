from strutils import parseInt, count, split

proc checkValues*(opt: string; value: string): bool =
  if len(opt) > 0:
    if opt == "-d":
      if len(value) == 1:
        return true

      else:
        return false

    elif opt == "-g":
      try:
        return parseInt(value) is int
      except ValueError:
        return false

    elif opt == "-r":
      if value.count(",") < 1 or value.count(",") > 1:
        return false

      else:
        try:
          return (parseInt(value.split(",")[0]), parseInt(value.split(",")[1])) is (int, int)
        except ValueError:
          return false

    else:
      return false

  else:
    return false
