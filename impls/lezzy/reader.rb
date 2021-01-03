class Reader

    TOKENS = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

    def initialize(tokens)
        @tokens = tokens
        @token_index = 0
        @full = read_form
    end

    def out
        @full
    end

    def next!
        @token_index += 1
        @tokens[@token_index - 1]
    end

    def peek
        @tokens[@token_index]
    end

    def read_form
        if peek == '('
            next!
            return read_list
        else
            return read_atom
        end
    end

    def read_atom
        next!
    end

    def read_list
        my_list = []
        while (peek != ')' and peek != '') do
            my_list << read_form
        end
        next!
        my_list
    end

    def self.tokenize(string)
        string.scan(TOKENS).map{ |i| i[0] }
    end

    def self.read_str(string)
        reader = new(tokenize(string))
        reader.out
    end

end
