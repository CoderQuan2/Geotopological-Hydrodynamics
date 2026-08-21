/-
  Module: GTH.Fields.ChiralGovernor
  Description: Chiral Suppression Field and Strict Graviton Mass Bounds.
-/
import Mathlib.Data.Real.Basic

namespace GTH.Fields

/-- Chiral Suppression Field State at a Local Spacetime Point x -/
structure ChiralFieldAtPoint where
  chi_val   : ℝ  -- Dimensionless suppression field value
  h_chi_nonneg : 0 ≤ chi_val
  h_chi_lt_one : chi_val < 1  -- Strict asymptotic upper bound

/-- Bare Graviton Mass Parameter -/
structure BareMass where
  M_G   : ℝ
  h_pos : 0 < M_G

/-- Effective Graviton Mass Squared: M_{G,eff}^2(x) = M_G^2 * (1 - chi(x)) -/
def effectiveMassSq (B : BareMass) (C : ChiralFieldAtPoint) : ℝ :=
  (B.M_G ^ 2) * (1 - C.chi_val)

/-- Theorem: Effective Mass Squared is strictly positive -/
theorem effectiveMassSq_pos (B : BareMass) (C : ChiralFieldAtPoint) :
    0 < effectiveMassSq B C := by
  dsimp [effectiveMassSq]
  have h_MG2_pos : 0 < B.M_G ^ 2 := sq_pos_of_ne_zero (ne_of_gt B.h_pos)
  have h_factor_pos : 0 < 1 - C.chi_val := sub_pos.mpr C.h_chi_lt_one
  exact mul_pos h_MG2_pos h_factor_pos

/-- Theorem: Effective Mass Squared is bounded from above by Bare Mass Squared -/
theorem effectiveMassSq_le_bare (B : BareMass) (C : ChiralFieldAtPoint) :
    effectiveMassSq B C ≤ B.M_G ^ 2 := by
  dsimp [effectiveMassSq]
  have h_MG2_nonneg : 0 ≤ B.M_G ^ 2 := sq_nonneg B.M_G
  have h_factor_le_one : 1 - C.chi_val ≤ 1 := by
    linarith [C.h_chi_nonneg]
  nlinarith

/-- Chiral Orthogonality Governor Boundedness Theorem: 0 < M_{G,eff}^2(x) <= M_G^2 -/
theorem chiral_orthogonality_governor_bounds (B : BareMass) (C : ChiralFieldAtPoint) :
    0 < effectiveMassSq B C ∧ effectiveMassSq B C ≤ B.M_G ^ 2 := by
  constructor
  · exact effectiveMassSq_pos B C
  · exact effectiveMassSq_le_bare B C

end GTH.Fields
