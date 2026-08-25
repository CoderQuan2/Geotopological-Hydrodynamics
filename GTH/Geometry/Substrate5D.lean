/-
  Module: GTH.Geometry.Substrate5D
  Description: 5D Kaluza-Klein Metric Foliation, Compact Fiber Length L_tau, and Effective 4D Newton Constant G_4 = G_5 / L_tau.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Geometry

/-- 5D Substrate Metric Foliation State Vector -/
structure Substrate5DState where
  L_tau        : ℝ  -- Compact fiber length scale (meters) (> 0)
  G_5          : ℝ  -- 5D Newton gravitational coupling (> 0)
  c_sub        : ℝ  -- Substrate shear acoustic speed (> 0)
  h_L_pos      : 0 < L_tau
  h_G5_pos     : 0 < G_5
  h_csub_pos   : 0 < c_sub

/-- Effective 4D Newton Constant: G_4 = G_5 / L_tau -/
noncomputable def effectiveNewtonConstant4D (S : Substrate5DState) : ℝ :=
  S.G_5 / S.L_tau

theorem effectiveNewtonConstant4D_pos (S : Substrate5DState) :
    0 < effectiveNewtonConstant4D S := by
  dsimp [effectiveNewtonConstant4D]
  exact div_pos S.h_G5_pos S.h_L_pos

/-- Compact Fiber Scale Inversion: L_tau = G_5 / G_4 -/
theorem fiber_scale_inversion (S : Substrate5DState) :
    S.G_5 / (effectiveNewtonConstant4D S) = S.L_tau := by
  dsimp [effectiveNewtonConstant4D]
  have hL_ne : S.L_tau ≠ 0 := ne_of_gt S.h_L_pos
  have hG_ne : S.G_5 ≠ 0 := ne_of_gt S.h_G5_pos
  have : S.G_5 / (S.G_5 / S.L_tau) = S.G_5 * (S.L_tau / S.G_5) := by ring
  rw [this]
  have : S.G_5 * (S.L_tau / S.G_5) = (S.G_5 / S.G_5) * S.L_tau := by ring
  rw [this, div_self hG_ne, one_mul]

/-- Reduction to 4D Einstein-Hilbert Action: G_4 * L_tau = G_5 -/
theorem effective_newton_constant (G5 : ℝ) (L_tau : ℝ) (h_pos : 0 < L_tau) :
    (G5 / L_tau) * L_tau = G5 := by
  have h_ne : L_tau ≠ 0 := ne_of_gt h_pos
  have : (G5 / L_tau) * L_tau = G5 * (L_tau / L_tau) := by ring
  rw [this, div_self h_ne, mul_one]

end GTH.Geometry
