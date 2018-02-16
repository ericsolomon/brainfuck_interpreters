#!/usr/bin/env ruby

class Tape
  def initialize
    @tape = [0]
    @pointer = 0
  end

  def get
    @tape[@pointer]
  end

  def set(value)
    @tape[@pointer] = value
  end

  def inc
    @tape[@pointer] += 1
  end

  def dec
    @tape[@pointer] -= 1
  end

  def left
    if @pointer - 1 < 0
      @pointer = @tape.length - 1
    else
      @pointer -= 1
    end
  end

  def right
    @pointer += 1

    if @pointer > @tape.length - 1
      @tape.push(0)
    end
  end
end

def parse(program)
  pc = 0
  parsed = ''
  jump_table = {}
  bracket_stack = []

  program.split('').each do |token|
    if %w(> < + - [ ] . ,).include?(token)
      parsed += token

      if token == '[' then bracket_stack.push(pc) end

      if token == ']'
        left_pc = bracket_stack.pop
        jump_table[pc] = left_pc
        jump_table[left_pc] = pc
      end

      pc += 1
    end
  end

  return parsed, jump_table
end

def run()
  file_name = ARGV.first

  unless file_name
    puts "Program file must be provided"
    return
  end

  program = File.read(ARGV.first)

  tape = Tape.new
  parsed, jump_table = parse(program)
  pc = 0

  while pc < parsed.length
    token = parsed[pc]

    case token
    when '+' then tape.inc
    when '-' then tape.dec
    when '>' then tape.right
    when '<' then tape.left
    when '.' then print tape.get.chr
    when '['
      if tape.get == 0
        pc = jump_table[pc]
      end
    when ']'
      if tape.get != 0
        pc = jump_table[pc]
      end
    when ','
      input = STDIN.read(1).ord
      tape.set(input)
    end

    pc += 1
  end
end

run
