/-
  Module: GTH.Quantum.MicroscopicCasimirSubstrateCohesion
  Description: Microscopic Casimir Substrate Force, Attractive Pressure P_Casimir < 0, and Cohesion Energy Positivity.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Quantum

/-- Casimir Vacuum Force State Vector -/
structure CasimirSubstrateState where
  hbar_c       : ℝ  -- hbar * c_SI (3.1615e-26 J*m) (> 0)
  plate_dist_d : ℝ  -- Plate separation distance d (meters) (> 0)
  K_bulk       : ℝ  -- Substrate bulk compressive modulus (1.5150e-10 Pa) (> 0)
  cav_factor   : ℝ  -- Cavitation ratio (1 - rho_cav/rho_0)^2 (0.9690) (> 0)
  h_hbarc_pos  : 0 < hbar_c
  h_d_pos      : 0 < plate_dist_d
  h_K_pos      : 0 < K_bulk
  h_cav_pos    : 0 < cav_factor

/-- Ideal Casimir Pressure Magnitude: P_ideal = (pi^2 / 240) * hbar_c / d^4 -/
noncomputable def casimirPressureMagnitude (C : CasimirSubstrateState) : ℝ :=
  (Real.pi ^ 2 / 240) * C.hbar_c / (C.plate_dist_d ^ 4)

theorem casimirPressureMagnitude_pos (C : CasimirSubstrateState) :
    0 < casimirPressureMagnitude C := by
  dsimp [casimirPressureMagnitude]
  have h_pi2 : 0 < Real.pi ^ 2 := sq_pos_of_ne_zero (ne_of_gt Real.pi_pos)
  have h_coeff : 0 < Real.pi ^ 2 / 240 := div_pos h_pi2 (by norm_num)
  have h_d4 : 0 < C.plate_dist_d ^ 4 := pow_pos C.h_d_pos 4
  have h_quot : 0 < C.hbar_c / (C.plate_dist_d ^ 4) := div_pos C.h_hbarc_pos h_d4
  exact mul_pos h_coeff h_quot

/-- Attractive Physical Casimir Pressure: P_att = - P_ideal < 0 -/
noncomputable def physicalCasimirPressure (C : CasimirSubstrateState) : ℝ :=
  - casimirPressureMagnitude C

theorem physical_casimir_pressure_attractive (C : CasimirSubstrateState) :
    physicalCasimirPressure C < 0 := by
  dsimp [physicalCasimirPressure]
  exact neg_lt_zero.mpr (casimirPressureMagnitude_pos C)

/-- Substrate Cohesion Energy Density: E_cohesion = (1/2) * K_bulk * cav_factor -/
def substrateCohesionEnergy (C : CasimirSubstrateState) : ℝ :=
  (1 / 2 : ℝ) * C.K_bulk * C.cav_factor

theorem substrateCohesionEnergy_pos (C : CasimirSubstrateState) :
    0 < substrateCohesionEnergy C := by
  dsimp [substrateCohesionEnergy]
  have h_half_K : 0 < (1 / 2 : ℝ) * C.K_bulk := mul_pos (by norm_num) C.h_K_pos
  exact mul_pos h_half_K C.h_cav_pos

end GTH.Quantum
