using ReadOnlyDicts
using Test
using Aqua
using JET
using SafeTestsets

@testset "ReadOnlyDicts.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ReadOnlyDicts)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(ReadOnlyDicts; target_defined_modules = true)
    end
    @safetestset "ReadOnlyDict tests" begin
        include("core.jl")
    end
end
