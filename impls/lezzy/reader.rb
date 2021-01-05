class Kollection

    ATTRS = {
        parens: { chars: "()" },
        bracket: { chars: "[]" },
        curly: { chars: "{}" },
    }

    attr_reader :items

    def initialize(type, items)
        @type = type
        @items = items
    end

    def open
        ATTRS[@type][:chars][0]
    end

    def close
        ATTRS[@type][:chars][1]
    end

    def self.start?(char)
        ATTRS.each do |k,v|
            if v[:chars][0] == char
                return k
            end
        end

        return nil
    end

    def self.closer_for(type)
        ATTRS[type][:chars][1]
    end

end

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
        list_type = Kollection.start?(peek)
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
        while (peek != Kollection.closer_for(list_type)) do
            if peek == ''
                raise 'unbalanced'
            end
            my_list << read_form
        end
        next!
        Kollection.new(list_type, my_list)
    end

    def self.tokenize(string)
        "(#{string.chomp})".scan(TOKENS).map{ |i| i[0] }
    end

    def self.read_str(string)
        reader = new(tokenize(string))
        reader.out
    end

end
