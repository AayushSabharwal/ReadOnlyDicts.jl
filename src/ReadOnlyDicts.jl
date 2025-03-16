module ReadOnlyDicts

struct ReadOnlyDict{K, V, D <: AbstractDict{K, V}} <: AbstractDict{K, V}
    inner::D
end

end
