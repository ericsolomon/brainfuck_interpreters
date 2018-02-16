import os
import sets

let program = if paramCount() > 0: readFile paramStr(1) else: readAll stdin

var
  tape = newSeq[char]()
  pc = 0
  tapePos = 0

{.push overflowchecks: off.}
proc xinc(c: var char) = inc c
proc xdec(c: var char) = dec c
{.pop.}

proc run(skip = false): bool =
  while tapePos >= 0 and pc < program.len:
    if tapePos >= tape.len:
      tape.add '\0'

    if program[pc] == '[':
      inc pc
      let oldPc = pc
      while run(tape[tapePos] == '\0'):
        pc = oldPc
    elif program[pc] == ']':
      return tape[tapePos] != '\0'
    elif not skip:
      case program[pc]
      of '+': xinc tape[tapePos]
      of '-': xdec tape[tapePos]
      of '>': inc tapePos
      of '<': dec tapePos
      of '.': stdout.write tape[tapePos]
      of ',': discard stdin.readBuffer(tape[tapePos].addr, 1)
      else: discard

    inc pc

discard run()
