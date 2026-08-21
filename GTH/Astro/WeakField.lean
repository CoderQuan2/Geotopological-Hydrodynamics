import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Astro

structure AstroConstants where
  G_newton : ℝ
  c_light  : ℝ
  h_G      : 0 < G_newton
  h_c      : 0 < c_light

variable (A : AstroConstants)

noncomputable def rho_topological (vorticity_sq : ℝ) (h_vort_nonneg : 0 ≤ vorticity_sq) : ℝ :=
  (1 / (8 * Real.pi * A.G_newton * (A.c_light ^ 2))) * vorticity_sq

theorem rho_topological_nonneg (vorticity_sq : ℝ) (h_vort_nonneg : 0 ≤ vorticity_sq) :
    0 ≤ rho_topological A vorticity_sq h_vort_nonneg := by
  dsimp [rho_topological]
  have h_pi_pos : 0 < Real.pi := Real.pi_pos
  have h_c2_pos : 0 < A.c_light ^ 2 := sq_pos_of_ne_zero (ne_of_gt A.h_c)
  have h_denom : 0 < 8 * Real.pi * A.G_newton * (A.c_light ^ 2) := by
    apply mul_pos
    apply mul_pos
    apply mul_pos (by norm_num) h_pi_pos
    exact A.h_G
    exact h_c2_pos
  have h_coeff : 0 < 1 / (8 * Real.pi * A.G_newton * (A.c_light ^ 2)) := div_pos (by norm_num) h_denom
  exact mul_nonneg (le_of_lt h_coeff) h_vort_nonneg

noncomputable def v_flat_quartic (M_bar : ℝ) (a_0 : ℝ) : ℝ :=
  A.G_newton * M_bar * a_0

theorem v_flat_quartic_pos (M_bar a_0 : ℝ) (hM : 0 < M_bar) (ha : 0 < a_0) :
    0 < v_flat_quartic A M_bar a_0 := by
  dsimp [v_flat_quartic]
  exact mul_pos (mul_pos A.h_G hM) ha

end GTH.Astro
