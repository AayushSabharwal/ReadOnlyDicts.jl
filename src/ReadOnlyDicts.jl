module ReadOnlyDicts

export ReadOnlyDict

using Base: Callable
using DocStringExtensions

"""
    $(TYPEDEF)

Wraps an `AbstractDict` and only implements non-mutating functions of the interface.
The wrapped `AbstractDict` can be obtained using `Base.parent`. The standard dictionary
constructors use `Base.Dict` as the inner collection.
"""
struct ReadOnlyDict{K, V, D <: AbstractDict{K, V}} <: AbstractDict{K, V}
    inner::D
end

ReadOnlyDict() = ReadOnlyDict{Any, Any}()
ReadOnlyDict{K}() where {K} = ReadOnlyDict{K, Any}()
ReadOnlyDict{K, V}() where {K, V} = ReadOnlyDict(Dict{K, V}())
ReadOnlyDict(pairs::Pair...) = ReadOnlyDict(Dict(pairs...))

Base.copy(rod::ReadOnlyDict) = ReadOnlyDict(copy(rod.inner))
function Base.empty(rod::ReadOnlyDict, ::Type{K}, ::Type{V}) where {K, V}
    ReadOnlyDict(empty(rod.inner, K, V))
end

Base.getindex(rod::ReadOnlyDict, k) = rod.inner[k]

Base.getkey(rod::ReadOnlyDict, k, default) = getkey(rod.inner, k, default)

Base.get(rod::ReadOnlyDict, k, def) = get(rod.inner, k, def)
Base.get(f::Callable, rod::ReadOnlyDict, k) = get(f, rod.inner, k)

Base.haskey(rod::ReadOnlyDict, k) = haskey(rod.inner, k)
Base.isempty(rod::ReadOnlyDict) = isempty(rod.inner)
Base.length(rod::ReadOnlyDict) = length(rod.inner)

Base.iterate(rod::ReadOnlyDict, state...) = iterate(rod.inner, state...)

Base.parent(rod::ReadOnlyDict) = rod.inner

Base.sizehint!(rod::ReadOnlyDict, n; kwargs...) = throw(MethodError(sizehint!, (rod, n)))

Base.filter!(f, rod::ReadOnlyDict) = throw(MethodError(filter!, (f, rod)))

end
