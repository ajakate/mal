class Parens

    attr_reader :items

    def initialize(items)
        @items = items
    end

    def self.open
        "("
    end

    def self.close
        ")"
    end
end

class Bracket

    attr_reader :items

    def initialize(items)
        @items = items
    end

    def self.open
        "["
    end

    def self.close
        "]"
    end
end

class Curley

    attr_reader :items

    def initialize(items)
        @items = items
    end
    
    def self.open
        "{"
    end

    def self.close
        "}"
    end
end

class Reader

    TOKENS = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

    PARENS = [Parens, Bracket, Curley]

    def initialize(tokens)
        # puts "Herrr"
        # puts tokens
        @tokens = tokens
        @token_index = 0
        @full = read_form
    end

    def out
        # puts "hey"
        @full
    end

    def next!
        # puts "ne #{@token_index}"
        @token_index += 1
        @tokens[@token_index - 1]
    end

    def peek
        @tokens[@token_index]
    end

    def get_list_type(peek)
        PARENS.each do |klass|
            if peek == klass.open
                return klass
            end
        end
        nil
    end

    def read_form
        list_type = get_list_type(peek)
        if list_type
            next!
            return read_list(list_type)
        else
            return read_atom
        end
    end

    def read_atom
        next!
    end

    def read_list(list_type)
        my_list = []
        while (peek != list_type.close) do
            # puts "fuck"
            # puts peek
            if peek == ''
                raise 'unbalanced'
            end
            my_list << read_form
        end
        next!
        list_type.new(my_list)
    end

    def self.tokenize(string)
        # puts "hi"
        # puts string
        poo = "(#{string.chomp})"
        # puts poo
        poo.scan(TOKENS).map{ |i| i[0] }
    end

    def self.read_str(string)
        reader = new(tokenize(string))
        reader.out
    end

end
