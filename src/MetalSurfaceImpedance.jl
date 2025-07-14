module MetalSurfaceImpedance
export Zsurface, effective_conductivity

const μ₀ = 1.25663706212e-6 # permeability of free space [H/m]
const c₀ = 299792458.0 # Speed of light [m/s]
const ϵ₀ = 1 / (μ₀ * c₀^2) # Permeability of free space [F/m]

"Intrinsic impedance of free space [F/m]"
const η₀ = sqrt(μ₀ / ϵ₀)


"""
    Zsurface(f, σ₀, Rq, disttype=:normal)

Computes the complex surface impedance in units of [Ω/□] (assuming ``e^{j\\omega t}`` time variation) 
for a rough (or smooth) metallic surface that
is many skin depths thick.  Uses a fast rational function approximation of the
Gradient model that is taken from D. N. Grujić, "Simple and Accurate Approximation 
of Rough Conductor Surface Impedance," in **IEEE Trans. Microwave Theory Tech.**, 
vol. 70, no. 4, pp. 2053-2059, April 2022.

## Input Arguments

* `f`:  The frequency [Hz].
* `σ₀`: The DC bulk conductivity of the metal [S/m].
* `Rq`: The RMS surface roughness [m]. 
* `disttype`: The type of probability distribution used to model the roughness.  Choices
  are `:normal` (the default, used for the "oxide" side of printed conductors) and `:rayleigh`
  (used for the "foil" side of printed conductors).
"""
function Zsurface(f, σ₀, Rq, disttype=:normal)
    f > 0 || throw(ArgumentError("frequency f must be positive"))
    σ₀ ≥ 0 || throw(ArgumentError("conductivity σ₀ must be nonnegative"))
    Rq ≥ 0 || throw(ArgumentError("RMS surface roughness Rq must be nonnegative"))
    isinf(σ₀) && Rq > 0 && throw(ArgumentError("Rq must be zero for infinite conductivity"))
    if disttype == :rayleigh
        fz = (8.697e7, 3.456e9, 9.563e12, Inf)
        fp = (2.128e9, 5.624e13, 1.119e12, Inf)
        r = (0.5074, 0.4404, 0.3571, 1.0)
    elseif disttype == :normal
        fz = (8.655e7, 2.3039e9, 4.6915e13, 2.7795e14)
        fp = (1.7702e9, 7.1614e13, 1.6413e16, 4.9260e12)
        r = (0.50074, 0.45270, 0.43005, 0.29384)
    else
        throw(ArgumentError("Illegal value for disttype"))
    end

    ω = 2π * f

    if iszero(Rq)
        isinf(σ₀) && return zero(ComplexF64)
        δ = sqrt(2.0 / (ω * μ₀ * σ₀))
        Rsmooth = 1.0 / (σ₀ * δ)
        Zsmooth = complex(Rsmooth, Rsmooth)
        return Zsmooth
    end
    
    Rq_ref = 1e-6
    σ₀_ref = 58e6
    λ = Rq * Rq * σ₀ / (Rq_ref * Rq_ref * σ₀_ref)
    ω_ref = λ * ω
    f_ref = λ * f
    f_ref > 1e12 && error("Reference frequency is too high for interpolation")
    δ_ref = sqrt(2 / (ω_ref * μ₀ * σ₀_ref))
    Rsmooth_ref =  1.0 / (σ₀_ref * δ_ref)
    Zsmooth_ref = complex(Rsmooth_ref, Rsmooth_ref)
    Ψ = one(ComplexF64)
    for (fzn, fpn, rn) in zip(fz, fp, r)
        Ψ *= (1 + (f_ref/fzn * im)^rn) / (1 + (f_ref/fpn * im)^rn)
    end
    Zs = Rq / (Rq_ref * λ) * (Ψ * Zsmooth_ref)
    return Zs
end


"""
    effective_conductivity(f, σ₀, Rq, disttype=:normal)

Computes the effective conductivity in units of [S/m] due to surface roughness
for a rough (or smooth) metallic surface that is many skin depths thick.  Uses a 
fast rational function approximation of the Gradient model that is taken from D. N. Grujić, 
"Simple and Accurate Approximation of Rough Conductor Surface Impedance," **IEEE Trans. 
Microwave Theory Tech.**, vol. 70, no. 4, pp. 2053-2059, April 2022.

## Input Arguments

* `f`:  The frequency [Hz].
* `σ₀`: The DC bulk conductivity of the metal [S/m].
* `Rq`: The RMS surface roughness [m]. 
* `disttype`: The type of probability distribution used to model the roughness.  Choices
  are `:normal` (the default, used for the "oxide" side of printed conductors) and `:rayleigh`
  (used for the "foil" side of printed conductors).
"""
function effective_conductivity(f, σ₀, Rq, disttype=:normal)
    Zs = Zsurface(f, σ₀, Rq, disttype)
    ω = 2π * f
    σ_eff = ω * μ₀ / (2 * (real(Zs)^2))
    return σ_eff
end

end # module


