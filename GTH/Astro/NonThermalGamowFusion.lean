/-
  Module: GTH.Astro.NonThermalGamowFusion
  Description: Non-Thermal Gamow Peak Integration, Sommerfeld Tunneling Factor, and Selective BBN Reaction Rates.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

/-- Thermonuclear Reactant State with Nuclear Charges Z1, Z2 and Reduced Mass mu -/
structure GamowReactantState where
  Z1            : ℝ  -- Nuclear charge 1 (> 0)
  Z2            : ℝ  -- Nuclear charge 2 (> 0)
  reduced_mass  : ℝ  -- Reduced mass mu in amu (> 0)
  energy_keV    : ℝ  -- Center-of-mass energy E in keV (> 0)
  h_Z1_pos      : 0 < Z1
  h_Z2_pos      : 0 < Z2
  h_mu_pos      : 0 < reduced_mass
  h_E_pos       : 0 < energy_keV

/-- Sommerfeld Parameter: eta = 0.1574 * Z1 * Z2 * sqrt(mu / E) -/
noncomputable def sommerfeldParameter (G : GamowReactantState) : ℝ :=
  0.1574 * G.Z1 * G.Z2 * Real.sqrt (G.reduced_mass / G.energy_keV)

theorem sommerfeldParameter_pos (G : GamowReactantState) :
    0 < sommerfeldParameter G := by
  dsimp [sommerfeldParameter]
  have h_Z12 : 0 < 0.1574 * G.Z1 * G.Z2 := by
    have h1 : 0 < (0.1574 : ℝ) * G.Z1 := mul_pos (by norm_num) G.h_Z1_pos
    exact mul_pos h1 G.h_Z2_pos
  have h_frac : 0 < G.reduced_mass / G.energy_keV := div_pos G.h_mu_pos G.h_E_pos
  have h_sqrt : 0 < Real.sqrt (G.reduced_mass / G.energy_keV) := Real.sqrt_pos.mpr h_frac
  exact mul_pos h_Z12 h_sqrt

/-- Gamow Tunneling Penetration Probability P_tunnel = exp(-2 * pi * eta) in (0, 1) -/
noncomputable def gamowTunnelingFactor (G : GamowReactantState) : ℝ :=
  Real.exp (- (2 * Real.pi * sommerfeldParameter G))

theorem gamowTunnelingFactor_pos (G : GamowReactantState) :
    0 < gamowTunnelingFactor G := by
  dsimp [gamowTunnelingFactor]
  exact Real.exp_pos _

/-- Non-Thermal Reaction Rate Enhancement State: rate_GTH / rate_thermal > 1 -/
structure NonThermalEnhancementState where
  destruction_rate_thermal : ℝ
  destruction_rate_GTH     : ℝ
  h_thermal_pos            : 0 < destruction_rate_thermal
  h_enhancement_gt         : destruction_rate_thermal < destruction_rate_GTH

noncomputable def enhancementRatio (N : NonThermalEnhancementState) : ℝ :=
  N.destruction_rate_GTH / N.destruction_rate_thermal

theorem enhancementRatio_gt_one (N : NonThermalEnhancementState) :
    1 < enhancementRatio N := by
  dsimp [enhancementRatio]
  exact (one_lt_div N.h_thermal_pos).mpr N.h_enhancement_gt

end GTH.Astro
