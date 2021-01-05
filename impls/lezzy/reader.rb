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

    def initialize(tokens)
        @tokens = tokens
        @token_index = 0
    end

    def next!
        @token_index += 1
        @tokens[@token_index - 1]
    end

    def peek
        @tokens[@token_index]
    end

end

def read_atom(reader)
    reader.next!
end

def read_list(reader, list_type)
    my_list = []
    while (reader.peek != Kollection.closer_for(list_type)) do
        if reader.peek == ''
            raise 'unbalanced'
        end
        my_list << read_form(reader)
    end
    reader.next!
    Kollection.new(list_type, my_list)
end

def read_form(reader)
    list_type = Kollection.start?(reader.peek)
    if list_type
        reader.next!
        return read_list(reader, list_type)
    else
        return read_atom(reader)
    end
end


TOKENS = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

def tokenize(string)
    "(#{string.chomp})".scan(TOKENS).map{ |i| i[0] }
end

def read_str(string)
    reader = Reader.new(tokenize(string))
    read_form(reader)
end
