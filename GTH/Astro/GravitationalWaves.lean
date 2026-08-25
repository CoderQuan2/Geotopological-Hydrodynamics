import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

structure CompactHorizonState where
  mass_kg          : ℝ
  schwarzschild_r  : ℝ
  epsilon_sub      : ℝ
  c_speed          : ℝ
  c_sound_sub      : ℝ
  h_mass_pos       : 0 < mass_kg
  h_rs_pos         : 0 < schwarzschild_r
  h_eps_pos        : 0 < epsilon_sub
  h_eps_lt_one     : epsilon_sub < 1
  h_c_pos          : 0 < c_speed
  h_cs_pos         : 0 < c_sound_sub

noncomputable def echoTimeDelay (H : CompactHorizonState) (log_inv_eps : ℝ) (h_log : 0 < log_inv_eps) : ℝ :=
  (2 * H.schwarzschild_r / H.c_speed) * log_inv_eps + (2 * H.schwarzschild_r / H.c_sound_sub)

theorem echoTimeDelay_pos (H : CompactHorizonState) (log_inv_eps : ℝ) (h_log : 0 < log_inv_eps) :
    0 < echoTimeDelay H log_inv_eps h_log := by
  dsimp [echoTimeDelay]
  have h1 : 0 < (2 * H.schwarzschild_r / H.c_speed) * log_inv_eps := by
    apply mul_pos
    · exact div_pos (mul_pos (by norm_num) H.h_rs_pos) H.h_c_pos
    · exact h_log
  have h2 : 0 < (2 * H.schwarzschild_r / H.c_sound_sub) := by
    exact div_pos (mul_pos (by norm_num) H.h_rs_pos) H.h_cs_pos
  exact add_pos h1 h2

end GTH.Astro
