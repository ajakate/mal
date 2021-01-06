class Kollection

    ATTRS = {
        parens: { chars: "()" },
        bracket: { chars: "[]" },
        curly: { chars: "{}" },
    }

    attr_reader :items

    def initialize(type, items = [])
        @type = type
        @items = items
    end

    def append(item)
        @items.append(item)
    end

    def open
        ATTRS[@type][:chars][0]
    end

    def close
        ATTRS[@type][:chars][1]
    end

    def self.build_from_initial(char)
        ATTRS.each do |k,v|
            if v[:chars][0] == char
                return new(k)
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

def read_list(reader, list)
    next_char = reader.peek

    while (reader.peek != list.close) do
        if reader.peek == '' or reader.peek.nil?
            raise 'unbalanced'
        end
        list.append(read_form(reader))
    end
    reader.next!
    list
end

def read_form(reader)

    special_forms = {
        "'" => "quote",
        "`" => "quasiquote",
        "~" => "unquote",
        "@" => "deref",
        "~@" => "splice-unquote",
    }

    special_forms.each do |k,v|
        if reader.peek == k
            reader.next!
            quote = Kollection.new(:parens, [v])
            quote.append(read_form(reader))
            return quote
        end
    end

    liste = Kollection.build_from_initial(reader.peek)
    if liste
        reader.next!
        return read_list(reader, liste)
    else
        return read_atom(reader)
    end
end


TOKENS = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

def tokenize(string)
    "(#{string.chomp})".scan(TOKENS).map{ |i| i[0] }.select{ |t| t[0..0] != ";" }
end

def read_str(string)
    reader = Reader.new(tokenize(string))
    read_form(reader)
end
