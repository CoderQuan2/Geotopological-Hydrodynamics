/-
  Module: GTH.Fields.FunctionalRG
  Description: Wetterich Functional Renormalization Group (FRG) Flow, Litim Regulator, and Density Ceiling.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Fields

/-- Substrate Coupling Flow Parameters under Wetterich FRG -/
structure FRGFlowState where
  k_scale     : ℝ  -- Renormalization scale k
  lambda_top  : ℝ  -- Topological coupling constant
  alpha_c     : ℝ  -- Conformal coupling weight
  kappa_SI    : ℝ  -- Induced gravitational metric coupling
  rho_density : ℝ  -- Condensate density
  h_k_pos     : 0 < k_scale
  h_lambda    : 0 < lambda_top
  h_alpha     : 0 < alpha_c
  h_kappa     : 0 < kappa_SI
  h_rho_nonneg: 0 ≤ rho_density

/-- Maximum Condensate Density Ceiling rho_max = 1 / (2 * alpha * kappa) -/
noncomputable def rhoMax (F : FRGFlowState) : ℝ :=
  1 / (2 * F.alpha_c * F.kappa_SI)

/-- Theorem: Density Ceiling rho_max is strictly positive -/
theorem rhoMax_pos (F : FRGFlowState) : 0 < rhoMax F := by
  dsimp [rhoMax]
  have h_denom : 0 < 2 * F.alpha_c * F.kappa_SI := mul_pos (mul_pos (by norm_num) F.h_alpha) F.h_kappa
  exact div_pos (by norm_num) h_denom

/-- Non-Perturbative Logarithmic Barrier Potential: V_top(rho) = -lambda_top * ln(1 - 2*alpha*kappa*rho) -/
structure BarrierDerivativeState where
  F           : FRGFlowState
  h_sub_ceil  : F.rho_density < rhoMax F

/-- Derivative of the topological potential dV_top / drho = (2 * alpha * kappa * lambda_top) / (1 - 2*alpha*kappa*rho) -/
noncomputable def dVtop_drho (B : BarrierDerivativeState) : ℝ :=
  (2 * B.F.alpha_c * B.F.kappa_SI * B.F.lambda_top) / (1 - 2 * B.F.alpha_c * B.F.kappa_SI * B.F.rho_density)

/-- Theorem: Topological potential derivative is strictly positive below the ceiling -/
theorem dVtop_drho_pos (B : BarrierDerivativeState) : 0 < dVtop_drho B := by
  dsimp [dVtop_drho]
  have h_num : 0 < 2 * B.F.alpha_c * B.F.kappa_SI * B.F.lambda_top := by
    apply mul_pos
    · apply mul_pos
      · exact mul_pos (by norm_num) B.F.h_alpha
      · exact B.F.h_kappa
    · exact B.F.h_lambda
  have h_denom : 0 < 1 - 2 * B.F.alpha_c * B.F.kappa_SI * B.F.rho_density := by
    have h_ceil := B.h_sub_ceil
    dsimp [rhoMax] at h_ceil
    have h_prod_pos : 0 < 2 * B.F.alpha_c * B.F.kappa_SI := mul_pos (mul_pos (by norm_num) B.F.h_alpha) B.F.h_kappa
    have h_ineq := (lt_div_iff₀ h_prod_pos).mp h_ceil
    linarith
  exact div_pos h_num h_denom

end GTH.Fields
