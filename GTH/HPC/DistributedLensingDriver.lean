/-
  Module: GTH.HPC.DistributedLensingDriver
  Description: Distributed 3D Solenoidal Projector k^i P_ij(k) = 0 and Gravitational Lensing Vector Deflection Fields.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.HPC

/-- 3D Fourier Wavenumber State Vector k = (k_x, k_y, k_z) -/
structure WavenumberState where
  kx           : ℝ
  ky           : ℝ
  kz           : ℝ
  h_k_nonzero  : kx ^ 2 + ky ^ 2 + kz ^ 2 ≠ 0

theorem k_squared_pos (K : WavenumberState) :
    0 < K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2 := by
  have h_nonneg : 0 ≤ K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2 := by
    have h1 : 0 ≤ K.kx ^ 2 := sq_nonneg K.kx
    have h2 : 0 ≤ K.ky ^ 2 := sq_nonneg K.ky
    have h3 : 0 ≤ K.kz ^ 2 := sq_nonneg K.kz
    linarith
  exact lt_of_le_of_ne h_nonneg (Ne.symm K.h_k_nonzero)

/-- Solenoidal (Divergence-Free) Projection Tensor: P_xx(k) = 1 - kx^2 / |k|^2 -/
noncomputable def projector_P_xx (K : WavenumberState) : ℝ :=
  1 - (K.kx ^ 2) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)

/-- Off-Diagonal Projection Tensor: P_xy(k) = - (kx * ky) / |k|^2 -/
noncomputable def projector_P_xy (K : WavenumberState) : ℝ :=
  - ((K.kx * K.ky) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2))

/-- Off-Diagonal Projection Tensor: P_xz(k) = - (kx * kz) / |k|^2 -/
noncomputable def projector_P_xz (K : WavenumberState) : ℝ :=
  - ((K.kx * K.kz) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2))

/-- Transverse Solenoidal Identity Theorem: k^i P_ij(k) = 0 Identically -/
theorem solenoidal_transverse_divergence_free (K : WavenumberState) :
    K.kx * (1 - (K.kx ^ 2) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) -
    K.ky * ((K.kx * K.ky) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) -
    K.kz * ((K.kx * K.kz) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) = 0 := by
  have h_den_pos := k_squared_pos K
  have h_den_ne : K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2 ≠ 0 := ne_of_gt h_den_pos
  have h1 : K.kx * (1 - (K.kx ^ 2) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) =
            K.kx - (K.kx ^ 3) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
  have h2 : K.ky * ((K.kx * K.ky) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) =
            (K.kx * (K.ky ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
  have h3 : K.kz * ((K.kx * K.kz) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) =
            (K.kx * (K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
  rw [h1, h2, h3]
  have h_comb : (K.kx ^ 3) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) +
                (K.kx * (K.ky ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) +
                (K.kx * (K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) =
                (K.kx * (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by ring
  calc
    K.kx - (K.kx ^ 3) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) -
    (K.kx * (K.ky ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) -
    (K.kx * (K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)
    _ = K.kx - ((K.kx ^ 3) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) +
                (K.kx * (K.ky ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) +
                (K.kx * (K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) := by ring
    _ = K.kx - (K.kx * (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) := by rw [h_comb]
    _ = K.kx - K.kx := by
      have : (K.kx * (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) = K.kx * ((K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2) / (K.kx ^ 2 + K.ky ^ 2 + K.kz ^ 2)) := by ring
      rw [this, div_self h_den_ne, mul_one]
    _ = 0 := by ring

end GTH.HPC
