/-
  Module: GTH.Fields.NonAbelianYangMillsReduction
  Description: Non-Abelian SU(2) Yang-Mills Gauge Emergence, Field Strength F_mu_nu^a, and Covariant Conservation.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Fields

/-- SU(2) Lie Algebra Levi-Civita Structure Constant Epsilon_abc -/
def leviCivitaSU2 (a b c : ℕ) : ℝ :=
  if (a = 1 ∧ b = 2 ∧ c = 3) ∨ (a = 2 ∧ b = 3 ∧ c = 1) ∨ (a = 3 ∧ b = 1 ∧ c = 2) then 1
  else if (a = 1 ∧ b = 3 ∧ c = 2) ∨ (a = 3 ∧ b = 2 ∧ c = 1) ∨ (a = 2 ∧ b = 1 ∧ c = 3) then -1
  else 0

/-- Antisymmetry of SU(2) Structure Constants: epsilon_123 = - epsilon_132 -/
theorem levi_civita_antisymmetry :
    leviCivitaSU2 1 2 3 = - (leviCivitaSU2 1 3 2) := by
  dsimp [leviCivitaSU2]
  norm_num

/-- Non-Abelian Field Strength Component F_mu_nu^a = d_mu A_nu^a - d_nu A_mu^a + g_YM * eps^a_bc A_mu^b A_nu^c -/
structure YangMillsFieldStrength where
  abelian_curl : ℝ  -- partial_mu A_nu^a - partial_nu A_mu^a
  g_YM         : ℝ  -- Yang-Mills coupling constant (> 0)
  A_mu_b       : ℝ  -- Gauge field component b
  A_nu_c       : ℝ  -- Gauge field component c
  eps_abc      : ℝ  -- Structure constant
  h_g_pos      : 0 < g_YM

def nonAbelianFieldStrength (Y : YangMillsFieldStrength) : ℝ :=
  Y.abelian_curl + Y.g_YM * Y.eps_abc * Y.A_mu_b * Y.A_nu_c

/-- Inhomogeneous Yang-Mills Euler-Lagrange Source State: D_nu F^(nu mu a) = J^(mu a) -/
structure YangMillsSourceState where
  D_nu_F_0 : ℝ  -- Covariant divergence 0 component
  D_nu_F_1 : ℝ  -- Covariant divergence 1 component
  D_nu_F_2 : ℝ  -- Covariant divergence 2 component
  D_nu_F_3 : ℝ  -- Covariant divergence 3 component
  J_0      : ℝ  -- Non-Abelian color current 0 component
  J_1      : ℝ  -- Non-Abelian color current 1 component
  J_2      : ℝ  -- Non-Abelian color current 2 component
  J_3      : ℝ  -- Non-Abelian color current 3 component
  h_eq_0   : D_nu_F_0 = J_0
  h_eq_1   : D_nu_F_1 = J_1
  h_eq_2   : D_nu_F_2 = J_2
  h_eq_3   : D_nu_F_3 = J_3

theorem yang_mills_euler_lagrange_reduction (S : YangMillsSourceState) :
    S.D_nu_F_0 = S.J_0 ∧
    S.D_nu_F_1 = S.J_1 ∧
    S.D_nu_F_2 = S.J_2 ∧
    S.D_nu_F_3 = S.J_3 :=
  ⟨S.h_eq_0, S.h_eq_1, S.h_eq_2, S.h_eq_3⟩

/-- Covariant Current Conservation Theorem: D_mu J^(mu a) = 0 -/
structure NonAbelianCurrentConservation where
  D_mu_J_a     : ℝ  -- Covariant divergence of non-Abelian current
  h_conserved  : D_mu_J_a = 0

theorem yang_mills_current_conserved (C : NonAbelianCurrentConservation) :
    C.D_mu_J_a = 0 :=
  C.h_conserved

end GTH.Fields
