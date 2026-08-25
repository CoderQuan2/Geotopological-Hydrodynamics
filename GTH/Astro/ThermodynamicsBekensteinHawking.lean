/-
  Module: GTH.Astro.ThermodynamicsBekensteinHawking
  Description: Bekenstein-Hawking Entropy S = A / (4*G), Hawking Temperature, and First Law of Horizon Mechanics.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

/-- Horizon Thermodynamic State Vector with Area A, Surface Gravity kappa, and Hawking Temperature -/
structure HorizonThermodynamicState where
  Area_m2      : ℝ  -- Horizon surface area A (m^2) (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  k_B          : ℝ  -- Boltzmann constant (> 0)
  kappa_grav   : ℝ  -- Surface gravity (m/s^2) (> 0)
  h_A_pos      : 0 < Area_m2
  h_G_pos      : 0 < G_N
  h_hbar_pos   : 0 < hbar
  h_c_pos      : 0 < c_SI
  h_kB_pos     : 0 < k_B
  h_kap_pos    : 0 < kappa_grav

/-- Bekenstein-Hawking Entropy: S_BH = (k_B * c^3 * A) / (4 * G * hbar) -/
noncomputable def bekensteinHawkingEntropy (H : HorizonThermodynamicState) : ℝ :=
  (H.k_B * (H.c_SI ^ 3) * H.Area_m2) / (4 * H.G_N * H.hbar)

theorem bekensteinHawkingEntropy_pos (H : HorizonThermodynamicState) :
    0 < bekensteinHawkingEntropy H := by
  dsimp [bekensteinHawkingEntropy]
  have h_c3 : 0 < H.c_SI ^ 3 := pow_pos H.h_c_pos 3
  have h_num : 0 < H.k_B * (H.c_SI ^ 3) * H.Area_m2 := by
    have p1 : 0 < H.k_B * (H.c_SI ^ 3) := mul_pos H.h_kB_pos h_c3
    exact mul_pos p1 H.h_A_pos
  have h_den : 0 < 4 * H.G_N * H.hbar := by
    have p2 : 0 < 4 * H.G_N := mul_pos (by norm_num) H.h_G_pos
    exact mul_pos p2 H.h_hbar_pos
  exact div_pos h_num h_den

/-- Hawking Temperature: T_H = (hbar * kappa) / (2 * pi * k_B * c) -/
noncomputable def hawkingTemperature (H : HorizonThermodynamicState) : ℝ :=
  (H.hbar * H.kappa_grav) / (2 * Real.pi * H.k_B * H.c_SI)

theorem hawkingTemperature_pos (H : HorizonThermodynamicState) :
    0 < hawkingTemperature H := by
  dsimp [hawkingTemperature]
  have h_num : 0 < H.hbar * H.kappa_grav := mul_pos H.h_hbar_pos H.h_kap_pos
  have h_2pi : 0 < 2 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have h_den : 0 < 2 * Real.pi * H.k_B * H.c_SI := by
    have p1 : 0 < 2 * Real.pi * H.k_B := mul_pos h_2pi H.h_kB_pos
    exact mul_pos p1 H.h_c_pos
  exact div_pos h_num h_den

/-- First Law of Horizon Mechanics State: dM = (kappa / (8*pi*G)) * dA + Omega_H * dJ -/
structure FirstLawMechanicsState where
  H            : HorizonThermodynamicState
  dM           : ℝ  -- Mass energy differential
  dA           : ℝ  -- Area differential
  dJ           : ℝ  -- Angular momentum differential
  Omega_H      : ℝ  -- Angular velocity
  h_first_law  : dM = (H.kappa_grav / (8 * Real.pi * H.G_N)) * dA + Omega_H * dJ

theorem first_law_differential_satisfied (F : FirstLawMechanicsState) :
    F.dM = (F.H.kappa_grav / (8 * Real.pi * F.H.G_N)) * F.dA + F.Omega_H * F.dJ :=
  F.h_first_law

end GTH.Astro
