/-
  Module: GTH.Cosmology.TopologicalInflationaryPhase
  Description: Inflaton-Free Superfluid Phase Transition, Primordial e-Folds, and Spectral Index n_s Invariants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Cosmology

/-- Primordial Phase Transition State with e-Folding Number N_efolds > 50 -/
structure InflationaryPhaseState where
  N_efolds     : ℝ  -- Number of inflationary e-folds (~ 62.4)
  h_N_pos      : 50 < N_efolds

/-- Primordial Scalar Spectral Index: n_s = 1 - (2 / N_efolds) -/
noncomputable def scalarSpectralIndex (I : InflationaryPhaseState) : ℝ :=
  1 - (2 / I.N_efolds)

theorem scalarSpectralIndex_lt_one (I : InflationaryPhaseState) :
    scalarSpectralIndex I < 1 := by
  dsimp [scalarSpectralIndex]
  have h_pos : 0 < 2 / I.N_efolds := by
    have h_N : 0 < I.N_efolds := by linarith [I.h_N_pos]
    exact div_pos (by norm_num) h_N
  linarith

theorem scalarSpectralIndex_pos (I : InflationaryPhaseState) :
    0 < scalarSpectralIndex I := by
  dsimp [scalarSpectralIndex]
  have h_frac_lt : 2 / I.N_efolds < 1 := by
    have h_N : 50 < I.N_efolds := I.h_N_pos
    have h1 : 2 < I.N_efolds := by linarith
    have h2 : 0 < I.N_efolds := by linarith
    exact (div_lt_one₀ h2).mpr h1
  linarith

/-- Primordial Tensor-to-Scalar Ratio: r = 12 / N_efolds^2 -/
noncomputable def tensorToScalarRatio (I : InflationaryPhaseState) : ℝ :=
  12 / (I.N_efolds ^ 2)

theorem tensorToScalarRatio_pos (I : InflationaryPhaseState) :
    0 < tensorToScalarRatio I := by
  dsimp [tensorToScalarRatio]
  have h_N : 0 < I.N_efolds := by linarith [I.h_N_pos]
  have h_N2 : 0 < I.N_efolds ^ 2 := sq_pos_of_ne_zero (ne_of_gt h_N)
  exact div_pos (by norm_num) h_N2

theorem tensorToScalarRatio_bicep_bound (I : InflationaryPhaseState) (h_N60 : 60 ≤ I.N_efolds) :
    tensorToScalarRatio I < (0.036 : ℝ) := by
  dsimp [tensorToScalarRatio]
  have h_N2_ge : (60 : ℝ) ^ 2 ≤ I.N_efolds ^ 2 := by
    have h_pos : 0 ≤ (60 : ℝ) := by norm_num
    nlinarith
  have h_num : 12 / (I.N_efolds ^ 2) ≤ 12 / (3600 : ℝ) := by
    have h_N2_pos : 0 < I.N_efolds ^ 2 := by nlinarith
    exact div_le_div_of_nonneg_left (by norm_num) (by norm_num) h_N2_ge
  have h_calc : 12 / (3600 : ℝ) = (1 : ℝ) / 300 := by norm_num
  have h_lt : (1 : ℝ) / 300 < (0.036 : ℝ) := by norm_num
  linarith

end GTH.Cosmology
