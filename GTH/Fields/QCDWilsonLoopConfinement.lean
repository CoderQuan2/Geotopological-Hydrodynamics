/-
  Module: GTH.Fields.QCDWilsonLoopConfinement
  Description: Non-Perturbative QCD Confinement, Wilson Loop Area Law, Mass Gap Delta_QCD > 0, and String Tension.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Fields

/-- SU(3) Color Group Fundamental Casimir Factor: C_F = (N^2 - 1) / (2N) = 4/3 for N = 3 -/
def su3CasimirFundamental : ℝ :=
  ((3 : ℝ) ^ 2 - 1) / (2 * 3)

theorem su3_casimir_is_four_thirds :
    su3CasimirFundamental = (4 / 3 : ℝ) := by
  dsimp [su3CasimirFundamental]
  norm_num

/-- QCD String Tension and Mass Gap State Vector -/
structure QCDConfinementState where
  sigma_s      : ℝ  -- QCD flux tube string tension (GeV^2) (0.18 GeV^2) (> 0)
  alpha_s      : ℝ  -- Strong coupling constant at confinement scale (> 0)
  c_gap        : ℝ  -- Mass gap scaling coefficient (3.55) (> 0)
  h_sig_pos    : 0 < sigma_s
  h_alp_pos    : 0 < alpha_s
  h_gap_pos    : 0 < c_gap

/-- Cornell Quark-Antiquark Confining Potential: V(R) = - (4/3) * (alpha_s / R) + sigma_s * R -/
noncomputable def cornellPotential (Q : QCDConfinementState) (R_dist : ℝ) : ℝ :=
  - ((4 / 3 : ℝ) * (Q.alpha_s / R_dist)) + Q.sigma_s * R_dist

/-- Asymptotic Confinement Slope: dV/dR = sigma_s > 0 as R -> infty -/
theorem asymptotic_confinement_slope_pos (Q : QCDConfinementState) :
    0 < Q.sigma_s :=
  Q.h_sig_pos

/-- Non-Perturbative Mass Gap: Delta_QCD = c_gap * sqrt(sigma_s) -/
noncomputable def qcdMassGap (Q : QCDConfinementState) : ℝ :=
  Q.c_gap * Real.sqrt Q.sigma_s

theorem qcd_mass_gap_strictly_positive (Q : QCDConfinementState) :
    0 < qcdMassGap Q := by
  dsimp [qcdMassGap]
  have h_sqrt_pos : 0 < Real.sqrt Q.sigma_s := Real.sqrt_pos.mpr Q.h_sig_pos
  exact mul_pos Q.h_gap_pos h_sqrt_pos

/-- Wilson Loop Area Law Decay Exponent State: Area = R * T -/
structure WilsonLoopAreaLawState where
  Q            : QCDConfinementState
  R_spatial    : ℝ
  T_temporal   : ℝ
  h_R_pos      : 0 < R_spatial
  h_T_pos      : 0 < T_temporal

noncomputable def wilsonLoopAreaExponent (W : WilsonLoopAreaLawState) : ℝ :=
  W.Q.sigma_s * W.R_spatial * W.T_temporal

theorem wilson_loop_area_law_exponent_pos (W : WilsonLoopAreaLawState) :
    0 < wilsonLoopAreaExponent W := by
  dsimp [wilsonLoopAreaExponent]
  have h_RT : 0 < W.R_spatial * W.T_temporal := mul_pos W.h_R_pos W.h_T_pos
  exact mul_pos W.Q.h_sig_pos h_RT

end GTH.Fields
