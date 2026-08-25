/-
  Module: GTH.Continuum.CarreauYasudaRheology
  Description: Non-Linear Carreau-Yasuda Rheology, Shear-Thinning Stress Boundedness, and Horizon Memory Quenching.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Continuum

/-- Carreau-Yasuda Rheological Constitutive Parameters -/
structure CarreauYasudaState where
  eta_0       : ℝ  -- Zero-shear viscosity eta_n (> 0)
  tau_0       : ℝ  -- Zero-strain relaxation time (> 0)
  lambda_eta  : ℝ  -- Viscous timescale parameter (> 0)
  lambda_tau  : ℝ  -- Elastic timescale parameter (> 0)
  n_index     : ℝ  -- Shear-thinning index (0 < n < 1)
  K_bulk      : ℝ  -- Substrate bulk modulus (> 0)
  h_eta0_pos  : 0 < eta_0
  h_tau0_pos  : 0 < tau_0
  h_leta_pos  : 0 < lambda_eta
  h_ltau_pos  : 0 < lambda_tau
  h_n_pos     : 0 < n_index
  h_n_lt_one  : n_index < 1
  h_K_pos     : 0 < K_bulk

/-- Asymptotic High-Strain Dynamic Saturation Shear Stress Sigma_sat = (eta_0 / tau_0) * (lambda_eta / lambda_tau)^(n - 1) -/
noncomputable def saturationStress (C : CarreauYasudaState) : ℝ :=
  (C.eta_0 / C.tau_0) * ((C.lambda_eta / C.lambda_tau) ^ (C.n_index - 1))

/-- Theorem: Saturation stress is strictly positive -/
theorem saturationStress_pos (C : CarreauYasudaState) : 0 < saturationStress C := by
  dsimp [saturationStress]
  have h_ratio_pos : 0 < C.eta_0 / C.tau_0 := div_pos C.h_eta0_pos C.h_tau0_pos
  have h_scale_pos : 0 < C.lambda_eta / C.lambda_tau := div_pos C.h_leta_pos C.h_ltau_pos
  have h_pow_pos : 0 < (C.lambda_eta / C.lambda_tau) ^ (C.n_index - 1) := Real.rpow_pos_of_pos h_scale_pos (C.n_index - 1)
  exact mul_pos h_ratio_pos h_pow_pos

/-- Admissibility Condition: Saturated dynamic stress remains below bulk compressive modulus K_bulk -/
structure AdmissibleRheologyState where
  C             : CarreauYasudaState
  h_bulk_bound  : saturationStress C < C.K_bulk

/-- Theorem: High-Strain Horizon Stress is strictly bounded by bulk modulus -/
theorem dynamic_stress_bounded_by_bulk (A : AdmissibleRheologyState) :
    saturationStress A.C < A.C.K_bulk :=
  A.h_bulk_bound

/-- High-Strain Memory Quenching: Effective relaxation time decays with strain rate exponent (n - 1) < 0 -/
structure MemoryQuenchingState where
  C           : CarreauYasudaState
  strain_rate : ℝ
  h_strain_gt_one : 1 < strain_rate

theorem negative_relaxation_exponent (C : CarreauYasudaState) :
    C.n_index - 1 < 0 :=
  sub_lt_zero.mpr C.h_n_lt_one

end GTH.Continuum
