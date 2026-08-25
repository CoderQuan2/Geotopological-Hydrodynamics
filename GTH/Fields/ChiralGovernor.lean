import Mathlib.Data.Real.Basic

noncomputable section

namespace GTH.Fields

structure ChiralFieldAtPoint where
  chi_val   : ℝ
  h_chi_nonneg : 0 ≤ chi_val
  h_chi_lt_one : chi_val < 1

structure BareMass where
  M_G   : ℝ
  h_pos : 0 < M_G

noncomputable def effectiveMassSq (B : BareMass) (C : ChiralFieldAtPoint) : ℝ :=
  (B.M_G ^ 2) * (1 - C.chi_val)

theorem effectiveMassSq_pos (B : BareMass) (C : ChiralFieldAtPoint) :
    0 < effectiveMassSq B C := by
  dsimp [effectiveMassSq]
  have h_MG2_pos : 0 < B.M_G ^ 2 := sq_pos_of_ne_zero (ne_of_gt B.h_pos)
  have h_factor_pos : 0 < 1 - C.chi_val := sub_pos.mpr C.h_chi_lt_one
  exact mul_pos h_MG2_pos h_factor_pos

theorem effectiveMassSq_le_bare (B : BareMass) (C : ChiralFieldAtPoint) :
    effectiveMassSq B C ≤ B.M_G ^ 2 := by
  dsimp [effectiveMassSq]
  have h_MG2_nonneg : 0 ≤ B.M_G ^ 2 := sq_nonneg B.M_G
  have h_factor_le_one : 1 - C.chi_val ≤ 1 := by linarith [C.h_chi_nonneg]
  calc
    B.M_G ^ 2 * (1 - C.chi_val) ≤ B.M_G ^ 2 * 1 := mul_le_mul_of_nonneg_left h_factor_le_one h_MG2_nonneg
    _ = B.M_G ^ 2 := mul_one (B.M_G ^ 2)

theorem chiral_orthogonality_governor_bounds (B : BareMass) (C : ChiralFieldAtPoint) :
    0 < effectiveMassSq B C ∧ effectiveMassSq B C ≤ B.M_G ^ 2 := by
  constructor
  · exact effectiveMassSq_pos B C
  · exact effectiveMassSq_le_bare B C

end GTH.Fields
