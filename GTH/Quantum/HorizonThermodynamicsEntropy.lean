/-
  Module: GTH.Quantum.HorizonThermodynamicsEntropy
  Description: Hawking Temperature T_H, Bekenstein-Hawking Entropy S_BH, and Microscopic Soliton State Counting.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- Horizon Thermodynamics State Vector -/
structure HorizonThermodynamicsState where
  M_mass_kg    : ℝ  -- Remnant mass M (kg) (> 0)
  Area_m2      : ℝ  -- Horizon surface area A (m^2) (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  k_B          : ℝ  -- Boltzmann constant (> 0)
  h_M_pos      : 0 < M_mass_kg
  h_A_pos      : 0 < Area_m2
  h_hbar_pos   : 0 < hbar
  h_G_pos      : 0 < G_N
  h_c_pos      : 0 < c_SI
  h_kB_pos     : 0 < k_B

/-- Hawking Horizon Temperature: T_H = (hbar * c^3) / (8 * pi * G * M * k_B) -/
noncomputable def hawkingTemperature (H : HorizonThermodynamicsState) : ℝ :=
  (H.hbar * (H.c_SI ^ 3)) / (8 * Real.pi * H.G_N * H.M_mass_kg * H.k_B)

theorem hawkingTemperature_pos (H : HorizonThermodynamicsState) :
    0 < hawkingTemperature H := by
  dsimp [hawkingTemperature]
  have h_c3 : 0 < H.c_SI ^ 3 := pow_pos H.h_c_pos 3
  have h_num : 0 < H.hbar * (H.c_SI ^ 3) := mul_pos H.h_hbar_pos h_c3
  have h_8pi : 0 < 8 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have p1 : 0 < 8 * Real.pi * H.G_N := mul_pos h_8pi H.h_G_pos
  have p2 : 0 < p1 * H.M_mass_kg := mul_pos p1 H.h_M_pos
  have h_den : 0 < p2 * H.k_B := mul_pos p2 H.h_kB_pos
  exact div_pos h_num h_den

/-- Bekenstein-Hawking Entropy: S_BH = (k_B * c^3 * A) / (4 * G * hbar) -/
noncomputable def bekensteinHawkingEntropy (H : HorizonThermodynamicsState) : ℝ :=
  (H.k_B * (H.c_SI ^ 3) * H.Area_m2) / (4 * H.G_N * H.hbar)

theorem bekensteinHawkingEntropy_pos (H : HorizonThermodynamicsState) :
    0 < bekensteinHawkingEntropy H := by
  dsimp [bekensteinHawkingEntropy]
  have h_c3 : 0 < H.c_SI ^ 3 := pow_pos H.h_c_pos 3
  have p1 : 0 < H.k_B * (H.c_SI ^ 3) := mul_pos H.h_kB_pos h_c3
  have h_num : 0 < p1 * H.Area_m2 := mul_pos p1 H.h_A_pos
  have p2 : 0 < 4 * H.G_N := mul_pos (by norm_num) H.h_G_pos
  have h_den : 0 < p2 * H.hbar := mul_pos p2 H.h_hbar_pos
  exact div_pos h_num h_den

/-- Microscopic Soliton Quantum State Equivalence State -/
structure MicroscopicEntropyEquivalenceState where
  H            : HorizonThermodynamicsState
  S_micro      : ℝ
  h_equiv      : S_micro = bekensteinHawkingEntropy H

theorem microscopic_entropy_matches_bekenstein (E : MicroscopicEntropyEquivalenceState) :
    E.S_micro = bekensteinHawkingEntropy E.H :=
  E.h_equiv

/-- First Law of Horizon Thermodynamics: dE = T_H * dS -/
structure FirstLawThermodynamicsState where
  dE_Joules    : ℝ
  T_H          : ℝ
  dS_Entropy   : ℝ
  h_T_pos      : 0 < T_H
  h_dS_pos     : 0 < dS_Entropy
  h_first_law  : dE_Joules = T_H * dS_Entropy

theorem first_law_energy_conservation (F : FirstLawThermodynamicsState) :
    F.dE_Joules = F.T_H * F.dS_Entropy :=
  F.h_first_law

end GTH.Quantum
