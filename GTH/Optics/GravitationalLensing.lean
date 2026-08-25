/-
  Module: GTH.Optics.GravitationalLensing
  Description: Gravitational Lensing Ray-Tracing, Convergence Profiles, and Magnification Invariants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Optics

/-- Gravitational Lensing Geometry State with Angular Diameter Distances -/
structure LensGeometryState where
  D_d  : ℝ  -- Distance to deflector (lens) (> 0)
  D_s  : ℝ  -- Distance to source (> 0)
  D_ds : ℝ  -- Distance between deflector and source (> 0)
  h_Dd : 0 < D_d
  h_Ds : 0 < D_s
  h_Dds: 0 < D_ds

/-- Critical Surface Mass Density: Sigma_crit = (c^2 / 4*pi*G) * (D_s / (D_d * D_ds)) -/
structure CriticalDensityState where
  geom     : LensGeometryState
  c_speed  : ℝ
  G_newton : ℝ
  h_c      : 0 < c_speed
  h_G      : 0 < G_newton

noncomputable def sigmaCrit (C : CriticalDensityState) : ℝ :=
  ((C.c_speed ^ 2) / (4 * Real.pi * C.G_newton)) * (C.geom.D_s / (C.geom.D_d * C.geom.D_ds))

theorem sigmaCrit_pos (C : CriticalDensityState) : 0 < sigmaCrit C := by
  dsimp [sigmaCrit]
  have h_pi : 0 < Real.pi := Real.pi_pos
  have h_num1 : 0 < C.c_speed ^ 2 := sq_pos_of_ne_zero (ne_of_gt C.h_c)
  have h_denom1 : 0 < 4 * Real.pi * C.G_newton := mul_pos (mul_pos (by norm_num) h_pi) C.h_G
  have h_frac1 : 0 < (C.c_speed ^ 2) / (4 * Real.pi * C.G_newton) := div_pos h_num1 h_denom1
  have h_denom2 : 0 < C.geom.D_d * C.geom.D_ds := mul_pos C.geom.h_Dd C.geom.h_Dds
  have h_frac2 : 0 < C.geom.D_s / (C.geom.D_d * C.geom.D_ds) := div_pos C.geom.h_Ds h_denom2
  exact mul_pos h_frac1 h_frac2

/-- GTH Convergence with Topological Vorticity: kappa = (Sigma_b + Sigma_topo) / Sigma_crit -/
structure LensingConvergenceState where
  sigma_total : ℝ  -- Sigma_baryon + Sigma_topological (> 0)
  C           : CriticalDensityState
  h_sig_pos   : 0 < sigma_total

noncomputable def convergenceKappa (L : LensingConvergenceState) : ℝ :=
  L.sigma_total / (sigmaCrit L.C)

theorem convergenceKappa_pos (L : LensingConvergenceState) : 0 < convergenceKappa L := by
  dsimp [convergenceKappa]
  exact div_pos L.h_sig_pos (sigmaCrit_pos L.C)

/-- Magnification Factor mu = 1 / ((1 - kappa)^2 - gamma^2) in Sub-Critical Regime -/
structure MagnificationState where
  kappa       : ℝ
  shear_gamma : ℝ
  h_subcrit   : (shear_gamma ^ 2) < (1 - kappa) ^ 2

noncomputable def magnification (M : MagnificationState) : ℝ :=
  1 / (((1 - M.kappa) ^ 2) - (M.shear_gamma ^ 2))

theorem magnification_pos (M : MagnificationState) : 0 < magnification M := by
  dsimp [magnification]
  have h_denom : 0 < ((1 - M.kappa) ^ 2) - (M.shear_gamma ^ 2) := sub_pos.mpr M.h_subcrit
  exact div_pos (by norm_num) h_denom

end GTH.Optics
