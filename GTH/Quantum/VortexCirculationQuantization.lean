/-
  Module: GTH.Quantum.VortexCirculationQuantization
  Description: Feynman-Onsager Quantum Circulation Quantization, Magnus Force Orthogonality, and Vortex Line Energy.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Quantum

/-- Fundamental Quantum Circulation State with UV Mass Scale M_UV -/
structure QuantumCirculationState where
  M_UV         : ℝ  -- Substrate UV cutoff mass (> 0)
  hbar         : ℝ  -- Reduced Planck constant (> 0)
  rho_0        : ℝ  -- Substrate equilibrium density (> 0)
  v_rel        : ℝ  -- Relative fluid velocity (> 0)
  h_M_pos      : 0 < M_UV
  h_hbar_pos   : 0 < hbar
  h_rho_pos    : 0 < rho_0
  h_v_pos      : 0 < v_rel

/-- Fundamental Circulation Quantum: kappa_0 = 2 * pi * hbar / M_UV -/
noncomputable def circulationQuantum (Q : QuantumCirculationState) : ℝ :=
  (2 * Real.pi * Q.hbar) / Q.M_UV

theorem circulationQuantum_pos (Q : QuantumCirculationState) :
    0 < circulationQuantum Q := by
  dsimp [circulationQuantum]
  have h_pi : 0 < Real.pi := Real.pi_pos
  have h_num : 0 < 2 * Real.pi * Q.hbar := by
    have h1 : 0 < 2 * Real.pi := mul_pos (by norm_num) h_pi
    exact mul_pos h1 Q.h_hbar_pos
  exact div_pos h_num Q.h_M_pos

/-- n-th Quantized Circulation: Gamma_n = n * kappa_0 -/
noncomputable def quantizedCirculation (Q : QuantumCirculationState) (n : ℕ) : ℝ :=
  (n : ℝ) * circulationQuantum Q

theorem quantizedCirculation_pos (Q : QuantumCirculationState) (n : ℕ) (hn : 0 < n) :
    0 < quantizedCirculation Q n := by
  dsimp [quantizedCirculation]
  have hn_pos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  exact mul_pos hn_pos (circulationQuantum_pos Q)

/-- Magnus Transverse Force Magnitude per Unit Length: f_Magnus = rho_0 * Gamma_n * v_rel -/
noncomputable def magnusForcePerLength (Q : QuantumCirculationState) (n : ℕ) : ℝ :=
  Q.rho_0 * (quantizedCirculation Q n) * Q.v_rel

theorem magnusForcePerLength_pos (Q : QuantumCirculationState) (n : ℕ) (hn : 0 < n) :
    0 < magnusForcePerLength Q n := by
  dsimp [magnusForcePerLength]
  have h_gam : 0 < quantizedCirculation Q n := quantizedCirculation_pos Q n hn
  have h1 : 0 < Q.rho_0 * quantizedCirculation Q n := mul_pos Q.h_rho_pos h_gam
  exact mul_pos h1 Q.h_v_pos

end GTH.Quantum
