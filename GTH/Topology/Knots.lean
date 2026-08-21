import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Basic

namespace GTH.Topology

structure FramedVortexRibbon where
  Twist  : ℝ
  Writhe : ℝ
  Link   : ℤ

axiom calugareanu_white_fuller (K : FramedVortexRibbon) :
    K.Twist + K.Writhe = (K.Link : ℝ)

structure QuantumVortex where
  quantum_number : ℤ
  hbar           : ℝ
  m_condensate   : ℝ
  h_hbar_pos     : 0 < hbar
  h_m_pos        : 0 < m_condensate

noncomputable def QuantumVortex.circulationQuantum (V : QuantumVortex) : ℝ :=
  (2 * Real.pi * V.hbar) / V.m_condensate

theorem QuantumVortex.circulationQuantum_pos (V : QuantumVortex) :
    0 < V.circulationQuantum := by
  dsimp [QuantumVortex.circulationQuantum]
  have h_pi_pos : 0 < Real.pi := Real.pi_pos
  have h_num : 0 < 2 * Real.pi * V.hbar := mul_pos (mul_pos (by norm_num) h_pi_pos) V.h_hbar_pos
  exact div_pos h_num V.h_m_pos

end GTH.Topology
