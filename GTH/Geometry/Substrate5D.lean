import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Geometry

structure ConformalWeights where
  alpha : ℝ
  beta  : ℝ
  einstein_frame_condition : 2 * alpha + beta = 0

def standardWeights : ConformalWeights where
  alpha := - (1 / Real.sqrt 6)
  beta  := 2 / Real.sqrt 6
  einstein_frame_condition := by
    dsimp
    have h_sqrt6_pos : 0 < Real.sqrt 6 := Real.sqrt_pos.mpr (by norm_num)
    have h_sqrt6_ne : Real.sqrt 6 ≠ 0 := ne_of_gt h_sqrt6_pos
    calc
      2 * (- (1 / Real.sqrt 6)) + 2 / Real.sqrt 6
      _ = - (2 / Real.sqrt 6) + 2 / Real.sqrt 6 := by ring
      _ = 0 := by ring

structure FiberGeometry where
  R_tau : ℝ
  h_R   : 0 < R_tau

noncomputable def FiberGeometry.L_tau (F : FiberGeometry) : ℝ :=
  2 * Real.pi * F.R_tau

theorem FiberGeometry.L_tau_pos (F : FiberGeometry) : 0 < F.L_tau := by
  dsimp [FiberGeometry.L_tau]
  have h_pi : 0 < Real.pi := Real.pi_pos
  exact mul_pos (mul_pos (by norm_num) h_pi) F.h_R

noncomputable def G4_effective (G5 : ℝ) (F : FiberGeometry) : ℝ :=
  G5 / F.L_tau

theorem G4_effective_pos (G5 : ℝ) (hG5 : 0 < G5) (F : FiberGeometry) :
    0 < G4_effective G5 F := by
  dsimp [G4_effective]
  exact div_pos hG5 (F.L_tau_pos)

theorem G4_reconstruction (G5 : ℝ) (F : FiberGeometry) :
    (G4_effective G5 F) * F.L_tau = G5 := by
  dsimp [G4_effective]
  have h_ne : F.L_tau ≠ 0 := ne_of_gt F.L_tau_pos
  exact div_mul_cancel₀ G5 h_ne

end GTH.Geometry
