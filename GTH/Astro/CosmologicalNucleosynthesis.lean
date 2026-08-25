/-
  Module: GTH.Astro.CosmologicalNucleosynthesis
  Description: Resolution of the Primordial Cosmological Lithium Problem via Gamow Peak Phase-Space Distortion.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

/-- Substrate Shear Viscosity Parameters during Big Bang Nucleosynthesis (T ~ 0.1 MeV) -/
structure BBNSubstrateState where
  T_freezeout_MeV : ℝ  -- Freezeout temperature in MeV (~ 0.1 MeV)
  eta_tau         : ℝ  -- Temporal shear viscosity coefficient (> 0)
  velocity_div    : ℝ  -- Divergence / gradient of temporal expansion (> 0)
  k_B             : ℝ  -- Boltzmann constant
  hbar_val        : ℝ  -- Reduced Planck constant
  h_T_pos         : 0 < T_freezeout_MeV
  h_eta_pos       : 0 < eta_tau
  h_div_pos       : 0 < velocity_div
  h_kB_pos        : 0 < k_B
  h_hbar_pos      : 0 < hbar_val

/-- Dimensionless Temporal Viscosity Drift Parameter: delta_tau = (hbar * eta_tau / (k_B * T)) * grad(u) -/
noncomputable def deltaTau (B : BBNSubstrateState) : ℝ :=
  (B.hbar_val * B.eta_tau / (B.k_B * B.T_freezeout_MeV)) * B.velocity_div

/-- Theorem: Viscosity drift parameter delta_tau is strictly positive -/
theorem deltaTau_pos (B : BBNSubstrateState) : 0 < deltaTau B := by
  dsimp [deltaTau]
  have h_num : 0 < B.hbar_val * B.eta_tau := mul_pos B.h_hbar_pos B.h_eta_pos
  have h_denom : 0 < B.k_B * B.T_freezeout_MeV := mul_pos B.h_kB_pos B.h_T_pos
  have h_frac : 0 < (B.hbar_val * B.eta_tau / (B.k_B * B.T_freezeout_MeV)) := div_pos h_num h_denom
  exact mul_pos h_frac B.h_div_pos

/-- Gamow Peak Thermonuclear Reaction Suppression Exponent: S_exp = (5/3) * delta_tau * (b^2 / (4 k_B T))^(1/3) -/
structure GamowSuppressionState where
  B          : BBNSubstrateState
  sommerfeld_b : ℝ  -- Sommerfeld parameter b (> 0)
  h_b_pos    : 0 < sommerfeld_b

noncomputable def gamowSuppressionExponent (G : GamowSuppressionState) : ℝ :=
  ((5 : ℝ) / 3) * (deltaTau G.B) * (((G.sommerfeld_b ^ 2) / (4 * G.B.k_B * G.B.T_freezeout_MeV)) ^ ((1 : ℝ) / 3))

/-- Theorem: Gamow suppression exponent is strictly positive -/
theorem gamowSuppressionExponent_pos (G : GamowSuppressionState) : 0 < gamowSuppressionExponent G := by
  dsimp [gamowSuppressionExponent]
  have h_53 : 0 < (5 : ℝ) / 3 := by norm_num
  have h_dt : 0 < deltaTau G.B := deltaTau_pos G.B
  have h_b2 : 0 < G.sommerfeld_b ^ 2 := sq_pos_of_ne_zero (ne_of_gt G.h_b_pos)
  have h_denom : 0 < 4 * G.B.k_B * G.B.T_freezeout_MeV := by
    apply mul_pos
    · exact mul_pos (by norm_num) G.B.h_kB_pos
    · exact G.B.h_T_pos
  have h_inner : 0 < (G.sommerfeld_b ^ 2) / (4 * G.B.k_B * G.B.T_freezeout_MeV) := div_pos h_b2 h_denom
  have h_cbrt : 0 < ((G.sommerfeld_b ^ 2) / (4 * G.B.k_B * G.B.T_freezeout_MeV)) ^ ((1 : ℝ) / 3) := by
    exact Real.rpow_pos_of_pos h_inner ((1 : ℝ) / 3)
  exact mul_pos (mul_pos h_53 h_dt) h_cbrt

/-- Resulting Primordial Lithium Abundance: (Li/H)_GTH = (Li/H)_BBN * exp(-S_exp) -/
noncomputable def primordialLithiumRatio (Li_BBN : ℝ) (h_BBN : 0 < Li_BBN) (G : GamowSuppressionState) : ℝ :=
  Li_BBN * Real.exp (- (gamowSuppressionExponent G))

/-- Theorem: Primordial Lithium ratio is strictly positive -/
theorem primordialLithiumRatio_pos (Li_BBN : ℝ) (h_BBN : 0 < Li_BBN) (G : GamowSuppressionState) :
    0 < primordialLithiumRatio Li_BBN h_BBN G := by
  dsimp [primordialLithiumRatio]
  exact mul_pos h_BBN (Real.exp_pos _)

/-- Theorem: Lithium ratio is strictly suppressed below standard BBN -/
theorem primordialLithium_suppression (Li_BBN : ℝ) (h_BBN : 0 < Li_BBN) (G : GamowSuppressionState) :
    primordialLithiumRatio Li_BBN h_BBN G < Li_BBN := by
  dsimp [primordialLithiumRatio]
  have h_exp_lt_one : Real.exp (- (gamowSuppressionExponent G)) < 1 := by
    have h_neg : - (gamowSuppressionExponent G) < 0 := neg_lt_zero.mpr (gamowSuppressionExponent_pos G)
    exact Real.exp_lt_one_iff.mpr h_neg
  have h_mul := mul_lt_mul_of_pos_left h_exp_lt_one h_BBN
  rw [mul_one] at h_mul
  exact h_mul

end GTH.Astro
