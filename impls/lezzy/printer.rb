require_relative "reader"

def pr_str(tree)
    # if tree.class != Array
    #     return tree
    # end
    poo = tree.items.map do |el|
        if [Parens, Bracket, Curley].include? el.class
            "#{el.class.open}#{pr_str(el)}#{el.class.close}"
        else
            el
        end
    end.join(' ')

    poo
end
