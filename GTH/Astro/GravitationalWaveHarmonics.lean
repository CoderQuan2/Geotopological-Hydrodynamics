/-
  Module: GTH.Astro.GravitationalWaveHarmonics
  Description: Gravitational Wave Higher Harmonic Resonances, Viscoelastic Power Decay, and Comb Convergence.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Astro

/-- Gravitational Wave Harmonic State with Fundamental Frequency f_res -/
structure GWHarmonicState where
  f_res_hz    : ℝ  -- Fundamental cavity resonance frequency (> 0)
  tau_0       : ℝ  -- Viscoelastic relaxation time (> 0)
  chi_visc    : ℝ  -- Boundary damping coefficient (> 0)
  h_f_pos     : 0 < f_res_hz
  h_tau_pos   : 0 < tau_0
  h_chi_pos   : 0 < chi_visc

/-- n-th Harmonic Resonance Frequency: f_n = n * f_res -/
def harmonicFrequency (H : GWHarmonicState) (n : ℕ) : ℝ :=
  (n : ℝ) * H.f_res_hz

theorem harmonicFrequency_pos (H : GWHarmonicState) (n : ℕ) (hn : 0 < n) :
    0 < harmonicFrequency H n := by
  dsimp [harmonicFrequency]
  have hn_pos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  exact mul_pos hn_pos H.h_f_pos

/-- Harmonic Frequency Strict Monotonicity: f_n < f_{n+1} -/
theorem harmonicFrequency_strictMono (H : GWHarmonicState) (n : ℕ) :
    harmonicFrequency H n < harmonicFrequency H (n + 1) := by
  dsimp [harmonicFrequency]
  have h_lt : (n : ℝ) < ((n + 1 : ℕ) : ℝ) := by
    push_cast
    linarith
  exact mul_lt_mul_of_pos_right h_lt H.h_f_pos

/-- Boundary Attenuation Factor R_n(omega_n) = 1 / sqrt(1 + (2*pi*f_n * tau_0 * chi)^2) -/
noncomputable def harmonicReflectivity (H : GWHarmonicState) (n : ℕ) : ℝ :=
  1 / Real.sqrt (1 + (2 * Real.pi * (harmonicFrequency H n) * H.tau_0 * H.chi_visc) ^ 2)

theorem harmonicReflectivity_pos (H : GWHarmonicState) (n : ℕ) :
    0 < harmonicReflectivity H n := by
  dsimp [harmonicReflectivity]
  have h_inner : 0 < 1 + (2 * Real.pi * (harmonicFrequency H n) * H.tau_0 * H.chi_visc) ^ 2 := by
    have h_sq := sq_nonneg (2 * Real.pi * (harmonicFrequency H n) * H.tau_0 * H.chi_visc)
    linarith
  have h_sqrt : 0 < Real.sqrt (1 + (2 * Real.pi * (harmonicFrequency H n) * H.tau_0 * H.chi_visc) ^ 2) := Real.sqrt_pos.mpr h_inner
  exact div_pos (by norm_num) h_sqrt

end GTH.Astro
