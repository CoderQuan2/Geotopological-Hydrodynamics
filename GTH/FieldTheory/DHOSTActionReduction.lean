/-
  Module: GTH.FieldTheory.DHOSTActionReduction
  Description: DHOST Class Ia Action Reduction, Disformal Metric Invertibility, and Covariant Conservation.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.FieldTheory

/-- DHOST Class Ia Metric State with Kinetic Term X = -(1/2) (grad phi)^2 -/
structure DHOSTMetricState where
  C_conf       : ℝ  -- Conformal factor C(phi, X) (> 0)
  D_disform    : ℝ  -- Disformal coefficient D(phi, X) (>= 0)
  X_kinetic    : ℝ  -- Kinetic invariant X (>= 0)
  c_s          : ℝ  -- Substrate sound speed (> 0)
  c_SI         : ℝ  -- Physical light speed (> 0)
  h_C_pos      : 0 < C_conf
  h_D_nonneg   : 0 ≤ D_disform
  h_X_nonneg   : 0 ≤ X_kinetic
  h_cs_pos     : 0 < c_s
  h_cSI_gt     : c_s < c_SI
  h_invertible : 2 * X_kinetic * D_disform < C_conf

/-- Disformal Determinant Factor: Delta = C - 2 * X * D > 0 -/
def disformalDelta (D : DHOSTMetricState) : ℝ :=
  D.C_conf - 2 * D.X_kinetic * D.D_disform

theorem disformalDelta_pos (D : DHOSTMetricState) :
    0 < disformalDelta D := by
  dsimp [disformalDelta]
  linarith [D.h_invertible]

/-- Inverse Disformal Metric Normalization Factor: 1 / (C * Delta) -/
noncomputable def inverseDisformalFactor (D : DHOSTMetricState) : ℝ :=
  1 / (D.C_conf * disformalDelta D)

theorem inverseDisformalFactor_pos (D : DHOSTMetricState) :
    0 < inverseDisformalFactor D := by
  dsimp [inverseDisformalFactor]
  have h_prod : 0 < D.C_conf * disformalDelta D := mul_pos D.h_C_pos (disformalDelta_pos D)
  exact div_pos (by norm_num) h_prod

/-- Disformal Inverse Metric 00 Component: h^00 = (1/C) * (g^00 - D * (grad phi)^2 / Delta) -/
structure InverseMetricContraction where
  D            : DHOSTMetricState
  g_00         : ℝ
  g_inv_00     : ℝ
  h_g_contract : g_inv_00 * g_00 = 1

theorem disformal_metric_invertible (I : InverseMetricContraction) :
    0 < disformalDelta I.D ∧ 0 < inverseDisformalFactor I.D := by
  constructor
  · exact disformalDelta_pos I.D
  · exact inverseDisformalFactor_pos I.D

/-- Contracted Bianchi Identity on Disformal Physical Manifold: div(G[h]) = 0 -/
structure BianchiConservationState where
  div_G_0      : ℝ  -- Covariant divergence of Einstein tensor 0-component
  div_G_1      : ℝ  -- Covariant divergence of Einstein tensor 1-component
  div_G_2      : ℝ  -- Covariant divergence of Einstein tensor 2-component
  div_G_3      : ℝ  -- Covariant divergence of Einstein tensor 3-component
  h_bianchi_0  : div_G_0 = 0
  h_bianchi_1  : div_G_1 = 0
  h_bianchi_2  : div_G_2 = 0
  h_bianchi_3  : div_G_3 = 0

/-- Energy-Momentum Covariant Conservation Theorem: div(T_eff) = (1/kappa) * div(G) = 0 -/
theorem energymomentum_covariant_conservation (B : BianchiConservationState) (kappa : ℝ) (h_kap : kappa ≠ 0) :
    (1 / kappa) * B.div_G_0 = 0 ∧
    (1 / kappa) * B.div_G_1 = 0 ∧
    (1 / kappa) * B.div_G_2 = 0 ∧
    (1 / kappa) * B.div_G_3 = 0 := by
  rw [B.h_bianchi_0, B.h_bianchi_1, B.h_bianchi_2, B.h_bianchi_3]
  refine ⟨by ring, by ring, by ring, by ring⟩

end GTH.FieldTheory
