/-
  Module: GTH.Quantum.ElectroweakSymmetryBreaking
  Description: Spontaneous Electroweak Symmetry Breaking, Higgs Mass m_H, W/Z Boson Masses, and Custodial Invariance.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- Electroweak Symmetry Breaking State Vector -/
structure ElectroweakState where
  v_EW        : ℝ  -- Vacuum expectation value (246.22 GeV) (> 0)
  lambda_H    : ℝ  -- Higgs quartic self-coupling (0.1290) (> 0)
  g_weak      : ℝ  -- SU(2)_L weak gauge coupling (0.652) (> 0)
  g_prime     : ℝ  -- U(1)_Y hypercharge gauge coupling (0.357) (> 0)
  h_v_pos     : 0 < v_EW
  h_lam_pos   : 0 < lambda_H
  h_g_pos     : 0 < g_weak
  h_gp_pos    : 0 < g_prime

/-- Physical Higgs Boson Mass Squared: m_H^2 = 2 * lambda_H * v_EW^2 -/
def higgsMassSquared (E : ElectroweakState) : ℝ :=
  2 * E.lambda_H * (E.v_EW ^ 2)

theorem higgsMassSquared_pos (E : ElectroweakState) :
    0 < higgsMassSquared E := by
  dsimp [higgsMassSquared]
  have h_v2 : 0 < E.v_EW ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_v_pos)
  have h_2lam : 0 < 2 * E.lambda_H := mul_pos (by norm_num) E.h_lam_pos
  exact mul_pos h_2lam h_v2

/-- W-Boson Mass Squared: m_W^2 = (1/4) * g_weak^2 * v_EW^2 -/
def wMassSquared (E : ElectroweakState) : ℝ :=
  (1 / 4 : ℝ) * (E.g_weak ^ 2) * (E.v_EW ^ 2)

theorem wMassSquared_pos (E : ElectroweakState) :
    0 < wMassSquared E := by
  dsimp [wMassSquared]
  have h_g2 : 0 < E.g_weak ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_g_pos)
  have h_v2 : 0 < E.v_EW ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_v_pos)
  have h_prod : 0 < (E.g_weak ^ 2) * (E.v_EW ^ 2) := mul_pos h_g2 h_v2
  exact mul_pos (by norm_num) h_prod

/-- Z-Boson Mass Squared: m_Z^2 = (1/4) * (g_weak^2 + g_prime^2) * v_EW^2 -/
def zMassSquared (E : ElectroweakState) : ℝ :=
  (1 / 4 : ℝ) * (E.g_weak ^ 2 + E.g_prime ^ 2) * (E.v_EW ^ 2)

theorem zMassSquared_pos (E : ElectroweakState) :
    0 < zMassSquared E := by
  dsimp [zMassSquared]
  have h_g2 : 0 < E.g_weak ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_g_pos)
  have h_gp2 : 0 < E.g_prime ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_gp_pos)
  have h_sum : 0 < E.g_weak ^ 2 + E.g_prime ^ 2 := add_pos h_g2 h_gp2
  have h_v2 : 0 < E.v_EW ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_v_pos)
  have h_prod : 0 < (E.g_weak ^ 2 + E.g_prime ^ 2) * (E.v_EW ^ 2) := mul_pos h_sum h_v2
  exact mul_pos (by norm_num) h_prod

/-- Gauge Boson Mass Ordering: m_W^2 < m_Z^2 strictly -/
theorem w_less_than_z_mass (E : ElectroweakState) :
    wMassSquared E < zMassSquared E := by
  dsimp [wMassSquared, zMassSquared]
  have h_gp2 : 0 < E.g_prime ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_gp_pos)
  have h_v2 : 0 < E.v_EW ^ 2 := sq_pos_of_ne_zero (ne_of_gt E.h_v_pos)
  have h_diff : (1 / 4 : ℝ) * (E.g_weak ^ 2 + E.g_prime ^ 2) * (E.v_EW ^ 2) - (1 / 4 : ℝ) * (E.g_weak ^ 2) * (E.v_EW ^ 2) = (1 / 4 : ℝ) * (E.g_prime ^ 2) * (E.v_EW ^ 2) := by ring
  rw [← sub_pos]
  rw [h_diff]
  have h_prod : 0 < (E.g_prime ^ 2) * (E.v_EW ^ 2) := mul_pos h_gp2 h_v2
  exact mul_pos (by norm_num) h_prod

/-- Tree-Level Custodial Parameter: rho = m_W^2 / (m_Z^2 * cos^2(theta_W)) = 1 -/
structure CustodialInvarianceState where
  mW2       : ℝ
  mZ2       : ℝ
  cos2_thW  : ℝ
  h_mW_pos  : 0 < mW2
  h_mZ_pos  : 0 < mZ2
  h_cos_pos : 0 < cos2_thW
  h_custod  : mW2 = mZ2 * cos2_thW

theorem custodial_rho_is_unity (C : CustodialInvarianceState) :
    C.mW2 / (C.mZ2 * C.cos2_thW) = 1 := by
  have h_denom_ne : C.mZ2 * C.cos2_thW ≠ 0 := ne_of_gt (mul_pos C.h_mZ_pos C.h_cos_pos)
  rw [C.h_custod]
  exact div_self h_denom_ne

end GTH.Quantum
