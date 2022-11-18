# MetalSurfaceImpedance

| **Tests**     | **CodeCov**  |
|:--------:|:-------:|
|[![CI](https://github.com/simonp0420/MetalSurfaceImpedance.jl/workflows/CI/badge.svg?branch=main)](https://github.com/simonp0420/MetalSurfaceImpedance.jl/actions) | [![codecov.io](https://codecov.io/github/simonp0420/MetalSurfaceImpedance.jl/coverage.svg?branch=main)](https://codecov.io/github/simonp0420/MetalSurfaceImpedance.jl?branch=main) |


A small Julia package to calculate the surface impedance of rough metallic surfaces, useful in microwave
engineering and computational electromagnetics.  The complex surface impedance (assuming $e^{j\omega t}$ time variation) is computed using a fast rational function approximation of the Gradient model.  The approximation is taken from D. N. Grujić, "Simple and Accurate Approximation of Rough Conductor Surface Impedance," IEEE Trans. Microwave Theory Tech., vol. 70, no. 4, pp. 2053-2059, April 2022.


## Installation
You can obtain MetalSurfaceImpedance using Julia's Pkg REPL-mode (hitting `]` as the first character of the command prompt):

```julia
(@v1.8) pkg> add MetalSurfaceImpedance
```

or with `using Pkg; Pkg.add("MetalSurfaceImpedance")`.

## Exported Functions

The package exports two functions: `Zsurface` and `effective_conductivity`: 

    Zsurface(f, σ₀, Rq, disttype=:normal)

Returns the complex surface impedance [Ω/□] for a rough (or smooth) metallic surface that is many skin depths thick.  The input arguments are:
* `f`:  The frequency [Hz].
* `σ₀`: The DC bulk conductivity of the metal [S/m].
* `Rq`: The RMS surface roughness [m]. 
* `disttype`: The type of probability distribution used to model the roughness.  Choices are `:normal` (the default, used for the "oxide" side of printed conductors) and `:rayleigh` (used for the "foil" side of printed conductors).
  
  
####
    effective_conductivity(f, σ₀, Rq, disttype=:normal)

Returns the effective conductivity [S/m] due to surface roughness.  Input arguments are the same as those of `Zsurface`.

### Usage examples

```julia
julia> using MetalSurfaceImpedance

julia> σ₀ = 58e6 # 58 MS/m (pure Copper)
5.8e7

julia> Zsurface(10e9, σ₀, 0, :rayleigh) # Smooth copper surface
0.02608950694933611 + 0.02608950694933611im

julia> Zsurface(10e9, σ₀, 1e-6, :rayleigh) # 1 μm RMS roughness copper surface
0.07482375631106834 + 0.3177602251933982im

julia> effective_conductivity(10e9, σ₀, 0.5e-6)
2.276056215432205e7

julia> ans/σ₀
0.3924234854193457
```
