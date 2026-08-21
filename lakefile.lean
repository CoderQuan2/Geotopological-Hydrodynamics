import Lake
open Lake DSL

package "GTH" where
  version := v!"5.0.0"
  keywords := #["physics", "formal-verification", "hydrodynamics", "topology", "gravity"]
  defaultTargets := #[`GTH]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.8.0"

@[default_target]
lean_lib «GTH» where
  roots := #[`GTH]
