using ReadOnlyDicts
using Test
using Aqua
using JET

@testset "ReadOnlyDicts.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ReadOnlyDict)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(ReadOnlyDict; target_defined_modules = true)
    end
    # Write your tests here.
end
