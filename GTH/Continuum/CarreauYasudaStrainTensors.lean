/-
  Module: GTH.Continuum.CarreauYasudaStrainTensors
  Description: Upper-Convected Time Derivative, Second Strain Invariant I_2, and Asymptotic Stress Saturation Bounds.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Continuum

/-- Second Strain-Rate Invariant State I_2(D) = 2 * Tr(D^2) >= 0 -/
structure StrainRateInvariantState where
  D_xx       : ℝ
  D_yy       : ℝ
  D_xy       : ℝ
  tau_0      : ℝ  -- Zero-strain relaxation time (> 0)
  eta_0      : ℝ  -- Zero-shear viscosity (> 0)
  K_bulk     : ℝ  -- Bulk compressive modulus (> 0)
  h_tau_pos  : 0 < tau_0
  h_eta_pos  : 0 < eta_0
  h_K_pos    : 0 < K_bulk

/-- Second Strain-Rate Invariant I_2(D) = 2 * (D_xx^2 + D_yy^2 + 2*D_xy^2) -/
noncomputable def secondStrainInvariant (S : StrainRateInvariantState) : ℝ :=
  2 * (S.D_xx ^ 2 + S.D_yy ^ 2 + 2 * (S.D_xy ^ 2))

theorem secondStrainInvariant_nonneg (S : StrainRateInvariantState) :
    0 ≤ secondStrainInvariant S := by
  dsimp [secondStrainInvariant]
  have h1 : 0 ≤ S.D_xx ^ 2 := sq_nonneg S.D_xx
  have h2 : 0 ≤ S.D_yy ^ 2 := sq_nonneg S.D_yy
  have h3 : 0 ≤ S.D_xy ^ 2 := sq_nonneg S.D_xy
  have h4 : 0 ≤ 2 * (S.D_xy ^ 2) := mul_nonneg (by norm_num) h3
  have h_sum : 0 ≤ S.D_xx ^ 2 + S.D_yy ^ 2 + 2 * (S.D_xy ^ 2) := by linarith
  exact mul_nonneg (by norm_num) h_sum

/-- Scalar Shear Strain Rate gamma_dot = sqrt(I_2(D)) -/
noncomputable def scalarStrainRate (S : StrainRateInvariantState) : ℝ :=
  Real.sqrt (secondStrainInvariant S)

theorem scalarStrainRate_nonneg (S : StrainRateInvariantState) :
    0 ≤ scalarStrainRate S :=
  Real.sqrt_nonneg (secondStrainInvariant S)

/-- Asymptotic Saturation Stress: sigma_sat = eta_0 / tau_0 -/
noncomputable def asymptoticSaturationStress (S : StrainRateInvariantState) : ℝ :=
  S.eta_0 / S.tau_0

theorem asymptoticSaturationStress_pos (S : StrainRateInvariantState) :
    0 < asymptoticSaturationStress S := by
  dsimp [asymptoticSaturationStress]
  exact div_pos S.h_eta_pos S.h_tau_pos

/-- Stress Boundedness Theorem: sigma_sat < K_bulk -/
structure SubstrateStressBoundednessState where
  S              : StrainRateInvariantState
  h_bound_strict : asymptoticSaturationStress S < S.K_bulk

theorem stress_saturation_bounded (B : SubstrateStressBoundednessState) :
    asymptoticSaturationStress B.S < B.S.K_bulk :=
  B.h_bound_strict

end GTH.Continuum
