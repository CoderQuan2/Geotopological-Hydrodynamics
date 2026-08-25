/-
  Module: GTH.Quantum.NeutrinoOscillationGeometry
  Description: Topological PMNS Flavor Mixing, Mass-Squared Splittings, and Normal Hierarchy Invariants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Quantum

/-- Neutrino Mass Hierarchy State with Mass Eigenvalues m1, m2, m3 in eV -/
structure NeutrinoMassState where
  m1_eV        : ℝ  -- Lightest neutrino mass (> 0)
  m2_eV        : ℝ  -- Second mass eigenvalue (> 0)
  m3_eV        : ℝ  -- Third mass eigenvalue (> 0)
  h_m1_pos     : 0 < m1_eV
  h_m12_order  : m1_eV < m2_eV
  h_m23_order  : m2_eV < m3_eV

/-- Solar Mass-Squared Splitting: Delta m_21^2 = m_2^2 - m_1^2 -/
noncomputable def deltaM21Sq (N : NeutrinoMassState) : ℝ :=
  N.m2_eV ^ 2 - N.m1_eV ^ 2

theorem deltaM21Sq_pos (N : NeutrinoMassState) :
    0 < deltaM21Sq N := by
  dsimp [deltaM21Sq]
  have h1 : 0 ≤ N.m1_eV := le_of_lt N.h_m1_pos
  have h2 : 0 ≤ N.m2_eV := le_of_lt (lt_trans N.h_m1_pos N.h_m12_order)
  have h_sq_lt : N.m1_eV ^ 2 < N.m2_eV ^ 2 := by
    nlinarith [N.h_m12_order]
  exact sub_pos.mpr h_sq_lt

/-- Atmospheric Mass-Squared Splitting: Delta m_31^2 = m_3^2 - m_1^2 -/
noncomputable def deltaM31Sq (N : NeutrinoMassState) : ℝ :=
  N.m3_eV ^ 2 - N.m1_eV ^ 2

theorem deltaM31Sq_pos (N : NeutrinoMassState) :
    0 < deltaM31Sq N := by
  dsimp [deltaM31Sq]
  have h_m13 : N.m1_eV < N.m3_eV := lt_trans N.h_m12_order N.h_m23_order
  have h1 : 0 ≤ N.m1_eV := le_of_lt N.h_m1_pos
  have h2 : 0 ≤ N.m3_eV := le_of_lt (lt_trans N.h_m1_pos h_m13)
  have h_sq_lt : N.m1_eV ^ 2 < N.m3_eV ^ 2 := by
    nlinarith [h_m13]
  exact sub_pos.mpr h_sq_lt

/-- Normal Hierarchy Ordering Theorem: Delta m_21^2 < Delta m_31^2 -/
theorem normal_hierarchy_ordering (N : NeutrinoMassState) :
    deltaM21Sq N < deltaM31Sq N := by
  dsimp [deltaM21Sq, deltaM31Sq]
  have h2 : 0 ≤ N.m2_eV := le_of_lt (lt_trans N.h_m1_pos N.h_m12_order)
  have h3 : 0 ≤ N.m3_eV := le_of_lt (lt_trans (lt_trans N.h_m1_pos N.h_m12_order) N.h_m23_order)
  have h_sq : N.m2_eV ^ 2 < N.m3_eV ^ 2 := by
    nlinarith [N.h_m23_order]
  linarith

end GTH.Quantum
