/-
  Module: GTH.Cosmology.DarkEnergyViscoelasticEoS
  Description: Viscoelastic Dark Energy Equation of State w(a), Null Energy Condition (w >= -1), and Accelerated Expansion.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Cosmology

/-- CPL Cosmological Dark Energy Equation of State Parameters -/
structure DarkEnergyEoSState where
  w_0          : ℝ  -- Present-day equation of state w(a=1) (e.g. -0.9950)
  w_a          : ℝ  -- Time evolution parameter dw/da (e.g. +0.0125)
  h_w0_accel   : w_0 < - (1 / 3 : ℝ)  -- Accelerating expansion condition (q < 0)
  h_nec_w0     : -1 ≤ w_0             -- Null Energy Condition at present day (no phantom ghost)
  h_wa_nonneg  : 0 ≤ w_a

/-- CPL Equation of State Function: w(a) = w_0 + w_a * (1 - a) -/
def cplEquationOfState (D : DarkEnergyEoSState) (a : ℝ) : ℝ :=
  D.w_0 + D.w_a * (1 - a)

/-- Theorem: Cosmic Acceleration at Present Day (w(1) < -1/3 implies ddot(a) > 0) -/
theorem cosmic_acceleration_at_present (D : DarkEnergyEoSState) :
    cplEquationOfState D 1 < - (1 / 3 : ℝ) := by
  dsimp [cplEquationOfState]
  have h_one : D.w_a * (1 - (1 : ℝ)) = 0 := by ring
  rw [h_one, add_zero]
  exact D.h_w0_accel

/-- Null Energy Condition (NEC) Invariant: 1 + w(a) >= 0 holds for all a in [0, 1] -/
theorem null_energy_condition_past (D : DarkEnergyEoSState) (a : ℝ) (ha_nonneg : 0 ≤ a) (ha_le_one : a ≤ 1) :
    -1 ≤ cplEquationOfState D a := by
  dsimp [cplEquationOfState]
  have h_diff_nonneg : 0 ≤ 1 - a := by linarith
  have h_wa_term : 0 ≤ D.w_a * (1 - a) := mul_nonneg D.h_wa_nonneg h_diff_nonneg
  linarith [D.h_nec_w0]

/-- Repulsive Acceleration Pressure Gradient: rho_DE + 3 * P_DE / c^2 < 0 -/
def accelerationPressureSum (rho_DE_c2 : ℝ) (w_val : ℝ) : ℝ :=
  rho_DE_c2 * (1 + 3 * w_val)

theorem acceleration_pressure_sum_negative (rho_DE_c2 : ℝ) (h_rho_pos : 0 < rho_DE_c2)
    (w_val : ℝ) (hw_lt : w_val < - (1 / 3 : ℝ)) :
    accelerationPressureSum rho_DE_c2 w_val < 0 := by
  dsimp [accelerationPressureSum]
  have h_sum_neg : 1 + 3 * w_val < 0 := by linarith
  exact mul_neg_of_pos_of_neg h_rho_pos h_sum_neg

end GTH.Cosmology
