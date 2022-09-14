#[
  [func] -> {remEsc}:
  -> Remove all escape characters from a string while preserving escpos.
  -> Removes tab, formfeed, vertical tab, alert bell, backspace, return, NULL, and newline

  [return] -> var string:
  -> Returns the mutated string if the removal succeeds, otherwise the original string is returned.
]#
func remEsc(data: var string): var string =
  var escpos, index: int64
  (escpos, index) = (0, 0)

  while escpos < len(data) - 1:
    if data[escpos] in ['\t', '\f', '\v', '\a', '\b', '\r', '\0', '\n']:
      if escpos == 0:
        data[escpos..<escpos+1] = ""

      elif escpos == len(data) - 1:
        data[escpos..<escpos+1] = ""

      else:
        data[escpos] = ' '

    escpos.inc()

  while index < len(data) - 1:
    if index == 0 and data[index] == ' ' and data[index+1] == ' ':
      data[index..<index+1] = ""

    elif index > 0:
      if data[index-1] == ' ' and data[index] == ' ' and data[index+1] == ' ':
        data[index..<index+1] = ""
        data[index..<index+1] = ""

      elif data[index-1] != ' ' and data[index] == ' ' and data[index+1] == ' ':
        data[index..<index+1] = ""

      elif data[index-1] == ' ' and data[index] == ' ' and data[index+1] != ' ':
        data[index..<index+1] = ""

    index.inc()

  return data

#[
 [func] -> {mutateStr}:
 -> Mutates a string inplace given an arbitrary number of mutations.
 -> Each mutation is an array consisting of two strings: 'target' and 'replacement'.
 -> The 'target' is the part of the string that will be mutated / replaced by the 'replacement'.

 [return] -> var string:
 -> Returns the mutated string if the mutation(s) succeed, otherwise the original string is returned.
]#
func mutateStr*(str: var string; escRem: bool = false; mutations: varargs[array[0..1, string]]): var string =
  var oldtarget: string
  var head, tail, dif, sum: int64

  if str == "":
    return str

  elif escRem == true and len(mutations) == 0:
    return str.remEsc()

  elif escRem == true and len(mutations) > 0:
    discard str.remEsc()

  elif len(mutations) == 0:
    return str

  else:
    for mutation in mutations:
      if len(str) < len(mutation[0]):
        return str

      else:
        (head, tail, dif, sum) = (0, int64(mutation[0].len), 0, 0)

        while head < int64(str.len) + 1:
          try:
            if dif > 0 and str[head-dif..<tail-dif] == mutation[0]:
              str[head-dif..<tail-dif] = mutation[1]
              head.dec(dif.int)
              tail.dec(dif.int)
            
            elif sum > 0 and str[head+sum..<tail+sum] == mutation[0]:
              str[head+sum..<tail+sum] = mutation[1]
              head.inc(sum.int)
              tail.inc(sum.int)
            
            elif dif == 0 and sum == 0 and str[head..<tail] == mutation[0]:
              oldtarget = str[head..<tail]
              str[head..<tail] = mutation[1]

              if int64(oldtarget.len) == int64(mutation[1].len):
                dif = 0
                sum = 0
              
              elif int64(oldtarget.len) < int64(mutation[1].len):
                sum = int64(mutation[1].len)

              elif int64(oldtarget.len) > int64(mutation[1].len):
                dif = tail - head
            
            head.inc()
            tail.inc()
          except IndexDefect:
            break
    
  return str
