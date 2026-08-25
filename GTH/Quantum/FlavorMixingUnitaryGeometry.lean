/-
  Module: GTH.Quantum.FlavorMixingUnitaryGeometry
  Description: CKM / PMNS Geometric Flavor Mixing Matrix, Row/Column Unitarity, Jarlskog Invariant, and Cabibbo Hierarchy.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- CKM Quark Flavor Mixing Matrix Moduli State Vector -/
structure CKMMatrixModuli where
  V_ud : ℝ  -- 0.97435
  V_us : ℝ  -- 0.22500
  V_ub : ℝ  -- 0.00369
  V_cd : ℝ  -- 0.22486
  V_cs : ℝ  -- 0.97349
  V_cb : ℝ  -- 0.04182
  V_td : ℝ  -- 0.00857
  V_ts : ℝ  -- 0.04110
  V_tb : ℝ  -- 0.99912
  h_ud_pos : 0 < V_ud
  h_us_pos : 0 < V_us
  h_ub_pos : 0 < V_ub
  h_cd_pos : 0 < V_cd
  h_cs_pos : 0 < V_cs
  h_cb_pos : 0 < V_cb
  h_td_pos : 0 < V_td
  h_ts_pos : 0 < V_ts
  h_tb_pos : 0 < V_tb

/-- First Row Unitarity Sum: S_row1 = V_ud^2 + V_us^2 + V_ub^2 -/
def ckmRow1Unitarity (C : CKMMatrixModuli) : ℝ :=
  C.V_ud ^ 2 + C.V_us ^ 2 + C.V_ub ^ 2

/-- First Column Unitarity Sum: S_col1 = V_ud^2 + V_cd^2 + V_td^2 -/
def ckmCol1Unitarity (C : CKMMatrixModuli) : ℝ :=
  C.V_ud ^ 2 + C.V_cd ^ 2 + C.V_td ^ 2

/-- Unitarity State: Strict Row & Column Normalization to 1 -/
structure UnitaryCKMState where
  C        : CKMMatrixModuli
  h_row1_eq: ckmRow1Unitarity C = 1
  h_col1_eq: ckmCol1Unitarity C = 1

theorem ckm_row1_is_unitary (U : UnitaryCKMState) :
    ckmRow1Unitarity U.C = 1 :=
  U.h_row1_eq

theorem ckm_col1_is_unitary (U : UnitaryCKMState) :
    ckmCol1Unitarity U.C = 1 :=
  U.h_col1_eq

/-- Cabibbo Magnitude Hierarchy: V_ub < V_cb < V_us < V_ud -/
structure CabibboHierarchy where
  C           : CKMMatrixModuli
  h_ub_lt_cb  : C.V_ub < C.V_cb
  h_cb_lt_us  : C.V_cb < C.V_us
  h_us_lt_ud  : C.V_us < C.V_ud

theorem cabibbo_hierarchy_chain (H : CabibboHierarchy) :
    H.C.V_ub < H.C.V_ud := by
  calc
    H.C.V_ub < H.C.V_cb := H.h_ub_lt_cb
    _ < H.C.V_us := H.h_cb_lt_us
    _ < H.C.V_ud := H.h_us_lt_ud

/-- Jarlskog CP-Violation Invariant Parameter State -/
structure JarlskogInvariantState where
  s12       : ℝ  -- sin(theta_12) (> 0)
  s23       : ℝ  -- sin(theta_23) (> 0)
  s13       : ℝ  -- sin(theta_13) (> 0)
  c12       : ℝ  -- cos(theta_12) (> 0)
  c23       : ℝ  -- cos(theta_23) (> 0)
  c13       : ℝ  -- cos(theta_13) (> 0)
  sin_delta : ℝ  -- sin(delta_CP) (> 0)
  h_s12_pos : 0 < s12
  h_s23_pos : 0 < s23
  h_s13_pos : 0 < s13
  h_c12_pos : 0 < c12
  h_c23_pos : 0 < c23
  h_c13_pos : 0 < c13
  h_sd_pos  : 0 < sin_delta

/-- Jarlskog Invariant Formula: J = c12 * c23 * c13^2 * s12 * s23 * s13 * sin(delta) -/
def jarlskogInvariant (J : JarlskogInvariantState) : ℝ :=
  J.c12 * J.c23 * (J.c13 ^ 2) * J.s12 * J.s23 * J.s13 * J.sin_delta

theorem jarlskog_invariant_strictly_positive (J : JarlskogInvariantState) :
    0 < jarlskogInvariant J := by
  dsimp [jarlskogInvariant]
  have h_c13_sq : 0 < J.c13 ^ 2 := sq_pos_of_ne_zero (ne_of_gt J.h_c13_pos)
  have p1 : 0 < J.c12 * J.c23 := mul_pos J.h_c12_pos J.h_c23_pos
  have p2 : 0 < p1 * (J.c13 ^ 2) := mul_pos p1 h_c13_sq
  have p3 : 0 < p2 * J.s12 := mul_pos p2 J.h_s12_pos
  have p4 : 0 < p3 * J.s23 := mul_pos p3 J.h_s23_pos
  have p5 : 0 < p4 * J.s13 := mul_pos p4 J.h_s13_pos
  exact mul_pos p5 J.h_sd_pos

end GTH.Quantum
