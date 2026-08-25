/-
  Module: GTH.Astro.BekensteinHawkingMicrostateEntropy
  Description: Bekenstein-Hawking Horizon Area Entropy S = A / (4*l_P^2), Microstate Counting, and Hawking Temperature.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

/-- Black Hole / Compact Remnant Horizon Thermodynamic State Vector -/
structure HorizonThermodynamicState where
  M_mass_kg    : ℝ  -- Remnant mass (kg) (> 0)
  Area_m2      : ℝ  -- Horizon surface area (m^2) (> 0)
  l_Planck_m   : ℝ  -- Planck length l_P = sqrt(hbar * G / c^3) (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  k_B          : ℝ  -- Boltzmann constant (> 0)
  h_M_pos      : 0 < M_mass_kg
  h_A_pos      : 0 < Area_m2
  h_lp_pos     : 0 < l_Planck_m
  h_G_pos      : 0 < G_N
  h_c_pos      : 0 < c_SI
  h_hb_pos     : 0 < hbar
  h_kB_pos     : 0 < k_B

/-- Bekenstein-Hawking Horizon Entropy: S_BH = (k_B * Area) / (4 * l_Planck^2) -/
noncomputable def bekensteinHawkingEntropy (H : HorizonThermodynamicState) : ℝ :=
  (H.k_B * H.Area_m2) / (4 * (H.l_Planck_m ^ 2))

theorem bekensteinHawkingEntropy_pos (H : HorizonThermodynamicState) :
    0 < bekensteinHawkingEntropy H := by
  dsimp [bekensteinHawkingEntropy]
  have h_num : 0 < H.k_B * H.Area_m2 := mul_pos H.h_kB_pos H.h_A_pos
  have h_lp2 : 0 < H.l_Planck_m ^ 2 := sq_pos_of_ne_zero (ne_of_gt H.h_lp_pos)
  have h_den : 0 < 4 * (H.l_Planck_m ^ 2) := mul_pos (by norm_num) h_lp2
  exact div_pos h_num h_den

/-- Hawking Radiation Temperature: T_H = (hbar * c^3) / (8 * pi * G * M * k_B) -/
noncomputable def hawkingTemperature (H : HorizonThermodynamicState) : ℝ :=
  (H.hbar * (H.c_SI ^ 3)) / (8 * Real.pi * H.G_N * H.M_mass_kg * H.k_B)

theorem hawkingTemperature_pos (H : HorizonThermodynamicState) :
    0 < hawkingTemperature H := by
  dsimp [hawkingTemperature]
  have h_c3 : 0 < H.c_SI ^ 3 := pow_pos H.h_c_pos 3
  have h_num : 0 < H.hbar * (H.c_SI ^ 3) := mul_pos H.h_hb_pos h_c3
  have p1 : 0 < 8 * Real.pi := mul_pos (by norm_num) Real.pi_pos
  have p2 : 0 < p1 * H.G_N := mul_pos p1 H.h_G_pos
  have p3 : 0 < p2 * H.M_mass_kg := mul_pos p2 H.h_M_pos
  have h_den : 0 < p3 * H.k_B := mul_pos p3 H.h_kB_pos
  exact div_pos h_num h_den

/-- First Law of Horizon Thermodynamics: dE = T_H * dS -/
structure FirstLawState where
  T_H          : ℝ
  dS           : ℝ
  dE           : ℝ
  h_T_pos      : 0 < T_H
  h_dS_pos     : 0 < dS
  h_first_law  : dE = T_H * dS

theorem horizon_first_law_energy_pos (F : FirstLawState) :
    0 < F.dE := by
  rw [F.h_first_law]
  exact mul_pos F.h_T_pos F.h_dS_pos

end GTH.Astro
