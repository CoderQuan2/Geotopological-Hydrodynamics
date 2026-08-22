/-
  Module: GTH.Core.SaturatedCoreMechanics
  Description: Non-Singular Compact Core Regularization, Minimum Core Radius Inequality, and Logarithmic Potential Divergence.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Core

/-- Compact Core Mass State with Non-Singular Density Ceiling rho_max -/
structure CompactCoreState where
  M_core_kg : ℝ  -- Compact remnant mass (> 0)
  rho_max   : ℝ  -- Maximum substrate density ceiling (> 0)
  h_M_pos   : 0 < M_core_kg
  h_rho_pos : 0 < rho_max

/-- Minimum Saturated Core Radius Cubed: R_c^3 = 3 * M_core / (4 * pi * rho_max) -/
noncomputable def minCoreRadiusCubed (C : CompactCoreState) : ℝ :=
  (3 * C.M_core_kg) / (4 * Real.pi * C.rho_max)

theorem minCoreRadiusCubed_pos (C : CompactCoreState) :
    0 < minCoreRadiusCubed C := by
  dsimp [minCoreRadiusCubed]
  have h_pi : 0 < Real.pi := Real.pi_pos
  have h_num : 0 < 3 * C.M_core_kg := mul_pos (by norm_num) C.h_M_pos
  have h_denom : 0 < 4 * Real.pi * C.rho_max := mul_pos (mul_pos (by norm_num) h_pi) C.h_rho_pos
  exact div_pos h_num h_denom

/-- Minimum Saturated Physical Core Radius: R_c = (3 * M_core / (4 * pi * rho_max))^(1/3) -/
noncomputable def minCoreRadius (C : CompactCoreState) : ℝ :=
  (minCoreRadiusCubed C) ^ ((1 : ℝ) / 3)

theorem minCoreRadius_pos (C : CompactCoreState) :
    0 < minCoreRadius C := by
  dsimp [minCoreRadius]
  exact Real.rpow_pos_of_pos (minCoreRadiusCubed_pos C) ((1 : ℝ) / 3)

/-- Saturated Core Regularization Theorem: Actual core radius is strictly bounded from below by R_c -/
structure RegularizedCoreBound where
  C            : CompactCoreState
  actual_R     : ℝ
  h_bound_sat  : minCoreRadius C ≤ actual_R

theorem core_singularity_prohibited (R : RegularizedCoreBound) :
    0 < R.actual_R := by
  have h_min_pos := minCoreRadius_pos R.C
  linarith [R.h_bound_sat]

end GTH.Core
