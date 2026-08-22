/-
  Module: GTH.Quantum.CasimirThreshold
  Description: 5D Kaluza-Klein Modular Casimir Radiative Loop Correction and Exact Newton Coupling Closure.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Quantum

/-- Kaluza-Klein Casimir Threshold State on S¹_tau of length L_tau -/
structure KKCasimirState where
  G5           : ℝ  -- 5D Bulk Newton constant (> 0)
  L_tau        : ℝ  -- Fiber length (> 0)
  zeta_3       : ℝ  -- Apéry constant zeta(3) (~ 1.2020569)
  h_G5_pos     : 0 < G5
  h_L_pos      : 0 < L_tau
  h_zeta3_pos  : 0 < zeta_3

/-- 1-Loop Radiative Offset Factor: delta_loop = (G5 * zeta(3)) / (12 * pi * L_tau^3) -/
noncomputable def deltaLoopCorrection (K : KKCasimirState) : ℝ :=
  (K.G5 * K.zeta_3) / (12 * Real.pi * (K.L_tau ^ 3))

theorem deltaLoopCorrection_pos (K : KKCasimirState) :
    0 < deltaLoopCorrection K := by
  dsimp [deltaLoopCorrection]
  have h_pi : 0 < Real.pi := Real.pi_pos
  have h_num : 0 < K.G5 * K.zeta_3 := mul_pos K.h_G5_pos K.h_zeta3_pos
  have h_L3 : 0 < K.L_tau ^ 3 := pow_pos K.h_L_pos 3
  have h_denom : 0 < 12 * Real.pi * (K.L_tau ^ 3) := mul_pos (mul_pos (by norm_num) h_pi) h_L3
  exact div_pos h_num h_denom

/-- Bare Geometric Model Coupling G_model = G5 / L_tau -/
def G_model_tree (K : KKCasimirState) : ℝ :=
  K.G5 / K.L_tau

/-- Physical Renormalized 4D Newton Constant: G_eff = G_model * (1 + delta_loop) -/
noncomputable def G_eff_renormalized (K : KKCasimirState) : ℝ :=
  (G_model_tree K) * (1 + deltaLoopCorrection K)

theorem G_eff_strictly_exceeds_tree (K : KKCasimirState) :
    G_model_tree K < G_eff_renormalized K := by
  dsimp [G_eff_renormalized]
  have h_tree_pos : 0 < G_model_tree K := div_pos K.h_G5_pos K.h_L_pos
  have h_delta_pos : 0 < deltaLoopCorrection K := deltaLoopCorrection_pos K
  have h_factor : 1 < 1 + deltaLoopCorrection K := by linarith
  have h_mul := mul_lt_mul_of_pos_left h_factor h_tree_pos
  rw [mul_one] at h_mul
  exact h_mul

end GTH.Quantum
