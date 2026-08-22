/-
  Module: GTH.HPC.DistributedLensingDriver
  Description: Momentum-Space Solenoidal Projection Tensor, Fourier Incompressibility, and Idempotent Invariants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.HPC

/-- Momentum Vector k in 3D Fourier Space with Non-Zero Magnitude -/
structure MomentumVector3D where
  kx : ℝ
  ky : ℝ
  kz : ℝ
  h_k_nonzero : kx ^ 2 + ky ^ 2 + kz ^ 2 ≠ 0

noncomputable def kMagnitudeSq (K : MomentumVector3D) : ℝ :=
  K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2

theorem kMagnitudeSq_pos (K : MomentumVector3D) :
    0 < kMagnitudeSq K := by
  dsimp [kMagnitudeSq]
  have h_sum_nonneg : 0 ≤ K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2 := by
    have h1 : 0 ≤ K.kx ^ 2 := sq_nonneg K.kx
    have h2 : 0 ≤ K.ky ^ 2 := sq_nonneg K.ky
    have h3 : 0 ≤ K.kz ^ 2 := sq_nonneg K.kz
    linarith
  exact lt_of_le_of_ne h_sum_nonneg (Ne.symm K.h_k_nonzero)

/-- Solenoidal Projector Component P_xx(k) = 1 - (kx^2 / |k|^2) -/
noncomputable def projectorPxx (K : MomentumVector3D) : ℝ :=
  1 - (K.kx ^ 2 / kMagnitudeSq K)

/-- Solenoidal Projector Component P_xy(k) = - (kx * ky / |k|^2) -/
noncomputable def projectorPxy (K : MomentumVector3D) : ℝ :=
  - (K.kx * K.ky / kMagnitudeSq K)

/-- Theorem: Transverse Divergence-Free Orthogonality: k_x * P_xx + k_y * P_yx + k_z * P_zx = 0 -/
theorem solenoidal_momentum_orthogonality (K : MomentumVector3D) :
    K.kx * (1 - K.kx ^ 2 / kMagnitudeSq K) +
    K.ky * (- (K.kx * K.ky / kMagnitudeSq K)) +
    K.kz * (- (K.kx * K.kz / kMagnitudeSq K)) = 0 := by
  have h_k2_ne : kMagnitudeSq K ≠ 0 := ne_of_gt (kMagnitudeSq_pos K)
  dsimp [kMagnitudeSq] at *
  calc
    K.kx * (1 - K.kx ^ 2 / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) +
    K.ky * (- (K.kx * K.ky / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2))) +
    K.kz * (- (K.kx * K.kz / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)))
    _ = K.kx - (K.kx ^ 3 + K.kx * K.ky ^ 2 + K.kx * K.kz ^ 2) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
    _ = K.kx - (K.kx * (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
    _ = K.kx - K.kx := by rw [mul_div_cancel_right₀ K.kx h_k2_ne]
    _ = 0 := by ring

end GTH.HPC
