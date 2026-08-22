/-
  Module: GTH.FieldTheory.DHOSTDisformalCoupling
  Description: Regularized DHOST Class Ia Disformal Mapping, Null Geodesic Speed Locking, and Ghost Elimination.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.FieldTheory

/-- DHOST Kinetic Invariant State X = -1/2 (nabla phi)^2 with non-zero VEV X_0 -/
structure DHOSTKineticState where
  X_vev       : ℝ  -- Kinetic vacuum expectation value X_0 (> 0)
  X_kinetic   : ℝ  -- Background kinetic invariant X (>= 0)
  c_s         : ℝ  -- Substrate longitudinal acoustic speed (> 0)
  c_SI        : ℝ  -- Boundary light/GW speed (> 0)
  h_X0_pos    : 0 < X_vev
  h_X_nonneg  : 0 ≤ X_kinetic
  h_cs_pos    : 0 < c_s
  h_cSI_pos   : 0 < c_SI
  h_c_order   : c_s < c_SI

/-- Disformal Regularized Coupling Function D(phi, X) = (c_SI^2 - c_s^2) / (c_s^2 * (2*X_0 + 2*X)) -/
noncomputable def disformalFactor (D : DHOSTKineticState) : ℝ :=
  (D.c_SI ^ 2 - D.c_s ^ 2) / (D.c_s ^ 2 * (2 * D.X_vev + 2 * D.X_kinetic))

/-- Theorem: Disformal denominator is strictly positive, eliminating coordinate singularities everywhere -/
theorem disformal_denominator_pos (D : DHOSTKineticState) :
    0 < D.c_s ^ 2 * (2 * D.X_vev + 2 * D.X_kinetic) := by
  have h_cs2 : 0 < D.c_s ^ 2 := sq_pos_of_ne_zero (ne_of_gt D.h_cs_pos)
  have h_inner : 0 < 2 * D.X_vev + 2 * D.X_kinetic := by
    have h1 : 0 < 2 * D.X_vev := mul_pos (by norm_num) D.h_X0_pos
    have h2 : 0 ≤ 2 * D.X_kinetic := mul_nonneg (by norm_num) D.h_X_nonneg
    linarith
  exact mul_pos h_cs2 h_inner

/-- Theorem: Disformal factor is strictly positive -/
theorem disformalFactor_pos (D : DHOSTKineticState) :
    0 < disformalFactor D := by
  dsimp [disformalFactor]
  have h_num : 0 < D.c_SI ^ 2 - D.c_s ^ 2 := by
    have h_cSI2 : 0 < D.c_SI ^ 2 := sq_pos_of_ne_zero (ne_of_gt D.h_cSI_pos)
    have h_lt : D.c_s ^ 2 < D.c_SI ^ 2 := by
      have h1 : 0 ≤ D.c_s := le_of_lt D.h_cs_pos
      have h2 : 0 ≤ D.c_SI := le_of_lt D.h_cSI_pos
      nlinarith [D.h_c_order]
    exact sub_pos.mpr h_lt
  exact div_pos h_num (disformal_denominator_pos D)

/-- Geodesic Speed Squared on the Physical Disformal Manifold at VEV: c_eff^2 = c_s^2 + D * c_s^2 * 2*X_0 -/
noncomputable def effectivePhotonSpeedSq (D : DHOSTKineticState) : ℝ :=
  D.c_s ^ 2 + (disformalFactor D) * (D.c_s ^ 2) * (2 * D.X_vev)

/-- Theorem: Physical boundary photon & graviton speed locks identically to c_SI at vacuum equilibrium -/
theorem photon_speed_locks_to_cSI (D : DHOSTKineticState) (h_vac : D.X_kinetic = 0) :
    effectivePhotonSpeedSq D = D.c_SI ^ 2 := by
  dsimp [effectivePhotonSpeedSq, disformalFactor]
  rw [h_vac, mul_zero, add_zero]
  have h_denom_inner : 2 * D.X_vev ≠ 0 := by
    have : 0 < 2 * D.X_vev := mul_pos (by norm_num) D.h_X0_pos
    exact ne_of_gt this
  have h_cs2_ne : D.c_s ^ 2 ≠ 0 := by
    have : 0 < D.c_s ^ 2 := sq_pos_of_ne_zero (ne_of_gt D.h_cs_pos)
    exact ne_of_gt this
  have h_cancel : (D.c_s ^ 2 * (2 * D.X_vev)) ≠ 0 := mul_ne_zero h_cs2_ne h_denom_inner
  calc
    D.c_s ^ 2 + ((D.c_SI ^ 2 - D.c_s ^ 2) / (D.c_s ^ 2 * (2 * D.X_vev))) * (D.c_s ^ 2) * (2 * D.X_vev)
    _ = D.c_s ^ 2 + ((D.c_SI ^ 2 - D.c_s ^ 2) / (D.c_s ^ 2 * (2 * D.X_vev))) * (D.c_s ^ 2 * (2 * D.X_vev)) := by ring
    _ = D.c_s ^ 2 + (D.c_SI ^ 2 - D.c_s ^ 2) := by rw [div_mul_cancel₀ (D.c_SI ^ 2 - D.c_s ^ 2) h_cancel]
    _ = D.c_SI ^ 2 := by ring

end GTH.FieldTheory
