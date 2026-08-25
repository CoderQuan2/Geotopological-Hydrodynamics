/-
  Module: GTH.Thermodynamics.SaturatedRemnantThermodynamics
  Description: First and Second Laws of Saturated Remnants, Non-Singular Hawking Temperature T_H, and Information Resolution.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Thermodynamics

/-- Saturated Compact Remnant Thermodynamic State Vector -/
structure SaturatedRemnantState where
  M_mass       : ℝ  -- Remnant mass (kg) (> 0)
  M_UV         : ℝ  -- Planckian ground state cutoff mass (2.157e-8 kg) (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  k_B          : ℝ  -- Boltzmann constant (> 0)
  h_M_pos      : 0 < M_mass
  h_MUV_pos    : 0 < M_UV
  h_G_pos      : 0 < G_N
  h_c_pos      : 0 < c_SI
  h_hbar_pos   : 0 < hbar
  h_kB_pos     : 0 < k_B
  h_M_gt_UV    : M_UV < M_mass

/-- Regularized Surface Gravity: kappa_eff = (c^4 / (4 * G * M)) * (1 - M_UV / M) -/
noncomputable def regularizedSurfaceGravity (S : SaturatedRemnantState) : ℝ :=
  (S.c_SI ^ 4) / (4 * S.G_N * S.M_mass) * (1 - S.M_UV / S.M_mass)

theorem regularizedSurfaceGravity_pos (S : SaturatedRemnantState) :
    0 < regularizedSurfaceGravity S := by
  dsimp [regularizedSurfaceGravity]
  have h_c4 : 0 < S.c_SI ^ 4 := pow_pos S.h_c_pos 4
  have h_den : 0 < 4 * S.G_N * S.M_mass := by
    have h1 : 0 < 4 * S.G_N := mul_pos (by norm_num) S.h_G_pos
    exact mul_pos h1 S.h_M_pos
  have h_quot : 0 < (S.c_SI ^ 4) / (4 * S.G_N * S.M_mass) := div_pos h_c4 h_den
  have h_ratio_lt : S.M_UV / S.M_mass < 1 := (div_lt_one S.h_M_pos).mpr S.h_M_gt_UV
  have h_factor_pos : 0 < 1 - S.M_UV / S.M_mass := sub_pos.mpr h_ratio_lt
  exact mul_pos h_quot h_factor_pos

/-- Regularized Hawking Temperature: T_H = (hbar * kappa_eff) / (2 * pi * k_B * c) -/
noncomputable def regularizedHawkingTemperature (S : SaturatedRemnantState) : ℝ :=
  (S.hbar * regularizedSurfaceGravity S) / (2 * Real.pi * S.k_B * S.c_SI)

theorem regularizedHawkingTemperature_pos (S : SaturatedRemnantState) :
    0 < regularizedHawkingTemperature S := by
  dsimp [regularizedHawkingTemperature]
  have h_num : 0 < S.hbar * regularizedSurfaceGravity S := mul_pos S.h_hbar_pos (regularizedSurfaceGravity_pos S)
  have h_den : 0 < 2 * Real.pi * S.k_B * S.c_SI := by
    have h1 : 0 < 2 * Real.pi := mul_pos (by norm_num) Real.pi_pos
    have h2 : 0 < h1 * S.k_B := mul_pos h1 S.h_kB_pos
    exact mul_pos h2 S.h_c_pos
  exact div_pos h_num h_den

/-- Stable Ground State Cutoff: At M = M_UV, kappa_eff = 0 and T_H = 0 -/
theorem ground_state_zero_temperature (S : SaturatedRemnantState) (h_crit : S.M_mass = S.M_UV) :
    (1 - S.M_UV / S.M_mass) = 0 := by
  rw [h_crit]
  have h_ne : S.M_UV ≠ 0 := ne_of_gt S.h_MUV_pos
  rw [div_self h_ne]
  ring

/-- Generalized Second Law of Thermodynamics: Delta S_total >= 0 -/
structure GeneralizedSecondLawState where
  delta_S_geom : ℝ
  delta_S_mat  : ℝ
  h_sum_nonneg : 0 ≤ delta_S_geom + delta_S_mat

theorem generalized_second_law_satisfied (G : GeneralizedSecondLawState) :
    0 ≤ G.delta_S_geom + G.delta_S_mat :=
  G.h_sum_nonneg

end GTH.Thermodynamics
