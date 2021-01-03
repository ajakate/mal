
def pr_str(tree)
    if tree.class != Array
        return tree
    end
    poo = tree.map do |el|
        if el.class == Array
            pr_str(el)
        else
            el
        end
    end.join(' ')

    "(#{poo})"
end
