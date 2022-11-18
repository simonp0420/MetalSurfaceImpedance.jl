using RoughSurfaceImpedance
using Test

@testset "RoughSurfaceImpedance.jl" begin
    tol = 1e-3
    @test Zsurface(1e7, 58e6, 0.5e-6) ≈  2.0711e-04 + 3.0389e-04im atol=tol
    @test Zsurface(1e7, 58e6, 0.5e-6) ≈  4.1422e-04 + 6.0777e-04im atol=tol
    @test Zsurface(1e7, 58e6, 0.5e-6) ≈  8.2843e-04 + 1.2155e-03im atol=tol
    @test Zsurface(1e7, 58e6, 0.5e-6) ≈  2.0639e-04 + 2.5529e-04im atol=tol
    @test Zsurface(1e7, 58e6, 0.5e-6) ≈  8.2555e-04 + 1.0211e-03im atol=tol
    @test Zsurface(1e8, 58e6, 0.5e-6) ≈  2.6364e-03 + 4.5506e-03im atol=tol
    @test Zsurface(1e9, 58e6, 0.5e-6) ≈  9.0208e-03 + 2.7039e-02im atol=tol
    @test Zsurface(1e10, 58e6, 0.5e-6) ≈  4.1647e-02 + 1.9682e-01im atol=tol
    @test Zsurface(1e11, 58e6, 0.5e-6) ≈  2.7427e-01 + 1.5143e+00im atol=tol
    @test Zsurface(1e11, 58e6, 0.5e-6) ≈  2.7427e-01 + + 1.5143e+00im atol=tol
    @test Zsurface(1e12, 58e6, 0.5e-6) ≈  2.1159e+00 + 1.1739e+01im atol=tol
    @test Zsurface(1e7, 58e6, 1e-6) ≈  8.2843e-04  + 1.2155e-03im atol=tol
    @test Zsurface(1e7, 58e6, 0.5e-6, :rayleigh) ≈  8.2648e-04 + 1.0217e-03im atol=tol
    @test Zsurface(1e8, 58e6, 0.5e-6, :rayleigh) ≈  0.0026378 + 0.004552im atol=tol
    @test Zsurface(1e10, 58e6, 1e-6, :rayleigh) ≈  7.4824e-02 + 3.1776e-01im atol=tol
    @test Zsurface(1e11, 58e6, 1e-6, :rayleigh) ≈  5.8510e-01 + 2.2346e+00im atol=tol
    @test Zsurface(1e12, 58e6, 1e-6, :rayleigh) ≈  4.8131e+00 + 1.4622e+01im atol=tol

    @test effective_conductivity(10e9, 58e6, 0.5e-6) ≈ 2.276056215432205e7

end
