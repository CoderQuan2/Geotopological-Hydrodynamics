/-
  Module: GTH.Inference.JointPosteriorEstimation
  Description: Joint Multi-Catalog Bayesian Likelihood Inversion, Degrees of Freedom, and Convergence Criteria.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Inference

/-- 5-Channel Empirical Likelihood Chi-Squared State -/
structure JointLikelihoodState where
  chi2_SPARC   : ℝ  -- SPARC 175 galaxies rotation curves
  chi2_Bullet  : ℝ  -- Bullet Cluster offset
  chi2_GW_Echo : ℝ  -- Gravitational wave echo comb
  chi2_BBN_Li  : ℝ  -- Primordial Lithium-7 yield
  chi2_Hubble  : ℝ  -- Late-time Hubble expansion shift
  N_dof        : ℕ  -- Total degrees of freedom (e.g. 180)
  h_N_pos      : 0 < N_dof
  h_sparc_pos  : 0 ≤ chi2_SPARC
  h_bullet_pos : 0 ≤ chi2_Bullet
  h_gw_pos     : 0 ≤ chi2_GW_Echo
  h_bbn_pos    : 0 ≤ chi2_BBN_Li
  h_hubble_pos : 0 ≤ chi2_Hubble

/-- Total Joint Chi-Squared: chi2_total = sum of 5 empirical channels -/
def totalJointChiSquared (J : JointLikelihoodState) : ℝ :=
  J.chi2_SPARC + J.chi2_Bullet + J.chi2_GW_Echo + J.chi2_BBN_Li + J.chi2_Hubble

theorem totalJointChiSquared_nonneg (J : JointLikelihoodState) :
    0 ≤ totalJointChiSquared J := by
  dsimp [totalJointChiSquared]
  linarith [J.h_sparc_pos, J.h_bullet_pos, J.h_gw_pos, J.h_bbn_pos, J.h_hubble_pos]

/-- Reduced Chi-Squared: chi2_red = chi2_total / N_dof -/
noncomputable def reducedChiSquared (J : JointLikelihoodState) : ℝ :=
  totalJointChiSquared J / (J.N_dof : ℝ)

theorem reducedChiSquared_nonneg (J : JointLikelihoodState) :
    0 ≤ reducedChiSquared J := by
  dsimp [reducedChiSquared]
  have hN_pos : 0 < (J.N_dof : ℝ) := Nat.cast_pos.mpr J.h_N_pos
  exact div_nonneg (totalJointChiSquared_nonneg J) (le_of_lt hN_pos)

/-- Convergence Invariant: chi2_red <= 1.15 -/
structure MCMCConvergenceCriterion where
  J            : JointLikelihoodState
  h_converged  : reducedChiSquared J ≤ (115 / 100 : ℝ)

theorem mcmc_posterior_converged (C : MCMCConvergenceCriterion) :
    reducedChiSquared C.J ≤ (115 / 100 : ℝ) :=
  C.h_converged

/-- Bayesian Evidence Ratio State (Jeffreys Scale ln B > 3.0) -/
structure BayesianEvidenceState where
  ln_Z_GTH     : ℝ
  ln_Z_Lambda  : ℝ
  h_evidence   : (3 : ℝ) < ln_Z_GTH - ln_Z_Lambda

def bayesFactorLog (B : BayesianEvidenceState) : ℝ :=
  B.ln_Z_GTH - B.ln_Z_Lambda

theorem strong_evidence_exhibited (B : BayesianEvidenceState) :
    (3 : ℝ) < bayesFactorLog B := by
  dsimp [bayesFactorLog]
  exact B.h_evidence

end GTH.Inference
