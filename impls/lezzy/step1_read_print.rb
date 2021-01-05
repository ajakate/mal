require_relative "reader"
require_relative "printer"

def READ(args)
    read_str(args)
end

def EVAL(args)
	args
end

def PRINT(args)
    pr_str(args)
end

def rep(args)
    PRINT(EVAL(READ(args)))
end

loop do
    print "user> "
    input = gets
    puts rep(input)
rescue => e
    puts e
end

