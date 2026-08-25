import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Topology

structure GeoKnotState where
  M_UV        : ℝ
  rho_knot    : ℝ
  filament_L  : ℝ
  c_sub       : ℝ
  hbar_val    : ℝ
  h_M_UV      : 0 < M_UV
  h_rho       : 0 < rho_knot
  h_L         : 0 < filament_L
  h_c         : 0 < c_sub
  h_hbar      : 0 < hbar_val

noncomputable def solitonMassEstimate (K : GeoKnotState) (N_top : ℤ) (hN : N_top ≠ 0) : ℝ :=
  (Real.sqrt (K.rho_knot * (K.hbar_val ^ 3) / (K.c_sub ^ 3 * (K.M_UV ^ 2)))) * (abs (N_top : ℝ))

theorem solitonMass_pos (K : GeoKnotState) (N_top : ℤ) (hN : N_top ≠ 0) :
    0 < solitonMassEstimate K N_top hN := by
  dsimp [solitonMassEstimate]
  have h_num : 0 < K.rho_knot * (K.hbar_val ^ 3) := mul_pos K.h_rho (pow_pos K.h_hbar 3)
  have h_denom : 0 < K.c_sub ^ 3 * (K.M_UV ^ 2) := mul_pos (pow_pos K.h_c 3) (pow_pos K.h_M_UV 2)
  have h_frac_pos : 0 < (K.rho_knot * (K.hbar_val ^ 3)) / (K.c_sub ^ 3 * (K.M_UV ^ 2)) := div_pos h_num h_denom
  have h_sqrt_pos : 0 < Real.sqrt ((K.rho_knot * (K.hbar_val ^ 3)) / (K.c_sub ^ 3 * (K.M_UV ^ 2))) := Real.sqrt_pos.mpr h_frac_pos
  have h_N_pos : 0 < abs (N_top : ℝ) := abs_pos.mpr (by exact_mod_cast hN)
  exact mul_pos h_sqrt_pos h_N_pos

noncomputable def chargeDepletionFactor : ℝ := (1 : ℝ) / 64

theorem chargeDepletion_pos : 0 < chargeDepletionFactor := by
  dsimp [chargeDepletionFactor]
  norm_num

end GTH.Topology
