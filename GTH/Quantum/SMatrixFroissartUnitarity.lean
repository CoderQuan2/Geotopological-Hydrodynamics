/-
  Module: GTH.Quantum.SMatrixFroissartUnitarity
  Description: S-Matrix Optical Theorem, Froissart-Martin Bound on Total Cross-Sections, and Partial-Wave Unitarity.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- S-Matrix Scattering State Vector at Center-of-Mass Energy Squared s -/
structure SMatrixScatteringState where
  s_energy_sq  : ℝ  -- Center-of-mass energy squared s (GeV^2) (> 0)
  m_mass       : ℝ  -- Particle mass (GeV) (> 0)
  sigma_tot    : ℝ  -- Total cross-section (mbarn) (> 0)
  h_s_pos      : 0 < s_energy_sq
  h_m_pos      : 0 < m_mass
  h_sig_pos    : 0 < sigma_tot
  h_s_threshold: 4 * (m_mass ^ 2) < s_energy_sq

/-- Optical Theorem: Im(M(s, t=0)) = 2 * sqrt(s * (s - 4m^2)) * sigma_tot -/
noncomputable def imaginaryForwardAmplitude (S : SMatrixScatteringState) : ℝ :=
  2 * Real.sqrt (S.s_energy_sq * (S.s_energy_sq - 4 * (S.m_mass ^ 2))) * S.sigma_tot

theorem imaginaryForwardAmplitude_pos (S : SMatrixScatteringState) :
    0 < imaginaryForwardAmplitude S := by
  dsimp [imaginaryForwardAmplitude]
  have h_diff : 0 < S.s_energy_sq - 4 * (S.m_mass ^ 2) := sub_pos.mpr S.h_s_threshold
  have h_prod : 0 < S.s_energy_sq * (S.s_energy_sq - 4 * (S.m_mass ^ 2)) := mul_pos S.h_s_pos h_diff
  have h_sqrt : 0 < Real.sqrt (S.s_energy_sq * (S.s_energy_sq - 4 * (S.m_mass ^ 2))) := Real.sqrt_pos.mpr h_prod
  have h_2sqrt : 0 < 2 * Real.sqrt (S.s_energy_sq * (S.s_energy_sq - 4 * (S.m_mass ^ 2))) := mul_pos (by norm_num) h_sqrt
  exact mul_pos h_2sqrt S.h_sig_pos

/-- Froissart-Martin Theoretical Bound: sigma_max(s) = C_froissart * ln^2(s / s_0) -/
structure FroissartBoundState where
  C_froissart  : ℝ  -- Universal coefficient pi * hbar^2 / m_pi^2 (~ 62.83 mb) (> 0)
  s_0          : ℝ  -- Scale normalization (1.0 GeV^2) (> 0)
  h_C_pos      : 0 < C_froissart
  h_s0_pos     : 0 < s_0

noncomputable def froissartCeiling (F : FroissartBoundState) (s_val : ℝ) (log_ratio : ℝ) : ℝ :=
  F.C_froissart * (log_ratio ^ 2)

theorem froissart_ceiling_nonneg (F : FroissartBoundState) (s_val : ℝ) (log_ratio : ℝ) :
    0 ≤ froissartCeiling F s_val log_ratio := by
  dsimp [froissartCeiling]
  have h_sq : 0 ≤ log_ratio ^ 2 := sq_nonneg log_ratio
  exact mul_nonneg (le_of_lt F.h_C_pos) h_sq

/-- Partial-Wave Unitarity Invariant: |f_l(s)| <= 1 for all orbital harmonics l -/
structure PartialWaveUnitarityState where
  f_l_modulus  : ℝ  -- Modulus of partial-wave amplitude |f_l(s)|
  h_mod_nonneg : 0 ≤ f_l_modulus
  h_unitarity  : f_l_modulus ≤ 1

theorem partial_wave_unitarity_bounded (P : PartialWaveUnitarityState) :
    P.f_l_modulus ≤ 1 :=
  P.h_unitarity

end GTH.Quantum
