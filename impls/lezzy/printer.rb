require_relative "reader"

def pr_str(tree)
    tree.items.map do |el|
        if el.class == Kollection
            "#{el.open}#{pr_str(el)}#{el.close}"
        else
            el
        end
    end.join(' ')
end
