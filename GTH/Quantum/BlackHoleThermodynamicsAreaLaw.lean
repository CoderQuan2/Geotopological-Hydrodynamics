/-
  Module: GTH.Quantum.BlackHoleThermodynamicsAreaLaw
  Description: Bekenstein-Hawking Area Law, Logarithmic Quantum Entropy Correction, and Hawking Temperature.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- Black Hole Acoustic Horizon State Vector -/
structure BlackHoleHorizonState where
  M_mass_kg    : ℝ  -- Remnant mass (kg) (> 0)
  Area_m2      : ℝ  -- Horizon surface area (m^2) (> 0)
  kappa_surf   : ℝ  -- Horizon surface gravity (m/s^2) (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  k_B          : ℝ  -- Boltzmann constant (> 0)
  h_M_pos      : 0 < M_mass_kg
  h_A_pos      : 0 < Area_m2
  h_kap_pos    : 0 < kappa_surf
  h_G_pos      : 0 < G_N
  h_hbar_pos   : 0 < hbar
  h_c_pos      : 0 < c_SI
  h_kB_pos     : 0 < k_B

/-- Classical Bekenstein-Hawking Area Entropy: S_BH = (k_B * c^3 * A) / (4 * G * hbar) -/
noncomputable def bekensteinHawkingEntropy (H : BlackHoleHorizonState) : ℝ :=
  (H.k_B * (H.c_SI ^ 3) * H.Area_m2) / (4 * H.G_N * H.hbar)

theorem bekensteinHawkingEntropy_pos (H : BlackHoleHorizonState) :
    0 < bekensteinHawkingEntropy H := by
  dsimp [bekensteinHawkingEntropy]
  have h_c3 : 0 < H.c_SI ^ 3 := pow_pos H.h_c_pos 3
  have h_p1 : 0 < H.k_B * (H.c_SI ^ 3) := mul_pos H.h_kB_pos h_c3
  have h_num : 0 < H.k_B * (H.c_SI ^ 3) * H.Area_m2 := mul_pos h_p1 H.h_A_pos
  have h_p2 : 0 < 4 * H.G_N := mul_pos (by norm_num) H.h_G_pos
  have h_den : 0 < 4 * H.G_N * H.hbar := mul_pos h_p2 H.h_hbar_pos
  exact div_pos h_num h_den

/-- Hawking Evaporation Temperature: T_H = (hbar * kappa) / (2 * pi * k_B * c) -/
noncomputable def hawkingTemperature (H : BlackHoleHorizonState) : ℝ :=
  (H.hbar * H.kappa_surf) / (2 * Real.pi * H.k_B * H.c_SI)

theorem hawkingTemperature_pos (H : BlackHoleHorizonState) :
    0 < hawkingTemperature H := by
  dsimp [hawkingTemperature]
  have h_num : 0 < H.hbar * H.kappa_surf := mul_pos H.h_hbar_pos H.h_kap_pos
  have h_p1 : 0 < 2 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have h_p2 : 0 < 2 * Real.pi * H.k_B := mul_pos h_p1 H.h_kB_pos
  have h_den : 0 < 2 * Real.pi * H.k_B * H.c_SI := mul_pos h_p2 H.h_c_pos
  exact div_pos h_num h_den

/-- First Law of Black Hole Mechanics: dM = (kappa / (8 * pi * G)) * dA -/
structure FirstLawMechanicsState where
  H            : BlackHoleHorizonState
  dArea        : ℝ
  dMass        : ℝ
  h_dA_pos     : 0 < dArea
  h_first_law  : dMass = (H.kappa_surf / (8 * Real.pi * H.G_N)) * dArea

theorem first_law_mass_increment_pos (F : FirstLawMechanicsState) :
    0 < F.dMass := by
  rw [F.h_first_law]
  have h_p1 : 0 < 8 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have h_den : 0 < 8 * Real.pi * F.H.G_N := mul_pos h_p1 F.H.h_G_pos
  have h_quot : 0 < F.H.kappa_surf / (8 * Real.pi * F.H.G_N) := div_pos F.H.h_kap_pos h_den
  exact mul_pos h_quot F.h_dA_pos

end GTH.Quantum
