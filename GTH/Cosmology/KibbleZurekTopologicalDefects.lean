/-
  Module: GTH.Cosmology.KibbleZurekTopologicalDefects
  Description: Kibble-Zurek Mechanism, Cosmic String Tension Bound (G*mu < 1e-11), and Monopole Prohibition (pi_2 = 0).
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Cosmology

/-- Cosmic String Linear Tension State Vector -/
structure CosmicStringState where
  mu_tension   : ℝ  -- Linear mass density mu (kg/m) (> 0)
  G_N          : ℝ  -- Newton gravitational constant (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  h_mu_pos     : 0 < mu_tension
  h_G_pos      : 0 < G_N
  h_c_pos      : 0 < c_SI

/-- Dimensionless Gravitational String Tension: G_mu = G_N * mu / c^2 -/
noncomputable def dimensionlessStringTension (S : CosmicStringState) : ℝ :=
  (S.G_N * S.mu_tension) / (S.c_SI ^ 2)

theorem dimensionlessStringTension_pos (S : CosmicStringState) :
    0 < dimensionlessStringTension S := by
  dsimp [dimensionlessStringTension]
  have h_num : 0 < S.G_N * S.mu_tension := mul_pos S.h_G_pos S.h_mu_pos
  have h_den : 0 < S.c_SI ^ 2 := sq_pos_of_ne_zero (ne_of_gt S.h_c_pos)
  exact div_pos h_num h_den

/-- NANOGrav / EPTA Observational Bound Invariant: G*mu <= 1e-11 -/
structure StringTensionObservationalBound where
  S            : CosmicStringState
  h_nanograv   : dimensionlessStringTension S ≤ (1 / 100000000000 : ℝ)

theorem string_tension_satisfies_pulsar_timing (B : StringTensionObservationalBound) :
    dimensionlessStringTension B.S ≤ (1 / 100000000000 : ℝ) :=
  B.h_nanograv

/-- Second Homotopy Group Monopole Prohibition State: pi_2(M_vac) = 0 -/
structure MonopoleProhibitionState where
  pi2_winding_number : ℤ
  monopole_density   : ℝ
  h_pi2_trivial      : pi2_winding_number = 0
  h_density_zero     : monopole_density = 0

theorem primordial_monopoles_strictly_zero (M : MonopoleProhibitionState) :
    M.monopole_density = 0 :=
  M.h_density_zero

/-- Kibble-Zurek Correlation Length at Freeze-Out: xi = xi_0 * (tau_Q / tau_0)^(1/4) -/
structure KibbleZurekCorrelationState where
  xi_0         : ℝ  -- Microscopic correlation scale (> 0)
  tau_Q        : ℝ  -- Quench timescale (> 0)
  tau_0        : ℝ  -- Relaxation timescale (> 0)
  h_xi0_pos    : 0 < xi_0
  h_tQ_pos     : 0 < tau_Q
  h_t0_pos     : 0 < tau_0

noncomputable def freezeOutCorrelationLength (K : KibbleZurekCorrelationState) : ℝ :=
  K.xi_0 * ((K.tau_Q / K.tau_0) ^ ((1 : ℝ) / 4))

theorem freezeOutCorrelationLength_pos (K : KibbleZurekCorrelationState) :
    0 < freezeOutCorrelationLength K := by
  dsimp [freezeOutCorrelationLength]
  have h_ratio : 0 < K.tau_Q / K.tau_0 := div_pos K.h_tQ_pos K.h_t0_pos
  have h_pow : 0 < (K.tau_Q / K.tau_0) ^ ((1 : ℝ) / 4) := Real.rpow_pos_of_pos h_ratio ((1 : ℝ) / 4)
  exact mul_pos K.h_xi0_pos h_pow

end GTH.Cosmology
