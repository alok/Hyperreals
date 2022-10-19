module Hyperreals

# TODO: make a struct rather than type alias
Hyperreal = Dict{Float64, Float64}

# TODO impl a way to simplify *relative* to an epsilon
# TODO : add a function to convert a real number to a hyperreal
# TODO : write tests
#
function zero(::Hyperreal)
    Hyperreal(0 => 0.0)
end
function one(::Hyperreal)
    Hyperreal(0 => 1.0)
end

# TODO: this could use symbolics.jl
function +(a::Hyperreal, b::Hyperreal)
    out = deepcopy(a)

    for (k, v) in b
        if k in keys(out)
            out[k] += v
        else
            out[k] = v
        end
    end

    out
end
function -(a::Hyperreal, b::Hyperreal)
    # TODO: impl negation, then use it to impl a - b as a + (-b)

    out = deepcopy(a)

    for (k, v) in b
        if k in keys(out)
            out[k] -= v
        else
            out[k] = v
        end
    end

    out
end

# TODO: this isn't efficient for multiplication or div, it should be a convolution
function *(a::Hyperreal, b::Hyperreal)
    out = Hyperreal()
    for (k, v) in a
        for (k2, v2) in b
            if k + k2 in keys(out)
                out[k + k2] += v * v2
            else
                out[k + k2] = v * v2
            end
        end
    end
    out
end
function /(a::Hyperreal, b::Hyperreal)
    # TODO: impl inv (1/x) to get x/y as x * inv(y)
    out = Hyperreal()
    for (k, v) in a
        for (k2, v2) in b
            if k - k2 in keys(out)
                out[k - k2] += v / v2
            else
                out[k - k2] = v / v2
            end
        end
    end
end

# TODO: use property based testing, impl conversion to/from TaylorSeries.jl
@test zero(Hyperreal) * Hyperreal(2 => 1.0) == zero(Hyperreal) # 0*x=0
@test one(Hyperreal) * Hyperreal(2 => 1.0) == Hyperreal(2 => 1.0) # 1*x=x
end
