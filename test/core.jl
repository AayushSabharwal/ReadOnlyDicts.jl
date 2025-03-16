using ReadOnlyDicts

@testset "Constructors" begin
    d = ReadOnlyDict()
    @test d isa ReadOnlyDict{Any, Any, Dict{Any, Any}}
    @test isempty(d.inner)
    d = ReadOnlyDict{Int}()
    @test d isa ReadOnlyDict{Int, Any, Dict{Int, Any}}
    @test isempty(d.inner)
    d = ReadOnlyDict{Int, String}()
    @test d isa ReadOnlyDict{Int, String, Dict{Int, String}}
    @test isempty(d.inner)
    d = ReadOnlyDict(1 => :a, 2 => :b)
    @test d isa ReadOnlyDict{Int, Symbol, Dict{Int, Symbol}}
    @test length(d.inner) == 2
    @test d.inner[1] == :a
    @test d.inner[2] == :b
    d = ReadOnlyDict(1 => :a, 2 => 3)
    @test d isa ReadOnlyDict{Int, Any, Dict{Int, Any}}
    @test length(d.inner) == 2
    @test d.inner[1] == :a
    @test d.inner[2] == 3
    id = IdDict(1 => 3, 1.0 => 4)
    d = ReadOnlyDict(id)
    @test d isa ReadOnlyDict{Any, Int, typeof(id)}
    @test d.inner === id
end

@testset "Interface functions" begin
    dinner = Dict(1 => 2, 3 => 4)
    d = ReadOnlyDict(dinner)
    k1 = ones(2)
    k2 = ones(2)
    dvec = ReadOnlyDict(k1 => 1)
    tmp = Memory{Float64}(undef, 2)
    fill!(tmp, 1.0)

    @testset "length" begin
        @test length(d) == 2
    end

    @testset "copy" begin
        d2 = copy(d)
        d2.inner[5] = 6
        @test length(d) == 2
        @test length(d2) == 3
    end

    @testset "empty" begin
        @testset "1-arg" begin
            d2 = empty(d)
            @test length(d) == 2
            @test length(d2) == 0
            @test typeof(d) == typeof(d2)
        end

        @testset "2-arg" begin
            d2 = empty(d, String)
            @test length(d2) == 0
            @test d2 isa ReadOnlyDict{Int, String, Dict{Int, String}}
        end

        @testset "3-arg" begin
            d2 = empty(d, Symbol, String)
            @test length(d2) == 0
            @test d2 isa ReadOnlyDict{Symbol, String, Dict{Symbol, String}}
        end
    end

    @testset "getindex" begin
        @test d[1] == 2
    end

    @testset "getkey" begin
        @test getkey(d, 1, nothing) == 1
        @test getkey(d, 2, nothing) === nothing
        # === is intentional
        @test getkey(dvec, k2, nothing) === k1
    end

    @testset "get" begin
        @test get(d, 1, nothing) == 2
        @test get(d, 2, nothing) === nothing
        @test get(dvec, k2, nothing) == 1
        @test get(dvec, zeros(2), nothing) === nothing
        # different key type
        @test get(d, 1.0, nothing) == 2
        @test get(dvec, tmp, nothing) == 1
    end

    @testset "haskey" begin
        @test haskey(d, 1)
        @test !haskey(d, 2)
        @test haskey(dvec, k2)
        @test !haskey(dvec, zeros(2))
        # different key type
        @test haskey(d, 1.0)
        @test haskey(dvec, tmp)
    end

    @testset "isempty" begin
        @test !isempty(d)
        d2 = empty(d)
        @test isempty(d2)
    end

    @testset "iterate" begin
        dtmp = Dict{Int, Int}()
        for (k, v) in d
            dtmp[k] = v
        end
        @test dtmp == d
    end

    @testset "parent" begin
        @test parent(d) == dinner
    end

    @testset "Mutating functions" begin
        @test !applicable(setindex!, 3, 2)
        @test_throws MethodError map!(isodd, values(d))
        @test_throws MethodError get!(d, 2, 3)
        @test_throws MethodError get!(Returns(3), d, 2)
        @test !applicable(pop!, d, 1)
        @test !applicable(pop!, d, 1, 2)
        @test !applicable(delete!, d, 1)
        @test !applicable(empty!, d)
        @test_throws MethodError sizehint!(d, 42)
        @test_throws MethodError filter!(isodd ∘ first, d)
        @test_throws MethodError merge!(d, Dict(5 => 6))
        d2 = Dict(5 => 6)
        @test_nowarn merge!(d2, d)
        @test length(d2) == 3
        @test d2[1] == 2
        @test d2[3] == 4
        @test d2[5] == 6
    end
end
