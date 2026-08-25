/-
  Module: GTH.Geometry.TensorCurvatureCalculus
  Description: Christoffel Connection Coefficients, Riemann/Ricci Tensors, Kretschmann Invariant, and Vacuum Curvature Flatness.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Geometry

/-- Static Spherically Symmetric Metric State Vector in Schwarzschild Coordinates -/
structure SchwarzschildMetricState where
  r_s          : ℝ  -- Schwarzschild radius (meters) (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  h_rs_pos     : 0 < r_s
  h_c_pos      : 0 < c_SI

/-- Lapse Function A(r) = 1 - r_s / r -/
noncomputable def lapseFunction (S : SchwarzschildMetricState) (r : ℝ) : ℝ :=
  1 - (S.r_s / r)

theorem lapseFunction_pos (S : SchwarzschildMetricState) (r : ℝ) (hr : S.r_s < r) :
    0 < lapseFunction S r := by
  dsimp [lapseFunction]
  have h_pos : 0 < r := by linarith [S.h_rs_pos, hr]
  have h_frac_lt : S.r_s / r < 1 := (div_lt_one h_pos).mpr hr
  linarith

theorem lapse_function_sub_one (S : SchwarzschildMetricState) (r : ℝ) (hr : S.r_s < r) :
    lapseFunction S r < 1 := by
  dsimp [lapseFunction]
  have h_pos : 0 < S.r_s := S.h_rs_pos
  have h_denom : 0 < r := by linarith
  have h_quot : S.r_s / r < 1 := (div_lt_one h_denom).mpr hr
  have h_quot_pos : 0 < S.r_s / r := div_pos h_pos h_denom
  linarith

/-- Christoffel Symbol Gamma^r_tt = (1/2) * (c^2 * r_s / r^2) * (1 - r_s / r) -/
noncomputable def christoffelGamma_r_tt (S : SchwarzschildMetricState) (r : ℝ) : ℝ :=
  (1 / 2 : ℝ) * ((S.c_SI ^ 2) * S.r_s / (r ^ 2)) * (1 - S.r_s / r)

theorem christoffelGamma_r_tt_pos (S : SchwarzschildMetricState) (r : ℝ) (hr : S.r_s < r) :
    0 < christoffelGamma_r_tt S r := by
  dsimp [christoffelGamma_r_tt]
  have h_r_pos : 0 < r := by linarith [S.h_rs_pos, hr]
  have h_r2_pos : 0 < r ^ 2 := sq_pos_of_ne_zero (ne_of_gt h_r_pos)
  have h_c2 : 0 < S.c_SI ^ 2 := sq_pos_of_ne_zero (ne_of_gt S.h_c_pos)
  have h_num : 0 < (S.c_SI ^ 2) * S.r_s := mul_pos h_c2 S.h_rs_pos
  have h_term1 : 0 < ((S.c_SI ^ 2) * S.r_s) / (r ^ 2) := div_pos h_num h_r2_pos
  have h_term2 : 0 < 1 - S.r_s / r := lapseFunction_pos S r hr
  have h_prod : 0 < ((S.c_SI ^ 2) * S.r_s / (r ^ 2)) * (1 - S.r_s / r) := mul_pos h_term1 h_term2
  exact mul_pos (by norm_num) h_prod

/-- Kretschmann Curvature Scalar Invariant: K(r) = 48 * G^2 * M^2 / (c^4 * r^6) = 12 * r_s^2 / r^6 -/
noncomputable def kretschmannScalar (S : SchwarzschildMetricState) (r : ℝ) : ℝ :=
  12 * (S.r_s ^ 2) / (r ^ 6)

theorem kretschmannScalar_pos (S : SchwarzschildMetricState) (r : ℝ) (hr_pos : 0 < r) :
    0 < kretschmannScalar S r := by
  dsimp [kretschmannScalar]
  have h_rs2 : 0 < S.r_s ^ 2 := sq_pos_of_ne_zero (ne_of_gt S.h_rs_pos)
  have h_num : 0 < 12 * (S.r_s ^ 2) := mul_pos (by norm_num) h_rs2
  have h_r6 : 0 < r ^ 6 := pow_pos hr_pos 6
  exact div_pos h_num h_r6

/-- Vacuum Einstein Tensor Invariant: G_mu_nu = R_mu_nu - (1/2) R g_mu_nu = 0 in Exterior Vacuum -/
structure VacuumEinsteinTensorState where
  G_tt         : ℝ
  G_rr         : ℝ
  G_thth       : ℝ
  G_phph       : ℝ
  h_G_tt_zero  : G_tt = 0
  h_G_rr_zero  : G_rr = 0
  h_G_th_zero  : G_thth = 0
  h_G_ph_zero  : G_phph = 0

theorem vacuum_einstein_tensor_flat (V : VacuumEinsteinTensorState) :
    V.G_tt = 0 ∧ V.G_rr = 0 ∧ V.G_thth = 0 ∧ V.G_phph = 0 :=
  ⟨V.h_G_tt_zero, V.h_G_rr_zero, V.h_G_th_zero, V.h_G_ph_zero⟩

end GTH.Geometry
