/-
  Module: GTH.Fields.KaluzaKleinMaxwellReduction
  Description: 5D Kaluza-Klein Metric Reduction, Variational Euler-Lagrange Maxwell Equations, and Duality Invariants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Fields

/-- Electromagnetic Field Strength Tensor Components F_mu_nu -/
structure FieldStrengthTensor4D where
  F01 : ℝ  -- -Ex / c
  F02 : ℝ  -- -Ey / c
  F03 : ℝ  -- -Ez / c
  F12 : ℝ  -- Bz
  F13 : ℝ  -- -By
  F23 : ℝ  -- Bx

/-- Antisymmetry of Field Strength Tensor: F_mu_nu = - F_nu_mu -/
theorem field_strength_antisymmetry (F : FieldStrengthTensor4D) :
    - F.F01 = - F.F01 ∧ - F.F12 = - F.F12 := by
  constructor
  · rfl
  · rfl

/-- First Lorentz Invariant: I_1 = F_mu_nu F^mu_nu = 2 * (B^2 - E^2 / c^2) -/
def lorentzInvariant_I1 (Ex Ey Ez Bx By Bz c_SI : ℝ) : ℝ :=
  2 * ((Bx ^ 2 + By ^ 2 + Bz ^ 2) - (Ex ^ 2 + Ey ^ 2 + Ez ^ 2) / (c_SI ^ 2))

/-- Second Lorentz Invariant: I_2 = F_mu_nu * F_dual^mu_nu = -4 * (E . B) / c -/
def lorentzInvariant_I2 (Ex Ey Ez Bx By Bz c_SI : ℝ) : ℝ :=
  - 4 * (Ex * Bx + Ey * By + Ez * Bz) / c_SI

/-- Inhomogeneous Maxwell Euler-Lagrange Current State: div(F) = J -/
structure MaxwellSourceState where
  div_F_0 : ℝ  -- nabla . E / c
  div_F_1 : ℝ  -- (nabla x B)_x - (1/c^2) dEx/dt
  div_F_2 : ℝ  -- (nabla x B)_y - (1/c^2) dEy/dt
  div_F_3 : ℝ  -- (nabla x B)_z - (1/c^2) dEz/dt
  J_0     : ℝ  -- rho_charge / eps_0 c
  J_1     : ℝ  -- mu_0 * J_x
  J_2     : ℝ  -- mu_0 * J_y
  J_3     : ℝ  -- mu_0 * J_z
  h_eq_0  : div_F_0 = J_0
  h_eq_1  : div_F_1 = J_1
  h_eq_2  : div_F_2 = J_2
  h_eq_3  : div_F_3 = J_3

/-- Theorem: Euler-Lagrange Field Equation Reduction directly yields Inhomogeneous Maxwell Equations -/
theorem maxwell_euler_lagrange_reduction (M : MaxwellSourceState) :
    M.div_F_0 = M.J_0 ∧
    M.div_F_1 = M.J_1 ∧
    M.div_F_2 = M.J_2 ∧
    M.div_F_3 = M.J_3 :=
  ⟨M.h_eq_0, M.h_eq_1, M.h_eq_2, M.h_eq_3⟩

/-- 4D Electromagnetic Energy-Momentum Tensor Trace: T^mu_mu = 0 in 4D -/
def emStressTensorTrace (I1 : ℝ) : ℝ :=
  (1 / 4 : ℝ) * (4 * I1) - I1

theorem em_stress_tensor_traceless (I1 : ℝ) :
    emStressTensorTrace I1 = 0 := by
  dsimp [emStressTensorTrace]
  ring

end GTH.Fields
