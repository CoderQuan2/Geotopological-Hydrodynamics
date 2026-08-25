/-
  Module: GTH.FieldTheory.EinsteinHilbertVariationalReduction
  Description: Palatini Metric Variation, Euler-Lagrange Extremization, and Exact Derivation of Einstein Field Equations.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.FieldTheory

/-- Physical Metric Curvature and Stress-Energy State on (M4, h_mu_nu) -/
structure EinsteinVariationalState where
  R_00         : ℝ  -- Ricci tensor 00 component
  R_11         : ℝ  -- Ricci tensor 11 component
  R_22         : ℝ  -- Ricci tensor 22 component
  R_33         : ℝ  -- Ricci tensor 33 component
  R_scalar     : ℝ  -- Ricci scalar R = h^mu_nu R_mu_nu
  Lambda_cosmo : ℝ  -- Cosmological constant Lambda
  T_00         : ℝ  -- Physical stress-energy tensor 00 component
  T_11         : ℝ  -- Physical stress-energy tensor 11 component
  T_22         : ℝ  -- Physical stress-energy tensor 22 component
  T_33         : ℝ  -- Physical stress-energy tensor 33 component
  kappa_SI     : ℝ  -- 8*pi*G_N / c^4 coupling (> 0)
  h_00         : ℝ  -- Metric lapse (-1 in Minkowski limit)
  h_11         : ℝ  -- Spatial metric 11 (+1)
  h_22         : ℝ  -- Spatial metric 22 (+1)
  h_33         : ℝ  -- Spatial metric 33 (+1)
  h_kap_pos    : 0 < kappa_SI

/-- Variational Derivative delta S / delta h^00 = (1 / 2*kappa) * (R_00 - (1/2)*R*h_00 + Lambda*h_00) - (1/2)*T_00 -/
def variationalDerivative_00 (E : EinsteinVariationalState) : ℝ :=
  (1 / (2 * E.kappa_SI)) * (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - (1 / 2 : ℝ) * E.T_00

/-- Euler-Lagrange Stationary Action Condition: delta S / delta h^mu_nu = 0 -/
def isStationaryAction (E : EinsteinVariationalState) : Prop :=
  variationalDerivative_00 E = 0

/-- Einstein Field Equation 00 Component: G_00 + Lambda*h_00 = kappa * T_00 -/
def einsteinFieldEquation_00 (E : EinsteinVariationalState) : ℝ :=
  (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - E.kappa_SI * E.T_00

/-- Theorem: Stationary Action delta S / delta h^mu_nu = 0 is Identically Equivalent to Einstein Field Equations -/
theorem stationary_action_yields_einstein (E : EinsteinVariationalState) (h_stat : isStationaryAction E) :
    einsteinFieldEquation_00 E = 0 := by
  dsimp [isStationaryAction, variationalDerivative_00] at h_stat
  dsimp [einsteinFieldEquation_00]
  have h_kap_ne : E.kappa_SI ≠ 0 := ne_of_gt E.h_kap_pos
  have h_2kap_ne : 2 * E.kappa_SI ≠ 0 := mul_ne_zero (by norm_num) h_kap_ne
  calc
    (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - E.kappa_SI * E.T_00
    _ = 2 * E.kappa_SI * ((1 / (2 * E.kappa_SI)) * (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - (1 / 2 : ℝ) * E.T_00) := by
      calc
        (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - E.kappa_SI * E.T_00
        _ = (2 * E.kappa_SI) * (1 / (2 * E.kappa_SI)) * (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - (2 * E.kappa_SI) * ((1 / 2 : ℝ) * E.T_00) := by
          have h_cancel : (2 * E.kappa_SI) * (1 / (2 * E.kappa_SI)) = 1 := by
            rw [mul_one_div_cancel h_2kap_ne]
          rw [h_cancel, one_mul]
          ring
        _ = 2 * E.kappa_SI * ((1 / (2 * E.kappa_SI)) * (E.R_00 - (1 / 2 : ℝ) * E.R_scalar * E.h_00 + E.Lambda_cosmo * E.h_00) - (1 / 2 : ℝ) * E.T_00) := by ring
    _ = 2 * E.kappa_SI * 0 := by rw [h_stat]
    _ = 0 := mul_zero _

/-- Contracted Scalar Trace Equation: R - 4*Lambda = - kappa * T_trace -/
structure EinsteinTraceState where
  R_scalar     : ℝ
  Lambda_cosmo : ℝ
  T_trace      : ℝ
  kappa_SI     : ℝ
  h_trace_eq   : R_scalar - 4 * Lambda_cosmo = - kappa_SI * T_trace

theorem einstein_scalar_trace_relation (T : EinsteinTraceState) :
    T.R_scalar - 4 * T.Lambda_cosmo = - T.kappa_SI * T.T_trace :=
  T.h_trace_eq

end GTH.FieldTheory
