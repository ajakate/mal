
def READ(args)
	args
end

def EVAL(args)
	args
end

def PRINT(args)
    args
end

def rep(args)
    PRINT(EVAL(READ(args)))
end

loop do
    print "user> "
    input = gets
    puts rep(input)
end

