/-
  Module: GTH.Astro.SpinVorticityQuadrupole
  Description: Spin-Vorticity Lense-Thirring Coupling, Quadrupole Gravitational Radiation, and Angular Momentum Exchange.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Astro

/-- Compact Remnant Spin State with Angular Momentum J and Gravitational Mass M -/
structure RemnantSpinState where
  M_kg         : ℝ  -- Remnant mass (> 0)
  J_spin       : ℝ  -- Angular momentum magnitude (> 0)
  G_newton     : ℝ  -- 4D gravitational coupling (> 0)
  c_SI         : ℝ  -- Speed of light (> 0)
  radius_r     : ℝ  -- Radius r (> 0)
  h_M_pos      : 0 < M_kg
  h_J_pos      : 0 < J_spin
  h_G_pos      : 0 < G_newton
  h_c_pos      : 0 < c_SI
  h_r_pos      : 0 < radius_r

/-- Lense-Thirring Vorticity Magnitude: Omega_LT = (G * J) / (c^2 * r^3) -/
noncomputable def lenseThirringVorticity (S : RemnantSpinState) : ℝ :=
  (S.G_newton * S.J_spin) / ((S.c_SI ^ 2) * (S.radius_r ^ 3))

theorem lenseThirringVorticity_pos (S : RemnantSpinState) :
    0 < lenseThirringVorticity S := by
  dsimp [lenseThirringVorticity]
  have h_num : 0 < S.G_newton * S.J_spin := mul_pos S.h_G_pos S.h_J_pos
  have h_c2 : 0 < S.c_SI ^ 2 := sq_pos_of_ne_zero (ne_of_gt S.h_c_pos)
  have h_r3 : 0 < S.radius_r ^ 3 := pow_pos S.h_r_pos 3
  have h_denom : 0 < (S.c_SI ^ 2) * (S.radius_r ^ 3) := mul_pos h_c2 h_r3
  exact div_pos h_num h_denom

/-- Quadrupole Gravitational Wave Radiation Power: P_quad = (G / (5 * c^5)) * I_triple_sq -/
structure QuadrupoleRadiationState where
  S           : RemnantSpinState
  I_triple_sq : ℝ  -- Quadrupole moment 3rd time derivative squared d^3 I_ij / dt^3 ^ 2 (> 0)
  h_I3_pos    : 0 < I_triple_sq

noncomputable def quadrupoleRadiationPower (Q : QuadrupoleRadiationState) : ℝ :=
  (Q.S.G_newton / (5 * (Q.S.c_SI ^ 5))) * Q.I_triple_sq

theorem quadrupoleRadiationPower_pos (Q : QuadrupoleRadiationState) :
    0 < quadrupoleRadiationPower Q := by
  dsimp [quadrupoleRadiationPower]
  have h_c5 : 0 < Q.S.c_SI ^ 5 := pow_pos Q.S.h_c_pos 5
  have h_denom : 0 < 5 * (Q.S.c_SI ^ 5) := mul_pos (by norm_num) h_c5
  have h_factor : 0 < Q.S.G_newton / (5 * (Q.S.c_SI ^ 5)) := div_pos Q.S.h_G_pos h_denom
  exact mul_pos h_factor Q.h_I3_pos

end GTH.Astro
