/-
  Module: GTH.Continuum.Viscoelasticity
  Description: Viscoelastic Maxwell-Kelvin-Voigt Constitutive Law & Sound Dispersion.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

namespace GTH.Continuum

/-- Acoustic and Shear Moduli State -/
structure ElasticModuli where
  K_bulk  : ℝ
  G_shear : ℝ
  h_K     : 0 < K_bulk
  h_G     : 0 < G_shear

/-- Poisson Ratio of the Substrate in terms of Bulk (K) and Shear (G) Moduli -/
def poissonRatio (M : ElasticModuli) : ℝ :=
  (3 * M.K_bulk - 2 * M.G_shear) / (2 * (3 * M.K_bulk + M.G_shear))

/-- Incompressibility Limit: When K >> G, Poisson ratio approaches 1/2 -/
theorem incompressibility_limit (M : ElasticModuli) (h_incomp : M.G_shear = 0) :
    poissonRatio M = 1 / 2 := by
  dsimp [poissonRatio]
  rw [h_incomp]
  have hK_ne : M.K_bulk ≠ 0 := ne_of_gt M.h_K
  have h_denom : 2 * (3 * M.K_bulk + 0) = 6 * M.K_bulk := by ring
  have h_num : 3 * M.K_bulk - 2 * 0 = 3 * M.K_bulk := by ring
  rw [h_denom, h_num]
  have : (3 * M.K_bulk) / (6 * M.K_bulk) = (3 / 6) * (M.K_bulk / M.K_bulk) := by ring
  rw [this, div_self hK_ne, mul_one]
  norm_num

/-- 1D Linear Maxwell Constitutive Equation Relation -/
structure MaxwellStressState where
  sigma_shear : ℝ  -- Deviatoric stress component
  dot_sigma   : ℝ  -- Time derivative of stress
  dot_epsilon : ℝ  -- Strain rate tensor component
  eta         : ℝ  -- Viscosity
  G           : ℝ  -- Shear modulus
  tau_relax   : ℝ  -- tau_0 = eta / G
  h_G         : 0 < G
  h_eta       : 0 < eta
  h_tau_def   : tau_relax = eta / G
  constitutive : sigma_shear + tau_relax * dot_sigma = 2 * eta * dot_epsilon

/-- Steady-State Flow Limit: dot_sigma = 0 recovers pure Newtonian Navier-Stokes -/
theorem steady_state_newtonian (M : MaxwellStressState) (h_steady : M.dot_sigma = 0) :
    M.sigma_shear = 2 * M.eta * M.dot_epsilon := by
  have h_const := M.constitutive
  rw [h_steady, mul_zero, add_zero] at h_const
  exact h_const

end GTH.Continuum
